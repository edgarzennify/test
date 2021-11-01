public class SchedulerService implements ISchedulerService {
    public void schedule(String jobName, String jobScheduleCron, Schedulable job){
    	System.schedule(jobName, jobScheduleCron, job);
    }
}