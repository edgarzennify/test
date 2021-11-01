@IsTest
private class TmArchivingWiresMapperTests {
	
    private static final TmArchivingWiresMapper sut;
    private static final TmArchivingMock.ofIMapperHelper mockHelper;
	private static final TmArchivingMock.ofIConfiguration mockConfiguration;
    
    static {
       mockHelper = new TmArchivingMock.ofIMapperHelper();
       mockConfiguration = new TmArchivingMock.ofIConfiguration();
       sut = new TmArchivingWiresMapper(mockHelper, mockConfiguration);
    }

    @IsTest
    static void it_should_handle_wires_recordtype() {
    	String product = 'Wires';
    	mockConfiguration.setup('RECORDTYPE_WIRES').returns(product);

    	String result = sut.handle();

    	mockConfiguration.verify('RECORDTYPE_WIRES', Times.Once);
    	System.assertEquals(product ,result);
    }

    @IsTest
    static void it_should_build_tm_service_object() {
    	String product = 'Wires';
    	Treasury_Management__c tmSrv = new Treasury_Management__c();
    	mockConfiguration.setup('RECORDTYPE_WIRES').returns(product);
    	TmArchiving.MapperRequestContainer container = new TmArchiving.MapperRequestContainer();
    	container.pm = new TmBoarding.RequestPm();
    	container.pm.requestPm = new Tm_Service_Request__c(Domestic_Wires__c = true, Wire_Transfer_Fee__c = true);
    	mockHelper.setup('buildTMObject', new List<Object>{container, product}).returns(tmSrv);

    	Treasury_Management__c result = sut.buildTmService(container);

    	mockHelper.verify('buildTMObject', new List<Object>{container, product}, Times.Once);
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
		List<string> result = TmArchivingMock.getErrorsOnRunningSoql(sut);
		
		System.assertEquals(0, result.size()); 
	}
}