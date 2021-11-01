@IsTest
private class ParentRelationshipSvcTests {
    
    private static final MockOfIParentRelTreeBuilderDataProv mockDataProv;
    private static final ParentRelationshipSvc sut;

    static {
        mockDataProv  = new MockOfIParentRelTreeBuilderDataProv();
        sut = new ParentRelationshipSvc(mockDataProv);
    }
    
    @IsTest
    static void it_should_return_the_top_level_parent() {
        Account grandparent = new Account(Id='001f000000GsU5a', Name='Grandparent');        
        Account parent1 = new Account(Id='001f000000GsU6a', ParentId=grandparent.Id, Parent=grandparent, Name='ParentSortMeSecond');
        Account childOfParent1 = new Account(Id='001f000000GsU8a', ParentId=parent1.Id, Parent=parent1, Name='ChildParent1');
        mockDataProv.setup('getEntity', new List<Object>{grandparent.Id}).returns(grandparent);
        mockDataProv.setup('getEntity', new List<Object>{parent1.Id}).returns(parent1);
        mockDataProv.setup('getEntity', new List<Object>{childOfParent1.Id}).returns(childOfParent1);

        Account topLevelParentOfChild = sut.getTopLevelParent(childOfParent1.Id);

        system.assertEquals(grandparent.Id, topLevelParentOfChild.Id);
    }

    @IsTest
    static void it_should_return_the_top_level_parent_that_is_seven_levels_high_with_only_two_calls_to_data_prov() {
        Account level7 = new Account(Id='001f000000GsU7a');
        Account level6 = new Account(Id='001f000000GsU6a', ParentId=level7.Id, Parent=level7);
        Account level5 = new Account(Id='001f000000GsU5a', ParentId=level6.Id, Parent=level6);
        Account level4 = new Account(Id='001f000000GsU4a', ParentId=level5.Id, Parent=level5);
        Account level3 = new Account(Id='001f000000GsU3a', ParentId=level4.Id, Parent=level4);
        Account level2 = new Account(Id='001f000000GsU2a', ParentId=level3.Id, Parent=level3);
        Account level1 = new Account(Id='001f000000GsU1a', ParentId=level2.Id, Parent=level2);
        mockDataProv.setup('getEntity', new List<Object>{level7.Id}).returns(level7);
        mockDataProv.setup('getEntity', new List<Object>{level1.Id}).returns(level1);

        Account topLevelForLevel1 = sut.getTopLevelParent(level1.Id);

        system.assertEquals(level7.Id, topLevelForLevel1.Id);
        mockDataProv.verify('getEntity', new List<Object>{level7.Id}, Times.Once);
        mockDataProv.verify('getEntity', new List<Object>{level1.Id}, Times.Once);
        mockDataProv.verify('getEntity', new List<Object>{level6.Id}, Times.Never);
        mockDataProv.verify('getEntity', new List<Object>{level5.Id}, Times.Never);
        mockDataProv.verify('getEntity', new List<Object>{level4.Id}, Times.Never);
        mockDataProv.verify('getEntity', new List<Object>{level3.Id}, Times.Never);
        mockDataProv.verify('getEntity', new List<Object>{level2.Id}, Times.Never);
    }

    @IsTest
    static void it_should_return_the_top_level_parent_that_is_six_levels_high_with_only_two_calls_to_data_prov() {
        Account level6 = new Account(Id='001f000000GsU6a');
        Account level5 = new Account(Id='001f000000GsU5a', ParentId=level6.Id, Parent=level6);
        Account level4 = new Account(Id='001f000000GsU4a', ParentId=level5.Id, Parent=level5);
        Account level3 = new Account(Id='001f000000GsU3a', ParentId=level4.Id, Parent=level4);
        Account level2 = new Account(Id='001f000000GsU2a', ParentId=level3.Id, Parent=level3);
        Account level1 = new Account(Id='001f000000GsU1a', ParentId=level2.Id, Parent=level2);
        mockDataProv.setup('getEntity', new List<Object>{level6.Id}).returns(level6);
        mockDataProv.setup('getEntity', new List<Object>{level1.Id}).returns(level1);

        Account topLevelForLevel1 = sut.getTopLevelParent(level1.Id);

        system.assertEquals(level6.Id, topLevelForLevel1.Id);
        mockDataProv.verify('getEntity', new List<Object>{level6.Id}, Times.Once);
        mockDataProv.verify('getEntity', new List<Object>{level1.Id}, Times.Once);
        mockDataProv.verify('getEntity', new List<Object>{level5.Id}, Times.Never);
        mockDataProv.verify('getEntity', new List<Object>{level4.Id}, Times.Never);
        mockDataProv.verify('getEntity', new List<Object>{level3.Id}, Times.Never);
        mockDataProv.verify('getEntity', new List<Object>{level2.Id}, Times.Never);
    }

