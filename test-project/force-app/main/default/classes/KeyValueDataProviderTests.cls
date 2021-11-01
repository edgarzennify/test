@IsTest
private class KeyValueDataProviderTests {
    
    private static final KeyValueDataProvider sut;
    private static final Mock.ofICachedMap mockCache;

    static {
        mockCache = new Mock.ofICachedMap();
        sut = new KeyValueDataProvider(mockCache);
    }

    @IsTest
    static void INTEGRATION_it_should_return_a_value_when_given_a_valid_key_regardless_of_keys_case() {
        Schema.SObjectType soType = TriggerBreaker__mdt.SObjectType;
        String key = 'Llc_BI__LoAn__C';
        String cacheKey = String.valueOf(soType) + key;

        mockCache
            .setup('containsKey', new List<Object>{cacheKey})
            .returns(false);

        Object results = sut.get(soType, key);

        System.assertEquals(true, results);
    }

    @IsTest
    static void INTEGRATION_it_should_return_a_stored_map_from_the_cache() {
        Schema.SObjectType soType = TriggerBreaker__mdt.SObjectType;
        String key = 'LLC_BI__Loan__c';
        String cacheKey = String.valueOf(soType) + key;
        
        Map<String, Object> cachedMap = new Map<String, Object>();
        cachedMap.put('LLC_BI__LOAN__C', true);

        mockCache
            .setupSequence('containsKey', new List<Object>{cacheKey})
            .returns(false)
            .returns(true);

        mockCache
            .setup('get', new List<Object>{cacheKey})
            .returns(cachedMap);
        //first pass, configs are loaded into cache
        sut.get(soType, key);
        //second pass, configs are pulled from cache
        Object results = sut.get(soType, key);

        mockCache.verify('put', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
        mockCache.verify('get', new List<Object>{cacheKey}, Times.Once);
        System.assertEquals(true, results);
    }
    
    @IsTest
    static void INTEGRATION_it_should_throw_an_exception_when_the_key_is_not_found_in_the_map() {
        Schema.SObjectType soType = TriggerBreaker__mdt.SObjectType;
        String key = 'invalid key';
        String cacheKey = String.valueOf(soType) + key;

        mockCache
            .setup('containsKey', new List<Object>{cacheKey})
            .returns(false);

        try {
            Object results = sut.get(soType, key);
            System.assert(false, 'It should have thrown an exception.');
        } catch (ApplicationException ae) {
            System.assert(true);
        } catch (Exception e) {
            System.assert(false, 'It threw the wrong type of exception.');
        }
    }
}