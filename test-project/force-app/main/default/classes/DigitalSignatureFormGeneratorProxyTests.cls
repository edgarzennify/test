@IsTest
private class DigitalSignatureFormGeneratorProxyTests {

    private static string SVC_ENDPOINT = 'DigitalFormGeneratorServiceUrl';
    private static string RESOURCE_SEND_FOR_SIGNATURE = '/sendforsignature';
    private static string RESOURCE_GENERATE_PDF = '/generatepdf';
    private static string RESOURCE_GET_ESIGNATURE_DATA = 'esignatureapplication';

    private static final Mock.ofIRestService m_mockRestService;
    private static final Mock.ofIJson m_mockJson;   
    private static DigitalSignatureFormGeneratorProxy sut;

    static {
        m_mockRestService = new Mock.ofIRestService();
        m_mockJson = new Mock.ofIJson();
        sut = new DigitalSignatureFormGeneratorProxy(m_mockRestService, m_mockJson);
    }

    @IsTest
    static void it_should_get_pdf_as_base64_by_calling_post_when_request_is_passed() {
        String jsonData = 'json-data';
    	String serializedData = 'serialized-data';
    	RestUtility.Result response = new RestUtility.Result();
    	response.Status = 'OK';
        response.response = 'data';
        DigitalSignatureFormGeneratorProxy.PdfResponse svcResponse = new DigitalSignatureFormGeneratorProxy.PdfResponse();
        svcResponse.base64Reports = new List<string>{'test'};
        String svcResData = 'test-data';
        
        DigitalSignatureFormGeneratorProxy.SignatureRequest request = new DigitalSignatureFormGeneratorProxy.SignatureRequest();
        request.ApplicationId = 1;
        m_mockJson.setup('serialize', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(serializedData);
    	m_mockRestService.setup('POST', new List<Object>{SVC_ENDPOINT, RESOURCE_GENERATE_PDF ,serializedData}).returns(response);
    	m_mockJson.setup('deserialize', new List<Object>{response.response ,DigitalSignatureFormGeneratorProxy.PdfResponse.class}).returns(svcResponse);
        
        DigitalSignatureFormGeneratorProxy.PdfResponse result = sut.getPdfAsbase64(request);
        
        m_mockJson.verify('serialize',  ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
    	List<Object> arguments = (List<Object>)m_mockJson.getArgumentsFromCall('serialize');
        DigitalSignatureFormGeneratorProxy.SignatureRequest params = (DigitalSignatureFormGeneratorProxy.SignatureRequest)arguments[0];
        System.assertEquals(1, params.ApplicationId);
        System.assertEquals('test', result.base64Reports[0]);
    }

    @IsTest
    static void it_should_do_a_post_to_send_request_for_signature() {
        String jsonData = 'json-data';
    	String serializedData = 'serialized-data';
    	RestUtility.Result response = new RestUtility.Result();
    	response.Status = 'OK';
        response.response = 'data';
        DigitalSignatureFormGeneratorProxy.SignatureResponse svcResponse = new DigitalSignatureFormGeneratorProxy.SignatureResponse();
        String svcResData = 'test-data';
        
        DigitalSignatureFormGeneratorProxy.SignatureRequest request = new DigitalSignatureFormGeneratorProxy.SignatureRequest();
        request.ApplicationId = 1;
        m_mockJson.setup('serialize', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(serializedData);
    	m_mockRestService.setup('POST', new List<Object>{SVC_ENDPOINT, RESOURCE_SEND_FOR_SIGNATURE ,serializedData}).returns(response);
    	m_mockJson.setup('deserialize', new List<Object>{response.response ,DigitalSignatureFormGeneratorProxy.SignatureResponse.class}).returns(svcResponse);
        
        DigitalSignatureFormGeneratorProxy.SignatureResponse result = sut.sendForSignature(request);

        m_mockJson.verify('serialize',  ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
    	List<Object> arguments = (List<Object>)m_mockJson.getArgumentsFromCall('serialize');
    	DigitalSignatureFormGeneratorProxy.SignatureRequest params = (DigitalSignatureFormGeneratorProxy.SignatureRequest)arguments[0];
        System.assertEquals(1, params.ApplicationId);
    }

    @IsTest
    static void it_should_do_a_get_to_get_signature_data() {
        String appId = '1';
    	RestUtility.Result response = new RestUtility.Result();
    	response.Status = 'OK';
        response.response = 'data';
        DigitalSignatureFormGeneratorProxy.SignatureStatusDataResponse svcResponse = new DigitalSignatureFormGeneratorProxy.SignatureStatusDataResponse();
        svcResponse.Items = new List<DigitalSignatureFormGeneratorProxy.SignatureStatusDataItemResponse>();
        DigitalSignatureFormGeneratorProxy.SignatureStatusDataItemResponse resItem = new DigitalSignatureFormGeneratorProxy.SignatureStatusDataItemResponse();
        resItem.ApplicationId = 1;
        svcResponse.Items.add(resItem);
        string url = String.format('/{0}/{1}', new List<string>{RESOURCE_GET_ESIGNATURE_DATA, appId});
        
    	m_mockRestService.setup('GET', new List<Object>{ SVC_ENDPOINT ,url}).returns(response);
    	m_mockJson.setup('deserialize', new List<Object>{response.response ,DigitalSignatureFormGeneratorProxy.SignatureResponse.class}).returns(svcResponse);  
        
        DigitalSignatureFormGeneratorProxy.SignatureStatusDataResponse result = sut.getData('1');

        m_mockJson.verify('deserialize',  ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
        List<Object> arguments = (List<Object>)m_mockJson.getArgumentsFromCall('deserialize');
        String params = (String)arguments[0];
        System.assertEquals('data', params);
    }
}