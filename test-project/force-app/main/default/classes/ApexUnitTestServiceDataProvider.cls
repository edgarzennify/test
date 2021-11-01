public class ApexUnitTestServiceDataProvider implements ApexUnitTests.IDataProvider{
    
    private static ApexUnitTests.IDataProvider m_instance;
    
    private ApexUnitTestServiceDataProvider(){
        
    }
    
    @testVisible
    private static void setInstance(ApexUnitTests.IDataProvider dataProvider){
        m_instance = dataProvider;
    }
    
    public static ApexUnitTests.IDataProvider getInstance(){
        if(m_instance == null){
            setInstance(new ApexUnitTestServiceDataProvider());
        }
        return m_instance;
    }
    
    public List<ApexClass> getApexClasses(){
        return [SELECT Id, Name, Body FROM ApexClass ORDER BY Name];
    }
    
    public void insertTestQueueItems(List<ApexTestQueueItem> queueItems){
        insert queueItems;
    }
    
    public Id getJobIdFromQueueItem(Id queueItemId){
        ApexTestQueueItem item = [SELECT ParentJobId FROM ApexTestQueueItem WHERE Id=:queueItemId LIMIT 1];
        return item.parentJobId;
    }
    
    public List<ApexTestQueueItem> getAggregateResultsByJobId(Id jobId){
        return [SELECT Id, ApexClass.Name, Status, ExtendedStatus FROM ApexTestQueueItem WHERE ParentJobId=:jobId];
    }
    
    public List<ApexTestResult> getDetailedResultsByJobId(Id jobId){
        return [SELECT Outcome, ApexClass.Name, MethodName, Message, StackTrace FROM ApexTestResult WHERE AsyncApexJobId=:jobId];
    }
}