@IsTest
private class PricingWkstSvcProxyTests {

    private static final PricingWkstRequest testRequest;
    private static final PricingWkst.PricingRequestForJSON testRequestForJson;
    private static final PricingWkst.PricingResponseForJSON testResponseForJson;
    private static final PricingWkstResults testResults;
    private static final String jsonRequest;
    private static final Mock.ofIRESTService mockRESTService;
    private static final MockofIPricingWkstSvcMapper mockPricingWkstSvcMapper;
    private static final PricingWkstSvcProxy sut;

    static {
        mockRESTService = new Mock.ofIRESTService();
        mockPricingWkstSvcMapper = new MockofIPricingWkstSvcMapper();

        testRequest = new PricingWkstRequest();
        testRequestForJson = new PricingWkst.PricingRequestForJSON();
        jsonRequest = JSON.serialize(testRequestForJson);
        mockPricingWkstSvcMapper.setup('convertToJSONRequestObject', new List<Object>{testRequest}).returns(testRequestForJson);

        String pricingWksheetUrl = 'SalesforceRESTService/data/xyz';
        mockRESTService.setup('GetApiResource', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(pricingWksheetUrl);

        testResponseForJson = new PricingWkst.PricingResponseForJSON();
        testResponseForJson.targetReturnOnEquity = 99.88;
        RestUtility.result webservicereturn = new RestUtility.result();
        String jsonResults = ' {"TargetReturnOnEquity":99.88}';
        webservicereturn.response = jsonResults;
        testResults = new PricingWkstResults();
        testResults.targetReturnOnEquity = 99.88;
        mockRESTService.setup('POST', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(webservicereturn);
        mockPricingWkstSvcMapper.setup('generatePricingRequestResults', new List<Object>{testRequest, testResponseForJson}).returns(testResults);
        sut = new PricingWkstSvcProxy(mockRESTService, mockPricingWkstSvcMapper);
    }

    @IsTest
    static void it_should_call_the_default_constructor_without_error() {
        PricingWkstSvcProxy sutDef = new PricingWkstSvcProxy();
    }

    @IsTest
    static void it_should_send_the_request_to_the_svc_mapper_to_convert_to_json_request_object() {
        sut.getPricingInformation(testRequest);

        mockPricingWkstSvcMapper.verify('convertToJSONRequestObject', new List<Object>{testRequest}, Times.Once);
    }

    @IsTest
    static void it_should_wakeup_the_rest_service_when_requesting_a_response_from_the_rest_service() {
        sut.getPricingInformation(testRequest);

        mockRESTService.verify('Wakeup', Times.Once);
    }

    @IsTest
    static void it_should_get_the_api_resource_when_requesting_a_response_from_the_rest_service() {
        sut.getPricingInformation(testRequest);

        mockRESTService.verify('GetApiResource', new List<Object>{'PricingWorksheetUrl'}, Times.Once);
    }

    @IsTest
    static void it_should_request_a_response_from_the_rest_service() {
        sut.getPricingInformation(testRequest);

        mockRESTService.verify('POST', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
    }

    @IsTest
    static void it_should_send_result_of_rest_service_to_svc_mapper_to_convert_to_results() {
        sut.getPricingInformation(testRequest);

        mockPricingWkstSvcMapper.verify('generatePricingRequestResults', new List<Object>{testRequest, testResponseForJson}, Times.Once);
    }

    @IsTest
    static void it_should_return_the_object_from_the_call_to_service_mapper() {
        PricingWkstResults results = sut.getPricingInformation(testRequest);

        System.assertEquals(99.88, results.targetReturnOnEquity);
    }

    private class MockofIPricingWkstSvcMapper extends ApexMoq implements PricingWkst.IPricingWkstSvcMapper {
        public PricingWkst.PricingRequestForJSON convertToJSONRequestObject(PricingWkstRequest request){
            return (PricingWkst.PricingRequestForJSON)handleMethodInvocation('convertToJSONRequestObject', new List<Object>{request});
        }
        public PricingWkstResults generatePricingRequestResults(PricingWkstRequest request, PricingWkst.PricingResponseForJSON response){
            return (PricingWkstResults)handleMethodInvocation('generatePricingRequestResults', new List<Object>{request, response});
        }
    }
}