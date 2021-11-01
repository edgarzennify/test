@IsTest
private class TmFeeCalculatorTests {

    private static final TmFeeCalculator sut;
    private static final MockITmFeeCalculatorHelper mockHelper;
    
    static {        
        mockHelper = new MockITmFeeCalculatorHelper(); 
        sut = new TmFeeCalculator(mockHelper);
    }
    
    @IsTest
    static void it_should_return_different_fees_for_different_requests() {
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
        
        Id scheduleId02 = ObjectFactory.getFakeId(TM_Fee_Schedule__c.SObjectType, '1');
        TM_Fee_Schedule__c schedule02 = new TM_Fee_Schedule__c();
        schedule02.Client_Type__c = 'Commercial Banking';
        schedule02.Bundle_Type__c = bundleType;
        schedule02.TM_Product__r = product;
        schedule02.Id = scheduleId01;
        
        TM_Fee__c fee01 = new TM_Fee__c();
        fee01.Fee_Amount__c = 100;
        fee01.Fee_API_Name__c = 'ACH_Module_Maintenance_Fee__c';
        fee01.TM_Fee_Schedule__r = schedule01;
        fee01.Feature_Fee_Dependency__c = 'ACH_Pass_Thru__c';
        TM_Fee__c fee02 = new TM_Fee__c();
        fee02.Fee_Amount__c = 75;
        fee02.Fee_API_Name__c = 'Return_Fee__c'; 
        fee02.TM_Fee_Schedule__r = schedule02;
        TM_Fee__c fee03 = new TM_Fee__c();
        fee03.Fee_Amount__c = 50;
        fee03.Fee_API_Name__c = 'ACH_Implementation_Setup_Fee__c';
        fee03.TM_Fee_Schedule__r = schedule01;
        
        List<TM_Fee__c> firstFees = new List<TM_Fee__c>{fee01,fee03};
        List<TM_Fee__c> secondFees = new List<TM_Fee__c>{fee02};

        TM_Service_Request_Packet__c tmPacket1 = new TM_Service_Request_Packet__c();
        tmPacket1.Client_Type__c = clientType;
        tmPacket1.Bundle_Type__c = bundleType;
        
        Id stageId = ObjectFactory.getFakeId(TM_Service_Request_Stage__c.SObjectType, '1');
        Tm_Service_Request_Stage__c stage = new Tm_Service_Request_Stage__c();
        stage.Name = 'New';
        stage.Id = stageId;
            
        Id serviceId1 = ObjectFactory.getFakeId(TM_Service_Request__c.SObjectType, '1');
        TM_Service_Request__c tmRequest1 = new TM_Service_Request__c();
        tmRequest1.ACH_Module_Maintenance_Fee__c = 0;
        tmRequest1.TM_Service_Request_Packet__r = tmPacket1;
        tmRequest1.RecordType = Utility.recordTypeObject('TM_Service_Request__c', productType);
        tmRequest1.ACH_Implementation_Setup_Fee__c = 0;
        tmRequest1.Return_Fee__c  = 0;
        tmRequest1.ACH_Pass_Thru__c = true;
        tmRequest1.Id = serviceId1;
        tmRequest1.Stage__c = stage.Id;
        
        TM_Service_Request_Packet__c tmPacket2 = new TM_Service_Request_Packet__c();
        tmPacket2.Client_Type__c = 'Commercial Banking';
        tmPacket2.Bundle_Type__c = 'Large Commercial';
            
        Id serviceId2 = ObjectFactory.getFakeId(TM_Service_Request__c.SObjectType, '2');
        TM_Service_Request__c tmRequest2 = new TM_Service_Request__c();
        tmRequest2.ACH_Module_Maintenance_Fee__c = 0;
        tmRequest2.TM_Service_Request_Packet__r = tmPacket2;
        tmRequest2.RecordType = Utility.recordTypeObject('TM_Service_Request__c', productType);
        tmRequest2.ACH_Implementation_Setup_Fee__c = 0;
        tmRequest2.Return_Fee__c  = 0;
        tmRequest2.Id = serviceId2;
        tmRequest2.Stage__c = stage.Id;
        
        List<TM_Service_Request__c> tmRequests = new List<TM_Service_Request__c>{tmRequest1, tmRequest2};

        mockHelper.setup('GetBundleType', new List<Object>{tmRequest1}).returns('Optima Suite');
        mockHelper.setup('GetClientType', new List<Object>{tmRequest1}).returns('Business Banking');
        mockHelper.setup('GetProductType', new List<Object>{tmRequest1}).returns('ACH');
        mockHelper.setup('GetBundleType', new List<Object>{tmRequest2}).returns('Large Commercial');
        mockHelper.setup('GetClientType', new List<Object>{tmRequest2}).returns('Commercial Banking');
        mockHelper.setup('GetProductType', new List<Object>{tmRequest2}).returns('ACH');
        mockHelper.setup('GetStage', new List<Object>{stage.Id}).returns(stage);
        mockHelper.setup('GetFees', new List<Object>{'Business Banking', 'Optima Suite', 'ACH'}).returns(firstFees);
        mockHelper.setup('GetFees', new List<Object>{'Commercial Banking', 'Large Commercial', 'ACH'}).returns(secondFees);
        //act
		List<TM_Service_Request__c> results = sut.Calculate(tmRequests); 
        //assert
        System.assertEquals(fee03.Fee_Amount__c, results[0].ACH_Implementation_Setup_Fee__c);
        System.assertNotEquals(fee03.Fee_Amount__c, results[1].ACH_Implementation_Setup_Fee__c);
        System.assertEquals(tmRequest2.ACH_Module_Maintenance_Fee__c, results[1].ACH_Implementation_Setup_Fee__c);
    }
    
