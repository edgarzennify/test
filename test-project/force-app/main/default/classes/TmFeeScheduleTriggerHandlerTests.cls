@IsTest
public class TmFeeScheduleTriggerHandlerTests {

    private static final MockOfITmFeeCalculator mockCalc; 
    private static final MockOfIDataProvider mockDataProv;
    private static final TmFeeScheduleTriggerHandler sut;
    
    static {
        mockCalc = new MockOfITmFeeCalculator();
        mockDataProv = new MockOfIDataProvider();
        sut = new TmFeeScheduleTriggerHandler(mockCalc, mockDataProv);
    }
    
    @IsTest
    static void code_coverage_for_constructor() {
        TmFeeScheduleTriggerHandler hld = new TmFeeScheduleTriggerHandler();
    }
    
    @IsTest
    static void it_should_call_the_fee_calculator_once_when_updating_multiple_fee_schedule_records() {
        //assemble
        Id schedId1 = ObjectFactory.getFakeId(Tm_Fee_Schedule__c.SObjectType, '1');
        Tm_Fee_Schedule__c oldSched1 = new Tm_Fee_Schedule__c();
        oldSched1.Bundle_Type__c = 'Optima Suite';
        oldSched1.Id = schedId1;
        
        Tm_Fee_Schedule__c newSched1 = new Tm_Fee_Schedule__c();
        newSched1.Bundle_Type__c = 'Agriculture Bundle';
        newSched1.Id = schedId1;
        
        Id schedId2 = ObjectFactory.getFakeId(Tm_Fee_Schedule__c.SObjectType, '3');
        Tm_Fee_Schedule__c notChangingSched2 = new Tm_Fee_Schedule__c();
        notChangingSched2.Id = schedId2;
        
        List<SObject> oldSos = new List<SObject>{oldSched1,notChangingSched2};
        Map<Id, SObject> newMap = new Map<Id, SObject>{schedId1=>newSched1, schedId2=>notChangingSched2};        
            
        Tm_Fee__c fee = new Tm_Fee__c();
        fee.TM_Fee_Schedule__c = schedId1;
        List<Tm_Fee__c> feeList = new List<Tm_Fee__c>{fee};
            
        mockDataProv.setup('getTmFeesByFeeSchedule', new List<Object>{new List<Id>{schedId1}}).returns(feeList);
        //act
        sut.BulkAfterUpdate(oldSos, newMap);
        //assert
        mockCalc.verify('Calculate', new List<Object>{feeList}, Times.Once);
    }
    
    @IsTest
    static void it_should_call_the_data_provider_once_when_updating_multiple_fee_schedule_records(){  
        //assemble
        Id schedId1 = ObjectFactory.getFakeId(Tm_Fee_Schedule__c.SObjectType, '1');
        Tm_Fee_Schedule__c oldSched1 = new Tm_Fee_Schedule__c();
        oldSched1.Bundle_Type__c = 'Optima Suite';
        oldSched1.Id = schedId1;
        
        Tm_Fee_Schedule__c newSched1 = new Tm_Fee_Schedule__c();
        newSched1.Bundle_Type__c = 'Agriculture Bundle';
        newSched1.Id = schedId1;
        
        Id schedId2 = ObjectFactory.getFakeId(Tm_Fee_Schedule__c.SObjectType, '3');
        Tm_Fee_Schedule__c notChangingSched2 = new Tm_Fee_Schedule__c();
        notChangingSched2.Id = schedId2;
        
        List<SObject> oldSos = new List<SObject>{oldSched1,notChangingSched2};
        Map<Id, SObject> newMap = new Map<Id, SObject>{schedId1=>newSched1, schedId2=>notChangingSched2};        
            
        Tm_Fee__c fee = new Tm_Fee__c();
        fee.TM_Fee_Schedule__c = schedId1;
        List<Tm_Fee__c> feeList = new List<Tm_Fee__c>{fee};
        
        Id reqId = ObjectFactory.getFakeId(Tm_Service_Request__c.SObjectType, '1');
        Tm_Service_Request__c tmRequest = new Tm_Service_Request__c();
        tmRequest.Id = reqId; 
        List<Tm_Service_Request__c> tmRequests = new List<Tm_Service_Request__c>{tmRequest};

        mockDataProv.setup('getTmFeesByFeeSchedule', new List<Object>{new List<Id>{schedId1}}).returns(feeList);
        mockCalc.setup('Calculate', new List<Object>{feeList}).returns(tmRequests);
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
    private class MockOfIDataProvider extends ApexMoq implements TmFeeScheduleTriggerHandler.IDataProvider{
        public List<String> saveObjects(List<SObject> objs){
            return (List<String>)handleMethodInvocation('saveObjects', new List<Object>{objs});
        }
        public List<Tm_Fee__c> getTmFeesByFeeSchedule(List<Id> feeScheduleIds){
            return (List<Tm_Fee__c>)handleMethodInvocation('getTmFeesByFeeSchedule', new List<Object>{feeScheduleIds});
        }
    }
}