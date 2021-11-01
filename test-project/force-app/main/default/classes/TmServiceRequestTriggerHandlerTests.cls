@IsTest
private class TmServiceRequestTriggerHandlerTests {

    private static TmServiceRequestTriggerHandler sut;
    private static final TmConfigurationMock.ofIStageRepository mockStageRepository; 
    private static final Mock.ofIObjectActionLogService mockStageLogger;
    private static final Mock.ofIUtility mockUtility;
    private static final MockOfITmFeeCalculator mockFeeCalculator;
    private static final MockOfITMPacketStageCalculator mockPacketCalculator; 
    private static final Mock.ofIDataProvider mockDataProvider;
    private static final Mock.ofISystem mockSystem;
    
    static {
        mockStageRepository = new TmConfigurationMock.ofIStageRepository();
        mockStageLogger = new Mock.ofIObjectActionLogService();
        mockUtility = new Mock.ofIUtility();
        mockFeeCalculator = new MockOfITmFeeCalculator();
        mockPacketCalculator = new MockOfITMPacketStageCalculator();
        mockDataProvider = new Mock.ofIDataProvider();
        mockSystem = new Mock.ofISystem();
        sut = new TmServiceRequestTriggerHandler(mockStageRepository, mockStageLogger , mockUtility, mockFeeCalculator, mockPacketCalculator, mockDataProvider, mockSystem); 
    }

    @IsTest
    static void it_should_call_the_fee_calculator_once_when_inserting_records_bulkBeforeInsert() {
        //Assemble
        Id reqId01 = ObjectFactory.getFakeId(Tm_Service_Request__c.SObjectType, '1');
        Tm_Service_Request__c req1 = new Tm_Service_Request__c();
        req1.Id = reqId01;
        Id reqId02= ObjectFactory.getFakeId(Tm_Service_Request__c.SObjectType, '2');
        Tm_Service_Request__c req2 = new Tm_Service_Request__c();
        req2.Id = reqId02;
        
        List<SObject> newSos = new List<SObject>{req1, req2};
        //Act
        sut.bulkBeforeInsert(newSos);
        //Assert
        mockFeeCalculator.verify('Calculate', new List<Object>{newSos}, Times.Once);
    }
    
    @IsTest
    static void it_should_call_the_fee_calculator_once_when_updating_records_bulkBeforeUpdate() {
        //Assemble
        Id reqId01 = ObjectFactory.getFakeId(Tm_Service_Request__c.SObjectType, '1');
        Tm_Service_Request__c req1 = new Tm_Service_Request__c();
        req1.Id = reqId01;
        Id reqId02= ObjectFactory.getFakeId(Tm_Service_Request__c.SObjectType, '2');
        Tm_Service_Request__c req2 = new Tm_Service_Request__c();
        req2.Id = reqId02;
        
        List<SObject> oldSos = new List<SObject>{req1, req2};
        Map<Id, SObject> newSosMap = new Map<Id, SObject>{reqId01=>req1, reqId02=>req2};
        //Act
        sut.bulkBeforeUpdate(oldSos, newSosMap);
        //Assert
        mockFeeCalculator.verify('Calculate', new List<Object>{newSosMap.values()}, Times.Once);
    }

    @IsTest
	static void it_should_log_intitial_request_stage_values_on_bulkAfterInsert() {
        Id docStageId = ObjectFactory.getFakeId(TM_Service_Request_Stage__c.SObjectType, '1');
        Id opsStageId = ObjectFactory.getFakeId(TM_Service_Request_Stage__c.SObjectType, '2');

        DmTmRequestStage dmDocStage = new DmTmRequestStage();
        dmDocStage.Id = docStageId;
        dmDocStage.Name = 'Documentation Cycle';

        DmTmRequestStage dmOpsStage = new DmTmRequestStage();
        dmOpsStage.Id = opsStageId;
        dmOpsStage.Name = 'Ops Review';

        List<DmTmRequestStage> dmStages = new List<DmTmRequestStage>{dmDocStage,dmOpsStage};
        
        Tm_Service_Request__c req01 = new Tm_Service_Request__c();
        req01.Stage__c = docStageId;
        Tm_Service_Request__c req02 = new Tm_Service_Request__c();
        req02.Stage__c = opsStageId;

        List<Tm_Service_Request__c> sos = new List<Tm_Service_Request__c>{req01,req02};

        mockStageLogger.setup('getCachedLogs').returns(new List<Object_Action_Log__c>());
        mockStageRepository.setup('getAllStages').returns(dmStages);
        //act
        sut.bulkAfterInsert(sos);
        //assert
        //TODO:TEST FOR NEW SIGNATURE
        mockStageLogger.verify('log', new List<Object>{'TM_Service_Request__c', String.valueOf(req01.Id), 'Stage Logging', 'Documentation Cycle'}, Times.Once);
        mockStageLogger.verify('log', new List<Object>{'TM_Service_Request__c', String.valueOf(req02.Id), 'Stage Logging', 'Ops Review'}, Times.Once);
        mockStageLogger.verify('getCachedLogs', Times.Once);
    }

