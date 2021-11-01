@IsTest
private class TmArchivingOnlineBankingMapperTests {

	private static TmArchivingOnlineBankingMapper sut;
    private static final TmArchivingMock.ofIMapperHelper mockHelper;
	private static final TmArchivingMock.ofIConfiguration mockConfig;
	private static final TmArchivingMock.ofIOnlineBankingMapperHelper mockOnlineBkHelper; 

	static {
		mockHelper = new TmArchivingMock.ofIMapperHelper();
		mockConfig = new TmArchivingMock.ofIConfiguration();
		mockOnlineBkHelper = new TmArchivingMock.ofIOnlineBankingMapperHelper();
		sut = new TmArchivingOnlineBankingMapper(mockHelper, mockConfig, mockOnlineBkHelper);
	}

	@IsTest
    static void it_should_return_true_when_calling_handle() {
		String productName = 'Lockbox';
		mockConfig.setup('RECORDTYPE_ONLINE_BANKING').returns(productName);

		String result = sut.handle();

		mockConfig.verify('RECORDTYPE_ONLINE_BANKING', Times.Once);
		System.assertEquals(productName, result);
	}

	@IsTest
    static void it_should_map_fields_for_tm_service() {
		TmBoarding.RequestPm pm = new TmBoarding.RequestPm();
		pm.entityPm = new Account();
		String recordTypeName = 'Commercial Online Banking';
		pm.entityPm.Id = ObjectFactory.getFakeId(Account.SObjectType, '1');
		RecordType r = Utility.recordTypeObject('Treasury_Management__c', recordTypeName);
		List<RecordType> recordTypes = new List<RecordType> {r};
		Tm_Service_Request__c objRequest = new Tm_Service_Request__c();
		pm.requestPm = objRequest;
		TmArchiving.MapperRequestContainer container = new TmArchiving.MapperRequestContainer();
		container.Pm = pm;
		container.RecordTypes = recordTypes;
		Treasury_Management__c tm = new Treasury_Management__c();
		tm.RecordTypeId = r.Id;
		tm.Product_PL__c = 'Commercial Online Banking';
		tm.Account__c = pm.entityPm.Id;
		mockHelper.setup('buildTMObject', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(tm);
		mockConfig.setup('RECORDTYPE_ONLINE_BANKING').returns(recordTypeName);
		
		Treasury_Management__c result = sut.buildTmService(container);

		mockHelper.verify('buildTMObject', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
		List<Object> arguments = mockHelper.getArgumentsFromCall('buildTMObject');
		TmArchiving.MapperRequestContainer arg0 = (TmArchiving.MapperRequestContainer)arguments[0];
		String arg1 = (string)arguments[1];
		System.assertNotEquals(null, result);
		System.assertEquals(r.Id, result.RecordTypeId);
		System.assertEquals('Commercial Online Banking', result.Product_PL__c);
		System.assertEquals(pm.entityPm.Id, result.Account__c);
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
    static void INTEGRATION_Soql_Test(){
		List<string> result = TmArchivingMock.getErrorsOnRunningSoql(sut);
		
		System.assertEquals(0, result.size()); 
	}
}