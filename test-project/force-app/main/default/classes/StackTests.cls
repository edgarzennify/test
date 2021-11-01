@IsTest
private class StackTests {
    private static Stack sut;
    static {
        sut = new Stack();
    }
    
    private static testMethod void it_should_enqueue_an_item() {
        Object item = 'test';
        
        sut.push(item);
            
        Object result = sut.pop();
        System.assertEquals(item, result);
    }
    
    private static testMethod void it_should_call_the_isempty_to_check_is_item_exists() {
        Object item = 'test';
        
        sut.push(item);
        
        System.assertEquals(false, sut.isEmpty());
    }
    
    private static testMethod void it_should_call_the_size_to_get_thecurrent_count_of_items_in_queue() {
        Object item = 'test';
        
        sut.push(item);
        
        System.assertEquals(1, sut.size());
    }

    private static testMethod void it_should_get_the_items_from_stack_in_the_LIFO_order() {
        Object item1 = 'A';
        Object item2 = 'B';

        sut.push(item1);
        sut.push(item2);

        Object result1 = sut.pop();
        Object result2 = sut.pop();

        System.assertEquals(item2, result1);
        System.assertEquals(item1, result2);
    }
}