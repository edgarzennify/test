@Istest
private class TmConfigurationVmMetadataBuilderTests {
	
    private static TmConfigurationVmMetadataBuilder sut;
    
    static {
        sut = new TmConfigurationVmMetadataBuilder();
    }
    
    private static testMethod void it_should_build_form_sections() {
        DmSection section = new DmSection();
        section.Name = 'section-name';
        List<DmSection> sections = new List<DmSection>{section};
        
        List<TmConfiguration.FormSection> result = sut.build(sections);
        
        System.assertEquals(1, result.size());
    }
}