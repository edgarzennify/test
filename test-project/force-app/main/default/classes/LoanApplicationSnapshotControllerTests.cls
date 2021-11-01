@IsTest
private class LoanApplicationSnapshotControllerTests {
    private final static Mock.ofIApexPages mockApexPages = new Mock.ofIApexPages();
    private final static Mock.ofIRestService mockRestService = new Mock.ofIRestService();
    private static LoanApplicationSnapshotController sut;
    
    static {
        RESTUtility.result testResult = new RESTUtility.result();
        testResult.response = 'received';
        mockRestService.setup('POST', ApexMoq.Arguments.HAVE_ANY_VALUE).Returns(testResult);
        sut = new LoanApplicationSnapshotController(mockApexPages,mockRestService);
    }

    @IsTest
    static void it_should_call_the_rest_service_to_post_minute_snapshot_request() {
        mockApexPages.setup('getParameter', new List<Object>{'type'}).Returns('minute');
        mockApexPages.setup('getParameter', new List<Object>{'minuteId'}).Returns('0001');
        mockApexPages.setup('getParameter', new List<Object>{'loanAppId'}).Returns('');
        
        sut.GenerateSnapShot();
        
        mockApexPages.verify('getParameter', new List<Object>{'type'}, Times.Once);
        mockApexPages.verify('getParameter', new List<Object>{'minuteId'}, Times.Once);
        mockRestService.verify('POST', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
    }
    
    @IsTest
    static void it_should_call_the_rest_service_to_post_archive_snapshot_request() {
        mockApexPages.setup('getParameter', new List<Object>{'type'}).Returns('archive');
        mockApexPages.setup('getParameter', new List<Object>{'minuteId'}).Returns('0001');
        mockApexPages.setup('getParameter', new List<Object>{'loanAppId'}).Returns('0001');
        
        sut.GenerateSnapShot();
        
        mockApexPages.verify('getParameter', new List<Object>{'type'}, Times.Once);
        mockApexPages.verify('getParameter', new List<Object>{'minuteId'}, Times.Once);
        mockApexPages.verify('getParameter', new List<Object>{'loanAppId'}, Times.Once);
        mockRestService.verify('POST', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
    }
    
    @IsTest
    static void code_coverage() {
        sut = new LoanApplicationSnapshotController();
    }
}