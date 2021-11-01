@IsTest
private class ApprovalProcessManagerTests {

    private static ApprovalProcessMock.ofIDataProvider mockDataProvider;
    private static ApprovalProcessMock.ofIDmBuilder mockDmBuilder;
    private static Mock.ofIUtility mockUtil;
    private static ApprovalProcessMock.ofIManagerHelper mockHelper;
    private static ProcessInstanceMock.ofIApprovalProcessResultFactory mockFactory;

    private static ApprovalProcessManager sut;

    static {
        mockDataProvider = new ApprovalProcessMock.ofIDataProvider();
        mockDmBuilder = new ApprovalProcessMock.ofIDmBuilder();
        mockUtil = new Mock.ofIUtility();
        mockHelper = new ApprovalProcessMock.ofIManagerHelper();
        mockFactory = new ProcessInstanceMock.ofIApprovalProcessResultFactory();
        sut = new ApprovalProcessManager(mockDataProvider, mockDmBuilder, mockUtil, mockHelper, mockFactory);
    }

    @IsTest
    static void it_should_call_the_data_provider_to_get_pm() {
        String recordId = 'test-record'; 
        String approvalProcessName = 'test-approval';
        String sObjectName = 'TM_Service_Request__c';
        mockUtil.setup('getObjectNameFromId', new List<Object>{recordId}).returns(sObjectName);

        DmApproval.Info result = sut.getApprovalProcessInformation(recordId, approvalProcessName);

        mockDataProvider.verify('getProcessPm', new List<Object>{approvalProcessName, sObjectName, recordId}, Times.Once);
        System.assertEquals(null, result.name);
    }

    @IsTest
    static void it_should_call_the_data_provider_to_get_definition_when_pm_is_empty() {
        String recordId = 'test-record'; 
        String approvalProcessName = 'test-approval';
        String sObjectName = 'TM_Service_Request__c';
        mockUtil.setup('getObjectNameFromId', new List<Object>{recordId}).returns(sObjectName);

        DmApproval.Info result = sut.getApprovalProcessInformation(recordId, approvalProcessName);

        mockDataProvider.verify('getProcessDefinition', new List<Object>{approvalProcessName,sObjectName}, Times.Once);
    }

    @IsTest
    static void it_should_not_call_the_data_provider_to_get_definition_when_pm_is_not_empty() {
        String recordId = 'test-record'; 
        String approvalProcessName = 'test-approval';
        String sObjectName = 'TM_Service_Request__c';
        ApprovalProcess.ProcessPm pm = new ApprovalProcess.ProcessPm();
        pm.definition = new ProcessDefinition();
        mockUtil.setup('getObjectNameFromId', new List<Object>{recordId}).returns(sObjectName);    
        mockDataProvider.setup('getProcessPm', new List<Object>{approvalProcessName, sObjectName, recordId}).returns(pm);

        DmApproval.Info result = sut.getApprovalProcessInformation(recordId, approvalProcessName);

        mockDataProvider.verify('getProcessDefinition', new List<Object>{approvalProcessName,sObjectName}, Times.Never);
    }

    @IsTest 
    static void it_should_call_the_helper_to_get_instance_wrappers(){
        String recordId = 'test-record'; 
        String approvalProcessName = 'test-approval';
        String sObjectName = 'TM_Service_Request__c';
        Id insId = ObjectFactory.getFakeId(ProcessInstance.SObjectType, '1');
        ApprovalProcess.ProcessPm pm = new ApprovalProcess.ProcessPm();
        pm.definition = new ProcessDefinition();
        pm.instances = new List<ProcessInstance>{new ProcessInstance(Id=insId)};

        mockDataProvider.setup('getProcessPm', new List<Object>{approvalProcessName, sObjectName, recordId}).returns(pm);

        mockUtil.setup('getObjectNameFromId', new List<Object>{recordId}).returns(sObjectName);

        DmApproval.Info result = sut.getApprovalProcessInformation(recordId, approvalProcessName);

        mockHelper.verify('getInstances', new List<Object>{pm}, Times.Once);
    }

    @IsTest 
    static void it_should_call_the_helper_to_get_history_wrappers(){
        String recordId = 'test-record'; 
        String approvalProcessName = 'test-approval';
        String sObjectName = 'TM_Service_Request__c';
        Id insId = ObjectFactory.getFakeId(ProcessInstance.SObjectType, '1');
        ApprovalProcess.ProcessPm pm = new ApprovalProcess.ProcessPm();
        pm.definition = new ProcessDefinition();
        pm.instances = new List<ProcessInstance>{new ProcessInstance(Id=insId)};
        pm.steps = new List<ProcessInstanceStep>{new ProcessInstanceStep(ProcessInstanceId = insId)};
        pm.history = new List<ProcessInstanceHistory>{new ProcessInstanceHistory()};

        mockDataProvider.setup('getProcessPm', new List<Object>{approvalProcessName, sObjectName, recordId}).returns(pm);

        mockUtil.setup('getObjectNameFromId', new List<Object>{recordId}).returns(sObjectName);

        DmApproval.Info result = sut.getApprovalProcessInformation(recordId, approvalProcessName);

        mockHelper.verify('getHistory', new List<Object>{pm}, Times.Once);
    }

    @IsTest 
    static void it_should_call_the_helper_to_get_step_wrappers(){
        String recordId = 'test-record'; 
        String approvalProcessName = 'test-approval';
        String sObjectName = 'TM_Service_Request__c';
        Id insId = ObjectFactory.getFakeId(ProcessInstance.SObjectType, '1');
        ApprovalProcess.ProcessPm pm = new ApprovalProcess.ProcessPm();
        pm.definition = new ProcessDefinition();
        pm.instances = new List<ProcessInstance>{new ProcessInstance(Id=insId)};
        pm.steps = new List<ProcessInstanceStep>{new ProcessInstanceStep(ProcessInstanceId = insId)};

        mockDataProvider.setup('getProcessPm', new List<Object>{approvalProcessName, sObjectName, recordId}).returns(pm);

        mockUtil.setup('getObjectNameFromId', new List<Object>{recordId}).returns(sObjectName);

        DmApproval.Info result = sut.getApprovalProcessInformation(recordId, approvalProcessName);

        mockHelper.verify('getSteps', new List<Object>{pm}, Times.Once);
    }

    @IsTest 
    static void it_should_call_the_helper_to_get_workitem_wrappers(){
        String recordId = 'test-record'; 
        String approvalProcessName = 'test-approval';
        String sObjectName = 'TM_Service_Request__c';
        Id insId = ObjectFactory.getFakeId(ProcessInstance.SObjectType, '1');
        ApprovalProcess.ProcessPm pm = new ApprovalProcess.ProcessPm();
        pm.definition = new ProcessDefinition();
        pm.instances = new List<ProcessInstance>{new ProcessInstance(Id=insId)};
        pm.workItems = new List<ProcessInstanceWorkItem>{new ProcessInstanceWorkItem(ProcessInstanceId = insId)};

        mockDataProvider.setup('getProcessPm', new List<Object>{approvalProcessName, sObjectName, recordId}).returns(pm);

        mockUtil.setup('getObjectNameFromId', new List<Object>{recordId}).returns(sObjectName);

        DmApproval.Info result = sut.getApprovalProcessInformation(recordId, approvalProcessName);

        mockHelper.verify('getWorkItems', new List<Object>{pm}, Times.Once);
    }
}