    @IsTest
	static void it_should_log_only_changed_stage_values_on_bulkBeforeUpdate() {
        Id docStageId = ObjectFactory.getFakeId(TM_Service_Request_Stage__c.SObjectType, '1');
        Id opsReviewStageId = ObjectFactory.getFakeId(TM_Service_Request_Stage__c.SObjectType, '2');

        DmTmRequestStage dmDocStage = new DmTmRequestStage();
        dmDocStage.Id = docStageId;
        dmDocStage.Name = 'Documentation Cycle';
        DmTmRequestStage dmOpsReviewStage = new DmTmRequestStage();
        dmOpsReviewStage.Id = opsReviewStageId;
        dmOpsReviewStage.Name = 'Ops Review';

        List<DmTmRequestStage> dmStages = new List<DmTmRequestStage>{dmDocStage,dmOpsReviewStage};
        
        Id reqId01 = ObjectFactory.getFakeId(Tm_Service_Request__c.SObjectType, '1');
        Tm_Service_Request__c oldReq01 = new Tm_Service_Request__c();
        oldReq01.Id = reqId01;
        oldReq01.Stage__c = docStageId;
        Tm_Service_Request__c newReq01 = new Tm_Service_Request__c();
        newReq01.Id = reqId01;
        newReq01.Stage__c = opsReviewStageId;
        Id reqId02 = ObjectFactory.getFakeId(Tm_Service_Request__c.SObjectType, '2');
        Tm_Service_Request__c oldReq02 = new Tm_Service_Request__c();
        oldReq02.Id = reqId02;
        oldReq02.Stage__c = docStageId;
        Tm_Service_Request__c newReq02 = new Tm_Service_Request__c();
        newReq02.Id = reqId02;
        newReq02.Stage__c = docStageId;
        List<Tm_Service_Request__c> oldSos = new List<Tm_Service_Request__c>{oldReq01,oldReq02};
        Map<Id, SObject> newSosMap = new Map<Id, SObject>{newReq01.Id=>newReq01, newReq02.Id=>newReq02};

        mockStageRepository.setup('getAllStages').returns(dmStages);
        mockStageLogger.setup('getCachedLogs').returns(new List<Object_Action_Log__c>());
        //act
        sut.bulkBeforeUpdate(oldSos, newSosMap);
        //assert
        //TODO:TEST FOR NEW SIGNATURE
        mockStageLogger.verify('log', new List<Object>{'TM_Service_Request__c', String.valueOf(newReq01.Id), 'Stage Logging', 'Ops Review'}, Times.Once);
        mockStageLogger.verify('log', new List<Object>{'TM_Service_Request__c', String.valueOf(newReq02.Id), 'Stage Logging', 'Documentation Cycle'}, Times.Never);
    }

