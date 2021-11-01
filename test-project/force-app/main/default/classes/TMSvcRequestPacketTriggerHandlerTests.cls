@IsTest
public class TMSvcRequestPacketTriggerHandlerTests {

    private static final MockOfITmFeeCalculator mockFeeCalculator; 
    private static final MockOfITmServiceRequestPacketDataProvider mockDataProv;
    private static final Mock.ofIObjectActionLogService mockStageLogger;
    private static final TmConfigurationMock.ofIStageRepository mockStageRepository;
    private static final TMServiceRequestPacketTriggerHandler sut;
    
    static {
        mockFeeCalculator = new MockOfITmFeeCalculator();
        mockDataProv = new MockOfITmServiceRequestPacketDataProvider();
        mockStageLogger = new Mock.ofIObjectActionLogService();
        mockStageRepository = new TmConfigurationMock.ofIStageRepository();
        sut = new TMServiceRequestPacketTriggerHandler(mockFeeCalculator, mockDataProv, mockStageLogger, mockStageRepository); 
    }

    @IsTest
    static void code_coverage_for_constructor() {
        TMServiceRequestPacketTriggerHandler hld = new TMServiceRequestPacketTriggerHandler();
    }

    @IsTest
    static void it_should_call_saveObjects_on_the_dataProvider_once_when_given_multiple_packets() { 
        //assemble
        Id packId1 = ObjectFactory.getFakeId(Tm_Service_Request_Packet__c.SObjectType, '1');
        Tm_Service_Request_Packet__c oldPack1 = new Tm_Service_Request_Packet__c();
        oldPack1.Client_Type__c = 'Business Banking';
        oldPack1.Id = packId1;
        
        Tm_Service_Request_Packet__c newPack1 = new Tm_Service_Request_Packet__c();
        newPack1.Client_Type__c = 'Commercial Banking';
        newPack1.Id = packId1;
        
        Id packId2 = ObjectFactory.getFakeId(Tm_Service_Request_Packet__c.SObjectType, '3');
        Tm_Service_Request_Packet__c notChangingPack2 = new Tm_Service_Request_Packet__c();
        notChangingPack2.Id = packId2;
        
        Id reqId = ObjectFactory.getFakeId(Tm_Service_Request__c.SObjectType, '1');
        Tm_Service_Request__c tmRequest = new Tm_Service_Request__c(); 
        tmRequest.Id = reqId;
        tmRequest.TM_Service_Request_Packet__r = oldPack1;
        List<Tm_Service_Request__c> tmRequests = new List<Tm_Service_Request__c>{tmRequest};
            
        List<SObject> oldsos = new List<SObject>{oldPack1, notChangingPack2};
        Map<Id, SObject> newMap = new Map<Id, SObject>{packId1=> newPack1, packId2=>notChangingPack2};
        
        List<Id> packetIdList = new List<Id>{packId1};

        mockDataProv.setup('getTmServiceRequestsByPacket', new List<Object>{packetIdList}).returns(tmRequests);
        mockFeeCalculator.setup('Calculate', new List<Object>{tmRequests}).returns(tmRequests);
        mockStageLogger.setup('getCachedLogs').returns(new List<Object_Action_Log__c>());
        //act
        sut.bulkAfterUpdate(oldsos, newMap);
        //assert
        mockDataProv.verify('save', new List<Object>{tmRequests}, Times.Once);
    }
    
    @IsTest
    static void it_should_call_saveObjects_with_an_empty_list_of_objects_if_client_and_bundle_type_dont_change() { 
        //assemble
        Id packId1 = ObjectFactory.getFakeId(Tm_Service_Request_Packet__c.SObjectType, '1');
        Tm_Service_Request_Packet__c oldPack = new Tm_Service_Request_Packet__c();
        oldPack.Client_Type__c = 'Business Banking';
        oldPack.Id = packId1;
        
        Tm_Service_Request_Packet__c newPack = new Tm_Service_Request_Packet__c();
        newPack.Client_Type__c = 'Business Banking';
        newPack.Id = packId1;
        
        Id reqId = ObjectFactory.getFakeId(Tm_Service_Request__c.SObjectType, '1');
        Tm_Service_Request__c tmRequest = new Tm_Service_Request__c();
        tmRequest.Id = reqId;
        tmRequest.TM_Service_Request_Packet__r = newPack;
        List<Tm_Service_Request__c> tmRequests = new List<Tm_Service_Request__c>{tmRequest};
            
        List<SObject> oldsos = new List<SObject>{oldPack};
        Map<Id, SObject> newMap = new Map<Id, SObject>{newPack.id=> newPack};

        mockDataProv.setup('soqlRequests').returns(tmRequests);
        mockFeeCalculator.setup('Calculate', new List<Object>{tmRequests}).returns(tmRequests);
        mockStageLogger.setup('getCachedLogs').returns(new List<Object_Action_Log__c>());
        //act
        sut.bulkAfterUpdate(oldsos, newMap);
        //assert
        mockDataProv.verify('save', new List<Object>{new List<SObject>()}, Times.Once);
    }

