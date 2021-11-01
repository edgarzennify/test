public class ApprovalProcessVmBuilder implements ApprovalProcess.IVmBuilder{

    private final String RECALL_APPROVAL_REQUEST =  'Recall Approval Request';
    private final String SUBMIT_FOR_APPROVAL = 'Submit for Approval';
    private final String SUCCESS_MESSAGE_APPROVAL = 'Submit for approval successful';
    private final String SUCCESS_MESSAGE_RECALL = 'Recall successful';
    private final String FALIURE_MESSAGE_RECALL = 'Recall error';

    private final ApprovalProcess.IVmBuilderHelper m_vmHelper;

    public ApprovalProcessVmBuilder(ApprovalProcess.IVmBuilderHelper vmHelper){
        m_vmHelper = vmHelper;
    }

    public ApprovalProcess.ApprovalProcessInformation buildVm(DmApproval.Info approvalDm, String recordId){
        ApprovalProcess.ApprovalProcessInformation vm = new ApprovalProcess.ApprovalProcessInformation();
        vm.Name = approvalDm.name;
        vm.SObjectName  = approvalDm.sobjectApiName;
        vm.ProcessItems = buildSteps(approvalDm, recordId);
        vm.Action = '';
        vm.ActionText = SUBMIT_FOR_APPROVAL;
        if(vm.ProcessItems.size() > 0){
            String overallStatus = vm.ProcessItems[0].OverallStatus;
            vm.IsPending = overallStatus == ApprovalProcess.PENDING;
            vm.Action = String.isBlank(overallStatus)?'': overallStatus;
            vm.ActionText = overallStatus == ApprovalProcess.PENDING? RECALL_APPROVAL_REQUEST: SUBMIT_FOR_APPROVAL;
        }
        return vm;
    }

    public ApprovalProcess.ApprovalSubmitResponse buildSubmitApprovalVm(ApprovalProcess.SubmitApprovalResponsePm response){
        ApprovalProcess.ApprovalSubmitResponse res = new ApprovalProcess.ApprovalSubmitResponse();
        if(response == null) return res;
        res.isSuccess = response.isSuccess;
        res.errors = res.isSuccess?SUCCESS_MESSAGE_APPROVAL:  String.join(response.Errors, ',');
        return res;
    }

    public ApprovalProcess.ApprovalSubmitResponse buildRecallApprovalVm(string errorMessage, boolean isError){
        ApprovalProcess.ApprovalSubmitResponse res = new ApprovalProcess.ApprovalSubmitResponse();
        res.isSuccess = !isError;
        res.errors = res.isSuccess?SUCCESS_MESSAGE_RECALL:FALIURE_MESSAGE_RECALL;
        return  res;
    }

    private List<ApprovalProcess.ApprovalProcessItem> buildSteps(DmApproval.Info approvalDm, String recordId){
        List<ApprovalProcess.ApprovalProcessItem> vms = new List<ApprovalProcess.ApprovalProcessItem>();
        if(approvalDm == null || approvalDm.instances == null) return vms;

        for(DmApproval.DmInstance ins: approvalDm.instances){
            ApprovalProcess.ApprovalProcessItem vmIns = m_vmHelper.buildStepVm(ins);
            List<ApprovalProcess.ApprovalProcessDetail> steps = new List<ApprovalProcess.ApprovalProcessDetail>();
            for(DmApproval.DmHistory h : ins.history){
                ApprovalProcess.ApprovalProcessDetail vm = m_vmHelper.buildStepDetailVm(ins, h, recordId);
                steps.add(vm);
                if(String.isNotBlank(vm.StepName)){
                    vmIns.StepTitle = m_vmHelper.getStepTitle(vm.StepName, vmIns.OverallStatus);
                }            
            }
            vmIns.steps = steps;
            vms.add(vmIns);
        }

        return vms;
    }
}