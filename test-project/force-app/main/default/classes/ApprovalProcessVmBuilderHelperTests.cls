@IsTest
private class ApprovalProcessVmBuilderHelperTests {

    private static Mock.ofIUtility mockUtil;
    private static final ApprovalProcessVmBuilderHelper sut;

    static{
        mockUtil = new Mock.ofIUtility();
        sut = new ApprovalProcessVmBuilderHelper(mockUtil);
    }

    @IsTest
    private static void it_should_build_a_step_detail_when_instance_and_history_is_provided_and_one_work_item_exists(){
        String url = 'some-url';
        DateTime dt = DateTime.newInstance(2001,1,1);
        DmUser Approver = new DmUser();
        approver.name = 'approver-name';
        approver.id = 'approver-id';
        DmUser originalApprover = new DmUser();
        originalApprover.name = 'original-approver';
        originalApprover.id = 'original-id';
        DmApproval.DmInstance instance = new DmApproval.DmInstance();
        DmApproval.DmHistory history = new DmApproval.DmHistory();
        history.Comments = 'test-comment';
        history.CreatedDate = dt;
        history.IsPending = true;
        history.OriginalApprover = originalApprover;
        history.Approver = approver;
        history.StepTitle = 'step-title';
        history.Step = 'Pending';
        String recordId = 'test-record-id';
        DmApproval.DmWorkItem workItem = new DmApproval.DmWorkItem();
        workItem.id = 'woritem-id';
        instance.workItems = new List<DmApproval.DmWorkItem>{workItem};
        mockUtil.setup('getServerUrl').returns(url);

        ApprovalProcess.ApprovalProcessDetail result =  sut.buildStepDetailVm(instance, history, recordId);

        System.assertEquals(dt, result.CreatedDate);
        System.assertEquals(originalApprover.id, result.OriginalApproverId);
        System.assertEquals(originalApprover.name, result.OriginalApproverName);
        System.assertEquals(approver.id, result.ApproverId);
        System.assertEquals(approver.name, result.ApproverName);
        System.assertEquals(history.step, result.State);
        System.assertEquals('some-url/p/process/ProcessInstanceWorkitemWizardStageManager?id=woritem-id', result.LinkToApproval);
        System.assertEquals('some-url/woritem-id/e?et=REASSIGN&retURL=%2Fatest-record-id', result.LinkToReassign);
    }

     @IsTest
    private static void it_should_build_a_step_detail_when_instance_and_history_is_provided_and_one_work_item_does_not_exists(){
        String url = 'some-url';
        DateTime dt = DateTime.newInstance(2001,1,1);
        DmUser Approver = new DmUser();
        approver.name = 'approver-name';
        approver.id = 'approver-id';
        DmUser originalApprover = new DmUser();
        originalApprover.name = 'original-approver';
        originalApprover.id = 'original-id';
        DmApproval.DmInstance instance = new DmApproval.DmInstance();
        DmApproval.DmHistory history = new DmApproval.DmHistory();
        history.Comments = 'test-comment';
        history.CreatedDate = dt;
        history.IsPending = true;
        history.OriginalApprover = originalApprover;
        history.Approver = approver;
        history.StepTitle = 'step-title';
        history.Step = 'Start';
        String recordId = 'test-record-id';
        DmApproval.DmWorkItem workItem = new DmApproval.DmWorkItem();
        workItem.id = 'woritem-id';
        instance.workItems = new List<DmApproval.DmWorkItem>{workItem};
        mockUtil.setup('getServerUrl').returns(url);

        ApprovalProcess.ApprovalProcessDetail result =  sut.buildStepDetailVm(instance, history, recordId);

        System.assertEquals(dt, result.CreatedDate);
        System.assertEquals(originalApprover.id, result.OriginalApproverId);
        System.assertEquals(originalApprover.name, result.OriginalApproverName);
        System.assertEquals(approver.id, result.ApproverId);
        System.assertEquals(approver.name, result.ApproverName);
        System.assertEquals(history.step, result.State);
        System.assertEquals('', result.LinkToApproval);
        System.assertEquals('', result.LinkToReassign);
    }

    @IsTest
    private static void it_should_get_status(){
        String status = 'Removed';

        String result = sut.getStatus(status);

        System.assertEquals('Recalled', result);
    }

    @IsTest
    private static void it_should_get_title(){
        String stepTitle = 'some-title';
        String status = 'Pending';

        String  result = sut.getStepTitle(stepTitle, status);

        System.assertEquals(stepTitle + ' (Pending for approval)', result);
    }
}