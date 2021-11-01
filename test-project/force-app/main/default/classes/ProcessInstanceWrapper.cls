public class ProcessInstanceWrapper implements IProcessInstance {
	
    public interface IProcessInstanceFactory{
        IProcessInstance create(ProcessInstance ins);
    }
    
    public class ProcessInstanceFactory implements IProcessInstanceFactory{
        public IProcessInstance create(ProcessInstance ins){
            return new ProcessInstanceWrapper(ins);
        }
    }
    
    public interface IProcessInstance{
        Id id();
        String status();
        String lastActorId();
        String lastActorName();
        String lastActorEmail();
        DateTime completedDate();
        DateTime createdDate();
    }
    
    private final ProcessInstance m_ins;
    
    public ProcessInstanceWrapper(ProcessInstance ins){
        m_ins = ins;
    }
    
    public Id id(){
        return m_ins.id;
    }

    public String status(){
        return m_ins.Status;
    }

    public String lastActorId(){
        return m_ins.LastActorId;
    }

    public String lastActorName(){
        return m_ins.LastActor.Name;
    }

    public String lastActorEmail(){
        return m_ins.LastActor.Email;
    }

    public DateTime completedDate(){
        return m_ins.completedDate;
    }
    
    public DateTime createdDate(){
        return m_ins.CreatedDate;
    }
}