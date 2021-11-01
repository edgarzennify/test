public  class DmLoanRenewal {
    public string id{get;set;}
    public DmLoan rootLoan{get;set;}
    public DmLoan renewalLoan{get;set;}
    public DmLoan parentLoan{get;set;}
    public integer renewalOrder{get;set;}
    public string revisionStatus{get;set;}
}