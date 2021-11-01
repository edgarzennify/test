@IsTest
private class ApprovalProcessManagerHelperTests {

    private static ProcessInstanceMock.ofIProcessInstanceHistoryFactory mockHistoryFactory;
    private static ProcessInstanceMock.ofIProcessInstanceStepFactory mockStepFactory;
    private static ProcessInstanceMock.ofIProcessInstanceWorkItemFactory mockWorkItemFactory;
    private static ProcessInstanceMock.ofIProcessInstanceFactory mockInstanceFactory;
    private static ApprovalProcessManagerHelper sut;

    static {
        mockHistoryFactory = new ProcessInstanceMock.ofIProcessInstanceHistoryFactory();
        mockStepFactory = new ProcessInstanceMock.ofIProcessInstanceStepFactory();
        mockWorkItemFactory = new ProcessInstanceMock.ofIProcessInstanceWorkItemFactory();
        mockInstanceFactory = new ProcessInstanceMock.ofIProcessInstanceFactory();
        sut = new ApprovalProcessManagerHelper(mockHistoryFactory,mockStepFactory,mockWorkItemFactory,mockInstanceFactory);
    }

    @IsTest
    static void it_should_call_the_instance_factory_to_get_wrapped_instance(){
        ApprovalProcess.ProcessPm pm = new ApprovalProcess.ProcessPm();
        Id insId = ObjectFactory.getFakeId(ProcessInstance.SOBjectType, '1');
        ProcessInstance ins = new ProcessInstance(Id=insId);
        pm.instances = new List<ProcessInstance>{ins};

        List<ProcessInstanceWrapper.IProcessInstance> result = sut.getInstances(pm);

        mockInstanceFactory.verify('create', new List<Object>{ins}, Times.Once);
    }

    @IsTest 
    static void it_should_call_the_history_factory_to_get_wrapped_history(){
        ApprovalProcess.ProcessPm pm = new ApprovalProcess.ProcessPm();
        ProcessInstanceHistory hist = new ProcessInstanceHistory();
        pm.history = new List<ProcessInstanceHistory>{hist};

        List<ProcessInstanceHistoryWrapper.IProcessInstanceHistory> result = sut.gethistory(pm);

        mockHistoryFactory.verify('create', new List<Object>{hist}, Times.Once);
    }

    @IsTest 
    static void it_should_call_the_step_factory_to_get_wrapped_step(){
        ApprovalProcess.ProcessPm pm = new ApprovalProcess.ProcessPm();
        ProcessInstanceStep step = new ProcessInstanceStep();
        pm.steps = new List<ProcessInstanceStep>{step};

        List<ProcessInstanceStepWrapper.IProcessInstanceStep> result = sut.getSteps(pm);

        mockStepFactory.verify('create', new List<Object>{step}, Times.Once);
    }

    @IsTest 
    static void it_should_call_the_workitem_factory_to_get_wrapped_workitem(){
        ApprovalProcess.ProcessPm pm = new ApprovalProcess.ProcessPm();
        ProcessInstanceWorkItem workItem = new ProcessInstanceWorkItem();
        pm.workItems = new List<ProcessInstanceWorkItem>{workItem};

        List<ProcessInstanceWorkItemWrapper.IProcessInstanceWorkItem> result = sut.getWorkItems(pm);

        mockWorkItemFactory.verify('create', new List<Object>{workItem}, Times.Once);
    }
}