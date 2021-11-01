public class StackFactory implements IStackFactory {
    public interface IStackFactory {
        IStack getNewInstance();
    }
	
    public IStack getNewInstance() {
        return new Stack();
    }
}