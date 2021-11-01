@IsTest
public class ConfigurationsTests {

    private static final Configurations sut;
    private static final Mock.ofIKeyValueDataProvider mockDataProvider;

    static {
        mockDataProvider = new MOck.ofIKeyValueDataProvider();
        sut = new Configurations(mockDataProvider);
    }

    @IsTest
    static void it_should_get_a_known_config_from_app_settings_metadata() {
        String key = 'serviceBaseUrl';
        Schema.SObjectType soType = AppSetting__mdt.SObjectType;

        mockDataProvider.setup('get', new List<Object>{soType, key}).returns('returned string');

        String results = sut.get(key);

        mockDataProvider.verify('get', new List<Object>{soType, key});
        System.assertEquals('returned string', results);
    }

    @IsTest
    static void it_should_return_a_known_config_when_given_a_type_and_key() {
        String key = 'test key';
        Schema.SObjectType soType = AppSetting__mdt.SObjectType;

        mockDataProvider.setup('get', new List<Object>{soType, key}).returns('returned string');

        //Overloaded get method that accepts two arguments -- JELLISON 10/29/2020
        Object results = sut.get(soType, key);

        System.assertEquals('returned string', (String)results);
    }
    
    @IsTest
    static void LEGACY_getRelationshipReviewRequiredGracePeriod_it_should_get_a_known_config_from_app_settings_metadata() {
        String key = 'RelationshipReviewReqdGracePeriod';

        mockDataProvider.setup('get', new List<Object>{AppSetting__mdt.SObjectType, key}).returns('4');

        Integer results = sut.getRelationshipReviewRequiredGracePeriod();

        System.assertEquals(4, results);
    }

    @IsTest
    static void LEGACY_getDefaultRelationshipOversightApprover_it_should_get_a_known_config_from_app_settings_metadata() {
        String key = 'DefaultRelationshipOversightApprover';

        mockDataProvider.setup('get', new List<Object>{AppSetting__mdt.SObjectType, key}).returns('asdf');

        String results = sut.getDefaultRelationshipOversightApprover();

        System.assertEquals('asdf', results);
    }

    @IsTest
    static void LEGACY_isSandbox_it_should_get_a_known_config_from_app_settings_metadata() {
        String key = 'IsSandbox';

        mockDataProvider.setup('get', new List<Object>{AppSetting__mdt.SObjectType, key}).returns('true');

        Boolean results = sut.IsSandbox();

        System.assertEquals(true, results);
    }

    @IsTest
    static void LEGACY_creditRelationshipReportId_it_should_get_a_known_config_from_app_settings_metadata() {
        String key = 'CreditRelationshipReportId';

        mockDataProvider.setup('get', new List<Object>{AppSetting__mdt.SObjectType, key}).returns('4');

        Integer results = sut.creditRelationshipReportId();

        System.assertEquals(4, results);
    }

    @IsTest
    static void LEGACY_creditRelationshipOreoReportId_it_should_get_a_known_config_from_app_settings_metadata() {
        String key = 'CreditRelationshipOREOReportId';

        mockDataProvider.setup('get', new List<Object>{AppSetting__mdt.SObjectType, key}).returns('4');

        Integer results = sut.creditRelationshipOreoReportId();

        System.assertEquals(4, results);
    }

    @IsTest
    static void LEGACY_baseReportUrl_it_should_get_a_known_config_from_app_settings_metadata() {
        String key = 'BaseReportUrl';

        mockDataProvider.setup('get', new List<Object>{AppSetting__mdt.SObjectType, key}).returns('asdf');

        String results = sut.baseReportUrl();

        System.assertEquals('asdf', results);
    }

    @IsTest
    static void LEGACY_certificateName_it_should_get_a_known_config_from_app_settings_metadata() {
        String key = 'clientCertificateName';

        mockDataProvider.setup('get', new List<Object>{AppSetting__mdt.SObjectType, key}).returns('asdf');

        String results = sut.certificateName();

        System.assertEquals('asdf', results);
    }

    @IsTest
    static void LEGACY_restServiceBaseUrl_it_should_get_a_known_config_from_app_settings_metadata() {
        String key = 'serviceBaseUrl';

        mockDataProvider.setup('get', new List<Object>{AppSetting__mdt.SObjectType, key}).returns('asdf');

        String results = sut.restServiceBaseUrl();

        System.assertEquals('asdf', results);
    }

    @IsTest
    static void LEGACY_barcodeGeneratorUploadDrawerName_it_should_get_a_known_config_from_app_settings_metadata() {
        String key = 'barcodeGeneratorUploadDrawerName';

        mockDataProvider.setup('get', new List<Object>{AppSetting__mdt.SObjectType, key}).returns('asdf');

        String results = sut.barcodeGeneratorUploadDrawerName();

        System.assertEquals('asdf', results);
    }

    @IsTest
    static void LEGACY_code_coverage_call_for_static_rest_service_properties() {
        Object results = null;
        
        results = sut.creditRelationshipSaveReportBaseUrl();
        results = sut.creditRelationshipOreoSaveReportBaseUrl();
    }
}