public class ApprovalProcessDmBuilder implements ApprovalProcess.IDmBuilder {

    public DmApproval.Info build(String approvalName, String approvalSObjectName, DateTime approvalDate, List<ProcessInstanceHistoryWrapper.IProcessInstanceHistory> history,
                List<ProcessInstanceStepWrapper.IProcessInstanceStep> steps,
                    List<ProcessInstanceWorkItemWrapper.IProcessInstanceWorkItem> workItems, List<ProcessInstanceWrapper.IProcessInstance> instancePms){
        DmApproval.Info dm = new DmApproval.Info();
        dm.name = approvalName;
        dm.sobjectApiName = approvalSObjectName;
        dm.createdDate = approvalDate;
        dm.instances = buildInstanceDms(history, steps, workItems, instancePms);
        return dm;
    }

    private List<DmApproval.DmInstance> buildInstanceDms(List<ProcessInstanceHistoryWrapper.IProcessInstanceHistory> history,
                List<ProcessInstanceStepWrapper.IProcessInstanceStep> steps,
                    List<ProcessInstanceWorkItemWrapper.IProcessInstanceWorkItem> workItems, List<ProcessInstanceWrapper.IProcessInstance> instancePms){
        
        List<DmApproval.DmInstance> instances = new List<DmApproval.DmInstance>();
        Map<Id,List<DmApproval.DmStep>> stepDms = buildStepDms(steps);
        Map<Id,List<DmApproval.DmWorkItem>> workItemDms = buildWorkItemDms(workItems);
        Map<Id,List<DmApproval.DmHistory>> historyDms =  buildHistoryDms(history);
        for(ProcessInstanceWrapper.IProcessInstance i : instancePms){
            DmApproval.DmInstance ins = new DmApproval.DmInstance();
            ins.Id = i.Id();
            ins.completedDate = i.completedDate();
            ins.OverallStatus = i.status();
            ins.LastApprover = new DmUSer();
            if(String.isNotBlank(i.lastActorId())){               
                ins.lastApprover.id = i.lastActorId();
                ins.lastApprover.name = i.lastActorName();
            }
            ins.CreatedDate = i.CreatedDate();
            ins.steps = stepDms.get(i.Id());
            ins.workItems = workItemDms.get(i.Id());
            ins.history = historyDms.get(i.Id());
            instances.add(ins);
        }
        return instances;
    }

    private Map<Id,List<DmApproval.DmStep>> buildStepDms(List<ProcessInstanceStepWrapper.IProcessInstanceStep> steps){
         Map<Id,List<DmApproval.DmStep>> stepDms =  new Map<Id,List<DmApproval.DmStep>>();
        if(steps == null) return stepDms;

        for(ProcessInstanceStepWrapper.IProcessInstanceStep ps : steps){
            if(!stepDms.containsKey(ps.Id())){
                stepDms.put(ps.ProcessInstanceId(), new List<DmApproval.DmStep>());
            }
            DmApproval.DmStep stepDm = new DmApproval.DmStep();
            stepDm.Id = ps.Id();
            stepDm.ProcessId = ps.ProcessInstanceId();
            stepDm.Status = ps.StepStatus();
            stepDm.Comments = ps.Comments();
            stepDms.get(ps.ProcessInstanceId()).add(stepDm);
        }
        return stepDms;
    }

    private Map<Id,List<DmApproval.DmWorkItem>> buildWorkItemDms(List<ProcessInstanceWorkItemWrapper.IProcessInstanceWorkItem> workItems){
        Map<Id,List<DmApproval.DmWorkItem>> workItemDms = new Map<Id,List<DmApproval.DmWorkItem>>();
        if(workItems == null) return workItemDms;
        for(ProcessInstanceWorkItemWrapper.IProcessInstanceWorkItem wk : workItems){
            if(!workItemDms.containsKey(wk.ProcessInstanceId())){
                workItemDms.put(wk.ProcessInstanceId(), new List<DmApproval.DmWorkItem>());
            }
            DmApproval.DmWorkItem workDm = new DmApproval.DmWorkItem();
            workDm.Id = wk.Id();
            workDm.ProcessId = wk.ProcessInstanceId();
            workDm.ElapsedDays = wk.ElapsedTimeInDays() == null?0:Integer.valueof( wk.ElapsedTimeInDays());
            workDm.ElapsedHours = wk.ElapsedTimeInHours() == null? 0: Integer.valueof(wk.ElapsedTimeInHours());
            workDm.ElapsedMinutes = wk.ElapsedTimeInMinutes() == null? 0: Integer.valueOf(wk.ElapsedTimeInMinutes());
            workDm.ElapsedTime = getElapsedTime(workDm.ElapsedDays, workDm.ElapsedHours, workDm.ElapsedMinutes);

            workItemDms.get(wk.ProcessInstanceId()).add(workDm);
        }
        return workItemDms;
    }

    private Map<Id,List<DmApproval.DmHistory>> buildHistoryDms(List<ProcessInstanceHistoryWrapper.IProcessInstanceHistory> historyPms){
        Map<Id,List<DmApproval.DmHistory>> historyDms = new Map<Id,List<DmApproval.DmHistory>>();
        if(historyPms == null) return historyDms;
        for(ProcessInstanceHistoryWrapper.IProcessInstanceHistory h : historyPms){
            if(!historyDms.containsKey(h.ProcessInstanceId())){
                historyDms.put(h.ProcessInstanceId(), new List<DmApproval.DmHistory>());
            }
            DmApproval.DmHistory histDm = new DmApproval.DmHistory();
            histDm.Id = h.id();
            histDm.sObjectRecordId = h.TargetObjectId();
            histDm.ProcessId = h.ProcessInstanceId();
            histDm.comments = h.Comments();
            histDm.IsPending = h.IsPending();
            histDm.Step = h.stepStatus();
            histDm.StepTitle = h.ProcessNodeName();
            if(String.isNotBlank(h.OriginalActorId())){
                histDm.OriginalApprover = new DmUser();
                histDm.OriginalApprover.id = h.OriginalActorId();
                histDm.OriginalApprover.name = h.OriginalActorName();
            }
            if(String.isNotBlank(h.ActorId())){
                histDm.Approver = new DmUser();
                histDm.Approver.id =  h.ActorId();
                histDm.Approver.name = h.ActorName();
            }
            histDm.RemindersSent = Integer.valueof(h.RemindersSent());
            histDm.CreatedDate = h.createdDate();
            historyDms.get(h.ProcessInstanceId()).add(histDm);
        }
        return historyDms;
    }

    private String getElapsedTime(Integer days, Integer hours, Integer minutes){
        String dayLabel = days ==null || days <  2? 'day' : 'days';
        String hourLabel = hours ==null || hours < 2 ? 'hour' : 'hours';
        String minuteLabel = minutes ==null || minutes < 2? 'minute' : 'minutes';

        return String.format('{0} {1} {2} {3} {4} {5}', new List<string>{String.valueof(days), dayLabel, 
                                                                         String.valueof(hours), hourLabel,
                                                                         String.valueof(minutes), minuteLabel});
    }

}