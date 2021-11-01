public interface IApexJobScheduler{
    void start();
    void stop();
    Boolean isScheduled();
}