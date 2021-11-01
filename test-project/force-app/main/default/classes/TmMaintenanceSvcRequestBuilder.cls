public class TmMaintenanceSvcRequestBuilder implements ITmMaintenanceSvcRequestBuilder{
    
    public interface ITmMaintenanceSvcRequestBuilder {
        List<TmBoardingServiceProxy.TmMaintenanceStatusUpdateRequest> buildStatusUpdateRequest(List<TM_Maintenance__c> oldSObjs, Map<Id, TM_Maintenance__c> newSObjs );
    }
    
    private TmBoardingServiceProxy.ITmBoardingServiceProxy m_tmBoradingSvc;
    
    public List<TmBoardingServiceProxy.TmMaintenanceStatusUpdateRequest> buildStatusUpdateRequest(List<TM_Maintenance__c> oldSObjs, Map<Id, TM_Maintenance__c> newSObjs ){
        List<TmBoardingServiceProxy.TmMaintenanceStatusUpdateRequest> request = new List<TmBoardingServiceProxy.TmMaintenanceStatusUpdateRequest>();
             
        for(TM_Maintenance__c tmm : oldSObjs){
            TM_Maintenance__c newSObj = newSObjs.get(tmm.Id);
            if(newSObj != null && tmm.Status__c != newSObj.Status__c ){
                request.add(build(newSObj));
            }
        }
        return request;
    }
    
    private TmBoardingServiceProxy.TmMaintenanceStatusUpdateRequest build(TM_Maintenance__c item){
        TmBoardingServiceProxy.TmMaintenanceStatusUpdateRequest req = new TmBoardingServiceProxy.TmMaintenanceStatusUpdateRequest();
        req.SalesforceId = item.Id;
        req.Status = item.Status__c;
        req.SyncKey = item.Sync_Key__c;
        return req;
    }
    
    
    
}