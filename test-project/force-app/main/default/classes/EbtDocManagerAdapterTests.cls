@IsTest
private class EbtDocManagerAdapterTests {
    private final static EbtDocManagerAdapter sut;
    private final static Mock.ofIJson mockJson;
    private final static Mock.ofIImagingServiceProxy mockImagingSvc;
    private final static EbtDocManagerMock.ofIPluginManager mockPluginMgr;
    private final static EbtDocManagerMock.ofIInternalStore mockInternalStore;
    
    static {
        mockImagingSvc = new Mock.ofIImagingServiceProxy();
        mockJson = new Mock.ofIJson();
        mockPluginMgr = new EbtDocManagerMock.ofIPluginManager();
        mockInternalStore = new EbtDocManagerMock.ofIInternalStore();
        sut = new EbtDocManagerAdapter(mockImagingSvc, mockJson, mockPluginMgr, mockInternalStore);
    }

    @IsTest
    static void it_should_call_the_imaging_service_when_getting_token_for_chunked_upload() {
        Integer chunkCount = 1;

        sut.getTokenForChunkedUpload(chunkCount);

        mockImagingSvc.verify('getChunkedMessageToken', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
    }

    @IsTest
    static void it_should_call_the_imaging_service_when_saving_document_chunk() {
        String messageToken = '123';
        String chunkContent = 'abc';
        Integer sequenceNumber = 1;

        sut.saveDocumentChunkToExternalStore(messageToken, chunkContent, sequenceNumber);

        mockImagingSvc.verify('storeDocumentChunked', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
    }

    @IsTest
    static void it_should_get_the_plugin_from_the_plugin_manager() {
        String objectId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '001');
        EbtDocManagerMock.ofIPlugin mockPlugin = new EbtDocManagerMock.ofIPlugin();
        mockPluginMgr.setup('getPluginByObjectId', new List<Object>{objectId}).returns(mockPlugin);
        mockImagingSvc.setup('getDocumentMetadata', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(new List<ImagingServiceProxy.DocumentMetadata>());
        mockPlugin.setup('getExternalDocumentLookup', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(new EbtDocManager.ExternalDocumentLookup());

        sut.reconcileInternalStore(objectId);

        mockPluginMgr.verify('getPluginByObjectId', new List<Object>{objectId}, Times.Once);
    }

    @IsTest
    static void it_should_get_the_external_identifiers_from_the_internal_store() {
        String objectId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '001');
        EbtDocManagerMock.ofIPlugin mockPlugin = new EbtDocManagerMock.ofIPlugin();
        mockPluginMgr.setup('getPluginByObjectId', new List<Object>{objectId}).returns(mockPlugin);
        mockImagingSvc.setup('getDocumentMetadata',ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(new List<ImagingServiceProxy.DocumentMetadata>());
        mockPlugin.setup('getExternalDocumentLookup', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(new EbtDocManager.ExternalDocumentLookup());

        sut.reconcileInternalStore(objectId);

        mockInternalStore.verify('getExternalIdentifiers', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
    }

    @IsTest
    static void it_should_get_the_documents_from_the_imaging_service_by_passing_lookup_retrieved_from_plugin() {
        String objectId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '001');
        String keyStatus = '000';
        String keyType = 'aaa';
        List<String> keys = new List<String>{'bbb'};
        EbtDocManager.ExternalDocumentLookup lookup = new EbtDocManager.ExternalDocumentLookup();
        lookup.keys = keys;
        EbtDocManagerMock.ofIPlugin mockPlugin = new EbtDocManagerMock.ofIPlugin();
        mockPluginMgr.setup('getPluginByObjectId', new List<Object>{objectId}).returns(mockPlugin);
        mockPlugin.setup('getExternalDocumentLookup', new List<Object>{objectId}).returns(lookup);
        mockImagingSvc.setup('getDocumentMetadata', new List<Object>{keys}).returns(new List<ImagingServiceProxy.DocumentMetadata>());

        sut.reconcileInternalStore(objectId);

        mockImagingSvc.verify('getDocumentMetadata', new List<Object>{keys});
    }

    @IsTest
    static void it_should_get_the_missing_documents_from_plugin() {
        String objectId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '001');
        List<ImagingServiceProxy.DocumentMetadata> docs = new List<ImagingServiceProxy.DocumentMetadata>();
        ImagingServiceProxy.DocumentMetadata doc = new ImagingServiceProxy.DocumentMetadata();
        doc.documentId = '1234';
        docs.add(doc);
        String existingDocumentId = '4567';
        Set<String> externalIds = new Set<String>{existingDocumentId};
         
        EbtDocManagerMock.ofIPlugin mockPlugin = new EbtDocManagerMock.ofIPlugin();
        mockPluginMgr.setup('getPluginByObjectId', new List<Object>{objectId}).returns(mockPlugin);
        mockInternalStore.setup('getExternalIdentifiers', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(externalIds);
        mockPlugin.setup('getExternalDocumentLookup', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(new EbtDocManager.ExternalDocumentLookup());
        mockImagingSvc.setup('getDocumentMetadata', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(docs);

        sut.reconcileInternalStore(objectId);

        mockInternalStore.verify('createDocumentsFromExternalDocuments', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
        List<Object> arguments = (List<Object>)mockInternalStore.getArgumentsFromCall('createDocumentsFromExternalDocuments');
        List<ImagingServiceProxy.DocumentMetadata> docsPassed = (List<ImagingServiceProxy.DocumentMetadata>)arguments[1];
        String objectIdPassed = (String)arguments[2];
        System.assertEquals(doc.documentId, docsPassed[0].documentId);
        System.assertEquals(objectId, objectIdPassed);     
    }

    @IsTest
    static void it_should_retrieve_a_plugin_from_the_plugin_manager_when_cleaning_up_unmatched_docs() {
        String objectId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '001');
        EbtDocManagerMock.ofIPlugin mockPlugin = new EbtDocManagerMock.ofIPlugin();

        sut.cleanupUnmatchedItems(objectId);

        mockPluginMgr.verify('getPluginByObjectId', new List<Object>{objectId}, Times.Once);
    }

    @IsTest
    static void it_should_call_cleanup_on_the_internal_store_when_cleaning_up_unmatched_docs() {
        String objectId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '001');
        EbtDocManagerMock.ofIPlugin mockPlugin = new EbtDocManagerMock.ofIPlugin();
        mockPluginMgr.setup('getPluginByObjectId', new List<Object>{objectId}).returns(mockPlugin);

        sut.cleanupUnmatchedItems(objectId);

        mockInternalStore.verify('cleanupUnmatchedItems', new List<Object>{mockPlugin, objectId}, Times.Once);
    }
}