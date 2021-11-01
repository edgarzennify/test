@isTest
public class SchedulerServiceTests {
    private static testMethod void codeCoverage(){
    	SchedulerService sut = new SchedulerService();
    	MockOfSchedulable mockJob = new MockOfSchedulable();
    	sut.Schedule('bogus for unit testing', '0 35 23 ? * MON-FRI', mockJob);
    }
    
    public class MockOfSchedulable implements Schedulable{
    	public void execute(SchedulableContext ctx){}
    }
}