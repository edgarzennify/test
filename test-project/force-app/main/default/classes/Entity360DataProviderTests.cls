@IsTest
private class Entity360DataProviderTests {

	private static final Entity360DataProvider sut;
	private static final MockofIEntity360DmBuilder m_mockDmBuilder;
	private static final MockofIParentRelTreeBuilder m_mockParentRelTreeBuilder;

	static {
		m_mockDmBuilder = new MockofIEntity360DmBuilder();
		m_mockParentRelTreeBuilder = new MockofIParentRelTreeBuilder();
		sut = new Entity360DataProvider(m_mockDmBuilder, m_mockParentRelTreeBuilder);
	}

	@IsTest
    static void it_should_call_the_parent_rel_tree_builder_to_get_a_relationship_tree() {
		String entityId = ObjectFactory.getFakeId(Account.SObjectType, '1');

		sut.getAllRelationshipEntitiesBySingleEntityId(entityId);

		m_mockParentRelTreeBuilder.verify('getRelationshipTreeForEntity', new List<object> { (Id)entityId, false, null }, Times.Once);
	}

	@IsTest
    static void it_should_call_the_parent_rel_tree_builder_to_get_a_relationship_tree_list_for_display() {
		String entityId = ObjectFactory.getFakeId(Account.SObjectType, '1');
		List<Map<Id, Account>> tree = new List<Map<Id, Account>>();

		m_mockParentRelTreeBuilder.setup('getRelationshipTreeForEntity', new List<object> { (Id)entityId, false, null }).returns(tree);

		sut.getAllRelationshipEntitiesBySingleEntityId(entityId);

		m_mockParentRelTreeBuilder.verify('getRelationshipTreeListForDisplay', new List<object> { tree, (Id)entityId }, Times.Once);
	}

