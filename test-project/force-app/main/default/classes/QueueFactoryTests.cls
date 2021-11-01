@Istest
private class QueueFactoryTests {
	
    private static QueueFactory sut;
    
    static {
        sut = new QueueFactory();
    }
    
    private static testMethod void it_should_create_a_new_instance_of_queue() {
        IQueue result = sut.getNewInstance();
        
        System.assertEquals(true, result.isEmpty());
    }
}