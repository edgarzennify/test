public class ProcessInstanceWorkItemWrapper implements IProcessInstanceWorkItem {
	
    public interface IProcessInstanceWorkItemFactory{
        IProcessInstanceWorkItem create(ProcessInstanceWorkItem item);
    }
    
    public class ProcessInstanceWorkItemFactory implements IProcessInstanceWorkItemFactory{

        public IProcessInstanceWorkItem create(ProcessInstanceWorkItem item){
            return new ProcessInstanceWorkItemWrapper(item);
        }
    }
    
    public interface IProcessInstanceWorkItem{
        Id id();
        Id processInstanceId();
        Decimal elapsedTimeInMinutes();
        Decimal elapsedTimeInHours();
        Decimal elapsedTimeInDays();
    }
    
    private ProcessInstanceWorkItem m_item;
    
    public ProcessInstanceWorkItemWrapper(ProcessInstanceWorkItem item){
        m_item = item;
    }
    
    public Id id(){
        return m_item.Id;
    }
    
    public Id processInstanceId(){
        return m_item.ProcessInstanceId;
    }
    
	public Decimal elapsedTimeInMinutes(){
        return m_item.ElapsedTimeInMinutes;
    }
    
    public Decimal elapsedTimeInHours(){
        return m_item.ElapsedTimeInHours;
    }
    
    public Decimal elapsedTimeInDays(){
        return m_item.ElapsedTimeInDays;
    }
}