@IsTest
private class TmBoardingDataMapBuilderTests {
	
    private static TmBoardingDataMapBuilder sut;
    
    static {
        sut = new TmBoardingDataMapBuilder();
    }
    
    private static testMethod void it_should_call_the_config_When_building_a_packet() {
        String entityName = 'entity-name';
        String packetName = 'test-packet';
        String requestName = 'request-name';
        String LockboxProduct = 'Lockbox';
        String OnlineProduct = 'Online Banking';
        Account entity = new Account(Name = entityName);
        TM_Service_Request_Packet__c packet = new TM_Service_Request_Packet__c(Name = packetName);
        RecordType reqRecordType = new RecordType(Name = LockboxProduct);
        TM_Service_Request__c request = new TM_Service_Request__c();
        request.RecordType = reqRecordType;
        request.RecordType.Name = Lockboxproduct;
        
        TM_service_Request__c packetReq1 = new TM_Service_Request__c();
        RecordType packetreqRecordType = new RecordType(Name = OnlineProduct);
        packetReq1.RecordType = packetreqRecordType;
        packetReq1.RecordType.Name = OnlineProduct;
        TmBoarding.RequestPm pm = new TmBoarding.RequestPm();
        pm.EntityPm = entity;
        pm.packetPm = packet;
        pm.requestPm = request;
        pm.packetRequestsPm = new List<Tm_Service_Request__c>{packetReq1};
        
        TmBoarding.LayoutComponent2 result = sut.buildPacket(pm);
        
        System.assertEquals(null, result.Entity.Id);
        System.assertEquals(entityName, result.Entity.Name);
        System.assertEquals(null, result.PacketDetail.Id);
        System.assertEquals(packetName, result.PacketDetail.Name);
        System.assertEquals(null, result.Request.Id);
        System.assertEquals(null, result.Request.Name);
        System.assertEquals(LockboxProduct, result.Type);
        System.assertEquals(1, result.Requests.size());
        System.assertEquals(OnlineProduct, result.Requests[0].Name);
    }
    
    private static testMethod void it_should_build_details() {    
        String lockboxProduct = 'Lockbox';
        String objectName = 'TM_Service_Request__c';
        TmBoarding.RequestPm pm = new TmBoarding.RequestPm();
        
        TM_Service_Request__c req = new TM_Service_Request__c();
        RecordType LockboxRecordType = new RecordType(Name = lockboxProduct);
        req.RecordType = LockboxRecordType;
        pm.requestPm = req;
		
        DmField requestfield1 = new DmField();
        requestfield1.Name = 'Stage__c';
        requestfield1.ObjectName = objectName; 
        DmField scheduleField1 = new DmField();
        scheduleField1.Name = 'Commercial_Banking__c';
        scheduleField1.ObjectName = objectName;
        List<DmField> requestfields = new List<DmField>{requestfield1};
        List<DmField> scheduleFields = new List<DmField>{scheduleField1};
        
        TmBoarding.DataComponent result = sut.buildDetails(pm, requestfields, scheduleFields);
        
        Set<String> keys = result.Data[0].Keyset();
        List<String> keyList = new List<String>();
        keyList.addAll(keys);
		System.assertEquals(1, result.Data.size());
        String requestFieldId = objectName + '.' + 'Id';
        String requestFieldName = objectName + '.' + requestfield1.Name;
        String scheduleFieldName = objectName + '.' + scheduleField1.Name; 
        System.assertEquals(requestFieldId, keyList[0]);
		System.assertEquals(requestFieldName, keyList[1]);
        System.assertEquals(scheduleFieldName, keyList[2]); 
    }
    
    private static testMethod void it_should_build_contacts() {
        Id requestId = OBjectFactory.getFakeId(Tm_Service_Request__c.SObjectType, '1');
        String LockboxProduct = 'Lockbox';
        String objectName = 'Contact';
        
        DmField contactOption = new DmField();
		contactOption.Name = 'contact-name';
        contactOption.IsAccessible = true;
        contactOption.objectName = objectName;        
        TmBoarding.RequestPm pm = new TmBoarding.RequestPm();
        List<DmField> contactOptions = new List<DmField>{contactOption};
        Contact c = new Contact(FirstName = 'first', LastName = 'last');
        TM_Service_Request_Contact__c rcontact = new TM_Service_Request_Contact__c();
        rcontact.Contact__c = c.Id;
        List<TM_Service_Request_Contact__c> serviceContactPms = new List<TM_Service_Request_Contact__c>{rcontact};
        RecordType lockboxRecordType = new RecordType(Name = LockboxProduct);
        Tm_Service_Request__c req = new Tm_service_Request__c(Id = requestId);
        req.RecordType = lockboxRecordType;
        pm.requestPm = req;
        pm.contactPms = new List<Contact>{c};
		pm.serviceContactPms = serviceContactPms;
        
        TmBoarding.DataComponent result = sut.buildContacts(pm, contactOptions);
        
        System.assertEquals(1 , result.Data.size());
    }
    
    private static testMethod void it_should_build_accounts() {
        Id requestId = OBjectFactory.getFakeId(Tm_Service_Request__c.SObjectType, '1');
        String LockboxProduct = 'Lockbox';
        String objectName = 'EB_Account__c';
        String accountName = 'account-name';
        DmField accountOption = new DmField();
		accountOption.Name = 'account-name';
        accountOption.IsAccessible = true;
        accountOption.objectName = objectName;        
        TmBoarding.RequestPm pm = new TmBoarding.RequestPm();
        List<DmField> accountOptions = new List<DmField>{accountOption};
        EB_Account__c eba = new EB_Account__c(Name = accountName);
        TM_Service_Request_Account__c raccount = new TM_Service_Request_Account__c();
        raccount.EB_Account__c = eba.Id;
        List<TM_Service_Request_Account__c> serviceAccountPms = new List<TM_Service_Request_Account__c>{raccount};
        RecordType lockboxRecordType = new RecordType(Name = LockboxProduct);
        Tm_Service_Request__c req = new Tm_service_Request__c(Id = requestId);
        req.RecordType = lockboxRecordType;
        pm.requestPm = req;
        pm.accountPms = new List<Eb_Account__c>{eba};
		pm.serviceAccountPms = serviceAccountPms;
        
        TmBoarding.DataComponent result = sut.buildAccounts(pm, accountOptions);
        
        System.assertEquals(1 , result.Data.size());
    }
    
    private static testMethod void it_should_build_contact_accounts() {    
        String lockboxProduct = 'Lockbox';
        RecordType rt = new RecordType(Name = lockboxProduct);
        Tm_Service_Request__c req = new Tm_Service_Request__c();
        req.RecordType = rt;
        TmBoarding.RequestPm pm = new TmBoarding.RequestPm();
        pm.requestPm = req;
        DmField contactAccount = new DmField();
        contactAccount.Name = 'Name';
        List<DmField> contactAccounts = new List<DmField>{contactAccount};
            
        TmBoarding.DataComponent result = sut.buildContactAccounts(pm, contactAccounts);
        
        System.assertEquals(null, result);
    }
}