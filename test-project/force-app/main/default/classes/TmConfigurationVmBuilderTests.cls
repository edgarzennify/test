@IsTest
private class TmConfigurationVmBuilderTests {
	
	private static final TmConfigurationVmBuilder sut;
	private static final TmConfigurationMock.ofIVmMetadataBuilder m_mockMetadataBuilder;

	static {
		m_mockMetadataBuilder = new TmConfigurationMock.ofIVmMetadataBuilder();
		sut = new TmConfigurationVmBuilder(m_mockMetadataBuilder);
	}

	@IsTest
    static void it_should_build() {
		String objectName = 'fsdfewr';

		DmSection section = new DmSection();
		List<DmSection> sectionDms = new List<DmSection>{section};

		DmSection objectSection = new DmSection();
		List<DmSection> objectSections = new List<DmSection>{objectSection};

		List<TmConfiguration.ObjectField> configObj = new List<TmConfiguration.ObjectField>();
		m_mockMetadataBuilder.setup('getObjectFields', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(configObj);

		TmConfiguration.FormComponent result = sut.build(objectName, sectionDms, objectSections);

		m_mockMetadataBuilder.verify('getObjectFields', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);	
	}

	@IsTest
    static void it_should_build_details() {
		String objectName = 'dfwer';
		List<DmSection> detailSections = new List<DmSection>();
		List<DmSection> scheduleSections = new List<DmSection>();
		List<DmSection> objectSections = new List<DmSection>();

		TmConfiguration.FormComponent result = sut.buildDetails(objectName, detailSections, scheduleSections, objectSections);

		m_mockMetadataBuilder.verify('buildDetails', new List<Object>{objectName, detailSections, scheduleSections}, Times.Once);
	}
}