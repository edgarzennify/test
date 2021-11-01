global class GatewayApiController {
    @RemoteAction
    global static String get(String apiResource, String endpoint, Integer lifeSpanMinutes){
        try{
            Configurations.IConfigurations config = Configurations.bootstrap();
            Webservices.IRestService restService = new RestService(new GatewayApiMetadataProvider(), config);
            WebServiceCache.IWebServiceCache cache = new WebServiceCache();
            GatewayApiProvider.IGatewayApiProvider provider = new GatewayApiProvider(restService, cache, config);
            return provider.get(apiResource, endpoint, lifeSpanMinutes);
        }catch(Exception ex){

        }
        return '';
    }

    @RemoteAction
    global static String get2(String url) {
        try{
            Configurations.IConfigurations config = Configurations.bootstrap();
            Webservices.IRestService restService = new RestService(new GatewayApiMetadataProvider(), config);
            WebServiceCache.IWebServiceCache cache = new WebServiceCache();
            GatewayApiProvider.IGatewayApiProvider provider = new GatewayApiProvider(restService, cache, config);
            return provider.get(url);
        }catch(Exception ex){

        }
        return '';
    }

    @RemoteAction
    global static String post(String url, String body) {
        try{
            Configurations.IConfigurations config = Configurations.bootstrap();
            Webservices.IRestService restService = new RestService(new GatewayApiMetadataProvider(), config);
            WebServiceCache.IWebServiceCache cache = new WebServiceCache();
            GatewayApiProvider.IGatewayApiProvider provider = new GatewayApiProvider(restService, cache, config);
            return provider.post(url, body);            
        }catch(Exception ex){

        }
        return '';
    }

    @RemoteAction
    global static Boolean getIsSandbox{
        get{
            return getInstanceInfo().IsSandbox;
        }
    }

    @RemoteAction
    global static string getInstanceName{
        get{
            return getInstanceInfo().InstanceName;
        }
    }

    @RemoteAction
    global static InstanceMetadata getInstanceInfo(){
        DataProvider.IDataProvider d = new DataProvider();
        InstanceMetadata data = new InstanceMetadata();
        String query = 'SELECT IsSandbox,InstanceName FROM Organization LIMIT 1';
        List<string> fieldNames = new List<string>{'IsSandbox','InstanceName'};
        DataProvider.DynamicQueryResult qr = d.executeDynamicQuery(query, fieldNames)[0];
        for(DataProvider.DynamicQueryFieldResult qfr : qr.fieldValues){
            if(qfr.FieldName.tolowercase() == 'issandbox'){
                data.issandbox = Boolean.valueof(qfr.FieldValue);
            }else if(qfr.FieldName.tolowercase() == 'instancename'){
                data.InstanceName = String.valueof(qfr.FieldValue);
            }
        }
        
        return data;
    }

    @RemoteAction 
    global static String getCurrentUser(){
        IUserInfoService usvc = UserInfoService.bootstrap();
        Utility.IUtility util = new Utility();
        String userId = uSvc.getCurrentUserId();
        userId = util.convertid15ToId18(userId);
        return userId;
    }

    global class InstanceMetadata{
        public string InstanceName{get;set;}
        public Boolean IsSandbox{get;set;}
    }
}