public class PM_LLCBI_AccountDocument_c extends PM_SObject{
    public PM_Account LLCBI_Account_r{get;set;}
    public boolean LLCBI_Portal_Enabled_c{get;set;}
    public String LLCBI_Portal_Doc_Description_c{get;set;}
    public String LLCBI_Portal_Doc_Name_c{get;set;}
    public Date Document_Due_Date_c{get;set;}
    public PM_LLCBI_Document_Store_c LLCBI_Document_Store_r{get;set;}
    public DateTime CreatedDate{get;set;}
}