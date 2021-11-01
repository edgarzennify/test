public class RESTService implements WebServices.IRESTService{

    private final GatewayApiMetadataProvider.IGatewayApiMetadataProvider m_gatewayMetadataProvider;
    private final Configurations.IConfigurations m_configurations;

    public RESTService(GatewayApiMetadataProvider.IGatewayApiMetadataProvider gatewayMetadataProvider, Configurations.IConfigurations configurations)
    {
        m_gatewayMetadataProvider = gatewayMetadataProvider;
        m_configurations = configurations;
    }

    public void Wakeup(){
        RESTUtility.WakeupService();
    }
    
    public RESTUtility.result GET(String uri){
        return RESTUtility.EbRESTGet(uri);
    }

    public RESTUtility.result GET(String uri,Map<string,string> headers){
        RESTUtility.EbtRestGetRequest req = new RESTUtility.EbtRestGetRequest();
        req.url = uri;
        req.Headers = headers == null?new Map<string,string>():headers;
        return RESTUtility.EbRESTGet(req);
    }
    
    public RESTUtility.result GET(String apiName, String uri){
        String url = getUrl(apiName, uri);
        return GET(url);
    }

    public RESTUtility.result GET(String apiName, String uri, Map<string, string> headers){
        String url = getUrl(apiName, uri);
        return GET(url,headers);
    }

    public void GET_Async(String apiName, String uri){
        String url = getUrl(apiName, uri);
        asyncGetCallout(url);
    }

    public RESTUtility.result POST(String uri, String body){
        return RESTUtility.EbRESTPost(uri, body);
    }

    public RESTUtility.result POST(String uri, String body, Map<string,string> headers){
        RESTUtility.EbtRestPostRequest req = new RESTUtility.EbtRestPostRequest();
        req.url = uri;
        req.body = body;
        req.headers = headers == null? new Map<string,string>():headers;
        return RESTUtility.EbRESTPost(req);
    }
    
    public RESTUtility.result POST(String apiName, String uri, String body){
        String url = getUrl(apiName, uri);
        return POST(url, body);
    }

    public RESTUtility.result POST(String apiName, String uri, String body, Map<string, string> headers){
        String url = getUrl(apiName, uri);
        return POST(url, body, headers);
    }

    public void POST_Async(String apiName, String uri, String body){
        String url = getUrl(apiName, uri);
        asyncCallout(url, body);
    }

    public String getApiResource(String apiName){
        String serviceBaseUrl = m_configurations.restServiceBaseUrl();
        String apiResource = m_gatewayMetadataProvider.GetResourceBy(apiName);
        return String.format('{0}{1}', new List<String>{ serviceBaseUrl, apiResource });
    }
    
    private String getUrl(String apiName, String uri){
        String baseUri = getApiResource(apiName);
        return String.format('{0}{1}', new String[]{ baseUri, uri });
    }

    @future(callout=true)
    private static void asyncCallout(String url, String body){
        RESTUtility.EbRESTPost(url, body);
    }

    @future(callout=true)
    private static void asyncGetCallout(String url) {
        RESTUtility.Result res = RESTUtility.EbRESTGet(url);
    }
}