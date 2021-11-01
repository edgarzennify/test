@IsTest
private class ApprovalProcessDmBuilderTests {

private static final ApprovalProcessDmBuilder sut;

    static{
        sut = new ApprovalProcessDmBuilder();
    }


    @IsTest
    private static void it_should_build_approval_dm_instance_when_process_instance_pm_is_provided(){
        String approvalName = 'approval-name';
        String approvalSObjectName = 'TM_Service_Request__c';
        DateTime approvalDate = DateTime.newInstance(2000,1,2);
        Id insId = ObjectFactory.getFakeId(ProcessInstance.SObjectType, '1');
        List<ProcessInstanceHistoryWrapper.IProcessInstanceHistory> histPms = new List<ProcessInstanceHistoryWrapper.IProcessInstanceHistory>();
        List<ProcessInstanceStepWrapper.IProcessInstanceStep> stepPms = new List<ProcessInstanceStepWrapper.IProcessInstanceStep>();
        List<ProcessInstanceWorkItemWrapper.IProcessInstanceWorkItem> workItemPms = new List<ProcessInstanceWorkItemWrapper.IProcessInstanceWorkItem>();
        
        ProcessInstanceMock.ofIProcessInstance ins = new ProcessInstanceMock.ofIProcessInstance();
        ins.setup('id').returns(insId);
        ins.setup('createdDate').returns(approvalDate);

        List<ProcessInstanceWrapper.IProcessInstance> instancePms = new List<ProcessInstanceWrapper.IProcessInstance>{ins};

        DmApproval.Info result = sut.build(approvalName, approvalSObjectName, approvalDate, histPms, stepPms, workItemPms, instancePms);
        
        
        System.assertEquals(approvalName, result.name);
        System.assertEquals(approvalSObjectName, result.sobjectApiName);
        System.assertEquals(1, result.instances.size());
        System.assertEquals(insId, result.instances[0].Id);
        System.assertEquals(approvalDate, result.instances[0].createdDate);     
    }

    @IsTest
    private static void it_should_build_history_dm_when_history_pm_are_provided(){
        String approvalName = 'approval-name';
        String approvalSObjectName = 'TM_Service_Request__c';
        DateTime approvalDate = DateTime.newInstance(2000,1,2);
        Id insId = ObjectFactory.getFakeId(ProcessInstance.SObjectType, '1');
        Id histId = null;
        String targetObjectId = 'test-record-id';
        String comments = 'test-comments';
        Boolean isPending = true;
        Decimal remindersSent = 1.00;
        String step = 'Approved';
        String userId = 'test-id';
        String userName = 'test-name';

        List<ProcessInstanceStepWrapper.IProcessInstanceStep> stepPms = new List<ProcessInstanceStepWrapper.IProcessInstanceStep>();
        List<ProcessInstanceWorkItemWrapper.IProcessInstanceWorkItem> workItemPms = new List<ProcessInstanceWorkItemWrapper.IProcessInstanceWorkItem>();      
        ProcessInstanceMock.ofIProcessInstance ins = new ProcessInstanceMock.ofIProcessInstance();
        ins.setup('id').returns(insId);
        ins.setup('createdDate').returns(approvalDate);
        List<ProcessInstanceWrapper.IProcessInstance> instancePms = new List<ProcessInstanceWrapper.IProcessInstance>{ins};
        ProcessInstanceMock.ofIProcessInstanceHistory his = new ProcessInstanceMock.ofIProcessInstanceHistory();
        his.setup('id').returns(histId);
        his.setup('processInstanceId').returns(insId);
        his.setup('targetObjectId').returns(targetObjectId);
        his.setup('comments').returns(comments);
        his.setup('isPending').returns(isPending);
        his.setup('remindersSent').returns(remindersSent);
        his.setup('createdDate').returns(approvalDate);
        his.setup('stepStatus').returns(step);
        his.setup('originalActorId').returns(userId);
        his.setup('OriginalActorName').returns(userName);
        his.setup('ActorId').returns('approver-id');
        his.setup('ActorName').returns('approver-name');
        List<ProcessInstanceHistoryWrapper.IProcessInstanceHistory> histPms = new List<ProcessInstanceHistoryWrapper.IProcessInstanceHistory>{his};

        DmApproval.Info result = sut.build(approvalName, approvalSObjectName, approvalDate, histPms, stepPms, workItemPms, instancePms);

        System.assertEquals(approvalName, result.name);
        System.assertEquals(approvalSObjectName, result.sobjectApiName);
        System.assertEquals(1, result.instances.size());
        System.assertEquals(1, result.instances[0].history.size());
        System.assertEquals(histId, result.instances[0].history[0].Id);
        System.assertEquals(insId, result.instances[0].history[0].processId);
        System.assertEquals(targetObjectId, result.instances[0].history[0].SobjectRecordId);
        System.assertEquals(comments, result.instances[0].history[0].Comments);
        System.assertEquals(isPending, result.instances[0].history[0].isPending);
        System.assertEquals(RemindersSent, result.instances[0].history[0].RemindersSent);
        System.assertEquals(approvalDate, result.instances[0].history[0].CreatedDate);
        System.assertEquals(step, result.instances[0].history[0].Step);
        System.assertEquals('approver-id', result.instances[0].history[0].approver.Id);
        System.assertEquals('approver-name', result.instances[0].history[0].approver.Name);
    }

