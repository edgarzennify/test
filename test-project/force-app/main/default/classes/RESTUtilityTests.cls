@IsTest
public class RESTUtilityTests {
    
    private final static MockIGatewayApiMetadataProvider mockGatewayMetadata = new MockIGatewayApiMetadataProvider();
    private final static Mock.ofIConfigurations mockConfigurations = new Mock.ofIConfigurations();
    private final static RESTUtility sut;

    static {
        sut  = new RESTUtility(mockGatewayMetadata, mockConfigurations);
    }

    @IsTest
    static void it_should_use_the_gateway_provider_to_get_resource() {
        String apiName = 'test';

        String result = sut.GetApiResource(apiName);

        mockGatewayMetadata.Verify('GetResourceBy', new List<Object>{apiName}, Times.Once);
    }

    @IsTest
    static void it_should_return_the_api_resource_uri_when_api_name_is_provided() {
        String apiName = 'test';
        String apiResource = 'testuri/';
        String baseUrl = 'http://sf-gateway/';
        mockGatewayMetadata.Setup('GetResourceBy', new List<Object>{apiName}).Returns(apiResource);
        mockConfigurations.Setup('restServiceBaseUrl').Returns(baseUrl);

        String result = sut.GetApiResource(apiName);

        System.assertEquals('http://sf-gateway/testuri/', result);
    }


    @IsTest
    static void it_should_return_token_from_json() {
        String myReturnedToken = RESTutility.GenerateSingleTokenFromJSON('{"imageNowGetSingleDocumentResult":["myPageImage"]}');
        System.assertEquals('myPageImage', myReturnedToken);   
    }

    @IsTest
    static void it_should_return_empty_string_from_invalid_json() {
        String myReturnedToken = RESTutility.GenerateSingleTokenFromJSON('invalid');
        System.assertEquals('', myReturnedToken);   
    }

    static testMethod void it_should_be_able_to_test_callouts() {
        Archived_Report__c report = new Archived_Report__c();
        insert report;
        RESTUtility.CreditRelationshipOREO(report.Id);
    }

    public class MockIGatewayApiMetadataProvider extends ApexMoq implements GatewayApiMetadataProvider.IGatewayApiMetadataProvider {
        public String GetResourceBy(String apiName ) {
            return (String)handleMethodInvocation('GetResourceBy', new List<Object>{apiName});
        }
        public Map<String, DmGateway> GetAll() {
            return (Map<String, DmGateway>)handleMethodInvocation('GetResourceBy');
        }
    }
}