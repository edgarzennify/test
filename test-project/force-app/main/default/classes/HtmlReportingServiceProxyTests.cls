@IsTest
private class HtmlReportingServiceProxyTests {
	
	private static final String SERVICE_API_NAME = 'HtmlReportingUrl';
	private static final String SERVICE_RESOURCE = '/generate';

    private static final Mock.ofIRestService m_mockRestService;
    private static final Mock.ofIEncodingUtil m_mockEncodingUtil;
    private static final Mock.ofIStaticResource m_mockStaticResource;
    private static final Mock.ofIJson m_mockJson;
	private static final Mock.ofIHtmlCoding m_mockHtmlEncoding;
    private static final HtmlReportingServiceProxy sut;

    static {
    	m_mockRestService = new Mock.ofIRestService();
    	m_mockEncodingUtil = new Mock.ofIEncodingUtil();
    	m_mockStaticResource = new Mock.ofIStaticResource();
    	m_mockJson = new Mock.ofIJson();
		m_mockHtmlEncoding = new Mock.ofIHtmlCoding();
        sut = new HtmlReportingServiceProxy(m_mockRestService, m_mockEncodingUtil, m_mockStaticResource, m_mockJson, m_mockHtmlEncoding);
    }

    @IsTest
    static void it_should_call_the_static_resource_to_get_bytes() {
    	String staticResourceName = 'test-folder';
    	String fileName = 'test-file';
    	String jsonData = 'json-data';
    	String serializedData = 'serialized-data';
    	RestUtility.Result response = new RestUtility.Result();
    	response.Status = 'OK';
    	response.response = 'data';
    	HtmlReportingServiceProxy.SvcResponse svcResponse = new HtmlReportingServiceProxy.SvcResponse();

    	m_mockJson.setup('serialize', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(serializedData);
    	m_mockRestService.setup('POST', new List<Object>{SERVICE_API_NAME, SERVICE_RESOURCE ,serializedData}).returns(response);
    	m_mockJson.setup('deserialize', new List<Object>{response.response ,HtmlReportingServiceProxy.SvcResponse.class}).returns(svcResponse);
		m_mockHtmlEncoding.setup('httpRequestSanitizer', new List<Object>{jsonData}).returns(jsonData);

    	Blob result = sut.getPdf(staticResourceName, fileName, jsonData);

    	m_mockStaticResource.verify('getData', new List<Object>{staticResourceName, fileName}, Times.Once);
		m_mockHtmlEncoding.verify('httpRequestSanitizer', new List<Object>{jsonData}, Times.Once);
    }

    @IsTest
    static void it_should_call_the_encoding_util_to_get_convert_back_from_base_64() {
    	String staticResourceName = 'test-folder';
    	String fileName = 'test-file';
    	String jsonData = 'json-data';
    	String serializedData = 'serialized-data';
    	RestUtility.Result response = new RestUtility.Result();
    	response.Status = 'OK';
    	response.response = 'data';
    	HtmlReportingServiceProxy.SvcResponse svcResponse = new HtmlReportingServiceProxy.SvcResponse();
    	String svcResData = 'test-data';
    	svcResponse.base64Report = svcResData;
    	Blob staticResourceData = Blob.valueof(svcResData);

    	m_mockJson.setup('serialize', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(serializedData);
    	m_mockRestService.setup('POST', new List<Object>{SERVICE_API_NAME, SERVICE_RESOURCE ,serializedData}).returns(response);
    	m_mockJson.setup('deserialize', new List<Object>{response.response ,HtmlReportingServiceProxy.SvcResponse.class}).returns(svcResponse);
    	m_mockStaticResource.setup('getData', new List<Object>{staticResourceName, fileName}).returns(staticResourceData);
		m_mockHtmlEncoding.setup('httpRequestSanitizer', new List<Object>{jsonData}).returns(jsonData);

    	Blob result = sut.getPdf(staticResourceName, fileName, jsonData);

    	m_mockEncodingUtil.verify('fromBase64', new List<Object>{svcResponse.base64Report});
    }

    @IsTest
    static void it_should_verify_that_the_params_created_have_correct_values() {
    	String staticResourceName = 'test-folder';
    	String fileName = 'test-file';
    	String jsonData = 'json-data';
    	String serializedData = 'serialized-data';
    	RestUtility.Result response = new RestUtility.Result();
    	response.Status = 'OK';
    	response.response = 'data';
    	HtmlReportingServiceProxy.SvcResponse svcResponse = new HtmlReportingServiceProxy.SvcResponse();
    	String svcResData = 'test-data';
    	svcResponse.base64Report = svcResData;
    	String templateStringData = 'test-template-data';
    	Blob template = Blob.valueof(templateStringData);
    	String templateBase64 = 'test-template-base64';

    	m_mockJson.setup('serialize', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(serializedData);
    	m_mockRestService.setup('POST', new List<Object>{SERVICE_API_NAME, SERVICE_RESOURCE ,serializedData}).returns(response);
    	m_mockJson.setup('deserialize', new List<Object>{response.response ,HtmlReportingServiceProxy.SvcResponse.class}).returns(svcResponse);
    	m_mockEncodingUtil.setup('toBase64', new List<Object>{template}).returns(templateBase64);
		m_mockHtmlEncoding.setup('httpRequestSanitizer', new List<Object>{jsonData}).returns(jsonData);

    	Blob result = sut.getPdf(template, jsonData);

    	m_mockJson.verify('serialize',  ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
    	List<Object> arguments = (List<Object>)m_mockJson.getArgumentsFromCall('serialize');
    	HtmlReportingServiceProxy.HtmlReportingParams params = (HtmlReportingServiceProxy.HtmlReportingParams)arguments[0];
    	System.assertEquals(templateBase64 ,params.Base64HtmlTemplate );
    	System.assertEquals(jsonData , params.ReportDataJson);
    	System.assertEquals(MimeType.Pdf , params.MimeType);
    }
}