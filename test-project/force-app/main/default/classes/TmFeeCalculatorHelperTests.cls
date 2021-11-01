@IsTest
private class TmFeeCalculatorHelperTests {

    private static final TmFeeCalculatorHelper sut;
    private static final MockOfIDataProvider mockDataProvider; 

    static {        
        mockDataProvider = new MockOfIDataProvider();
        sut = new TmFeeCalculatorHelper(mockDataProvider); 
    }  

    @IsTest
    static void It_shoould_call_the_data_provider_once_when_getFees_is_called_multiple_times() {
        //assemble 
        String clientType = 'Business Banking';
        String bundleType = 'Optima Suite';
        String productType = 'ACH';
        TM_Fee__c fee01 = new TM_Fee__c();
        TM_Fee__c fee02 = new TM_Fee__c();
        List<TM_Fee__c> expectedFees = new List<TM_Fee__c>{fee01,fee02}; 

        mockDataProvider.setup('getAllFees').returns(expectedFees);
        //action 
        sut.GetFees(clientType,bundleType,productType);
        sut.GetFees(clientType,bundleType,productType);     
        //assert 
        mockDataProvider.verify('getAllFees', Times.Once);
    }

    @IsTest
    static void It_should_call_the_data_provider_once_when_getPacket_is_called_multiple_times() {
        //assemble 
        Id requestId1 = ObjectFactory.getFakeId(TM_Service_Request__c.SObjectType, '1');
        Id requestId2 = ObjectFactory.getFakeId(TM_Service_Request__c.SObjectType, '2');
        
        Tm_Service_Request_Packet__c tmPacket = new Tm_Service_Request_Packet__c();
                
        List<Tm_Service_Request_Packet__c> tmPackets = new List<Tm_Service_Request_Packet__c>{tmPacket};
        
        mockDataProvider.setup('getAllPackets').returns(tmPackets);        
        //action 
        sut.GetPacket(requestId1); 
        sut.GetPacket(requestId2);     
        //assert 
        mockDataProvider.verify('getAllPackets', Times.Once);
    }

    @IsTest
    static void It_should_call_the_data_provider_once_when_getSchedule_is_called_multiple_times() {
        //assemble        
        Id schedId = ObjectFactory.getFakeId(TM_Fee_Schedule__c.SObjectType, '1');
        Tm_Fee_Schedule__c sched = new Tm_Fee_Schedule__c();
        sched.Id = schedId;
        sched.Bundle_Type__c = 'Optima Suite';
        List<Tm_Fee_Schedule__c> feeSchedules = new List<Tm_Fee_Schedule__c>{sched};
            
        Tm_Fee__c fee1 = new Tm_Fee__c();
        fee1.TM_Fee_Schedule__r = sched;
        
        Tm_Fee__c fee2 = new Tm_Fee__c();
        fee2.TM_Fee_Schedule__r = sched;
        
        mockDataProvider.setup('getAllSchedules').returns(feeSchedules);        
        //action 
        sut.getSchedule(fee1.TM_Fee_Schedule__c); 
        sut.getSchedule(fee2.TM_Fee_Schedule__c); 
        //assert 
        mockDataProvider.verify('getAllSchedules', Times.Once);
    }

    @IsTest
    static void It_should_call_soqlRequests_once_when_GetRequests_is_called_twice() {
        //assemble
        String clientType1  = 'Business Banking';
        String bundleType1  = 'Optima Suite';
        String productName1 = 'ACH';
        
        String clientType2  = 'Commercial Banking';
        String bundleType2  = 'Large Commercial';
        String productName2 = 'Online Banking';
        
        Tm_Service_Request__c tmRequest = new Tm_Service_Request__c();
        
        List<Tm_Service_Request__c> tmRequests = new List<Tm_Service_Request__c>{tmRequest};
        
        mockDataProvider.setup('getAllRequests').returns(tmRequests);
        //act
        sut.GetRequests(clientType1, bundleType1, productName1);
        sut.GetRequests(clientType2, bundleType2, productName2);
        //assert
        mockDataProvider.verify('getAllRequests', Times.Once);
    }

    @IsTest
    static void It_shoould_call_soqlStages_once_when_GetStage_is_called_twice() {
        //assemble 
        Id stageId = ObjectFactory.getFakeId(TM_Service_Request_Stage__c.SObjectType, '1');
        Tm_Service_Request_Stage__c stage = new Tm_Service_Request_Stage__c();
        stage.Name = 'New';
        stage.Id = stageId;
        List<Tm_Service_Request_Stage__c> stages = new List<Tm_Service_Request_Stage__c>{stage};
        Tm_Service_Request__c tmRequest = new Tm_Service_Request__c();
        tmRequest.Stage__c = stage.Id;
        
        mockDataProvider.setup('getAllStages').returns(stages);
        //action 
        sut.GetStage(tmRequest.Stage__c);
        sut.GetStage(tmRequest.Stage__c);     
        //assert 
        mockDataProvider.verify('getAllStages', Times.Once);
    }

