public class ApexUnitTests {
	public interface IApexUnitTestService{
        Id runAllTests();
        String getStatus(Id jobId);
        List<ApexTestResult> getFailedTests(Id jobId);
        String getCompilationError(Id jobId);
	}
	
	public interface IDataProvider{
		List<ApexClass> getApexClasses();
		void insertTestQueueItems(List<ApexTestQueueItem> queueItems);
		Id getJobIdFromQueueItem(Id queueItemId);
		List<ApexTestQueueItem> getAggregateResultsByJobId(Id jobId);
		List<ApexTestResult> getDetailedResultsByJobId(Id jobId);
	}
	
	public class ApexUnitTestsException extends Exception{

	}
}