public class GatewayApiProvider implements IGatewayApiProvider{

    public interface IGatewayApiProvider{
        String get(String apiResource, String endpoint, Integer lifeSpanMinutes);
        String get(String url);
        String post(String url, String payload);
    }
    
    private final Webservices.IRestService m_restService;
    private final WebServiceCache.IWebServiceCache m_cache;
    private final Configurations.IConfigurations m_configs;
    
    public GatewayApiProvider(Webservices.IRestService restService, WebServiceCache.IWebServiceCache cache, Configurations.IConfigurations configs){
        m_restService = restService;
        m_cache = cache;
        m_configs = configs;
    }
    
    public String get(String apiResource, String endpoint, Integer lifeSpanMinutes){
        try{
            String listKey = apiResource + endpoint;
            wsCache__c existing = m_cache.FindByKey(listKey);
            
            if(lifeSpanMinutes > 0 && existing != null){
                List<wsCacheItem__c> cache = m_cache.LoadItems(existing, 'Text0__c', 'ASC', 0, 0, '');
                return cache[0].LongText0__c;
            }else{
                String response = fetchFromService(apiResource, endpoint);
                if(lifeSpanMinutes > 0 && !String.isBlank(response)){
                    wsCacheItem__c saveItem = new wsCacheItem__c();
                    saveItem.LongText0__c = response;
                    m_cache.SaveItems(new List<wsCacheItem__c>{saveItem}, listKey, lifeSpanMinutes);  
                }                 
                return response;
            }
        }catch(Exception ex){
            return fetchFromService(apiResource, endpoint);
        }
    }

    public String get(String url) {
        String baseUrl = m_configs.restServiceBaseUrl();
        String endpoint = baseUrl + url;
        RESTUtility.result result = m_restService.GET(endpoint);
        if(result != null){return result.response;}
        return '';
    }

    public String post(String url, String payload){
        String baseUrl = m_configs.restServiceBaseUrl();
        String endpoint = baseUrl + url;
        RESTUtility.result result = m_restService.POST(endpoint, payload);
        if(result!= null){
            return result.response;
        }
        return '';
    }
    
    private String fetchFromService(String apiResource, String endpoint) {
        RESTUtility.result res = m_restService.GET(apiResource, endpoint);
        if(res.status.contains('OK')) return res.response;
        throw new WebServiceException(res.response);
    }

    public class WebServiceException extends Exception {}
}