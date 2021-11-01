@IsTest
private class ProcessInstanceStepWrapperTests {
    @IsTest 
    private static void code_coverage_it_should_create_an_instance_of_process_instance_step(){
        ProcessInstanceStepWrapper.ProcessInstanceStepFactory sut = new ProcessInstanceStepWrapper.ProcessInstanceStepFactory();
        ProcessInstanceStepWrapper.IProcessInstanceStep result = sut.create(new ProcessInstanceStep());
    }

    @IsTest 
    private static void it_should_create_a_wrapper_for_process_instance_step(){
        
        ProcessInstanceStepWrapper sut = new ProcessInstanceStepWrapper(new ProcessInstanceStep());

        System.assertEquals(null, sut.id());
        System.assertEquals(null, sut.processInstanceId());
        System.assertEquals(null, sut.stepStatus());
        System.assertEquals(null, sut.comments());
    }
}