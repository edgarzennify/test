@IsTest
private class LoanArchiveMergeProcessorHelperTests {

    private final static LoanArchiveMergeProcessorHelper sut;

    static {
        sut = new LoanArchiveMergeProcessorHelper();
    }

    @IsTest
    static void it_should_build_a_request_map_when_merge_requests_are_provided() {
        Id prospectEntityId = ObjectFactory.getFakeId(Account.SObjectType, '1');
        Id coreEntityId = ObjectFactory.getFakeId(Account.SObjectType, '2');
        Id prospectCollateralId = ObjectFactory.getFakeId(LLC_BI__Collateral__c.SObjectType, '1');
        Id coreCollateralId = ObjectFactory.getFakeId(LLC_BI__Collateral__c.SObjectType, '2');
        LoanArchive.SObjectMergeRequest request1 = new LoanArchive.SObjectMergeRequest();
        request1.prospectObjectId = prospectEntityId;
        request1.coreObjectId = coreEntityId;
        LoanArchive.SObjectMergeRequest request2 = new LoanArchive.SObjectMergeRequest();
        request2.prospectObjectId = prospectCollateralId;
        request2.coreObjectId = coreCollateralId;
        List<LoanArchive.SObjectMergeRequest> requests = new List<LoanArchive.SObjectMergeRequest>{request1, request2};

        Map<SObjectType, List<LoanArchive.SObjectMergeRequest>> result = sut.buildRequestMap(requests);

        System.assertEquals(2, result.values().size());
        System.assertEquals(request1, result.get(prospectEntityId.getSObjectType())[0]);
        System.assertEquals(request2, result.get(prospectCollateralId.getSObjectType())[0]);
    }

    @IsTest
    static void it_should_build_a_list_of_ids_from_requests() {
        Id prospectEntityId = ObjectFactory.getFakeId(Account.SObjectType, '1');
        Id prospectCollateralId = ObjectFactory.getFakeId(LLC_BI__Collateral__c.SObjectType, '1');
        LoanArchive.SObjectMergeRequest request1 = new LoanArchive.SObjectMergeRequest();
        request1.prospectObjectId = prospectEntityId;
        LoanArchive.SObjectMergeRequest request2 = new LoanArchive.SObjectMergeRequest();
        request2.prospectObjectId = prospectCollateralId;
        List<LoanArchive.SObjectMergeRequest> requests = new List<LoanArchive.SObjectMergeRequest>{request1, request2};
        
        List<Id> result = sut.buildIdList(requests);

        System.assertEquals(4, result.size());
        Set<Id> resultSet = new Set<Id>(result);
        System.assert(resultSet.contains(prospectEntityId));
        System.assert(resultSet.contains(prospectCollateralId));
    }

    @IsTest
    static void it_should_build_an_sobjectmap_from_given_sobjects() {
        Id prospectEntityId = ObjectFactory.getFakeId(Account.SObjectType, '1');
        Id coreEntityId = ObjectFactory.getFakeId(Account.SObjectType, '2');
        SObject sobj1 = new Account(Id = prospectEntityId);
        SObject sobj2 = new Account(Id = coreEntityId);
        List<SObject> sobjects = new List<SObject>{sobj1, sobj2};

        Map<Id, SObject> result = sut.buildSObjectMap(sobjects);

        System.assertEquals(2, result.values().size());
        System.assertEquals(sobj1, result.get(sobj1.Id));
        System.assertEquals(sobj2, result.get(sobj2.Id));
    }

    @IsTest
    static void it_should_assert_the_arguments_passed_to_the_merge_objects() {
        Id prospectEntityId = ObjectFactory.getFakeId(Account.SObjectType, '1');
        Id coreEntityId = ObjectFactory.getFakeId(Account.SObjectType, '2');
        SObject prospectSObj = new Account(Id = prospectEntityId);
        SObject coreEntitySObj = new Account(Id = coreEntityId);
        LoanArchive.SObjectMergeRequest request1 = new LoanArchive.SObjectMergeRequest();
        request1.prospectObjectId = prospectEntityId;
        request1.coreObjectId = coreEntityId;
        List<LoanArchive.SObjectMergeRequest> requests = new List<LoanArchive.SObjectMergeRequest>{request1};
        Map<Id, SObject> sobjectMap = new Map<Id, SObject>{prospectEntityId => prospectSObj,coreEntityId =>coreEntitySObj};
        LoanArchiveMock.ofIHandler mockHandler = new LoanArchiveMock.ofIHandler();
        LoanArchive.MergeResult mergeResult = new LoanArchive.MergeResult();
        mockHandler.setup('mergeObjects', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(mergeResult);

        List<LoanArchive.MergeResult> result = sut.mergeObjects(mockHandler, requests, sobjectMap);

        mockHandler.verify('mergeObjects', new List<Object>{prospectEntityId, coreEntityId, sobjectMap}, Times.Once);
    }
}