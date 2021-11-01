public class PM_EB_Loan_App_Collateral_Relationship_c extends PM_SObject {
    public Decimal Lendable_Equity_c {get;set;}
    public Decimal Loan_Value_c {get;set;}
    public String Description_c {get;set;}
    public String Purpose_Of_Collateral_c {get;set;}
    public String Abundance_Of_Caution_c {get;set;}
    public String Collateral_Code_c {get;set;}
    public PM_EB_Loan_Application_c EB_Loan_Application_ID_r {get;set;}
    public PM_EB_Collateral_c EB_Collateral_ID_r {get;set;}
}