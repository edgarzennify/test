@IsTest
private class ParentRelFlattenHierarchyControllerTests {
	
	private static final Account testEntity;
	private static final Mock.ofIParentRelationshipSvc mockParentSvc;
	private static final Mock.ofIParentRelTreeBuilderDataProv mockDataProv;
	private static final Mock.ofIApexPages mockApexPages;
	private static final Mock.ofIUtility mockUtility;
	private static final ParentRelFlattenHierarchyController sut;
	
	static {
		testEntity = new Account(Id=ObjectFactory.getFakeId(Account.SObjectType, '1'));
		testEntity.OwnerId = ObjectFactory.getFakeId(User.SObjectType, '1');
		mockParentSvc = new Mock.ofIParentRelationshipSvc();
		mockDataProv = new Mock.ofIParentRelTreeBuilderDataProv();
		mockApexPages = new Mock.ofIApexPages();
		mockUtility = new Mock.ofIUtility();
		mockApexPages.setup('getParameter', new List<Object>{'id'}).returns(testEntity.Id);
		mockDataProv.setup('getEntity', new List<Object>{testEntity.Id}).returns(testEntity);
		mockUtility.setup('getServerUrl').returns('servUrl');
		sut = new ParentRelFlattenHierarchyController(mockParentSvc, mockDataProv, mockApexPages, mockUtility);
	}

	@IsTest
    static void it_should_make_call_to_get_entity_id_from_page_wrapper() {
		mockApexPages.verify('getParameter', new List<Object>{'id'}, Times.Once);
	}

	@IsTest
    static void it_should_make_call_to_get_entity_from_data_prov_using_id_from_wrapper() {
		mockDataProv.verify('getEntity', new List<Object>{testEntity.Id}, Times.Once);
	}

	@IsTest
    static void it_should_set_entity_to_the_one_provided_from_data_prov() {
		System.assertEquals(testEntity, sut.entity);
	}

	@IsTest
    static void it_should_make_call_to_flatten_hierarchy_for_given_entity() {
		sut.flattenHierarchyForEntity();

		mockParentSvc.verify('flattenRelatedChildrenForEntity', new List<Object>{testEntity}, Times.Once);
	}

	@IsTest
    static void it_should_return_user_to_owner_overview_when_completed() {
		String expectedDestination = 'servUrl' + '/apex/OwnerOverview?id=' + testEntity.OwnerId;
		PageReference returnURL = sut.flattenHierarchyForEntity();

		mockUtility.verify('getServerUrl', Times.Once);
		System.assertEquals(expectedDestination, returnURL.getUrl());	
	}

	@IsTest
    static void it_should_return_user_to_owner_overview_when_cancelled() {
		String expectedDestination = 'servUrl' + '/apex/OwnerOverview?id=' + testEntity.OwnerId;
		PageReference returnURL = sut.cancel();

		mockUtility.verify('getServerUrl', Times.Once);
		System.assertEquals(expectedDestination, returnURL.getUrl());	
	}
}