    @IsTest
    static void it_should_return_the_top_level_parent_that_is_five_levels_high_with_only_two_calls_to_data_prov() {
        Account level5 = new Account(Id='001f000000GsU5a');
        Account level4 = new Account(Id='001f000000GsU4a', ParentId=level5.Id, Parent=level5);
        Account level3 = new Account(Id='001f000000GsU3a', ParentId=level4.Id, Parent=level4);
        Account level2 = new Account(Id='001f000000GsU2a', ParentId=level3.Id, Parent=level3);
        Account level1 = new Account(Id='001f000000GsU1a', ParentId=level2.Id, Parent=level2);
        mockDataProv.setup('getEntity', new List<Object>{level5.Id}).returns(level5);
        mockDataProv.setup('getEntity', new List<Object>{level1.Id}).returns(level1);

        Account topLevelForLevel1 = sut.getTopLevelParent(level1.Id);

        system.assertEquals(level5.Id, topLevelForLevel1.Id);
        mockDataProv.verify('getEntity', new List<Object>{level5.Id}, Times.Once);
        mockDataProv.verify('getEntity', new List<Object>{level1.Id}, Times.Once);
        mockDataProv.verify('getEntity', new List<Object>{level4.Id}, Times.Never);
        mockDataProv.verify('getEntity', new List<Object>{level3.Id}, Times.Never);
        mockDataProv.verify('getEntity', new List<Object>{level2.Id}, Times.Never);
    }

    @IsTest
    static void it_should_return_the_top_level_parent_that_is_four_levels_high_with_only_two_calls_to_data_prov() {
        Account level4 = new Account(Id='001f000000GsU4a');
        Account level3 = new Account(Id='001f000000GsU3a', ParentId=level4.Id, Parent=level4);
        Account level2 = new Account(Id='001f000000GsU2a', ParentId=level3.Id, Parent=level3);
        Account level1 = new Account(Id='001f000000GsU1a', ParentId=level2.Id, Parent=level2);
        mockDataProv.setup('getEntity', new List<Object>{level4.Id}).returns(level4);
        mockDataProv.setup('getEntity', new List<Object>{level1.Id}).returns(level1);

        Account topLevelForLevel1 = sut.getTopLevelParent(level1.Id);

        system.assertEquals(level4.Id, topLevelForLevel1.Id);
        mockDataProv.verify('getEntity', new List<Object>{level4.Id}, Times.Once);
        mockDataProv.verify('getEntity', new List<Object>{level1.Id}, Times.Once);
        mockDataProv.verify('getEntity', new List<Object>{level3.Id}, Times.Never);
        mockDataProv.verify('getEntity', new List<Object>{level2.Id}, Times.Never);
    }

    @IsTest
    static void it_should_return_the_top_level_parent_that_is_three_levels_high_with_only_two_calls_to_data_prov() {
        Account level3 = new Account(Id='001f000000GsU3a');
        Account level2 = new Account(Id='001f000000GsU2a', ParentId=level3.Id, Parent=level3);
        Account level1 = new Account(Id='001f000000GsU1a', ParentId=level2.Id, Parent=level2);
        mockDataProv.setup('getEntity', new List<Object>{level3.Id}).returns(level3);
        mockDataProv.setup('getEntity', new List<Object>{level1.Id}).returns(level1);

        Account topLevelForLevel1 = sut.getTopLevelParent(level1.Id);

        system.assertEquals(level3.Id, topLevelForLevel1.Id);
        mockDataProv.verify('getEntity', new List<Object>{level3.Id}, Times.Once);
        mockDataProv.verify('getEntity', new List<Object>{level1.Id}, Times.Once);
        mockDataProv.verify('getEntity', new List<Object>{level2.Id}, Times.Never);
    }

    @IsTest
    static void it_should_return_the_top_level_parent_that_is_two_levels_high_with_two_calls_to_data_prov() {
        Account level2 = new Account(Id='001f000000GsU2a');
        Account level1 = new Account(Id='001f000000GsU1a', ParentId=level2.Id, Parent=level2);
        mockDataProv.setup('getEntity', new List<Object>{level2.Id}).returns(level2);
        mockDataProv.setup('getEntity', new List<Object>{level1.Id}).returns(level1);

        Account topLevelForLevel1 = sut.getTopLevelParent(level1.Id);

        system.assertEquals(level2.Id, topLevelForLevel1.Id);
        mockDataProv.verify('getEntity', new List<Object>{level2.Id}, Times.Once);
        mockDataProv.verify('getEntity', new List<Object>{level1.Id}, Times.Once);
    }

