public class ApexPagesWrapper implements IApexPages {
	public void addMessage(ApexPages.Severity sev, String msg){
		ApexPages.addMessage(new ApexPages.Message(sev, msg));
	}

	public void addMessage(ApexPages.Message msg){
		ApexPages.addMessage(msg);
	}

	public System.PageReference currentPage(){
		return ApexPages.currentPage();
	}

	public List<ApexPages.Message> getMessages(){
		return ApexPages.getMessages();
	}

	public Boolean hasMessages(){
		return ApexPages.hasMessages();
	}

	public Boolean hasMessages(ApexPages.Severity sev){
		return ApexPages.hasMessages(sev);
	}

	public String getParameter(String queryParameter){
		return ApexPages.currentPage().getParameters().get(queryParameter);
	}

    public Map<String, String> getParameters(){
        return ApexPages.currentPage().getParameters();
	}
	
	public static IApexPages bootstrap(){
		return new ApexPagesWrapper();
	}
}