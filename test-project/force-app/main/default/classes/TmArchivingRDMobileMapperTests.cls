@IsTest
private class TmArchivingRDMobileMapperTests {

    private static final TmArchivingRemoteDepositMobileMapper sut;
	private static final TmArchivingMock.ofIMapperHelper mockHelper;
	private static final TmArchivingMock.ofIConfiguration mockConfiguration;

	static {
		mockHelper = new TmArchivingMock.ofIMapperHelper();
		mockConfiguration = new TmArchivingMock.ofIConfiguration();
		sut = new TmArchivingRemoteDepositMobileMapper(mockHelper,mockConfiguration);
	}

    @IsTest
    static void it_should_handle_positive_pay() {
		String productName = 'lelrkwwer';
		mockConfiguration.setup('RECORDTYPE_REMOTE_DEPOSIT').returns(productName);

		String result = sut.handle();

		mockConfiguration.verify('RECORDTYPE_REMOTE_DEPOSIT', Times.Once);
		System.assertEquals(productName ,result);
	}

    @IsTest
    static void it_should_not_build_tm_service() {
		TmArchiving.MapperRequestContainer container = new TmArchiving.MapperRequestContainer();
        container.Pm = new TmBoarding.RequestPm();
        TM_Service_Request__c request = new TM_Service_Request__c();
        request.RemoteDeposit_Mobile__c = false;

        container.Pm.requestPm = request;

        Treasury_Management__c results = sut.buildTmService(container);

        System.assertEquals(null, results);
    }

    @IsTest
    static void it_should_build_tm_service() {
        TmArchiving.MapperRequestContainer container = new TmArchiving.MapperRequestContainer();
        container.Pm = new TmBoarding.RequestPm();
        TM_Service_Request__c request = new TM_Service_Request__c();
        request.RemoteDeposit_Mobile__c = true;
        request.Lending_Relationship__c = 'Yes';
        container.Pm.requestPm = request;

        Treasury_Management__c tms = new Treasury_Management__c();

        String remoteDeposit = 'sdfwerwet';
        String remoteDepositMobile = 'sfwerwt3454';

        mockHelper.setup('compare', new List<Object>{'Yes', 'yes'}).returns(true);
        mockConfiguration.setup('RECORDTYPE_REMOTE_DEPOSIT').returns(remoteDeposit);
        mockConfiguration.setup('REMOTE_DEPOSIT_MOBILE').returns(remoteDepositMobile);
        mockHelper.setup('buildTMObject', new List<Object>{container, remoteDeposit}).returns(tms);

        Treasury_Management__c results = sut.buildTmService(container);

        System.assertNotEquals(null, results);
        System.assertEquals(remoteDepositMobile, results.Product_PL__c);
        System.assertEquals(true, results.Lending_Relationship__c);
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
		ar.Product_Fee_Account__c = true;
		Tmboarding.RequestPm pm = new Tmboarding.RequestPm();
		pm.serviceAccountPms = new List<Tm_Service_Request_Account__c>{ar};
		Treasury_Management__c tm = new Treasury_Management__c();

		List<EB_Account_Service__c> result = sut.buildAccounts(pm, tm);

		System.assertEquals(1, result.size());
        System.assertEquals(true, result[0].Product_Fee_Account__c);
	}

	@IsTest
    static void INTEGRATION_Soql_Test() {
		List<string> result = TmArchivingMock.getErrorsOnRunningSoql(sut);
		
		System.assertEquals(0, result.size()); 
	}
}