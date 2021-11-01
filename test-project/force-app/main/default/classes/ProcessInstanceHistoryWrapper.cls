public class ProcessInstanceHistoryWrapper implements IProcessInstanceHistory{
    
    public interface IProcessInstanceHistoryFactory{
        IProcessInstanceHistory create(ProcessInstanceHistory history);
    }
    
    public class ProcessInstanceHistoryFactory implements IProcessInstanceHistoryFactory{
        public IProcessInstanceHistory create(ProcessInstanceHistory history){
            return new ProcessInstanceHistoryWrapper(history);
        }
    }
    
    public interface IProcessInstanceHistory{
        Id id();
        String targetObjectId();
        Id processInstanceId();
        String ProcessNodeId();
        String ProcessNodeName();
        String comments();
        Boolean isPending();
        String StepStatus();
        String OriginalActorId();
        String OriginalActorName();
        String OriginalActorEmail();
        String ActorId();
        String ActorName();
        String ActorEmail();
        Decimal remindersSent();
        DateTime createdDate();
    }
    
    private ProcessInstanceHistory m_history;
    public ProcessInstanceHistoryWrapper(ProcessInstanceHistory history){
        m_history = history;
    }
    
    public Id id(){
        return m_history.Id;
    }

    public String ProcessNodeId(){
        return m_history.ProcessNodeId;
    }
    
    public String ProcessNodeName(){
        return m_history.ProcessNode.Name;
    }
    
    public String targetObjectId(){
        return m_history.TargetObjectId;
    }
    
    public Id processInstanceId(){
        return m_history.ProcessInstanceId;
    }
    
    public String comments(){
        return m_history.Comments;
    }
    
    public Boolean isPending(){
        return m_history.IsPending;
    }
    
    public Decimal remindersSent(){
        return m_History.RemindersSent;
    }

    public String stepStatus(){
        return m_history.StepStatus;
    }
    
    public String originalActorId(){
        return m_history.OriginalActorId;
    }
    
    public String OriginalActorName(){
        return m_history.OriginalActor.Name;
    }
    
    public String OriginalActorEmail(){
        return m_history.OriginalActor.Email;
    }

    public String ActorId(){
        return m_history.ActorId;
    }
    
    public String ActorName(){
        return m_history.Actor.Name;
    }
    
    public String ActorEmail(){
        return m_history.Actor.Email;
    }

    public DateTime createdDate(){
        return m_History.CreatedDate;
    }
    
    

}