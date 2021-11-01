@IsTest
private class DocumentCacheTests {
    private static final Mock.ofISalesforceDocumentProvider mockSfDocumentProvider;
    private static final MockDocumentDmBuilder mockDocumentDmBuilder;
    private static DocumentCache sut;

    private static final String DOCUMENT_CACHE_FOLDER = 'DocumentCache';

    static {
        mockSfDocumentProvider = new Mock.ofISalesforceDocumentProvider();
        mockDocumentDmBuilder = new MockDocumentDmBuilder();
        sut = new DocumentCache(mockSfDocumentProvider, mockDocumentDmBuilder);
    }
    
    @IsTest
    static void it_should_call_the_sf_data_provider_to_get_document() {    
        String documentId = '1234';
        
        sut.getDocument(documentId);
        
        mockSfDocumentProvider.verify('getDocument', new List<Object>{DOCUMENT_CACHE_FOLDER, documentId}, Times.Once);
    }
    
    @IsTest
    static void it_should_call_the_dm_builder_to_get_document() {
        String documentId = '1234';
        Document doc = new Document();
        doc.Name = 'testDocument';
        mockSfDocumentProvider.setup('getDocument', new List<Object>{DOCUMENT_CACHE_FOLDER, documentId}).Returns(doc);
      
        sut.getDocument(documentId);
              
        mockDocumentDmBuilder.verify('build', new List<Object>{doc}, Times.Once);
    }

    @IsTest
    static void it_should_call_the_dm_builder_to_build_dm_from_provided_pm_to_get_document() {
        String documentId = '1234';
        Document doc = new Document();
        doc.Name = 'testDocument';
        DmDocument dm = new DmDocument();
        dm.Name = doc.Name;
        mockSfDocumentProvider.setup('getDocument', new List<Object>{DOCUMENT_CACHE_FOLDER, documentId}).Returns(doc);
        mockDocumentDmBuilder.setup('build', new List<Object>{doc}).Returns(dm);
      
        DmDocument result =  sut.getDocument(documentId);

        System.assertEquals(doc.Name, result.Name);     
    }

    @IsTest
    static void it_should_call_the_sf_data_provider_to_save_document() {
        DmDocument dmDocument = new DmDocument();
        dmDocument.Name = 'testDm';
        Document pmDocument = new Document();
        
        mockDocumentDmBuilder.setup('build', new List<Object>{dmDocument}).Returns(pmDocument);
        mockDocumentDmBuilder.setup('build', new List<Object>{pmDocument}).Returns(dmDocument);

        sut.saveDocument(dmDocument);

        mockSfDocumentProvider.verify('saveDocument' , new List<Object>{DOCUMENT_CACHE_FOLDER,  pmDocument}, Times.Once);
    }

    @IsTest
    static void it_should_receive_a_dm_document_when_save_is_called() {
        DmDocument dmDocument = new DmDocument();
        dmDocument.Name = 'testDm';
        Document pmDocument = new Document();
        pmDocument.Name = 'pm test doc';
        
        mockDocumentDmBuilder.setup('build', new List<Object>{dmDocument}).Returns(pmDocument);
        mockDocumentDmBuilder.setup('build', new List<Object>{pmDocument}).Returns(dmDocument);
        mockSfDocumentProvider.setup('saveDocument' ,ApexMoq.Arguments.HAVE_ANY_VALUE).Returns(pmDocument);

        DmDocument result = sut.saveDocument(dmDocument);

        System.assertEquals(dmDocument.Name, result.Name);
    }
    
    //private class MockSalesforceDocumentProvider extends ApexMoq implements Documents.ISalesforceDocumentProvider{
    //    public Document getDocument(String folderName, String documentName){
    //        return (Document) handleMethodInvocation('getDocument', new List<Object>{folderName, documentName});
    //    }

    //    public List<Document> getDocuments(List<String> documentIds) {
    //        return (List<Document>) handleMethodInvocation('getDocuments', new List<Object>{documentIds});
    //    }

    //    public Document saveDocument(String folderName, Document document){
    //        return (Document) handleMethodInvocation('saveDocument', new List<Object> {folderName, document});
    //    }
    //}

    private class MockDocumentDmBuilder extends ApexMoq implements Documents.IDocumentDmBuilder {
        public Document build(DmDocument dmDocument){
            return (Document)handleMethodInvocation('build', new List<Object>{dmDocument});
        }

        public DmDocument build(Document pmDocument){
            return (DmDocument)handleMethodInvocation('build', new List<Object>{pmDocument});
        }
    }
}