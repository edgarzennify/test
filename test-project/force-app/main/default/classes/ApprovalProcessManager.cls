public class ApprovalProcessManager implements ApprovalProcess.IManager {
    private final ApprovalProcess.IDataProvider m_dataProvider;
    private final Utility.IUtility m_util;
    private final ApprovalProcess.IDmBuilder m_dmBuilder;
    private final ApprovalProcess.IManagerHelper m_helper;
    private final ApprovalProcessResultWrapper.IApprovalProcessResultFactory m_approvalResultFactory;


    public ApprovalProcessManager(ApprovalProcess.IDataProvider dataProvider, ApprovalProcess.IDmBuilder dmBuilder, 
                Utility.IUtility util, ApprovalProcess.IManagerHelper helper, ApprovalProcessResultWrapper.IApprovalProcessResultFactory approvalResultFactory){
        m_dataProvider = dataProvider;
        m_dmBuilder = dmBuilder;
        m_util = util;
        m_helper = helper;
        m_approvalResultFactory = approvalResultFactory;
    }

    public DmApproval.Info getApprovalProcessInformation(String recordId, String approvalProcessName){
        String sObjectName = m_util.getObjectNameFromId(recordId);
        
        ApprovalProcess.ProcessPm pm = m_dataProvider.getProcessPm(approvalProcessName, sObjectName, recordId);
        if(pm == null || pm.definition == null) {
            DmApproval.Info info = new DmApproval.Info();
            ProcessDefinition pDefinitionPm = m_dataProvider.getProcessDefinition(approvalProcessName, sObjectName);
            if(pDefinitionPm != null && String.isNotBlank(pDefinitionPm.Name)){
                info.name = approvalProcessName;
                info.sobjectApiName = sObjectName;
            }
            return info;
        }
        List<ProcessInstanceWrapper.IProcessInstance> instances = m_helper.getInstances(pm);
        List<ProcessInstanceHistoryWrapper.IProcessInstanceHistory> history = m_helper.getHistory(pm);
        List<ProcessInstanceWorkItemWrapper.IProcessInstanceWorkItem> workItem = m_helper.getWorkItems(pm);
        List<ProcessInstanceStepWrapper.IProcessInstanceStep> steps = m_helper.getSteps(pm);
        
        return m_dmBuilder.build(pm.definition.name, sObjectName, pm.definition.createdDate, history, steps, workItem, instances);
    }

    public ApprovalProcess.SubmitApprovalResponsePm submitForApproval(String recordId, String comments){
        ApprovalProcess.SubmitApprovalResponsePm response = new  ApprovalProcess.SubmitApprovalResponsePm();
        response.Errors = new List<string>();
        response.isSuccess = false;
        Approval.ProcessSubmitRequest submitRequest = new Approval.ProcessSubmitRequest();
       
        try{           
            submitRequest.setObjectId(recordId);
            submitRequest.setComments(comments);
            Approval.ProcessResult result = Approval.process(submitRequest);       
            response = m_helper.buildSubmitApprovalResponse(m_approvalResultFactory.create(result));
            return response;
        }catch(Exception ex){
            
        }
        
        return response;
    }

    public void recallApproval(String recordId){
        m_util.recallApprovalRequest(recordId);
    }
}