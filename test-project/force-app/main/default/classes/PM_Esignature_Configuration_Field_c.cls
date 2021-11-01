public class PM_Esignature_Configuration_Field_c extends PM_SObject {
    public string Field_Name_c{get;set;}
    public string Field_Name_Api_c{get;set;}
    public string Salesforce_Name_Api_c {get;set;}
    public string Field_Type_c{get;set;}
    public decimal Sort_Order_c{get;set;}
    public PM_Esignature_Configuration_Signer_c Esignature_Configuration_Signer_r{get;set;}
}