public interface IApexPages {
	void addMessage(ApexPages.Severity sev, String msg);
	void addMessage(ApexPages.Message msg);
	System.PageReference currentPage();
	List<ApexPages.Message> getMessages();
	Boolean hasMessages();
	Boolean hasMessages(ApexPages.Severity sev);
	String getParameter(String queryParameter);
    Map<String, String> getParameters();
}