    @IsTest
    static void it_should_return_the_expectedFees_given_multiple_fees_and_schedules() {
        //assemble
        String clientType = 'Business Banking';
        String bundleType = 'Optima Suite';
        String productType = 'ACH';

        Id productId = ObjectFactory.getFakeId(TM_Product__c.SObjectType, '1'); 
        TM_Product__c product = new TM_Product__c();
        product.Name = productType;
        product.Id = productId;

        Id scheduleId01 = ObjectFactory.getFakeId(TM_Fee_Schedule__c.SObjectType, '1');
        TM_Fee_Schedule__c schedule01 = new TM_Fee_Schedule__c();
        schedule01.Client_Type__c = clientType;
        schedule01.Bundle_Type__c = bundleType;
        schedule01.TM_Product__r = product;
        schedule01.Id = scheduleId01;

        Id scheduleId02 = ObjectFactory.getFakeId(TM_Fee_Schedule__c.SObjectType, '2');
        TM_Fee_Schedule__c schedule02 = new TM_Fee_Schedule__c();
        schedule02.Client_Type__c = 'Commercial Banking';
        schedule02.Bundle_Type__c = bundleType;
        schedule02.TM_Product__r = product;
        schedule02.Id = scheduleId02;

        TM_Fee__c fee01 = new TM_Fee__c();
        fee01.TM_Fee_Schedule__r = schedule01;
        fee01.Fee_Amount__c = 50;

        TM_Fee__c fee02 = new TM_Fee__c();
        fee02.TM_Fee_Schedule__r = schedule02;
        fee02.Fee_Amount__c = 100;

        List<TM_Fee__c> allFees = new List<TM_Fee__c>{fee01, fee02};
        List<TM_Fee__c> expectedFees = new List<TM_Fee__c>{fee01};
        mockDataProvider.setup('getAllFees').returns(allFees);
        //action
        List<TM_Fee__c> results = sut.GetFees(clientType,bundleType,productType);
        //assert
        System.assertNotEquals(results, null);
        System.assertEquals(expectedFees, results); 
    }

    @IsTest
    static void it_should_return_the_business_banking_client_when_GetClientType_is_called() {
        //assemble
        Id packetId = ObjectFactory.getFakeId(TM_Service_Request_Packet__c.SObjectType, '1');
        Tm_Service_Request_Packet__c tmPacket = new Tm_Service_Request_Packet__c();
        tmPacket.Client_Type__c = 'Business Banking';
        
        List<Tm_Service_Request_Packet__c> packetList = new List<Tm_Service_Request_Packet__c>{tmPacket};
        
        TM_Service_Request__c tmRequest = new TM_Service_Request__c();
        tmRequest.TM_Service_Request_Packet__c = tmPacket.Id;
        
        mockDataProvider.setup('getAllPackets').returns(packetList);
        //action
        String ct = sut.GetClientType(tmRequest);
        //assert
        System.assertEquals('Business Banking', ct);
    }

    @IsTest
    static void it_should_return_the_commercial_client_when_GetClientType_is_called() {
        //assemble
        Id packetId = ObjectFactory.getFakeId(TM_Service_Request_Packet__c.SObjectType, '1');
        Tm_Service_Request_Packet__c tmPacket = new Tm_Service_Request_Packet__c();
        tmPacket.Client_Type__c = 'Commercial Banking';
        
        List<Tm_Service_Request_Packet__c> packetList = new List<Tm_Service_Request_Packet__c>{tmPacket};
        
        TM_Service_Request__c tmRequest = new TM_Service_Request__c();
        tmRequest.TM_Service_Request_Packet__c = tmPacket.Id;
        
        mockDataProvider.setup('getAllPackets').returns(packetList);
        //action
        String ct = sut.GetClientType(tmRequest);
        //assert
        System.assertEquals('Commercial Banking', ct);
    }

    @IsTest
    static void it_should_return_the_corporate_olb_client_when_GetClientType_is_called() {
        //assemble
        Id packetId = ObjectFactory.getFakeId(TM_Service_Request_Packet__c.SObjectType, '1');
        Tm_Service_Request_Packet__c tmPacket = new Tm_Service_Request_Packet__c();
        tmPacket.Client_Type__c = 'Corporate OLB';
        
        List<Tm_Service_Request_Packet__c> packetList = new List<Tm_Service_Request_Packet__c>{tmPacket};
        
        TM_Service_Request__c tmRequest = new TM_Service_Request__c();
        tmRequest.TM_Service_Request_Packet__c = tmPacket.Id;
        
        mockDataProvider.setup('getAllPackets').returns(packetList);
        //action
        String ct = sut.GetClientType(tmRequest);
        //assert
        System.assertEquals('Corporate OLB', ct);
    }

