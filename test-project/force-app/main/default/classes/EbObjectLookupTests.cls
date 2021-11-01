@IsTest
private class EbObjectLookupTests {
    
    private static final MockOfIDataProvider mockDataProvider;
    private static EbObjectLookup sut;
    
    static {
        mockDataProvider = new MockOfIDataProvider();
        sut = new EbObjectLookup(mockDataProvider);
    }

    @IsTest
    static void it_should_get_an_object_id_when_entity_key_is_provided() {
        String objectKey = '616-1122';
        
        Id objectId = sut.getObjectId(objectKey);
        
        mockDataProvider.verify('getEntity', new List<OBject>{objectKey}, Times.Once); 
    }
    
    @IsTest
    static void it_should_get_an_object_id_when_ebaccount_key_is_provided() {
        String objectKey = '616-15-22002';
        
        Id objectId = sut.getObjectId(objectKey);
        
        mockDataProvider.verify('getEbAccount', new List<OBject>{objectKey}, Times.Once); 
    }

    @IsTest
    static void it_should_get_an_object_id_when_wealth_management_ebaccount_key_is_provided() {
        string objectKey = '007691-1';
        //act
        Id result = sut.getObjectId(objectKey);
        //assert
        mockDataProvider.verify('getEbAccount', new List<OBject>{objectKey}, Times.Once);
    }

    @IsTest
    static void it_should_get_an_object_id_when_wealth_management_entity_key_is_provided() {
        string objectKey = '123456789';
        //act
        Id result = sut.getObjectId(objectKey);
        //assert
        mockDataProvider.verify('getEntity', new List<OBject>{objectKey}, Times.Once);
    }

    @IsTest
    static void it_should_not_return_an_object_id_when_objectKey_has_more_than_3_parts() {
        string objectKey = '1-2-3-4';
        //act
        Id result = sut.getObjectId(objectKey);
        //assert
        System.assertEquals(null, result, 'The Id is not null.');
    }
    
    @IsTest
    static void it_should_get_an_object_id_when_ebcollateral_key_is_provided() {
        String objectKey = '616-20-22002';
        
        Id objectId = sut.getObjectId(objectKey);
        
        mockDataProvider.verify('getEbCollateral', new List<OBject>{objectKey}, Times.Once); 
    }
    
    @IsTest
    static void it_should_get_an_object_id_when_entity_key_and_type_is_provided() {
        String objectKey = '616-1122';
        
        Id objectId = sut.getObjectId(objectKey, 'Entity');
        
        mockDataProvider.verify('getEntity', new List<OBject>{objectKey}, Times.Once); 
    }

    @IsTest
    static void it_should_get_an_object_id_when_collateral_key_and_type_is_provided() {
        String objectKey = '616-20-1122';
        
        Id objectId = sut.getObjectId(objectKey, 'account');
        
        mockDataProvider.verify('getEbCollateral', new List<OBject>{objectKey}, Times.Once); 
    }

    @IsTest
    static void it_should_get_an_object_id_when_ebaccount_key_and_type_is_provided() {
        String objectKey = '616-15-1122';
        
        Id objectId = sut.getObjectId(objectKey, 'account');
        
        mockDataProvider.verify('getEbAccount', new List<OBject>{objectKey}, Times.Once); 
    }

    @IsTest
    static void it_should_get_an_object_key_and_type_when_entity_id_is_provided() {
        String ebCustomer = 'test-eb-cust';
        Id objectId = ObjectFactory.getFakeId(Account.SObjectType, '1');
        Account a = new Account(Id = objectId, EB_Customer_Number__c = ebCustomer);
        mockDataProvider.setup('getEntity', new List<Object>{a.Id}).returns(a);
        
        EbObjectLookup.KeyAndType result = sut.getObjectKeyAndType(a.Id);
        
        System.assertEquals('entity',result.keyType);
        System.assertEquals(ebCustomer , result.objectKey);
    }
    
    @IsTest
    static void it_should_get_an_object_key_and_type_when_WM_entity_id_is_provided() {
        String ebCustomer = 'test-eb-cust';
        Id objectId = ObjectFactory.getFakeId(Account.SObjectType, '1');
        Account a = new Account(Id = objectId, EB_Customer_Number__c = NULL, WM_Key__c = ebCustomer);
        mockDataProvider.setup('getEntity', new List<Object>{a.Id}).returns(a);
        
        EbObjectLookup.KeyAndType result = sut.getObjectKeyAndType(a.Id);
        
        System.assertEquals('entity',result.keyType);
        System.assertEquals(ebCustomer , result.objectKey);
    }
    
