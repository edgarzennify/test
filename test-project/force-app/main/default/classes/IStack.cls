public interface IStack {
	void push(Object item);
    Object pop();
    Boolean isEmpty();
    Object peek();
    Integer size();
}