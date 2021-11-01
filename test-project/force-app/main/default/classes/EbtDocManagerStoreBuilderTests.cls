@IsTest
private class EbtDocManagerStoreBuilderTests {
    
    private final static EbtDocManagerStoreBuilder sut;
    private final static Mock.ofIConfigurations mockConfigs;
    private final static EbtDocManagerMock.ofIStoreBuilderHelper mockHelper;
    
    static{
        mockConfigs = new Mock.ofIConfigurations();
        mockHelper = new EbtDocManagerMock.ofIStoreBuilderHelper();
        sut = new EbtDocManagerStoreBuilder(mockConfigs, mockHelper);
    }
    
    @IsTest
    static void it_should_build_the_correct_stores(){
        String docStoreName = 'ebt-doc-store';
        ImagingServiceProxy.DocumentMetadata doc1 = new ImagingServiceProxy.DocumentMetadata();
        ImagingServiceProxy.DocumentMetadata doc2 = new ImagingServiceProxy.DocumentMetadata();
        List<ImagingServiceProxy.DocumentMetadata> docs = new List<ImagingServiceProxy.DocumentMetadata> { doc1, doc2 };
        mockConfigs.setup('get', new List<Object>{'EbtDocManagerStoreName'}).returns(docStoreName);
        
        List<LLC_BI__Document_Store__c> result = sut.buildDocumentManagerStores(docs);
        
        System.assertEquals(2, result.size());
        System.assertEquals(doc1.documentId, result[0].LLC_BI__External_Identifier__c);
        System.assertEquals(docStoreName, result[0].LLC_BI__Type__c);
        System.assertEquals(doc2.documentId, result[1].LLC_BI__External_Identifier__c);
        System.assertEquals(docStoreName, result[1].LLC_BI__Type__c);
    }
    
    @IsTest
    static void it_should_build_the_correct_store_indexes(){
        Id store1Id = ObjectFactory.getFakeId(LLC_BI__Document_Store__c.SObjectType,'1');
        Id store2Id = ObjectFactory.getFakeId(LLC_BI__Document_Store__c.SObjectType,'2');
        LLC_BI__Document_Store__c store1 = new LLC_BI__Document_Store__c(Id = store1Id);
        LLC_BI__Document_Store__c store2 = new LLC_BI__Document_Store__c(Id = store2Id);
        List<LLC_BI__Document_Store__c> stores = new List<LLC_BI__Document_Store__c> { store1, store2 };
        
        List<LLC_BI__Document_Store_Index__c> result = sut.buildDocumentManagerStoreIndexes(stores);
        
        System.assertEquals(2, result.size());
        System.assertEquals(store1Id, result[0].LLC_BI__Document_Store__c);
        System.assertEquals(store2Id, result[1].LLC_BI__Document_Store__c);
    }

    @IsTest
    static void it_should_call_the_plugin_for_each_external_doc_received(){
        EbtDocManagerMock.ofIPlugin plugin = new EbtDocManagerMock.ofIPlugin();
        ImagingServiceProxy.DocumentMetadata xdoc1 = new ImagingServiceProxy.DocumentMetadata();
        xdoc1.documentId = '11111';
        ImagingServiceProxy.DocumentMetadata xdoc2 = new ImagingServiceProxy.DocumentMetadata();
        xdoc2.documentId = '22222';
        List<ImagingServiceProxy.DocumentMetadata> externalDocs = new List<ImagingServiceProxy.DocumentMetadata> { xdoc1, xdoc2 };
        Id objectId = ObjectFactory.getFakeId(Account.SObjectType, '1');

        sut.buildDocumentManagerDocuments(plugin, externalDocs, objectId);

        plugin.verify('buildDocumentManagerDocument', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Twice);
    }

