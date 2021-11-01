@IsTest
private class TmArchivingMapperHelperTests {
	
    private static final TmArchivingMapperHelper sut;
    private static final TmConfigurationMock.ofIRepository mockRepository;
    private static final TmArchivingMock.ofIConfiguration mockConfig;
    
    static {
        mockRepository = new TmConfigurationMock.ofIRepository();
        mockConfig = new  TmArchivingMock.ofIConfiguration();
        sut = new TmArchivingMapperHelper(mockRepository, mockConfig);
    }
    
    private static testMethod void it_should_find_recordtype() {
        List<RecordType> pms = new List<RecordType>{
            new RecordType(Name = 'test')
        };

        RecordType result = sut.getRecordType(pms,  'test');
        System.assertEquals('test', result.name);
    }
    
    private static testMethod void it_should_build_tm_object() {
        String recordName = 'Online Banking';
        List<RecordType> pms = new List<RecordType>{
            new RecordType(Name = recordName)
        };
        TmArchiving.MapperRequestContainer container = new TmArchiving.MapperRequestContainer();
        Id requestId = ObjectFactory.getFakeId(Tm_Service_request__c.SObjectType, '1');
        container.recordTypes = pms;
        container.Pm = new TmBoarding.requestPm();
        container.Pm.entityPm = new Account();
        container.Pm.requestPm = new Tm_Service_Request__c(Id=requestId);
        container.Pm.requestPm.RecordType = new RecordType(Name = recordName);
		container.Pm.packetRequestsPm = new List<Tm_Service_Request__c>{container.Pm.requestPm}; 

        mockConfig.setup('RECORDTYPE_ONLINE_BANKING').returns(recordName);
        
        Treasury_Management__c result = sut.buildTMObject(container, recordName);
        
        System.assertEquals(recordName, result.Product_PL__c);
        System.assertEquals(requestId, result.Tm_Service_Request__c);
    }
    
    private static testMethod void it_should_compare() {
        
        boolean result = sut.compare('test', 'test');
        
        System.assertEquals(true, result);
    }

    private static testMethod void it_should_contatenate(){

        String result = sut.concatenate('123456789101112', 10);

        System.assertEquals('1234567891', result);
    }

    private static testMethod void it_should_get_fee_account() {
        Id requestId = ObjectFactory.getFakeId(Tm_Service_Request__c.SObjectType, '1');
        Id ebAccountId = ObjectFactory.getFakeId(Eb_Account__c.SObjectType, '1');
        Eb_Account__c ebAccount = new Eb_Account__c(Id = ebAccountId);
        Tm_Service_Request_Account__c ra = new Tm_Service_Request_Account__c(Tm_Service_Request__c = requestId
            , Eb_Account__c = ebAccountId, Product_Fee_Account__c = true);
        ra.EB_Account__r = ebAccount;
        List<Tm_Service_Request_Account__c> relatedAccounts = new List<Tm_Service_Request_Account__c>{ra};
        
        Id result = sut.getFeeAccount(relatedAccounts);

        System.assertEquals(ebAccountId ,result);
    }

    private static testMethod void it_should_get_sweep_account() {
        Id requestId = ObjectFactory.getFakeId(Tm_Service_Request__c.SObjectType, '1');
        Id ebAccountId = ObjectFactory.getFakeId(Eb_Account__c.SObjectType, '1');
        Eb_Account__c ebAccount = new Eb_Account__c(Id = ebAccountId);
        ebAccount.Fee_Master_Account__c = true;
        Tm_Service_Request_Account__c ra = new Tm_Service_Request_Account__c(Tm_Service_Request__c = requestId, Eb_Account__c = ebAccountId);
        ra.EB_Account__r = ebAccount;
        ra.Sweep_Investment_Account_Number__c = true;
        List<Tm_Service_Request_Account__c> relatedAccounts = new List<Tm_Service_Request_Account__c>{ra};

        Tm_Service_Request_Account__c result = sut.getSweepAccount(relatedAccounts);
    
        System.assertEquals(ra ,result);
    }

    private static testMethod void it_should_get_dollar_limit() {
        TmBoarding.RequestPm r = new TmBoarding.RequestPm();
        Tm_Service_Request_Account__c ra = new Tm_Service_Request_Account__c();
        ra.Daily_Dollar_Limit__c  = 10.25;
        r.serviceAccountPms = new List<Tm_Service_Request_Account__c>{ra};

        Decimal result = sut.getDailyLimit(r);

        System.assertEquals(10.25 , result);
    }

    private static testMethod void it_should_get_loan_accounts() {
        Eb_Account__c a = new Eb_Account__c();
        a.Account_Number__c = '1122-2';
        a.Application__c = 15;
        a.Id = ObjectFactory.getFakeId(Eb_Account__c.SObjectType, '1');
        TmBoarding.RequestPm r = new TmBoarding.RequestPm();
        Tm_Service_Request_Account__c svcAccount = new Tm_Service_Request_Account__c(Eb_Account__r = a);
        svcAccount.EB_Account__c = a.Id;

        r.serviceAccountPms = new List<Tm_Service_Request_Account__c>{svcAccount};

        Eb_Account__c result = sut.getLoanAccount(r);

        System.assertEquals(15, result.Application__c);
    }

    private static testMethod void it_should_get_primary_contact() {
        Contact c = new Contact();
        Tm_Service_Request_Contact__c cr = new Tm_Service_Request_Contact__c(Contact__r = c);
        cr.Contact__c = c.Id;
        cr.Primary_Product_Contact__c = true;

        Contact result = sut.getPrimaryContact(new List<Tm_Service_Request_Contact__c>{cr});

        System.assertEquals(c.Id, result.Id);
    }

     private static testMethod void it_should_get_secondary_contact() {
        Contact c = new Contact();
        Tm_Service_Request_Contact__c cr = new Tm_Service_Request_Contact__c(Contact__r = c);
        cr.Contact__c = c.Id;
        cr.Secondary_Product_Contact__c = true;

        Contact result = sut.getSecondaryContact(new List<Tm_Service_Request_Contact__c>{cr});

        System.assertEquals(c.Id, result.Id);
    }
}