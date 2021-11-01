@IsTest
private class ImageNowDataServiceTests {
    
    private static final Mock.ofIRESTService mockSvc;
    private static final Mock.OfIWebServiceCache mockCache;
    private static final Mock.ofIEbObjectLookup mockObjectLookup;
    private static ImageNowDataService sut;
    
    static {
        mockSvc = new Mock.ofIRESTService();
        mockCache = new Mock.OfIWebServiceCache();
        mockObjectLookup = new Mock.ofIEbObjectLookup();
        sut = new ImageNowDataService(mockSvc, mockCache, mockObjectLookup);
    }

    @IsTest
    static void it_should_delete_cache_when_key_is_provided() {
        String objectId = 'obj-id';
        EbObjectLookup.KeyAndType kt = new EbObjectLookup.KeyAndType();
        kt.keyType = 'key-type';
        kt.objectKey = 'obj-key';
        mockObjectLookup.setup('getObjectKeyAndType', new List<Object>{objectId}).returns(kt);

        sut.ExpireCache(objectId);

        mockCache.verify('DeleteItems', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Twice);
    }

    @IsTest
    static void it_should_call_the_rest_service_to_get_base_url_to_build_key() {
        String keyType = 'key-type';
        String pageKey = 'page-key';
        Boolean includeRelated = true;
        String serviceBaseUrl = 'base-url';
        mockSvc.setup('GetApiResource', new list<Object>{'DocumentsUrl'}).returns(serviceBaseUrl);

        string result = sut.BuildKey(keyType, pageKey, includeRelated);

        String expectedKey = String.Format('{0}/documents/rel_nav?key_type={1}&keys={2}&include_related={3}',new string[]{serviceBaseUrl, keyType, pageKey, String.valueOf(includeRelated)});
        System.assertEquals(expectedKey ,result);
    }

    @IsTest
    static void it_should_load_document_list_when_existing_cache_is_empty() {
        String listKey = 'lst-key';
        String sortByProperty = 'Name';
        String sortByDirection = 'ASC';
        Integer pageSize = 1;
        Integer pageNumber = 1;
        String conditions = 'x';
        MockOfICachable mockDocICache = new MockOfICachable();
        RestUtility.result res = new RestUtility.result();
        res.response = '{"DrawerName":"Collateral","Email":"x@y.com"}';
        wsCache__c wsc = null;
        wsCacheItem__c wsci = new wsCacheItem__c();
        List<wsCacheItem__c> wscs = new List<wsCacheItem__c>{wsci};
        mockCache.setup('FindByKey', new List<Object>{listKey}).returns(wsc);
        mockDocICache.setup('classType', new List<Object>{listKey}).returns(Documents.ICacheable.Class);
        mockSvc.setup('GET', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(res);

        List<Documents.ICacheable> result = sut.LoadList(listKey, sortByProperty, sortByDirection, pageSize, pageNumber, conditions, mockDocICache);
        
        mockCache.verify('FindByKey', new List<Object>{listKey}, Times.Once);
        mockSvc.setup('GET', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(res);
    }

    @IsTest
    static void it_should_load_document_list_when_existing_cache_is_not_empty() {
        String listKey = 'lst-key';
        String sortByProperty = 'Name';
        String sortByDirection = 'ASC';
        Integer pageSize = 1;
        Integer pageNumber = 1;
        String conditions = 'x';
        MockOfICachable mockDocICache = new MockOfICachable();
        RestUtility.result res = new RestUtility.result();

        res.response = '{"DrawerName":"Collateral","Email":"x@y.com"}';
        wsCache__c wsc = new wsCache__c();
        wsCacheItem__c wsci = new wsCacheItem__c();
        List<wsCacheItem__c> wscs = new List<wsCacheItem__c>{wsci};
        mockCache.setup('LoadItems', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(wscs);
        mockCache.setup('FindByKey', new List<Object>{listKey}).returns(wsc);
        mockDocICache.setup('classType', new List<Object>{listKey}).returns(Documents.ICacheable.Class);

        List<Documents.ICacheable> result = sut.LoadList(listKey, sortByProperty, sortByDirection, pageSize, pageNumber, conditions, mockDocICache);
        
        mockCache.verify('FindByKey', new List<Object>{listKey}, Times.Once);
        mockCache.verify('LoadItems', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
    }

    @IsTest
    static void it_should_save_items() {
        MockOfICachable mockDocICache = new MockOfICachable();
        List<MockOfICachable> objects = new List<MockOfICachable>{mockDocICache};
        String listKey = 'list-key';

        sut.SaveList(objects, listKey);

        mockCache.verify('SaveItems', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
    }

    public class MockOfICachable extends ApexMoq implements Documents.ICacheable {
        public System.Type classType(){
            return (System.Type)handleMethodInvocation('classType');
        }
        public MockOfICachable FromCacheItem(wsCacheItem__c ch) {
            return (mockOfICachable)handleMethodInvocation('FromCacheItem', new List<Object>{ch});
        }
        public wsCacheItem__c ToCacheItem() {
            return (wsCacheItem__c)handleMethodInvocation('ToCacheItem');
        }
        public String ToCacheFieldName(String fld){
            return (String)handleMethodInvocation('ToCacheFieldName', new List<Object>{fld});
        }
    }

    public static string getJsonString(){
        return '{"DrawerName":"Collateral","Email":"rupadhya@enterprisebank.com"}';
    }
}