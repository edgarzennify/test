@IsTest
private class ModReqOfficerControllerTests {
	
	private static final Id testEBAcctId;
	private static final EB_Account__c testEBAcct;
	private static final MockofIModReqOfficerControllerDataProv mockDataProv;
	private static final Mock.ofIApexPages mockApexPages;
	private static final Mock.ofIConfigurations mockConfig;
	private static final ModReqOfficerController sut;

	static {
		testEBAcctId = ObjectFactory.getFakeId(EB_Account__c.SObjectType, '1');
		testEBAcct = new EB_Account__c();
		mockDataProv = new MockofIModReqOfficerControllerDataProv();
		mockDataProv.setup('getEBAccount', new List<Object>{testEBAcctId}).returns(testEBAcct);
		mockApexPages = new Mock.ofIApexPages();
		mockApexPages.setup('getParameter', new List<Object>{'AccountId'}).returns(testEBAcctId);
		mockConfig = new Mock.ofIConfigurations();
		sut = new ModReqOfficerController(mockDataProv, mockApexPages, mockConfig);
	}

	@IsTest
    static void it_should_call_the_default_constructor_without_error() {
		Account testAcct = ObjectFactory.getValidEntity('name');
		EB_Account__c testEBAccount = ObjectFactory.getEBAccount('Test Account','12345',testAcct);
		ApexPages.currentPage().getParameters().put('AccountId', testEBAccount.Id);

		ModReqOfficerController sutDef = new ModReqOfficerController();
	}

	@IsTest
    static void it_should_get_the_eb_acct_id_from_the_apex_pages_wrapper() {
		mockApexPages.verify('getParameter', new List<Object>{'AccountId'}, Times.Once);
	}

	@IsTest
    static void it_should_set_the_ebacct_based_on_return_from_data_prov_for_given_id() {
		mockDataProv.verify('getEBAccount', new List<Object>{testEBAcctId}, Times.Once);

		System.assertEquals(testEBAcct, sut.ebAccount);
	}

	@IsTest
    static void it_should_return_null_if_no_branch_on_entity() {
		testEBAcct.EB_Unit__c = null;

		System.assertEquals(null, sut.currentUnit);
	}

	@IsTest
    static void it_should_return_branch_on_entity() {
		Id testUnitId = ObjectFactory.getFakeId(EB_Unit__c.SObjectType, '1');
		testEBAcct.EB_Unit__c = testUnitId;

		System.assertEquals(testUnitId, sut.currentUnit);
	}

	@IsTest
    static void it_should_return_none_if_no_branch_on_entity() {
		EB_Unit__c testUnit = new EB_Unit__c();
		testEBAcct.EB_Unit__r = testUnit;
		testEBAcct.EB_Unit__r.Name = null;

		System.assertEquals('None', sut.currentUnitName);
	}

	@IsTest
    static void it_should_return_branch_name_from_branch_on_entity() {
		EB_Unit__c testUnit = new EB_Unit__c();
		testEBAcct.EB_Unit__r = testUnit;
		testEBAcct.EB_Unit__r.Name = 'Test Loc';

		System.assertEquals('Test Loc', sut.currentUnitName);
	}

	@IsTest
    static void it_should_return_default_approver_from_config_if_no_relationship_oversight_for_unit() {
		Id fakeUserIdFromConfig = ObjectFactory.getFakeId(User.SObjectType, '2');
		mockConfig.setup('getDefaultRelationshipOversightApprover').returns(fakeUserIdFromConfig);
		EB_Unit__c testUnit = new EB_Unit__c();
		testEBAcct.EB_Unit__r = testUnit;
		testEBAcct.EB_Unit__r.Relationship_Oversight__c = null;

		System.assertEquals(fakeUserIdFromConfig, sut.firstApproverId);
	}

	@IsTest
    static void it_should_return_id_of_relationship_oversight_from_unit_on_acct() {
		Id fakeUserId = ObjectFactory.getFakeId(User.SObjectType, '1');
		EB_Unit__c testUnit = new EB_Unit__c();
		testEBAcct.EB_Unit__r = testUnit;
		testEBAcct.EB_Unit__r.Relationship_Oversight__c = fakeUserId;

		System.assertEquals(fakeUserId, sut.firstApproverId);
	}

	@IsTest
    static void it_should_return_true_if_the_mod_unit_parameter_from_apex_pages_is_true() {
		mockApexPages.setup('getParameter', new List<Object>{'modUnit'}).returns('true');

		Boolean returnForTrue = sut.defaultModifyUnit;

		System.assertEquals(true, returnForTrue);
	}

	@IsTest
    static void it_should_return_false_if_the_mod_unit_parameter_from_apex_pages_is_not_true() {
		mockApexPages.setup('getParameter', new List<Object>{'modUnit'}).returns('');

		Boolean returnForFalse = sut.defaultModifyUnit;
	
		System.assertEquals(false, returnForFalse);
	}

	@IsTest
    static void it_should_return_true_if_the_mod_acct_off_parameter_from_apex_pages_is_true() {
		mockApexPages.setup('getParameter', new List<Object>{'modAcctOff'}).returns('true');

		Boolean returnForTrue = sut.defaultModifyAcctOfficer;

		System.assertEquals(true, returnForTrue);
	}

	@IsTest
    static void it_should_return_false_if_the_mod_acct_off_parameter_from_apex_pages_is_not_true() {
		mockApexPages.setup('getParameter', new List<Object>{'modAcctOff'}).returns('');

		Boolean returnForFalse = sut.defaultModifyAcctOfficer;
	
		System.assertEquals(false, returnForFalse);
	}

	@IsTest
    static void it_should_get_the_name_of_the_eb_account() {
		Account testAcct = ObjectFactory.getValidEntity('name');
		ObjectFactory.getEBAccount('Test Account','12345',testAcct);
		EB_Account__c testEBAccount = [SELECT Name FROM EB_Account__c LIMIT 1];
		
		sut.ebAccount = testEBAccount;

		System.assertEquals(testEBAccount.Name, sut.modificationRequestName);
	}

	private class MockofIModReqOfficerControllerDataProv extends ApexMoq implements ModReqOfficerControllerDataProv.IModReqOfficerControllerDataProv {
		public EB_Account__c getEBAccount(Id ebAccountId){
			return (EB_Account__c)handleMethodInvocation('getEBAccount', new List<Object>{ebAccountId});
		}
	}
}