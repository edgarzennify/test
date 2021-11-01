public class WebServices{
    public interface IRESTService{
        void Wakeup();
        RESTUtility.result GET(String uri);
        RESTUtility.result GET(String uri,Map<string,string> headers);
        RESTUtility.result GET(String apiName, String uri);
        RESTUtility.result GET(String apiName, String uri, Map<string, string> headers);
        
        RESTUtility.result POST(String uri, String body);
        RESTUtility.result POST(String uri, String body, Map<string,string> headers);
        RESTUtility.result POST(String apiName, String uri, String body);
        RESTUtility.result POST(String apiName, String uri, String body, Map<string, string> headers);
        void POST_Async(String apiName, String uri, String body);
        void GET_Async(String apiName, String uri);
        String GetApiResource(string apiName);
    }
}