    @IsTest
    static void it_should_return_the_top_level_parent_that_is_one_level_high_with_one_call_to_data_prov() {
        Account level1 = new Account(Id='001f000000GsU1a');
        mockDataProv.setup('getEntity', new List<Object>{level1.Id}).returns(level1);
        Account topLevelForLevel1 = sut.getTopLevelParent(level1.Id);

        system.assertEquals(level1.Id, topLevelForLevel1.Id);
        mockDataProv.verify('getEntity', new List<Object>{level1.Id}, Times.Once);
    }

    @IsTest
    static void it_should_return_the_top_level_parent_that_is_thirteen_levels_high_with_only_three_calls_to_data_prov() {
        Account level13 = new Account(Id='001f000000GsV3a');
        Account level12 = new Account(Id='001f000000GsV2a', ParentId=level13.Id, Parent=level13);
        Account level11 = new Account(Id='001f000000GsV1a', ParentId=level12.Id, Parent=level12);
        Account level10 = new Account(Id='001f000000GsV0a', ParentId=level11.Id, Parent=level11);
        Account level9 = new Account(Id='001f000000GsU9a', ParentId=level10.Id, Parent=level10);
        Account level8 = new Account(Id='001f000000GsU8a', ParentId=level9.Id, Parent=level9);
        Account level7 = new Account(Id='001f000000GsU7a', ParentId=level8.Id, Parent=level8);
        Account level6 = new Account(Id='001f000000GsU6a', ParentId=level7.Id, Parent=level7);
        Account level5 = new Account(Id='001f000000GsU5a', ParentId=level6.Id, Parent=level6);
        Account level4 = new Account(Id='001f000000GsU4a', ParentId=level5.Id, Parent=level5);
        Account level3 = new Account(Id='001f000000GsU3a', ParentId=level4.Id, Parent=level4);
        Account level2 = new Account(Id='001f000000GsU2a', ParentId=level3.Id, Parent=level3);
        Account level1 = new Account(Id='001f000000GsU1a', ParentId=level2.Id, Parent=level2);
        mockDataProv.setup('getEntity', new List<Object>{level13.Id}).returns(level13);
        mockDataProv.setup('getEntity', new List<Object>{level7.Id}).returns(level7);
        mockDataProv.setup('getEntity', new List<Object>{level1.Id}).returns(level1);

        Account topLevelForLevel1 = sut.getTopLevelParent(level1.Id);

        system.assertEquals(level13.Id, topLevelForLevel1.Id);
        mockDataProv.verify('getEntity', new List<Object>{level13.Id}, Times.Once);
        mockDataProv.verify('getEntity', new List<Object>{level7.Id}, Times.Once);
        mockDataProv.verify('getEntity', new List<Object>{level1.Id}, Times.Once);
        mockDataProv.verify('getEntity', new List<Object>{level12.Id}, Times.Never);
        mockDataProv.verify('getEntity', new List<Object>{level11.Id}, Times.Never);
        mockDataProv.verify('getEntity', new List<Object>{level10.Id}, Times.Never);
        mockDataProv.verify('getEntity', new List<Object>{level9.Id}, Times.Never);
        mockDataProv.verify('getEntity', new List<Object>{level8.Id}, Times.Never);
        mockDataProv.verify('getEntity', new List<Object>{level6.Id}, Times.Never);
        mockDataProv.verify('getEntity', new List<Object>{level5.Id}, Times.Never);
        mockDataProv.verify('getEntity', new List<Object>{level4.Id}, Times.Never);
        mockDataProv.verify('getEntity', new List<Object>{level3.Id}, Times.Never);
        mockDataProv.verify('getEntity', new List<Object>{level2.Id}, Times.Never);
    }

