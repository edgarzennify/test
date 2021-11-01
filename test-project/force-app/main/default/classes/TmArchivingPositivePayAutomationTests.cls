@IsTest
private class TmArchivingPositivePayAutomationTests {
    
    private static final TmArchivingPositivePayAutomationMapper sut;
    private static final TmArchivingMock.ofIMapperHelper mockHelper;
    private static final TmArchivingMock.ofIConfiguration mockConfiguration;

    static {
        mockHelper = new TmArchivingMock.ofIMapperHelper();
        mockConfiguration = new TmArchivingMock.ofIConfiguration();
        sut = new TmArchivingPositivePayAutomationMapper(mockHelper, mockConfiguration);
    }

    @IsTest
    static void it_should_handle() {
        String positivePay = 'pospay';
        mockConfiguration.setup('RECORDTYPE_POSITIVE_PAY').returns(positivePay);

        String results = sut.handle();

        mockConfiguration.verify('RECORDTYPE_POSITIVE_PAY', Times.Once);
        System.assertEquals(positivePay, results);
    }

    @IsTest
    static void it_should_not_build_tm_service() {
        String positivePay = 'pospay';

        Treasury_Management__c tms = new Treasury_Management__c();

        TmArchiving.MapperRequestContainer container = new TmArchiving.MapperRequestContainer();
        TM_Service_Request__c request = new TM_Service_Request__c();
        request.Automated_File_Creation_Set_Up__c = false;

        container.Pm = new TmBoarding.RequestPm();
        container.Pm.requestPm = request;

        mockConfiguration.setup('RECORDTYPE_POSITIVE_PAY').returns(positivePay);
        mockHelper.setup('buildTMObject', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(tms);

        Treasury_Management__c results = sut.buildTmService(container);

        System.assertEquals(null, results);
    }

    @IsTest
    static void it_should_return_service_when_conventional() {
        String positivePay = 'pospay';
        String productPositivePay = 'fsdfwer';
        String conventional = 'conventional';
        String otherSoftware = 'a34554';

        Treasury_Management__c tms = new Treasury_Management__c();
        Account account = new Account();
        tms.Account__r = account;

        TmArchiving.MapperRequestContainer container = new TmArchiving.MapperRequestContainer();
        TM_Service_Request__c request = new TM_Service_Request__c();
        request.Automated_File_Creation_Set_Up__c = true;
        request.Positive_Pay_Type__c = conventional;
        request.Conventional_Positive_Pay_Fee__c = 34;
        request.Conventional_PP_Per_Items_Fee__c = 36;
        request.Conventional_PP_Exception_Items_Fee__c = 99;
        request.Accounting_Software_Type__c = otherSoftware;
        request.Other_Software__c = 'other';
        request.TM_Fee__c = true;

        container.Pm = new TmBoarding.RequestPm();
        container.Pm.requestPm = request;

        mockConfiguration.setup('RECORDTYPE_POSITIVE_PAY').returns(positivePay);
        mockConfiguration.setup('CONVENTIONAL').returns(conventional);
        mockConfiguration.setup('OTHER').returns(otherSoftware);
        mockConfiguration.setup('SVC_PRODUCT_POSITIVE_PAY_AUTOMATION').returns(productPositivePay);
        mockHelper.setup('buildTMObject', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(tms);
        mockHelper.setup('compare', new List<Object>{conventional, conventional}).returns(true);
        mockHelper.setup('compare', new List<Object>{otherSoftware.toLowerCase(), otherSoftware.toLowerCase()}).returns(true);

        Treasury_Management__c results = sut.buildTmService(container);

        System.assertNotEquals(null, results);
        System.assertEquals(productPositivePay, results.Product_PL__c);
        mockConfiguration.verify('RECORDTYPE_POSITIVE_PAY', Times.Once);
        mockConfiguration.verify('OTHER', Times.Once);
        mockConfiguration.verify('SVC_PRODUCT_POSITIVE_PAY_AUTOMATION', Times.Once);
        System.assertEquals(34, results.Positive_Pay_Actual__c);
        System.assertEquals(36, results.Per_Item_Fee_Actual__c);
        System.assertEquals(99, results.Exception_Items_Actual__c);
        System.assertEquals('other', results.Account__r.Accounting_Package__c);
    }

    @IsTest
    static void it_should_return_service_when_conventional_custom() {
        String positivePay = 'pospay';
        String productPositivePay = 'fsdfwer';
        String conventional = 'sdfwert';
        String otherSoftware = 'a34554';

        Treasury_Management__c tms = new Treasury_Management__c();
        Account account = new Account();
        tms.Account__r = account;

        TmArchiving.MapperRequestContainer container = new TmArchiving.MapperRequestContainer();
        TM_Service_Request__c request = new TM_Service_Request__c();
        request.Automated_File_Creation_Set_Up__c = true;
        request.Positive_Pay_Type__c = conventional;
        request.Conventional_Positive_Pay_Fee_Custom__c = 34;
        request.Conventional_PP_Per_Items_Fee_Custom__c = 36;
        request.Conventional_PP_Exception_Items_Custom__c = 99;
        request.Accounting_Software_Type__c = otherSoftware;
        request.Other_Software__c = 'other';
        request.Custom_Fee__c = true;

        container.Pm = new TmBoarding.RequestPm();
        container.Pm.requestPm = request;

        mockConfiguration.setup('RECORDTYPE_POSITIVE_PAY').returns(positivePay);
        mockConfiguration.setup('CONVENTIONAL').returns(conventional);
        mockConfiguration.setup('OTHER').returns(otherSoftware);
        mockConfiguration.setup('SVC_PRODUCT_POSITIVE_PAY_AUTOMATION').returns(productPositivePay);
        mockHelper.setup('buildTMObject', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(tms);
        mockHelper.setup('compare', new List<Object>{conventional, conventional}).returns(true);
        mockHelper.setup('compare', new List<Object>{otherSoftware.toLowerCase(), otherSoftware.toLowerCase()}).returns(true);

        Treasury_Management__c results = sut.buildTmService(container);

        System.assertNotEquals(null, results);
        System.assertEquals(productPositivePay, results.Product_PL__c);
        mockConfiguration.verify('RECORDTYPE_POSITIVE_PAY', Times.Once);
        mockConfiguration.verify('OTHER', Times.Once);
        mockConfiguration.verify('SVC_PRODUCT_POSITIVE_PAY_AUTOMATION', Times.Once);
        System.assertEquals(34, results.Positive_Pay_Actual__c);
        System.assertEquals(36, results.Per_Item_Fee_Actual__c);
        System.assertEquals(99, results.Exception_Items_Actual__c);
        System.assertEquals('other', results.Account__r.Accounting_Package__c);
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
    static void it_should_build_accounts_with_service_charge_zero() {
        TmBoarding.RequestPm pm = new TmBoarding.RequestPm();
        Treasury_Management__c tm = new Treasury_Management__c();
        Tm_Service_Request__c requestPm = new Tm_Service_Request__c();
        tm.Positive_Pay_Actual__c = 29;
        pm.requestPm = requestPm;

        Tm_Service_Request_Account__c account= new Tm_Service_Request_Account__c();
        account.Id = ObjectFactory.getFakeId(Tm_Service_Request_Account__c.SObjectType, '1');
        account.Product_Fee_Account__c = false;

        pm.serviceAccountPms = new List<Tm_Service_Request_Account__c>{account};

        List<EB_Account_Service__c> results = sut.buildAccounts(pm, tm);

        System.assertEquals(tm.Id, results[0].TM_Service__c);
        System.assertEquals(0.0, results[0].Service_Charge__c);
        System.assertEquals(1, results.size());
    }

    @IsTest
    static void it_should_build_accounts_with_service_charge_not_zero() {
        TmBoarding.RequestPm pm = new TmBoarding.RequestPm();
        Treasury_Management__c tm = new Treasury_Management__c();
        Tm_Service_Request__c requestPm = new Tm_Service_Request__c();
        tm.Positive_Pay_Actual__c = 29;
        pm.requestPm = requestPm;
        pm.requestPm.Conventional_Positive_Pay_Fee__c = 29;
        pm.requestPm.TM_Fee__c = true;

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