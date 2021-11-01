@IsTest
private class ExternalDocumentViewerControllerTests {

    private static final Mock.ofIApexPages mockApexPages; 
    private static final ExternalDocumentViewerMock.ofIPresenter mockPresenter;
    private static ExternalDocumentViewerController sut;

    static {
        mockApexPages = new Mock.ofIApexPages();
        mockPresenter = new ExternalDocumentViewerMock.ofIPresenter();
        sut = new ExternalDocumentViewerController( mockApexPages, mockPresenter );
    }

    @IsTest
    static void it_should_call_presenter_to_get_document() {
        Map<string, string> parameters = new Map<string, string>{'id'=>'1'};
        mockApexPages.setup('getParameters').returns(parameters);

        PageReference result = sut.initialize();

        mockPresenter.verify('getDocument', new List<Object>{parameters}, Times.Once);
    }

    @IsTest
    static void it_should_return_document_url() {
        Map<string, string> parameters = new Map<string, string>{'id'=>'1'};
        DmDocument d = new DmDocument();
        d.Id = 'fileid';
        mockApexPages.setup('getParameters').returns(parameters);
        mockPresenter.setup('getDocument', new List<Object>{parameters}).returns(d);

        PageReference result = sut.initialize();

        System.assertEquals('/servlet/servlet.FileDownload?file=fileid', result.getUrl());
    }
}