    @IsTest
    static void it_should_return_all_related_entities_for_given_parent() {
        Account grandparent     = new Account(Id='001f000000GsU5a', Name='Grandparent');        
        Account parent1         = new Account(Id='001f000000GsU6a', ParentId=grandparent.Id, Name='ParentSortMeSecond');
        Account parent2         = new Account(Id='001f000000GsU7a', ParentId=grandparent.Id, Name='ParentSortMeFirst');
        Account childOfParent1  = new Account(Id='001f000000GsU8a', ParentId=parent1.Id, Name='ChildParent1');
        Account childOfParent2  = new Account(Id='001f000000GsU9a', ParentId=parent2.Id, Name='ChildParent2');
        Set<Id> grandparentIds  = new Set<Id>{grandparent.Id};
        Set<Id> parentIds       = new Set<Id>{parent1.Id, parent2.Id};
        Set<Id> childIds        = new Set<Id>{childOfParent1.Id, childOfParent2.Id};
        Map<Id, Account> parents    = new Map<Id, Account>{parent1.Id => parent1, parent2.Id => parent2};
        Map<Id, Account> children   = new Map<Id, Account>{childOfParent1.Id => childOfParent1, childOfParent2.Id => childOfParent2};
        mockDataProv.setup('getEntity', new List<Object>{grandparent.Id}).returns(grandparent);
        mockDataProv.setup('getChildrenForEntities', new List<Object>{grandparentIds}).returns(parents);
        mockDataProv.setup('getChildrenForEntities', new List<Object>{parentIds}).returns(children);
        mockDataProv.setup('getChildrenForEntities', new List<Object>{childIds}).returns(new Map<Id, Account>());

        Map<Id, Account> relatedEntities = sut.getAllRelatedEntitiesForParent(grandparent.Id);

        system.assertEquals(5, relatedEntities.size());
        system.assert(relatedEntities.containsKey(grandparent.Id));
        system.assert(relatedEntities.containsKey(parent1.Id));
        system.assert(relatedEntities.containsKey(parent2.Id));
        system.assert(relatedEntities.containsKey(childOfParent1.Id));
        system.assert(relatedEntities.containsKey(childOfParent2.Id));
    }

    @IsTest
    static void it_should_set_the_top_level_parent_for_entity() {
        Account grandparent     = new Account(Id='001f000000GsU5a', Name='Grandparent', OwnerId = '0051300000Bc0dK');        
        Account parent1         = new Account(Id='001f000000GsU6a', ParentId=grandparent.Id, Name='ParentSortMeSecond', OwnerId='0051300000BbvdU');
        mockDataProv.setup('getEntity', new List<Object>{grandparent.Id}).returns(grandparent);
        mockDataProv.setup('getEntity', new List<Object>{parent1.Id}).returns(parent1);
        parent1.Primary_Relationship__c = null;

        sut.setTopLevelParentForEntity(parent1);

        System.assertEquals(grandparent.Id, parent1.Primary_Relationship__c );
        System.assertEquals(grandparent.OwnerId, parent1.OwnerId);    
    }

    @IsTest
    static void it_should_set_the_top_level_parent_for_entity_and_update_contact() {
        User user1 = ObjectFactory.getUser('first1', 'last1','standarduser1@testorg.com.ebt', true);
        Account grandparent = ObjectFactory.getValidEntity('grandparent');  
        grandparent.OwnerId = user1.Id;
        update grandparent;

        User user2 = ObjectFactory.getUser('first2', 'last2','standarduser2@testorg.com.ebt', true);
        Account parent1 = ObjectFactory.getValidEntity('parent1');  
        parent1.OwnerId = user2.Id;
        parent1.ParentId = grandparent.Id;
        parent1.Relationship_Change_Ignore_Validation__c = true;
        update parent1;
        Contact contact = new Contact(FirstName = 'ContactFirst', LastName ='ContactLast', AccountId = parent1.Id, OwnerId = user2.Id );
        insert contact;

        Account gParent = [SELECT Id, OwnerId, ParentId, ( SELECT Id, OwnerId FROM Contacts) FROM Account WHERE Id =: grandparent.Id LIMIT 1 ];
        Account par1 = [SELECT Id, OwnerId, ParentId, Parent.ParentId ,( SELECT Id, OwnerId FROM Contacts) FROM Account WHERE Id =: parent1.Id LIMIT 1 ];

        mockDataProv.setup('getEntity', new List<Object>{grandparent.Id}).returns(gParent);
        mockDataProv.setup('getEntity', new List<Object>{parent1.Id}).returns(par1);
        parent1.Primary_Relationship__c = null;

        sut.setTopLevelParentForEntity(par1);

        System.assertEquals(gParent.OwnerId, par1.Contacts[0].OwnerId);    
    }

