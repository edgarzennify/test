@IsTest
private class LoanArchiveHandlerEntityTests {

    private final static LoanArchiveHandlerEntity sut;
    private final static LoanArchiveMock.ofIDataProvider mockDataProvider; 
    private final static LoanArchiveMock.ofIHandlerEntityHelper mockHelper;

    static {
        mockDataProvider = new LoanArchiveMock.ofIDataProvider();
        mockHelper = new LoanArchiveMock.ofIHandlerEntityHelper();
        sut = new LoanArchiveHandlerEntity(mockDataProvider, mockHelper);
    }

    @IsTest
    static void it_should_get_the_sobject_type() {
        SObjectType result = sut.getSObjectTypeHandled();

        System.assertEquals(Account.SobjectType, result);
    }

    @IsTest
    static void it_should_call_the_data_provider_to_get_merge_objects() {
        Id prospectId = ObjectFactory.getFakeId(Account.SObjectType, '1');
        Id coreId = ObjectFactory.getFakeId(Account.SObjectType, '2');
        List<Id> objectIds = new List<Id>{prospectId, coreId};
        List<Account> entities = new List<Account> {new Account(Id = prospectId), new Account(Id = coreId)};
        
        mockDataProvider.setup('getEntitiesForMerge', new List<Object> {objectIds}).returns(entities);

        List<Account> result = sut.getSObjectsForMerging(objectIds);

        mockDataProvider.verify('getEntitiesForMerge', new List<Object> {objectIds}, Times.Once);
        System.assertEquals(2, result.size());
        System.assertEquals(entities, result);
    }

    @IsTest
    static void it_should_build_merged_result_objects_from_prospect_and_core_objects() {
        Id pid = ObjectFactory.getFakeId(Account.SObjectType, '1');
        Id cid = ObjectFactory.getFakeId(Account.SObjectType, '2');
        Account prospect = new Account(Id=pid);
        Account core = new Account(Id=cid);
        Map<Id,SObject> mergeData = new Map<Id,SObject>();
        mergeData.put(pid,prospect);
        mergeData.put(cid,core);

        mockHelper.setup('reparentCollateralOwnerships', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(new List<SObject>());
        mockHelper.setup('reparentEbAccountOwnerships', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE). returns(new List<SObject>());
        mockHelper.setup('reparentEbAccountRelationships', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(new List<SObject>());
        mockHelper.setup('reparentEbCollateralOwnerships' ,ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(new List<SObject>());
        mockHelper.setup('reparentEbCollateralRelationships', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(new List<SObject>());
        mockHelper.setup('reparentLoans', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(new List<SObject>());
        mockHelper.setup('reparentEntityInvolvements', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(new List<SObject>());
        mockHelper.setup('createDeletesForEntityInvolvements', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(new List<SObject>());
        mockHelper.setup('createDeletesForCollateralOwnerships', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(new List<SObject>());

        LoanArchive.MergeResult result = sut.mergeObjects(pid, cid, mergeData);

        mockHelper.verify('reparentCollateralOwnerships', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
        mockHelper.verify('reparentEbAccountOwnerships', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
        mockHelper.verify('reparentEbAccountRelationships', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
        mockHelper.verify('reparentEbCollateralOwnerships' ,ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
        mockHelper.verify('reparentEbCollateralRelationships', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
        mockHelper.verify('reparentEntityInvolvements', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
        mockHelper.verify('reparentLoans', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
        mockHelper.verify('createDeletesForEntityInvolvements', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
        mockHelper.verify('createDeletesForCollateralOwnerships', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
        System.assertEquals(prospect, result.saveRecords[0]);
    }
}