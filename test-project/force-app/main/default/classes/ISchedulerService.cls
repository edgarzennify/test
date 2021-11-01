global interface ISchedulerService {
    void schedule(String jobName, String jobScheduleCron, Schedulable job);
}