    @IsTest
	static void it_should_call_recordCachedLogs_the_request_logs_bulkBeforeUpdate() {
        Id docStageId = ObjectFactory.getFakeId(TM_Service_Request_Stage__c.SObjectType, '1');
        Id opsReviewStageId = ObjectFactory.getFakeId(TM_Service_Request_Stage__c.SObjectType, '2');

        DmTmRequestStage dmDocStage = new DmTmRequestStage();
        dmDocStage.Id = docStageId;
        dmDocStage.Name = 'Documentation Cycle';
        DmTmRequestStage dmOpsReviewStage = new DmTmRequestStage();
        dmOpsReviewStage.Id = opsReviewStageId;
        dmOpsReviewStage.Name = 'Ops Review';

        List<DmTmRequestStage> dmStages = new List<DmTmRequestStage>{dmDocStage,dmOpsReviewStage};
        
        Id reqId01 = ObjectFactory.getFakeId(Tm_Service_Request__c.SObjectType, '1');
        Tm_Service_Request__c oldReq01 = new Tm_Service_Request__c();
        oldReq01.Stage__c = docStageId;
        Tm_Service_Request__c newReq01 = new Tm_Service_Request__c();
        newReq01.Stage__c = opsReviewStageId;
        Id reqId02 = ObjectFactory.getFakeId(Tm_Service_Request__c.SObjectType, '2');
        Tm_Service_Request__c oldReq02 = new Tm_Service_Request__c();
        oldReq02.Stage__c = docStageId;
        Tm_Service_Request__c newReq02 = new Tm_Service_Request__c();
        newReq02.Stage__c = opsReviewStageId;

        List<Tm_Service_Request__c> oldSos = new List<Tm_Service_Request__c>{oldReq01,oldReq02};
        Map<Id, SObject> newSosMap = new Map<Id, SObject>{newReq01.Id=>newReq01, newReq02.Id=>newReq02};

        Object_Action_Log__c expectedLog01 = new Object_Action_Log__c();
        expectedLog01.Object_API_Name__c = 'TM_Service_Request__c';
        expectedLog01.Object_Id__c = reqId01;
        expectedLog01.Action__c = 'Ops Review';

        Object_Action_Log__c expectedLog02 = new Object_Action_Log__c();
        expectedLog02.Object_API_Name__c = 'TM_Service_Request__c';
        expectedLog02.Object_Id__c = reqId02;
        expectedLog02.Action__c = 'Ops Review';

        List<Object_Action_Log__c> expectedLogs = new List<Object_Action_Log__c>{expectedLog01,expectedLog02};

        mockPacketCalculator.setup('calculate', new List<Object>{newSosMap.values()}).returns(new List<TM_Service_Request_Packet__c>());
        mockStageRepository.setup('getAllStages').returns(dmStages);        
        //act
        sut.bulkBeforeUpdate(oldSos, newSosMap);
        //assert
        mockStageLogger.verify('recordCachedLogs', Times.Once);
    }

    @IsTest
	static void it_should_create_an_unknown_log_when_the_stage_is_not_in_the_stageMap_bulkAfterUpdate() {
        Id docStageId = ObjectFactory.getFakeId(TM_Service_Request_Stage__c.SObjectType, '1');
        Id opsReviewStageId = ObjectFactory.getFakeId(TM_Service_Request_Stage__c.SObjectType, '2');
        
        Id reqId01 = ObjectFactory.getFakeId(Tm_Service_Request__c.SObjectType, '1');
        Tm_Service_Request__c oldReq01 = new Tm_Service_Request__c();
        oldReq01.Id = reqId01;
        oldReq01.Stage__c = docStageId;
        Tm_Service_Request__c newReq01 = new Tm_Service_Request__c();
        newReq01.Id = reqId01;
        newReq01.Stage__c = opsReviewStageId;

        List<Tm_Service_Request__c> oldSos = new List<Tm_Service_Request__c>{oldReq01};
        Map<Id, SObject> newSosMap = new Map<Id, SObject>{newReq01.Id=>newReq01};

        mockStageRepository.setup('getAllStages').returns(new List<DmTmRequestStage>());
        mockStageLogger.setup('getCachedLogs').returns(new List<Object_Action_Log__c>());
        //act
        sut.bulkBeforeUpdate(oldSos, newSosMap);
        //assert
        mockStageLogger.verify('log', new List<Object>{'TM_Service_Request__c', String.valueOf(newReq01.Id), 'Stage Logging', 'Unknown'}, Times.Once);  //TODO:TEST FOR NEW SIGNATURE
    }

