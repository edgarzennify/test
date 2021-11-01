@IsTest
private class TmConfigurationDmBuilderTests {
	
    private static TmConfigurationDmBuilder sut;
    private static final TmConfigurationMock.ofIFieldBuilder m_mockAllFieldBuilder;
    private static final TmConfigurationMock.ofIFieldBuilder m_mockEditFieldBuilder;
    private static final TmConfigurationMock.ofISectionBuilder m_mockSectionBuilder;
    
    static {
        m_mockAllFieldBuilder = new TmConfigurationMock.ofIFieldBuilder();
        m_mockEditFieldBuilder = new TmConfigurationMock.ofIFieldBuilder();
        List<TmConfigurationMock.ofIFieldBuilder> fieldBuilders = new List<TmConfigurationMock.ofIFieldBuilder>{m_mockAllFieldBuilder, m_mockEditFieldBuilder};
        m_mockSectionBuilder = new TmConfigurationMock.ofISectionBuilder();
        sut = new TmConfigurationDmBuilder(fieldBuilders, m_mockSectionBuilder);
    }
    
    @IsTest
    static void it_should_build_dm_fields_and_pass_it_to_section_builder() {
        Id sectionId = ObjectFactory.getFakeId(TM_Service_Configuration_Section__c.SobjectType, '1');
        TmConfiguration.Placement placement = TmConfiguration.Placement.Edit;
        TM_Service_Configuration_Field__c cfgField = new TM_Service_Configuration_Field__c();
        cfgField.Object_Name__c = 'Tm_Service_Request__c';
        cfgField.Name = 'Label 1';
        cfgField.Field_Name__c = 'Request_Type__c';
        cfgField.Edit__c = true;
        cfgField.Edit_Placement__c = 1.00;

        DmField fieldDm = new DmField();
        fieldDm.Name = 'Label 1';

        List<DmField> fieldDms = new List<DmField>{fieldDm};

        TM_Service_Configuration_Section__c section = new TM_Service_Configuration_Section__c(Id = sectionId);

        List<TM_Service_Configuration_Field__c> serviceOptionPms = new List<TM_Service_Configuration_Field__c>{cfgField};
        Map<Id,TM_Service_Configuration_Section__c> sectionOptionPms = new Map<Id,TM_Service_Configuration_Section__c>{sectionId => section};
        m_mockEditFieldBuilder.setup('handle').returns(placement);
        m_mockEditFieldBuilder.setup('build', new List<Object>{serviceOptionPms}).returns(fieldDms);

        List<DmSection> result = sut.buildSections(serviceOptionPms, sectionOptionPms, placement);

        m_mockSectionBuilder.Verify('build', new List<OBject>{fieldDms, sectionOptionPms}, Times.Once);
    }

    @IsTest
    static void it_should_accept_a_request_call_the_edit_dm_builder_and_pass_fields_to_section_builder() {
        TmConfiguration.Placement placement = TmConfiguration.Placement.Edit;
        Id sectionId = ObjectFactory.getFakeId(TM_Service_Configuration_Section__c.SobjectType, '1');
        TM_Service_Configuration_Section__c section = new TM_Service_Configuration_Section__c(Id = sectionId);
        Map<Id,TM_Service_Configuration_Section__c> sectionOptionPms = new Map<Id,TM_Service_Configuration_Section__c>{sectionId => section};
        TmConfiguration.DmBuildRequest req = new TmConfiguration.DmBuildRequest();
        req.Placement = placement;
        req.sectionOptionPms = sectionOptionPms;

        DmField fieldDm = new DmField();
        fieldDm.Name = 'Label 1';

        List<DmField> fieldDms = new List<DmField>{fieldDm};

        m_mockEditFieldBuilder.setup('handle').returns(placement);
        m_mockEditFieldBuilder.setup('build', new List<Object>{req}).returns(fieldDms);

        List<DmSection> result = sut.buildSections(req);

        m_mockSectionBuilder.verify('build', new List<Object>{fieldDms, req}, Times.Once);
    }

    @IsTest
    static void it_should_build_object_fields() {
        String name = 'field-name';
        String label = 'field-label';
        String objectName = 'obj-name';
        Mock.ofISObjectField mockSobjectField = new Mock.ofISObjectField();
        Mock.ofIDescribeFieldResult mockMetadata = new Mock.ofIDescribeFieldResult();
        mockMetadata.setup('getName').returns(name);
        mockMetadata.setup('getLabel').returns(label);
        mockSobjectField.setup('getDescribe').returns(mockMetadata);
        List<ISobjectField> fields = new List<ISobjectField>{mockSobjectField};

        DmSection result = sut.buildObjectFields(fields, objectName);

        System.assertEquals(1, result.fields.size());
    }
}