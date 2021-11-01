@IsTest
private class DataViewerPresenterTests {
    private static final Mock.ofIApexPages mockApexPages;
    private static final Mock.ofIJson mockJson;
    private static final DataViewerMock.ofIDocumentHandler mockDocHandler;
    private static final Mock.ofIEncodingUtil mockEncodingUtil;
    private static final DataViewerMock.ofIHelper mockHelper;
    private static DataViewerPresenter sut;

    static {
        mockApexPages = new Mock.ofIApexPages();
        mockJson = new Mock.ofIJson();
        mockDocHandler = new DataViewerMock.ofIDocumentHandler();
        mockEncodingUtil = new Mock.ofIEncodingUtil();
        mockHelper = new DataViewerMock.ofIHelper();
        sut = new DataViewerPresenter(mockApexPages, mockJson, mockDocHandler, mockEncodingUtil, mockHelper);
    }

    @IsTest
    static void it_should_call_helper_to_get_results_from_data_Provider() {
        Id reportId = ObjectFactory.getFakeId(dvReport__c.SOBjectType, '1');
        String reportName = 'my-report';
        String apexClassName = 'apex-class';
        String contextId = 'cid';
        PM_DvReport reportPm = new PM_DvReport();
        reportPm.Id=reportId;
        reportPm.Name = reportName;
        reportPm.Use_Apex_Class_As_Query = true;
        reportPm.Apex_Class_Name = apexClassName;
        mockApexPages.setup('getParameter', new List<Object>{'rpt'}).returns(reportName);
        mockApexPages.setup('getParameter', new List<Object>{'debug'}).returns('1');
        mockApexPages.setup('getParameter', new List<Object>{'pdf'}).returns('true');
        mockApexPages.setup('getParameter', new List<Object>{'cid'}).returns(contextId);
        mockHelper.setup('getReportByName', new List<Object>{reportName}).returns(reportPm);

        DataViewer.FormVm result = sut.buildFormVm();

        mockHelper.verify('getResultsFromReportDataProvider', new List<Object>{apexClassName, contextId}, Times.Once);
    }
}