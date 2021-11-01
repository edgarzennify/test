public class LoanArchiveScheduler implements IApexJobScheduler {
	ISchedulerService m_schedulerService;
	
    public LoanArchiveScheduler(ISchedulerService schedulerSvc){
    	m_schedulerService = schedulerSvc;
    }
 
    public void start(){
        //Seconds Minutes Hours Day_of_month Month Day_of_week optional_year
        //System.schedule('Nightly Cleanup Job', '0 35 23 ? * MON-FRI', new getLoanArchiveList());
        m_schedulerService.schedule('Nightly Cleanup Job','0 35 23 ? * MON-FRI',new getLoanArchiveList());
    }
    
    public void stop(){}
    public Boolean isScheduled(){
    	return false;
    }
}