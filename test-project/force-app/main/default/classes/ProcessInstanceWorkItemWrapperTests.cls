@IsTest
private class ProcessInstanceWorkItemWrapperTests {

    @IsTest 
    private static void code_coverage_it_should_create_an_instance_of_process_work_item(){
        ProcessInstanceWorkItemWrapper.ProcessInstanceWorkItemFactory sut = new ProcessInstanceWorkItemWrapper.ProcessInstanceWorkItemFactory();
        ProcessInstanceWorkItemWrapper.IProcessInstanceWorkItem result = sut.create(new ProcessInstanceWorkItem());
    }

    @IsTest 
    private static void it_should_create_a_wrapper_for_process_work_item(){
        
        ProcessInstanceWorkItemWrapper sut = new ProcessInstanceWorkItemWrapper(new ProcessInstanceWorkItem());

        System.assertEquals(null, sut.id());
        System.assertEquals(null, sut.processInstanceId());
        System.assertEquals(null, sut.elapsedTimeInMinutes());
        System.assertEquals(null, sut.elapsedTimeInHours());
        System.assertEquals(null, sut.elapsedTimeInDays());

    }
}