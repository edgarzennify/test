@isTest
private class ParentRelTreeBuilderTests {

    private final static MockofIParentRelTreeBuilderDataProv mockDataProv = new MockofIParentRelTreeBuilderDataProv();
    private final static Mock.ofIParentRelationshipSvc mockParentRelationshipSvc = new Mock.ofIParentRelationshipSvc();
    private final static ParentRelTreeBuilder sut = new ParentRelTreeBuilder(mockDataProv, mockParentRelationshipSvc);

    private final static Account grandparent        = new Account(Id='001f000000GsU5a', Name='Grandparent');        
    private final static Account parent1            = new Account(Id='001f000000GsU6a', ParentId=grandparent.Id, Name='ParentSortMeSecond');
    private final static Account parent2            = new Account(Id='001f000000GsU7a', ParentId=grandparent.Id, Name='ParentSortMeFirst');
    private final static Account childOfParent1     = new Account(Id='001f000000GsU8a', ParentId=parent1.Id, Name='ChildParent1');
    private final static Account childOfParent2     = new Account(Id='001f000000GsU9a', ParentId=parent2.Id, Name='ChildParent2');
    private final static Set<Id> grandparentIDSet   = new Set<Id>{grandparent.Id};
    private final static Set<Id> parentIDSet        = new Set<Id>{parent1.Id, parent2.Id};
    private final static Set<Id> childIDSet         = new Set<Id>{childOfParent1.Id, childOfParent2.Id};
    private final static Set<Id> parentIDSet2Only   = new Set<Id>{parent2.Id};
    private final static Set<Id> childIDSet2Only    = new Set<Id>{childOfParent2.Id};
    private final static Map<Id, Account> grandparentChildren       = new Map<Id, Account>{ parent1.Id => parent1,  parent2.Id => parent2 };
    private final static Map<Id, Account> parentChildren            = new Map<Id, Account>{ childOfParent1.Id => childOfParent1, childOfParent2.Id => childOfParent2 };
    private final static Map<Id, Account> parentChildrenOfParent2   = new Map<Id, Account>{ childOfParent2.Id => childOfParent2 };
    private final static Map<Id, Account> childrenChildren          = new Map<Id, Account>();

    static{
        mockDataProv.setup('getEntity', new List<Object>{grandparent.Id}).returns(grandparent);
        mockDataProv.setup('getEntity', new List<Object>{parent1.Id}).returns(parent1);
        mockDataProv.setup('getEntity', new List<Object>{parent2.Id}).returns(parent2);
        mockDataProv.setup('getEntity', new List<Object>{childOfParent1.Id}).returns(childOfParent1);
        mockDataProv.setup('getEntity', new List<Object>{childOfParent2.Id}).returns(childOfParent2);
        mockDataProv.setup('getChildrenForEntities', new List<Object>{grandparentIDSet}).returns(grandparentChildren);
        mockDataProv.setup('getChildrenForEntities', new List<Object>{parentIDSet}).returns(parentChildren);
        mockDataProv.setup('getChildrenForEntities', new List<Object>{childIDSet}).returns(childrenChildren);
        mockDataProv.setup('getChildrenForEntities', new List<Object>{parentIDSet2Only}).returns(parentChildrenOfParent2);
        mockDataProv.setup('getChildrenForEntities', new List<Object>{childIDSet2Only}).returns(childrenChildren);
        mockParentRelationshipSvc.setup('getTopLevelParent', new List<Object>{childOfParent2.Id}).returns(grandparent);
        mockParentRelationshipSvc.setup('getTopLevelParent', new List<Object>{childOfParent1.Id}).returns(grandparent);
        mockParentRelationshipSvc.setup('getTopLevelParent', new List<Object>{parent2.Id}).returns(grandparent);
        mockParentRelationshipSvc.setup('getTopLevelParent', new List<Object>{parent1.Id}).returns(grandparent);
        mockParentRelationshipSvc.setup('getTopLevelParent', new List<Object>{grandparent.Id}).returns(grandparent);
    }

    private static testMethod void it_should_call_the_default_constructor_without_error() {
        ParentRelTreeBuilder sutDefaultCall = new ParentRelTreeBuilder();
    }

    private static testMethod void it_should_build_a_relationship_tree_for_an_entity_starting_at_the_top_parent() {
        List<Map<Id, Account>> retTree = sut.getRelationshipTreeForEntity(parent2.Id, false, null);

        system.assertEquals(3, retTree.size());
        system.assertEquals(1, retTree[0].size());
        system.assertEquals(true, retTree[0].containsKey(grandparent.Id));
        system.assertEquals(2, retTree[1].size());
        system.assertEquals(true, retTree[1].containsKey(parent1.Id));
        system.assertEquals(true, retTree[1].containsKey(parent2.Id));
        system.assertEquals(2, retTree[2].size());
        system.assertEquals(true, retTree[2].containsKey(childOfParent1.Id));
        system.assertEquals(true, retTree[2].containsKey(childOfParent2.Id));
    
    }


    private static testMethod void it_should_build_a_relationship_tree_for_an_entity_ignoring_any_parent_of_entity() {
        List<Map<Id, Account>> retTree = sut.getRelationshipTreeForEntity(parent2.Id, true, null);

        system.assertEquals(2, retTree.size());
        system.assertEquals(1, retTree[0].size());
        system.assertEquals(true, retTree[0].containsKey(parent2.Id));
        system.assertEquals(1, retTree[1].size());
        system.assertEquals(true, retTree[1].containsKey(childOfParent2.Id));
    }

