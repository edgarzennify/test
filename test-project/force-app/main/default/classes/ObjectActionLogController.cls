public class ObjectActionLogController {
 
    private final ObjectActionLogService.IObjectActionLogService m_loggingService;
 
    public ObjectActionLogController(){
        m_loggingService = ObjectActionLogService.bootstrap();
    }
    
    public ObjectActionLogController(ObjectActionLogService.IObjectActionLogService loggingService){
        m_loggingService = loggingService;
    }
    
    public List<ObjectActionLogService.Data> logs {get;set;}
    public String titleAttribute {get;set;}
    public Integer heightAttribute {get;set;}

    public String objectIdAttribute {
        get;
        set {
            objectIdAttribute = value;
            tryInitialize();
        }
    }
    
    public String actionTypeAttribute{
        get;
        set {
            actionTypeAttribute = value;
            tryInitialize();
        }
    }
    
    private void tryInitialize(){
        if (attributesAreNotNull(objectIdAttribute, actionTypeAttribute)) {
            initialize();
        }       
    }
    
    private void initialize(){
        ObjectActionLogService.ObjectAndTypeRequest request = new ObjectActionLogService.ObjectAndTypeRequest();
        request.ObjectRecordId = objectIdAttribute;
        request.ActionType = actionTypeAttribute;
        
        logs = m_loggingService.get(request);
    }

    private Boolean attributesAreNotNull(String objectIdAttribute, String actionTypeAttribute){
        return String.isEmpty(objectIdAttribute) || String.isEmpty(actionTypeAttribute) ?  false : true; 
    }
}