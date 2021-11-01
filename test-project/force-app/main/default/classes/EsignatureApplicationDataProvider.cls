public class EsignatureApplicationDataProvider extends DataProvider implements EsignatureApplication.IDataProvider{	
    
    public List<PM_Esignature_Configuration_c> getConfigurations(){
        List<Esignature_Configuration__c> pms = [
            SELECT
                Id
                ,Name
                ,Application_Id__c
                ,Reference_Id_Type__c
                ,Esign_Application_Url__c
                ,Object_Name_Api__c
                ,Record_Type_Name__c
                ,Is_Template_Pdf__c
                ,Is_Template_Dynamic__c
                ,Is_Signer_Attachment_Required__c
                ,Is_Notification_On_Complete_Required__c
                ,PermissionSet__c
                ,Signature_Role_Code__c
                ,Template_File_Name__c
                ,Signer_Attachment_Template_File_Name__c
                ,Transaction_Name__c
                ,Department__c
                ,Status_Field__c
                ,Status_Value__c
                ,Is_Active__c
            FROM
            	Esignature_Configuration__c
            WHERE
            	Is_Active__c =:true    
        ];

        List<PM_Esignature_Configuration_c> configPMs = new List<PM_Esignature_Configuration_c>();
        for(Esignature_Configuration__c pm: pms){
            configPMs.add(buildConfigPm(pm));
        }
        return configPms;
    }

    public PM_Esignature_Configuration_c getConfigurationByAppId(string applicationId){
        Esignature_Configuration__c pm = getConfiguration( applicationId);
        return buildConfigPm(pm);
    }

    private PM_Esignature_Configuration_c buildConfigPm(Esignature_Configuration__c pm){
        PM_Esignature_Configuration_c  pmConfig = new PM_Esignature_Configuration_c();
        pmConfig.Esignature_Configuration_Fields_r = new List<PM_Esignature_Configuration_Field_c>();

        pmConfig.id = pm.id;
        pmConfig.name = pm.name;
        pmConfig.Application_Id_c = pm.Application_Id__c;
        pmConfig.Reference_Id_Type_c = pm.Reference_Id_Type__c;
        pmConfig.Esign_Application_Url_c = pm.Esign_Application_Url__c;
        pmConfig.Object_Name_Api_c = pm.Object_Name_Api__c;
        pmConfig.Record_Type_Name_c = pm.Record_Type_Name__c;
        pmConfig.Is_Template_Pdf_c = pm.Is_Template_Pdf__c;
        pmConfig.Is_Template_Dynamic_c = pm.Is_Template_Dynamic__c;
        pmConfig.Is_Signer_Attachment_Required_c = pm.Is_Signer_Attachment_Required__c;
        pmConfig.Is_Notification_On_Complete_Required_c = pm.Is_Notification_On_Complete_Required__c;
        pmConfig.PermissionSet_c = pm.PermissionSet__c;
        pmConfig.Template_File_Name_c = pm.Template_File_Name__c;
        pmConfig.Signer_Attachment_Template_File_Name_c = pm.Signer_Attachment_Template_File_Name__c;
        pmConfig.Transaction_Name_c = pm.Transaction_Name__c;
        pmConfig.Department_c = pm.Department__c;
        pmConfig.Status_Field_c = pm.Status_Field__c;
        pmConfig.Status_Value_c = pm.Status_Value__c;
        pmConfig.Is_Active_c = pm.Is_Active__c;

        if(pm.Esignature_Configuration_Fields__r == null) return pmConfig;

        for(Esignature_Configuration_Field__c x : pm.Esignature_Configuration_Fields__r){
            PM_Esignature_Configuration_Field_c pmField = new PM_Esignature_Configuration_Field_c();
            pmField.Id = x.Id;
            pmField.Name = x.Name;
            pmField.Field_Name_c = x.Field_Name__c;
            pmField.Field_Name_Api_c = x.Field_Name_Api__c;
            pmField.Field_Type_c = x.Field_Type__c;
            pmField.Salesforce_Name_Api_c = x.Salesforce_Name_Api__c;
            pmField.Sort_Order_c = x.Sort_Order__c;
            pmField.Esignature_Configuration_Signer_r = new PM_Esignature_Configuration_Signer_c();
            if(String.isNotBlank(x.Esignature_Configuration_Signer__c)){ 
                pmField.Esignature_Configuration_Signer_r.Id = x.Esignature_Configuration_Signer__c;
                pmField.Esignature_Configuration_Signer_r.Name = x.Esignature_Configuration_Signer__r.Name;
                pmField.Esignature_Configuration_Signer_r.Role_Code_c = x.Esignature_Configuration_Signer__r.Role_Code__c;
                pmField.Esignature_Configuration_Signer_r.Role_Order_c = x.Esignature_Configuration_Signer__r.Role_Order__c;
            }
            pmConfig.Esignature_Configuration_Fields_r.add(pmField);
        }


        return pmConfig;
    }

    private Esignature_Configuration__c getConfiguration(string applicationId){
        return [
            SELECT
                Id
                ,Name
                ,Application_Id__c
                ,Reference_Id_Type__c
                ,Esign_Application_Url__c
                ,Object_Name_Api__c
                ,Record_Type_Name__c
                ,Is_Template_Pdf__c
                ,Is_Template_Dynamic__c
                ,Is_Signer_Attachment_Required__c
                ,Is_Notification_On_Complete_Required__c
                ,PermissionSet__c
                ,Signature_Role_Code__c
                ,Template_File_Name__c
                ,Signer_Attachment_Template_File_Name__c
                ,Transaction_Name__c
                ,Department__c
                ,Status_Field__c
                ,Status_Value__c
                ,Is_Active__c
                ,(
                    SELECT
                        Id
                        ,Name
                        ,Field_Name__c
                        ,Field_Type__c
                        ,Field_Name_Api__c
                        ,Salesforce_Name_Api__c
                        ,Esignature_Configuration_Signer__c
                        ,Esignature_Configuration_Signer__r.Name
                        ,Esignature_Configuration_Signer__r.Role_Code__c
                        ,Esignature_Configuration_Signer__r.Role_Order__c
                        ,Sort_Order__c
                    FROM
                        Esignature_Configuration_Fields__r
                )
            FROM
            	Esignature_Configuration__c
            WHERE
            	Application_Id__c =:applicationId
            Limit 1        
        ];
    }
}