public with sharing class ReportUrlProvider implements IReportUrlProvider
{
	public interface IReportUrlProvider
	{
		string getReportUrl(string reportId);
		string getReportUrl(string reportId, List<string> parameters);
	}

	private Configurations.IConfigurations m_configs;

	public ReportUrlProvider(Configurations.IConfigurations configs)
	{
		m_configs = configs;
	}

	public string getReportUrl(string reportId)
	{
		return baseUrl() + reportId;
	}

	public string getReportUrl(string reportId, List<string> parameters)
	{
		string params = '';
		for(Integer i = 0; i < parameters.size(); ++i)
		{
			params += '&P' + string.valueOf(i+1) + '=' + parameters[i];
		}

		return getReportUrl(reportId) + params;
	}

	private String baseUrl()
	{
		return m_configs.baseReportUrl();
	}
}