    @IsTest
    static void it_should_return_a_list_with_the_docs_created_by_the_plugin(){
        EbtDocManagerMock.ofIPlugin plugin = new EbtDocManagerMock.ofIPlugin();
        ImagingServiceProxy.DocumentMetadata xdoc1 = new ImagingServiceProxy.DocumentMetadata();
        xdoc1.documentId = '11111';
        List<ImagingServiceProxy.DocumentMetadata> externalDocs = new List<ImagingServiceProxy.DocumentMetadata> { xdoc1 };
        Id objectId = ObjectFactory.getFakeId(Account.SObjectType, '1');
        LLC_BI__LLC_LoanDocument__c doc1 = new LLC_BI__LLC_LoanDocument__c();
        doc1.LLC_BI__mimeType__c = 'abc';
        plugin.setup('buildDocumentManagerDocument', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(doc1);

        List<SObject> result = sut.buildDocumentManagerDocuments(plugin, externalDocs, objectId);

        System.assertEquals(1, result.size());
        LLC_BI__LLC_LoanDocument__c r1 = (LLC_BI__LLC_LoanDocument__c)result[0];
        System.assertEquals(doc1.LLC_BI__mimeType__c, r1.LLC_BI__mimeType__c);
    }

    @IsTest
    static void it_should_update_the_document_when_is_staged_is_false_and_doc_class_is_found(){
        EbtDocManagerMock.ofIPlugin plugin = new EbtDocManagerMock.ofIPlugin();
        ImagingServiceProxy.DocumentMetadata xdoc1 = new ImagingServiceProxy.DocumentMetadata();
        xdoc1.documentId = '11111';
        xdoc1.docTypeName = 'test-doc-type-name';
        xdoc1.isStaged = false;
        List<ImagingServiceProxy.DocumentMetadata> externalDocs = new List<ImagingServiceProxy.DocumentMetadata> { xdoc1 };
        Id objectId = ObjectFactory.getFakeId(Account.SObjectType, '1');
        String docManName = 'test-doc-man';
        LLC_BI__LLC_LoanDocument__c doc1 = new LLC_BI__LLC_LoanDocument__c();
        doc1.LLC_BI__mimeType__c = 'abc';
        Id docClassId = ObjectFactory.getFakeId(LLC_BI__DocClass__c.SObjectType, '1');
        LLC_BI__DocClass__c docClass = new LLC_BI__DocClass__c(Id=docClassId);
        EbtDocManager.InternalDocumentBuildRequest buildRequest = new EbtDocManager.InternalDocumentBuildRequest();
        plugin.setup('getDocumentManagerName').returns(docManName);
        mockHelper.setup('createInternalDocumentBuildRequest', new List<Object>{xdoc1, docManName, objectId}).returns(buildRequest);
        plugin.setup('buildDocumentManagerDocument', new List<Object>{buildRequest}).returns(doc1);
        mockHelper.setup('getDocumentManagerClass', new List<Object>{docManName, xdoc1.docTypeName}).returns(docClass);

        List<SObject> result = sut.buildDocumentManagerDocuments(plugin, externalDocs, objectId);

        plugin.verify('updateDocumentManagerDocument', new List<Object>{doc1, docClass}, Times.Once);
    }

    @IsTest
    static void it_should_not_update_the_document_when_is_staged_is_true_and_doc_class_is_found(){
        EbtDocManagerMock.ofIPlugin plugin = new EbtDocManagerMock.ofIPlugin();
        ImagingServiceProxy.DocumentMetadata xdoc1 = new ImagingServiceProxy.DocumentMetadata();
        xdoc1.documentId = '11111';
        xdoc1.docTypeName = 'test-doc-type-name';
        xdoc1.isStaged = true;
        List<ImagingServiceProxy.DocumentMetadata> externalDocs = new List<ImagingServiceProxy.DocumentMetadata> { xdoc1 };
        Id objectId = ObjectFactory.getFakeId(Account.SObjectType, '1');
        String docManName = 'test-doc-man';
        LLC_BI__LLC_LoanDocument__c doc1 = new LLC_BI__LLC_LoanDocument__c();
        doc1.LLC_BI__mimeType__c = 'abc';
        Id docClassId = ObjectFactory.getFakeId(LLC_BI__DocClass__c.SObjectType, '1');
        LLC_BI__DocClass__c docClass = new LLC_BI__DocClass__c(Id=docClassId);
        EbtDocManager.InternalDocumentBuildRequest buildRequest = new EbtDocManager.InternalDocumentBuildRequest();
        plugin.setup('getDocumentManagerName').returns(docManName);
        mockHelper.setup('createInternalDocumentBuildRequest', new List<Object>{xdoc1, docManName, objectId}).returns(buildRequest);
        plugin.setup('buildDocumentManagerDocument', new List<Object>{buildRequest}).returns(doc1);
        mockHelper.setup('getDocumentManagerClass', new List<Object>{docManName, xdoc1.docTypeName}).returns(docClass);

        List<SObject> result = sut.buildDocumentManagerDocuments(plugin, externalDocs, objectId);

        mockHelper.verify('getDocumentManagerClass', new List<Object>{docManName, xdoc1.docTypeName}, Times.Once);
        plugin.verify('updateDocumentManagerDocument', new List<Object>{doc1, docClass}, Times.Never);
    }

    @IsTest
    static void it_should_not_update_the_document_when_is_staged_is_false_and_doc_class_is_not_found(){
        EbtDocManagerMock.ofIPlugin plugin = new EbtDocManagerMock.ofIPlugin();
        ImagingServiceProxy.DocumentMetadata xdoc1 = new ImagingServiceProxy.DocumentMetadata();
        xdoc1.documentId = '11111';
        xdoc1.docTypeName = 'test-doc-type-name';
        xdoc1.isStaged = false;
        List<ImagingServiceProxy.DocumentMetadata> externalDocs = new List<ImagingServiceProxy.DocumentMetadata> { xdoc1 };
        Id objectId = ObjectFactory.getFakeId(Account.SObjectType, '1');
        String docManName = 'test-doc-man';
        LLC_BI__LLC_LoanDocument__c doc1 = new LLC_BI__LLC_LoanDocument__c();
        doc1.LLC_BI__mimeType__c = 'abc';
        Id docClassId = ObjectFactory.getFakeId(LLC_BI__DocClass__c.SObjectType, '1');
        LLC_BI__DocClass__c docClass = new LLC_BI__DocClass__c(Id=docClassId);
        EbtDocManager.InternalDocumentBuildRequest buildRequest = new EbtDocManager.InternalDocumentBuildRequest();
        plugin.setup('getDocumentManagerName').returns(docManName);
        mockHelper.setup('createInternalDocumentBuildRequest', new List<Object>{xdoc1, docManName, objectId}).returns(buildRequest);
        plugin.setup('buildDocumentManagerDocument', new List<Object>{buildRequest}).returns(doc1);
        mockHelper.setup('getDocumentManagerClass', new List<Object>{docManName, xdoc1.docTypeName}).returns(null);

        List<SObject> result = sut.buildDocumentManagerDocuments(plugin, externalDocs, objectId);

        mockHelper.verify('getDocumentManagerClass', new List<Object>{docManName, xdoc1.docTypeName}, Times.Once);
        plugin.verify('updateDocumentManagerDocument', new List<Object>{doc1, docClass}, Times.Never);
    }
}