    @IsTest
    static void it_should_call_save_on_the_dataProvider_with_the_calculated_packets_once_bulkAfterInsert() {
        Tm_Service_Request__c req1 = new Tm_Service_Request__c();
        Tm_Service_Request__c req2 = new Tm_Service_Request__c();

        Id packetId01 = ObjectFactory.getFakeId(TM_Service_Request_Packet__c.SObjectType, '1');
        TM_Service_Request_Packet__c packet01 = new TM_Service_Request_Packet__c();
        packet01.Id = packetId01;
        packet01.Name = 'test name 1';

        List<TM_Service_Request_Packet__c> packetList = new List<TM_Service_Request_Packet__c>{packet01};
        
        List<SObject> sos = new List<SObject>{req1, req2};
        
        mockStageLogger.setup('getCachedLogs').returns(new List<Object_Action_Log__c>());
        mockStageRepository.setup('getAllStages').returns(new List<DmTmRequestStage>());
        mockPacketCalculator.setup('calculate', new List<Object>{sos}).returns(packetList);
        //act
        sut.bulkAfterInsert(sos);
        //assert
        mockDataProvider.verify('save', new List<Object>{packetList}, Times.Once);
    }

    @IsTest
    static void it_should_call_save_on_the_dataProvider_with_the_calculated_packets_once_bulkAfterUpdate() {
        Id reqId01 = ObjectFactory.getFakeId(Tm_Service_Request__c.SObjectType, '1');
        Tm_Service_Request__c req1 = new Tm_Service_Request__c();
        req1.Id = reqId01;
        Id reqId02= ObjectFactory.getFakeId(Tm_Service_Request__c.SObjectType, '2');
        Tm_Service_Request__c req2 = new Tm_Service_Request__c();
        req2.Id = reqId02;

        Id packetId01 = ObjectFactory.getFakeId(TM_Service_Request_Packet__c.SObjectType, '1');
        TM_Service_Request_Packet__c packet01 = new TM_Service_Request_Packet__c();
        packet01.Id = packetId01;
        packet01.Name = 'test name 1';

        List<TM_Service_Request_Packet__c> packetList = new List<TM_Service_Request_Packet__c>{packet01};
        List<TM_Service_Request__c> oldSos = new List<TM_Service_Request__c>{req1, req2};
        Map<Id, Sobject> newSos = new Map<Id, Sobject>{reqId01 => req1, reqId02 => req2};
        
        mockPacketCalculator.setup('calculate', new List<Object>{newSos.values()}).returns(packetList);
        mockStageLogger.setup('getCachedLogs').returns(new List<Object_Action_Log__c>());
        //act
        sut.bulkAfterUpdate(oldSos, newSos);
        //assert
        mockDataProvider.verify('save', new List<Object>{packetList}, Times.Once);
    }
    
