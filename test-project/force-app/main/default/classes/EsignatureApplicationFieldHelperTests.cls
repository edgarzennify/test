@IsTest
private class EsignatureApplicationFieldHelperTests {

    private static EsignatureApplicationFieldHelper sut;

    static{
        sut = new EsignatureApplicationFieldHelper();
    }

    @IsTest
    private static void it_should_build_fields_without_default_values_when_isdefaultvaluerequired_is_false(){
        DmEsignatureConfigurationInfo.DmEsignatureConfiguration dm = new DmEsignatureConfigurationInfo.DmEsignatureConfiguration();
        DmEsignatureConfigurationInfo.DmEsignatureConfigurationField dmField1 = new DmEsignatureConfigurationInfo.DmEsignatureConfigurationField();
        dmField1.roleCode = 'PS';
        dmField1.roleOrder = 1;
        dmField1.fieldName = 'x';
        DmEsignatureConfigurationInfo.DmEsignatureConfigurationField dmField2 = new DmEsignatureConfigurationInfo.DmEsignatureConfigurationField();
        dmField2.fieldName = 'y';
        dm.fields = new List<DmEsignatureConfigurationInfo.DmEsignatureConfigurationField>{dmField1,dmField2};
        boolean isDafaultValueRequired = false;

        EsignatureApplication.FieldData result = sut.buildFields(dm, isDafaultValueRequired);

        System.assertEquals(1, result.SignerFields.size());
        System.assertEquals(1, result.OtherFields.size());
        System.assertEquals('x', result.SignerFields[0].label);
        System.assertEquals('y', result.OtherFields[0].label);
    }

    @IsTest
    private static void it_should_build_default_values_for_given_fields(){
        Dataprovider.DynamicQueryResult dbResult = new Dataprovider.DynamicQueryResult();
        Dataprovider.DynamicQueryFieldResult dbFieldResult = new Dataprovider.DynamicQueryFieldResult();
        dbFieldResult.fieldName = 'test-name-api-1';
        dbFieldResult.fieldValue = 'test-name';
        dbResult.sobj = new Contact();
        dbResult.fieldValues = new List<Dataprovider.DynamicQueryFieldResult>{dbFieldResult};
        List<Dataprovider.DynamicQueryResult> dbResults = new List<Dataprovider.DynamicQueryResult>{dbResult};
        DmEsignatureConfigurationInfo.DmEsignatureConfiguration dm = new DmEsignatureConfigurationInfo.DmEsignatureConfiguration();
        DmEsignatureConfigurationInfo.DmEsignatureConfigurationField dmField1 = new DmEsignatureConfigurationInfo.DmEsignatureConfigurationField();
        dmField1.identifier = '1234';
        dmField1.fieldName = 'test-name-1';
        dmField1.fieldNameApi = 'test-name-api-1';
        dmField1.fieldType = 'FirstName';
        dmField1.roleCode = 'PS';
        dmField1.roleOrder = 1;
        DmEsignatureConfigurationInfo.DmEsignatureConfigurationField dmField2 = new DmEsignatureConfigurationInfo.DmEsignatureConfigurationField();
        dmField2.identifier = '123456';
        dmField2.fieldName = 'test-name-1';
        dmField2.fieldNameApi = 'test-name-api-1';
        dmField2.fieldType = 'LastName';
        dm.fields = new List<DmEsignatureConfigurationInfo.DmEsignatureConfigurationField>{dmField1, dmField2};
        EsignatureApplication.FieldData fieldData = new EsignatureApplication.FieldData();
        EsignatureApplication.FieldLayout fld1 = new EsignatureApplication.FieldLayout();
        fld1.defaultValue = 'test-name';
        fld1.id = '1234';
        fld1.fieldType = 'FirstName';
        EsignatureApplication.FieldLayout fld2 = new EsignatureApplication.FieldLayout();
        fld2.id = '123456';
        fld2.fieldType = 'LastName';
        fieldData.SignerFields = new List<EsignatureApplication.FieldLayout>{fld1};
        fieldData.OtherFields = new List<EsignatureApplication.FieldLayout>{fld2};
        Map<string, string> fieldMap = new Map<string, string>();
        fieldMap.put('test-name-api-1','1234');

        EsignatureApplication.FieldData result = sut.BuildFieldWithDefaultValues(dbResults, dm, fieldData, fieldMap);

        System.assertEquals(1, result.SignerFields.size());
        System.assertEquals(1, result.OtherFields.size());
        System.assertEquals('test-name', result.SignerFields[0].defaultValue);
    }

    @IsTest
    private static void it_should_build_request(){
        DmEsignatureConfigurationInfo.DmEsignatureConfiguration dm = new DmEsignatureConfigurationInfo.DmEsignatureConfiguration();
        DmEsignatureConfigurationInfo.DmEsignatureConfigurationField fld = new DmEsignatureConfigurationInfo.DmEsignatureConfigurationField();
        fld.fieldNameApi = 'Name-1';
        fld.salesforceNameApi = 'Name';
        fld.identifier = '1234';
        dm.fields = new List<DmEsignatureConfigurationInfo.DmEsignatureConfigurationField>{fld};

        EsignatureApplication.FieldDefaultValueRequest result = sut.buildRequest(dm);

        System.assertEquals(new List<string>{'Name'}, result.FieldsForQuery);
        System.assertEquals(new Map<string,string>{'Name' => '1234'}, result.FieldMap); 
    }

}