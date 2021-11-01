@IsTest
private class DataViewerDocumentHandlerTests {
    private static final Mock.ofIHtmlReportingService mockHtmlReportingSvc;
    private static final Mock.ofISalesforceDocumentProvider mockSfDocumentProvider;
    private static final Mock.ofISystem mockSystem;
    private static final Mock.ofIUserInfoService mockUserInfo;
    private static final Mock.ofIEncodingUtil mockEncodingUtil;
    private static DataViewerDocumentHandler sut;
    
    static {
        mockHtmlReportingSvc = new Mock.ofIHtmlReportingService();
        mockSfDocumentProvider = new Mock.ofISalesforceDocumentProvider();
        mockSystem = new Mock.ofISystem();
        mockUserInfo = new Mock.ofIUserInfoService();
        mockEncodingUtil = new Mock.ofIEncodingUtil();
        sut = new DataViewerDocumentHandler(mockHtmlReportingSvc, mockSfDocumentProvider, mockSystem, mockUserInfo, mockEncodingUtil);
    }

    @IsTest
    static void it_should_call_the_reporting_svc_to_get_pdf() {
        Blob templateBytes = new EncodingUtilProvider().toBytes('test');
        Blob doc = new EncodingUtilProvider().toBytes('test');
        String dataAsJson = 'test-json';
        String folderName = 'test-folder';
        String documentName = 'test-document';
        DateTime nowTime = Datetime.newInstance(2021, 2, 17);

        Document testDocument = new Document();
        testDocument.Body = doc;
        mockSfDocumentProvider.setup('getDocument', new List<Object>{folderName, documentName}).returns(testDocument);
        mockSfDocumentProvider.setup('saveDocument', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(testDocument);
        mockSystem.setup('now').returns(nowTime);

        String result = sut.getPdfDocument(templateBytes, dataAsJson, folderName, documentName);

        mockHtmlReportingSvc.verify('getPdf', new List<Object>{templateBytes, dataAsJson}, Times.Once);
    }

    @IsTest
    static void it_should_get_pdf_document_id_when_pdf_is_provided_as_base64() {
        String base64pdf = 'pdf-as-base-64';
        String folderName = 'myfolder';
        String documentName = 'mydocument';
        Blob pdfBytes = Blob.valueOf('my-pdf-bytes');
        String savedDocId = ObjectFactory.getFakeId(Document.SObjectType, '1');
        Document pdfDoc = new Document();
        Document newPdfDoc = new Document(Id=savedDocId);

        mockEncodingUtil.setup('fromBase64', new List<OBject>{base64Pdf}).returns(pdfBytes);
        mockSfDocumentProvider.setup('getDocument', new List<Object>{folderName,documentName}).returns(pdfDoc);
        mockSfDocumentProvider.setup('saveDocument', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(newPdfDoc);

        string result = sut.getPdfDocument(base64Pdf, folderName, documentName);

        mockSfDocumentProvider.verify('saveDocument', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
        List<Object> arguments = mockSfDocumentProvider.getArgumentsFromCall('saveDocument');
        String resultFolderName = (string)arguments[0];
        Document resultNewDocument = (Document)arguments[1];

        System.assertEquals(resultFolderName, folderName);
        System.assertEquals(null, resultNewDocument.Id);
        System.assertEquals(savedDocId, result);
    }

    @IsTest
    static void it_should_user_info_service_to_provide_document_name() {
        String documentNamePrefix = 'DocPrefix';
        String userId = ObjectFactory.getFakeId(User.SobjectType, '1');
        mockUserInfo.setup('getCurrentUserId').returns(userId);

        String result = sut.getDocumentName(documentNamePrefix);

        System.assertEquals(documentNamePrefix + '-' + userId, result);
    }
}