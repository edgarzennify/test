@Istest
private class TmConfigurationEditFieldBuilderTests {
	private static TmConfigurationEditFieldBuilder sut;
    
    static {
        sut = new TmConfigurationEditFieldBuilder();
    }
    
    private static testMethod void it_should_get_edit_handler_for_get_type() {
        
        TmConfiguration.Placement result = sut.handle();
        
        System.assertEquals(TmConfiguration.Placement.Edit, result);
    }
    
    private static testMethod void it_should_build_fields() {
        TM_Service_Configuration_Field__c fieldPm = new TM_Service_Configuration_Field__c();
        fieldPm.Field_Name__c = 'field-name';
        fieldPm.Edit_Placement__c = 1.20;
        fieldPm.Edit__c = true;
        
        List<TM_Service_Configuration_Field__c> fieldPms = new List<TM_Service_Configuration_Field__c>{fieldPm};
        
        List<DmField> result = sut.build(fieldPms);
        
        System.assertEquals(1, result.size());
    }
    
    private static testMethod void it_should_build_fields_when_request_is_provided() {
        String fieldName = 'field-name';
        String label = 'field-label';
        String objectName = 'obj-name';
        Id sectionId = OBjectFactory.getFakeId(TM_Service_Configuration_Section_Group__c.SOBjectType, '1');
        TmConfiguration.DmBuildRequest req = new TmConfiguration.DmBuildRequest();
        TM_Service_Configuration_Field__c pm = new TM_Service_Configuration_Field__c();
        pm.Edit__c = true;
        pm.Field_Name__c = fieldName;
        pm.Edit_Placement__c = 1.20;
        pm.Object_Name__c = objectName;
        List<TM_Service_Configuration_Field__c> pms = new List<TM_Service_Configuration_Field__c>{pm};
        
        

        Mock.ofISObjectField mockSobjectField = new Mock.ofISObjectField();
        Mock.ofIDescribeFieldResult mockMetadata = new Mock.ofIDescribeFieldResult();
        mockMetadata.setup('getName').returns(fieldName);
        mockMetadata.setup('getLabel').returns(label);
        mockSobjectField.setup('getDescribe').returns(mockMetadata);
        
        TM_Service_Configuration_Section_Group__c sectionPm = new TM_Service_Configuration_Section_Group__c(id = sectionId, Name='Section', Type__c = 'test-type');
        
        Map<Id, TM_Service_Configuration_Section_Group__c> sectionGroups = new Map<Id, TM_Service_Configuration_Section_Group__c>{sectionId => sectionPm};
        
        Map<string, ISObjectField> fieldMap = new Map<string, ISObjectField>{fieldName => mockSobjectField};
        
        req.ServiceOptionPms = pms;
        req.fieldMap = fieldMap;
        req.SectionGroupOptions = sectionGroups;
        
        List<DmField> result = sut.build(req); 
        
        System.assertEquals(1, result.size());
    }
}