    @IsTest
    static void it_should_return_an_updated_list_of_requests_when_calculate_is_called_with_a_list_of_fees() { 
    	//assemble
    	Id prodId = ObjectFactory.getFakeId(TM_Product__c.SObjectType, '1');
        Tm_Product__c product = new Tm_Product__c();
        product.Id = prodId;
        product.Name = 'ACH';
        
        Id schedId = ObjectFactory.getFakeId(TM_Fee_Schedule__c.SObjectType, '1');
        Tm_Fee_Schedule__c sched = new Tm_Fee_Schedule__c();
        sched.Id = schedId;
        sched.TM_Product__c  = product.Id;
        sched.TM_Product__r  = product;
        sched.Client_Type__c = 'Business Banking';
        sched.Bundle_Type__c = 'Optima Suite';
        
        Tm_Fee__c fee1 = new Tm_Fee__c();
        fee1.TM_Fee_Schedule__r = sched;
        fee1.TM_Fee_Schedule__c = sched.Id;
        fee1.Fee_Amount__c = 50;
        fee1.Feature_Fee_Dependency__c = 'ACH_Pass_Thru__c';
        fee1.Fee_API_Name__c = 'ACH_Implementation_Setup_Fee__c';
        
        Tm_Fee__c fee2 = new Tm_Fee__c();
        fee2.TM_Fee_Schedule__r = sched;
        fee2.TM_Fee_Schedule__c = sched.Id;
        fee2.Fee_Amount__c = 100;
        fee2.Fee_API_Name__c = 'ACH_Module_Maintenance_Fee__c';
        
        List<Tm_Fee__c> feeList = new List<Tm_Fee__c>{fee1,fee2};
        
        Id stageId = ObjectFactory.getFakeId(TM_Service_Request_Stage__c.SObjectType, '1');
        Tm_Service_Request_Stage__c stage = new Tm_Service_Request_Stage__c();
        stage.Name = 'New';
        stage.Id = stageId;
        
        Tm_Service_Request__c tmRequest = new Tm_Service_Request__c(); 
        tmRequest.ACH_Implementation_Setup_Fee__c = 0;
		tmRequest.ACH_Module_Maintenance_Fee__c   = 0;
        tmRequest.ACH_Pass_Thru__c = true;
        tmRequest.Stage__c = stage.Id;
        
        List<Tm_Service_Request__c> tmRequests = new List<Tm_Service_Request__c>{tmRequest};
            
        mockHelper.setup('GetSchedule', new List<Object>{fee1.TM_Fee_Schedule__c}).returns(sched);
        mockHelper.setup('GetSchedule', new List<Object>{fee2.TM_Fee_Schedule__c}).returns(sched);
        mockHelper.setup('GetProductType', new List<Object>{sched.TM_Product__c}).returns(product);
        mockHelper.setup('GetStage', new List<Object>{tmRequest.Stage__c}).returns(stage);
        mockHelper.setup('GetRequests', new List<Object>{sched.Client_Type__c, sched.Bundle_Type__c, product.Name}).returns(tmRequests);
        mockHelper.setup('GetClientType', new List<Object>{tmRequest}).returns('Business Banking');
        mockHelper.setup('GetBundleType', new List<Object>{tmRequest}).returns('Optima Suite');
        mockHelper.setup('GetProductType', new List<Object>{tmRequest}).returns(product.Name);
        mockHelper.setup('GetFees', new List<Object>{'Business Banking', 'Optima Suite', product.Name}).returns(feeList);
        //act
        List<Tm_Service_Request__c> results = sut.Calculate(feeList);
        //assert
        system.assertEquals(1, results.size());
        system.assertEquals(50, results[0].ACH_Implementation_Setup_Fee__c);
        system.assertEquals(100, results[0].ACH_Module_Maintenance_Fee__c);
        
    }
    @IsTest
    static void it_should_not_update_fees_for_requests_in_a_complete_stage() { 
    	//assemble
    	Id stageId = ObjectFactory.getFakeId(TM_Service_Request_Stage__c.SObjectType, '1');
        Tm_Service_Request_Stage__c stage = new Tm_Service_Request_Stage__c();
        stage.Name = 'Complete';
        stage.Id = stageId;
        
        Tm_Service_Request__c tmRequest = new Tm_Service_Request__c();
        tmRequest.ACH_Implementation_Setup_Fee__c = 0;
		tmRequest.ACH_Module_Maintenance_Fee__c   = 0;
        tmRequest.ACH_Pass_Thru__c = true;
        tmRequest.Stage__c = stage.Id;
        
        List<Tm_Service_Request__c> tmRequests = new List<Tm_Service_Request__c>{tmRequest};
            
        mockHelper.setup('GetStage', new List<Object>{tmRequest.Stage__c}).returns(stage);
        //act
        List<Tm_Service_Request__c> results = sut.Calculate(tmRequests);
        //assert
        mockHelper.verify('GetClientType', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Never);
        mockHelper.verify('GetBundleType', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Never);
        mockHelper.verify('GetProductType', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Never);
        mockHelper.verify('GetFees', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Never);
        
    }
    @IsTest
    static void it_should_set_fees_to_null_if_feature_fee_is_undone() { 
    	//assemble
    	Id stageId = ObjectFactory.getFakeId(TM_Service_Request_Stage__c.SObjectType, '1');
        Tm_Service_Request_Stage__c stage = new Tm_Service_Request_Stage__c();
        stage.Name = 'Documentation Cycle';
        stage.Id = stageId;
        Tm_Service_Request__c tmRequest = new Tm_Service_Request__c();
        tmRequest.ACH_FTP__c = false;
		tmRequest.ACH_FTP_Module_Fee__c	= 150;
        tmRequest.Stage__r = stage;
        tmRequest.Stage__c = stage.Id;
        
        Tm_Product__c product = new Tm_Product__c();
        product.Name = 'ACH';
        
        List<Tm_Service_Request__c> tmRequests = new List<Tm_Service_Request__c>{tmRequest};
            
        Tm_Fee__c fee = new Tm_Fee__c();
        fee.Fee_Api_Name__c = 'ACH_FTP_Module_Fee__c';
        fee.Fee_Amount__c = 150;
        fee.Feature_Fee_Dependency__c = 'ACH_FTP__c';
        List<Tm_Fee__c> feeList = new List<Tm_Fee__c>{fee};
            
        mockHelper.setup('GetClientType', new List<Object>{tmRequest}).returns('Business Banking');
        mockHelper.setup('GetBundleType', new List<Object>{tmRequest}).returns('Optima Suite');
        mockHelper.setup('GetProductType', new List<Object>{tmRequest}).returns(product.Name);
        mockHelper.setup('GetFees', new List<Object>{'Business Banking', 'Optima Suite', product.Name}).returns(feeList);
        mockHelper.setup('GetStage', new List<Object>{tmRequest.Stage__c}).returns(stage);
        //act
        List<Tm_Service_Request__c> results = sut.Calculate(tmRequests);
        //assert
        system.assertEquals(0, results[0].ACH_FTP_Module_Fee__c);
        
    }

