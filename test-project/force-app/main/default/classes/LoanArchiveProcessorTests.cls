@IsTest
private class LoanArchiveProcessorTests {
    
    private final static LoanArchiveProcessor sut;
    private final static LoanArchiveMock.ofIDataProvider mockDataProvider;
    private final static LoanArchiveMock.ofIMergeProcessor mockMergeProcessor;
    private final static Mock.ofIImagingServiceProxy mockImagingService;

    static {
        mockDataProvider = new LoanArchiveMock.ofIDataProvider();
        mockMergeProcessor = new LoanArchiveMock.ofIMergeProcessor();
        mockImagingService = new Mock.ofIImagingServiceProxy();
        sut = new LoanArchiveProcessor(mockDataProvider, mockMergeProcessor, mockImagingService);
    }

    @IsTest
    static void it_should_process_the_request_with_the_merge_processor() {
        Id loanId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        List<LoanArchive.SObjectMergeRequest> requests = new List<LoanArchive.SObjectMergeRequest>();
        LoanArchive.MergeResult result = new LoanArchive.MergeResult();
        result.saveRecords = new List<SObject>();
        result.deleteRecords = new List<SObject>();
        result.mergeRecords = new List<LoanArchive.MergeRequest>();
        result.keyUpdates = new List<LoanArchive.DocumentKeyUpdate>();
        List<LoanArchive.MergeResult> results = new List<LoanArchive.MergeResult>{result};
        mockMergeProcessor.setup('process', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(results);

        sut.process(loanId, requests);

        mockMergeProcessor.verify('process', new List<Object>{requests}, Times.Once);
    }

    @IsTest
    static void it_should_save_the_list_returned_by_the_merge_processor() {
        Id loanId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        List<LoanArchive.SObjectMergeRequest> requests = new List<LoanArchive.SObjectMergeRequest>();
        LoanArchive.MergeResult result = new LoanArchive.MergeResult();
        Id id1 = ObjectFactory.getFakeId(Account.SObjectType, '1');
        Id id2 = ObjectFactory.getFakeId(Account.SObjectType, '2');
        Account entity1 = new Account(Id=id1);
        Account entity2 = new Account(Id=id2);
        result.saveRecords = new List<SObject>{entity1};
        result.deleteRecords = new List<SObject>{entity2};
        result.mergeRecords = new List<LoanArchive.MergeRequest>();
        result.keyUpdates = new List<LoanArchive.DocumentKeyUpdate>();
        List<LoanArchive.MergeResult> results = new List<LoanArchive.MergeResult>{result};
        mockMergeProcessor.setup('process', new List<Object>{requests}).returns(results);

        sut.process(loanId, requests);

        List<Object> saveParams = mockDataProvider.getArgumentsFromCall('save');
        List<Object> removeParams = mockDataProvider.getArgumentsFromCall('remove');
        List<SObject> saves = (List<SObject>)saveParams[0];
        List<SObject> deletes = (List<SObject>)removeParams[0];
        System.assertEquals(1, saves.size());
        System.assertEquals(entity1, saves[0]);
        System.assertEquals(1, deletes.size());
        System.assertEquals(entity2, deletes[0]);
    }

    @IsTest
    static void it_should_rollback_the_database_changes_and_rethrow_the_exception_when_save_throws_an_exception() {
        Id loanId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        List<LoanArchive.SObjectMergeRequest> requests = new List<LoanArchive.SObjectMergeRequest>();
        LoanArchive.MergeResult result = new LoanArchive.MergeResult();
        Id id1 = ObjectFactory.getFakeId(Account.SObjectType, '1');
        Id id2 = ObjectFactory.getFakeId(Account.SObjectType, '2');
        Account entity1 = new Account(Id=id1);
        Account entity2 = new Account(Id=id2);
        result.saveRecords = new List<SObject>{entity1};
        result.deleteRecords = new List<SObject>{entity2};
        result.mergeRecords = new List<LoanArchive.MergeRequest>();
        result.keyUpdates = new List<LoanArchive.DocumentKeyUpdate>();
        List<LoanArchive.MergeResult> results = new List<LoanArchive.MergeResult>{result};
        Savepoint testSavepoint = Database.setSavepoint();
        ApplicationException testException = new ApplicationException('test-test-test');
        mockMergeProcessor.setup('process', new List<Object>{requests}).returns(results);
        mockDataProvider.setup('setSavepoint').returns(testSavepoint);
        mockDataProvider.setup('save', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).throws(testException);

        try {
            sut.process(loanId, requests);
            System.assert(false);
        } catch (ApplicationException ex) {
            System.assertEquals(testException.getMessage(), ex.getMessage());
        } catch (Exception xex) {
            System.assert(false);
        }
        
        mockDataProvider.verify('rollback', new List<Object>{testSavepoint}, Times.Once);
    }

    @IsTest
    static void it_should_call_the_image_proxy_and_pass_the_key_update() {
        Id loanId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        List<LoanArchive.SObjectMergeRequest> requests = new List<LoanArchive.SObjectMergeRequest>();
        LoanArchive.MergeResult result = new LoanArchive.MergeResult();
        LoanArchive.DocumentKeyUpdate keyUpdate = new LoanArchive.DocumentKeyUpdate();
        keyUpdate.oldExternalKey = 'oldKey';
        keyUpdate.newExternalKey = 'newKey';
        result.saveRecords = new List<SObject>();
        result.deleteRecords = new List<SObject>();
        result.mergeRecords = new List<LoanArchive.MergeRequest>();
        result.keyUpdates = new List<LoanArchive.DocumentKeyUpdate>{keyUpdate};
        List<LoanArchive.MergeResult> results = new List<LoanArchive.MergeResult>{result};
        mockMergeProcessor.setup('process', new List<Object>{requests}).returns(results);

        sut.process(loanId, requests);

        mockImagingService.verify('updateDocumentKeys_Async', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
        List<Object> arguments = mockImagingService.getArgumentsFromCall('updateDocumentKeys_Async');
        List<ImagingServiceProxy.UpdateDocumentKeysRequest> keys = (List<ImagingServiceProxy.UpdateDocumentKeysRequest>)arguments[0];
        System.assertEquals('oldKey', keys[0].oldExternalKey);
        System.assertEquals('newKey', keys[0].newExternalKey);
    }
}