@isTest
public class EntityActionTriggerHandlerTests {
    private static final EntityActionTriggerHandler sut;
    private static final Mock.ofIObjectActionLogService mockStageLogger;
    private static final MockOfIEntityActionDataProvider mockDataProvider;
    static{
        mockStageLogger = new Mock.ofIObjectActionLogService();
        mockDataProvider = new MockOfIEntityActionDataProvider();
        sut = new EntityActionTriggerHandler(mockStageLogger, mockDataProvider);
    }
    
    private static testMethod void it_should_log_stage_changes_on_bulkAfterUpdate(){
        Id actionId1 = ObjectFactory.getFakeId(Entity_Action__c.SObjectType, '1');
        Id actionId2 = ObjectFactory.getFakeId(Entity_Action__c.SObjectType, '2');
        
        Entity_Action__c oldAction1 = new Entity_Action__c();
        oldAction1.Id = actionId1;
        oldAction1.Status__c = 'New';
        Entity_Action__c oldAction2 = new Entity_Action__c();
        oldAction2.Id = actionId2;
        oldAction2.Status__c = 'In Process';

        List<Entity_Action__c> oldSos = new List<Entity_Action__c>{oldAction1,oldAction2};

        Entity_Action__c newAction1 = new Entity_Action__c();
        newAction1.Id = actionId1;
        newAction1.Status__c = 'In Process';
        Entity_Action__c newAction2 = new Entity_Action__c();
        newAction2.Id = actionId2;
        newAction2.Status__c = 'In Process';

        Map<Id, Sobject> newSosMap = new Map<Id, Sobject>();
        newSosMap.put(newAction1.Id, newAction1);
        newSosMap.put(newAction2.Id, newAction2);

        mockStageLogger.setup('getCachedLogs').returns(new List<Object_Action_Log__c>());
        //act
        sut.bulkAfterUpdate(oldSos, newSosMap);
        //assert
        mockStageLogger.verify('log', new List<Object>{'Entity_Action__c', String.valueOf(newAction1.Id), 'Stage Logging','In Process'}, Times.Once);
        mockStageLogger.verify('log', new List<Object>{'Entity_Action__c', String.valueOf(newAction2.Id), 'Stage Logging','In Process'}, Times.Never);
    }
    private static testMethod void it_should_log_the_initial_stage_when_bulkAfterInsert_is_called(){
        Entity_Action__c action1 = new Entity_Action__c();
        action1.Status__c = 'New';
        Entity_Action__c action2 = new Entity_Action__c();
        action2.Status__c = 'In Process';

        List<Entity_Action__c> sos = new List<Entity_Action__c>{action1, action2};

        mockStageLogger.setup('getCachedLogs').returns(new List<Object_Action_Log__c>());
        //act
        sut.bulkAfterInsert(sos);
        //assert
        mockStageLogger.verify('log', new List<Object>{'Entity_Action__c', String.valueOf(action1.Id), 'Stage Logging', 'New'}, Times.Once);
        mockStageLogger.verify('log', new List<Object>{'Entity_Action__c', String.valueOf(action2.Id), 'Stage Logging', 'In Process'}, Times.Once);
    }
    private static testMethod void it_should_code_cover_the_constructor(){
        EntityActionTriggerHandler eath = new EntityActionTriggerHandler();
    }
    
    private class MockOfIEntityActionDataProvider extends ApexMoq implements EntityActionTriggerHandler.IEntityActionDataProvider{
        public void save(List<SObject> objs){
            handleMethodInvocation('save', new List<Object>{objs});
        }
    }

}