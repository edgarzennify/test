@IsTest
private class TmArchivingAchFtpMapperTests {
    
    private static final TmArchivingAchFtpMapper sut;
    private static final TmArchivingMock.ofIMapperHelper mockHelper;
	private static final TmArchivingMock.ofIConfiguration mockConfiguration;

    static {
		mockHelper = new TmArchivingMock.ofIMapperHelper();
		mockConfiguration = new TmArchivingMock.ofIConfiguration();
		sut = new TmArchivingAchFtpMapper(mockHelper,mockConfiguration);
	}

    @IsTest
    static void it_should_return_true_when_calling_handle() {
		String productName = 'ACH';
		mockConfiguration.Setup('RECORDTYPE_ACH').returns(productName);

		String result = sut.handle();

		mockConfiguration.Verify('RECORDTYPE_ACH', Times.Once);
		System.assertEquals(productName, result);
	}

    @IsTest
    static void it_should_return_null_if_not_ftp() {
        TmBoarding.RequestPm pm = new TmBoarding.RequestPm();
        pm.requestPm = new Tm_Service_Request__c();
        pm.requestPm.ACH_FTP_Fees__c = false;

        TmArchiving.MapperRequestContainer container = new TmArchiving.MapperRequestContainer();
        container.Pm = pm;

        Treasury_Management__c results = sut.buildTmService(container);

        System.assertEquals(null, results);
    }

