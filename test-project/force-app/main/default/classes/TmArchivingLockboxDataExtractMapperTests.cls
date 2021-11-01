@IsTest
private class TmArchivingLockboxDataExtractMapperTests {
	
	private static final TmArchivingLockboxDataExtractMapper sut;
	private static final TmArchivingMock.ofIMapperHelper mockHelper;
	private static final TmArchivingMock.ofIConfiguration mockConfig; 

	static {
		mockHelper = new TmArchivingMock.ofIMapperHelper();
		mockConfig = new TmArchivingMock.ofIConfiguration();
		sut = new TmArchivingLockboxDataExtractMapper(mockHelper,mockConfig);
	}

	@IsTest
    static void it_should_return_true_when_calling_handle() {
		String productName = 'Lockbox';
		mockConfig.setup('RECORDTYPE_LOCKBOX').returns(productName);

		String result = sut.handle();

		System.assertEquals(productName, result);
	}

	@IsTest
    static void it_should_map() {
		TmBoarding.RequestPm pm = new TmBoarding.RequestPm();
		Id ebAccountId = ObjectFactory.getFakeID(Eb_Account__c.SOBjectType, '1');
		pm.entityPm = new Account();
		pm.entityPm.Id = ObjectFactory.getFakeId(Account.SObjectType, '1');
		String recordTypeName = 'Lockbox';
		String product = 'Lockbox - Data Extract Module';
		RecordType r = Utility.recordTypeObject('Treasury_Management__c', recordTypeName);
		List<RecordType> recordTypes = new List<RecordType> {r};

		Tm_Service_Request__c objRequest = new Tm_Service_Request__c();
		objRequest.PO_Box_Number__c = 'STL - 790379';
		objRequest.Notes__c = 'test';
		objRequest.Data_Extract__c = true;
		pm.requestPm = objRequest;
		TmArchiving.MapperRequestContainer container = new TmArchiving.MapperRequestContainer();
		container.Pm = pm;
		container.RecordTypes = recordTypes;
		Treasury_Management__c tm = new Treasury_Management__c();
		tm.RecordTypeId = r.Id;
		tm.Product_PL__c = product;
		tm.Account__c = pm.entityPm.Id;
		mockHelper.setup('buildTMObject', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(tm);
		mockConfig.setup('RECORDTYPE_LOCKBOX').returns(recordTypeName);
		mockConfig.setup('RECORDTYPE_LOCKBOX_DATA_EXTRACT_MODULE').returns(product);
		mockHelper.setup('getFeeAccount', new List<Object>{container.pm.serviceAccountPms}).returns(ebAccountId);
		mockHelper.setup('annualFee',new List<Object>{objRequest.Lockbox_Monthly_Maintenance_Fee__c}).returns(10.00);
		
		Treasury_Management__c result = sut.buildTmService(container);

		mockHelper.verify('buildTMObject', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
		List<Object> arguments = mockHelper.getArgumentsFromCall('buildTMObject');
		TmArchiving.MapperRequestContainer arg0 = (TmArchiving.MapperRequestContainer)arguments[0];
		String arg1 = (string)arguments[1];
		System.assertNotEquals(null, result);
		System.assertEquals(container, arg0);
		System.assertEquals(recordTypeName, arg1);
		System.assertEquals(r.Id, result.RecordTypeId);
		System.assertEquals('Lockbox - Data Extract Module', result.Product_PL__c);
		System.assertEquals('STL - 790379', result.PO_Box_Number__c);
		System.assertEquals(pm.entityPm.Id, result.Account__c);
		System.assertEquals('test', result.Service_Notes__c);
	}

	@IsTest
    static void it_should_return_null_when_data_extract_is_not_checked() {
		String recordTypeName = 'Lockbox';
		String product = 'Lockbox - Data Extract Module'; 
		TmBoarding.RequestPm pm = new TmBoarding.RequestPm();
		pm.entityPm = new Account();
		pm.entityPm.Id = ObjectFactory.getFakeId(Account.SObjectType, '1');
		RecordType r = Utility.recordTypeObject('Treasury_Management__c', 'Lockbox');
		List<RecordType> recordTypes = new List<RecordType> {r};

		Tm_Service_Request__c objRequest = new Tm_Service_Request__c();
		objRequest.PO_Box_Number__c = 'STL - 790379';
		objRequest.Data_Entry__c = true;
		objRequest.Data_Extract__c = false;
		objRequest.Remittance_Imaging__c = true;
		objRequest.Data_Entry_Fields__c = 'rrerettt';
		pm.requestPm = objRequest;
		TmArchiving.MapperRequestContainer container = new TmArchiving.MapperRequestContainer();
		container.Pm = pm;
		container.RecordTypes = recordTypes;
		mockConfig.setup('RECORDTYPE_LOCKBOX').returns(recordTypeName);
		mockConfig.setup('RECORDTYPE_LOCKBOX_DATA_EXTRACT_MODULE').returns(product);
		
		Treasury_Management__c result = sut.buildTmService(container);

		System.assertEquals(null, result);
	}

	@IsTest
    static void it_should_build_service_contacts() {
		Contact c = new Contact();
		TmBoarding.RequestPm pm = new TmBoarding.RequestPm();
		Treasury_Management__c tm = new Treasury_Management__c();
		Tm_Service_Request_Contact__c cr = new Tm_Service_Request_Contact__c(Contact__r = c, Contact__c = c.Id);

		pm.serviceContactPms = new List<Tm_Service_Request_Contact__c>{cr};

		List<TM_Service_Contact__c> result = sut.buildContacts(pm, tm);

		System.assertEquals(1, result.size());
		System.assertEquals(c.Id, result[0].Contact__c);
	}

	@IsTest
    static void it_should_build_service_accounts() {
		Eb_Account__c a = new Eb_Account__c(Fee_Master_Account__c = true);
		Tm_Service_Request_Account__c ar = new Tm_Service_Request_Account__c();
		ar.Eb_Account__r = a;
		ar.Eb_Account__c = a.id;
		ar.Daily_Deposit_Limit__c = 100.00;
		Tmboarding.RequestPm pm = new Tmboarding.RequestPm();
		pm.serviceAccountPms = new List<Tm_Service_Request_Account__c>{ar};
		Treasury_Management__c tm = new Treasury_Management__c();

		List<EB_Account_Service__c> result = sut.buildAccounts(pm, tm);

		System.assertEquals(1, result.size());
		System.assertEquals(tm.id, result[0].TM_Service__c);
	}

	@IsTest
    static void INTEGRATION_Soql_Test() {
		List<String> result = TmArchivingMock.getErrorsOnRunningSoql(sut);		
		System.assertEquals(0, result.size());
	}
}