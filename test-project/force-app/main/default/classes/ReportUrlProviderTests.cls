@IsTest
private class ReportUrlProviderTests {
	
	private static final ReportUrlProvider sut;
	private static final Mock.ofIConfigurations m_configs;

	static {
		m_configs = new Mock.ofIConfigurations();
		sut = new ReportUrlProvider(m_configs);
	}

	@IsTest
	static void it_should_call_the_configs_to_get_baseurl_for_report_url() {
		String reportId = '0000';

		sut.getReportUrl(reportId);

		m_configs.verify('baseReportUrl', Times.Once);
	}

	@IsTest
	static void it_should_receive_a_report_url_when_reportid_and_parameters_are_provided() {
		String reportId = '0000';
		String baseUrl = 'https://app.enterprisebank.com/REST/';
		List<String> parameters = new List<String>{'P1', 'P2', 'P3'};
		m_configs.setup('baseReportUrl').returns(baseUrl);

		String reportUrl = sut.getReportUrl(reportId , parameters);

		System.assertEquals(true, reportUrl.contains(baseurl));
		System.assertEquals(true, reportUrl.contains('P1=P1'));
		System.assertEquals(true, reportUrl.contains('P2=P2'));
		System.assertEquals(true, reportUrl.contains('P3=P3'));
	}
}