public class DrawerPrivilege implements Documents.ICacheable{

    public String Email {get;set;}
    public String DrawerName {get;set;}
    
    public static String GetKey(String userEmail){
        WebServices.IRestService restService = new RestService(new GatewayApiMetadataProvider(), Configurations.bootstrap());
        return restService.GetApiResource('DocumentsUrl') + '/drawers?user=' + userEmail;
    }
    
    public Type classType(){
        return DrawerPrivilege.class;
    }
    
    public Documents.ICacheable FromCacheItem(wsCacheItem__c item){
        DrawerPrivilege d = new DrawerPrivilege();
        d.Email = item.Text0__c;
        d.DrawerName = item.Text1__c;
        return d;
    }
    
    public wsCacheItem__c ToCacheItem(){
        wsCacheItem__c i = new wsCacheItem__c();
        i.Key__c = Email + ';' + DrawerName;
        i.Text0__c = Email;
        i.Text1__c = DrawerName;
        return i;
    }
    
    public String ToCacheFieldName(String fieldName){
        if(fieldName=='Email') return 'Text0__c';
        if(fieldName=='DrawerName') return 'Text1__c';
        return '';
    }
}