@IsTest
private class EsignatureApplicationDataProviderTests {

    private static  EsignatureApplicationDataProvider sut;
    static {
        sut = new EsignatureApplicationDataProvider();
    }

    @IsTest
    private static void it_should_get_one_configuration_when_application_is_provided(){
        Esignature_Configuration__c pm = new Esignature_Configuration__c();
        pm.name = 'test';
        pm.Application_Id__c = '1';
        insert pm;

        PM_Esignature_Configuration_c result = sut.getConfigurationByAppId('1');

        Object x = result.Name;
        x = result.Esign_Application_Url_c;
        x = result.Is_Template_Pdf_c;
        x = result.Template_File_Name_c;
        x = result.Transaction_Name_c;
        x = result.Department_c;
        x = result.Is_Active_c;

        System.assertEquals('test', result.name);
    }

    @IsTest
    private static void it_should_get_all_esign_configurations(){
        Esignature_Configuration__c pm = new Esignature_Configuration__c();
        pm.name = 'test';
        pm.Application_Id__c = '1';
        insert pm;

        List<PM_Esignature_Configuration_c> result = sut.getConfigurations();

        Object x = result[0].Name;
        x = result[0].Application_Id_c;
        x = result[0].Is_Template_Pdf_c;
        x = result[0].PermissionSet_c;
        x = result[0].Template_File_Name_c;
        x = result[0].Transaction_Name_c;
        x = result[0].Department_c;
        x = result[0].Is_Active_c;

        System.assertEquals('test', result[0].name);
    }
}