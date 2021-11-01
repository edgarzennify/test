public class PM_EB_Loan_App_Entity_Relationship_c extends PM_SObject {
    public String Relationship_Type_c {get;set;}
    public PM_EB_Loan_Application_c Loan_Application_ID_r {get;set;}
    public PM_Account Entity_Name_r {get;set;}
}