    public class MockITmFeeCalculatorHelper extends ApexMoq implements TmFeeCalculator.ITmFeeCalculatorHelper {
        public List<TM_Fee__c> GetFees(String clientType, String bundleType, String productType) {
            return (List<Tm_fee__c>)handleMethodInvocation('GetFees', new List<Object>{clientType, bundleType, productType});
        }
        public String GetClientType(TM_Service_Request__c tmRequest) {
            return (String)handleMethodInvocation('GetClientType', new List<Object>{tmRequest}); 
        }
        public String GetBundleType(TM_Service_Request__c tmRequest) {
            return (String)handleMethodInvocation('GetBundleType', new List<Object>{tmRequest});
        }
        public String GetProductType(TM_Service_Request__c tmRequest) {
            return (String)handleMethodInvocation('GetProductType', new List<Object>{tmRequest});  
        } 
        public Tm_Service_Request_Packet__c GetPacket(Id packetId) {
            return (Tm_Service_Request_Packet__c)handleMethodInvocation('GetPacket', new List<Object>{packetId});
        }
        public Tm_Fee_Schedule__c GetSchedule(Id scheduleId) {
            return (Tm_Fee_Schedule__c)handleMethodInvocation('GetSchedule', new List<Object>{scheduleId});
        }
        public Tm_Product__c GetProductType(Id productId) {
            return (Tm_Product__c)handleMethodInvocation('GetProductType', new List<Object>{productId});
        }
        public List<Tm_Service_Request__c> GetRequests(String clientType, String bundleType, String productName) {
            return (List<Tm_Service_Request__c>)handleMethodInvocation('GetRequests', new List<Object>{clientType, bundleType, productName});
        }
        public Tm_Service_Request_Stage__c GetStage(Id stageId) {
            return (Tm_Service_Request_Stage__c)handleMethodInvocation('GetStage', new List<Object>{stageId});
        }
    }
}