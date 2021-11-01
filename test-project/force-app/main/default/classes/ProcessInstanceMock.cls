@IsTest
public class ProcessInstanceMock {

    public class ofIProcessInstanceFactory extends ApexMoq implements ProcessInstanceWrapper.IProcessInstanceFactory{
        public ProcessInstanceWrapper.IProcessInstance create(ProcessInstance ins){
            return (ProcessInstanceWrapper.IProcessInstance)handleMethodInvocation('create', new List<Object>{ins});
        }
    }

    public class ofIProcessInstance extends ApexMoq implements ProcessInstanceWrapper.IProcessInstance{
        public Id id(){
            return (Id)handleMethodInvocation('id');
        }
        public String status(){
            return (String)handleMethodInvocation('status');
        }
        public String lastActorId(){
            return (String)handleMethodInvocation('lastActorId');
        }
        public String lastActorName(){
            return (String)handleMethodInvocation('lastActorName');
        }
        public String lastActorEmail(){
            return (String)handleMethodInvocation('lastActorEmail');
        }
        public DateTime completedDate(){
            return (DateTime)handleMethodInvocation('completedDate');
        }
        public DateTime createdDate(){
            return (DateTime)handleMethodInvocation('createdDate');
        }
    }

    public class ofIProcessInstanceHistoryFactory extends ApexMoq implements ProcessInstanceHistoryWrapper.IProcessInstanceHistoryFactory {
        public ProcessInstanceHistoryWrapper.IProcessInstanceHistory create(ProcessInstanceHistory history){
            return (ProcessInstanceHistoryWrapper.IProcessInstanceHistory)handleMethodInvocation('create', new List<Object>{history});
        }
    }

    public class ofIProcessInstanceHistory extends ApexMoq implements ProcessInstanceHistoryWrapper.IProcessInstanceHistory{
        public Id id(){
            return (Id)handleMethodInvocation('id');
        }
        public Id processInstanceId(){
            return (Id)handleMethodInvocation('processInstanceId');
        }
        public String ProcessNodeId(){
            return (String) handleMethodInvocation('ProcessNodeId');
        }  
        public String ProcessNodeName(){
            return (String) handleMethodInvocation('ProcessNodeName');
        }
        public String targetObjectId(){
            return (String)handleMethodInvocation('targetObjectId');
        }
        public String comments(){
            return (String)handleMethodInvocation('comments');
        }
        public Boolean isPending(){
            return (Boolean)handleMethodInvocation('isPending');
        }
        public Decimal remindersSent(){
            return (Decimal)handleMethodInvocation('remindersSent');
        }
        public String stepStatus(){
            return (String)handleMethodInvocation('stepStatus');
        }
    
        public String originalActorId(){
            return (String) handleMethodInvocation('originalActorId');
        }
        
        public String OriginalActorName(){
            return (String) handleMethodInvocation('OriginalActorName');
        }
        
        public String OriginalActorEmail(){
            return (String) handleMethodInvocation('OriginalActorEmail');
        }
        public String ActorId(){
            return (String)handleMethodInvocation('ActorId');
        }
        public String ActorName(){
            return (String)handleMethodInvocation('ActorName');
        }
        public String ActorEmail(){
            return (String)handleMethodInvocation('ActorEmail');
        }
        public DateTime createdDate(){
            return (DateTime)handleMethodInvocation('createdDate');
        }
    }

    public class ofIProcessInstanceStepFactory extends ApexMoq implements ProcessInstanceStepWrapper.IProcessInstanceStepFactory{
        public ProcessInstanceStepWrapper.IProcessInstanceStep create(ProcessInstanceStep step){
            return (ProcessInstanceStepWrapper.IProcessInstanceStep)handleMethodInvocation('create', new List<Object>{step});
        }
    }

    public class ofIProcessInstanceStep extends ApexMoq implements ProcessInstanceStepWrapper.IProcessInstanceStep{
        public Id id(){
            return (Id)handleMethodInvocation('id');
        }
        public Id processInstanceId(){
            return (Id)handleMethodInvocation('processInstanceId');
        }
        public String stepStatus(){
            return (String)handleMethodInvocation('stepStatus');
        }
        public String comments(){
            return (String)handleMethodInvocation('comments');
        }
    }

    public class ofIProcessInstanceWorkItemFactory extends ApexMoq implements ProcessInstanceWorkItemWrapper.IProcessInstanceWorkItemFactory{
        public ProcessInstanceWorkItemWrapper.IProcessInstanceWorkItem create(ProcessInstanceWorkItem wk){
            return (ProcessInstanceWorkItemWrapper.IProcessInstanceWorkItem)handleMethodInvocation('create', new List<Object>{wk});
        }
    }

    public class ofIProcessInstanceWorkItem extends ApexMoq implements ProcessInstanceWorkItemWrapper.IProcessInstanceWorkItem {
        public Id id(){
            return (Id)handleMethodInvocation('id');
        }
        public Id processInstanceId(){
            return (Id)handleMethodInvocation('processInstanceId');
        }
        public Decimal elapsedTimeInMinutes(){
            return (Decimal)handleMethodInvocation('elapsedTimeInMinutes');
        }
        public Decimal elapsedTimeInHours(){
            return (Decimal)handleMethodInvocation('elapsedTimeInHours');
        }
        public Decimal elapsedTimeInDays(){
            return (Decimal)handleMethodInvocation('elapsedTimeInDays');
        }
    }

    public class ofIApprovalProcessResultFactory extends ApexMoq implements ApprovalProcessResultWrapper.IApprovalProcessResultFactory{
        public ApprovalProcessResultWrapper.IApprovalProcessResult create(Approval.ProcessResult result){
            return (ApprovalProcessResultWrapper.IApprovalProcessResult)handleMethodInvocation('create', new List<Object>{result});
        }
    }

    public class ofIApprovalProcessResult extends ApexMoq implements ApprovalProcessResultWrapper.IApprovalProcessResult{
        public List<string> getErrors(){
            return (List<string>)handleMethodInvocation('getErrors');
        }
        public Boolean isSuccess(){
            return (Boolean)handleMethodInvocation('isSuccess');
        }
        public String instanceId(){
            return (String)handleMethodInvocation('instanceId');
        }
        public String entityId(){
            return (String)handleMethodInvocation('entityId');
        }
    }

}