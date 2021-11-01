public class PM_Entity_Action_c extends PM_SObject{
    public PM_EB_Account_c Account_Number_r{get;set;}
    public PM_User Account_Officer_r{get;set;}
    public string Attention_To_Address_c{get;set;}
    public string Charge_Status_c{get;set;}
    public DateTime CreatedDate{get;set;}
    public Date Date_c{get;set;}
    public PM_Account Entity_r{get;set;}
    public string Esignature_Status_c{get;set;}
    public string Lead_Account_Number_c{get;set;}
    public string Online_Banking_ID_s_c{get;set;}
    public string Other_Analysis_Request_c{get;set;}
    public string Paper_Address_Or_E_Statement_Users_c{get;set;}
    public string Statement_Type_c{get;set;}
    public string Subsidiary_Account_s_c{get;set;}
    public string status_c{get;set;}
    public PM_EB_Unit_c Unit_r{get;set;}
    public Date Waive_Expiration_Date_c{get;set;}
    public PM_User CreatedBy{get;set;}
    public string Assigned_To_c{get;set;}
    public DateTime Date_of_Last_Stage_Change_c{get;set;}
}