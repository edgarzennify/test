@isTest
private class TmConfigurationReportFieldBuilderTests {
	
	private static final TmConfigurationReportFieldBuilder sut;

	static {
		sut = new TmConfigurationReportFieldBuilder();
	}

	public static testMethod void it_should_get_handle() {

		TmConfiguration.Placement results = sut.handle();

		System.assertEquals(TmConfiguration.Placement.Report, results);

	}
// public List<DmField> build(List<TM_Service_Configuration_Field__c> pms) {
//         List<DmField> dms = new List<DmField>();
//         for(TM_Service_Configuration_Field__c pm : pms) {
//             if(pm.Report__c == true) {
//             	dms.add(build(pm, pm.Report_Placement__c));
//             }
//         }
//         return dms;
//     }

	public static testMethod void it_should_build_from_config_fields() {
		TM_Service_Configuration_Field__c pm = new TM_Service_Configuration_Field__c(Report__c = true, Report_Placement__c = 2.0);
        List<TM_Service_Configuration_Field__c> pms = new List<TM_Service_Configuration_Field__c>{pm};
        
        List<DmField> result = sut.build(pms);
        
        System.assertEquals(1, result.size());
	}

	public static testMethod void it_should_build_from_dm_build_request() {
		 String fieldName = 'field-name';  
        String label = 'field-label';
        String objectName = 'obj-name';
        Id sectionId = OBjectFactory.getFakeId(TM_Service_Configuration_Section_Group__c.SOBjectType, '1');
        TmConfiguration.DmBuildRequest req = new TmConfiguration.DmBuildRequest();
        TM_Service_Configuration_Field__c pm = new TM_Service_Configuration_Field__c();
        pm.Report__c = true;
        pm.Field_Name__c = fieldName;
        pm.Report_Placement__c = 1.20;
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

	public static testMethod void it_should_build_from_service_config_and_config_section_group_and_return_null() {
		List<TM_Service_Configuration_Field__c> fields = new List<TM_Service_Configuration_Field__c>();
		Map<Id,TM_Service_Configuration_Section_Group__c> groups = new Map<Id,TM_Service_Configuration_Section_Group__c>();

		List<DmField> result = sut.build(fields, groups);

		System.assert(result == null);
	}
	
}