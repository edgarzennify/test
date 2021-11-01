public class ApprovalProcessResultWrapper implements IApprovalProcessResult{
    
    public interface IApprovalProcessResultFactory{
        IApprovalProcessResult create(Approval.ProcessResult result);
    }
    
    public class ApprovalProcessResultFactory implements IApprovalProcessResultFactory{
        public IApprovalProcessResult create(Approval.ProcessResult result){
            return new ApprovalProcessResultWrapper(result);
        }
    }
    
    public interface IApprovalProcessResult{
        List<string> getErrors();
        Boolean isSuccess();
        String instanceId();
        String entityId();
    }
    
    private Approval.ProcessResult m_result;
	
    public ApprovalProcessResultWrapper(Approval.ProcessResult result){
        m_result = result;
    }
    
    public List<string> getErrors(){
        
        List<String> errors = new List<string>();
        if(m_result == null || m_result.getErrors() == null) return errors;

        for(Database.Error e : m_result.getErrors()){
            errors.add(e.getMessage());
        }      
        return errors;

    }
    
    public Boolean isSuccess(){
        return m_result == null? false:m_result.isSuccess();
    }
    
    public String instanceId(){
        return m_result == null? '':m_result.instanceid;
    }
    
    public String entityId(){
        return m_result == null? '':m_result.entityid;
    }
}