    @IsTest
    static void it_should_set_the_owner_of_contact_to_related_entity_owner() {
        User user1 = ObjectFactory.getUser('first1', 'last1','standarduser1@testorg.com.ebt', true);
        Account testEntity = ObjectFactory.getValidEntity('testEntity');
        testEntity.OwnerId = user1.Id;
        update testEntity;

        User user2 = ObjectFactory.getUser('first2', 'last2','standarduser2@testorg.com.ebt', true);
        Contact contact = new Contact(FirstName = 'ContactFirst', LastName ='ContactLast', AccountId = testEntity.Id, OwnerId = user2.Id );
        insert contact;
        Account tstEnt = [SELECT Id, OwnerId, ParentId, (SELECT Id, OwnerId FROM Contacts) FROM Account WHERE Id =: testEntity.Id LIMIT 1 ];
        
        mockDataProv.setup('getEntity', new List<Object>{tstEnt.Id}).returns(tstEnt);

        sut.setTopLevelParentForEntity(tstEnt);

        System.assertEquals(tstEnt.OwnerId, tstEnt.Contacts[0].OwnerId); 
    }

    @IsTest
    static void it_should_set_the_top_level_parent_to_null_for_entity_that_is_at_top() {
        Account grandparent     = new Account(Id='001f000000GsU5a', Name='Grandparent');        
        mockDataProv.setup('getEntity', new List<Object>{grandparent.Id}).returns(grandparent);
        grandparent.Primary_Relationship__c = grandparent.Id;

        sut.setTopLevelParentForEntity(grandparent);

        System.assertEquals(null, grandparent.Primary_Relationship__c );    
    }

    @IsTest
    static void it_should_update_any_entities_that_are_children_of_children_of_an_entity_to_directly_be_children_of_that_entity() {
        Account grandparent     = new Account(Id='001f000000GsU5a', Name='Grandparent');        
        Account parent1         = new Account(Id='001f000000GsU6a', ParentId=grandparent.Id, Name='ParentSortMeSecond');
        Account parent2         = new Account(Id='001f000000GsU7a', ParentId=grandparent.Id, Name='ParentSortMeFirst');
        Account childOfParent1  = new Account(Id='001f000000GsU8a', ParentId=parent1.Id, Name='ChildParent1');
        Account childOfParent2  = new Account(Id='001f000000GsU9a', ParentId=parent2.Id, Name='ChildParent2');
        Set<Id> grandparentIds  = new Set<Id>{grandparent.Id};
        Set<Id> parentIds       = new Set<Id>{parent1.Id, parent2.Id};
        Set<Id> childIds        = new Set<Id>{childOfParent1.Id, childOfParent2.Id};
        Map<Id, Account> parents    = new Map<Id, Account>{parent1.Id => parent1, parent2.Id => parent2};
        Map<Id, Account> children   = new Map<Id, Account>{childOfParent1.Id => childOfParent1, childOfParent2.Id => childOfParent2};
        mockDataProv.setup('getEntity', new List<Object>{grandparent.Id}).returns(grandparent);
        mockDataProv.setup('getChildrenForEntities', new List<Object>{grandparentIds}).returns(parents);
        mockDataProv.setup('getChildrenForEntities', new List<Object>{parentIds}).returns(children);
        mockDataProv.setup('getChildrenForEntities', new List<Object>{childIds}).returns(new Map<Id, Account>());

        sut.flattenRelatedChildrenForEntity(grandparent);

        List<Object> rawRequest = mockDataProv.getArgumentsFromCall('updateEntities');
        List<Account> acctsUpdated = (List<Account>) (rawRequest.get(0));
        System.assertEquals(2, acctsUpdated.size());
        Account childUpdated1 = new Account();
        Account childUpdated2 = new Account();
        for(Account child : acctsUpdated){
            if(child.Id == childOfParent1.Id) childUpdated1 = child;
            if(child.Id == childOfParent2.Id) childUpdated2 = child;
        }
        System.assertEquals(childOfParent1.Id, childUpdated1.Id);
        System.assertEquals(grandparent.Id, childUpdated1.ParentId);
        System.assertEquals(childOfParent2.Id, childUpdated2.Id);
        System.assertEquals(grandparent.Id, childUpdated2.ParentId);
    }

    private class MockOfIParentRelTreeBuilderDataProv extends ApexMoq implements ParentRelTreeBuilderDataProv.IParentRelTreeBuilderDataProv {
        public Account getEntity(Id acctId){
            return (Account)handleMethodInvocation('getEntity', new List<Object>{acctId});
        }
        public Map<Id, Account> getChildrenForEntities(Set<Id> acctIds){
            return (Map<Id, Account>)handleMethodInvocation('getChildrenForEntities', new List<Object>{acctIds});
        }
        public Map<Id, Account> getTopLevelAccountsForOwners(Set<Id> ownerIds){
            return (Map<Id, Account>)handleMethodInvocation('getTopLevelAccountsForOwners', new List<Object>{ownerIds});
        }
        public void updateEntities(List<Account> entities){
            handleMethodInvocation('updateEntities', new List<Object>{entities});
        }
    }
}