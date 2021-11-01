@IsTest
private class LookupHelperTests {

    private static Mock.ofISchema mockSchema;
    private static LookupHelper sut;

    static{
        mockSchema = new Mock.ofISchema();
        sut = new LookupHelper(mockSchema);
    }

    @IsTest
    private static void it_should_build_lookup_query_when_sobject_search_and_fields_are_provided(){

        String referenceSObject = 'User';
        String search = 'GenericBank';
        List<String> lookupFields = new List<String>{'Id', 'Name'};
        String selectQuery = 'SELECT Id,Name FROM User WHERE  Name LIKE '+ '\'%' + String.escapeSingleQuotes('GenericBank') + '%\'' + ' ';

        String result = sut.buildQuery(search, lookupFields, referenceSObject);

        System.assertEquals(selectQuery, result);
    }

    @IsTest
    private static void it_should_find_the_reference_sobject_name_from_lookup_field() {
        String sObjectName = 'TM_Service_Request__c';
        String lookupFieldName = 'CreatedBy';
        String refSObjectName = 'User';
        Mock.ofISObjectType mockSObjectType = new Mock.ofISObjectType();
        Mock.ofISObjectType mockRefSObjectType = new Mock.ofISObjectType();
        List<Mock.ofISObjectType> mockRefSObjectTypes = new List<Mock.ofISObjectType>{mockRefSObjectType};

        Mock.ofIDescribesObjectResult mockSObjectResult = new Mock.ofIDescribesObjectResult();
        Mock.ofIDescribesObjectResult mockRefSObjectResult = new Mock.ofIDescribesObjectResult();

        mockRefSObjectResult.setup('getName').returns(refSObjectName);
        mockRefSObjectType.setup('getDescribe').returns(mockRefSObjectResult);
        List<Mock.ofIDescribesObjectResult> mockRefSObjectResultList = new List<Mock.ofIDescribesObjectResult>{mockRefSObjectResult};
        Mock.ofIDescribeFieldResult fieldResult = new Mock.ofIDescribeFieldResult();
        fieldResult.setup('getReferenceTo').returns(mockRefSObjectTypes);
        mockSObjectResult.setup('getFieldResult', new List<Object>{lookupFieldName}).returns(fieldResult);
        mockSObjectType.setup('getDescribe').returns(mockSObjectResult);
        mockSchema.setup('getSObjectType', new List<Object>{sObjectName}).returns(mockSObjectType);

        string result = sut.getReferenceObjectFromField(sObjectName, lookupFieldName);

        System.assertEquals('User', result);
    }


    @IsTest
    private static void it_should_build_response_when_dataprovider_result_is_given_and_the_lookup_metadata(){
        String lookupField = 'rajiv';
        String sObjectName = 'TM_Service_Request__c';
        String referenceObjectName = 'User';
        Object name = 'GenericBank User';
        DataProvider.DynamicQueryFieldResult dbResult = new DataProvider.DynamicQueryFieldResult();
        dbResult.fieldName = 'Name';
        dbResult.fieldValue = name;
        List<DataProvider.DynamicQueryFieldResult> dbResults = new List<DataProvider.DynamicQueryFieldResult>{dbResult};

        Lookup.Response result = sut.buildResponse(lookupField, sObjectName, referenceObjectName, dbResults);

        System.assertEquals(referenceObjectName, result.LookupSObjectName);
        System.assertEquals(sObjectName, result.SObjectName);
        System.assertEquals(lookupField, result.LookupFieldName);
        System.assertEquals(name, result.fieldNameValues.get('Name'));

    }

}