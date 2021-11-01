public class PM_EB_Collateral_c extends PM_SObject {
    public String Street_c {get;set;}
    public String State_c {get;set;}
    public String City_c {get;set;}
    public String Zip_Code_c {get;set;}
    public String Lien_Position_c {get;set;}
    public PM_Account Collateral_Owner_r {get;set;}
}