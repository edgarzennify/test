@IsTest
private class ApexUnitTestServiceTests{
    
    static testMethod void it_should_run_all_tests(){
        MockDataProvider mockDataProvider = new MockDataProvider();
        ApexUnitTestServiceDataProvider.setInstance(mockDataProvider);
        MockDataProvider.getApexClasses_Return = new List<ApexClass>{new ApexClass(Body='testMethod')};

        ApexUnitTestService.runAllTests();
        
        system.assertEquals(true,mockDataProvider.getApexClasses_Called);        
    }
    
    static testMethod void it_should_return_a_status_for_a_jobid(){
        MockDataProvider mockDataProvider = new MockDataProvider();
        ApexUnitTestServiceDataProvider.setInstance(mockDataProvider);
        mockDataProvider.getApexClasses_Return = new List<ApexClass>{new ApexClass(Body='testMethod')};
        mockDataProvider.getJobIdFromQueueItem_Return = Id.valueOf('0EWa00000008qBH');
        mockDataProvider.getAggregateResultsByJobId_Return = new List<ApexTestQueueItem>{new ApexTestQueueItem()};
                
        Id jobId = ApexUnitTestService.runAllTests();
        String status = ApexUnitTestService.getStatus(jobId);
        
        system.assertEquals(true , mockDataProvider.getAggregateResultsByJobId_Called);        
    }
    
    static testMethod void it_should_call_the_failed_result_method(){
        MockDataProvider mockDataProvider = new MockDataProvider();
        ApexUnitTestServiceDataProvider.setInstance(mockDataProvider);
        mockDataProvider.getApexClasses_Return = new List<ApexClass>{new ApexClass(Body='testMethod')};
        mockDataProvider.getJobIdFromQueueItem_Return = Id.valueOf('0EWa00000008qBH');
                
        Id jobId = ApexUnitTestService.runAllTests();
        List<ApexTestResult> failedResults = ApexUnitTestService.getFailedTests(jobId);
        
        system.assertEquals(true , mockDataProvider.getDetailedResultsByJobId_Called);        
    } 
    
    private class MockDataProvider Implements ApexUnitTests.IDataProvider{
        
        Public Boolean getAggregateResultsByJobId_Called{get; private set;}
        Public Id getAggregateResultsByJobId_param_jobId{get; private set;}
        Public List<ApexTestQueueItem> getAggregateResultsByJobId_Return{get; private set;}
        
        Public Boolean getDetailedResultsByJobId_Called{get; private set;}
        Public Id getDetailedResultsByJobId_jobId{get; private set;}
        Public List<ApexTestResult> getDetailedResultsByJobId_Return{get; private set;}
        
        Public Boolean getJobIdFromQueueItem_Called{get; private set;}
        Public Id getJobIdFromQueueItem_param_queueItem{get; private set;}
        Public Id getJobIdFromQueueItem_Return{get; private set;}
        
        Public Boolean insertTestQueueItems_Called{get; private set;}
        Public List<ApexTestQueueItem> insertTestQueueItems_param_queueItems{get; private set;}
        
        Public Boolean getApexClasses_Called{get; private set;}
        Public List<ApexClass> getApexClasses_Return {get; private set;}
        
        
        Public List<ApexTestQueueItem> getAggregateResultsByJobId(Id jobId){
            getAggregateResultsByJobId_Called = true;
            getAggregateResultsByJobId_param_jobId = jobId;
            return getAggregateResultsByJobId_Return;
        }
        Public List<ApexTestResult> getDetailedResultsByJobId(Id jobId){
            getDetailedResultsByJobId_Called = true;
            getDetailedResultsByJobId_jobId = jobId;
            Return getDetailedResultsByJobId_Return;
        }
        Public Id getJobIdFromQueueItem(Id queueItem){
            getJobIdFromQueueItem_Called = true;
            getJobIdFromQueueItem_param_queueItem = queueItem;
            return getJobIdFromQueueItem_Return;
        }
        Public void insertTestQueueItems(List<ApexTestQueueItem> queueItems){
            insertTestQueueItems_Called = true;
            insertTestQueueItems_param_queueItems = queueItems;             
        }
        Public List<ApexClass> getApexClasses(){
            getApexClasses_Called = true;
            return getApexClasses_Return;
            
        }
    }

}