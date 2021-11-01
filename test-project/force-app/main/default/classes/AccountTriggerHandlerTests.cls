@IsTest
private class AccountTriggerHandlerTests {

	private static final TriggerHandlerTester tester;
	private static final MockofIAccountTriggerHandlerDataProv mockDataProv;
	private static final Mock.ofIParentRelationshipSvc mockParentRelSvc;
	private static final AccountTriggerHandler sut;

	static {
		tester = new TriggerHandlerTester();
		tester.triggerOld = new List<Account>();
		tester.triggerNew = new List<Account>();
		mockDataProv = new MockofIAccountTriggerHandlerDataProv();
		mockParentRelSvc = new Mock.ofIParentRelationshipSvc();
		mockParentRelSvc.setup('getTopLevelParent', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(new Account());
		sut = new AccountTriggerHandler(mockDataProv, mockParentRelSvc);
	}

	@IsTest
    static void it_should_call_the_default_constructor_without_error() {
		AccountTriggerHandler sutDef = new AccountTriggerHandler();
	}

	@IsTest
    static void it_should_update_all_children_when_changes_made_to_RM_or_Parent() {
		Account preChange = new Account(Id='001f000000GsU5a', OwnerId='005000000000001', EB_UnitID__c='a0I000000000001', Primary_Relationship__c=null);
		Account postChange = new Account(Id='001f000000GsU5a', OwnerId='005000000000002', EB_UnitID__c='a0I000000000002', Primary_Relationship__c=null);
		tester.triggerOld.add(preChange);
		tester.triggerNew.add(postChange);
		Account testChild1 = new Account(Id='001f000000GsU6a', ParentId=postChange.Id, OwnerId = '005000000000001', EB_UnitID__c = 'a0I000000000001', Primary_Relationship__c=null);
		Account testChild2 = new Account(Id='001f000000GsU7a', ParentId=postChange.Id, OwnerId = '005000000000001', EB_UnitID__c = 'a0I000000000001', Primary_Relationship__c=null);
		Set<Id> testAcctSet = new Set<Id> {postChange.Id};
		List<Account> testAcctSetReturn	= new List<Account>{testChild1, testChild2};
		mockDataProv.setup('getChildrenOfAccounts', new List<Object>{testAcctSet}).returns(testAcctSetReturn);

		tester.afterTriggerUpdateSequence(sut);

		System.assertEquals('005000000000002', testChild1.OwnerId);
		System.assertEquals('005000000000002', testChild2.OwnerId);
		System.assertEquals(true, testChild1.Relationship_Change_Ignore_Validation__c);
		System.assertEquals(true, testChild2.Relationship_Change_Ignore_Validation__c);
		System.assertEquals('001f000000GsU5a', testChild1.Primary_Relationship__c);
		System.assertEquals('001f000000GsU5a', testChild2.Primary_Relationship__c);
	}

	@IsTest
    static void it_should_update_primary_relationship_field_to_null_if_entity_is_becoming_top_level() {
		Account preChange 	= new Account(Id='001f000000GsU5a', ParentId='001f000000GsU4a');
		Account postChange 	= new Account(Id='001f000000GsU5a', ParentId=null, Primary_Relationship__c='001f000000GsU4a');
		tester.triggerOld.add(preChange);
		tester.triggerNew.add(postChange);

		tester.beforeTriggerUpdateSequence(sut);

		System.assertEquals(null, postChange.Primary_Relationship__c);
	}

	@IsTest
    static void it_should_update_primary_relationship_field_to_new_parent_if_parent_is_top_level() {
		Account newParent = new Account(Id='001f000000GsU4a');
		Account preChange = new Account(Id='001f000000GsU5a', ParentId=null);
		Account postChange = new Account(Id='001f000000GsU5a', Parent=newParent, ParentId='001f000000GsU4a', Primary_Relationship__c=null);
		tester.triggerOld.add(preChange);
		tester.triggerNew.add(postChange);
		mockParentRelSvc.setup('getTopLevelParent', new List<Object>{newParent.Id}).returns(newParent);
	
		tester.beforeTriggerUpdateSequence(sut);

		System.assertEquals(newParent.Id, postChange.Primary_Relationship__c);
	}

	@IsTest
    static void it_should_update_primary_relationship_field_to_new_parents_primary_relationship_if_new_parent_is_not_top_level() {
		Account newTopLevel = new Account(Id='001f000000GsU3a');
		Account newParent = new Account(Id='001f000000GsU4a');
		Account preChange = new Account(Id='001f000000GsU5a', ParentId=null);
		Account postChange = new Account(Id='001f000000GsU5a', Parent=newParent, ParentId='001f000000GsU4a', Primary_Relationship__c=null);
		tester.triggerOld.add(preChange);
		tester.triggerNew.add(postChange);
		mockParentRelSvc.setup('getTopLevelParent', new List<Object>{newParent.Id}).returns(newTopLevel);
	
		tester.beforeTriggerUpdateSequence(sut);

		System.assertEquals(newTopLevel.Id, postChange.Primary_Relationship__c);
	}

	@IsTest
    static void it_should_return_an_error_if_attempting_to_change_parent_when_not_at_top_level_and_ignore_validation_is_false() {
		Account preChange = new Account(Id='001f000000GsU5a', ParentId='001f000000GsU3a');
		Account postChange = new Account(Id='001f000000GsU5a', ParentId='001f000000GsU4a');
		tester.triggerOld.add(preChange);
		tester.triggerNew.add(postChange);

		tester.beforeTriggerUpdateSequence(sut);

		system.assertEquals(true, wasErrorMessageFoundOnPage('parent'));
	}

	@IsTest
    static void it_should_return_an_error_if_attempting_to_change_owner_when_not_at_top_level_and_ignore_validation_is_false() {
		Account preChange = new Account(Id='001f000000GsU5a', ParentId='001f000000GsU4a', OwnerId='005000000000001');
		Account postChange = new Account(Id='001f000000GsU5a', ParentId='001f000000GsU4a', OwnerId='005000000000002');
		tester.triggerOld.add(preChange);
		tester.triggerNew.add(postChange);

		tester.beforeTriggerUpdateSequence(sut);

		system.assertEquals(true, wasErrorMessageFoundOnPage('rm'));
	}

	@IsTest
    static void it_should_not_return_an_error_if_attempting_to_change_RM_or_Parent_when_not_at_top_level_and_ignore_validation_is_true() {
		Account preChange = new Account(Id='001f000000GsU5a', ParentId='001f000000GsU3a', OwnerId='005000000000001', EB_UnitID__c='a0I000000000001');
		Account postChange = new Account(Id='001f000000GsU5a', ParentId='001f000000GsU4a', OwnerId='005000000000002', EB_UnitID__c='a0I000000000002');
		postChange.Relationship_Change_Ignore_Validation__c = true;
		tester.triggerOld.add(preChange);
		tester.triggerNew.add(postChange);

		tester.beforeTriggerUpdateSequence(sut);

		system.assertEquals(false, wasErrorMessageFoundOnPage('parent'));
		system.assertEquals(false, wasErrorMessageFoundOnPage('rm'));
		system.assertEquals(false, postChange.Relationship_Change_Ignore_Validation__c);		
	}

	@IsTest
    static void it_should_update_the_entities_relationship_manager_field_when_inserting_records() {
		Id ownerId = ObjectFactory.getFakeId(User.SObjectType, '1');
		Account preChange = new Account(Id='001f000000GsU5a', OwnerId=ownerId);
		Account postChange = new Account(Id='001f000000GsU5a', OwnerId=ownerId);
		Id teamMemberId = ObjectFactory.getFakeId(EB_Team_Member__c.SObjectType, '1');
		EB_Team_Member__c teamMember = new EB_Team_Member__c(Id=teamMemberId, User__c=ownerId);
		List<Id> ownerIds = new List<Id> {ownerId};
		List<EB_Team_Member__c> teamMembers = new List<EB_Team_Member__c>{teamMember};
		mockDataProv.setup('getTeamMembersById', new List<Object>{ownerIds}).returns(teamMembers);
		tester.triggerOld.add(preChange);
		tester.triggerNew.add(postChange);

		tester.beforeTriggerInsertSequence(sut);

		System.assertEquals(teamMemberId, preChange.Team_Relationship_Manager__c);
	}

	@IsTest
    static void it_should_update_the_entities_relationship_manager_field_when_updating_records() {
		Id ownerId = ObjectFactory.getFakeId(User.SObjectType, '1');
		Account preChange = new Account(Id='001f000000GsU5a', OwnerId=ownerId);
		Account postChange = new Account(Id='001f000000GsU5a', OwnerId=ownerId);
		Id teamMemberId = ObjectFactory.getFakeId(EB_Team_Member__c.SObjectType, '1');
		EB_Team_Member__c teamMember = new EB_Team_Member__c(Id=teamMemberId, User__c=ownerId);
		List<Id> ownerIds = new List<Id> {ownerId};
		List<EB_Team_Member__c> teamMembers = new List<EB_Team_Member__c>{teamMember};
		mockDataProv.setup('getTeamMembersById', new List<Object>{ownerIds}).returns(teamMembers);
		tester.triggerOld.add(preChange);
		tester.triggerNew.add(postChange);

		tester.beforeTriggerUpdateSequence(sut);

		System.assertEquals(teamMemberId, postChange.Team_Relationship_Manager__c);
	}

	@IsTest
	static void it_should_update_the_EB_Branch_text_field_bulkBeforeInsert() {
		Id unitId = ObjectFactory.getFakeId(EB_Unit__c.SObjectType, '1');
		Id accountId = ObjectFactory.getFakeId(Account.SObjectType, '1');
		Account givenEntity = new Account(
			Id = accountId,
			EB_Branch_text__c = null,
			EB_UnitID__c = unitId
		);
		tester.triggerOld.add(givenEntity);
		//act
		tester.beforeTriggerInsertSequence(sut);
		//assert
		System.assertEquals(unitId, givenEntity.EB_Branch_text__c);
	}

	@IsTest
	static void it_should_update_the_EB_Branch_text_field_bulkBeforeUpdate() {
		Id unitId01 = ObjectFactory.getFakeId(EB_Unit__c.SObjectType, '1');
		Id unitId02 = ObjectFactory.getFakeId(EB_Unit__c.SObjectType, '2');
		Id accountId = ObjectFactory.getFakeId(Account.SObjectType, '1');
		Account preChange = new Account(
			Id = accountId,
			EB_Branch_text__c = unitId02,
			EB_UnitID__c = unitId02
		);
		Account postChange = new Account(
			Id = accountId,
			EB_Branch_text__c = unitId02,
			EB_UnitID__c = unitId01
		);
		tester.triggerOld.add(preChange);
		tester.triggerNew.add(postChange);
		//act
		tester.beforeTriggerUpdateSequence(sut);
		//assert
		System.assertEquals(unitId01, postChange.EB_Branch_text__c);
	}

	@IsTest
	static void it_should_update_the_Record_Type_Description_field_when_bulkBeforeInsert() {
		RecordType clientRT = ObjectFactory.getRecordTypeObjByNameAndObject('Client', 'Account');
		Account entityGiven = new Account(
			Record_Type_Description__c = null,
			RecordType = clientRT
		);
		tester.triggerOld.add(entityGiven);
		//act
		tester.beforeTriggerInsertSequence(sut);
		//assert
		System.assertEquals(clientRT.Name, entityGiven.Record_Type_Description__c);
	}

	@IsTest
	static void it_should_update_the_Record_Type_Description_field_when_bulkBeforeUpdate() {
		RecordType prospectRT = ObjectFactory.getRecordTypeObjByNameAndObject('Prospect', 'Account');
		RecordType clientRT = ObjectFactory.getRecordTypeObjByNameAndObject('Client', 'Account');
		Account preChange = new Account(
			Record_Type_Description__c = 'Prospect',
			RecordType = prospectRT
		);
		Account postChange = new Account(
			Record_Type_Description__c = 'Prospect',
			RecordType = clientRT
		);
		tester.triggerOld.add(preChange);
		tester.triggerNew.add(postChange);
		//act
		tester.beforeTriggerUpdateSequence(sut);
		//assert
		System.assertEquals(clientRT.Name, postChange.Record_Type_Description__c);
	}

	@IsTest
	static void it_should_set_the_account_type_field_to_individual_when_bulkBeforeInsert() { //
		Account entity = new Account(Sub_Type__c = 'Personal');
		tester.triggerOld.add(entity);
		//act
		tester.beforeTriggerInsertSequence(sut);
		//assert
		System.assertEquals('Individual', entity.Type);
	}

	@IsTest
	static void it_should_set_the_account_type_field_to_Corporation_when_bulkBeforeInsert() {
		Account entity = new Account(Sub_Type__c = 'asdf');
		tester.triggerOld.add(entity);
		//act
		tester.beforeTriggerInsertSequence(sut);
		//assert
		System.assertEquals('Corporation', entity.Type);
	}

	@IsTest
	static void it_should_set_the_account_type_field_to_Corporation_when_type_is_null_bulkBeforeInsert() {
		Account entity = new Account(Sub_Type__c = null);
		tester.triggerOld.add(entity);
		//act
		tester.beforeTriggerInsertSequence(sut);
		//assert
		System.assertEquals('Corporation', entity.Type);
	}

	@IsTest
	static void it_should_set_the_account_type_field_to_individual_when_bulkBeforeUpdate() { //
		Account preChange = new Account(Sub_Type__c = 'asdf');
		Account postChange = new Account(Sub_Type__c = 'Personal');
		tester.triggerOld.add(preChange);
		tester.triggerNew.add(postChange);
		//act
		tester.beforeTriggerUpdateSequence(sut);
		//assert
		System.assertEquals('Individual', postChange.Type);
	}

	@IsTest
	static void it_should_set_the_account_type_field_to_Corporation_when_bulkBeforeUpdate() {
		Account preChange = new Account(Sub_Type__c = 'Personal');
		Account postChange = new Account(Sub_Type__c = 'asdf');
		tester.triggerOld.add(preChange);
		tester.triggerNew.add(postChange);
		//act
		tester.beforeTriggerUpdateSequence(sut);
		//assert
		System.assertEquals('Corporation', postChange.Type);
	}

	@IsTest
	static void it_should_update_the_billing_country_field_if_it_is_empty_or_null_when_bulkBeforeInsert(){
		Account testAccount = new Account(BillingCountry = null);
		tester.triggerOld.add(testAccount);

		tester.beforeTriggerInsertSequence(sut);

		System.assertEquals('US', testAccount.BillingCountry);
	}

	@IsTest
	static void it_should_not_update_the_billing_country_field_if_it_contains_a_value_when_bulkBeforeInsert(){
		Account testAccount = new Account(BillingCountry = 'some country');
		tester.triggerOld.add(testAccount);

		tester.beforeTriggerInsertSequence(sut);

		System.assertEquals('some country', testAccount.BillingCountry);
	}

	@IsTest
	static void it_should_update_the_shipping_country_field_if_it_is_empty_or_null_when_bulkBeforeInsert(){
		Account testAccount = new Account(ShippingCountry = null);
		tester.triggerOld.add(testAccount);

		tester.beforeTriggerInsertSequence(sut);

		System.assertEquals('US', testAccount.ShippingCountry);
	}

	@IsTest
	static void it_should_not_update_the_Shipping_country_field_if_it_contains_a_value_when_bulkBeforeInsert(){
		Account testAccount = new Account(ShippingCountry = 'some country');
		tester.triggerOld.add(testAccount);

		tester.beforeTriggerInsertSequence(sut);

		System.assertEquals('some country', testAccount.ShippingCountry);
	}

	@IsTest
	static void it_should_only_update_the_empty_country_field_when_one_has_a_value_and_one_does_not_during_bulkBeforeInsert() {
		Account testAccount = new Account(
			BillingCountry = null,
			ShippingCountry = 'some country'
		);
		tester.triggerOld.add(testAccount);

		tester.beforeTriggerInsertSequence(sut);

		System.assertEquals('US', testAccount.BillingCountry);
		System.assertEquals('some country', testAccount.ShippingCountry);
	}

	@IsTest
	static void it_should_set_ssn_tin_has_field_value_to_false_when_encrypted_ssn_field_is_empty_bulkBeforeUpdate() {
		Account preChange = new Account(SSNTIN_Encrypted__c = null);
		Account postChange = new Account(SSNTIN_Encrypted__c = null);
		tester.triggerOld.add(preChange);
		tester.triggerNew.add(postChange);

		tester.beforeTriggerUpdateSequence(sut);

		System.assertEquals(false, postChange.SSN_TIN_Has_Value__c);
	}

	@IsTest
	static void it_should_set_ssn_tin_has_field_value_to_true_when_encrypted_ssn_field_is_not_empty_bulkBeforeUpdate() {
		Account preChange = new Account(SSNTIN_Encrypted__c = null);
		Account postChange = new Account(SSNTIN_Encrypted__c = 'something');
		tester.triggerOld.add(preChange);
		tester.triggerNew.add(postChange);

		tester.beforeTriggerUpdateSequence(sut);

		System.assertEquals(true, postChange.SSN_TIN_Has_Value__c);
	}
	///////////////////////////////////////////////////////////////////////////////////////
	private static Boolean wasErrorMessageFoundOnPage(String msg) {
		Boolean foundMessage = false;
		for (ApexPages.Message message : ApexPages.getMessages()) {
			if (message.getDetail().toLowerCase().contains(msg.toLowerCase())) {
				foundMessage = true;
				break;
			}
		}
		return foundMessage;
	}

	private class MockofIAccountTriggerHandlerDataProv extends ApexMoq implements AccountTriggerHandler.IAccountTriggerHandlerDataProv {
		public List<Account> getChildrenOfAccounts(Set<Id> accts) {
			return (List<Account>)handleMethodInvocation('getChildrenOfAccounts', new List<Object>{accts});
		}
		public void updateAccounts(List<Account> accts) {
			handleMethodInvocation('updateAccounts', new List<Object>{accts});
		}
		public List<Eb_Team_Member__c> getTeamMembersByOwnerID(Set<Id> ownerIds) {
			return (List<Eb_Team_Member__c>)handleMethodInvocation('getTeamMembersByOwnerID', new List<Object>{ownerIds});
		}
		public List<EB_Loan_App_Entity_Relationship__c> getLoanAppRelatedEntities(Set<Id> acctIds, Set<String> fieldsToRetrieve) {
			return (List<EB_Loan_App_Entity_Relationship__c>)handleMethodInvocation('getLoanAppRelatedEntities', new List<Object>{acctIds, fieldsToRetrieve});
		}
		public void updateLoanAppRelatedEntities(List<EB_Loan_App_Entity_Relationship__c> relEntities) {
			handleMethodInvocation('updateLoanAppRelatedEntities', new List<Object>{relEntities});
		}
		public Set<EB_Loan_App_Stage_Validation_Rule__c> getLoanAppStageValidationRulesForObject(String objectName) {
			return (Set<EB_Loan_App_Stage_Validation_Rule__c>)handleMethodInvocation('getLoanAppStageValidationRulesForObject', new List<Object>{objectName});
		}
		public List<EB_Team_Member__c> getTeamMembersById(List<Id> userIds) {
			return (List<EB_Team_Member__c>)handleMethodInvocation('getTeamMembersById', new List<Object>{userIds});
		}
	}
}