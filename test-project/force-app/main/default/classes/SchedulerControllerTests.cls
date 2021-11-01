@isTest
public class SchedulerControllerTests {
    private static testMethod void codeCoverage(){   
    	MockOfIScheduledApex mockNightJobScheduler = new MockOfIScheduledApex();
        SchedulerController sut = new SchedulerController(mockNightJobScheduler);
        
        sut.StartJob();
    }
    
    public class MockOfIScheduledApex implements IApexJobScheduler{
    	public void start(){}
        public void stop(){}
        public Boolean isScheduled(){
        	return null;
        }
    }
}