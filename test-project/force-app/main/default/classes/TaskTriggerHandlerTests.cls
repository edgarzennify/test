@isTest
public class TaskTriggerHandlerTests { 
    private static TaskTriggerHandler sut;
    private static MockOfTaskCollectionHandler mockHandler;
    static{
        mockHandler = new MockOfTaskCollectionHandler();
        sut = new TaskTriggerHandler(mockHandler);
    }
    private static testMethod void it_should_code_cover_the_constructor(){
        TaskTriggerHandler tth = new TaskTriggerHandler();
    }
    private static testMethod void it_should_call_the_collection_task_handler_when_bulkAfterInsert_is_called(){
        Task t = new Task();
        List<SObject> sos = new List<SObject>{t};
        Map<Id, SObject> newSos = new Map<Id, SObject>();
        sut.bulkAfterInsert(sos);
        mockHandler.verify('handleCollectionTasks', new List<Object>{sos, newSos}, Times.Once);
    }
    private static testMethod void it_should_call_the_collection_task_handler_when_bulkBeforeUpdate_is_called(){
        Task t = new Task();
        t.Id = ObjectFactory.getFakeId(Task.SObjectType, '1');
        List<SObject> sos = new List<SObject>{t};
        Map<Id, SObject> newSos = new Map<Id, SObject>();
        newSos.put(t.Id, t);
        sut.bulkBeforeUpdate(sos, newSos);
        mockHandler.verify('handleCollectionTasks', new List<Object>{sos, newSos}, Times.Once);
    }
    
    public class MockOfTaskCollectionHandler extends ApexMoq implements TaskTriggerHandler.ITaskCollectionTaskHandler{
        public void handleCollectionTasks(List<SObject> sos, Map<Id, SObject> newSos){
            handleMethodInvocation('handleCollectionTasks', new List<Object>{sos, newSos});
        }
    }

}