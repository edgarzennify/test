@IsTest
private class ModReqUnitRMControllerTests {

	private static final Id testEntityId;
	private static final Account testEntity;
	private static final MockofIModReqUnitRMControllerDataProv mockDataProv;
	private static final Mock.ofIApexPages mockApexPages;
	private static final Mock.ofIConfigurations mockConfig;
	private static final ModReqUnitRMController sut;

	static {
		testEntityId = ObjectFactory.getFakeId(Account.SObjectType, '1');
		testEntity = new Account();
		mockDataProv = new MockofIModReqUnitRMControllerDataProv();
		mockDataProv.setup('getEntity', new List<Object>{testEntityId}).returns(testEntity);
		mockApexPages = new Mock.ofIApexPages();
		mockApexPages.setup('getParameter', new List<Object>{'EntityId'}).returns(testEntityId);
		mockConfig = new Mock.ofIConfigurations();
		sut = new ModReqUnitRMController(mockDataProv, mockApexPages, mockConfig);
	}

	@IsTest
    static void it_should_call_the_default_constructor_without_error() {
		Account testAcct = ObjectFactory.getValidEntity('name');
		ApexPages.currentPage().getParameters().put('EntityId', testAcct.Id);

		ModReqUnitRMController sutDef = new ModReqUnitRMController();
	}

	@IsTest
    static void it_should_get_the_entity_id_from_the_apex_pages_wrapper() {
		mockApexPages.verify('getParameter', new List<Object>{'EntityId'}, Times.Once);
	}

	@IsTest
    static void it_should_set_the_entity_based_on_return_from_data_prov_for_given_id() {
		mockDataProv.verify('getEntity', new List<Object>{testEntityId}, Times.Once);

		System.assertEquals(testEntity, sut.entity);
	}

	@IsTest
    static void it_should_return_null_if_no_branch_on_entity() {
		testEntity.EB_UnitID__c = null;

		System.assertEquals(null, sut.currentBranch);
	}

	@IsTest
    static void it_should_return_branch_on_entity() {
		Id testUnitId = ObjectFactory.getFakeId(EB_Unit__c.SObjectType, '1');
		testEntity.EB_UnitID__c = testUnitId;

		System.assertEquals(testUnitId, sut.currentBranch);
	}

	@IsTest
    static void it_should_return_none_if_no_branch_on_entity() {
		EB_Unit__c testUnit = new EB_Unit__c();
		testEntity.EB_UnitID__r = testUnit;
		testEntity.EB_UnitID__r.Name = null;

		System.assertEquals('None', sut.currentBranchName);
	}

	@IsTest
    static void it_should_return_branch_name_from_branch_on_entity() {
		EB_Unit__c testUnit = new EB_Unit__c();
		testEntity.EB_UnitID__r = testUnit;
		testEntity.EB_UnitID__r.Name = 'Test Loc';

		System.assertEquals('Test Loc', sut.currentBranchName);
	}

	@IsTest
    static void it_should_return_name_of_owner_on_entity() {
		ObjectFactory.getUser('Test', 'RelMan', 'testRM@enterprisebank.com.test123', true);
		User testUser = ObjectFactory.getUser('TRelMan');
		testEntity.Owner = testUser;

		System.assertEquals('Test RelMan', sut.currentRelationshipManager);
	}

	@IsTest
    static void it_should_return_default_approver_from_config_if_no_relationship_oversight_for_unit() {
		Id fakeUserIdFromConfig = ObjectFactory.getFakeId(User.SObjectType, '2');
		mockConfig.setup('getDefaultRelationshipOversightApprover').returns(fakeUserIdFromConfig);
		EB_Unit__c testUnit = new EB_Unit__c();
		testEntity.EB_UnitID__r = testUnit;
		testEntity.EB_UnitID__r.Relationship_Oversight__c = null;

		System.assertEquals(fakeUserIdFromConfig, sut.firstApproverId);
	}

	@IsTest
    static void it_should_return_id_of_relationship_oversight_from_branch_on_entity() {
		Id fakeUserId = ObjectFactory.getFakeId(User.SObjectType, '1');
		EB_Unit__c testUnit = new EB_Unit__c();
		testEntity.EB_UnitID__r = testUnit;
		testEntity.EB_UnitID__r.Relationship_Oversight__c = fakeUserId;

		System.assertEquals(fakeUserId, sut.firstApproverId);
	}

	@IsTest
    static void it_should_return_true_if_the_mod_branch_parameter_from_apex_pages_is_true() {
		mockApexPages.setup('getParameter', new List<Object>{'modBranch'}).returns('true');

		Boolean returnForTrue = sut.defaultModifyBranch;

		System.assertEquals(true, returnForTrue);
	}

	@IsTest
    static void it_should_return_false_if_the_mod_branch_parameter_from_apex_pages_is_not_true() {
		mockApexPages.setup('getParameter', new List<Object>{'modBranch'}).returns('');

		Boolean returnForFalse = sut.defaultModifyBranch;
	
		System.assertEquals(false, returnForFalse);
	}

	@IsTest
    static void it_should_return_true_if_the_mod_rm_parameter_from_apex_pages_is_true() {
		mockApexPages.setup('getParameter', new List<Object>{'modRM'}).returns('true');

		Boolean returnForTrue = sut.defaultModifyRM;

		System.assertEquals(true, returnForTrue);
	}

	@IsTest
    static void it_should_return_false_if_the_mod_rm_parameter_from_apex_pages_is_not_true() {
		mockApexPages.setup('getParameter', new List<Object>{'modRM'}).returns('');

		Boolean returnForFalse = sut.defaultModifyRM;
	
		System.assertEquals(false, returnForFalse);
	}


	@IsTest
    static void it_should_get_the_name_of_the_entity() {
		ObjectFactory.getValidEntity('name');
		Account testAcct = [SELECT Name FROM Account LIMIT 1];
		
		sut.entity = testAcct;

		System.assertEquals(testAcct.Name, sut.modificationRequestName);
	}

	private class MockofIModReqUnitRMControllerDataProv extends ApexMoq implements ModReqUnitRMControllerDataProv.IModReqUnitRMControllerDataProv {
		public Account getEntity(Id entityId){
			return (Account)handleMethodInvocation('getEntity', new List<Object>{entityId});
		}
	}
}