    @IsTest
    private static void it_should_build_steps_dm_when_steps_pm_are_provided(){
        String approvalName = 'approval-name';
        String approvalSObjectName = 'TM_Service_Request__c';
        DateTime approvalDate = DateTime.newInstance(2000,1,2);
        Id insId = ObjectFactory.getFakeId(ProcessInstance.SObjectType, '1');
        Id stepId = ObjectFactory.getFakeId(ProcessInstanceStep.SObjectType, '1');
        String stepStatus = 'approve';
        String comments = 'test-comments';

        List<ProcessInstanceHistoryWrapper.IProcessInstanceHistory> histPms = new List<ProcessInstanceHistoryWrapper.IProcessInstanceHistory>();
        List<ProcessInstanceWorkItemWrapper.IProcessInstanceWorkItem> workItemPms = new List<ProcessInstanceWorkItemWrapper.IProcessInstanceWorkItem>();      
        ProcessInstanceMock.ofIProcessInstance ins = new ProcessInstanceMock.ofIProcessInstance();
        ins.setup('id').returns(insId);
        ins.setup('createdDate').returns(approvalDate);
        List<ProcessInstanceWrapper.IProcessInstance> instancePms = new List<ProcessInstanceWrapper.IProcessInstance>{ins};

        ProcessInstanceMock.ofIProcessInstanceStep stepPm = new ProcessInstanceMock.ofIProcessInstanceStep();
        stepPm.setup('id').returns(stepId);
        stepPm.setup('processInstanceId').returns(insId);
        stepPm.setup('stepStatus').returns(stepStatus);
        stepPm.setup('comments').returns(comments);
        List<ProcessInstanceStepWrapper.IProcessInstanceStep> stepPms = new List<ProcessInstanceStepWrapper.IProcessInstanceStep>{stepPm};

        DmApproval.Info result = sut.build(approvalName, approvalSObjectName, approvalDate, histPms, stepPms, workItemPms, instancePms);

        System.assertEquals(approvalName, result.name);
        System.assertEquals(approvalSObjectName, result.sobjectApiName);
        System.assertEquals(1, result.instances.size());
        System.assertEquals(1, result.instances[0].steps.size());
        System.assertEquals(stepId, result.instances[0].steps[0].Id);
        System.assertEquals(insId, result.instances[0].steps[0].ProcessId);
        System.assertEquals(comments, result.instances[0].steps[0].Comments);
        System.assertEquals(stepStatus, result.instances[0].steps[0].Status);
    }

    @IsTest
    private static void it_should_build_workitem_dm_when_workitem_pm_is_provided(){
        String approvalName = 'approval-name';
        String approvalSObjectName = 'TM_Service_Request__c';
        DateTime approvalDate = DateTime.newInstance(2000,1,2);
        Id insId = ObjectFactory.getFakeId(ProcessInstance.SObjectType, '1');
        Id workItemId = ObjectFactory.getFakeId(ProcessInstanceWorkItem.SObjectType, '1');
        Decimal elapsedTimeInMinutes = 2.00;
        Decimal elapsedTimeInHours = 1.00;
        Decimal elapsedTimeInDays = 3.00;

        List<ProcessInstanceHistoryWrapper.IProcessInstanceHistory> histPms = new List<ProcessInstanceHistoryWrapper.IProcessInstanceHistory>();
        
        List<ProcessInstanceStepWrapper.IProcessInstanceStep> stepPms = new List<ProcessInstanceStepWrapper.IProcessInstanceStep>();    
        ProcessInstanceMock.ofIProcessInstance ins = new ProcessInstanceMock.ofIProcessInstance();
        ins.setup('id').returns(insId);
        ins.setup('createdDate').returns(approvalDate);
        List<ProcessInstanceWrapper.IProcessInstance> instancePms = new List<ProcessInstanceWrapper.IProcessInstance>{ins};

        ProcessInstanceMock.ofIProcessInstanceWorkItem workItemPm = new ProcessInstanceMock.ofIProcessInstanceWorkItem();
        workItemPm.setup('id').returns(workItemId);
        workItemPm.setup('processInstanceId').returns(insId);
        workItemPm.setup('elapsedTimeInMinutes').returns(elapsedTimeInMinutes);
        workItemPm.setup('elapsedTimeInHours').returns(elapsedTimeInHours);
        workItemPm.setup('elapsedTimeInDays').returns(elapsedTimeInDays);
        List<ProcessInstanceWorkItemWrapper.IProcessInstanceWorkItem> workItemPms = new List<ProcessInstanceWorkItemWrapper.IProcessInstanceWorkItem>{workItemPm};  

        DmApproval.Info result = sut.build(approvalName, approvalSObjectName, approvalDate, histPms, stepPms, workItemPms, instancePms);

        System.assertEquals(approvalName, result.name);
        System.assertEquals(approvalSObjectName, result.sobjectApiName);
        System.assertEquals(1, result.instances.size());
        System.assertEquals(1, result.instances[0].workItems.size());
        System.assertEquals(workItemId, result.instances[0].workItems[0].Id);
        System.assertEquals(insId, result.instances[0].workItems[0].ProcessId);
        System.assertEquals(Integer.Valueof(elapsedTimeInMinutes), result.instances[0].workItems[0].elapsedMinutes);
        System.assertEquals(Integer.Valueof(elapsedTimeInHours), result.instances[0].workItems[0].elapsedHours);
        System.assertEquals(Integer.Valueof(elapsedTimeInDays), result.instances[0].workItems[0].elapsedDays);
        System.assertEquals('3 days 1 hour 2 minutes', result.instances[0].workItems[0].elapsedTime);
    }

}