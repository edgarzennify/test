public class PM_Account extends PM_SObject {
    public String Type {get;set;}
    public String BillingStreet {get;set;}
    public String BillingCity {get;set;}
    public String BillingPostalCode {get;set;}
    public String BillingState {get;set;}
    public String EB_Client_Name_c {get;set;}
    public String Entity_Name_c {get;set;}
    public String Phone {get;set;}
    public String Sic {get;set;}
    public String Sub_Type_c {get;set;}
    public String TIN_SSN_c {get;set;}
    public String SSNTIN_Encrypted_c {get;set;}
    public Boolean SSN_TIN_Has_Value_c {get;set;}
    public Date Birthdate_c {get;set;}
    public String Reg_O_Code_c {get;set;}
    public PM_EB_Unit_c EB_UnitID_r {get;set;}    
}