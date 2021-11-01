public class PM_EB_Loan_Participation_c extends PM_SObject {
    public String Participating_Institution_c {get;set;}
    public Decimal Participated_Amount_c {get;set;}
    public PM_EB_Loan_Application_c Loan_Application_ID_r {get;set;}
}