public class PM_EB_Loan_App_Rate_Stream_c extends PM_SObject {
    public Decimal Fixed_Interest_Rate_c {get;set;}
    public String Index_Variance_Code_c {get;set;}
    public Decimal Interest_Rate_Ceiling_c {get;set;}
    public Decimal Interest_Rate_Floor_c {get;set;}
    public String Rate_Subject_To_Change_c {get;set;}
    public Decimal Rate_Index_Variance_c {get;set;}
    public String Stream_Number_c {get;set;}    
    public PM_EB_Floating_Rate_c EB_Floating_Rate_r {get;set;}
}