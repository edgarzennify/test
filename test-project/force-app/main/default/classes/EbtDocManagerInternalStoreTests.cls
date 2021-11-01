@IsTest
private class EbtDocManagerInternalStoreTests {
	private final static EbtDocManagerInternalStore sut;
    private final static EbtDocManagerMock.ofIStoreBuilder mockStoreBuilder;
    private final static EbtDocManagerMock.ofIDataProvider mockDataProvider;
    
    static {
        mockStoreBuilder = new EbtDocManagerMock.ofIStoreBuilder();
        mockDataProvider = new EbtDocManagerMock.ofIDataProvider();
        sut = new EbtDocManagerInternalStore(mockStoreBuilder, mockDataProvider);
    }

    @IsTest
    static void it_should_get_the_unmatched_docs_from_the_plugin_when_cleaning_up_unmatched(){
        EbtDocManagerMock.ofIPlugin plugin = new EbtDocManagerMock.ofIPlugin();
        Id objectId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');

        sut.cleanupUnmatchedItems(plugin, objectId);

        plugin.verify('getUnmatchedItems', new List<Object>{objectId}, Times.Once);
    }

    @IsTest
    static void it_should_send_the_unmatched_docs_back_to_the_plugin_for_update_when_cleaning_up_unmatched(){
        EbtDocManagerMock.ofIPlugin plugin = new EbtDocManagerMock.ofIPlugin();
        Id objectId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        Id doc1Id = ObjectFactory.getFakeId(LLC_BI__LLC_LoanDocument__c.SObjectType, '1');
        Id doc2Id = ObjectFactory.getFakeId(LLC_BI__LLC_LoanDocument__c.SObjectType, '2');
        LLC_BI__LLC_LoanDocument__c doc1 = new LLC_BI__LLC_LoanDocument__c(Id=doc1Id);
        LLC_BI__LLC_LoanDocument__c doc2 = new LLC_BI__LLC_LoanDocument__c(Id=doc2Id);
        List<SObject> docs = new List<SObject>{ doc1, doc2 };
        plugin.setup('getUnmatchedItems', new List<Object>{objectId}).returns(docs);

        sut.cleanupUnmatchedItems(plugin, objectId);

        plugin.verify('fixUnmatchedItem', new List<Object>{doc1}, Times.Once);
        plugin.verify('fixUnmatchedItem', new List<Object>{doc2}, Times.Once);
    }

    @IsTest
    static void it_should_save_the_updated_docs_when_cleaning_up_unmatched(){
        EbtDocManagerMock.ofIPlugin plugin = new EbtDocManagerMock.ofIPlugin();
        Id objectId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        Id doc1Id = ObjectFactory.getFakeId(LLC_BI__LLC_LoanDocument__c.SObjectType, '1');
        Id doc2Id = ObjectFactory.getFakeId(LLC_BI__LLC_LoanDocument__c.SObjectType, '2');
        LLC_BI__LLC_LoanDocument__c doc1 = new LLC_BI__LLC_LoanDocument__c(Id=doc1Id);
        LLC_BI__LLC_LoanDocument__c doc2 = new LLC_BI__LLC_LoanDocument__c(Id=doc2Id);
        List<SObject> docs = new List<SObject>{ doc1, doc2 };
        plugin.setup('getUnmatchedItems', new List<Object>{objectId}).returns(docs);

        sut.cleanupUnmatchedItems(plugin, objectId);

        mockDataProvider.verify('save', new List<Object>{docs}, Times.Once);
    }
    
    @IsTest
    static void it_should_get_the_store_indexes_from_the_given_plugin(){
        EbtDocManagerMock.ofIPlugin plugin = new EbtDocManagerMock.ofIPlugin();
        Id objectId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        plugin.setup('getDocumentManagerStoreIndexes', new List<Object>{objectId}).returns(new List<LLC_BI__Document_Store_Index__c>());

        sut.getExternalIdentifiers(plugin, objectId);

        plugin.verify('getDocumentManagerStoreIndexes', new List<Object>{objectId}, Times.Once);
    }
    
