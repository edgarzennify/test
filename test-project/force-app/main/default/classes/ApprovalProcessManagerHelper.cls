public class ApprovalProcessManagerHelper implements ApprovalProcess.IManagerHelper {
    private final ProcessInstanceHistoryWrapper.IProcessInstanceHistoryFactory m_hist;
    private final ProcessInstanceStepWrapper.IProcessInstanceStepFactory m_step;
    private final ProcessInstanceWorkItemWrapper.IProcessInstanceWorkItemFactory m_workItem;
    private final ProcessInstanceWrapper.IProcessInstanceFactory m_ins;
    
    public ApprovalProcessManagerHelper(ProcessInstanceHistoryWrapper.IProcessInstanceHistoryFactory hist, ProcessInstanceStepWrapper.IProcessInstanceStepFactory step,
                    ProcessInstanceWorkItemWrapper.IProcessInstanceWorkItemFactory workItem, ProcessInstanceWrapper.IProcessInstanceFactory ins){
    	m_hist = hist;
        m_step = step;
        m_workItem = workItem;
        m_ins = ins;
    }
    
	public List<ProcessInstanceWrapper.IProcessInstance> getInstances( ApprovalProcess.ProcessPm pm){
        List<ProcessInstanceWrapper.IProcessInstance> instances = new List<ProcessInstanceWrapper.IProcessInstance>();
        for(ProcessInstance p : pm.instances){
            ProcessInstanceWrapper.IProcessInstance i = m_ins.create(p);
            instances.add(i);
        }
        return instances;
    }

    public List<ProcessInstanceHistoryWrapper.IProcessInstanceHistory> getHistory( ApprovalProcess.ProcessPm pm){
        List<ProcessInstanceHistoryWrapper.IProcessInstanceHistory> instances = new List<ProcessInstanceHistoryWrapper.IProcessInstanceHistory>();
        for(ProcessInstanceHistory p : pm.history){
            ProcessInstanceHistoryWrapper.IProcessInstanceHistory i = m_hist.create(p);
            instances.add(i);
        }
        return instances;
    }

    public List<ProcessInstanceWorkItemWrapper.IProcessInstanceWorkItem> getWorkItems( ApprovalProcess.ProcessPm pm){
        List<ProcessInstanceWorkItemWrapper.IProcessInstanceWorkItem> instances = new List<ProcessInstanceWorkItemWrapper.IProcessInstanceWorkItem>();
        for(ProcessInstanceWorkItem p : pm.workItems){
            ProcessInstanceWorkItemWrapper.IProcessInstanceWorkItem i = m_workItem.create(p);
            instances.add(i);
        }
        return instances;
    }

    public List<ProcessInstanceStepWrapper.IProcessInstanceStep> getSteps( ApprovalProcess.ProcessPm pm){
        List<ProcessInstanceStepWrapper.IProcessInstanceStep> instances = new List<ProcessInstanceStepWrapper.IProcessInstanceStep>();
        for(ProcessInstanceStep p : pm.steps){
            ProcessInstanceStepWrapper.IProcessInstanceStep i = m_step.create(p);
            instances.add(i);
        }
        return instances;
    }

    public ApprovalProcess.SubmitApprovalResponsePm buildSubmitApprovalResponse(ApprovalProcessResultWrapper.IApprovalProcessResult result ){
        ApprovalProcess.SubmitApprovalResponsePm res = new ApprovalProcess.SubmitApprovalResponsePm();
        if(result == null) return res;      
        res.Errors = result.getErrors();
        res.isSuccess = result.isSuccess();
        res.ApprovalRecordId = result.instanceid();
        res.ApprovalSobjectId = result.entityid();
        return res;
    }
}