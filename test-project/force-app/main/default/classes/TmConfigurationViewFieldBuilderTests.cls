@IsTest
private class TmConfigurationViewFieldBuilderTests {
	
    private static TmConfigurationViewFieldBuilder sut;
    
    static {
        sut = new TmConfigurationViewFieldBuilder();
    }
    
    private static testMethod void it_should_call_the_get_type_to_get_view_type() {
        
        TmConfiguration.Placement result = sut.handle();
        
        System.assertEquals(TmConfiguration.Placement.View, result);
    }
    
    private static testMethod void it_should_build_fields_when_placement_view() {
        TM_Service_Configuration_Field__c pm = new TM_Service_Configuration_Field__c(View__c = true, field_name__c = 'test-name');
        List<TM_Service_Configuration_Field__c> pms = new List<TM_Service_Configuration_Field__c>{pm};
        
        List<DmField> result = sut.build(pms);
        
        System.assertEquals(1, result.size());
    }
    
    private static testMethod void it_should_build_fields_when_groups_are_provided() {
        String fieldName = 'field-name';  
        String label = 'field-label';
        String objectName = 'obj-name';
        Id sectionId = OBjectFactory.getFakeId(TM_Service_Configuration_Section_Group__c.SOBjectType, '1');
        TmConfiguration.DmBuildRequest req = new TmConfiguration.DmBuildRequest();
        TM_Service_Configuration_Field__c pm = new TM_Service_Configuration_Field__c();
        pm.View__c = true;
        pm.Field_Name__c = fieldName;
        pm.View_Placement__c = 1.20;
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