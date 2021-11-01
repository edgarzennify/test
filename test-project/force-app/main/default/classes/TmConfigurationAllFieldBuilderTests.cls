@IsTest
private class TmConfigurationAllFieldBuilderTests {
    
    private static TmConfigurationAllFieldBuilder sut;
    static {
        sut = new TmConfigurationAllFieldBuilder();
    }
    
    @IsTest
    static void it_should_build() {
        TM_Service_Configuration_Field__c pm = new TM_Service_Configuration_Field__c(Field_Name__c = 'test-name');       
        List<TM_Service_Configuration_Field__c> pms = new List<TM_Service_Configuration_Field__c>{pm};
        
        List<DmField> result = sut.build(pms);
        
        System.assertEquals(1 , result.size());
    }

    @IsTest
    static void it_should_build_dmfields_when_request_is_provided() {
        String fldName = 'name';
        String objectName = 'TM_Service_Request__c';
        Id sgId = ObjectFactory.getFakeId(TM_Service_Configuration_Section_Group__c.SObjectType, '1');
        TmConfiguration.DmBuildRequest request = new TmConfiguration.DmBuildRequest();
        TM_Service_Configuration_Section_Group__c sg = new TM_Service_Configuration_Section_Group__c();
        sg.id = sgId;

        request.SectionGroupOptions = new Map<Id,TM_Service_Configuration_Section_Group__c>{sgid => sg};
        TM_Service_Configuration_Field__c fld = new TM_Service_Configuration_Field__c();
        fld.Edit__c = true;
        fld.Edit_Placement__c = 2.00;
        fld.Field_Name__c = fldName;
        fld.Object_Name__c = objectName;
        fld.Readonly__c = true;

        request.ServiceOptionPms = new List<TM_Service_Configuration_Field__c>{fld};
        Mock.ofISObjectField mocksField = new Mock.ofISObjectField();
        mocksField.setup('getInlineHelpText').returns('help-text');
        string lookupField = string.format('{0}.{1}', new List<String>{ objectName.tolowercase(), fldName.tolowercase()});
        request.fieldMap = new Map<String,ISObjectField>{lookupField => mocksField};

        List<DmField> result = sut.build(request);

        mocksField.verify('getInlineHelpText', Times.Once);
    }

    @IsTest
    static void it_should_call_the_handle_method() {
        TmConfiguration.Placement result = sut.handle();

        System.assertEquals(TmConfiguration.Placement.All , result);
    }
}