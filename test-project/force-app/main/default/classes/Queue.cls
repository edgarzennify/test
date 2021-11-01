public class Queue implements IQueue {
    /*private List<Object> al;
    
    public Queue() {   
    	al = new List<Object>();
    }
    
    public void push(Object item) {
    	al.add(item);
    }

    public object pop() {
        if (!isEmpty()) {     
        	return al.remove(size()-1);
        }
        return null;
	}
    public boolean isEmpty() {  
        return (al.size() == 0);
    }

    public Object peek() {
        if (!isEmpty()) {     
        	return al.get(size()-1);
        }
        return null;
    }

    public integer size() { 
    	return al.size();
    } */
    
    private List<Object> forward;
    private List<Object> reversed;
    
    public Queue() {   
    	forward = new List<Object>();
        reversed = new List<Object>();
    }
    
    public void enqueue(Object item) {
    	forward.add(item);
        buildReverse();
    }

    public object dequeue() {
        if (!isEmpty()) {
            forward.remove(size()-1);
        	return reversed.remove(size()-1);
        }
        return null;
	}
    public boolean isEmpty() {  
        return (reversed.size() == 0);
    }

    public Object peek() {
        if (!isEmpty()) {     
        	return reversed.get(size()-1);
        }
        return null;
    }

    public integer size() { 
    	return reversed.size();
    }

    private void buildReverse() {
        reversed.clear();
        for(Integer i = forward.size() - 1; i >= 0; i--){
            reversed.add(forward[i]);
        }
    }
}