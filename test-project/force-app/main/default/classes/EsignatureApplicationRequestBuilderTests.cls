@IsTest
private class EsignatureApplicationRequestBuilderTests {

    private static Mock.ofISystem mockSystem;
    private static Mock.ofIEncodingUtil mockEutil;
    private static EsignatureApplicationRequestBuilder sut;

    static{
        mockSystem = new Mock.ofISystem();
        mockEutil = new Mock.ofIEncodingUtil();
        sut = new EsignatureApplicationRequestBuilder(mockSystem, mockEutil);
    }

    @IsTest
    private static void it_should_use_system_time_to_build_referenceid(){
        string userId = '1234';
        DmEsignatureConfigurationInfo.DmEsignatureConfiguration dm = new DmEsignatureConfigurationInfo.DmEsignatureConfiguration();
        dm.applicationId = '7';
        dm.signatureDocumentName = 'doc';
        dm.templateFileName = 'x.html';
        dm.isPdf = false;

        DmEsignatureConfigurationInfo.DmEsignatureConfigurationField f = new DmEsignatureConfigurationInfo.DmEsignatureConfigurationField();
        f.fieldName = 'test';
        dm.fields = new List<DmEsignatureConfigurationInfo.DmEsignatureConfigurationField>{f};
        EsignatureApplication.SaveModel sm = new EsignatureApplication.SaveModel();
        sm.saveData = new List<EsignatureApplication.SaveModelElement>();
        DateTime dt = DateTime.newInstance(2020, 1, 1, 1, 2, 3);
        string dtMilliseconds = String.valueof(dt.getTime());
        mockSystem.setup('now').returns(dt);
 
        DigitalSignatureFormGeneratorProxy.SignatureRequest result = sut.buildRequest(dm, userId, '', sm);

        system.assertEquals('7-'+dtMilliseconds, result.ReferenceId);
        system.assertEquals(7, result.ApplicationId);
        system.assertEquals(false, result.IsTemplatePdf);
        system.assertEquals('x.html', result.TemplateFileName);
    }

    @IsTest
    private static void it_should_build_data_for_template(){
        DmEsignatureConfigurationInfo.DmEsignatureConfiguration dm = new DmEsignatureConfigurationInfo.DmEsignatureConfiguration();
        dm.applicationId = '7';
        DmEsignatureConfigurationInfo.DmEsignatureConfigurationField f = new DmEsignatureConfigurationInfo.DmEsignatureConfigurationField();
        f.fieldName = 'test';
        f.fieldNameApi = 'test-api';
        f.identifier = '1';
        
        dm.fields = new List<DmEsignatureConfigurationInfo.DmEsignatureConfigurationField>{f};
        EsignatureApplication.SaveModel sm = new EsignatureApplication.SaveModel();
        EsignatureApplication.SaveModelElement sme = new EsignatureApplication.SaveModelElement();
        sme.fieldId = '1';
        sme.fieldValue = 'test-value';
        sm.saveData = new List<EsignatureApplication.SaveModelElement>{sme};
        string userId = '1234';
        DateTime dt = DateTime.newInstance(2020, 1, 1, 1, 2, 3);
        string dtMilliseconds = String.valueof(dt.getTime());
        mockSystem.setup('now').returns(dt);
 
        DigitalSignatureFormGeneratorProxy.SignatureRequest result = sut.buildRequest(dm, userId,'', sm);

        System.assertEquals(1, result.Data.keySet().size());
        System.assertEquals('test-value', result.Data.get('test-api'));
    }

    @IsTest
    private static void it_should_build_signers_for_template(){
        DmEsignatureConfigurationInfo.DmEsignatureConfiguration dm = new DmEsignatureConfigurationInfo.DmEsignatureConfiguration();
        dm.applicationId = '7';
        
        DmEsignatureConfigurationInfo.DmEsignatureConfigurationField f1 = new DmEsignatureConfigurationInfo.DmEsignatureConfigurationField();
        f1.fieldName = 'First Name';
        f1.fieldNameApi = 'First_Name';
        f1.fieldType = 'First_Name';
        f1.identifier = '1';
        f1.roleCode = 'PS';
        f1.roleOrder = 1;
        DmEsignatureConfigurationInfo.DmEsignatureConfigurationField f2 = new DmEsignatureConfigurationInfo.DmEsignatureConfigurationField();
        f2.fieldName = 'Last Name';
        f2.fieldNameApi = 'Last_Name';
        f2.fieldType = 'Last_Name';
        f2.identifier = '2';
        f2.roleCode = 'PS';
        f2.roleOrder = 1;
        DmEsignatureConfigurationInfo.DmEsignatureConfigurationField f3 = new DmEsignatureConfigurationInfo.DmEsignatureConfigurationField();
        f3.fieldName = 'Email';
        f3.fieldNameApi = 'Email';
        f3.fieldType = 'Email';
        f3.identifier = '3';
        f3.roleCode = 'PS';
        f3.roleOrder = 1;
        DmEsignatureConfigurationInfo.DmEsignatureConfigurationField f4 = new DmEsignatureConfigurationInfo.DmEsignatureConfigurationField();
        f4.fieldName = 'Pin';
        f4.fieldNameApi = 'Pin';
        f4.fieldType = 'Pin';
        f4.identifier = '4';
        f4.roleCode = 'PS';
        f4.roleOrder = 1;
        
        dm.fields = new List<DmEsignatureConfigurationInfo.DmEsignatureConfigurationField>{f1,f2,f3,f4};
        Map<string,string> sms = new Map<string,string>{'1' => 'test-first-name', '2'=>'test-last-name', '3'=>'test-email', '4'=>'test-pin'};
        EsignatureApplication.SaveModel sm = new EsignatureApplication.SaveModel();
        EsignatureApplication.SaveModelElement sme1 = new EsignatureApplication.SaveModelElement();
        sme1.fieldId = '1';
        sme1.fieldValue = 'test-first-name';
        EsignatureApplication.SaveModelElement sme2 = new EsignatureApplication.SaveModelElement();
        sme2.fieldId = '2';
        sme2.fieldValue = 'test-last-name';
        EsignatureApplication.SaveModelElement sme3 = new EsignatureApplication.SaveModelElement();
        sme3.fieldId = '3';
        sme3.fieldValue = 'test-email';
        EsignatureApplication.SaveModelElement sme4 = new EsignatureApplication.SaveModelElement();
        sme4.fieldId = '4';
        sme4.fieldValue = 'test-pin';
        sm.saveData = new List<EsignatureApplication.SaveModelElement>{sme1,sme2,sme3,sme4};
        string userId = '1234';
        DateTime dt = DateTime.newInstance(2020, 1, 1, 1, 2, 3);
        string dtMilliseconds = String.valueof(dt.getTime());

        mockSystem.setup('now').returns(dt);
 
        DigitalSignatureFormGeneratorProxy.SignatureRequest result = sut.buildRequest(dm, userId,'', sm);

        System.assertEquals(1, result.Signers.size());
        System.assertEquals('test-first-name',  result.Signers[0].FirstName);
        System.assertEquals('test-last-name',  result.Signers[0].LastName);
        System.assertEquals('test-email',  result.Signers[0].Email);
        System.assertEquals('test-pin',  result.Signers[0].Security);
    }

}