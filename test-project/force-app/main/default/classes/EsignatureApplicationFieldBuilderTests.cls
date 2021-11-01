@IsTest
private class EsignatureApplicationFieldBuilderTests {

    private static EsignatureApplicationMock.ofIFieldHelper mockOfFieldHelper;
    private static EsignatureApplicationFieldBuilder sut;

    static{
        mockOfFieldHelper = new EsignatureApplicationMock.ofIFieldHelper();
        sut = new EsignatureApplicationFieldBuilder(mockOfFieldHelper);
    }

    @IsTest
    private static void it_should_handle_the_case_when_reference_id_is_not_supplied(){
        DmEsignatureConfigurationInfo.DmEsignatureConfiguration dm = new DmEsignatureConfigurationInfo.DmEsignatureConfiguration();
        dm.referenceIdType = 'auto';

        boolean result = sut.handle(dm);

        System.assertEquals(true, result);
    }

    @IsTest
    private static void it_should_call_the_helper_to_build_fields(){
        DmEsignatureConfigurationInfo.DmEsignatureConfiguration dm = new DmEsignatureConfigurationInfo.DmEsignatureConfiguration();
        DmEsignatureConfigurationInfo.DmEsignatureConfigurationField dmField1 = new DmEsignatureConfigurationInfo.DmEsignatureConfigurationField();
        dmField1.roleCode = 'PS';
        dmField1.roleOrder = 1;
        DmEsignatureConfigurationInfo.DmEsignatureConfigurationField dmField2 = new DmEsignatureConfigurationInfo.DmEsignatureConfigurationField();
        dm.fields = new List<DmEsignatureConfigurationInfo.DmEsignatureConfigurationField>{dmField1,dmField2};

        EsignatureApplication.FieldData result = sut.buildFields(dm);

        mockOfFieldHelper.verify('buildFields', new List<object>{dm,false});
    }
}