    @IsTest
    static void it_should_return_null_when_GetClientType_is_called() {
        //assemble
        Id packetId = ObjectFactory.getFakeId(TM_Service_Request_Packet__c.SObjectType, '1');
        Tm_Service_Request_Packet__c tmPacket = new Tm_Service_Request_Packet__c();
        tmPacket.Client_Type__c = null;
        List<Tm_Service_Request_Packet__c> packetList = new List<Tm_Service_Request_Packet__c>{tmPacket};
        
        TM_Service_Request__c tmRequest = new TM_Service_Request__c();
        tmRequest.TM_Service_Request_Packet__c = tmPacket.Id;
        
        mockDataProvider.setup('getAllPackets').returns(packetList);
        //action
        String ct = sut.GetClientType(tmRequest);
        //assert
        System.assertEquals(null, ct);
    }

    @IsTest
    static void it_should_return_the_bundle_types_field_value_when_GetBundleType_is_called() {
        //assemble
        Id packetId = ObjectFactory.getFakeId(TM_Service_Request_Packet__c.SObjectType, '1');
        TM_Service_Request_Packet__c tmPacket = new Tm_Service_Request_Packet__c();
        tmPacket.Id = packetId;
        tmPacket.Bundle_Type__c = 'Optima Suite';        
        TM_Service_Request__c tmRequest = new TM_Service_Request__c();
        tmRequest.TM_Service_Request_Packet__c = tmPacket.Id;  
        mockDataProvider.setup('getAllPackets').returns(new List<Tm_Service_Request_Packet__c>{tmPacket});
        //action
        String results = sut.GetBundleType(tmRequest);
        //assert
        System.assertEquals('Optima Suite', results);
    }

    @IsTest
    static void it_should_return_null_when_GetBundleType_is_called_when_the_packet_is_not_returned_from_the_data_provider() {
        //assemble
        Id packetId = ObjectFactory.getFakeId(TM_Service_Request_Packet__c.SObjectType, '1');
        TM_Service_Request_Packet__c tmPacket = new Tm_Service_Request_Packet__c();
        tmPacket.Id = packetId;
        tmPacket.Bundle_Type__c = 'SomeBundleType';        
        TM_Service_Request__c tmRequest = new TM_Service_Request__c();
        tmRequest.TM_Service_Request_Packet__c = tmPacket.Id; 
        mockDataProvider.setup('getAllPackets').returns(new List<Tm_Service_Request_Packet__c>());
        //action
        String results = sut.GetBundleType(tmRequest);
        //assert
        System.assertEquals(null, results);
    }

    @IsTest
    static void it_should_return_ach_product_type_when_GetProductType_is_called() {
        //assemble
        String recordType = 'ACH';
        RecordType rt = Utility.recordTypeObject('TM_Service_Request__c', recordType);
        TM_Service_Request__c tmRequest = new TM_Service_Request__c();
        tmRequest.RecordTypeId = rt.Id;        
        //action
        String results = sut.GetProductType(tmRequest);
        //assert
        System.assertEquals(recordType, results);
    }

    @IsTest
    static void It_should_call_GetProductType_with_a_product_id_and_soql_only_once() {
        //assemble
		Tm_Product__c product1 = new Tm_Product__c();
        product1.Name = 'ACH';
        
		Tm_Product__c product2 = new Tm_Product__c();
        product2.Name = 'Online Banking';
        
        List<Tm_Product__c> productList = new List<Tm_Product__c>{product1, product2};
        
        Tm_Fee_Schedule__c tmSched1 = new Tm_Fee_Schedule__c();
        tmSched1.TM_Product__r = product1;
        
        Tm_Fee_Schedule__c tmSched2 = new Tm_Fee_Schedule__c();
        tmSched2.TM_Product__r = product2;

        mockDataProvider.setup('getAllProducts').returns(productList);  
        //act
        sut.GetProductType(tmSched1.TM_Product__c); 
        sut.GetProductType(tmSched2.TM_Product__c);
        //assert
		mockDataProvider.verify('getAllProducts', Times.Once);
    }
    
    public class MockOfIDataProvider extends ApexMoq implements TmFeeCalculator.IDataProvider {
        public List<Tm_fee__c> getAllFees(){
            return (List<Tm_fee__c>)handleMethodInvocation('getAllFees');
        }
        public List<Tm_Service_Request_Packet__c> getAllPackets(){
            return (List<Tm_Service_Request_Packet__c>)handleMethodInvocation('getAllPackets');
        }
        public List<Tm_Fee_Schedule__c> getAllSchedules(){
            return (List<Tm_Fee_Schedule__c>)handleMethodInvocation('getAllSchedules');
        }
        public List<Tm_Product__c> getAllProducts(){
            return (List<Tm_Product__c>)handleMethodInvocation('getAllProducts');
        }
        public List<Tm_Service_Request__c> getAllRequests(){
            return (List<Tm_Service_Request__c>)handleMethodInvocation('getAllRequests');
        }
        public List<Tm_Service_Request_Stage__c> getAllStages(){
            return (List<Tm_Service_Request_Stage__c>)handleMethodInvocation('getAllStages');
        }
    }
}