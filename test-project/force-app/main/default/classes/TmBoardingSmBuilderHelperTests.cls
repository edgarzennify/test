@IsTest
private class TmBoardingSmBuilderHelperTests {
	
    private static TmBoardingSmBuilderHelper sut;
    private static final TmBoardingMock.ofISmExtractor mockExtractor;
    private static final TmBoardingMock.ofIFieldMapManager mockFieldMapper;
    private static final Mock.ofIUtility mockUtil;
    
    static {
        mockExtractor = new TmBoardingMock.ofISmExtractor();
        mockFieldMapper = new TmBoardingMock.ofIFieldMapManager();
        mockUtil = new Mock.ofIUtility();
        sut = new TmBoardingSmBuilderHelper(mockExtractor, mockFieldMapper, mockUtil);
    }
    
    private static testMethod void it_should_build_service_contacts() {
        Id requestId = ObjectFactory.getFakeId(Tm_service_Request__c.SObjectType, '1');
        Id contact1Id = ObjectFactory.getFakeId(Contact.SObjectType, '1');
        Id contact2Id = ObjectFactory.getFakeId(Contact.SObjectType, '2');
        TmBoarding.RelatedSm relatedSm = new TmBoarding.RelatedSm();
        
        List<TmBoarding.SaveSm> sms = new List<TmBoarding.SaveSm>();
        TmBoarding.RequestConfigPm metadata = new TmBoarding.RequestConfigPm();
        TmBoarding.RequestPm pm = new TmBoarding.RequestPm();
        Tm_service_Request__c req = new Tm_service_Request__c(Id=requestId);
        Contact c1 = new Contact(Id=contact1Id);
        Contact c2 = new Contact(Id=contact2Id);
        Tm_Service_Request_Contact__c serviceContact = new Tm_Service_Request_Contact__c();
        serviceContact.TM_Service_Request__c = req.Id;
        serviceContact.Contact__c = c2.Id;
        List<Contact> contacts= new List<Contact>{c1, c2};
        pm.requestPm = req;
        pm.contactPms = contacts;
        pm.serviceContactPms = new List<Tm_Service_Request_Contact__c>{serviceContact};
        Map<String, Object> selectedContact1 = new Map<String, Object>{c1.Id => true};
        Map<String, Object> selectedContact2 = new Map<String, Object>{c2.Id => false};
        TmBoarding.coreSm coreSm = new TmBoarding.CoreSm();
        coreSm.request = req;
        coreSm.contacts = contacts;
        mockExtractor.setup('getSelectedFields', new List<Object>{c1.Id, sms}).returns(selectedContact1);
        mockExtractor.setup('getSelectedFields', new List<Object>{c2.Id, sms}).returns(selectedContact2);
        
        TmBoarding.RelatedSm result = sut.buildServiceContacts(relatedSm, coreSm, sms, metadata, pm);

        System.assertEquals(1, result.contactRelationships.size());
        System.assertEquals(1, result.deleteContactRelationships.size());
    }

    private static testMethod void it_should_build_new_service_contact() {
        Id requestId = ObjectFactory.getFakeId(Tm_service_Request__c.SObjectType, '1');
        Id contactId = ObjectFactory.getFakeId(Contact.SObjectType, '1');

        Tm_service_Request__c req = new Tm_service_Request__c(Id = requestId);
        Contact c = new Contact(Id = contactId);
        List<Contact> contacts = new List<Contact>{c};
        TmBoarding.relatedSm relatedSm = new TmBoarding.relatedSm();
        List<TmBoarding.SaveSm> sms = new List<TmBoarding.SaveSm>();
        TmBoarding.RequestConfigPm metadata = new TmBoarding.RequestConfigPm();
        TmBoarding.RequestPm pm = new TmBoarding.RequestPm();
        pm.requestPm = req;
        pm.contactPms = contacts;

        Map<String, List<TmBoarding.SaveSm>> requestContactSms = new Map<String, List<TmBoarding.SaveSm>>{c.Id => sms};

        mockExtractor.setup('getNewObjectsByParentId', new List<Object>{'tm_service_request_contact__c', sms}).returns(requestContactSms);

        List<TM_Service_Request_Contact__c> result = sut.buildNewServiceRequestContact(relatedSm, sms, metadata, pm);
    
        System.assertEquals(1, result.size());
    }

    private static testMethod void it_should_build_new_service_accounts() {
        Id requestId = ObjectFactory.getFakeId(Tm_service_Request__c.SObjectType, '1');
        Id accountId = ObjectFactory.getFakeId(Eb_Account__c.SObjectType, '1');

        Tm_service_Request__c req = new Tm_service_Request__c(Id = requestId);
        Eb_Account__c eba = new Eb_Account__c(Id = accountId);
        List<Eb_Account__c> accounts = new List<Eb_Account__c>{eba};
        TmBoarding.relatedSm relatedSm = new TmBoarding.relatedSm();
        List<TmBoarding.SaveSm> sms = new List<TmBoarding.SaveSm>();
        TmBoarding.RequestConfigPm metadata = new TmBoarding.RequestConfigPm();
        TmBoarding.RequestPm pm = new TmBoarding.RequestPm();
        pm.requestPm = req;
        pm.accountPms = accounts;

        Map<String, List<TmBoarding.SaveSm>> requestAccountSms = new Map<String, List<TmBoarding.SaveSm>>{eba.Id => sms};

        mockExtractor.setup('getNewObjectsByParentId', new List<Object>{'tm_service_request_account__c', sms}).returns(requestAccountSms);

        List<TM_Service_Request_Account__c> result = sut.buildNewServiceRequestAccount(relatedSm, sms, metadata, pm);
        
        System.assertEquals(1, result.size());
    }

