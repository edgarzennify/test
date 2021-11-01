@IsTest
global class SalesforceDocumentViewerPresenterTests {
    
    private static final SalesforceDocumentViewerMock.ofIDataProvider mockDataProvider;
    private static final Mock.ofIUtility mockUtility;
    private static final Mock.ofIEncodingUtil mockEncodingUtil;

    private static final SalesforceDocumentViewerPresenter sut;
    
    static{
        mockDataProvider = new SalesforceDocumentViewerMock.ofIDataProvider();
        mockUtility = new Mock.ofIUtility();
        mockEncodingUtil = new Mock.ofIEncodingUtil();
        sut = new SalesforceDocumentViewerPresenter(mockDataProvider, mockUtility, mockEncodingUtil);
    }


   @IsTest
    private static void it_should_call_the_data_provider_to_get_document(){
        Id docId = ObjectFactory.getFakeId(Document.SObjectType, '1');
        Document doc = new Document(Id=docId, Name='test');
        mockDataProvider.setup('getDocument', new List<Object>{docId}).returns(doc);
        mockUtility.setup('getObjectNameFromId', new List<Object>{docId}).returns('document');

        SalesforceDocumentViewer.Report result = sut.getReport(docId);

        System.assertEquals(doc.name+'.pdf', result.fileName);

    }

    @IsTest
    private static void it_should_call_the_data_provider_to_get_content_document(){
        Id docId = ObjectFactory.getFakeId(ContentVersion.SObjectType, '1');
        ContentVersion doc = new ContentVersion(Id=docId, Title='test');
        mockDataProvider.setup('getContentDocument', new List<Object>{docId}).returns(doc);
        mockUtility.setup('getObjectNameFromId', new List<Object>{docId}).returns('contentdocument');

        SalesforceDocumentViewer.Report result = sut.getReport(docId);

        System.assertEquals(doc.Title + '.pdf', result.fileName);

    }

    @IsTest
    private static void it_should_call_the_data_provider_to_get_attachment(){
        Id docId = ObjectFactory.getFakeId(Attachment.SObjectType, '1');
        Attachment doc = new Attachment(Id=docId, Name='test');
        mockDataProvider.setup('getAttachmentDocument', new List<Object>{docId}).returns(doc);
        mockUtility.setup('getObjectNameFromId', new List<Object>{docId}).returns('attachment');

        SalesforceDocumentViewer.Report result = sut.getReport(docId);

        System.assertEquals(doc.name+'.pdf', result.fileName);

    }
}