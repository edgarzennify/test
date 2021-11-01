@IsTest
private class ExternalDocumentViewerImgDocHandlerTests {
	private static final mockOfIDocumentRequestBuilder mockRequestBuilder;
    private static final mockOfIDocumentProvider mockDocumentProvider;
    private static ExternalDocumentViewerImgDocHandler sut;
    
    static{
        mockRequestBuilder = new mockOfIDocumentRequestBuilder();
        mockDocumentProvider = new mockOfIDocumentProvider();
        sut = new ExternalDocumentViewerImgDocHandler(mockRequestBuilder,mockDocumentProvider);
    }
    
    @IsTest
    static void it_should_get_handler_identifier() {
        String result = sut.handle();

        System.assertEquals('name', result);
    }

    @IsTest
    static void it_should_cal_the_doc_provider_to_get_document() {
        String docName = 'TM-01';
        Documents.DocumentGetRequest request = new Documents.DocumentGetRequest();
        Map<String, String> parameters = new Map<String, String>{'name' => docName};
        mockRequestBuilder.setup('buildDocumentGetRequest', new List<Object>{docName}).returns(request);

        DmDocument result = sut.buildDocument(parameters);

        mockDocumentProvider.verify('getDocument', new List<Object>{request}, Times.Once);
    }
    
    private class mockOfIDocumentRequestBuilder extends ApexMoq implements Documents.IDocumentRequestBuilder {
        public Documents.DocumentGetRequest buildDocumentGetRequest(String uniqueName){
            return (Documents.DocumentGetRequest)handleMethodInvocation('buildDocumentGetRequest', new List<Object>{uniqueName});
        }
    }
    
    private class mockOfIDocumentProvider extends ApexMoq implements Documents.IDocumentProvider {
        public DmDocument getDocument(Documents.DocumentGetRequest request){
            return (DmDocument)handleMethodInvocation('getDocument', new List<Object>{request});
        }
    }
}