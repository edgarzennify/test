public class PM_User extends PM_SObject {
    public String Department {get;set;}
    public String Distribution_Channel_c {get;set;}
    public String Division {get;set;}
    public String EmailAddress {get;set;}
    public String My_Referral_Team_c {get;set;}
    public String Referral_Routing_Team_c {get;set;}
    public String Title {get;set;}
    public PM_Contact Contact{get;set;}
    public PM_Account Account{get;set;}
    public boolean IsPortalEnabled{get;set;}
    public PM_UserRole UserRole {get;set;}
}