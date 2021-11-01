@IsTest
private class LoanArchiveHandlerCollateralTests {

    private static final LoanArchiveHandlerCollateral sut;
    private static final LoanArchiveMock.ofIDataProvider mockDataProvider;
    private static final LoanArchiveMock.ofIHandlerCollateralHelper mockHelper;

    static {
        mockDataProvider = new LoanArchiveMock.ofIDataProvider();
        mockHelper = new LoanArchiveMock.ofIHandlerCollateralHelper();
        sut = new LoanArchiveHandlerCollateral(mockDataProvider, mockHelper);
    }

    @IsTest
    static void it_should_return_the_collateral_sobject_type() {
        SObjectType result = sut.getSObjectTypeHandled();

        System.assertEquals(LLC_BI__Collateral__c.SObjectType, result);
    }

    @IsTest
    static void it_should_query_the_data_provider_for_collateral_with_given_ids() {
        Id cid = Objectfactory.getFakeId(LLC_BI__Collateral__c.SObjectType, '1');
        List<Id> ids = new List<Id> { cid };
        
        List<SObject> result = sut.getSObjectsForMerging(ids);

        mockDataProvider.verify('getCollateralForMerge', new List<Object>{ids}, Times.Once);
    }
    
    @IsTest
    static void it_should_call_the_helper_to_build_save_list() {
        Id prospectId = Objectfactory.getFakeId(LLC_BI__Collateral__c.SObjectType, '1');
        Id coreId = Objectfactory.getFakeId(LLC_BI__Collateral__c.SObjectType, '2');
        LLC_BI__Collateral__c prospect = new LLC_BI__Collateral__c(Id = prospectId);
        LLC_BI__Collateral__c core = new LLC_BI__Collateral__c(Id = coreId);
       
        mockHelper.setup('reparentCollateralPledges', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).Returns(new List<SObject>());
        mockHelper.setup('reparentCollateralOwnerships', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).Returns(new List<SObject>());
        mockHelper.setup('reparentCollateralDocuments', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).Returns(new List<SObject>());
        Map<Id, SObject> mergeData = new Map<Id, SObject>{prospectId => prospect, coreId => core};

        sut.mergeObjects(prospectId, coreId, mergeData);

        mockHelper.verify('reparentCollateralPledges', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
        mockHelper.verify('reparentCollateralOwnerships', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
        mockHelper.verify('reparentCollateralDocuments', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
    }

    @IsTest
    static void it_should_call_the_document_helper_to_get_merged_objects() {
        Id prospectId = Objectfactory.getFakeId(LLC_BI__Collateral__c.SObjectType, '1');
        Id coreId = Objectfactory.getFakeId(LLC_BI__Collateral__c.SObjectType, '2');
        LLC_BI__Collateral__c prospect = new LLC_BI__Collateral__c(Id = prospectId);
        LLC_BI__Collateral__c core = new LLC_BI__Collateral__c(Id = coreId, Sync_Key__c = '616-1230');
        List<Id> collateralIds = new List<Id>{coreId};
        LLC_BI__Document_PlaceHolder__c doc1 = new LLC_BI__Document_PlaceHolder__c(LLC_BI__External_Id__c = prospectId);
        LLC_BI__Document_PlaceHolder__c doc2 = new LLC_BI__Document_PlaceHolder__c(LLC_BI__External_Id__c = coreId);
        List<LLC_BI__Document_PlaceHolder__c> documents = new List<LLC_BI__Document_PlaceHolder__c>{doc1, doc2};
        List<LLC_BI__Document_PlaceHolder__c> prospectDocs = new List<LLC_BI__Document_PlaceHolder__c>{doc1};
        List<LLC_BI__Document_PlaceHolder__c> coreDocs = new List<LLC_BI__Document_PlaceHolder__c>{doc2};

        LLC_BI__Document_PlaceHolder__c doc1merge = new LLC_BI__Document_PlaceHolder__c(LLC_BI__External_Id__c = prospectId);
        LLC_BI__Document_PlaceHolder__c doc2merge = new LLC_BI__Document_PlaceHolder__c(LLC_BI__External_Id__c = prospectId);
        List<LLC_BI__Document_PlaceHolder__c> mergedDocs = new List<LLC_BI__Document_PlaceHolder__c>{doc1merge, doc2merge};
        
        mockHelper.setup('reparentCollateralPledges', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).Returns(new List<SObject>());
        mockHelper.setup('reparentCollateralOwnerships', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).Returns(new List<SObject>());
        mockHelper.setup('reparentCollateralDocuments', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).Returns(mergedDocs);
        Map<Id, SObject> mergeData = new Map<Id, SObject>{prospectId => prospect, coreId => core};
        mockDataProvider.setup('getCollateralDocumentsForMerge', new List<Object>{collateralIds}).Returns(documents);

        sut.mergeObjects(prospectId, coreId, mergeData);

        mockHelper.verify('reparentCollateralDocuments', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
        List<Object> arguments = (List<Object>)mockHelper.getArgumentsFromCall('reparentCollateralDocuments');
        Id argProspectCollateralId = (Id)arguments[0];
        List<LLC_BI__Document_PlaceHolder__c> argCoreDocs = (List<LLC_BI__Document_PlaceHolder__c>)arguments[1];
        System.assertEquals(prospectid, argProspectCollateralId);
        System.assertEquals(coreid, argCoreDocs[0].LLC_BI__External_Id__c);        
    }
}