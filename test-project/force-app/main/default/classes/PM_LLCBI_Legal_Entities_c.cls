public class PM_LLCBI_Legal_Entities_c extends PM_SObject {
    public String LLCBI_Tax_ID_c {get;set;}
    public String LLCBI_Relationship_Type_c {get;set;}
    public String LLCBI_Borrower_Type_c {get;set;}
    public Decimal Liabilities_c {get;set;}
    public String LLCBI_Address_c {get;set;}
    public String LLCBI_Contingent_Type_c {get;set;}
    public Decimal LLCBI_Ownership_c {get;set;}
    public String Limitations_c {get;set;}
    public PM_Account LLCBI_Account_r {get;set;}
    public PM_LLCBI_Loan_c LLCBI_Loan_r {get;set;}
}