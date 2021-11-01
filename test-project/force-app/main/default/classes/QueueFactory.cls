public class QueueFactory implements IQueueFactory{
    public interface IQueueFactory {
        IQueue getNewInstance();
    }
    public IQueue getNewInstance() {
        return new Queue();
    }
}