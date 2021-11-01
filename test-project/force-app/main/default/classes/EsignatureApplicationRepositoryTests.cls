@IsTest
private class EsignatureApplicationRepositoryTests {

    private static EsignatureApplicationMock.ofIDataProvider mockDataProvider;
    private static EsignatureApplicationRepository sut;

    static {
        mockDataProvider = new EsignatureApplicationMock.ofIDataProvider();
        sut = new EsignatureApplicationRepository(mockDataProvider);
    }
    
    @IsTest
    static void it_should_call_the_data_provider_to_run_query() {
        List<String> fieldsForQuery = new List<String>{'Id', 'Name'};
        String objectName = 'Contact';
        String recordId = 'record-1';
        String recordIdWithTicks = '\'' + recordId + '\'';
        String query = String.Format('SELECT {0} FROM {1} WHERE id={2}', new List<String>{String.join(fieldsForQuery, ','), objectName, recordIdWithTicks});

        List<DataProvider.DynamicQueryResult> result = sut.runQuery(fieldsForQuery, objectName, recordId);

        mockDataProvider.verify('executeDynamicQuery', new List<object>{query,fieldsForQuery}, Times.Once);
    }

    @IsTest
    static void it_should_call_the_data_provider_to_build_dm_when_application_is_given() {
        String applicationId = '10';
        String objectName = 'Contact';
        String recordTypeName = 'test-object-record-type';
        String referenceType = 'Auto';
        String fieldName = 'field-name';
        String fieldNameApi = 'field-api';
        String fieldType = 'my-type';
        String roleCode = 'PS';
        Integer roleOrder = 1;
        PM_Esignature_Configuration_c pm = new PM_Esignature_Configuration_c();
        pm.Object_Name_Api_c = objectName;
        pm.Record_Type_Name_c = 'test-object-record-type';
        pm.Application_Id_c = applicationId;
        pm.Reference_Id_Type_c = referenceType;

        PM_Esignature_Configuration_Signer_c signerPm1 = new PM_Esignature_Configuration_Signer_c();
        signerPm1.Role_Code_c = roleCode;
        signerPm1.Role_Order_c = roleOrder;
        PM_Esignature_Configuration_Field_c fieldPm1 = new PM_Esignature_Configuration_Field_c();
        fieldPm1.Esignature_Configuration_Signer_r = signerPm1;
        fieldPm1.Field_Name_Api_c = fieldNameApi;
        fieldPm1.Field_Name_c = fieldName;
        fieldPm1.Field_Type_c = fieldType;

        pm.Esignature_Configuration_Fields_r = new List<PM_Esignature_Configuration_Field_c>{fieldPm1};   
        mockdataProvider.setup('getConfigurationByAppId', new List<object>{applicationId}).returns(pm);

        DmEsignatureConfigurationInfo.DmEsignatureConfiguration result =  sut.buildDm(applicationId, '');

        System.assertEquals(applicationId, result.applicationId);
        System.assertEquals('', result.salesforceRecordId);
        System.assertEquals(objectName, result.objectNameApi);
        System.assertEquals(recordTypeName, result.recordTypeName);
        System.assertEquals(referenceType, result.referenceIdType);
        System.assertEquals(1, result.fields.size());
        System.assertEquals(fieldNameApi, result.fields[0].fieldNameApi);
        System.assertEquals(fieldName, result.fields[0].fieldName);
        System.assertEquals(fieldType, result.fields[0].fieldType);
    }

    @IsTest
    static void it_should_call_the_data_provider_to_build_dm_when_application_and_salesforce_record_id_is_given() {
        String applicationId = '10';
        String salesforceRecordId = 'record-id';
       
        PM_Esignature_Configuration_c pm = new PM_Esignature_Configuration_c();
        pm.Application_Id_c = applicationId;
        mockdataProvider.setup('getConfigurationByAppId', new List<object>{applicationId}).returns(pm);

        DmEsignatureConfigurationInfo.DmEsignatureConfiguration result =  sut.buildDm(applicationId,  salesforceRecordId);
    
        System.assertEquals(applicationId, result.applicationId);
        System.assertEquals(salesforceRecordId, result.salesforceRecordId);
    }
}