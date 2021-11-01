@IsTest
private class ProcessInstanceHistoryWrapperTests {
    @IsTest 
    private static void code_coverage_it_should_create_an_instance_of_process_history(){
        ProcessInstanceHistoryWrapper.ProcessInstanceHistoryFactory sut = new ProcessInstanceHistoryWrapper.ProcessInstanceHistoryFactory();
        ProcessInstanceHistoryWrapper.IProcessInstanceHistory result = sut.create(new ProcessInstanceHistory());
    }

    @IsTest 
    private static void it_should_create_a_wrapper_for_process_history(){
        
        ProcessInstanceHistoryWrapper sut = new ProcessInstanceHistoryWrapper(new ProcessInstanceHistory());

        System.assertEquals(null, sut.id());
        System.assertEquals(null, sut.targetObjectId());
        System.assertEquals(null, sut.processInstanceId());
        System.assertEquals(null, sut.comments());
        System.assertEquals(false, sut.isPending());
        System.assertEquals(null, sut.remindersSent());
        System.assertEquals(null, sut.createdDate());
    }
}