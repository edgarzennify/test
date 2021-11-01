@IsTest
private class DocumentProviderTests {
    private static final Mock.ofIImagingServiceProxy mockProxy;
    private static final MockDocumentCache mockCache;
    private static final Mock.ofIUtility mockUtil;
    private static final Mock.ofISystem mockSystemDate;
    private static DocumentProvider sut;
    
    static {
        mockProxy = new Mock.ofIImagingServiceProxy();
        mockCache = new MockDocumentCache();
        mockUtil = new Mock.ofIUtility();
        mockSystemDate = new Mock.ofISystem();
        sut = new DocumentProvider(mockProxy ,mockCache, mockUtil, mockSystemDate);
    }
    
    @IsTest
    static void it_should_call_cache() {
        Documents.DocumentGetRequest request = new Documents.DocumentGetRequest();
        request.externalDocumentId = '123';
        List<String> pages = new List<String>{'1', '2'};
        Blob b = EncodingUtil.base64Decode('test');
        mockProxy.setup('retrieveDocument', new List<Object>{request.externalDocumentId}).Returns(pages);
        mockUtil.setup('getBase64', new List<Object>{pages[0]}).Returns(b);
        
        sut.getDocument(request);

        mockCache.verify('getDocument', new List<Object>{request.externalDocumentId}, Times.Once);
    } 
    

    @IsTest
    static void it_should_create_document_by_using_imaging_proxy_when_document_received_from_cache_is_null() {
        Documents.DocumentGetRequest request = new Documents.DocumentGetRequest();
        request.externalDocumentId = '123';
        List<String> pages = new List<String>{'1', '2'};
        Blob b = EncodingUtil.base64Decode('test');
        mockProxy.setup('retrieveDocument', new List<Object>{request.externalDocumentId}).Returns(pages);
        mockUtil.setup('getBase64', new List<Object>{pages[0]}).Returns(b);
        
        sut.getDocument(request);
        
        mockProxy.verify('retrieveDocument', new List<Object>{request.externalDocumentId}, Times.Once);
    }

    @IsTest
    static void it_should_refresh_document_cache_delivers_not_null_document_and_proxy_receives_same_document() {
        Documents.DocumentGetRequest request = new Documents.DocumentGetRequest();
        request.externalDocumentId = '123';
        request.maxAgeMinutes = 1440;
        List<String> pages = new List<String>{'1', '2'};
        Blob b = EncodingUtil.base64Decode('test');
        DmDocument dm = new DmDocument();
        dm.Name = request.externalDocumentId;
        dm.id = '123';
        dm.LastModifiedDate = DateTime.newInstance(2000, 1, 2, 1, 0, 0);
        DateTime expiryDate = dm.LastModifiedDate.addMinutes(request.maxAgeMinutes);
        mockSystemDate.setup('now').returns(expiryDate + 2);
        mockProxy.setup('retrieveDocument', new List<Object>{request.externalDocumentId}).Returns(pages);
        mockUtil.setup('getBase64', new List<Object>{pages[0]}).Returns(b);
        mockCache.setup('getDocument' , new List<Object>{request.externalDocumentId}).returns(dm);
        
        sut.getDocument(request);
        
        mockProxy.verify('retrieveDocument', new List<Object>{dm.Name}, Times.Once);
    }

    @IsTest
    static void it_should_get_a_document_back_when_get_document_is_called() {
        Documents.DocumentGetRequest request = new Documents.DocumentGetRequest();
        request.externalDocumentId = '123';
        request.maxAgeMinutes = 1440;
        List<String> pages = new List<String>{'1', '2'};
        Blob b = EncodingUtil.base64Decode('test');
        DmDocument dm = new DmDocument();
        dm.Name = request.externalDocumentId;
        dm.id = '123';
        dm.LastModifiedDate = DateTime.newInstance(2000, 1, 2, 1, 0, 0);
        DateTime expiryDate = dm.LastModifiedDate.addMinutes(request.maxAgeMinutes);
        mockSystemDate.setup('now').returns(expiryDate + 2);
        mockProxy.setup('retrieveDocument', new List<Object>{request.externalDocumentId}).Returns(pages);
        mockUtil.setup('getBase64', new List<Object>{pages[0]}).Returns(b);
        mockCache.setup('getDocument' , new List<Object>{request.externalDocumentId}).returns(dm);
        mockCache.setup('saveDocument', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(dm);
        
        DmDocument result = sut.getDocument(request);

        System.assertEquals(dm, result);
    }

    private class MockDocumentCache extends ApexMoq implements Documents.IDocumentCache {
        public DmDocument getDocument(String documentName){
            return (DmDocument)handleMethodInvocation('getDocument', new List<Object>{documentName});
        }
        public DmDocument saveDocument(DmDocument document){
            return (DmDocument)handleMethodInvocation('saveDocument', new List<Object>{document});
        }
    }
}