    @IsTest
    static void it_should_log_current_stage_and_auto_forward_stage_when_an_auto_forward_exists_on_stage_on_bulkBeforeUpdate() {        
        Id newStageId = ObjectFactory.getFakeId(TM_Service_Request_Stage__c.SObjectType, '0');
        Id docCycleStageId = ObjectFactory.getFakeId(TM_Service_Request_Stage__c.SObjectType, '1');
        Id signatureCompleteStageId = ObjectFactory.getFakeId(TM_Service_Request_Stage__c.SObjectType, '2');
        Id opsReviewStageId = ObjectFactory.getFakeId(TM_Service_Request_Stage__c.SObjectType, '3');
        
        DmTmRequestStage stageNew = new DmTmRequestStage();
		stageNew.Id = newStageId;
        stageNew.Name = 'New';        
        
        DmTmRequestStage stageOpsReview = new DmTmRequestStage();
		stageOpsReview.Id = opsReviewStageId;
        stageOpsReview.Name = 'Ops Review';        
        
        DmTmRequestStage stageSignatureComplete = new DmTmRequestStage();
		stageSignatureComplete.Id = signatureCompleteStageId;
        stageSignatureComplete.Name = 'Signature Complete';
        stageSignatureComplete.AutoForwardStage = stageOpsReview;
        
        DmTmRequestStage stageDocCycle = new DmTmRequestStage();
        stageDocCycle.Id = docCycleStageId;
        stageDocCycle.Name = 'Documentation Cycle';
        stageDocCycle.AutoForwardStage = stageSignatureComplete;        
        
        List<DmTmRequestStage> dmStages = new List<DmTmRequestStage>{stageNew,stageDocCycle,stageOpsReview,stageSignatureComplete};
        
        Id reqId01 = ObjectFactory.getFakeId(Tm_Service_Request__c.SObjectType, '1');
        Tm_Service_Request__c oldReq01 = new Tm_Service_Request__c(Id=reqId01, Stage__c=newStageId);
        Tm_Service_Request__c newReq01 = new Tm_Service_Request__c(Id=reqId01, Stage__c=docCycleStageId);        

        List<Tm_Service_Request__c> oldSos = new List<Tm_Service_Request__c>{oldReq01};
        Map<Id, SObject> newSosMap = new Map<Id, SObject>{newReq01.Id=>newReq01};

        mockStageLogger.setup('getCachedLogs').returns(new List<Object_Action_Log__c>());
        mockStageRepository.setup('getAllStages').returns(dmStages);
        
        //act
        sut.bulkBeforeUpdate(oldSos, newSosMap);
        
        //assert
        System.assertEquals(opsReviewStageId, newReq01.Stage__c);
        mockStageLogger.verify('log', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Thrice);
        mockStageLogger.verify('log', new List<Object>{'TM_Service_Request__c', String.valueOf(reqId01), 'Stage Logging', 'Documentation Cycle'}, Times.Once);//TODO:TEST FOR NEW SIGNATURE
        mockStageLogger.verify('log', new List<Object>{'TM_Service_Request__c', String.valueOf(reqId01), 'Stage Logging', 'Signature Complete'}, Times.Once);
        mockStageLogger.verify('log', new List<Object>{'TM_Service_Request__c', String.valueOf(reqId01), 'Stage Logging', 'Ops Review'}, Times.Once);        
    }

    @IsTest
    static void code_coverage_for_constructor() {
        TmServiceRequestTriggerHandler hld = new TmServiceRequestTriggerHandler();
    }

    // @IsTest
    static void INTEGRATION_it_should_not_fail_after_update_dmls() {
        records_setup(200); 
        List<TM_Service_Request_Packet__c> packetIds = [SELECT Id FROM TM_Service_Request_Packet__c WHERE Name LIKE 'integrationPacket%'];
        TM_Service_Request_Stage__c documentationCycleStage = [SELECT Id FROM TM_Service_Request_Stage__c WHERE Name = 'Documentation Cycle' LIMIT 1];
        TM_Service_Request_Stage__c opsReviewStage = [SELECT Id FROM TM_Service_Request_Stage__c WHERE Name = 'Ops Review' LIMIT 1];
        System.debug('Query count after assigments: ' + Limits.getQueries());
        List<TM_Service_Request__c> requests = new List<TM_Service_Request__c>();
        for (TM_Service_Request_Packet__c packetId : packetIds) {
            TM_Service_Request__c request = new TM_Service_Request__c();
            request.TM_Service_Request_Packet__c = packetId.Id;
            request.Stage__c = documentationCycleStage.Id;
            requests.add(request);
        }
            insert requests;
        System.debug('Query count after request insert: ' + Limits.getQueries());
        for (TM_Service_Request__c request : requests) {
            request.Stage__c = opsReviewStage.Id;
        }
        test.startTest();
            update requests;
            System.debug('I have performed ' + Limits.getQueries() + ' and I am allowed up to ' + Limits.getLimitQueries() + ' within this request');
        test.stopTest();
        System.assert(true);
    }

    private static void records_setup(Integer count) {
            List<TM_Service_Request_Packet__c> packets = new List<TM_Service_Request_Packet__c>();
            for (Integer i = 1; i<=count; i++) {
                packets.add(new TM_Service_Request_Packet__c(Name = 'integrationPacket'+i));
            }
            insert packets;
            System.debug('setup packet query count' + Limits.getQueries());

            TM_Service_Request_Stage__c documentationCycle = new TM_Service_Request_Stage__c();
            documentationCycle.Name = 'Documentation Cycle';
            TM_Service_Request_Stage__c opsReview = new TM_Service_Request_Stage__c();
            opsReview.Name = 'Ops Review';
            List<TM_Service_Request_Stage__c> stages = new List<TM_Service_Request_Stage__c>{documentationCycle,opsReview};

            insert stages;
            System.debug('setup stage query count' + Limits.getQueries());
    }

