@IsTest
private class TmArchivingZbaMapperTests {

	private static TmArchivingZbaMapper sut;
	private static final TmArchivingMock.ofIMapperHelper mockHelper;
	private static final TmArchivingMock.ofIZbaMapperHelper mockZbaMapperHelper;
	private static final TmArchivingMock.ofIConfiguration mockConfiguration;

	static {
		mockHelper = new TmArchivingMock.ofIMapperHelper();
		mockZbaMapperHelper = new TmArchivingMock.ofIZbaMapperHelper();
		mockConfiguration = new TmArchivingMock.ofIConfiguration();
		sut = new TmArchivingZbaMapper(mockHelper, mockZbaMapperHelper, mockConfiguration);
	}

	@IsTest
    static void it_should_return_true_when_calling_handle() {
		String productName = 'ZBA';
		mockConfiguration.setup('RECORDTYPE_ZBA').returns(productName);

		String result = sut.handle();

		mockConfiguration.verify('RECORDTYPE_ZBA', Times.Once);
		System.assertEquals(productName, result);
	}

	@IsTest
    static void it_should_map_fields_for_TM_service() {
		TmBoarding.RequestPm pm = new TmBoarding.RequestPm();
		pm.entityPm = new Account();
		pm.entityPm.Id = ObjectFactory.getFakeId(Account.SObjectType, '1');
		pm.requestPm = new Tm_Service_Request__c();
		String recordTypeName = 'ZBA';
		RecordType r = Utility.recordTypeObject('Treasury_Management__c', recordTypeName);
		List<RecordType> recordTypes = new List<RecordType> {r};
		Treasury_Management__c tm = new Treasury_Management__c();
		tm.RecordTypeId = r.Id;
		tm.Product_PL__c = r.Name;
		tm.Account__c = pm.entityPm.Id;
		TmArchiving.MapperRequestContainer container = new TmArchiving.MapperRequestContainer();
		container.Pm = pm;
		container.RecordTypes = recordTypes;
		mockHelper.setup('buildTMObject', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(tm);

		Treasury_Management__c result = sut.buildTmService(container);

		List<Object> arguments = (List<Object>)mockHelper.getArgumentsFromCall('buildTMObject');
		mockHelper.verify('buildTMObject', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);		
		System.assertNotEquals(null, result);
		System.assertEquals(r.Id, result.RecordTypeId);
		System.assertEquals('ZBA', result.Product_PL__c);
		System.assertEquals((TmArchiving.MapperRequestContainer)arguments[0], container);
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
        pm.requestpm = new Tm_Service_Request__c();
        pm.requestPm.ZBA_Monthly_Maintenance_Fee__c = 50;
		pm.requestPM.TM_Fee__c = true;
        pm.serviceAccountPms = new List<Tm_Service_Request_Account__c>{ar};
        Treasury_Management__c tm = new Treasury_Management__c();

        List<EB_Account_Service__c> result = sut.buildAccounts(pm, tm);

        System.assertEquals(1, result.size());
        System.assertEquals(tm.id, result[0].TM_Service__c);
        System.assertEquals(50.0, result[0].Service_Charge__c);
    }

	@IsTest
    static void INTEGRATION_Soql_Test() {
		List<string> result = TmArchivingMock.getErrorsOnRunningSoql(sut);
		
		System.assertEquals(0, result.size()); 
	}
}