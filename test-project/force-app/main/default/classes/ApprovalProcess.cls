global class ApprovalProcess {
	
    public interface IDataProvider{
        ApprovalProcess.ProcessPm getProcessPm(String approvalName, String sObjectApiName, String sObjectRecordId);
        ProcessDefinition getProcessDefinition(String approvalName, String sObjectApiName);
    }

    public interface IManager {
        DmApproval.Info getApprovalProcessInformation(String recordId, String approvalProcessName);
        SubmitApprovalResponsePm submitForApproval(String recordId, String comments);
        void recallApproval(String recordId);
    }

    public interface IManagerHelper {
        List<ProcessInstanceWrapper.IProcessInstance> getInstances(ProcessPm pm);
        List<ProcessInstanceHistoryWrapper.IProcessInstanceHistory> getHistory(ProcessPm pm);
        List<ProcessInstanceWorkItemWrapper.IProcessInstanceWorkItem> getWorkItems(ProcessPm pm);
        List<ProcessInstanceStepWrapper.IProcessInstanceStep> getSteps(ProcessPm pm);
        SubmitApprovalResponsePm buildSubmitApprovalResponse(ApprovalProcessResultWrapper.IApprovalProcessResult result);
    }
    
    public interface IDmBuilder {
        DmApproval.Info build(String approvalName, String approvalSObjectName, DateTime approvalDate, List<ProcessInstanceHistoryWrapper.IProcessInstanceHistory> history,
                List<ProcessInstanceStepWrapper.IProcessInstanceStep> steps,
                    List<ProcessInstanceWorkItemWrapper.IProcessInstanceWorkItem> workItems, List<ProcessInstanceWrapper.IProcessInstance> instancePms);
    }

    public interface IVmBuilder{
        ApprovalProcessInformation buildVm(DmApproval.Info approvalDm, String recordId);
        ApprovalSubmitResponse buildSubmitApprovalVm(SubmitApprovalResponsePm response);
        ApprovalSubmitResponse buildRecallApprovalVm(string errorMessage, boolean isError);
    }

    public interface IVmBuilderHelper {
        ApprovalProcessItem buildStepVm(DmApproval.DmInstance instanceDm);
        ApprovalProcessDetail buildStepDetailVm(DmApproval.DmInstance instanceDm, DmApproval.DmHistory history, String recordId);
        String getStatus(String status);
        String getStepTitle(String stepTitle, String status);
    }

    public class ProcessPm{
        public ProcessDefinition definition{get;set;}
        public List<ProcessInstance> instances{get;set;}
        public List<ProcessInstanceStep> steps{get;set;}
        public List<ProcessInstanceWorkItem> workItems{get;set;}
        public List<ProcessInstanceHistory> history{get;set;}
    }

    public class SubmitApprovalResponsePm{
        public Boolean isSuccess{get;set;}
        public List<string> Errors{get;set;}
        public String ApprovalSobjectId{get;set;}
        public string ApprovalRecordId{get;set;}
    }

    /* VMs */
    global class ApprovalProcessInformation{
        public String Name{get;set;}
        public String SObjectName{get;set;}
        public boolean IsPending{get;set;}
        public String Action{get;set;}
        public String ActionText{get;set;}
        public List<ApprovalProcessItem> ProcessItems{get;set;}
    }

    global class ApprovalProcessItem {
        public String OverallStatus{get;set;}
        public String LastApproverId{get;set;}
        public string LastApproverName{get;set;}
        public string StepTitle{get;set;}
        public DateTime CompletedDate{get;set;}
        public DateTime CreatedDate{get;set;}
        public List<ApprovalProcessDetail> steps {get;set;}
    }

    global class ApprovalProcessDetail {
        public String LinkToApproval{get;set;}
        public String LinkToReassign{get;set;}
        public String OriginalApproverId{get;set;}
        public String OriginalApproverName{get;set;}
        public String ApproverId{get;set;}
        public String ApproverName{get;set;}
        public String State{get;set;}
        public String StepName{get;set;}
        public String Comments{get;set;}
        public DateTime CreatedDate{get;set;}
    }

    global class ApprovalSubmitResponse{
        public boolean isSuccess{get;set;}
        public string errors{get;set;}
    }

    public static final String REMOVED = 'Removed';
    public static final String RECALLED = 'Recalled';
    public static final String PENDING = 'Pending';

    public static IManager bootstrap(){
        ApprovalProcessDataProvider dataProvider = new ApprovalProcessDataProvider();
        ApprovalProcessDmBuilder dmBuilder = new ApprovalProcessDmBuilder();
        ProcessInstanceHistoryWrapper.IProcessInstanceHistoryFactory hist = new ProcessInstanceHistoryWrapper.ProcessInstanceHistoryFactory();
        ProcessInstanceStepWrapper.IProcessInstanceStepFactory step = new ProcessInstanceStepWrapper.ProcessInstanceStepFactory();
        ProcessInstanceWorkItemWrapper.IProcessInstanceWorkItemFactory wi = new ProcessInstanceWorkItemWrapper.ProcessInstanceWorkItemFactory();
        ProcessInstanceWrapper.IProcessInstanceFactory ins = new ProcessInstanceWrapper.ProcessInstanceFactory();
        Utility.IUtility util = new Utility();
        ApprovalProcessResultWrapper.IApprovalProcessResultFactory result = new ApprovalProcessResultWrapper.ApprovalProcessResultFactory();
        ApprovalProcessManagerHelper helper = new ApprovalProcessManagerHelper(hist,step,wi,ins);

        return new ApprovalProcessManager(dataProvider, dmBuilder, util, helper, result);
    }
}