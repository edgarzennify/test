@IsTest
private class TmBoardingFieldMetadataBuilderTests {
    private static TmBoardingFieldMetadataBuilder sut;
    private static final TmBoardingMock.ofIFieldMapManager m_mockOfIFieldMapManager;
    
    static {
        m_mockOfIFieldMapManager = new TmBoardingMock.ofIFieldMapManager();
        sut = new TmBoardingFieldMetadataBuilder(m_mockOfIFieldMapManager);
    }

    @IsTest
    static void it_should_call_the_field_manager_ti_get_field_metadata() {
        Id sectionGroupId = ObjectFactory.getFakeId(TM_Service_Configuration_Section_Group__c.SObjectType, '1');
    	TM_Service_Configuration_Field__c cfgField = new TM_Service_Configuration_Field__c();
    	cfgField.Name = 'test-name';
    	cfgField.Field_Name__c = 'test-field-name';
    	cfgField.Object_Name__c = 'test-object-name';
    	TM_Service_Configuration_Section_Group__c sectionGroup = new TM_Service_Configuration_Section_Group__c();
    	sectionGroup.Name = 'test-group';
    	TmBoarding.Placement plc = TmBoarding.Placement.Edit;
    	Map<Id, TM_Service_Configuration_Section_Group__c> sectionGroups = new Map<Id, TM_Service_Configuration_Section_Group__c>();
    	sectionGroups.put(sectionGroupId, sectionGroup);

    	TmBoarding.Field result =  sut.getFieldMetadata( cfgField, plc, sectionGroups);

    	m_mockOfIFieldMapManager.verify('getField', new List<Object>{cfgField.Object_Name__c, cfgField.Field_Name__c}, Times.Once);
    }

    @IsTest
    static void it_should_get_field_meta() {
        Id sectionGroupId = ObjectFactory.getFakeId(TM_Service_Configuration_Section_Group__c.SObjectType, '1'); 
        String objectName = 'TM_Service_Request__c';
        String fieldName1 = 'Id';
        String fieldName2 = 'Name';
        TM_Service_Configuration_Field__c cfgParent = new TM_Service_Configuration_Field__c(Title__c = true, View__c = true, Edit__c = true, Object_Name__c = objectName, Field_Name__c = fieldName1);
        List<TM_Service_Configuration_Field__c> parent = new List<TM_Service_Configuration_Field__c>{cfgParent};

        TM_Service_Configuration_Field__c cfgRelated = new TM_Service_Configuration_Field__c(Title__c = true, View__c = true, Edit__c = true, Object_Name__c = objectName, Field_Name__c = fieldName2);
        List<TM_Service_Configuration_Field__c> related = new List<TM_Service_Configuration_Field__c>{cfgRelated};


        TM_Service_Configuration_Section_Group__c sectionGroup = new TM_Service_Configuration_Section_Group__c(Id = sectionGroupId);
        Map<Id, TM_Service_Configuration_Section_Group__c> sectionGroups = new Map<Id, TM_Service_Configuration_Section_Group__c>{sectionGroupId => sectionGroup};


        Schema.SObjectField parentSObj = getField(objectName, fieldName1);
        Schema.SObjectField relatedSObj = getField(objectName, fieldName2);

        m_mockOfIFieldMapManager.setup('getField', new List<Object>{cfgParent.Object_Name__c, cfgParent.Field_Name__c}).returns(parentSObj);
        m_mockOfIFieldMapManager.setup('getField', new List<Object>{cfgRelated.Object_Name__c, cfgRelated.Field_Name__c}).returns(relatedSObj);

        m_mockOfIFieldMapManager.setup('isFieldAccessible' , new List<Object>{parentSObj}).returns(true);
        m_mockOfIFieldMapManager.setup('isFieldAccessible' , new List<Object>{relatedSObj}).returns(true);

        TmBoarding.FieldCategory result = sut.getCategoryMetadata( parent, related,   sectionGroups);

        m_mockOfIFieldMapManager.verify('getField', new List<Object>{cfgParent.Object_Name__c, cfgParent.Field_Name__c}, Times.Twice);
        m_mockOfIFieldMapManager.verify('getField', new List<Object>{cfgRelated.Object_Name__c, cfgRelated.Field_Name__c}, Times.Twice);
    }

    private static Schema.SObjectField getField(String objectName, String fieldName) {
        Map<string, Map<string,Schema.SObjectField>> m_fieldMap = new Map<string, Map<string,Schema.SObjectField>>();
        if (!m_fieldMap.containsKey(objectName)) {
            m_fieldMap.put(objectName,Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap());
        }
        return m_fieldMap.get(objectName).get(fieldName);
    }
}