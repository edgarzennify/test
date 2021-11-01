public class ApprovalProcessVmBuilderHelper implements ApprovalProcess.IVmBuilderHelper {
    private final Utility.IUtility m_util;

    public ApprovalProcessVmBuilderHelper(Utility.IUtility util){
        m_util = util;
    }

    public ApprovalProcess.ApprovalProcessItem buildStepVm(DmApproval.DmInstance instanceDm){
        ApprovalProcess.ApprovalProcessItem vmIns = new ApprovalProcess.ApprovalProcessItem();
        vmIns.CompletedDate = instanceDm.completedDate;
        vmIns.CreatedDate = instanceDm.CreatedDate;
        vmIns.OverallStatus = getStatus(instanceDm.OverallStatus);
        vmIns.LastApproverId = instanceDm.LastApprover.Id;
        vmIns.LastApproverName = instanceDm.LastApprover.name;
        return vmIns;
    }

    public ApprovalProcess.ApprovalProcessDetail buildStepDetailVm(DmApproval.DmInstance instanceDm, DmApproval.DmHistory history, String recordId){
        ApprovalProcess.ApprovalProcessDetail vm = new ApprovalProcess.ApprovalProcessDetail();
        vm.LinkToApproval = '';
        vm.LinkToReassign = '';
        String state = getStatus(history.Step);
        if(instanceDm.workItems != null && instanceDm.workItems.size() > 0 && String.isNotBlank(state) && state == ApprovalProcess.PENDING){
            vm.LinkToApproval = String.format('{0}/p/process/ProcessInstanceWorkitemWizardStageManager?id={1}', new List<String>{m_util.getServerUrl() ,instanceDm.workItems[0].Id}) ;
            vm.LinkToReassign = String.format('{0}/{1}/e?et=REASSIGN&retURL=%2Fa{2}', new List<String>{m_util.getServerUrl() ,instanceDm.workItems[0].Id, recordId});
        }
        
        vm.State = state;
        vm.StepName = history.StepTitle==null?'': history.StepTitle;
        vm.OriginalApproverId = history.OriginalApprover  != null? history.OriginalApprover.Id:'';
        vm.OriginalApproverName = history.OriginalApprover != null? history.OriginalApprover.name:'';
        vm.ApproverId = history.Approver  != null? history.Approver.Id:'';
        vm.ApproverName = history.Approver != null? history.Approver.name:'';
        vm.Comments = history.Comments == null? '': history.Comments;
        vm.CreatedDate = history.CreatedDate;
        return vm;
    }
    public String getStatus(String status){
        return status.toLowerCase() == ApprovalProcess.REMOVED.toLowerCase()? ApprovalProcess.RECALLED : status;
    }
    public String getStepTitle(String stepTitle, String status){
        return status.toLowerCase() == ApprovalProcess.PENDING.toLowerCase()?  String.Format('{0} (Pending for approval)', new List<String>{stepTitle}):stepTitle;
    }
}