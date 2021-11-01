public class SchedulerController {
	
	IApexJobScheduler m_nightJobScheduler;

    public SchedulerController(){
    	m_nightJobScheduler = new LoanArchiveScheduler(new SchedulerService());
        NightJobId = null;
    }   
    
    public SchedulerController(IApexJobScheduler nightJobScheduler){
    	m_nightJobScheduler = nightJobScheduler;
    }

    public void StartJob(){
        m_nightJobScheduler.start();
    }
    
    public void StopJob(){
        System.abortJob(NightJobId); 
    }
    
    public void ClearAllCache(){
        Utility.DeleteCache();
    }
    
    public void clearEventLog(){
    	List<EventLog__c> events = [SELECT Id FROM EventLog__c];
    	delete events;
    	Utility.debug_RecordLog('devForce', 'EventLog cleared!', 'SchedulerController.clearEventLog()');
    }
    
    public Id NightJobId{
        get{
            if(NightJobId == null){
                List<CronTrigger> listJobs = [SELECT Id FROM CronTrigger WHERE EndTime=:null AND CronExpression=:'0 35 23 ? * MON-FRI'];
                if(listJobs.size() == 1){
                    return listJobs[0].Id;
                }
                return null;
            }
            return NightJobId;
        }
        set;
    }
     
    public boolean IsJobScheduled{
        get{
            if(NightJobId!=null){
                return true;
            }            
            return false;  
        }
    }
     
    public String startButtonText{
        get{
            if(IsJobScheduled == true){
                return ' Job is currently enabled ';
            }else{
                return ' Enable this job ';
            }
        }
    }
    
     public String stopButtonText{
        get{
            if(IsJobScheduled == true){
                return ' Disable this job ';
            }else{
                return ' Job is currently disabled ';
            }
        }
    }
}