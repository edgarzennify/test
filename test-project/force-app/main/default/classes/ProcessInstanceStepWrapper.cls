public class ProcessInstanceStepWrapper implements IProcessInstanceStep{
	
    public interface IProcessInstanceStepFactory{
        IProcessInstanceStep create(ProcessInstanceStep instanceStep);
    }
    
    public class ProcessInstanceStepFactory implements IProcessInstanceStepFactory{
        public IProcessInstanceStep create(ProcessInstanceStep instanceStep){
            return new ProcessInstanceStepWrapper(instanceStep);
        }
    }
    
    public interface IProcessInstanceStep{
        Id id();
        Id processInstanceId();
        String stepStatus();
        String comments();
    }
    
    private ProcessInstanceStep m_instanceStep;
    
    public ProcessInstanceStepWrapper(ProcessInstanceStep instanceStep){
        m_instanceStep = instanceStep;
    }
    
    public Id id(){
        return m_instanceStep.Id;
    }
    
    public Id ProcessInstanceId(){
        return m_instanceStep.ProcessInstanceId;
    }
    
    public String StepStatus(){
        return m_instanceStep.StepStatus;
    }
    
    public String comments(){
        return m_instanceStep.Comments;
    }
}