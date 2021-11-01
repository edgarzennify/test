public class ApexUnitTestsController {
		
	private Id m_jobId;    
    public String status {get;set;}
    public List<ApexTestResult> detailedResults {get;set;}
    public Id jobId{
    	get{
    		return m_jobId;
    	}
    }
    
    public void runTests(){
    	m_jobId = ApexUnitTestService.runAllTests();
    }
    
    public void checkStatus(){
    	status = ApexUnitTestService.getStatus(m_jobId);
    }
    
    public void updateResults(){    	
    	detailedResults = ApexUnitTestService.getFailedTests(m_jobId);
    }

}