    @IsTest
    static void it_should_map_ach_ftp_fields_to_tm_service() {
        TmBoarding.RequestPm pm = new TmBoarding.RequestPm();
        pm.entityPm = new Account();
        pm.entityPm.Id = ObjectFactory.getFakeId(Account.SObjectType, '1');
        String recordTypeName = 'ACH FTP';
        pm.requestPm = new Tm_Service_Request__c();
        pm.requestPm.FTP_of_NACHA_Return_File_Transmission__c = false;
        pm.requestPm.ACH_FTP__c = true;
        pm.requestPm.ACH_Credits__c = true;
        pm.requestPm.ACH_Debits__c = true;

        RecordType r = new RecordType(Name = recordTypeName);
        List<RecordType> recordTypes = new List<RecordType>{r};
        Treasury_Management__c tm = new Treasury_Management__c();
        tm.RecordTypeId = r.Id;
        tm.Account__c = pm.entityPm.Id;
        TmArchiving.MapperRequestContainer container = new TmArchiving.MapperRequestContainer();
        container.Pm = pm;
        container.RecordTypes = recordTypes;
        mockHelper.setup('buildTMObject', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(tm);
        mockConfiguration.setup('SVC_PRODUCT_ACH_FTP').returns(recordTypeName);
        
        Treasury_Management__c results = sut.buildTmService(container);

        List<Object> arguments = (List<Object>)mockHelper.getArgumentsFromCall('buildTMObject');

        mockHelper.verify('buildTMObject', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
        System.assertNotEquals(null, results);
        System.assertEquals('ACH FTP', results.Product_PL__c);
        System.assertEquals(container, (TmArchiving.MapperRequestContainer)arguments[0]);
        System.assertEquals(recordTypeName, (String)arguments[1]);
        System.assertEquals(pm.entityPm.Id, results.Account__c);
    }

    @IsTest
    static void it_should_map_ach_ftp_return_transmission_fields_to_tm_service() {
        TmBoarding.RequestPm pm = new TmBoarding.RequestPm();
        pm.entityPm = new Account();
        pm.entityPm.Id = ObjectFactory.getFakeId(Account.SObjectType, '1');
        String recordTypeName = 'ACH FTP';
        String productTypeName = 'ACH Return';
        pm.requestPm = new Tm_Service_Request__c();
        pm.requestPm.FTP_of_NACHA_Return_File_Transmission__c = true;
        pm.requestPm.ACH_FTP__c = true;
        pm.requestPm.ACH_Credits__c = true;
        pm.requestPm.ACH_Debits__c = true;

        RecordType r = new RecordType(Name = recordTypeName);
        List<RecordType> recordTypes = new List<RecordType>{r};
        Treasury_Management__c tm = new Treasury_Management__c();
        tm.RecordTypeId = r.Id;
        tm.Account__c = pm.entityPm.Id;
        TmArchiving.MapperRequestContainer container = new TmArchiving.MapperRequestContainer();
        container.Pm = pm;
        container.RecordTypes = recordTypes;
        mockHelper.setup('buildTMObject', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(tm);
        mockConfiguration.setup('SVC_PRODUCT_ACH_FTP').returns(recordTypeName);
        mockConfiguration.setup('SVC_PRODUCT_ACH_RETURN_TRANSMISSION').returns(productTypeName);
        
        Treasury_Management__c results = sut.buildTmService(container);

        List<Object> arguments = (List<Object>)mockHelper.getArgumentsFromCall('buildTMObject');

        mockHelper.verify('buildTMObject', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
        System.assertNotEquals(null, results);
        System.assertEquals('ACH Return', results.Product_PL__c);
        System.assertEquals(container, (TmArchiving.MapperRequestContainer)arguments[0]);
        System.assertEquals(recordTypeName, (String)arguments[1]);
        System.assertEquals(pm.entityPm.Id, results.Account__c);
    }

    @IsTest
    static void it_should_call_build_query_fields() {
        Id requestId = ObjectFactory.getFakeId(Tm_Service_Request__c.SObjectType, '1');

        TmArchiving.QueryFields results = sut.build(requestId);

        System.assertNotEquals(null, results);
        System.assertEquals(requestId, results.requestId);
    }

    @IsTest
    static void it_should_build_contacts() {
        TmBoarding.RequestPm pm = new TmBoarding.RequestPm();
        TM_Service_Request_Contact__c contact = new TM_Service_Request_Contact__c();
        contact.Primary_Product_Contact__c = true;
        contact.Secondary_Product_Contact__c= false;
        pm.serviceContactPms = new List<Tm_Service_Request_Contact__c>{contact};
        Treasury_Management__c tm = new Treasury_Management__c();
        tm.Id = ObjectFactory.getFakeId(Treasury_Management__c.SObjectType, '1');
        
        List<TM_Service_Contact__c> results = sut.buildContacts(pm, tm);
        
        System.assertEquals(tm.Id, results[0].Treasury_Management_Service__c);
        System.assertEquals(true, results[0].Primary_Product_Contact__c);
        System.assertEquals(false, results[0].Secondary_Product_Contact__c);
        System.assertEquals(1, results.size());
    }

    @IsTest
    static void it_should_build_accounts() {
        TmBoarding.RequestPm pm = new TmBoarding.RequestPm();
        Treasury_Management__c tm = new Treasury_Management__c();
        Tm_Service_Request__c requestPm = new Tm_Service_Request__c();
        requestPm.ACH_FTP_Module_Fee__c = 29;
        requestPm.TM_Fee__c = true;
        pm.requestPm = requestPm;


        Tm_Service_Request_Account__c account= new Tm_Service_Request_Account__c();
        account.Id = ObjectFactory.getFakeId(Tm_Service_Request_Account__c.SObjectType, '1');
        account.Product_Fee_Account__c = true;

        pm.serviceAccountPms = new List<Tm_Service_Request_Account__c>{account};

        List<EB_Account_Service__c> results = sut.buildAccounts(pm, tm);

        System.assertEquals(tm.Id, results[0].TM_Service__c);
        System.assertEquals(29, results[0].Service_Charge__c);
        System.assertEquals(1, results.size());
    }

    @IsTest
    static void it_should_post_process() {
        List<TmArchiving.TreasuryManagementSm> sms = new List<TmArchiving.TreasuryManagementSm>();
        TmBoarding.RequestPm pm = new TmBoarding.RequestPm();

        List<TmArchiving.TreasuryManagementSm> results = sut.postProcess(sms, pm);

        System.assertEquals(sms, results);
    }

    @IsTest
    static void INTEGRATION_Soql_Test(){
        List<string> result = TmArchivingMock.getErrorsOnRunningSoql(sut);
        
        System.assertEquals(0, result.size());
    }
}