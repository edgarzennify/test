@IsTest
private class ExternalDocumentViewerPresenterTests {

    private static final ExternalDocumentViewerMock.ofIRequestHandler mockRequestHandler;
    private static final ExternalDocumentViewerPresenter sut;

    static {
        mockRequestHandler = new ExternalDocumentViewerMock.ofIRequestHandler();
        List<ExternalDocumentViewer.IRequestHandler> handlers = new List<ExternalDocumentViewer.IRequestHandler>{mockRequestHandler};
        sut = new ExternalDocumentViewerPresenter(handlers);
    }

    @IsTest
    static void it_should_get_document() {
        mockRequestHandler.setup('handle').returns('rptid');
        Map<String, String> parameters = new Map<String, String>{'rptid'=>'test'};

        DmDocument result = sut.getDocument(parameters);

        mockRequestHandler.verify('buildDocument', new List<Object>{parameters}, Times.Once);
    }

    @IsTest
    static void it_should_return_empty_document_if_no_handler_is_present() {
        mockRequestHandler.setup('handle').returns('id');
        Map<String, String> parameters = new Map<String, String>{'rptid'=>'test'};

        DmDocument result = sut.getDocument(parameters);

        System.assertEquals(null, result);
    }
}