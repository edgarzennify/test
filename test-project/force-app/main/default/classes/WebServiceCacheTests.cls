@isTest
public class WebServiceCacheTests {

    private static WebServiceCache sut;
    
    static {
        sut = new WebServiceCache();
    }
    
    private static testMethod void it_should_find_a_cache_container_by_key(){
        wsCache__c testCache = new wsCache__c(Key__c = 'abc123', Override_Lifespan_Minutes__c = 100);
        insert testCache;
                        
        wsCache__c results = sut.FindByKey('abc123');
        
        System.assert(results != null);
        System.assertEquals(testCache.Id, results.Id);
    }
    
    private static testMethod void it_should_save_items_to_the_cache(){
        List<wsCacheItem__c> testItems = new List<wsCacheItem__c>();
        testItems.add(new wsCacheItem__c());
        testItems.add(new wsCacheItem__c());
                        
        wsCache__c results = sut.SaveItems(testItems, 'abc123');
        
        List<wsCacheItem__c> requery = [SELECT Id FROM wsCacheItem__c WHERE wsCache__c =: results.Id];
        System.assertEquals(2, requery.size());
    }
    
    private static testMethod void it_should_not_save_items_but_return_the_existing_cache_container_when_one_with_the_given_key_exists(){
        wsCache__c testCache = new wsCache__c(Key__c = 'abc123', Override_Lifespan_Minutes__c = 100);
        insert testCache;
        
        List<wsCacheItem__c> testItems = new List<wsCacheItem__c>();
        testItems.add(new wsCacheItem__c());
        testItems.add(new wsCacheItem__c());
                        
        wsCache__c results = sut.SaveItems(testItems, 'abc123');
        
        List<wsCacheItem__c> requery = [SELECT Id FROM wsCacheItem__c WHERE wsCache__c =: results.Id];
        System.assertEquals(0, requery.size());
    }
    
    private static testMethod void it_should_load_all_items_from_the_cache(){
        List<wsCacheItem__c> testItems = new List<wsCacheItem__c>();
        testItems.add(new wsCacheItem__c());
        testItems.add(new wsCacheItem__c());
                        
        wsCache__c saveResults = sut.SaveItems(testItems, 'abc123');
        List<wsCacheItem__c> results = sut.LoadItems(saveResults, '', '', 0, 0, '');
        
        System.assertEquals(2, results.size());
    }
    
    private static testMethod void it_should_load_the_correct_page_items_from_the_cache(){
        List<wsCacheItem__c> testItems = new List<wsCacheItem__c>();
        testItems.add(new wsCacheItem__c(Text0__c='item1'));
        testItems.add(new wsCacheItem__c(Text0__c='item2'));
                        
        wsCache__c saveResults = sut.SaveItems(testItems, 'abc123');
        List<wsCacheItem__c> page1Results = sut.LoadItems(saveResults, 'Text0__c', 'ASC', 1, 0, '');
        List<wsCacheItem__c> page2Results = sut.LoadItems(saveResults, 'Text0__c', 'ASC', 1, 1, '');
        
        System.assertEquals(1, page1Results.size());
        System.assertEquals(1, page2Results.size());
        System.assertEquals('item1', page1Results[0].Text0__c);
        System.assertEquals('item2', page2Results[0].Text0__c);
    }
    
    private static testMethod void it_should_delete_a_cache_container_by_its_id(){
        wsCache__c testCache = new wsCache__c(Key__c = 'abc123', Override_Lifespan_Minutes__c = 100);
        insert testCache;
                        
        sut.DeleteItems(testCache.Id);
        
        List<wsCache__c> requery = [SELECT Id FROM wsCache__c WHERE Id =: testCache.Id];
        System.assertEquals(0, requery.size());
    }
    
    private static testMethod void it_should_delete_a_cache_container_by_its_key(){
        wsCache__c testCache = new wsCache__c(Key__c = 'abc123', Override_Lifespan_Minutes__c = 100);
        insert testCache;
                        
        sut.DeleteItems('abc123');
        
        List<wsCache__c> requery = [SELECT Id FROM wsCache__c WHERE Id =: testCache.Id];
        System.assertEquals(0, requery.size());
    }
}