    //@IsTest
    static void INTEGRATION_it_should_not_create_duplicate_stage_logs() {
        TM_Service_Request_Packet__c packet01 = new TM_Service_Request_Packet__c();
        packet01.Name = 'test packet 01';
        List<TM_Service_Request_Packet__c> packets = new List<TM_Service_Request_Packet__c>{packet01};

        insert packets;

        TM_Service_Request_Stage__c docStage = new TM_Service_Request_Stage__c();
        docStage.Name = 'Documentation Cycle';
        TM_Service_Request_Stage__c opsReviewStage = new TM_Service_Request_Stage__c();
        opsReviewStage.Name = 'Ops Review';
        List<TM_Service_Request_Stage__c> stages = new List<TM_Service_Request_Stage__c>{docStage,opsReviewStage};

        insert stages;

        TM_Service_Request__c req01 = new TM_Service_Request__c();
        req01.Stage__c = docStage.Id;
        req01.TM_Service_Request_Packet__c =  packet01.Id;

        List<TM_Service_Request__c> insertRequests = new List<TM_Service_Request__c>{req01};

        insert insertRequests;

        TM_Service_Request__c oldReq = new TM_Service_Request__c(Id = req01.Id, Stage__c = docStage.Id, TM_Service_Request_Packet__c = packet01.Id);

        req01.Stage__c = opsReviewStage.Id;

        List<Tm_Service_Request__c> oldSos = new List<Tm_Service_Request__c>{oldReq};
        Map<Id, SObject> newSosMap = new Map<Id, SObject>();
        newSosMap.put(req01.Id, req01);

        TmServiceRequestTriggerHandler sut01 = new TmServiceRequestTriggerHandler();
        TmServiceRequestTriggerHandler sut02 = new TmServiceRequestTriggerHandler();
        //act
        sut01.bulkAfterUpdate(oldSos, newSosMap);
        sut02.bulkAfterUpdate(oldSos, newSosMap);
        //assert
        List<Object_Action_Log__c> logs = [SELECT Id, Object_API_Name__c, Object_Id__c, Action__c, Action_Date_Time__c FROM Object_Action_Log__c WHERE Object_Id__c =: req01.Id ORDER BY createdDate];

        Utility.debug_Log(logs);
        System.assertEquals(2, logs.size());
        System.assertEquals('Documentation Cycle', logs[0].Action__c);
        System.assertEquals('Ops Review', logs[1].Action__c);
    }

    private class MockOfITmFeeCalculator extends ApexMoq implements TmFeeCalculator.ITmFeeCalculator {
        public List<DmTmRequest> Calculate(List<DmTmRequest> requests) {
           return (List<DmTmRequest>)handleMethodInvocation('Calculate', new List<Object>{requests}); 
        }
        public List<Tm_Service_Request__c> Calculate(List<Tm_Fee__c> fees) {
           return (List<Tm_Service_Request__c>)handleMethodInvocation('Calculate', new List<Object>{fees}); 
        }
        public List<TM_Service_Request__c> Calculate(List<TM_Service_Request__c> requests) {
           return (List<TM_Service_Request__c>)handleMethodInvocation('Calculate', new List<Object>{requests}); 
        }
        public List<Tm_Service_Request__c> Calculate(List<Tm_Fee_Schedule__c> schedules) {
           return (List<Tm_Service_Request__c>)handleMethodInvocation('Calculate', new List<Object>{schedules}); 
        }
        public List<Tm_Service_Request_Packet__c> Calculate(List<Tm_Service_Request_Packet__c> packets) {            
            return (List<Tm_Service_Request_Packet__c>)handleMethodInvocation('Calculate', new List<Object>{packets}); 
        }
    }

    private class MockOfITMPacketStageCalculator extends ApexMoq implements TMPacketStageCalculator.ITMPacketStageCalculator {
        public List<Tm_Service_Request_Packet__c> calculate(List<TM_Service_Request__c> requests) {
            return (List<Tm_Service_Request_Packet__c>)handleMethodInvocation('calculate', new List<Object>{requests});
        }
    }
}