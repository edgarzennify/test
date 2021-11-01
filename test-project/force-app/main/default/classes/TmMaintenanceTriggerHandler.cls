public class TmMaintenanceTriggerHandler extends TriggerHandler {
    
    private TmMaintenanceSvcRequestBuilder.ITmMaintenanceSvcRequestBuilder m_updateBuilder;
    private IJson m_jsonSerializer;
    
    public TmMaintenanceTriggerHandler(){
        m_updateBuilder = new TmMaintenanceSvcRequestBuilder();
        m_jsonSerializer = new JsonWrapper();
    }
        
    public TmMaintenanceTriggerHandler(TmMaintenanceSvcRequestBuilder.ITmMaintenanceSvcRequestBuilder updateBuilder, IJson jsonSerializer){
            m_updateBuilder = updateBuilder;
            m_jsonSerializer = jsonSerializer;
    }
    
    public override void bulkAfterUpdate(List<SObject> oldSos, Map<Id, SObject> newSosMap){
        updateMaintenance(oldSos, newSosMap);
    }

    private void updateMaintenance(List<SObject> oldSos, Map<Id, SObject> newSosMap){        
        List<TmBoardingServiceProxy.TmMaintenanceStatusUpdateRequest> request = m_updateBuilder.buildStatusUpdateRequest((List<TM_Maintenance__c>)oldSos, (Map<Id, TM_Maintenance__c>)newSosMap);
        if(request != null && request.size() > 0){
            String requestAsJson = m_jsonSerializer.serialize(request);           
            postMaintenanceUpdate(requestAsJson);
        }    
    }
    
    @future(callout=true)
    private static void  postMaintenanceUpdate(string requestJson){
        Configurations.IConfigurations cfg = Configurations.bootstrap();
        GatewayApiMetadataProvider.IGatewayApiMetadataProvider gtProvider = new GatewayApiMetadataProvider();
        WebServices.IRESTService restSvc = new RESTService(gtProvider, cfg);
        IJson j = new JsonWrapper();
    
        TmBoardingServiceProxy.ITmBoardingServiceProxy svc = new TmBoardingServiceProxy(restSvc, j);
        
        svc.sendMaintenanceStatus(requestJson);
    }
}