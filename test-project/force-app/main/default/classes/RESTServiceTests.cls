@IsTest
private class RESTServiceTests {

    private static RestService sut;
    private static final MockIGatewayApiMetadataProvider mockGatewayMetadataProvider;
    private static final Mock.ofIConfigurations mockConfigurations;
    private static final Mock.ofHttpCalloutMock m_mockCallout;

    static {
        mockGatewayMetadataProvider = new MockIGatewayApiMetadataProvider();
        mockConfigurations = new Mock.ofIConfigurations();
        m_mockCallout = new Mock.ofHttpCalloutMock();
        sut = new RestService(mockGatewayMetadataProvider, mockConfigurations);
    }

    @IsTest
    static void it_should_call_the_metadata_provider_and_config_to_get_available_for_restservice() {

        sut.GetApiResource('AvailableUrl');

        mockConfigurations.verify('restServiceBaseUrl', Times.Once);
        mockGatewayMetadataProvider.verify('GetResourceBy', new List<Object> {'AvailableUrl'}, Times.Once);
    }

    @IsTest
    static void it_should_make_the_correct_callout_when_GET_is_called() {
        String apiName = 'test-api-name';
        String uri = '/test-uri';
        String baseurl = 'base-url';
        String apiResource = '/api-resource';
        Test.setMock(HttpCalloutMock.class, m_mockCallout);
        mockConfigurations.setup('restServiceBaseUrl').returns(baseUrl);
        mockGatewayMetadataProvider.setup('GetResourceBy', new List<Object> {apiName}).returns(apiResource);
        m_mockCallout.setup('respond',  ApexMoq.Arguments.HAVE_ANY_VALUE).returns(new HttpResponse());

        Test.startTest(); 
        sut.GET(apiName, uri);
        Test.stopTest();

        m_mockCallout.verify('respond',  ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
        List<Object> arguments = (List<Object>)m_mockCallout.getArgumentsFromCall('respond');
        HttpRequest calledRequest = (HttpRequest) arguments[0];
        System.assertEquals('GET' ,calledRequest.getMethod());
        System.assertEquals(baseUrl + apiResource + uri, calledRequest.getEndpoint());
    }

    @IsTest
    static void it_should_make_the_correct_callout_when_GET_is_called_without_api_name() {
        String endpoint = 'test-endpoint';
        Test.setMock(HttpCalloutMock.class, m_mockCallout);
        m_mockCallout.setup('respond',  ApexMoq.Arguments.HAVE_ANY_VALUE).returns(new HttpResponse());

        Test.startTest(); 
        sut.GET(endpoint);
        Test.stopTest();

        m_mockCallout.verify('respond',  ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
        List<Object> arguments = (List<Object>)m_mockCallout.getArgumentsFromCall('respond');
        HttpRequest calledRequest = (HttpRequest) arguments[0];
        System.assertEquals('GET' ,calledRequest.getMethod());
        System.assertEquals(endpoint, calledRequest.getEndpoint());
    }

    @IsTest
    static void it_should_make_the_correct_callout_when_GET_is_called_with_url_and_headers() {
        String apiName = 'test-api-name';
        String uri = '/test-uri';
        String baseurl = 'base-url';
        String apiResource = '/api-resource';
        Map<string,string> headers = new Map<string,string>();
        Test.setMock(HttpCalloutMock.class, m_mockCallout);
        mockConfigurations.setup('restServiceBaseUrl').returns(baseUrl);
        mockGatewayMetadataProvider.setup('GetResourceBy', new List<Object> {apiName}).returns(apiResource);
        m_mockCallout.setup('respond',  ApexMoq.Arguments.HAVE_ANY_VALUE).returns(new HttpResponse());

        Test.startTest(); 
        sut.GET(apiName, uri, headers);
        Test.stopTest();

        m_mockCallout.verify('respond',  ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
        List<Object> arguments = (List<Object>)m_mockCallout.getArgumentsFromCall('respond');
        HttpRequest calledRequest = (HttpRequest) arguments[0];
        System.assertEquals('GET' ,calledRequest.getMethod());
        System.assertEquals(baseUrl + apiResource + uri, calledRequest.getEndpoint());
    }

    @IsTest
    static void it_should_make_the_correct_callout_when_POST_is_called() {
        String apiName = 'test-api-name';
        String uri = '/test-uri';
        String body = 'test-body';
        String baseurl = 'base-url';
        String apiResource = '/api-resource';
        Test.setMock(HttpCalloutMock.class, m_mockCallout);
        mockConfigurations.setup('restServiceBaseUrl').returns(baseUrl);
        mockGatewayMetadataProvider.setup('GetResourceBy', new List<Object> {apiName}).returns(apiResource);
        m_mockCallout.setup('respond',  ApexMoq.Arguments.HAVE_ANY_VALUE).returns(new HttpResponse());

        Test.startTest(); 
        sut.POST(apiName, uri, body);
        Test.stopTest();

        m_mockCallout.verify('respond',  ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
        List<Object> arguments = (List<Object>)m_mockCallout.getArgumentsFromCall('respond');
        HttpRequest calledRequest = (HttpRequest) arguments[0];
        System.assertEquals('POST' ,calledRequest.getMethod());
        System.assertEquals(baseUrl + apiResource + uri, calledRequest.getEndpoint());
        System.assertEquals(body ,calledRequest.getBody());  
    }

    @IsTest
    static void it_should_make_the_correct_callout_when_POST_is_called_without_api_name() {
        String endpoint = 'test-endpoint';
        String body = 'test-body';
        Test.setMock(HttpCalloutMock.class, m_mockCallout);
        m_mockCallout.setup('respond',  ApexMoq.Arguments.HAVE_ANY_VALUE).returns(new HttpResponse());

        Test.startTest(); 
        sut.POST(endpoint, body);
        Test.stopTest();

        m_mockCallout.verify('respond',  ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
        List<Object> arguments = (List<Object>)m_mockCallout.getArgumentsFromCall('respond');
        HttpRequest calledRequest = (HttpRequest) arguments[0];
        System.assertEquals('POST' ,calledRequest.getMethod());
        System.assertEquals(endpoint, calledRequest.getEndpoint());
        System.assertEquals(body ,calledRequest.getBody());
    }

    @IsTest
    static void it_should_make_the_correct_callout_when_POST_is_called_with_headers() {
        String apiName = 'test-api-name';
        String uri = '/test-uri';
        String body = 'test-body';
        String baseurl = 'base-url';
        String apiResource = '/api-resource';
        Map<string,string> headers = new Map<string,string>();
        Test.setMock(HttpCalloutMock.class, m_mockCallout);
        mockConfigurations.setup('restServiceBaseUrl').returns(baseUrl);
        mockGatewayMetadataProvider.setup('GetResourceBy', new List<Object> {apiName}).returns(apiResource);
        m_mockCallout.setup('respond',  ApexMoq.Arguments.HAVE_ANY_VALUE).returns(new HttpResponse());

        Test.startTest(); 
        sut.POST(apiName, uri, body, headers);
        Test.stopTest();

        m_mockCallout.verify('respond',  ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
        List<Object> arguments = (List<Object>)m_mockCallout.getArgumentsFromCall('respond');
        HttpRequest calledRequest = (HttpRequest) arguments[0];
        System.assertEquals('POST' ,calledRequest.getMethod());
        System.assertEquals(baseUrl + apiResource + uri, calledRequest.getEndpoint());
        System.assertEquals(body ,calledRequest.getBody());  
    }

    @IsTest
    static void it_should_make_the_correct_callout_when_POST_Async_is_called() {
        String apiName = 'test-api-name';
        String uri = '/test-uri';
        String body = 'test-body';
        String baseurl = 'base-url';
        String apiResource = '/api-resource';
        Test.setMock(HttpCalloutMock.class, m_mockCallout);
        mockConfigurations.setup('restServiceBaseUrl').returns(baseUrl);
        mockGatewayMetadataProvider.setup('GetResourceBy', new List<Object> {apiName}).returns(apiResource);
        m_mockCallout.setup('respond',  ApexMoq.Arguments.HAVE_ANY_VALUE).returns(new HttpResponse());

        Test.startTest(); 
        sut.POST_Async(apiName, uri, body);
        Test.stopTest();

        m_mockCallout.verify('respond',  ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
        List<Object> arguments = (List<Object>)m_mockCallout.getArgumentsFromCall('respond');
        HttpRequest calledRequest = (HttpRequest) arguments[0];
        System.assertEquals('POST' ,calledRequest.getMethod());
        System.assertEquals(baseUrl + apiResource + uri, calledRequest.getEndpoint());
        System.assertEquals(body ,calledRequest.getBody());  
    }

    @IsTest
    static void code_coverage_call_wakeup_service() {
        Test.setMock(HttpCalloutMock.class, m_mockCallout);
        m_mockCallout.setup('respond',  ApexMoq.Arguments.HAVE_ANY_VALUE).returns(new HttpResponse());

        Test.startTest(); 
        sut.Wakeup();
        Test.stopTest();

        m_mockCallout.verify('respond',  ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
    }

    public class MockIGatewayApiMetadataProvider extends ApexMoq implements GatewayApiMetadataProvider.IGatewayApiMetadataProvider {
        public Map<string, DmGateway> GetAll() {
            return (Map<string, DmGateway>)handleMethodInvocation('GetAll');
        }
        public String GetResourceBy(string apiName) {
            return (String)handleMethodInvocation('GetResourceBy', new List<Object>{apiName});
        }
    }
}