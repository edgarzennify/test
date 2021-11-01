global class ApexUnitTestService implements ApexUnitTests.IApexUnitTestService {
	
    private ApexUnitTestService(){}
    
    private static ApexUnitTests.IDataProvider m_dataProvider{
    	get{
    		return ApexUnitTestServiceDataProvider.getInstance();
    	}
    }
    
    webservice static Id runAllTests(){
        Id jobId;
        List<ApexClass> classes = removeClassesWithoutTests(m_dataProvider.getApexClasses());        
        List<ApexTestQueueItem> queueItems = buildQueueItemsFromClasses(classes);        
        m_dataProvider.insertTestQueueItems(queueItems);
        jobId = m_dataProvider.getJobIdFromQueueItem(queueItems[0].Id);     
        Utility.debug_RecordLog('ApexUnitTest', '<Method>runAllTests</Method><Action>Returned jobID=' + jobId + '</Action>', 'ApexUnitTestService.runAllTests()');
        return jobId;
    }
    
    static List<ApexClass> removeClassesWithoutTests(List<ApexClass> allClasses){
    	List<ApexClass> classesWithTests = new List<ApexClass>();
    	for(ApexClass cls : allClasses){
            if(cls.Body.toUpperCase().indexOf('@ISTEST') != -1 || cls.Body.toUpperCase().indexOf('TESTMETHOD') != -1){
                classesWithTests.add(cls);
            }
        }
        return classesWithTests;
    }
    
    webservice static String getStatus(Id jobId){
    	if(jobId == null){
    	   throw new ApexUnitTests.ApexUnitTestsException('unknown jobId: ' + string.valueOf(jobId));
    	}
    	
    	Boolean isComplete = true;
    	String status = 'Completed';
    	
        List<ApexTestQueueItem> queueItems = m_dataProvider.getAggregateResultsByJobId(jobId);
        Integer totalItems = queueItems.size();
        Integer completedItems = 0;
        for(ApexTestQueueItem queueItem : queueItems){
        	if(queueItem.Status == 'Failed'){
        		status = 'Failed';
        	}else if(queueItem.Status != 'Completed'){
                isComplete = false;
        	}
        	if(queueItem.Status=='Completed' || queueItem.Status=='Failed'){
        		completedItems += 1;
        	}
        }
        if(isComplete){
        	return status;
        }else{
            return 'Queued/Processing';
        }
    }
    
    webservice static List<ApexTestResult> getFailedTests(Id jobId){
    	if(jobId == null){
           throw new ApexUnitTests.ApexUnitTestsException('unknown jobId: ' + string.valueOf(jobId));
        }
        
    	List<ApexTestResult> failedTests = new List<ApexTestResult>();
    	List<ApexTestResult> testResults = m_dataProvider.getDetailedResultsByJobId(jobId);
    	if(testResults != null){
	        for(ApexTestResult tr : testResults){
	            if(tr.Outcome == 'Fail'){
	            	failedTests.add(tr);
	            }
	        }
    	}
        return failedTests;
    }
    
    webservice static String getCompilationError(Id jobId){
    	if(jobId == null){
           throw new ApexUnitTests.ApexUnitTestsException('unknown jobId: ' + string.valueOf(jobId));
        }
        
        if(getStatus(jobId) == 'Failed'){
            List<ApexTestResult> testResults = m_dataProvider.getDetailedResultsByJobId(jobId);
            return testResults[0].Message;
        }        
        return '';
    }
    
    private static List<ApexTestQueueItem> buildQueueItemsFromClasses(List<ApexClass> classes){
    	List<ApexTestQueueItem> queueItems = new List<ApexTestQueueItem>();
        if(classes != null){
	        for(ApexClass cls : classes){
	            queueItems.add(new ApexTestQueueItem(ApexClassId=cls.Id));
	        }
        }
        return queueItems;
    }
}