public class PaymentDecisionTriggerHandler extends TriggerHandler{
	
    
    private String opsAdminPermission = 'Function - Payment Decision - Admin';
    private String selectActionPermission = 'Function - Payment Decision - Select Actions';
    private String statusProcessed = 'Processed';
    private String statusNotProcessed = 'Not Processed';
    
    private IUserInfoService m_usrSvc;
    private ISystem m_sys;
    
    public PaymentDecisionTriggerHandler(){
        m_usrSvc = UserInfoService.bootstrap();
        m_sys = new SystemWrapper();
    }
    
    public PaymentDecisionTriggerHandler(IUserInfoService usrSvc, ISystem sys){
        m_usrSvc = usrSvc;
        m_sys = sys;
    }
    
    public override void bulkbeforeUpdate(List<SObject> oldSos, Map<Id, SObject> newSosMap){
        Id userId = m_usrSvc.getCurrentUserId();
        Boolean isAdmin = m_usrSvc.isSystemAdministrator(userId);
        Boolean isOpsAdmin = m_usrSvc.hasPermissionSet(userId,opsAdminPermission);
        Boolean isSelect = m_usrSvc.hasPermissionSet(userId,selectActionPermission);
        
        for(Payment_Decision__c p : (List<Payment_Decision__c>)oldSos){
            Payment_Decision__c newObj = (Payment_Decision__c)newSosMap.get(p.Id);
            if(!isAdmin && !isOpsAdmin && (isSelect && String.isNotBlank(p.Action__c) )){
                newObj.Action__c = p.Action__c;
                newObj.Action__c.addError('Changes not allowed to Action. Please contact Ops');
            }
            if(newObj.Status__c != null && newObj.Status__c == statusProcessed){
                newObj.Processed_Date__c = m_sys.today();
            }else{
                newObj.Processed_Date__c = null;
            }
        }


        
    }
}