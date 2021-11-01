@IsTest
private class TmArchivingAchMapperTests {

	private static final TmArchivingMock.ofIConfiguration mockConfig;
	private static final TmArchivingMock.ofIMapperHelper mockHelper;
	private static TmArchivingAchMapper sut;

	static {
		mockHelper = new TmArchivingMock.ofIMapperHelper();
		mockConfig = new TmArchivingMock.ofIConfiguration();
		sut = new TmArchivingAchMapper(mockHelper, mockConfig);
	}

	private static testMethod void it_should_handle_ach_record() {

		mockConfig.setup('RECORDTYPE_ACH').returns('x');

		string result =  sut.handle();

		System.assertEquals('x', result);
	}
}