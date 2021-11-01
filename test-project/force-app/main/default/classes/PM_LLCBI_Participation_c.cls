public class PM_LLCBI_Participation_c extends PM_SObject {
    public Decimal LLCBI_Participated_c {get;set;}
    public String Bank_c {get;set;}
    public Boolean Participation_Sold_c {get;set;}
    public Decimal Amount_c {get;set;}
    public PM_LLCBI_Loan_c LLCBI_Loan_r {get;set;}
}