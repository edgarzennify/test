@IsTest
private class SchemaProviderHelperTests {
    
    private static final SchemaProviderHelper sut;
    private static final Mock.ofISObjectFieldFactory mockFactory;
    private static final Mock.ofICachedMap mockCache;

    static {
        mockFactory = new Mock.ofISObjectFieldFactory();
        mockCache = new Mock.ofICachedMap();
        sut = new SchemaProviderHelper(mockFactory, mockCache);
    }

    @IsTest
    static void it_should_put_the_gdd_map_into_the_cache_and_convert_the_map_types_using_the_field_factory() {
        String objectName = 'Object_Action_Log__c';
        String key = 'SchemaProvider.globalDescribeResultFieldMap.' + objectName;
        
        Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
        Integer thisMany = fieldMap.keySet().size();
        Schema.SObjectField testField = fieldMap.get('action__c');

        Mock.ofISObjectField testSObjectField = new Mock.ofISObjectField();

        mockCache.setup('containsKey', new List<Object>{key}).returns(false);
        mockCache.setup('get', new List<Object>{key}).returns(fieldMap);
        mockFactory.setup('getInstance', new List<Object>{testField}).returns(testSObjectField);

    	Map<String, ISObjectField> results = sut.getFieldMap(objectName);

        mockFactory.verify('getInstance', new List<Object>{testField}, Times.Once);
        mockFactory.verify('getInstance', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Exactly(thisMany));
        mockCache.verify('put', new List<Object>{key, fieldMap}, Times.Once);
        System.assertEquals(testSObjectField, results.get('action__c'));
    }

    @IsTest
    static void it_should_put_the_gdd_map_into_the_cache_and_return_the_mapped_wrapped_sobject_type_token() {
        String objectName = 'Object_Action_Log__c';
        String key = 'SchemaProvider.globalDescribeResult.' + objectName;
        
        Schema.SObjectType type = Schema.getGlobalDescribe().get(objectName);

        Mock.ofISObjectType mockType = new Mock.ofISObjectType();
        Mock.ofIDescribesObjectResult mockObject = new Mock.ofIDescribesObjectResult();
        
        mockType.setup('getDescribe').returns(mockObject);
        mockObject.setup('getName').returns(objectName);

        mockCache.setup('containsKey', new List<Object>{key}).returns(false);
        mockCache.setup('get', new List<Object>{key}).returns(type);

        ISObjectType results = sut.getSObjectType(objectName);

        mockCache.verify('put', new List<Object>{key, type}, Times.Once);
        System.assertEquals(type.getDescribe().getName(), results.getDescribe().getName());
    }
}