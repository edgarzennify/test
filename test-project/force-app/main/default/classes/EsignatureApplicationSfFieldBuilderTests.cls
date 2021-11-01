@IsTest
private class EsignatureApplicationSfFieldBuilderTests {

    private static EsignatureApplicationSfFieldBuilder sut;
    private static EsignatureApplicationMock.ofIFieldHelper mockFieldHelper;
    private static EsignatureApplicationMock.ofIRepository mockRepository;

    static {
        mockFieldHelper = new EsignatureApplicationMock.ofIFieldHelper();
        mockRepository = new EsignatureApplicationMock.ofIRepository();
        sut = new EsignatureApplicationSfFieldBuilder(mockFieldHelper, mockRepository);
    }

    @IsTest
    static void it_should_return_true_when_reference_type_is_salesforce_and_salesforce_id_is_not_empty() {
        DmEsignatureConfigurationInfo.DmEsignatureConfiguration dm = new DmEsignatureConfigurationInfo.DmEsignatureConfiguration();
        dm.referenceIdType = 'salesforce record id';
        dm.salesforceRecordId = 'x';

        boolean result = sut.handle(dm);

        System.assertEquals(true, result);
    }

    @IsTest
    static void it_should_return_false_when_reference_type_is_salesforce_and_salesforce_id_empty() {
        DmEsignatureConfigurationInfo.DmEsignatureConfiguration dm = new DmEsignatureConfigurationInfo.DmEsignatureConfiguration();
        dm.referenceIdType = 'salesforce record id';
        dm.salesforceRecordId = '';

        boolean result = sut.handle(dm);

        System.assertEquals(false, result);
    }

    @IsTest
    static void it_should_call_the_helper_to_build_fields() {
        DmEsignatureConfigurationInfo.DmEsignatureConfiguration dm = new DmEsignatureConfigurationInfo.DmEsignatureConfiguration();
        DmEsignatureConfigurationInfo.DmEsignatureConfigurationField dmField = new DmEsignatureConfigurationInfo.DmEsignatureConfigurationField();
        dm.fields = new List<DmEsignatureConfigurationInfo.DmEsignatureConfigurationField>{dmField};
        EsignatureApplication.FieldDefaultValueRequest defaultValueRequest = new EsignatureApplication.FieldDefaultValueRequest();
        defaultValueRequest.FieldMap = new Map<string,string>{'' => ''};
        defaultValueRequest.FieldsForQuery = new List<string>{''};
        mockFieldHelper.setup('buildRequest', new List<Object>{dm}).returns(defaultValueRequest);

        EsignatureApplication.FieldData result =  sut.buildFields(dm);

        mockFieldHelper.verify('buildFields', new List<Object>{dm,true}, Times.Once);
    }

    @IsTest
    static void it_should_call_the_dataprovider_to_run_the_query_on_sf_object() {
        DmEsignatureConfigurationInfo.DmEsignatureConfiguration dm = new DmEsignatureConfigurationInfo.DmEsignatureConfiguration();
        dm.objectNameApi = 'Contact';
        dm.salesforceRecordId = 'sf-id';
        DmEsignatureConfigurationInfo.DmEsignatureConfigurationField dmField = new DmEsignatureConfigurationInfo.DmEsignatureConfigurationField();
        dmField.identifier = '1';
        dmField.salesforceNameApi = 'sf_fld_name__c';
        dmField.fieldName = 'name';
        
        dm.fields = new List<DmEsignatureConfigurationInfo.DmEsignatureConfigurationField>{dmField};
        EsignatureApplication.FieldData fieldData = new EsignatureApplication.FieldData();
        EsignatureApplication.FieldDefaultValueRequest defaultValueRequest = 
                                                new EsignatureApplication.FieldDefaultValueRequest();
        defaultValueRequest.FieldMap = new Map<string,string>{'sf_fld_name__c' => '1'};
        defaultValueRequest.FieldsForQuery = new List<string>{'sf_fld_name__c'};
        mockFieldHelper.setup('buildRequest', new List<Object>{dm}).returns(defaultValueRequest);
        mockFieldHelper.setup('buildFields', new List<Object>{dm,true}).returns(fieldData);
        
        EsignatureApplication.FieldData result =  sut.buildFields(dm);

        mockRepository.verify('runQuery', new List<Object>{defaultValueRequest.FieldsForQuery, dm.objectNameApi, dm.salesforceRecordId}, Times.Once);
    }

    @IsTest
    static void it_should_call_the_helper_to_update_fielddata_with_default_values() {
        DmEsignatureConfigurationInfo.DmEsignatureConfiguration dm = new DmEsignatureConfigurationInfo.DmEsignatureConfiguration();
        dm.objectNameApi = 'Contact';
        dm.salesforceRecordId = 'sf-id';
        DmEsignatureConfigurationInfo.DmEsignatureConfigurationField dmField = new DmEsignatureConfigurationInfo.DmEsignatureConfigurationField();
        dmField.salesforceNameApi = 'sf_fld_name__c';
        dmField.fieldName = 'name';
        
        dm.fields = new List<DmEsignatureConfigurationInfo.DmEsignatureConfigurationField>{dmField};
        EsignatureApplication.FieldData fieldData = new EsignatureApplication.FieldData();

        DataProvider.DynamicQueryResult queryResult = new DataProvider.DynamicQueryResult();
        queryResult.sobj = new Contact();
        DataProvider.DynamicQueryFieldResult queryFieldResult = new DataProvider.DynamicQueryFieldResult();
        queryFieldResult.fieldName = 'sf_fld_name__c';
        queryFieldResult.fieldValue = 'test';
        queryResult.fieldValues = new List<DataProvider.DynamicQueryFieldResult>{queryFieldResult};
        List<DataProvider.DynamicQueryResult> queryResults = new List<DataProvider.DynamicQueryResult>{queryResult};
        EsignatureApplication.FieldDefaultValueRequest defaultValueRequest = 
                                                new EsignatureApplication.FieldDefaultValueRequest();
        defaultValueRequest.FieldMap = new Map<string,string>{'sf_fld_name__c' => '1'};
        defaultValueRequest.FieldsForQuery = new List<string>{'sf_fld_name__c'};
        mockRepository.setup('runQuery', new List<Object>{defaultValueRequest.FieldsForQuery, 
                                    dm.objectNameApi, dm.salesforceRecordId}).returns(queryResults);
        mockFieldHelper.setup('buildRequest', new List<Object>{dm}).returns(defaultValueRequest);
        mockFieldHelper.setup('buildFields', new List<Object>{dm,true}).returns(fieldData);
        
        EsignatureApplication.FieldData result =  sut.buildFields(dm);

        mockFieldHelper.verify('BuildFieldWithDefaultValues', new List<Object>{queryResults,dm,fieldData, defaultValueRequest.FieldMap}, Times.Once);
    }
}