	@IsTest
    static void it_should_get_the_correct_dm_entities() {
		List<Map<Id, Account>> tree = new List<Map<Id, Account>>();

		EB_Team_Member__c newMember = ObjectFactory.getTeamMember('Test Member');
		Id newClientRecordTypeId = ObjectFactory.getRecordTypeIdByNameAndObject('Client', 'Account');		
		Account entity1 = ObjectFactory.getEntity('entity1', newClientRecordTypeId, newMember);

		List<EB_Account_Relationship__c> relatedAccounts = new List<Eb_Account_Relationship__c>();
		Integer acctLevelInTree = 2;
		Boolean currentNode = true;
		ParentRelationships.RelatedEntity relEntity1 = new ParentRelationships.RelatedEntity(entity1, relatedAccounts, acctLevelInTree, currentNode);
		List<ParentRelationships.RelatedEntity> relEntities = new List<ParentRelationships.RelatedEntity>{relEntity1};

		m_mockParentRelTreeBuilder.setup('getRelationshipTreeForEntity', new List<object> { entity1.Id, false, null }).returns(tree);
		m_mockParentRelTreeBuilder.setup('getRelationshipTreeListForDisplay', new List<object> { tree, entity1.Id }).returns(relEntities);
		DmEntity entityDm1 = new DmEntity();
		entityDm1.id = String.ValueOf(entity1.Id);
		List<DmEntity> entityDms = new List<DmEntity>{entityDm1};
		m_mockDmBuilder.setup('buildDmEntities', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(entityDms);

		List<DmEntity> result = sut.getAllRelationshipEntitiesBySingleEntityId(String.ValueOf(entity1.Id));

		List<Object> arguments = (List<Object>)m_mockDmBuilder.getArgumentsFromCall('buildDmEntities');
		List<Account> passedAccounts = (List<Account>)arguments[0];

		System.assertEquals(1, passedAccounts.size());
		System.assertEquals(entity1.Id, passedAccounts[0].Id);
	}

	@IsTest
    static void it_should_get_dm_entities_given_a_list_of_entityId_strings() {
		Eb_Unit__c newUnit = ObjectFactory.getUnit( 'Test Unit', 20001);
		EB_Team_Member__c newMember = ObjectFactory.getTeamMember('Test Member');
		Id newClientRecordTypeId = ObjectFactory.getRecordTypeIdByNameAndObject('Client', 'Account');		
		Account childEntity = ObjectFactory.getEntity('childEntity', newClientRecordTypeId, newMember);
		Account topParentEntity = ObjectFactory.getEntity('topParentEntity', newClientRecordTypeId, newMember);
		childEntity.Primary_Relationship__c = topParentEntity.Id;
		update childEntity;
		List<Account> accounts = new List<Account>{childEntity, topParentEntity};
		DmEntity entityDm1 = new DmEntity();
		entityDm1.id = String.ValueOf(childEntity.Id);
		DmEntity entityDm2 = new DmEntity();
		entityDm2.id = String.ValueOf(topParentEntity.Id);
		entityDm2.name = 'topParentEntity';
		List<DmEntity> entityDms = new List<DmEntity>{entityDm1, entityDm2};
		m_mockDmBuilder.setup('buildDmEntities', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(entityDms);

		List<DmEntity> result =	sut.GetDmEntities(new List<String>{entityDm1.id, entityDm2.id});

		m_mockDmBuilder.verify('buildDmEntities', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
		List<Object> arguments = (List<Object>)m_mockDmBuilder.getArgumentsFromCall('buildDmEntities');
		List<Account> passedAccounts = (List<Account>)arguments[0];

		System.assertEquals(2, passedAccounts.size());
		System.assertEquals(childEntity.Id, passedAccounts[0].Id);
		System.assertEquals(topParentEntity.Id, passedAccounts[1].Id);
		System.assertEquals(2,result.size());
		System.assertEquals('topParentEntity', result[1].name);
	}

	@IsTest
    static void it_should_verify_that_the_products_credit_card_and_debit_card_exist() {
        Schema.Describefieldresult fieldResult = Opportunity.Products__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        Set<String> values = new Set<String>();
        For(Schema.PicklistEntry p : ple){
              values.add(p.getValue().toLowerCase());
        }
        system.assertEquals(true,values.contains('credit card'));
        system.assertEquals(true,values.contains('debit card'));
    }

    @IsTest
    static void it_should_verify_that_the_ForecastCategoryName_field_should_atleast_have_one_item_fromsoql_where_clause() {
		Schema.Describefieldresult fieldResult = Opportunity.ForecastCategoryName.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        Set<String> values = new Set<String>();
        For(Schema.PicklistEntry p : ple){
              values.add(p.getValue());
        }
        system.assertEquals(true,values.contains('Pipeline') || values.contains('Omitted'));

    }

    @IsTest
    static void it_should_verify_that_the_StageName_field_should_atleast_have_one_item_fromsoql_where_clause() {
		Schema.Describefieldresult fieldResult = Opportunity.stageName.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        Set<String> values = new Set<String>();
        For(Schema.PicklistEntry p : ple){
              values.add(p.getValue());
        }
        system.assertEquals(true,values.contains('Monitor')
                              || values.contains('Discovery')
                              || values.contains('Proposal/Solution')
                              || values.contains('Negotiation')
                              || values.contains('Approval/Acceptance')
                              || values.contains('Documentation')
                           );
    }
    
    @IsTest
    static void it_should_get_only_the_active_related_eb_accounts() {
		List<Map<Id, Account>> tree = new List<Map<Id, Account>>();

		EB_Team_Member__c newMember = ObjectFactory.getTeamMember('Test Member');
		Id newClientRecordTypeId = ObjectFactory.getRecordTypeIdByNameAndObject('Client', 'Account');		
		Account entity1 = ObjectFactory.getEntity('entity1', newClientRecordTypeId, newMember);

		EB_Account__c acct1 = ObjectFactory.getEBAccount('EB Acct 1', '0001', entity1);
		acct1.Account_Status__c='A';
		
		EB_Account__c acct2 = ObjectFactory.getEBAccount('EB Acct 2', '0002', entity1);
		acct2.Account_Status__c='C';

		update acct1;
		update acct2;

		ObjectFactory.relateEntityToEBAccount(entity1, acct1);
		ObjectFactory.relateEntityToEBAccount(entity1, acct2);

		sut.GetDmEntities(new List<String> { entity1.Id });

		List<Object> args = m_mockDmBuilder.getArgumentsFromCall('buildDmEntities');
        List<Account> accounts = (List<Account>)args[0];        
        System.assertEquals(1, accounts[0].EB_Account_Relationships__r.size());
        System.assertEquals(acct1.Id, accounts[0].EB_Account_Relationships__r[0].EB_Account_Id__c);
	}

	@IsTest
    static void it_should_get_only_the_active_tm_services() {
		EB_Team_Member__c newMember = ObjectFactory.getTeamMember('Test Member');
		Id newClientRecordTypeId = ObjectFactory.getRecordTypeIdByNameAndObject('Client', 'Account');		
		Account entity1 = ObjectFactory.getEntity('entity1', newClientRecordTypeId, newMember);
		Treasury_Management__c tm1 = new Treasury_Management__c(Account__c = entity1.Id, Archive__c=false);
		Treasury_Management__c tm2 = new Treasury_Management__c(Account__c = entity1.Id, Archive__c=true);
		insert new List<Treasury_Management__c> { tm1, tm2 };
		
		sut.GetDmEntities(new List<String> { entity1.Id });

		List<Object> args = m_mockDmBuilder.getArgumentsFromCall('buildDmEntities');
        List<Account> accounts = (List<Account>)args[0];        
        System.assertEquals(1, accounts[0].Treasury_Management_Details__r.size());
        System.assertEquals(tm1.Id, accounts[0].Treasury_Management_Details__r[0].Id);
	}

	public class MockofIEntity360DmBuilder extends ApexMoq implements Entity360.IEntity360DmBuilder {
        public List<DmEntity> buildDmEntities(List<Account> pms){
            return (List<DmEntity>)handleMethodInvocation('buildDmEntities', new List<object> { pms });
        }
        public List<DmEntity> buildDmEntities(Map<Id, Account> pms){
            return (List<DmEntity>)handleMethodInvocation('buildDmEntities', new List<object> { pms });
        }
    }

    public class MockofIParentRelTreeBuilder extends ApexMoq implements ParentRelationships.IParentRelTreeBuilder {
    	public List<Map<Id, Account>> getRelationshipTreeForEntity(Id entityId, Boolean ignoreLookupForParent, Id excludeChildId){
    		return (List<Map<Id, Account>>)handleMethodInvocation('getRelationshipTreeForEntity', new List<object> { entityId, ignoreLookupForParent, excludeChildId });
    	}
    	public List<Map<Id, Account>> getRelationshipTreesForOwners(Set<Id> ownerIds){
    		return (List<Map<Id, Account>>)handleMethodInvocation('getRelationshipTreesForOwners', new List<object> { ownerIds });
    	}
    	public List<Map<Id, Account>> addChildToRelationshipTreeOfParent(Id parentIDofNewChild, Id childID, String relationshipToParent){
    		return (List<Map<Id, Account>>)handleMethodInvocation('addChildToRelationshipTreeOfParent', new List<object> { parentIDofNewChild, childID, relationshipToParent });
    	}
    	public List<ParentRelationships.RelatedEntity> getRelationshipTreeListForDisplay(List<Map<Id, Account>> relTree, Id currentId){
    		return (List<ParentRelationships.RelatedEntity>)handleMethodInvocation('getRelationshipTreeListForDisplay', new List<object> { relTree, currentId });
    	}
    }
}