public interface IQueue {
	void enqueue(Object item);
    Object dequeue();
    Boolean isEmpty();
    Object peek();
    Integer size();
}