@isTest
private class ParentRelTreeBuilderDataProvTests {
	
	private static testMethod void it_should_retrieve_the_entity() {
		Account testAcctParent = ObjectFactory.getValidEntity('Parent');
		Account testAcctChild = ObjectFactory.getValidEntity('Child');
		testAcctChild.ParentId = testAcctParent.Id;
		testAcctChild.Relationship_Change_Ignore_Validation__c = true;
		testAcctChild.Relationship_To_Parent__c = 'child';
		update testAcctChild;
		ParentRelTreeBuilderDataProv sut = new ParentRelTreeBuilderDataProv();

		Account returnResult = sut.getEntity(testAcctChild.Id);

		System.assertEquals(testAcctChild.Id, returnResult.Id);
		System.assertEquals(testAcctChild.ParentId, returnResult.ParentId);
	}

	private static testMethod void it_should_retrieve_the_children_for_the_entities() {
		Account testAcctParent1 = ObjectFactory.getValidEntity('Parent1');
		Account testAcctChild1 = ObjectFactory.getValidEntity('Child1');
		testAcctChild1.ParentId = testAcctParent1.Id;
		testAcctChild1.Relationship_Change_Ignore_Validation__c = true;
		testAcctChild1.Relationship_To_Parent__c = 'child';
		update testAcctChild1;
		Account testAcctParent2 = ObjectFactory.getValidEntity('Parent2');
		Account testAcctChild2 = ObjectFactory.getValidEntity('Child2');
		testAcctChild2.ParentId = testAcctParent2.Id;
		testAcctChild2.Relationship_Change_Ignore_Validation__c = true;
		testAcctChild2.Relationship_To_Parent__c = 'child';
		update testAcctChild2;
		Account testAcctParent3 = ObjectFactory.getValidEntity('ParentNotIncluded3');
		Account testAcctChild3 = ObjectFactory.getValidEntity('ChildNotIncluded3');
		testAcctChild3.ParentId = testAcctParent3.Id;
		testAcctChild3.Relationship_Change_Ignore_Validation__c = true;
		testAcctChild3.Relationship_To_Parent__c = 'child';
		update testAcctChild3;
		Set<Id> acctIds = new Set<Id>();
		acctIds.Add(testAcctParent1.Id);
		acctIds.Add(testAcctParent2.Id);

		ParentRelTreeBuilderDataProv sut = new ParentRelTreeBuilderDataProv();

		Map<Id, Account> returnResult = sut.getChildrenForEntities(acctIds);

		System.assertEquals(2, returnResult.size());
		System.assert(returnResult.containsKey(testAcctChild1.Id));
		System.assert(returnResult.containsKey(testAcctChild2.Id));
	}

	private static testMethod void it_should_retrieve_the_entities_that_are_top_level_for_given_owner() {
		User testUser1 = ObjectFactory.getUser('firstName', '1lastName', 'firstName1lastName@enterprisebank.com.test', true);
		User testUser2 = ObjectFactory.getUser('firstName', '2lastName', 'firstName2lastName@enterprisebank.com.test', true);
		Account testAcctParent1 = ObjectFactory.getValidEntity('Parent1');
		testAcctParent1.OwnerId = testUser1.Id;
		update testAcctParent1;
		Account testAcctChild1 = ObjectFactory.getValidEntity('Child1');
		testAcctChild1.ParentId = testAcctParent1.Id;
		testAcctChild1.Relationship_Change_Ignore_Validation__c = true;
		testAcctChild1.Relationship_To_Parent__c = 'child';
		testAcctChild1.OwnerId = testUser1.Id;
		update testAcctChild1;
		Account testAcctParent2 = ObjectFactory.getValidEntity('Parent2');
		testAcctParent2.OwnerId = testUser1.Id;
		update testAcctParent2;
		Account testAcctChild2 = ObjectFactory.getValidEntity('Child2');
		testAcctChild2.ParentId = testAcctParent2.Id;
		testAcctChild2.Relationship_Change_Ignore_Validation__c = true;
		testAcctChild2.Relationship_To_Parent__c = 'child';
		testAcctChild2.OwnerId = testUser1.Id;
		update testAcctChild2;
		Account testAcctParent3 = ObjectFactory.getValidEntity('ParentNotIncluded3');
		testAcctParent3.OwnerId = testUser2.Id;
		update testAcctParent3;
		Account testAcctChild3 = ObjectFactory.getValidEntity('ChildNotIncluded3');
		testAcctChild3.ParentId = testAcctParent3.Id;
		testAcctChild3.Relationship_Change_Ignore_Validation__c = true;
		testAcctChild3.Relationship_To_Parent__c = 'child';
		testAcctChild3.OwnerId = testUser2.Id;
		update testAcctChild3;
		Set<Id> ownerIds = new Set<Id>{testUser1.Id};
		ParentRelTreeBuilderDataProv sut = new ParentRelTreeBuilderDataProv();

		Map<Id, Account> returnResult = sut.getTopLevelAccountsForOwners(ownerIds);

		System.assertEquals(2, returnResult.size());
		System.assert(returnResult.containsKey(testAcctParent1.Id));
		System.assert(returnResult.containsKey(testAcctParent2.Id));
	}