    @IsTest
    static void it_should_return_a_set_with_the_store_indexes_returned(){
        EbtDocManagerMock.ofIPlugin plugin = new EbtDocManagerMock.ofIPlugin();
        Id objectId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        LLC_BI__Document_Store__c store = new LLC_BI__Document_Store__c();
        store.LLC_BI__External_Identifier__c = 'abc123';
        LLC_BI__Document_Store_Index__c storeIndex = new LLC_BI__Document_Store_Index__c();
        storeIndex.LLC_BI__Document_Store__r = store;
        List<LLC_BI__Document_Store_Index__c> storeIndexes = new List<LLC_BI__Document_Store_Index__c>{ storeIndex };
        plugin.setup('getDocumentManagerStoreIndexes', new List<Object>{objectId}).returns(storeIndexes);

        Set<String> result = sut.getExternalIdentifiers(plugin, objectId);

        System.assertEquals(1, result.size());
        System.assert(result.contains('abc123'));
    }
    
    @IsTest
    static void it_should_get_the_built_stores_from_the_store_builder(){
        EbtDocManagerMock.ofIPlugin plugin = new EbtDocManagerMock.ofIPlugin();
        Id objectId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        List<ImagingServiceProxy.DocumentMetadata> externalDocs = new List<ImagingServiceProxy.DocumentMetadata>();
        mockStoreBuilder.setup('buildDocumentManagerDocuments', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(new List<SObject>());

        sut.createDocumentsFromExternalDocuments(plugin, externalDocs, objectId);

        mockStoreBuilder.verify('buildDocumentManagerStores', new List<Object>{externalDocs}, Times.Once);
    }
    
    @IsTest
    static void it_should_save_the_built_stores(){
        EbtDocManagerMock.ofIPlugin plugin = new EbtDocManagerMock.ofIPlugin();
        Id objectId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        List<ImagingServiceProxy.DocumentMetadata> externalDocs = new List<ImagingServiceProxy.DocumentMetadata>();
        List<LLC_BI__Document_Store__c> stores = new List<LLC_BI__Document_Store__c>{ new LLC_BI__Document_Store__c() };
		mockStoreBuilder.setup('buildDocumentManagerStores', new List<Object>{externalDocs}).returns(stores);
        mockStoreBuilder.setup('buildDocumentManagerDocuments', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(new List<SObject>());
        
        sut.createDocumentsFromExternalDocuments(plugin, externalDocs, objectId);

        mockDataProvider.verify('save', new List<Object>{stores}, Times.Once);
    }
    
    @IsTest
    static void it_should_get_the_built_store_indexes_from_the_store_builder_with_the_returned_stores(){
        EbtDocManagerMock.ofIPlugin plugin = new EbtDocManagerMock.ofIPlugin();
        Id objectId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        List<ImagingServiceProxy.DocumentMetadata> externalDocs = new List<ImagingServiceProxy.DocumentMetadata>();
        List<LLC_BI__Document_Store__c> stores = new List<LLC_BI__Document_Store__c>();
		mockStoreBuilder.setup('buildDocumentManagerStores', new List<Object>{externalDocs}).returns(stores);
        mockStoreBuilder.setup('buildDocumentManagerDocuments', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(new List<SObject>());
        
        sut.createDocumentsFromExternalDocuments(plugin, externalDocs, objectId);

        mockStoreBuilder.verify('buildDocumentManagerStoreIndexes', new List<Object>{stores}, Times.Once);
    }
    
    @IsTest
    static void it_should_save_the_built_store_indexes(){
        EbtDocManagerMock.ofIPlugin plugin = new EbtDocManagerMock.ofIPlugin();
        Id objectId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        List<ImagingServiceProxy.DocumentMetadata> externalDocs = new List<ImagingServiceProxy.DocumentMetadata>();
        List<LLC_BI__Document_Store__c> stores = new List<LLC_BI__Document_Store__c>();
        List<LLC_BI__Document_Store_Index__c> storeIndexes = new List<LLC_BI__Document_Store_Index__c>{ new LLC_BI__Document_Store_Index__c() };
        mockStoreBuilder.setup('buildDocumentManagerStores', new List<Object>{externalDocs}).returns(stores);
        mockDataProvider.setup('save', new List<Object>{stores}).returns(storeIndexes);
		mockStoreBuilder.setup('buildDocumentManagerStoreIndexes', new List<Object>{externalDocs}).returns(storeIndexes);
        mockStoreBuilder.setup('buildDocumentManagerDocuments', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(new List<SObject>());
        
        sut.createDocumentsFromExternalDocuments(plugin, externalDocs, objectId);

        mockDataProvider.verify('save', new List<Object>{storeIndexes}, Times.Once);
    }
    
    @IsTest
    static void it_should_get_the_built_documents(){
        EbtDocManagerMock.ofIPlugin plugin = new EbtDocManagerMock.ofIPlugin();
        Id objectId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        List<ImagingServiceProxy.DocumentMetadata> externalDocs = new List<ImagingServiceProxy.DocumentMetadata>();
        mockStoreBuilder.setup('buildDocumentManagerDocuments', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(new List<SObject>());
        
        sut.createDocumentsFromExternalDocuments(plugin, externalDocs, objectId);

        mockStoreBuilder.verify('buildDocumentManagerDocuments', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
    }
    
    @IsTest
    static void it_should_save_the_built_documents(){
        EbtDocManagerMock.ofIPlugin plugin = new EbtDocManagerMock.ofIPlugin();
        Id objectId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        List<ImagingServiceProxy.DocumentMetadata> externalDocs = new List<ImagingServiceProxy.DocumentMetadata>();
        List<SObject> docs = (List<SObject>) new List<LLC_BI__LLC_LoanDocument__c>{ new LLC_BI__LLC_LoanDocument__c() };
        mockStoreBuilder.setup('buildDocumentManagerStoreIndexes', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(new List<LLC_BI__Document_Store_Index__c>{ new LLC_BI__Document_Store_Index__c() });
        mockStoreBuilder.setup('buildDocumentManagerDocuments', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(docs);
        
        sut.createDocumentsFromExternalDocuments(plugin, externalDocs, objectId);

        mockDataProvider.verify('save', new List<Object>{docs}, Times.AtLeastOnce);
    }
    
    @IsTest
    static void it_should_update_the_built_documents_using_the_given_plugin(){
        EbtDocManagerMock.ofIPlugin plugin = new EbtDocManagerMock.ofIPlugin();
        Id objectId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        List<ImagingServiceProxy.DocumentMetadata> externalDocs = new List<ImagingServiceProxy.DocumentMetadata>();
        LLC_BI__Document_Store_Index__c storeIndex = new LLC_BI__Document_Store_Index__c();
        List<LLC_BI__Document_Store_Index__c> indexes = new List<LLC_BI__Document_Store_Index__c>{ storeIndex };
        LLC_BI__LLC_LoanDocument__c doc = new LLC_BI__LLC_LoanDocument__c();
        List<SObject> docs = new List<SObject>{ doc };
        mockStoreBuilder.setup('buildDocumentManagerStoreIndexes', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(indexes);
        mockStoreBuilder.setup('buildDocumentManagerDocuments', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(docs);
        
        sut.createDocumentsFromExternalDocuments(plugin, externalDocs, objectId);

        plugin.verify('updateDocumentManagerDocument', new List<Object>{doc, storeIndex}, Times.Once);
    }
    
    @IsTest
    static void it_should_save_the_updated_documents(){
        EbtDocManagerMock.ofIPlugin plugin = new EbtDocManagerMock.ofIPlugin();
        Id objectId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        List<ImagingServiceProxy.DocumentMetadata> externalDocs = new List<ImagingServiceProxy.DocumentMetadata>();
        LLC_BI__Document_Store_Index__c storeIndex = new LLC_BI__Document_Store_Index__c();
        List<LLC_BI__Document_Store_Index__c> indexes = new List<LLC_BI__Document_Store_Index__c>{ storeIndex };
        LLC_BI__LLC_LoanDocument__c doc = new LLC_BI__LLC_LoanDocument__c();
        List<SObject> docs = new List<SObject>{ doc };
        mockStoreBuilder.setup('buildDocumentManagerStoreIndexes', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(indexes);
        mockStoreBuilder.setup('buildDocumentManagerDocuments', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(docs);
        
        sut.createDocumentsFromExternalDocuments(plugin, externalDocs, objectId);

        mockDataProvider.verify('save', new List<Object>{docs}, Times.Twice);
    }
}