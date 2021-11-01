public class PM_EB_Account_c extends PM_SObject {
    public String Key_c {get;set;}
    public Decimal Application_c{get;set;}
    public String Account_Number_c{get;set;}
    public String Account_Line_1_c{get;set;}
    public List<PM_Agreement_EB_Account_Relationship_c> Agreement_EB_Account_Relationship_r {get;set;}
}