    @IsTest
    static void it_should_log_intitial_stage_values_on_bulkAfterInsert() {
        TM_Service_Request_Packet__c packet01 = new TM_Service_Request_Packet__c();
        packet01.Stage__c = 'Documentation';
        TM_Service_Request_Packet__c packet02 = new TM_Service_Request_Packet__c();
        packet02.Stage__c = 'Ops Review';

        List<TM_Service_Request_Packet__c> sos = new List<TM_Service_Request_Packet__c>{packet01,packet02};

        mockStageLogger.setup('getCachedLogs').returns(new List<Object_Action_Log__c>());
        //act
        sut.bulkAfterInsert(sos);
        //assert
        mockStageLogger.verify('log', new List<Object>{'TM_Service_Request_Packet__c', String.valueOf(packet01.Id), 'Stage Logging', 'Documentation'}, Times.Once);
        mockStageLogger.verify('log', new List<Object>{'TM_Service_Request_Packet__c', String.valueOf(packet02.Id), 'Stage Logging', 'Ops Review'}, Times.Once);
    }

    @IsTest
    static void it_should_log_stage_changes_on_bulkAfterUpdate() {
        Id packetId01 = ObjectFactory.getFakeId(Tm_Service_Request_Packet__c.SObjectType, '1');
        Id packetId02 = ObjectFactory.getFakeId(Tm_Service_Request_Packet__c.SObjectType, '2');
        
        TM_Service_Request_Packet__c oldPacket01 = new TM_Service_Request_Packet__c();
        oldPacket01.Id = packetId01;
        oldPacket01.Stage__c = 'Documentation';
        TM_Service_Request_Packet__c oldPacket02 = new TM_Service_Request_Packet__c();
        oldPacket02.Id = packetId02;
        oldPacket02.Stage__c = 'Ops Review';

        List<TM_Service_Request_Packet__c> oldSos = new List<TM_Service_Request_Packet__c>{oldPacket01,oldPacket02};

        TM_Service_Request_Packet__c newPacket01 = new TM_Service_Request_Packet__c();
        newPacket01.Id = packetId01;
        newPacket01.Stage__c = 'Ops Review';
        TM_Service_Request_Packet__c newPacket02 = new TM_Service_Request_Packet__c();
        newPacket02.Id = packetId02;
        newPacket02.Stage__c = 'Ops Review';

        Map<Id, Sobject> newSosMap = new Map<Id, Sobject>{packetId01=>newPacket01,packetId02=>newPacket02};

        mockStageLogger.setup('getCachedLogs').returns(new List<Object_Action_Log__c>());
        //act
        sut.bulkAfterUpdate(oldSos, newSosMap);
        //assert
        mockStageLogger.verify('log', new List<Object>{'TM_Service_Request_Packet__c', String.valueOf(newPacket01.Id), 'Stage Logging','Ops Review'}, Times.Once);
        mockStageLogger.verify('log', new List<Object>{'TM_Service_Request_Packet__c', String.valueOf(newPacket02.Id), 'Stage Logging','Ops Review'}, Times.Never);
    }
    
    private class MockOfITmFeeCalculator extends ApexMoq implements TmFeeCalculator.ITmFeeCalculator{  
        public List<TM_Service_Request__c> Calculate(List<TM_Service_Request__c> requests) {            
            return (List<TM_Service_Request__c>)handleMethodInvocation('Calculate', new List<Object>{requests}); 
        }
        public List<TM_Service_Request__c> Calculate(List<TM_Fee__c> fees) {            
            return (List<TM_Service_Request__c>)handleMethodInvocation('Calculate', new List<Object>{fees}); 
        }
        public List<TM_Service_Request__c> Calculate(List<TM_Fee_Schedule__c> schedules) {            
            return (List<TM_Service_Request__c>)handleMethodInvocation('Calculate', new List<Object>{schedules}); 
        }
        public List<Tm_Service_Request_Packet__c> Calculate(List<Tm_Service_Request_Packet__c> packets) {            
            return (List<Tm_Service_Request_Packet__c>)handleMethodInvocation('Calculate', new List<Object>{packets}); 
        }
    }
    private class MockOfITmServiceRequestPacketDataProvider extends Mock.ofIDataProvider implements TMServiceRequestPacketTriggerHandler.IDataProvider{
        public List<Tm_Service_Request__c> getTmServiceRequestsByPacket(List<Id> packetIds) {
            return (List<Tm_Service_Request__c>)handleMethodInvocation('getTmServiceRequestsByPacket', new List<Object>{packetIds});
        }
    }
}