@IsTest
public class ApprovalProcessMock {
	
    public class ofIDataProvider extends ApexMoq implements ApprovalProcess.IDataProvider {
        public ApprovalProcess.ProcessPm getProcessPm(String approvalName, String sObjectApiName, String sObjectRecordId){
            return (ApprovalProcess.ProcessPm)handleMethodInvocation('getProcessPm', new List<Object>{approvalName, sObjectApiName, sObjectRecordId});
        }
        public ProcessDefinition getProcessDefinition(String approvalName, String sObjectApiName){
            return (ProcessDefinition)handleMethodInvocation('getProcessDefinition', new List<Object>{approvalName, sObjectApiName});
        }
    }
    
    public class ofIDmBuilder extends ApexMoq implements ApprovalProcess.IDmBuilder {
        public DmApproval.Info build(String approvalName, String approvalSObjectName, DateTime approvalDate, List<ProcessInstanceHistoryWrapper.IProcessInstanceHistory> history,
                List<ProcessInstanceStepWrapper.IProcessInstanceStep> steps,
                                     List<ProcessInstanceWorkItemWrapper.IProcessInstanceWorkItem> workItems, List<ProcessInstanceWrapper.IProcessInstance> instancePms){
                                         return (DmApproval.Info)handleMethodInvocation('build', new List<Object>{approvalName,approvalSObjectName,approvalDate, history, steps,workItems, instancePms});
        }
    }

    public class ofIManagerHelper extends ApexMoq implements ApprovalProcess.IManagerHelper {
        public List<ProcessInstanceWrapper.IProcessInstance> getInstances( ApprovalProcess.ProcessPm pm){
            return (List<ProcessInstanceWrapper.IProcessInstance>)handleMethodInvocation('getInstances', new List<Object>{pm});
        }
        public List<ProcessInstanceHistoryWrapper.IProcessInstanceHistory> getHistory( ApprovalProcess.ProcessPm pm){
            return (List<ProcessInstanceHistoryWrapper.IProcessInstanceHistory>)handleMethodInvocation('getHistory', new List<Object>{pm});
        }
        public List<ProcessInstanceWorkItemWrapper.IProcessInstanceWorkItem> getWorkItems( ApprovalProcess.ProcessPm pm){
            return (List<ProcessInstanceWorkItemWrapper.IProcessInstanceWorkItem>)handleMethodInvocation('getWorkItems', new List<Object>{pm});
        }
        public List<ProcessInstanceStepWrapper.IProcessInstanceStep> getSteps( ApprovalProcess.ProcessPm pm){
            return (List<ProcessInstanceStepWrapper.IProcessInstanceStep>)handleMethodInvocation('getSteps', new List<Object>{pm});
        }
        public ApprovalProcess.SubmitApprovalResponsePm buildSubmitApprovalResponse(ApprovalProcessResultWrapper.IApprovalProcessResult result ){
            return (ApprovalProcess.SubmitApprovalResponsePm)handleMethodInvocation('buildSubmitApprovalResponse', new List<Object>{result});
        }
    }

    public class ofIManager extends ApexMoq implements ApprovalProcess.IManager {
        public DmApproval.Info getApprovalProcessInformation(String recordId, String approvalProcessName){
            return (DmApproval.Info)handleMethodInvocation('getApprovalProcessInformation', new List<Object>{recordId, approvalProcessName});
        }
        public ApprovalProcess.SubmitApprovalResponsePm submitForApproval(String recordId, String comments){
            return (ApprovalProcess.SubmitApprovalResponsePm)handleMethodInvocation('submitForApproval', new List<Object>{recordId, comments});
        }
        public void recallApproval(String recordId){
            handleMethodInvocation('recallApproval', new List<Object>{recordId});
        }
    }

    public class ofIVmBuilder extends ApexMoq implements ApprovalProcess.IVmBuilder {
        public ApprovalProcess.ApprovalProcessInformation buildVm(DmApproval.Info approvalDm, String recordId){
                return (ApprovalProcess.ApprovalProcessInformation)handleMethodInvocation('buildVm', new List<Object>{approvalDm, recordId});
        }
        public ApprovalProcess.ApprovalSubmitResponse buildSubmitApprovalVm(ApprovalProcess.SubmitApprovalResponsePm response){
                return (ApprovalProcess.ApprovalSubmitResponse)handleMethodInvocation('buildSubmitApprovalVm', new List<Object>{response});
        }
        public ApprovalProcess.ApprovalSubmitResponse buildRecallApprovalVm(string errorMessage, boolean isError){
                return (ApprovalProcess.ApprovalSubmitResponse)handleMethodInvocation('buildRecallApprovalVm', new List<object>{errorMessage, isError});
        }
    }

    public class ofIVmBuilderHelper extends ApexMoq implements ApprovalProcess.IVmBuilderHelper {
        public ApprovalProcess.ApprovalProcessItem buildStepVm(DmApproval.DmInstance instanceDm){
            return (ApprovalProcess.ApprovalProcessItem)handleMethodInvocation('buildStepVm', new List<Object>{instanceDm});
        }
        public ApprovalProcess.ApprovalProcessDetail buildStepDetailVm(DmApproval.DmInstance instance, DmApproval.DmHistory history, String recordId){
            return (ApprovalProcess.ApprovalProcessDetail)handleMethodInvocation('buildStepDetailVm', new List<Object>{instance,history, recordId });
        }
        public String getStatus(String status){
            return (String)handleMethodInvocation('getStatus', new List<Object>{status});
        }
        public String getStepTitle(String stepTitle, String status){
            return (String)handleMethodInvocation('getStepTitle', new List<Object>{stepTitle,status});
        }
    }
}