@IsTest
private class EsignatureApplicationVmBuilderTests {

    private final static EsignatureApplicationMock.ofIFieldBuilder mockFieldBuilder1;
    private final static EsignatureApplicationMock.ofIFieldBuilder mockFieldBuilder2;
    private final static Mock.ofIUtility mockUtility;
    private static EsignatureApplicationVmBuilder sut;

    static{
        mockFieldBuilder1 = new EsignatureApplicationMock.ofIFieldBuilder();
        mockFieldBuilder2 = new EsignatureApplicationMock.ofIFieldBuilder();
        mockUtility = new Mock.ofIUtility();
        sut = new EsignatureApplicationVmBuilder(new List<EsignatureApplicationMock.ofIFieldBuilder>{mockFieldBuilder1, mockFieldBuilder2}, mockUtility);
    }

    @IsTest
    private static void it_should_build_form_vm(){
        boolean hasPermission = true;
        DmEsignatureConfigurationInfo.DmEsignatureConfiguration dm = new DmEsignatureConfigurationInfo.DmEsignatureConfiguration();
        dm.applicationId = '7';
        dm.name = 'my app';
        dm.department = 'my department';
        dm.referenceIdType = 'Auto';

        DmEsignatureConfigurationInfo.DmEsignatureConfigurationField f1 = new DmEsignatureConfigurationInfo.DmEsignatureConfigurationField();
        f1.fieldName = 'First Name';
        f1.fieldNameApi = 'First_Name';
        f1.fieldType = 'First_Name';
        f1.identifier = '1';
        f1.roleCode = 'PS';
        f1.roleOrder = 1;
        f1.sortOrder = 1;
        DmEsignatureConfigurationInfo.DmEsignatureConfigurationField f2 = new DmEsignatureConfigurationInfo.DmEsignatureConfigurationField();
        f2.fieldName = 'Last Name';
        f2.fieldNameApi = 'Last_Name';
        f2.fieldType = 'Last_Name';
        f2.identifier = '2';
        f2.roleCode = 'PS';
        f2.roleOrder = 1;
        f2.sortOrder = 2;
        DmEsignatureConfigurationInfo.DmEsignatureConfigurationField f3 = new DmEsignatureConfigurationInfo.DmEsignatureConfigurationField();
        f3.fieldName = 'Email';
        f3.fieldNameApi = 'Email';
        f3.fieldType = 'Email';
        f3.identifier = '3';
        f3.roleCode = 'PS';
        f3.roleOrder = 1;
        f3.sortOrder = 3;
        DmEsignatureConfigurationInfo.DmEsignatureConfigurationField f4 = new DmEsignatureConfigurationInfo.DmEsignatureConfigurationField();
        f4.fieldName = 'Pin';
        f4.fieldNameApi = 'Pin';
        f4.fieldType = 'Pin';
        f4.identifier = '4';
        f4.roleCode = 'PS';
        f4.roleOrder = 1;
        f4.sortOrder = 4;
        DmEsignatureConfigurationInfo.DmEsignatureConfigurationField f5 = new DmEsignatureConfigurationInfo.DmEsignatureConfigurationField();
        f5.fieldName = 'title';
        f5.fieldNameApi = 'title';
        f5.fieldType = '';
        f5.identifier = '5';
        f5.sortOrder = 1;
  
        dm.fields = new List<DmEsignatureConfigurationInfo.DmEsignatureConfigurationField>{f1,f2,f3,f4,f5};
        EsignatureApplication.FieldLayout fl1 = new EsignatureApplication.FieldLayout();
        EsignatureApplication.FieldLayout fl2 = new EsignatureApplication.FieldLayout();
        EsignatureApplication.FieldLayout fl3 = new EsignatureApplication.FieldLayout();
        EsignatureApplication.FieldLayout fl4 = new EsignatureApplication.FieldLayout();
        EsignatureApplication.FieldLayout fl5 = new EsignatureApplication.FieldLayout();
        List<EsignatureApplication.FieldLayout> signatureFields = new List<EsignatureApplication.FieldLayout>{fl1,fl2,fl3,fl4};
        List<EsignatureApplication.FieldLayout> otherFields = new List<EsignatureApplication.FieldLayout>{fl5};

        EsignatureApplication.FieldData fieldData = new EsignatureApplication.FieldData();

        fieldData.SignerFields = new List<EsignatureApplication.FieldLayout>{fl1,fl2,fl3,fl4};
        fieldData.OtherFields = new List<EsignatureApplication.FieldLayout>{fl5};
        mockFieldBuilder1.setup('buildSignerFields', new List<object>{dm}).returns(signatureFields);
        mockFieldBuilder1.setup('buildOtherFields', new List<object>{dm}).returns(otherFields);
        mockFieldBuilder1.setup('handle', new List<Object>{dm}).returns(true);
        mockFieldBuilder1.setup('buildFields', new List<object>{dm}).returns(fieldData);

        EsignatureApplication.FormVm result = sut.build(dm, hasPermission);

        System.assertEquals('my app', result.applicationName);
        System.assertEquals('my department', result.department);
        System.assertEquals(true, result.hasPermission);
        System.assertEquals(4, result.signerFields.size());
        System.assertEquals(1, result.otherFields.size());
    }

    @IsTest
    private static void it_should_build_signature_data_from_received_proxy_response(){
        DigitalSignatureFormGeneratorProxy.SignatureStatusDataResponse response = new DigitalSignatureFormGeneratorProxy.SignatureStatusDataResponse();
        DigitalSignatureFormGeneratorProxy.SignatureStatusDataItemResponse item = new DigitalSignatureFormGeneratorProxy.SignatureStatusDataItemResponse();
        item.ApplicationId = 7;
        item.Name = 'test';
        item.TransactionId = '1122223';
        item.SecurityPin = '1111';
        item.UserId = 'user-id';
        response.Items = new List<DigitalSignatureFormGeneratorProxy.SignatureStatusDataItemResponse>{item};
        
        EsignatureApplication.SignatureData result =  sut.Build(response);

        System.assertEquals(1, result.items.size());
        System.assertEquals('test', result.items[0].name);
        System.assertEquals('1111', result.items[0].securityPin);
    }
}