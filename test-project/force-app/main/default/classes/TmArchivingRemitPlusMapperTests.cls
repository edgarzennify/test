@IsTest
private class TmArchivingRemitPlusMapperTests {

	private static final TmArchivingRemitPlusMapper sut;
	private static final TmArchivingMock.ofIMapperHelper mockHelper;
	private static final TmArchivingMock.ofIConfiguration mockConfig;
    private static final TmArchivingMock.ofIRepository mockRepository;

    static {
    	mockHelper = new TmArchivingMock.ofIMapperHelper();
    	mockConfig = new TmArchivingMock.ofIConfiguration();
        mockRepository = new TmArchivingMock.ofIRepository();
        sut = new TmArchivingRemitPlusMapper(mockHelper, mockConfig, mockRepository);
    }

    @IsTest
    static void it_should_handle_remit_plus() {
    	String product = 'remit-plus';
    	mockConfig.setup('RECORDTYPE_REMIT_PLUS').returns(product);

    	String result = sut.handle();

    	mockConfig.verify('RECORDTYPE_REMIT_PLUS', Times.Once);
    	System.assertEquals(product ,result);
    }

    @IsTest
    static void it_should_build_tm_service_object() {
    	String product = 'remit-plus';
    	TmArchiving.MapperRequestContainer container = new TmArchiving.MapperRequestContainer();
    	container.pm = new TmBoarding.RequestPm();
    	container.pm.requestPm = new Tm_Service_Request__c();
    	Treasury_Management__c tsv = new Treasury_Management__c();
    	Tm_Service_Request_Account__c ta = new Tm_Service_Request_Account__c(Daily_Dollar_Limit__c = 0.0);
    	container.pm.serviceAccountPms = new List<Tm_Service_Request_Account__c>{ta};
    	mockConfig.setup('RECORDTYPE_REMIT_PLUS').returns(product);
    	mockHelper.setup('buildTMObject', new List<Object>{container, product}).returns(tsv);

    	Treasury_Management__c result = sut.buildTmService(container);

    	mockConfig.verify('RECORDTYPE_REMIT_PLUS', Times.Once);
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