public class EntityActionTriggerHandler extends TriggerHandler{
    
    private final ObjectActionLogService.IObjectActionLogService m_stageLogger;
    private final IEntityActionDataProvider m_dataProvider;
    private String ENTITY_ACTION_OBJ_NAME = 'Entity_Action__c';
    private String STAGE_LOGGING = 'Stage Logging';
    
    public interface IEntityActionDataProvider{
        void save(List<SObject> objs);
    }
    
    public EntityActionTriggerHandler(){
        m_stageLogger = ObjectActionLogService.bootstrap();
        m_dataProvider = new EntityActionDataProvider();
    }
    public EntityActionTriggerHandler(ObjectActionLogService.IObjectActionLogService logger, IEntityActionDataProvider dataProv){
        m_stageLogger  = logger;
        m_dataProvider = dataProv;
    }
    
    public override void bulkAfterInsert(List<SObject> sos){
        List<SObject> objects = new List<Sobject>();
        objects.addAll(recordIntialStage(sos));       
        m_dataProvider.save(objects);
    }
    public override void bulkAfterUpdate(List<SObject> oldSos, Map<Id, SObject> newSosMap){
        List<SObject> objects = new List<SObject>();
        objects.addAll(recordStage(oldSos, newSosMap));
        m_dataProvider.save(objects);
    }
    
    private List<Object_Action_Log__c> recordIntialStage(List<SObject> entityActions){
        for (Entity_Action__c entityAction : (List<Entity_Action__c>)entityActions){
            m_stageLogger.log(ENTITY_ACTION_OBJ_NAME, entityAction.Id, STAGE_LOGGING, entityAction.Status__c);
        }
        return m_stageLogger.getCachedLogs();
    }
    private List<Object_Action_Log__c> recordStage(List<SObject> oldSos, Map<Id, SObject> newSosMap){
        for(Entity_Action__c vOld : (List<Entity_Action__c>)oldSos){
            Entity_Action__c vNew = (Entity_Action__c)newSosMap.get(vOld.Id);
            if(stageHasChanged(vOld, vNew)){
                m_stageLogger.log(ENTITY_ACTION_OBJ_NAME, vNew.Id, STAGE_LOGGING, vNew.Status__c);
            }
        }
        return m_stageLogger.getCachedLogs();
    }
    private Boolean stageHasChanged(Entity_Action__c vOld, Entity_Action__c vNew){
        if(String.isNotBlank(vNew.Status__c)){
            if(vOld.Status__c != null && vNew != null && vNew.Status__c != vOld.Status__c){
                return true;
            }  
        }
        return false;
    }

}