public class PM_LLCBI_Loan_Collateral2_c extends PM_SObject {
    // Collateral Pledged
    public Boolean Abundance_of_Caution_c {get;set;}
    public String Description_c {get;set;}
    public String LLCBI_Collateral_Type_c {get;set;}
    public Decimal LLCBI_Current_Lendable_Value_c {get;set;}
    public Boolean LLCBI_Is_Primary_c {get;set;}
    public String LLCBI_Lien_Position_c {get;set;}
    public PM_LLCBI_Collateral_c LLCBI_Collateral_r {get;set;}
    public PM_LLCBI_Loan_c LLCBI_Loan_r {get;set;}
    public PM_LLCBI_Loan_Collateral_Aggregate_c LLCBI_Loan_Collateral_Aggregate_r {get;set;}
}