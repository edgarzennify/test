@IsTest
private class SchemaProviderTests {
	
    private static final SchemaProvider sut;
    private static final MockOfISchemaProviderHelper mockHelper;
    
    static {
        mockHelper = new MockOfISchemaProviderHelper();
        sut = new SchemaProvider(mockHelper);
    }

    @IsTest
    static void it_should_return_an_ISObjectField() {
        String objectName = 'some object';
        String fieldName = 'some field';

        Mock.ofISObjectField mockField = new Mock.ofISObjectField();
        Object fieldMap = new Map<String, ISObjectField>
        {
            fieldName => mockField
        };

        mockHelper.setup('getFieldMap', new List<Object>{objectName}).returns(fieldMap);

        ISObjectField results = sut.getField(objectName, fieldName.toUpperCase());

        System.assertEquals(mockField, results);
    }

    @IsTest
    static void it_should_return_a_list_of_ISObjectField() {
        String objectName = 'some object';
        String fieldName = 'some field';

        Mock.ofISObjectField mockField = new Mock.ofISObjectField();
        Object fieldMap = new Map<String, ISObjectField>
        {
            fieldName => mockField
        };

        mockHelper.setup('getFieldMap', new List<Object>{objectName}).returns(fieldMap);

        List<ISObjectField> results = sut.getFields(objectName);

        System.assertEquals(1, results.size());
        System.assertEquals(mockField, results[0]);
    }

    @IsTest
    static void it_should_return_a_map_of_string_and_ISObjectField() {
        String objectName = 'some object';
        String fieldName = 'some field';

        Mock.ofISObjectField mockField = new Mock.ofISObjectField();
        Object fieldMap = new Map<String, ISObjectField>
        {
            fieldName => mockField
        };

        mockHelper.setup('getFieldMap', new List<Object>{objectName}).returns(fieldMap);

        Map<String, ISObjectField> results = sut.getFieldMap(objectName);

        System.assertEquals(fieldMap, results);
    }

    @IsTest
    static void it_should_return_an_ISObjectType() {
        String objectName = 'some object';

        Mock.ofISObjectType mockType = new Mock.ofISObjectType();

        mockHelper.setup('getSObjectType', new List<Object>{objectName}).returns(mockType);

        ISObjectType results = sut.getSObjectType(objectName);

        System.assertEquals(mockType, results);
    }

    public class MockOfISchemaProviderHelper extends ApexMoq implements SchemaProvider.ISchemaProviderHelper{
        public Map<String, ISObjectField> getFieldMap(String objectName){
            return (Map<String, ISObjectField>)handleMethodInvocation('getFieldMap', new List<Object>{objectName});
        }
        public ISObjectType getSObjectType(String objectName){
            return (ISObjectType)handleMethodInvocation('getSObjectType', new List<Object>{objectName});
        }
        public Map<String, Schema.SObjectField> getSobjectFields(String objectName){
            return (Map<String, Schema.SObjectField>)handleMethodInvocation('getSobjectFields', new List<Object>{objectName});
        }
    }
}