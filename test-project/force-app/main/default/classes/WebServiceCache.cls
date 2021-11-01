public class WebServiceCache implements IWebServiceCache {
    public interface IWebServiceCache {
        wsCache__c FindByKey(String key);
        wsCache__c SaveItems(List<wsCacheItem__c> items, String cacheKey);
        wsCache__c SaveItems(List<wsCacheItem__c> items, String cacheKey, Integer lifeSpanMinutes);
        List<wsCacheItem__c> LoadItems(wsCache__c Cache, String sortByProperty, String sortByDirection, Integer pageSize, Integer pageNumber, String conditions);
        void DeleteItems(string key);
        void DeleteItems(ID wscacheId); 
    }  

    public wsCache__c FindByKey(String key){
        List<wsCache__c> existingList = [SELECT Id, Key__c FROM wsCache__c WHERE Key__c=:key AND IsExpired__c=0 ORDER BY Expiration_Date__c DESC LIMIT 1];
        if(existingList.size() > 0){
            return existingList[0];
        }else{
            return null;
        }
    }
    
    public wsCache__c SaveItems(List<wsCacheItem__c> items, String cacheKey){
    	return SaveItems(items, cacheKey, 0);
    }

    public wsCache__c SaveItems(List<wsCacheItem__c> items, String cacheKey, Integer lifeSpanMinutes){
        wsCache__c newCache = FindByKey(cacheKey);
        if(newCache != null) return newCache;
         
        newCache = new wsCache__c();
        newCache.Key__c = cacheKey;
        if(lifeSpanMinutes > 0) newCache.Override_Lifespan_Minutes__c = lifeSpanMinutes;
        if(items.size() == 0) return newCache;
        
        insert newCache;
                       
        for(wsCacheItem__c i : items){
            i.wsCache__c = newCache.Id;
        }
        insert items;
        
        return newCache;
    }    
       
    public List<wsCacheItem__c> LoadItems(wsCache__c Cache, String sortByProperty, String sortByDirection, Integer pageSize, Integer pageNumber, String conditions){
    	if(sortByProperty == ''){
    		sortByProperty = 'Name';
    		sortByDirection = 'ASC';
    	}
        
		String query = 'SELECT '
			+ 'Id,Name,Key__c '
			+ ',Text0__c,Text1__c,Text2__c,Text3__c,Text4__c,Text5__c,Text6__c,Text7__c, Text8__c '
			+ ',Number0__c,Number1__c,Number2__c,Number3__c '
			+ ',DateTime0__c,DateTime1__c '
        	+ ',LongText0__c '
			+ 'FROM wsCacheItem__c '
			+ 'WHERE wsCache__c = \'' + String.valueOf(Cache.Id) + '\' ';
		
        if(conditions != '') query += 'AND ' + conditions + ' ';
		query += 'ORDER BY ' + sortByProperty + ' ' + sortByDirection + ' ';
		if(pageSize > 0) query += 'LIMIT ' + String.valueOf(pageSize) + ' ';		
		if(pageNumber > 0) query += 'OFFSET ' + String.valueOf(pageSize*pageNumber);
		
        system.debug('####LoadItems ' + query);		
        return Database.query(query);
    }

    public void DeleteItems(ID wscacheId) {
    	wsCache__c ws = new wsCache__c(Id = wscacheId);
    	delete ws;
    }

    public void DeleteItems(String key){
    	List<wsCache__c> wsList = [SELECT Id FROM wsCache__c WHERE key__c =:key];
    	if(wsList.size() > 0) delete wsList;
    }   
}