@IsTest
private class ParentRelComponentTests {
    
    private static final MockofIParentRelTreeBuilder mockParentRelTreeBuilder = new MockofIParentRelTreeBuilder();
    private static final ParentRelComponent sut = new ParentRelComponent(mockParentRelTreeBuilder);
    private static final Account testAcctParent = new Account(Id='001f000000GsU5a');
    private static final Account testAcctChild  = new Account(Id='001f000000GsU6a');
    private static final ParentRelationships.RelatedEntity testEntity = new ParentRelationships.RelatedEntity(testAcctParent, testAcctParent.EB_Account_Relationships__r, 0, false);
    private static final List<Map<Id, Account>> returnForRelationshipCall = new List<Map<Id, Account>>();
    private static final List<ParentRelationships.RelatedEntity> returnForDisplayCall = new List<ParentRelationships.RelatedEntity>{testEntity};

    @IsTest
    static void it_should_call_the_default_constructor_without_error() {
        ParentRelComponent sutDefault = new ParentRelComponent();
    }

    @IsTest
    static void it_should_return_the_tree_from_tree_builder_for_existing_relationship() {
        mockParentRelTreeBuilder.setup('getRelationshipTreeForEntity', new List<Object>{testAcctChild.Id, false, null}).returns(returnForRelationshipCall);
        mockParentRelTreeBuilder.setup('getRelationshipTreeListForDisplay', new List<Object>{returnForRelationshipCall, testAcctChild.Id}).returns(returnForDisplayCall);
        sut.renderComponent = 'true';
        sut.pageBlockTitle = 'Title';
        sut.parentId = testAcctParent.Id;
        sut.childId = testAcctChild.Id;
        sut.relationshipToParent = 'relationship';
        sut.existingRelationships = true;

        List<ParentRelationships.RelatedEntity> returnTree = sut.relationshipTree;

        mockParentRelTreeBuilder.verify('getRelationshipTreeForEntity',new List<Object>{testAcctChild.Id, false, null}, Times.Once);
        system.assertEquals(returnForDisplayCall, returnTree);
    }

    @IsTest
    static void it_should_return_the_tree_from_tree_builder_for_no_parent() {
        mockParentRelTreeBuilder.setup('getRelationshipTreeForEntity', new List<Object>{testAcctChild.Id, true, null}).returns(returnForRelationshipCall);
        mockParentRelTreeBuilder.setup('getRelationshipTreeListForDisplay', new List<Object>{returnForRelationshipCall, testAcctChild.Id}).returns(returnForDisplayCall);
        sut.renderComponent = 'true';
        sut.pageBlockTitle = 'Title';
        sut.parentId = null;
        sut.childId = testAcctChild.Id;
        sut.relationshipToParent = 'relationship';
        sut.existingRelationships = false;

        List<ParentRelationships.RelatedEntity> returnTree = sut.relationshipTree;

        mockParentRelTreeBuilder.verify('getRelationshipTreeForEntity',new List<Object>{testAcctChild.Id, true, null}, Times.Once);
        system.assertEquals(returnForDisplayCall, returnTree);
    }

    @IsTest
    static void it_should_return_the_tree_from_tree_builder_for_dynamic_build() {
        mockParentRelTreeBuilder.setup('addChildToRelationshipTreeOfParent', new List<Object>{testAcctParent.Id, testAcctChild.Id, 'relationship'}).returns(returnForRelationshipCall);
        mockParentRelTreeBuilder.setup('getRelationshipTreeListForDisplay', new List<Object>{returnForRelationshipCall, testAcctChild.Id}).returns(returnForDisplayCall);
        sut.renderComponent = 'true';
        sut.pageBlockTitle = 'Title';
        sut.parentId = testAcctParent.Id;
        sut.childId = testAcctChild.Id;
        sut.relationshipToParent = 'relationship';
        sut.existingRelationships = false;

        List<ParentRelationships.RelatedEntity> returnTree = sut.relationshipTree;

        mockParentRelTreeBuilder.verify('addChildToRelationshipTreeOfParent',new List<Object>{testAcctParent.Id, testAcctChild.Id, 'relationship'}, Times.Once);
        system.assertEquals(returnForDisplayCall, returnTree);
    }

    private class MockofIParentRelTreeBuilder extends ApexMoq implements ParentRelationships.IParentRelTreeBuilder {
        public List<Map<Id, Account>> getRelationshipTreesForOwners(Set<Id> ownerIds){
            return (List<Map<Id, Account>>)handleMethodInvocation('getRelationshipTreesForOwners', new List<Object>{ownerIds});
        }
        public List<Map<Id, Account>> getRelationshipTreeForEntity(Id entityId, Boolean ignoreLookupForParent, Id excludeChildId){
            return (List<Map<Id, Account>>)handleMethodInvocation('getRelationshipTreeForEntity', new List<Object>{entityId, ignoreLookupForParent, excludeChildId});
        }
        public List<Map<Id, Account>> addChildToRelationshipTreeOfParent(Id parentIDofNewChild, Id childID, String relationshipToParent){
            return (List<Map<Id, Account>>)handleMethodInvocation('addChildToRelationshipTreeOfParent', new List<Object>{parentIDofNewChild, childID, relationshipToParent});
        }
        public List<ParentRelationships.RelatedEntity> getRelationshipTreeListForDisplay(List<Map<Id, Account>> relTree, Id currentId){
            return (List<ParentRelationships.RelatedEntity>)handleMethodInvocation('getRelationshipTreeListForDisplay', new List<Object>{relTree, currentId});
        }
    }
}