    private static testMethod void it_should_build_a_relationship_tree_for_an_entity_ignoring_provided_child() {
        List<Map<Id, Account>> retTree = sut.getRelationshipTreeForEntity(parent1.Id, false, childOfParent1.Id);

        system.assertEquals(3, retTree.size());
        system.assertEquals(1, retTree[0].size());
        system.assertEquals(true, retTree[0].containsKey(grandparent.Id));
        system.assertEquals(2, retTree[1].size());
        system.assertEquals(true, retTree[1].containsKey(parent1.Id));
        system.assertEquals(true, retTree[1].containsKey(parent2.Id));
        system.assertEquals(1, retTree[2].size());
        system.assertEquals(true, retTree[2].containsKey(childOfParent2.Id));
    }


    private static testMethod void it_should_build_a_relationship_tree_by_combining_old_relationship_tree_with_new_one_for_child() {
        Account parentMovingToChild = new Account(Id='001f000000GsU4a', ParentId = grandparent.Id);
        Account childOfParentMovingToChild = new Account(Id='001f000000GsU3a', ParentId = parentMovingToChild.Id);
        Set<Id> parentMovingToChildIDSet = new Set<Id>();
        parentMovingToChildIDSet.add(parentMovingToChild.Id);
        Set<Id> childOfParentMovingToChildIDSet = new Set<Id>();
        childOfParentMovingToChildIDSet.add(childOfParentMovingToChild.Id);
        Map<Id, Account> grandparentChildrenWithParentMoving = new Map<Id, Account>();
        grandparentChildrenWithParentMoving.put(parent1.Id, parent1);
        grandparentChildrenWithParentMoving.put(parent2.Id, parent2);
        grandparentChildrenWithParentMoving.put(parentMovingToChild.Id, parentMovingToChild);
        Map<Id, Account> parentMovingToChildChildren = new Map<Id, Account>();
        parentMovingToChildChildren.put(childOfParentMovingToChild.Id, childOfParentMovingToChild);
        mockDataProv.setup('getEntity', new List<Object>{parentMovingToChild.Id}).returns(parentMovingToChild);
        mockDataProv.setup('getEntity', new List<Object>{childOfParentMovingToChild.Id}).returns(childOfParentMovingToChild);
        mockDataProv.setup('getChildrenForEntities', new List<Object>{grandparentIDSet}).returns(grandparentChildrenWithParentMoving);
        mockDataProv.setup('getChildrenForEntities', new List<Object>{parentMovingToChildIDSet}).returns(parentMovingToChildChildren);
        mockDataProv.setup('getChildrenForEntities', new List<Object>{childOfParentMovingToChildIDSet}).returns(childrenChildren);

        List<Map<Id, Account>> retTree = sut.addChildToRelationshipTreeOfParent(parent1.Id, parentMovingToChild.Id, 'newRelationship');

        system.assertEquals(4, retTree.size());
        system.assertEquals(1, retTree[0].size());
        system.assertEquals(true, retTree[0].containsKey(grandparent.Id));
        system.assertEquals(2, retTree[1].size());
        system.assertEquals(true, retTree[1].containsKey(parent1.Id));
        system.assertEquals(true, retTree[1].containsKey(parent2.Id));
        system.assertEquals(3, retTree[2].size());
        system.assertEquals(true, retTree[2].containsKey(childOfParent1.Id));
        system.assertEquals(true, retTree[2].containsKey(childOfParent2.Id));
        system.assertEquals(true, retTree[2].containsKey(parentMovingToChild.Id));
        system.assertEquals('newRelationship', retTree[2].get(parentMovingToChild.Id).Relationship_To_Parent__c);
        system.assertEquals(1, retTree[3].size());
        system.assertEquals(true, retTree[3].containsKey(childOfParentMovingToChild.Id));
    }

    private static testMethod void it_should_return_a_relationship_tree_for_display() {
        Map<Id, Account> grandparents = new Map<Id, Account>{grandparent.Id => grandparent};
        List<Map<Id, Account>> relTree = new List<Map<Id, Account>>{grandparents, grandparentChildren, parentChildren};

        List<ParentRelationships.RelatedEntity> returnedTree = sut.getRelationshipTreeListForDisplay(relTree, childOfParent1.Id);

        system.assertEquals(5, returnedTree.size());
        system.assertEquals(grandparent.Id, returnedTree[0].entity.Id);
        system.assertEquals(0, returnedTree[0].nodeLevel);
        system.assertEquals(false, returnedTree[0].isCurrentNode);
//        system.assertEquals(grandparent.Id, returnedTree[0].RelatedEntity.totalActiveAccounts);
        system.assertEquals(parent2.Id, returnedTree[1].entity.Id);
        system.assertEquals(1, returnedTree[1].nodeLevel);
        system.assertEquals(false, returnedTree[1].isCurrentNode);
        system.assertEquals(childOfParent2.Id, returnedTree[2].entity.Id);
        system.assertEquals(2, returnedTree[2].nodeLevel);
        system.assertEquals(false, returnedTree[2].isCurrentNode);
        system.assertEquals(parent1.Id, returnedTree[3].entity.Id);
        system.assertEquals(1, returnedTree[3].nodeLevel);
        system.assertEquals(false, returnedTree[3].isCurrentNode);
        system.assertEquals(childOfParent1.Id, returnedTree[4].entity.Id);
        system.assertEquals(2, returnedTree[4].nodeLevel);
        system.assertEquals(true, returnedTree[4].isCurrentNode);
    }




    private class MockofIParentRelTreeBuilderDataProv extends ApexMoq implements ParentRelTreeBuilderDataProv.IParentRelTreeBuilderDataProv{
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