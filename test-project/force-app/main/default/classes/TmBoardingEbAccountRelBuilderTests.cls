@IsTest
private class TmBoardingEbAccountRelBuilderTests {
	
	private static TmBoardingEbAccountRelBuilder sut;
	private static final Mock.ofIParentRelTreeBuilder mockParentRelTreeBuilder;

    static {
    	mockParentRelTreeBuilder = new Mock.ofIParentRelTreeBuilder();
        sut = new TmBoardingEbAccountRelBuilder(mockParentRelTreeBuilder);
    }

    @IsTest
    static void it_should_call_the_tree_builder_to_get_entity_relationships() {
    	Id parentId = ObjectFactory.getFakeId(Account.SobjectType, '1');
    	Account parent = new Account(Id = parentId);

    	Map<String, DmEntity> result = sut.getRelatedEntitiesIncludingParent(parent);

    	mockParentRelTreeBuilder.verify('getRelationshipTreeForEntity', new List<Object>{parentId, false, null}, Times.Once);
    }

    @IsTest
    static void it_should_return_the_parent_and_related_entity() {
    	Id parentId = ObjectFactory.getFakeId(Account.SobjectType, '1');
    	Account parent = new Account(Id = parentId);
    	Id childId = ObjectFactory.getFakeId(Account.SobjectType, '2');
    	Account child = new Account(Id = childId);

    	List<Map<Id, Account>> rels = new List<Map<Id, Account>>{new Map<Id, Account>{childId => child}};
    	mockParentRelTreeBuilder.setup('getRelationshipTreeForEntity', new List<Object>{parent.Id, false, null}).returns(rels);
    	
    	Map<String, DmEntity> result = sut.getRelatedEntitiesIncludingParent(parent);

    	List<String> resultIds = new List<string>(result.keySet());
    	System.assertEquals(2, resultIds.size());
    	System.assertEquals(parentId, resultIds[0]);
    	System.assertEquals(childId, resultIds[1]);
    }
}