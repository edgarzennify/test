@Istest
private class StackFactoryTests {
	
    private static StackFactory sut;
    
    static {
        sut = new StackFactory();
    }
    
    private static testMethod void it_should_get_a_new_instance_of_the_stack() {
        
        IStack result = sut.getNewInstance();
        
        System.assertEquals(true, result.isEmpty());
    }
}