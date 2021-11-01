public class ImageNowDataService implements Documents.IDocumentDataService{
    private final WebServices.IRESTService m_svc;
    private final WebServiceCache.IWebServiceCache m_cache;
    private final EbObjectLookup.IEbObjectLookup m_objectLookup;
    
    public ImageNowDataService(WebServices.IRESTService svc, WebServiceCache.IWebServiceCache cache, EbObjectLookup.IEbObjectLookup objectLookup){
        m_svc = svc;
        m_cache = cache;
        m_objectLookup = objectLookup;
    }
    
    public void ExpireCache(String objectId){
        EbObjectLookup.KeyAndType kt = m_objectLookup.getObjectKeyAndType(objectId);        
        ExpireCache(kt.keyType, kt.objectKey);        
    }
    
    public void ExpireCache(String keyType, String pageKey){        
        String key1 = BuildKey(keyType,pageKey,true);
        String key2 = BuildKey(keyType,pageKey,false);
        m_cache.DeleteItems(key1);
        m_cache.DeleteItems(key2);        
    }
    
    public string BuildKey(String keyType, String pageKey, Boolean includeRelated){
        string serviceBaseUrl = m_svc.GetApiResource('DocumentsUrl');
        return String.Format('{0}/documents/rel_nav?key_type={1}&keys={2}&include_related={3}',new string[]{serviceBaseUrl, keyType, pageKey, String.valueOf(includeRelated)});
    }
    
    public List<Documents.ICacheable> LoadList(String listKey, String sortByProperty, String sortByDirection, Integer pageSize, Integer pageNumber, String conditions, Documents.ICacheable obj){
    	wsCache__c existing = m_cache.FindByKey(listKey);
        
        if(existing != null){
        	return FromCacheItems(obj, m_cache.LoadItems(existing, obj.ToCacheFieldName(sortByProperty), sortByDirection, pageSize, pageNumber, conditions));
        }else{
            List<Documents.ICacheable> liveList = RetrieveList(listKey, obj.classType());
            List<Documents.ICacheable> results = new List<Documents.ICacheable>();
            
            if(liveList != null){
                for(Documents.ICacheable o : liveList){
                    if(includedInFilter(o) && includeOnPage(results.size(), pageSize)){
                        results.add(o);
                    }
                }
            }            
            return results;
        }        
    }
                       
    private Boolean includedInFilter(Documents.ICacheable obj){
        return true;
    }
    
    private Boolean includeOnPage(Integer listSize, Integer pageSize){
        if(pageSize < 1 || listSize < pageSize){return true;}
        return false;
    }
    
    public void SaveList(List<Documents.ICacheable> objects, String listKey){
    	m_cache.SaveItems(ToCacheItems(objects), listKey);
    }
    
    private List<Documents.ICacheable> FromCacheItems(Documents.ICacheable obj, List<wsCacheItem__c> items){
    	List<Documents.ICacheable> objects = new List<Documents.ICacheable>();
        for(wsCacheItem__c i : items){
        	objects.add(obj.FromCacheItem(i));
        }
        return objects;
    }
    
    private List<wsCacheItem__c> ToCacheItems(List<Documents.ICacheable> objects){
    	List<wsCacheItem__c> items = new List<wsCacheItem__c>();
        for(Documents.ICacheable o : objects){
        	items.add(o.ToCacheItem());
        }
        return items;
    }
    
    private List<Documents.ICacheable> RetrieveList(String listKey, Type classType){
    	RestUtility.result res = FetchListFromService(listKey);
        return FromJSON(res.response, classType);
    }
    
    private RestUtility.result FetchListFromService(String listKey){
        return m_svc.GET(listKey);
    }
    
    private List<Documents.ICacheable> FromJSON(String jsonString, Type classType){
        List<Documents.ICacheable> objects = new List<Documents.ICacheable>();
        JSONParser parser = JSON.createParser(jsonString);
        
        while(parser.nextToken() != null){
            if(parser.getCurrentToken() == JSONToken.START_ARRAY){
                while(parser.nextToken() != null){
                    if(parser.getCurrentToken() == JSONToken.START_OBJECT){
                    	Documents.ICacheable o = (Documents.ICacheable)parser.readValueAs(classType);
                        objects.add(o);
                    }
                }
            }
        }
        return objects;
    }
}