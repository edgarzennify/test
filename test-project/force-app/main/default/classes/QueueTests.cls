@Istest
private class QueueTests {
	private static final Queue sut;
    static {
        sut = new Queue();
    }
    
    private static testMethod void it_should_enqueue_an_item() {
        Object item = 'test';
        
        sut.enqueue(item);
            
        Object result = sut.dequeue();
        System.assertEquals(item, result);
    }
    
    private static testMethod void it_should_call_the_isempty_to_check_is_item_exists() {
        Object item = 'test';
        
        sut.enqueue(item);
        
        System.assertEquals(false, sut.isEmpty());
    }
    
    private static testMethod void it_should_call_the_size_to_get_thecurrent_count_of_items_in_queue() {
        Object item = 'test';
        
        sut.enqueue(item);
        
        System.assertEquals(1, sut.size());
    }
    
    private static testMethod void it_should_get_the_items_from_stack_in_the_FIFO_order() {
        Object item1 = 'A';
        Object item2 = 'B';

        sut.enqueue(item1);
        sut.enqueue(item2);

        Object result1 = sut.dequeue();
        Object result2 = sut.dequeue();

        System.assertEquals(item1, result1);
        System.assertEquals(item2, result2);
    }
}