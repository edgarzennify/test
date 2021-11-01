@IsTest
private class LoanArchiveMergeProcessorTests {
    private final static LoanArchiveMergeProcessor sut;
    private final static LoanArchiveMock.ofIHandler mockHandler1;
    private final static LoanArchiveMock.ofIHandler mockHandler2;
    private final static LoanArchiveMock.ofIMergeProcessorHelper mockHelper;

    static {
        mockHandler1 = new LoanArchiveMock.ofIHandler();
        mockHandler2 = new LoanArchiveMock.ofIHandler();
        mockHelper = new LoanArchiveMock.ofIMergeProcessorHelper();
        List<LoanArchive.IHandler> handlers = new List<LoanArchive.IHandler>{mockHandler1,mockHandler2};
        sut = new LoanArchiveMergeProcessor(handlers, mockHelper);
    }

    @IsTest
    static void it_should_build_a_map_from_the_given_requests() {
        Id id1 = ObjectFactory.getFakeId(Account.SObjectType, '1');
        LoanArchive.SObjectMergeRequest r1 = new LoanArchive.SObjectMergeRequest();
        r1.coreObjectId = id1;
        List<LoanArchive.SObjectMergeRequest> requests = new List<LoanArchive.SObjectMergeRequest>{r1};
        Map<SObjectType, List<LoanArchive.SObjectMergeRequest>> requestMap = new Map<SObjectType, List<LoanArchive.SObjectMergeRequest>>();
        requestMap.put(Account.SObjectType, new List<LoanArchive.SObjectMergeRequest>());
        mockHelper.setup('buildRequestMap', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(requestMap);
        mockHandler1.setup('getSObjectTypeHandled').returns(Account.SObjectType);
        mockHelper.setup('mergeObjects', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(new List<LoanArchive.MergeResult>());

        List<LoanArchive.MergeResult> result = sut.process(requests);

        mockHelper.verify('buildRequestMap', new List<Object>{requests}, Times.Once);
    }

    @IsTest
    static void it_should_check_the_handled_type_on_all_handlers() {
        Id id1 = ObjectFactory.getFakeId(Account.SObjectType, '1');
        LoanArchive.SObjectMergeRequest r1 = new LoanArchive.SObjectMergeRequest();
        r1.coreObjectId = id1;
        List<LoanArchive.SObjectMergeRequest> requests = new List<LoanArchive.SObjectMergeRequest>{r1};
        Map<SObjectType, List<LoanArchive.SObjectMergeRequest>> requestMap = new Map<SObjectType, List<LoanArchive.SObjectMergeRequest>>();
        requestMap.put(Account.SObjectType, new List<LoanArchive.SObjectMergeRequest>());
        mockHelper.setup('buildRequestMap', new List<Object>{requests}).returns(requestMap);
        mockHandler1.setup('getSObjectTypeHandled').returns(Account.SObjectType);
        mockHelper.setup('mergeObjects', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(new List<LoanArchive.MergeResult>());

        List<LoanArchive.MergeResult> result = sut.process(requests);

        mockHandler1.verify('getSObjectTypeHandled', Times.Once);
        mockHandler2.verify('getSObjectTypeHandled', Times.Once);
    }

    @IsTest
    static void it_should_throw_a_handler_not_found_exception_if_no_handlers_handle_the_given_type() {
        Id id1 = ObjectFactory.getFakeId(Account.SObjectType, '1');
        LoanArchive.SObjectMergeRequest r1 = new LoanArchive.SObjectMergeRequest();
        r1.coreObjectId = id1;
        List<LoanArchive.SObjectMergeRequest> requests = new List<LoanArchive.SObjectMergeRequest>{r1};
        Map<SObjectType, List<LoanArchive.SObjectMergeRequest>> requestMap = new Map<SObjectType, List<LoanArchive.SObjectMergeRequest>>();
        requestMap.put(Account.SObjectType, new List<LoanArchive.SObjectMergeRequest>());
        mockHelper.setup('buildRequestMap', new List<Object>{requests}).returns(requestMap);

        try {
            List<LoanArchive.MergeResult> result = sut.process(requests);
            System.assert(false);
        } catch (LoanArchive.HandlerNotFoundException ex) {
            System.assert(true);
        } catch (Exception x) {
            System.assert(false);
        }   
    }

    @IsTest
    static void it_should_build_an_id_list_from_the_requests() {
        Id id1 = ObjectFactory.getFakeId(Account.SObjectType, '1');
        Id id2 = ObjectFactory.getFakeId(Account.SObjectType, '2');
        LoanArchive.SObjectMergeRequest r1 = new LoanArchive.SObjectMergeRequest();
        r1.coreObjectId = id1;
        LoanArchive.SObjectMergeRequest r2 = new LoanArchive.SObjectMergeRequest();
        r2.coreObjectId = id2;
        List<LoanArchive.SObjectMergeRequest> requests = new List<LoanArchive.SObjectMergeRequest>{r1};
        List<LoanArchive.SObjectMergeRequest> mappedRequests = new List<LoanArchive.SObjectMergeRequest>{r2};
        Map<SObjectType, List<LoanArchive.SObjectMergeRequest>> requestMap = new Map<SObjectType, List<LoanArchive.SObjectMergeRequest>>();
        requestMap.put(Account.SObjectType, mappedRequests);
        mockHelper.setup('buildRequestMap', new List<Object>{requests}).returns(requestMap);
        mockHandler1.setup('getSObjectTypeHandled').returns(Account.SObjectType);
        mockHelper.setup('mergeObjects', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(new List<LoanArchive.MergeResult>());

        List<LoanArchive.MergeResult> result = sut.process(requests);

        mockHelper.verify('buildIdList', new List<Object>{mappedRequests}, Times.Once);
    }

    @IsTest
    static void it_should_get_the_merge_objects_from_the_handler_with_the_id_list() {
        Id id1 = ObjectFactory.getFakeId(Account.SObjectType, '1');
        Id id2 = ObjectFactory.getFakeId(Account.SObjectType, '2');
        LoanArchive.SObjectMergeRequest r1 = new LoanArchive.SObjectMergeRequest();
        r1.coreObjectId = id1;
        LoanArchive.SObjectMergeRequest r2 = new LoanArchive.SObjectMergeRequest();
        r2.coreObjectId = id2;
        List<LoanArchive.SObjectMergeRequest> requests = new List<LoanArchive.SObjectMergeRequest>{r1};
        List<LoanArchive.SObjectMergeRequest> mappedRequests = new List<LoanArchive.SObjectMergeRequest>{r2};
        Map<SObjectType, List<LoanArchive.SObjectMergeRequest>> requestMap = new Map<SObjectType, List<LoanArchive.SObjectMergeRequest>>();
        requestMap.put(Account.SObjectType, mappedRequests);
        List<Id> ids = new List<Id>{id1};
        mockHelper.setup('buildRequestMap', new List<Object>{requests}).returns(requestMap);
        mockHandler1.setup('getSObjectTypeHandled').returns(Account.SObjectType);
        mockHelper.setup('mergeObjects', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(new List<LoanArchive.MergeResult>());        
        mockHelper.setup('buildIdList', new List<Object>{mappedRequests}).returns(ids);

        List<LoanArchive.MergeResult> result = sut.process(requests);

        mockHandler1.verify('getSObjectsForMerging', new List<Object>{ids}, Times.Once);
    }

    @IsTest
    static void it_should_build_an_sobject_map_from_the_sobjects_returned_from_the_handler() {
        Id id1 = ObjectFactory.getFakeId(Account.SObjectType, '1');
        Id id2 = ObjectFactory.getFakeId(Account.SObjectType, '2');
        LoanArchive.SObjectMergeRequest r1 = new LoanArchive.SObjectMergeRequest();
        r1.coreObjectId = id1;
        LoanArchive.SObjectMergeRequest r2 = new LoanArchive.SObjectMergeRequest();
        r2.coreObjectId = id2;
        List<LoanArchive.SObjectMergeRequest> requests = new List<LoanArchive.SObjectMergeRequest>{r1};
        List<LoanArchive.SObjectMergeRequest> mappedRequests = new List<LoanArchive.SObjectMergeRequest>{r2};
        Map<SObjectType, List<LoanArchive.SObjectMergeRequest>> requestMap = new Map<SObjectType, List<LoanArchive.SObjectMergeRequest>>();
        requestMap.put(Account.SObjectType, new List<LoanArchive.SObjectMergeRequest>());
        List<SObject> sobjects = new List<SObject>{new Account(Id=id1)};
        mockHelper.setup('buildRequestMap', new List<Object>{requests}).returns(requestMap);
        mockHandler1.setup('getSObjectTypeHandled').returns(Account.SObjectType);
        mockHelper.setup('mergeObjects', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(new List<LoanArchive.MergeResult>());
        mockHandler1.setup('getSObjectsForMerging', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(sobjects);

        List<LoanArchive.MergeResult> result = sut.process(requests);

        mockHelper.verify('buildSObjectMap', new List<Object>{sobjects}, Times.Once);
    }

    @IsTest
    static void it_should_merge_objects_using_handler_and_requests_and_sobjects_map() {
        Id id1 = ObjectFactory.getFakeId(Account.SObjectType, '1');
        Id id2 = ObjectFactory.getFakeId(Account.SObjectType, '2');
        LoanArchive.SObjectMergeRequest r1 = new LoanArchive.SObjectMergeRequest();
        r1.coreObjectId = id1;
        LoanArchive.SObjectMergeRequest r2 = new LoanArchive.SObjectMergeRequest();
        r2.coreObjectId = id2;
        List<LoanArchive.SObjectMergeRequest> requests = new List<LoanArchive.SObjectMergeRequest>{r1};
        Map<SObjectType, List<LoanArchive.SObjectMergeRequest>> requestMap = new Map<SObjectType, List<LoanArchive.SObjectMergeRequest>>();
        List<LoanArchive.SObjectMergeRequest> mappedRequests = new List<LoanArchive.SObjectMergeRequest>{r2};
        requestMap.put(Account.SObjectType, mappedRequests);
        List<SObject> sobjects = new List<SObject>{new Account(Id=id1)};
        Map<Id, SObject> sobjectMap = new Map<Id, SObject>();
        sobjectMap.put(id1, new Account(Id=id1));
        mockHelper.setup('buildRequestMap', new List<Object>{requests}).returns(requestMap);
        mockHandler1.setup('getSObjectTypeHandled').returns(Account.SObjectType);
        mockHelper.setup('mergeObjects', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(new List<LoanArchive.MergeResult>());
        mockHelper.setup('buildSObjectMap', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(sobjectMap);

        List<LoanArchive.MergeResult> result = sut.process(requests);

        mockHelper.verify('mergeObjects', new List<Object>{mockHandler1,mappedRequests,sobjectMap}, Times.Once);
    }

    @IsTest
    static void it_should_merge_objects_using_all_handlers_that_handle_the_given_type_and_requests_and_sobjects_map() {
        Id id1 = ObjectFactory.getFakeId(Account.SObjectType, '1');
        Id id2 = ObjectFactory.getFakeId(Account.SObjectType, '2');
        LoanArchive.SObjectMergeRequest r1 = new LoanArchive.SObjectMergeRequest();
        r1.coreObjectId = id1;
        LoanArchive.SObjectMergeRequest r2 = new LoanArchive.SObjectMergeRequest();
        r2.coreObjectId = id2;
        List<LoanArchive.SObjectMergeRequest> requests = new List<LoanArchive.SObjectMergeRequest>{r1};
        List<LoanArchive.SObjectMergeRequest> mappedRequests = new List<LoanArchive.SObjectMergeRequest>{r2};
        Map<SObjectType, List<LoanArchive.SObjectMergeRequest>> requestMap = new Map<SObjectType, List<LoanArchive.SObjectMergeRequest>>();
        requestMap.put(Account.SObjectType, mappedRequests);
        List<SObject> sobjects = new List<SObject>{new Account(Id=id1)};
        Map<Id, SObject> sobjectMap = new Map<Id, SObject>();
        sobjectMap.put(id1, new Account(Id=id1));
        mockHelper.setup('buildRequestMap', new List<Object>{requests}).returns(requestMap);
        mockHandler1.setup('getSObjectTypeHandled').returns(Account.SObjectType);
        mockHandler2.setup('getSObjectTypeHandled').returns(Account.SObjectType);
        mockHelper.setup('mergeObjects', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(new List<LoanArchive.MergeResult>());
        mockHelper.setup('buildSObjectMap', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(sobjectMap);

        List<LoanArchive.MergeResult> result = sut.process(requests);

        mockHelper.verify('mergeObjects', new List<Object>{mockHandler1, mappedRequests, sobjectMap});
        mockHelper.verify('mergeObjects', new List<Object>{mockHandler2, mappedRequests, sobjectMap});
    }

    @IsTest
    static void it_should_return_the_results_from_the_merge() {
        Id id1 = ObjectFactory.getFakeId(Account.SObjectType, '1');
        Id id2 = ObjectFactory.getFakeId(Account.SObjectType, '2');
        Id id3 = ObjectFactory.getFakeId(Account.SObjectType, '3');
        LoanArchive.SObjectMergeRequest r1 = new LoanArchive.SObjectMergeRequest();
        r1.coreObjectId = id1;
        LoanArchive.SObjectMergeRequest r2 = new LoanArchive.SObjectMergeRequest();
        r2.coreObjectId = id2;
        List<LoanArchive.SObjectMergeRequest> requests = new List<LoanArchive.SObjectMergeRequest>{r1};
        Map<SObjectType, List<LoanArchive.SObjectMergeRequest>> requestMap = new Map<SObjectType, List<LoanArchive.SObjectMergeRequest>>();
        List<LoanArchive.SObjectMergeRequest> mappedRequests = new List<LoanArchive.SObjectMergeRequest>{r2};
        requestMap.put(Account.SObjectType, new List<LoanArchive.SObjectMergeRequest>());
        List<SObject> sobjects = new List<SObject>{new Account(Id=id1)};
        Map<Id, SObject> sobjectMap = new Map<Id, SObject>();
        sobjectMap.put(id1, new Account(Id=id1));
        LoanArchive.MergeResult mergeResult = new LoanArchive.MergeResult();
        mergeResult.saveRecords = new List<SObject>{new Account(Id=id3)};
        List<LoanArchive.MergeResult> mergeResults = new List<LoanArchive.MergeResult>{mergeResult};
        mockHelper.setup('buildRequestMap', new List<Object>{requests}).returns(requestMap);
        mockHandler1.setup('getSObjectTypeHandled').returns(Account.SObjectType);
        mockHelper.setup('mergeObjects', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(mergeResults);

        List<LoanArchive.MergeResult> result = sut.process(requests);

        System.assertEquals(1, result.size());
        System.assertEquals(mergeResult, result[0]);
    }
}