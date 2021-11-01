@isTest
public class LoanArchiveSchedulerTests {
    private static testMethod void codeCoverage(){
    	MockOfISchedulerService mockSchedulerSvc = new MockOfISchedulerService();
        LoanArchiveScheduler sut = new LoanArchiveScheduler(mockSchedulerSvc);
        
        sut.start();
    }
    
    public class MockOfISchedulerService implements ISchedulerService{
    	public void schedule(String jobName, String jobScheduleCron, Schedulable job){}
    } 
}