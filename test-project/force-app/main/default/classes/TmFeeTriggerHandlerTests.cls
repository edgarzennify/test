@IsTest
public class TmFeeTriggerHandlerTests {
    
    private static final MockOfITmFeeCalculator mockCalc; 
    private static final Mock.ofIDataProvider mockDataProv; 
    private static final TmFeeTriggerHandler sut;
    
    static {
        mockCalc = new MockOfITmFeeCalculator();
        mockDataProv = new Mock.ofIDataProvider();
        sut = new TmFeeTriggerHandler(mockCalc, mockDataProv); 
    }
    
    @IsTest
    static void code_coverage_for_constructor() {
        TmFeeTriggerHandler hld = new TmFeeTriggerHandler();
    }
    
    @IsTest
    static void it_should_call_the_fee_calculator_once_when_inserting_records() {
        //assemble
        List<Tm_Fee__c> feeList = new List<Tm_Fee__c>();
        Tm_Fee__c fee = new Tm_Fee__c();
        feeList.add(fee);
        //act
        sut.BulkBeforeInsert(feeList);
        //assert
        mockCalc.verify('Calculate', new List<Object>{feeList}, Times.Once);
    }
    
    @IsTest
    static void it_should_call_the_data_provider_once_when_inserting_multiple_records() {
        //assemble
        List<Tm_Fee__c> feeList = new List<Tm_Fee__c>();
        Tm_Fee__c fee1 = new Tm_Fee__c();
        Tm_Fee__c fee2 = new Tm_Fee__c();
        feeList.add(fee1);
        feeList.add(fee2);
        
        Id reqId = ObjectFactory.getFakeId(Tm_Service_Request__c.SObjectType, '1');
        Tm_Service_Request__c tmRequest = new Tm_Service_Request__c();
        tmRequest.Id = reqId;
        
        List<Tm_Service_Request__c> tmRequests = new List<Tm_Service_Request__c>{tmRequest};
            
        mockCalc.setup('Calculate', new List<Object>{feeList}).returns(tmRequests);
        //act
        sut.BulkBeforeInsert(feeList);
        //assert
        mockDataProv.verify('saveObjects', new List<Object>{tmRequests}, Times.Once);
    }
    
    @IsTest
    static void it_should_call_the_fee_calculator_once_when_updating_records() {
        //assemble
        Id feeId = ObjectFactory.getFakeId(Tm_Fee__c.SObjectType, '1');
        Tm_Fee__c fee1 = new Tm_Fee__c();
        fee1.id = feeId;
        
        Tm_Fee__c fee2 = new Tm_Fee__c();
        fee2.id = feeId;
        
        List<SObject> oldSos = new List<SObject>{fee1};
        Map<Id, SObject> newMap = new Map<Id, SObject>{fee2.id=> fee2}; 
        //act
        sut.BulkAfterUpdate(oldSos, newMap);
        //assert
        mockCalc.verify('Calculate', new List<Object>{newMap.values()}, Times.Once);
    }
    
    @IsTest
    static void it_should_call_the_data_provider_once_when_updating_records() {
        //assemble
        Id feeId1 = ObjectFactory.getFakeId(Tm_Fee__c.SObjectType, '1');
        Tm_Fee__c fee1 = new Tm_Fee__c();
        fee1.id = feeId1;
        
        Id feeId2 = ObjectFactory.getFakeId(Tm_Fee__c.SObjectType, '2');
        Tm_Fee__c fee2 = new Tm_Fee__c();
        fee2.id = feeId2;
        
        Id feeId3 = ObjectFactory.getFakeId(Tm_Fee__c.SObjectType, '3');
        Tm_Fee__c fee3 = new Tm_Fee__c();
        fee3.id = feeId3;
        
        List<SObject> oldSos = new List<SObject>{fee1};
        Map<Id, SObject> newMap = new Map<Id, SObject>{fee2.id=> fee2}; 
        newMap.put(fee3.Id, fee3);
        
        Id reqId = ObjectFactory.getFakeId(Tm_Service_Request__c.SObjectType, '1');
        Tm_Service_Request__c tmRequest = new Tm_Service_Request__c();
        tmRequest.Id = reqId;
        List<Tm_Service_Request__c> tmRequests = new List<Tm_Service_Request__c>{tmRequest};
        
        mockCalc.setup('Calculate', new List<Object>{newMap.values()}).returns(tmRequests);
        //act
        sut.BulkAfterUpdate(oldSos, newMap);
        //assert
        mockDataProv.verify('saveObjects', new List<Object>{tmRequests}, Times.Once);
    }
    
    private class MockOfITmFeeCalculator extends ApexMoq implements TmFeeCalculator.ITmFeeCalculator {
        public List<TM_Service_Request__c> Calculate(List<TM_Service_Request__c> requests){            
            return (List<TM_Service_Request__c>)handleMethodInvocation('Calculate', new List<Object>{requests}); 
        }
        public List<TM_Service_Request__c> Calculate(List<TM_Fee__c> fees){            
            return (List<TM_Service_Request__c>)handleMethodInvocation('Calculate', new List<Object>{fees}); 
        }
    }
}