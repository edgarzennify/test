public class TaskTriggerHandler extends TriggerHandler{
    
    public interface ITaskDataProvider{
        void save(List<SObject> objs);
    }
    public interface ITaskCollectionTaskHandler{
        void handleCollectionTasks(List<SObject> sos, Map<Id, SObject> newSos);
    }
    
    public TaskTriggerHandler(){
        m_collectionHandler = new TaskCollectionTaskHandler();
    }
    public TaskTriggerHandler(ITaskCollectionTaskHandler collectionHandler){
        m_collectionHandler = collectionHandler;
    }
    
    private static ITaskCollectionTaskHandler m_collectionHandler;
    
    public override void bulkBeforeInsert(List<SObject> sos) {                                              
        m_collectionHandler.handleCollectionTasks(sos, new Map<Id, SObject>());
    }
    public override void bulkAfterInsert(List<SObject> sos) {                                              
        m_collectionHandler.handleCollectionTasks(sos, new Map<Id, SObject>());
    }
    public override void bulkBeforeUpdate(List<SObject> sos, Map<Id, SObject> newSos) {
        m_collectionHandler.handleCollectionTasks(sos, newSos);
    }

}