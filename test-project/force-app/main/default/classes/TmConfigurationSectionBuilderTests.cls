@IsTest
private class TmConfigurationSectionBuilderTests {
	private static TmConfigurationSectionBuilder sut;
    static {
        sut = new TmConfigurationSectionBuilder();
    }
    
    private static testMethod void it_should_build_sections() {
        Id sectionId = ObjectFactory.getFakeId(TM_Service_Configuration_Section__c.SObjectType, '1');
        String fieldName = 'field-name';
        DmField fld = new DmField();
        fld.Name = fieldName;
        fld.SectionId = sectionId;
        TM_Service_Configuration_Section__c section = new TM_Service_Configuration_Section__c(Id = sectionId, Name='section-name');
        
        List<DmField> fieldDms = new List<DmField>{fld};
        Map<Id,TM_Service_Configuration_Section__c> lookup = new Map<Id,TM_Service_Configuration_Section__c>{sectionId => section};
        
        List<DmSection> result =  sut.build(fieldDms, lookup);
        
        System.assertEquals(1, result.size());
    }
}