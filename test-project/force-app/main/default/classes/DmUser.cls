public class DmUser {
	public String Id {get;set;}
	public String Name {get;set;}
	public String OfficerCode {get;set;}
	public String EmailAddress{get;set;}
	public DmContact Contact{get;set;}
	public DmEntity Entity{get;set;}
	public boolean IsPortalEnabled{get;set;}
}