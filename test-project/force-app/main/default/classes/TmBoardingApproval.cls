public class TmBoardingApproval  implements TmBoarding.IApproval{

    private final String APPROVAL_PROCESS_NAME_KEY = 'TmBoardingApprovalProcessName';
    private final string PENDING = 'Pending';

    private final ApprovalProcess.IManager m_approvalManager;
    private final TmBoarding.IRepository m_repo;
    private final ApprovalProcess.IVmBuilder m_vmBuilder;
    private final Configurations.IConfigurations m_configs;

    public TmBoardingApproval(ApprovalProcess.IManager approvalManager, TmBoarding.IRepository repo, ApprovalProcess.IVmBuilder vmBuilder,  Configurations.IConfigurations configs){
        m_approvalManager = approvalManager;
        m_repo = repo;
        m_vmBuilder = vmBuilder;
        m_configs = configs;
    }

    public ApprovalProcess.ApprovalProcessInformation getApprovalInfo(Tm_Service_request__c record){
        String approvalProcessName = m_configs.get(APPROVAL_PROCESS_NAME_KEY);
        if(record == null || String.isBlank(record.Id) || String.isBlank(approvalProcessName)) return new ApprovalProcess.ApprovalProcessInformation();
        DmApproval.Info approvalDm = m_approvalManager.getApprovalProcessInformation(record.Id, approvalProcessName);
        return m_vmBuilder.buildVm(approvalDm, record.Id);
    }

    public ApprovalProcess.ApprovalSubmitResponse submitApprovalOrRecall(Tm_Service_request__c record, String action){
        if(action == PENDING){
            return recallApproval(record);
        }
        return submitRequestForApproval(record);
    }

    private ApprovalProcess.ApprovalSubmitResponse submitRequestForApproval(Tm_Service_request__c record){
        ApprovalProcess.SubmitApprovalResponsePm res = m_approvalManager.submitForApproval(record.Id, '');
        return m_vmBuilder.buildSubmitApprovalVm(res);
    }

    private ApprovalProcess.ApprovalSubmitResponse recallApproval(Tm_Service_request__c record){
        String error = '';
        try{
            m_approvalManager.recallApproval(record.Id);
            return m_vmBuilder.buildRecallApprovalVm(error, false);
        }catch(exception ex){
            error = ex.getMessage();
        }
        return m_vmBuilder.buildRecallApprovalVm(error, true);
    }
}