public class PM_Esignature_Configuration_c extends PM_SObject {
    public string Application_Id_c{get;set;}
    public string Reference_Id_Type_c{get;set;}
    public string Esign_Application_Url_c{get;set;}
    public string Object_Name_Api_c {get;set;}
    public string Record_Type_Name_c {get;set;}
    public boolean Is_Template_Pdf_c{get;set;}
    public boolean Is_Template_Dynamic_c{get;set;}
    public boolean Is_Signer_Attachment_Required_c{get;set;}
    public boolean Is_Notification_On_Complete_Required_c {get;set;}
    public string PermissionSet_c{get;set;}
    public string Template_File_Name_c{get;set;}
    public string Signer_Attachment_Template_File_Name_c{get;set;}
    public string Transaction_Name_c{get;set;}
    public string Department_c{get;set;}
    public string Status_Field_c{get;set;}
    public string Status_Value_c{get;set;}
    public boolean Is_Active_c{get;set;}
    public List<PM_Esignature_Configuration_Field_c> Esignature_Configuration_Fields_r{get;set;}
}