public class PM_EB_Loan_Application_c extends PM_SObject {
    public String Account_Number_Assigned_c {get;set;}
    public Decimal Total_Loan_Amount_c {get;set;}
    public String Use_of_Funds_c {get;set;}
    public Decimal Maturity_Term_In_Months_c {get;set;}
    public String Loan_Type_c {get;set;}
    public String Credit_Rating_c {get;set;}
    public String Niche_Products_c {get;set;}
    public String Purpose_Of_Loan_c {get;set;}
    public Date Maturity_Date_c {get;set;}
    public String RM_c {get;set;}
    public PM_EB_Industry_Code_c EB_Account_Industry_Code_r {get;set;}
    public PM_EB_Loan_App_Stage_c Application_Stage_r {get;set;}
    public PM_EB_Account_c Account_Number_r {get;set;}
    public PM_EB_Loan_Packet_c EB_Loan_Packet_r {get;set;}
    public List<PM_EB_Loan_App_Collateral_Relationship_c> EB_Loan_App_Collateral_Relationships_r {get;set;}
    public List<PM_EB_Loan_Participation_c> EB_Loan_Participations_r {get;set;}
    public List<PM_EB_Loan_App_Entity_Relationship_c> EB_Loan_App_Entity_Relationships_r {get;set;}
    public List<PM_EB_Loan_App_Rate_Stream_c> EB_Loan_App_Rate_Streams_r {get;set;}
    public List<PM_EB_Loan_Application_Payment_Stream_c> EB_Loan_Application_Payment_Streams_r {get;set;}
}