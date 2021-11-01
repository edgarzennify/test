@IsTest
private class ProcessInstanceWrapperTests {

    @IsTest 
    private static void code_coverage_it_should_create_an_instance_of_process_instance(){
        ProcessInstanceWrapper.ProcessInstanceFactory sut = new ProcessInstanceWrapper.ProcessInstanceFactory();
        ProcessInstanceWrapper.IProcessInstance result = sut.create(new ProcessInstance());
    }

    @IsTest 
    private static void it_should_create_a_wrapper_for_process_instance(){

        ProcessInstanceWrapper sut = new ProcessInstanceWrapper(new ProcessInstance());

        System.assertEquals(null, sut.id());
        System.assertEquals(null, sut.createdDate());
    }
}