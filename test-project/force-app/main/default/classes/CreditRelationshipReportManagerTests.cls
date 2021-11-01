@IsTest
private class CreditRelationshipReportManagerTests {

	private static final CreditRelationshipReportManager sut;
	private static final Mock.ofIConfigurations m_configs;
	private static final Mock.ofHttpCalloutMock m_mockCallout;
	private static String creditRelationshipId = ObjectFactory.getFakeId(Credit_Relationship__c.SObjectType, '1');
	private static String archivedReportId = ObjectFactory.getFakeId(Archived_Report__c.SObjectType, '1');
	private static HttpRequest request;

	static {
		HttpResponse response;
		response = new HttpResponse();
        response.setBody('test');
        response.setStatusCode(200);
        response.setStatus('OK');
        m_mockCallout = new Mock.ofHttpCalloutMock();
        m_mockCallout.Setup('respond',  ApexMoq.Arguments.HAVE_ANY_VALUE).returns(response);
		m_configs = new Mock.ofIConfigurations();	
		sut = new CreditRelationshipReportManager(m_configs);
	}

	@IsTest
    static void it_should_callout_oreo_report_generation_and_verify_that_the_response_was_received() {
		Test.setMock(HttpCalloutMock.class, m_mockCallout);
        archivedReportId = RestUtility.convertid15ToId18(archivedReportId);
        boolean isOreo = true;
        String body = 'reportid='+ EncodingUtil.urlEncode(archivedReportId,'UTF-8');
        String saveReportUrl = 'save-oreo-report';
        m_configs.setup('creditRelationshipOreoSaveReportBaseUrl').returns(saveReportUrl);

        Test.startTest();
        sut.generateReportOutput(archivedReportId, isOreo);
        Test.stopTest();

        m_configs.verify('creditRelationshipOreoSaveReportBaseUrl', Times.Once);
        m_mockCallout.verify('respond',  ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
        List<Object> arguments = (List<Object>)m_mockCallout.getArgumentsFromCall('respond');
        HttpRequest calledRequest = (HttpRequest) arguments[0];
        String url = saveReportUrl + archivedReportId;
        system.assertEquals(url ,calledRequest.getEndpoint());
        system.assertEquals('POST' ,calledRequest.getMethod());
        system.assertEquals(body ,calledRequest.getBody());
	}

	@IsTest
    static void it_should_callout_non_oreo_report_generation_and_verify_that_the_response_was_received() {
        Test.setMock(HttpCalloutMock.class, m_mockCallout);
        archivedReportId = RestUtility.convertid15ToId18(archivedReportId);
        boolean isOreo = false;     
        String body = 'reportid='+ EncodingUtil.urlEncode(archivedReportId,'UTF-8');
        String saveReportUrl = 'save-report';
        m_configs.setup('creditRelationshipSaveReportBaseUrl').returns(saveReportUrl);

 		Test.startTest();
        sut.generateReportOutput(archivedReportId, isOreo);
        Test.stopTest();   

        m_configs.verify('creditRelationshipSaveReportBaseUrl', Times.Once);
        m_mockCallout.verify('respond',  ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
        List<Object> arguments = (List<Object>)m_mockCallout.getArgumentsFromCall('respond');
        HttpRequest calledRequest = (HttpRequest) arguments[0];
        String url = saveReportUrl + archivedReportId;
        system.assertEquals(url ,calledRequest.getEndpoint());
        system.assertEquals('POST' ,calledRequest.getMethod());
        system.assertEquals(body ,calledRequest.getBody());    
	}

	@IsTest
    static void it_should_make_a_callout_when_a_archivedReportId_and_isOreo_is_true() {
		Test.setMock(HttpCalloutMock.class, m_mockCallout);
		Boolean isOreo = true;

		Test.startTest();
		sut.generateReportOutput(archivedReportId, isOreo);
		Test.stopTest();

		m_mockCallout.verify('respond', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
	}

	@IsTest
    static void it_should_make_a_callout_when_a_archivedReportId_and_isOreo_is_false() {
		Test.setMock(HttpCalloutMock.class, m_mockCallout);
		Boolean isOreo = false;

		Test.startTest();
		sut.generateReportOutput(archivedReportId, isOreo);
		Test.stopTest();

		m_mockCallout.verify('respond', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
	}

	@IsTest
    static void it_should_call_the_config_to_get_a_report_id_for_a_non_oreo() {
		Integer reportId = 1234;
		Boolean isOreo = false;
		m_configs.setup('creditRelationshipReportId').returns(reportid);

		Integer result  = sut.getReportIdForUrl(isOreo);

		m_configs.verify('creditRelationshipReportId', Times.Once);
		system.assertEquals(1234,result );
	}

	@IsTest
    static void it_should_call_the_config_to_get_a_report_id_for_an_oreo() {
		Integer reportId = 1234;
		Boolean isOreo = true;
		m_configs.setup('creditRelationshipOreoReportId').returns(reportid);

		Integer result  = sut.getReportIdForUrl(isOreo);

		m_configs.verify('creditRelationshipOreoReportId', Times.Once);
		system.assertEquals(1234,result );
	}

	@IsTest
    static void it_should_get_a_report_name_for_oreo() {
		String OREO_REPORT_NAME = 'Watch Credit OREO Report';
		Boolean isOreo = true;

		String reportName = sut.getArchiveReportName(isOreo);

		system.assertEquals(OREO_REPORT_NAME, reportName);
	}

	@IsTest
    static void it_should_get_a_report_name_for_non_oreo() {
		String REPORT_NAME = 'Watch Credit Report';
		Boolean isOreo = false;

		String reportName = sut.getArchiveReportName(isOreo);

		system.assertEquals(REPORT_NAME, reportName);
	}

	@IsTest
    static void it_should_create_a_sm_for_archived_report_when_a_dm_is_provided() {
		DmArchivedReport dm = new DmArchivedReport();
		dm.name = 'test report name';
		dm.creditRelationship = new DmCreditRelationship();
		dm.creditRelationship.id = creditrelationshipId;

		CreditRelationship.ArchivedReportSm result =  sut.buildArchivedReportSm(dm);

		system.assertEquals(dm.name ,result.name);
		system.assertEquals(dm.creditRelationship.id , result.creditRelationshipId);
	}
}