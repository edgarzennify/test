@IsTest
private class TmBoardingApprovalTests {

    private static final ApprovalProcessMock.ofIManager mockApprovalProcessManager;
    private static final TmBoardingMock.ofIRepository mockRepository;
    private static final ApprovalProcessMock.ofIVmBuilder mockVmBuilder;
    private static final Mock.ofIConfigurations mockConfiguration;
    private static final TmBoardingApproval sut;

    static {
        mockApprovalProcessManager = new ApprovalProcessMock.ofIManager();
        mockRepository = new TmBoardingMock.ofIRepository();
        mockVmBuilder = new ApprovalProcessMock.ofIVmBuilder();
        mockConfiguration = new Mock.ofIConfigurations();
        sut = new TmBoardingApproval(mockApprovalProcessManager, mockRepository, mockVmBuilder, mockConfiguration);
    }

    @IsTest
    static void it_should_call_the_configs_to_get_approval_process_name_when_building_approval_info() {
        String approvalProcessNameKey = 'TmBoardingApprovalProcessName';
        TM_Service_Request__c record = new TM_Service_Request__c();
        TmBoarding.RequestPm requestPm = new TmBoarding.RequestPm();
        requestPm.requestPm = record;
        mockRepository.setup('getdata', new List<Object>{record}).returns(requestPm);

        sut.getApprovalInfo(record);

        mockConfiguration.verify('get', new List<Object>{approvalProcessNameKey}, Times.Once);
    }

    @IsTest
    static void it_should_call_the_approval_process_manager_to_build_approval_dm_when_building_approval_info() {
        String approvalProcessName = 'approval-process-name';
        Id tmRequestId = ObjectFactory.getfakeId(TM_Service_Request__c.SObjectType, '1');
        TM_Service_Request__c record = new TM_Service_Request__c(Id=tmRequestId);
        TmBoarding.RequestPm requestPm = new TmBoarding.RequestPm();
        requestPm.requestPm = record;
        mockRepository.setup('getdata', new List<Object>{record}).returns(requestPm);
        mockConfiguration.setup('get',new List<Object>{'TmBoardingApprovalProcessName'}).returns(approvalProcessName);

        sut.getApprovalInfo(record);

        mockApprovalProcessManager.verify('getApprovalProcessInformation', new List<Object>{record.Id,approvalProcessName}, Times.Once);
    }

    @IsTest
    static void it_should_call_the_vm_builder_to_build_approval_vm_when_dm_is_provided() {
        String approvalProcessName = 'approval-process-name';
        String configName = 'TmBoardingApprovalProcessName'; 
        Id recordId = ObjectFactory.getFakeId(Tm_Service_Request__c.SObjectType, '1');
        TM_Service_Request__c record = new TM_Service_Request__c(Id = recordId);
        TmBoarding.RequestPm requestPm = new TmBoarding.RequestPm();
        requestPm.requestPm = record;
        DmApproval.Info approvalDm = new DmApproval.Info();
        mockConfiguration.setup('get',new List<Object>{configName}).returns(approvalProcessName);
        mockApprovalProcessManager.setup('getApprovalProcessInformation', new List<Object>{recordId,approvalProcessName}).returns(approvalDm);

        sut.getApprovalInfo(record);

        mockVmBuilder.verify('buildVm', new List<Object>{approvalDm,recordId}, Times.Once);
    }

    @IsTest
    static void it_should_return_an_empty_approval_info_when_approval_name_is_empty() {
        mockConfiguration.setup('get', new List<Object>{'TmBoardingApprovalProcessName'}).returns('Approval-name');

        ApprovalProcess.ApprovalProcessInformation result = sut.getApprovalInfo(null);

        System.assert(String.isBlank(result.Name));
        System.assert(String.isBlank(result.SObjectName));
    }

    @IsTest
    static void it_should_call_the_approval_process_manager_to_submit_approval_when_action_is_not_pending() {
        TM_Service_Request__c record = new TM_Service_Request__c();
        String action = '';
        TmBoarding.RequestPm requestPm = new TmBoarding.RequestPm();
        requestPm.requestPm = record;
        mockRepository.setup('getdata', new List<Object>{record}).returns(requestPm);

        ApprovalProcess.ApprovalSubmitResponse result = sut.submitApprovalOrRecall(record, action);

        mockApprovalProcessManager.verify('submitForApproval', new List<Object>{null,''}, Times.Once);
    }

    @IsTest
    static void it_should_call_the_vm_builder_to_build_response_vm_when_submit_for_approval() {
        TM_Service_Request__c record = new TM_Service_Request__c();
        String action = '';
        TmBoarding.RequestPm requestPm = new TmBoarding.RequestPm();
        requestPm.requestPm = record;
        mockRepository.setup('getdata', new List<Object>{record}).returns(requestPm);
        ApprovalProcess.SubmitApprovalResponsePm res = new ApprovalProcess.SubmitApprovalResponsePm();
        res.isSuccess = true;
        mockApprovalProcessManager.setup('submitForApproval', new List<Object>{null,''}).returns(res);

        ApprovalProcess.ApprovalSubmitResponse result = sut.submitApprovalOrRecall(record, action);

        mockVmBuilder.verify('buildSubmitApprovalVm', new List<Object>{res}, Times.Once);
    }

    @IsTest
    static void it_should_call_the_vm_builder_to_build_response_vm_when_recall_approval() {
        TM_Service_Request__c record = new TM_Service_Request__c();
        String action = 'Pending';
        TmBoarding.RequestPm requestPm = new TmBoarding.RequestPm();
        requestPm.requestPm = record;
        mockRepository.setup('getdata', new List<Object>{record}).returns(requestPm);
        ApprovalProcess.SubmitApprovalResponsePm res = new ApprovalProcess.SubmitApprovalResponsePm();
        res.isSuccess = true;
        res.Errors = new List<string>();
        mockApprovalProcessManager.setup('recallApproval', new List<Object>{null}).returns(res);

        ApprovalProcess.ApprovalSubmitResponse result = sut.submitApprovalOrRecall(record, action);

        mockVmBuilder.verify('buildRecallApprovalVm', new List<Object>{'', false}, Times.Once);
    }

    @IsTest
    static void it_should_call_the_approval_process_manager_to_recall_approval_when_action_is_pending_and_recall_executed_with_errors() {
        TM_Service_Request__c record = new TM_Service_Request__c();
        String action = 'Pending';

        ApprovalProcess.ApprovalSubmitResponse result = sut.submitApprovalOrRecall(null, action);

        mockApprovalProcessManager.verify('recallApproval', new List<Object>{null}, Times.Never);
        mockVmBuilder.verify('buildRecallApprovalVm', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE);
        List<Object> arguments = (List<Object>)mockVmBuilder.getArgumentsFromCall('buildRecallApprovalVm');
        String error = (String) arguments[0];
        Boolean isError = (Boolean) arguments[1];
        System.assertEquals(true, isError);
    }

    private class TestException extends Exception{}
}