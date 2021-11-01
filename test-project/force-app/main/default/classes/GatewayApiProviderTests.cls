@IsTest
private class GatewayApiProviderTests {
	private final static Mock.ofIRestService m_mockRestService;
    private final static Mock.ofIWebServiceCache m_mockCache;
    private final static Mock.ofIConfigurations m_mockConfigs;
    private final static GatewayApiProvider sut;
    
    static {
        m_mockRestService = new Mock.ofIRestService();
        m_mockCache = new Mock.ofIWebServiceCache();
        m_mockConfigs = new Mock.ofIConfigurations();
        sut = new GatewayApiProvider(m_mockRestService, m_mockCache, m_mockConfigs);
    }
    
    @IsTest
    static void it_should_call_the_rest_service_to_get_response_with_lifespan_provided() {
        string apiResource = 'getTestData';
        string endpoint = 'http://test.com/';
        integer lifeSpanMinutes = 2;
        RESTUtility.result res = new RESTUtility.result();
        res.status = 'OK';
        res.response = 'test-response';
        m_mockRestService.setup('Get', new List<Object>{apiResource, endpoint}).returns(res);
        
        sut.get(apiResource, endpoint, lifeSpanMinutes);
        
        m_mockRestService.verify('GET' ,new List<Object>{apiResource, endpoint}, Times.Once);
    }

    @IsTest
    static void it_should_call_the_web_service_cache_to_find_an_item_in_cache_by_key() {
        string apiResource = 'getTestData';
        string endpoint = 'http://test.com/';
        string listKey = apiResource + endpoint;
        integer lifeSpanMinutes = 2;
        RESTUtility.result res = new RESTUtility.result();
        res.status = 'OK';
        res.response = 'test-response';
        m_mockRestService.setup('Get', new List<Object>{apiResource, endpoint}).returns(res);
        
        sut.get(apiResource, endpoint, lifeSpanMinutes);

        m_mockCache.verify('FindByKey', new List<Object>{listKey}, Times.Once);
    }

    @IsTest
    static void it_should_call_the_web_service_cache_to_load_items() {
        string apiResource = 'getTestData';
        string endpoint = 'http://test.com/';
        string listKey = apiResource + endpoint;
        integer lifeSpanMinutes = 2;
        wsCache__c existing = new wsCache__c();
        RESTUtility.result res = new RESTUtility.result();
        res.status = 'OK';
        res.response = 'test-response';
        m_mockRestService.setup('Get', new List<Object>{apiResource, endpoint}).returns(res);
        m_mockCache.setup('FindByKey', new List<Object>{listKey}).returns(existing);
        
        sut.get(apiResource, endpoint, lifeSpanMinutes);

        m_mockCache.verify('LoadItems', new List<Object>{existing,'Text0__c', 'ASC', 0, 0, ''}, Times.Once);
    }

    @IsTest
    static void it_should_call_the_web_service_cache_to_save_loaded_items() {
        string apiResource = 'getTestData';
        string endpoint = 'http://test.com/';
        string listKey = apiResource + endpoint;
        integer lifeSpanMinutes = 2;
        wsCache__c existing = new wsCache__c();
        List<wsCacheItem__c> cache = new List<wsCacheItem__c>();
        RESTUtility.result res = new RESTUtility.result();
        res.status = 'OK';
        res.response = 'test-response';
        m_mockRestService.setup('Get', new List<Object>{apiResource, endpoint}).returns(res);
        
        sut.get(apiResource, endpoint, lifeSpanMinutes);

        m_mockCache.verify('SaveItems', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
        List<Object> args = m_mockCache.getArgumentsFromCall('SaveItems');
        List<wsCacheItem__c> argCacheItems = (List<wsCacheItem__c>)args[0];
        String argListKey = (string)args[1];
        Integer argLifeSpanMinutes = (Integer)args[2];

        System.assertEquals(1, argCacheItems.size());
        System.assertEquals(listKey, argListKey);
        System.assertEquals(lifeSpanMinutes, argLifeSpanMinutes);
    }

    @IsTest
    static void it_should_throw_a_GatewayApiProviderWebServiceException_when_the_service_call_fails() {
        string apiResource = 'getTestData';
        string endpoint = 'http://test.com/';
        string listKey = apiResource + endpoint;
        integer lifeSpanMinutes = 2;
        RESTUtility.result res = new RESTUtility.result();
        res.status = 'FAIL';
        res.response = 'test-response';
        m_mockRestService.setup('Get', new List<Object>{apiResource, endpoint}).returns(res);
        
        try {
            sut.get(apiResource, endpoint, lifeSpanMinutes);
            System.assert(false);
        } catch (GatewayApiProvider.WebServiceException ex) {
            System.assert(true);
        } catch (Exception ex){
            System.assert(false);
        }        
    }

    @IsTest
    static void it_should_not_load_from_the_cache_when_lifespan_parameter_is_zero_and_cache_exists() {
        string apiResource = 'getTestData';
        string endpoint = 'http://test.com/';
        RESTUtility.result res = new RESTUtility.result();
        res.status = 'OK';
        res.response = 'test-response';
        m_mockRestService.setup('Get', new List<Object>{apiResource, endpoint}).returns(res);
        m_mockCache.setup('FindByKey', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(new wsCache__c());
        
        sut.get(apiResource, endpoint, 0);
        
        m_mockCache.verify('LoadItems', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Never);
        m_mockCache.verify('SaveItems', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Never);
    }

    @IsTest
    static void it_should_call_the_rest_service_to_get_data() {
        String baseUrl = 'http://salesforce.com';
        String url = '-endpoint';
        String fetchUrl = baseUrl + url;
        RESTutility.result res = new RESTutility.result();
        res.response = 'test';

        m_mockConfigs.setup('restServiceBaseUrl').returns(baseUrl);
        m_mockRestService.setup('GET', new List<Object>{fetchUrl}).returns(res);

        String result = sut.get(url);

        m_mockRestService.verify('GET', new List<Object>{fetchUrl}, Times.Once);
        System.assertEquals('test' ,result);
    }

    @IsTest
    static void it_should_call_the_rest_service_to_post_data() {
        String baseUrl = 'http://salesforce.com';
        String url = '-endpoint';
        String fetchUrl = baseUrl + url;
        String body = '-body';
        RESTutility.result res = new RESTutility.result();
        res.response = 'test';

        m_mockConfigs.setup('restServiceBaseUrl').returns(baseUrl);
        m_mockRestService.setup('POST', new List<Object>{fetchUrl, body}).returns(res);

        String result = sut.post(url, body);

        m_mockRestService.verify('POST', new List<Object>{fetchUrl, body}, Times.Once);
        System.assertEquals('test' ,result);
    }
}