	private static testMethod void it_should_update_the_entities() {
		Account testAcct1 = ObjectFactory.getValidEntity('test1');
		Account testAcct2 = ObjectFactory.getValidEntity('test2');
		testAcct1.BillingStreet = 'PreChange1';
		testAcct2.BillingStreet = 'PreChange2';
		List<Account> testAccts = new List<Account> {testAcct1, testAcct2};
		update testAccts;
		Account testAcct1PreChange = [SELECT Id, BillingStreet FROM Account WHERE Id =: testAcct1.Id];
		Account testAcct2PreChange = [SELECT Id, BillingStreet FROM Account WHERE Id =: testAcct2.Id];
		testAcct1.BillingStreet = 'PostChange1';
		testAcct2.BillingStreet = 'PostChange2';
		ParentRelTreeBuilderDataProv sut = new ParentRelTreeBuilderDataProv();

		sut.updateEntities(testAccts);

		Account testAcct1PostChange = [SELECT Id, BillingStreet FROM Account WHERE Id =: testAcct1.Id];
		Account testAcct2PostChange = [SELECT Id, BillingStreet FROM Account WHERE Id =: testAcct2.Id];
		System.assertEquals('PreChange1', testAcct1PreChange.BillingStreet);
		System.assertEquals('PreChange2', testAcct2PreChange.BillingStreet);
		System.assertEquals('PostChange1', testAcct1PostChange.BillingStreet);
		System.assertEquals('PostChange2', testAcct2PostChange.BillingStreet);
	}


	private static testMethod void it_should_return_expected_fields_in_SOQL_for_getEntity() {
		Account testAcct = ObjectFactory.getValidEntity('Child');
		ParentRelTreeBuilderDataProv sut = new ParentRelTreeBuilderDataProv();

		Account returnResult = sut.getEntity(testAcct.Id);
		Object wasFieldInSOQL;
		wasFieldInSOQL = returnResult.Id;
		wasFieldInSOQL = returnResult.Name;
		wasFieldInSOQL = returnResult.ParentId;
		wasFieldInSOQL = returnResult.Parent.ParentId;
		wasFieldInSOQL = returnResult.Parent.Parent.ParentId;
		wasFieldInSOQL = returnResult.Parent.Parent.Parent.ParentId;
		wasFieldInSOQL = returnResult.Parent.Parent.Parent.Parent.ParentId;
		wasFieldInSOQL = returnResult.Parent.Parent.Parent.Parent.Parent.ParentId;
		wasFieldInSOQL = returnResult.Relationship_To_Parent__c;
		wasFieldInSOQL = returnResult.OwnerId;
		wasFieldInSOQL = returnResult.Owner.Name;
		wasFieldInSOQL = returnResult.BillingCity;
		wasFieldInSOQL = returnResult.BillingState;
	}

	private static testMethod void it_should_return_expected_fields_in_SOQL_for_getChildrenForEntities() {
		Account testAcctParent1 = ObjectFactory.getValidEntity('Parent1');
		Account testAcctChild1 = ObjectFactory.getValidEntity('Child1');
		testAcctChild1.ParentId = testAcctParent1.Id;
		testAcctChild1.Relationship_Change_Ignore_Validation__c = true;
		testAcctChild1.Relationship_To_Parent__c = 'child';
		update testAcctChild1;
		Set<Id> acctIds = new Set<Id>();
		acctIds.Add(testAcctParent1.Id);

		ParentRelTreeBuilderDataProv sut = new ParentRelTreeBuilderDataProv();

		Map<Id, Account> returnResult = sut.getChildrenForEntities(acctIds);

		Object wasFieldInSOQL;
		wasFieldInSOQL = returnResult.get(testAcctChild1.Id).Id;
		wasFieldInSOQL = returnResult.get(testAcctChild1.Id).Name;
		wasFieldInSOQL = returnResult.get(testAcctChild1.Id).ParentId;
		wasFieldInSOQL = returnResult.get(testAcctChild1.Id).Relationship_To_Parent__c;
		wasFieldInSOQL = returnResult.get(testAcctChild1.Id).OwnerId;
		wasFieldInSOQL = returnResult.get(testAcctChild1.Id).Owner.Name;
		wasFieldInSOQL = returnResult.get(testAcctChild1.Id).BillingCity;
		wasFieldInSOQL = returnResult.get(testAcctChild1.Id).BillingState;
	}


	
}