    @IsTest
    static void it_should_get_an_object_key_and_type_when_entity_id_without_customer_number_or_wm_key_is_provided() {
        Id objectId = ObjectFactory.getFakeId(Account.SObjectType, '1');
        Account a = new Account(Id = objectId, EB_Customer_Number__c = NULL, WM_Key__c = NULL);
        mockDataProvider.setup('getEntity', new List<Object>{a.Id}).returns(a);
        
        EbObjectLookup.KeyAndType result = sut.getObjectKeyAndType(a.Id);
        
        System.assertEquals('entity',result.keyType);
        System.assertEquals(objectId , result.objectKey);
    }

    @IsTest
    static void it_should_get_an_object_key_and_type_when_ebaccount_Id_is_provided() {
        String key = '616-2-1122';
        Id objectId = ObjectFactory.getFakeId(Eb_Account__c.SObjectType, '1');
        Eb_Account__c ebAccount = new Eb_Account__c(Id=objectId, key__c = key);
        mockDataProvider.setup('getEbAccount', new List<OBject>{ebAccount.Id}).returns(ebAccount); 
        
        EbObjectLookup.KeyAndType result = sut.getObjectKeyAndType(objectId);
        
        System.assertEquals('account',result.keyType);
        System.assertEquals(key , result.objectKey);
    }
    
    @IsTest
    static void it_should_get_an_object_key_and_type_when_ebcollateral_Id_is_provided() {
        String key = '616-20-1122';
        ID objectId = ObjectFactory.getFakeId(Eb_Collateral__c.SObjectType, '1');
        EB_Collateral__c col = new EB_Collateral__c(Id=objectId, Key__c = key);
        mockDataProvider.setup('getEbCollateral', new List<OBject>{objectId}).returns(col); 
        
        EbObjectLookup.KeyAndType result = sut.getObjectKeyAndType(objectId);
        
        System.assertEquals('account',result.keyType);
        System.assertEquals(key , result.objectKey);
    }
    
    @IsTest
    static void it_should_get_an_object_key_and_type_when_loan_Id_is_provided() {
        ID objectId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        LLC_BI__Loan__c obj = new LLC_BI__Loan__c(Id=objectId);
                
        EbObjectLookup.KeyAndType result = sut.getObjectKeyAndType(objectId);
        
        System.assertEquals('llcbiloan', result.keyType);
        System.assertEquals(objectId, result.objectKey);
    }
    
    @IsTest
    static void it_should_get_an_object_key_and_type_when_collateral_Id_is_provided() {
        ID objectId = ObjectFactory.getFakeId(LLC_BI__Collateral__c.SObjectType, '1');
        LLC_BI__Collateral__c obj = new LLC_BI__Collateral__c(Id=objectId);
                
        EbObjectLookup.KeyAndType result = sut.getObjectKeyAndType(objectId);
        
        System.assertEquals('llcbicollateral', result.keyType);
        System.assertEquals(objectId, result.objectKey);
    }

    @IsTest
    static void it_should_handle_empty_context_id() {      
        EbObjectLookup.KeyAndType result = sut.getObjectKeyAndType('');
        
        System.assertEquals(null, result.keyType);
        System.assertEquals(null , result.objectKey);
    }

    public class MockOfIDataProvider extends ApexMoq implements EbObjectLookup.IDataProvider {
        public Account getEntity(String key) {
            return (Account)handleMethodInvocation('getEntity', new List<OBject>{key});
        }
        public EB_Account__c getEbAccount(String key) {
            return (EB_Account__c)handleMethodInvocation('getEbAccount', new List<Object>{key});
        }
        public EB_Collateral__c getEbCollateral(String key) {
            return (EB_Collateral__c)handleMethodInvocation('getEbCollateral', new List<OBject>{key});
        }
        public Account getEntity(Id objectId) {
            return (Account)handleMethodInvocation('getEntity', new List<OBject>{objectId});
        }
        public EB_Account__c getEbAccount(Id objectId) {
            return (EB_Account__c)handleMethodInvocation('getEbAccount', new List<OBject>{objectId});
        }
        public EB_Collateral__c getEbCollateral(Id objectId) {
            return (EB_Collateral__c)handleMethodInvocation('getEbCollateral', new List<OBject>{objectId});
        }
    }
}