    private static testMethod void it_should_build_existing_service_accounts() {
        Id requestId = ObjectFactory.getFakeId(Tm_service_Request__c.SObjectType, '1');
        Id account1Id = ObjectFactory.getFakeId(Eb_Account__c.SObjectType, '1');
        Id account2Id = ObjectFactory.getFakeId(Eb_Account__c.SObjectType, '2');

        Tm_service_Request__c req = new Tm_service_Request__c(Id = requestId);
        Eb_Account__c eba1 = new Eb_Account__c(Id = account1Id);
        Eb_Account__c eba2 = new Eb_Account__c(Id = account2Id);
        List<Eb_Account__c> accounts = new List<Eb_Account__c>{eba1, eba2};
        TmBoarding.relatedSm relatedSm = new TmBoarding.relatedSm();
        List<TmBoarding.SaveSm> sms = new List<TmBoarding.SaveSm>();
        TmBoarding.RequestConfigPm metadata = new TmBoarding.RequestConfigPm();
        TmBoarding.RequestPm pm = new TmBoarding.RequestPm();
        TM_Service_Request_Account__c serviceAccount = new TM_Service_Request_Account__c();
        serviceAccount.TM_Service_Request__c = req.Id;
        serviceAccount.EB_Account__c = eba2.Id;
        pm.requestPm = req;
        pm.accountPms = accounts;
        pm.serviceAccountPms = new List<TM_Service_Request_Account__c>{serviceAccount};

        TmBoarding.CoreSm coreSm = new TmBoarding.CoreSm();
        coreSm.request = req;
        coreSm.accounts = accounts;
 
        Map<String, Object> selectedFields1 = new Map<String, Object>{eba1.Id => true};
        mockExtractor.setup('getSelectedFields', new List<Object>{eba1.Id, sms}).returns(selectedFields1);
        Map<String, Object> selectedFields2 = new Map<String, Object>{eba2.Id => false};
        mockExtractor.setup('getSelectedFields', new List<Object>{eba2.Id, sms}).returns(selectedFields2);

        TmBoarding.RelatedSm result =  sut.buildServiceAccounts(relatedSm, coreSm, sms, metadata, pm);

        System.assertEquals(1, result.accountRelationships.size());
    }

    private static testMethod void it_should_build_new_contact_account() {
        String objectName = 'tm_service_request_contact_account__c';
        Id requestId = ObjectFactory.getFakeId(Tm_service_Request__c.SObjectType, '1');
        Id account1Id = ObjectFactory.getFakeId(Eb_Account__c.SObjectType, '1');
        Id account2Id = ObjectFactory.getFakeId(Eb_Account__c.SObjectType, '2');
        Id contactId = ObjectFactory.getFakeId(Contact.SObjectType, '1');
        String fieldName = 'Name';

        Tm_service_Request__c req = new Tm_service_Request__c(Id = requestId);
        Eb_Account__c eba1 = new Eb_Account__c(Id = account1Id);
        Eb_Account__c eba2 = new Eb_Account__c(Id = account2Id);
        List<Eb_Account__c> accounts = new List<Eb_Account__c>{eba1, eba2};
        Contact c = new Contact(Id = contactId);
        TmBoarding.relatedSm relatedSm = new TmBoarding.relatedSm();
        List<TmBoarding.SaveSm> sms = new List<TmBoarding.SaveSm>();
        TmBoarding.RequestConfigPm metadata = new TmBoarding.RequestConfigPm();
        TmBoarding.RequestPm pm = new TmBoarding.RequestPm();
        TM_Service_Request_Account__c serviceAccount = new TM_Service_Request_Account__c();
        serviceAccount.TM_Service_Request__c = req.Id;
        serviceAccount.EB_Account__c = eba2.Id;
        TM_Service_Request_Contact__c serviceContact = new TM_Service_Request_Contact__c();
        serviceContact.TM_Service_Request__c = req.Id;
        serviceContact.Contact__c = c.Id;
        pm.requestPm = req;
        pm.accountPms = accounts;
        pm.contactPms = new List<Contact>{c};
        pm.serviceAccountPms = new List<TM_Service_Request_Account__c>{serviceAccount};
        pm.serviceContactPms = new List<Tm_Service_Request_Contact__c>{serviceContact};


        TmBoarding.CoreSm coreSm = new TmBoarding.CoreSm();
        coreSm.request = req;
        coreSm.accounts = accounts;     
        String key = 'x|y';
        Map<String, List<TmBoarding.SaveSm>> newRequestContactAccountSms = new Map<String, List<TmBoarding.SaveSm>>{key => sms};
        mockExtractor.setup('getObjectsByParentAndRelated' , new List<Object>{objectName, sms}).returns(newRequestContactAccountSms);
        SObjectField accountContactField = getField(objectName, fieldName);
        mockfieldMapper.setup('getField' , new List<Object>{'TM_Service_Request_Contact_Account__c', fieldName}).returns(accountContactField);
        mockUtil.setup('getObjectNameFromId' , new List<Object>{'x'}).returns('Contact');
        mockUtil.setup('getObjectNameFromId' , new List<Object>{'y'}).returns('Tm_Service_Request_Contact__c');

        List<TM_Service_Request_Contact_Account__c> result =  sut.buildNewContactAccount(relatedSm, sms, metadata, pm);

        System.assertEquals(1, result.size());
    }

    private static Schema.SObjectField getField(String objectName, String fieldName) {
        Map<string, Map<string,Schema.SObjectField>> m_fieldMap = new Map<string, Map<string,Schema.SObjectField>>();
        if(!m_fieldMap.containsKey(objectName)){
            m_fieldMap.put(objectName,Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap());
        }
        return m_fieldMap.get(objectName).get(fieldName);
    }
}