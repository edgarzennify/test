public  class PM_LLCBI_LoanRenewal_c extends PM_SObject{
    public PM_LLCBI_Loan_c LLCBI_RootLoanId_r{get;set;} 
    public PM_LLCBI_Loan_c LLCBI_RenewalLoanId_r{get;set;} 
    public PM_LLCBI_Loan_c LLCBI_ParentLoanId_r{get;set;} 
    public string LLCBI_RevisionStatus_c{get;set;}
    public integer LLCBI_RevisionNumber_c{get;set;}
}