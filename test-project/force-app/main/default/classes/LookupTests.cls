@IsTest
private class LookupTests {

    private static LookupMock.ofIHelper mockHelper;
    private static Mock.ofIDataprovider mockDataProvider;
    private static Lookup sut;

    static{
        mockHelper = new LookupMock.ofIHelper();
        mockDataProvider = new Mock.ofIDataprovider();
        sut = new Lookup(mockHelper, mockDataProvider);
    }

    @IsTest
    private static void it_should_call_the_helper_to_search_in_fields_and_build_response(){
        String sObjectName = 'TM_Service_Request__c';
        String lookupField = 'CreatedBy';
        String searchItem = 'GenericBank';
        String referenceObjectName = 'User';
        List<string> searchInFields = new List<String>{'Id', 'Name'};
        String query = 'SELECT Id, Name FROM User WHERE Name like ' + '%GenericBank%';
        Lookup.Request req = new Lookup.Request();
        req.sObjectName = sObjectName;
        req.LookupField = lookupField;
        req.SearchItem = searchItem;
        req.SearchInFields = searchInFields;
        DataProvider.DynamicQueryResult queryResult = new DataProvider.DynamicQueryResult();
        DataProvider.DynamicQueryFieldResult fieldResult = new DataProvider.DynamicQueryFieldResult();
        fieldResult.fieldName = 'Name';
        fieldResult.fieldValue = (Object)'GenericBank User';
        queryResult.fieldValues = new List<DataProvider.DynamicQueryFieldResult>{fieldResult};
        List<DataProvider.DynamicQueryResult> queryResults = new List<DataProvider.DynamicQueryResult>{queryResult};
        Lookup.Response response = new Lookup.Response();
        response.fieldNameValues = new Map<String, Object>{'Id' => (object) '2232323','Name' => (object)'GenericBank User'};
        mockHelper.setup('getReferenceObjectFromField', new List<Object>{sObjectName, lookupField}).returns(referenceObjectName);
        mockHelper.setup('buildQuery', new List<Object>{searchItem, searchInFields, referenceObjectName}).returns(query);
        mockDataProvider.setup('executeDynamicQuery', new List<Object>{query, searchInFields}).returns(queryResults);
        mockHelper.setup('buildResponse', new List<Object>{lookupField,sObjectName,referenceObjectName,queryResult.fieldValues}).returns(response);

        List<Lookup.Response> result = sut.searchInFields(req);
        
        System.assertEquals(true,((String)result[0].fieldNameValues.get('Name')).contains('GenericBank'));
        System.assertEquals(true,((String)result[0].fieldNameValues.get('Name')).contains('User'));
    }

    @IsTest
    private static void it_should_accept_a_search_item_lookup_field_and_sobjectname_to_lookup_in_name_field(){
        String sObjectName = 'TM_Service_Request__c';
        String lookupField = 'CreatedBy';
        String searchItem = 'GenericBank';
        String referenceObjectName = 'User';
        List<string> searchInFields = new List<String>{'Id', 'Name'};
        String query = 'SELECT Id, Name FROM User WHERE Name like ' + '%GenericBank%';
        Lookup.Request req = new Lookup.Request();
        req.sObjectName = sObjectName;
        req.LookupField = lookupField;
        req.SearchItem = searchItem;
        req.SearchInFields = searchInFields;
        DataProvider.DynamicQueryResult queryResult = new DataProvider.DynamicQueryResult();
        DataProvider.DynamicQueryFieldResult fieldResult = new DataProvider.DynamicQueryFieldResult();
        fieldResult.fieldName = 'Name';
        fieldResult.fieldValue = (Object)'GenericBank User';
        queryResult.fieldValues = new List<DataProvider.DynamicQueryFieldResult>{fieldResult};
        List<DataProvider.DynamicQueryResult> queryResults = new List<DataProvider.DynamicQueryResult>{queryResult};
        Lookup.Response response = new Lookup.Response();
        response.fieldNameValues = new Map<String, Object>{'Id' => (object) '2232323','Name' => (object)'GenericBank User'};
        mockHelper.setup('getReferenceObjectFromField', new List<Object>{sObjectName, lookupField}).returns(referenceObjectName);
        mockHelper.setup('buildQuery', new List<Object>{searchItem, searchInFields, referenceObjectName}).returns(query);
        mockDataProvider.setup('executeDynamicQuery', new List<Object>{query, searchInFields}).returns(queryResults);
        mockHelper.setup('buildResponse', new List<Object>{lookupField,sObjectName,referenceObjectName,queryResult.fieldValues}).returns(response);

        List<Lookup.Response> result = sut.search(sObjectName, lookupField, searchItem);

        System.assertEquals(true,((String)result[0].fieldNameValues.get('Name')).contains('GenericBank'));
        System.assertEquals(true,((String)result[0].fieldNameValues.get('Name')).contains('User'));
    }



}