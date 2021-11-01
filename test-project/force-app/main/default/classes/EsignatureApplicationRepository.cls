public class EsignatureApplicationRepository implements EsignatureApplication.IRepository{

    private final EsignatureApplication.IDataProvider m_dataProvider;

    public EsignatureApplicationRepository(EsignatureApplication.IDataProvider dataProvider){
        m_dataProvider = dataProvider;
    }

    public List<Dataprovider.DynamicQueryResult> runQuery(List<string> fieldsForQuery, string objectName, string recordId){
        string recordIdWithTicks = '\'' + recordId + '\'';
        String query = String.Format('SELECT {0} FROM {1} WHERE id={2}', new List<string>{String.join(fieldsForQuery, ','), objectName,recordIdWithTicks});
        
        return m_dataProvider.executeDynamicQuery(query, fieldsForQuery);
    }

    public DmEsignatureConfigurationInfo.DmEsignatureConfiguration buildDm(string applicationId, string salesforceId){
        PM_Esignature_Configuration_c pm = m_dataProvider.getConfigurationByAppId(applicationId);
        DmEsignatureConfigurationInfo.DmEsignatureConfiguration dm = new DmEsignatureConfigurationInfo.DmEsignatureConfiguration();
        dm.fields = new List<DmEsignatureConfigurationInfo.DmEsignatureConfigurationField>();
        if(pm == null) return dm;
        dm.applicationId = pm.Application_Id_c;
        dm.salesforceRecordId = salesforceId;
        dm.objectNameApi = pm.Object_Name_Api_c;
        dm.recordTypeName = pm.Record_Type_Name_c;
        dm.referenceIdType = String.isNotBlank(pm.Reference_Id_Type_c)?pm.Reference_Id_Type_c:'';
        dm.isPdf = pm.Is_Template_Pdf_c;
        dm.isTemplateDynamic = pm.Is_Template_Dynamic_c==null?false:pm.Is_Template_Dynamic_c;
        dm.IsSignerAttachmentRequired = pm.Is_Signer_Attachment_Required_c == null?false:pm.Is_Signer_Attachment_Required_c;
        
        dm.IsNotificationRequired = pm.Is_Notification_On_Complete_Required_c == null?
                                    false:pm.Is_Notification_On_Complete_Required_c;
        dm.appUrl = pm.Esign_Application_Url_c;
        dm.department = pm.Department_c;
        dm.statusFieldName = pm.Status_Field_c;
        dm.statusValue = pm.Status_Value_c;
        dm.name = pm.name;
        dm.permissionSet = pm.PermissionSet_c;
        dm.signatureDocumentName = pm.Transaction_Name_c;
        dm.templateFileName = pm.Template_File_Name_c;
        dm.signerTemplateFileName = pm.Signer_Attachment_Template_File_Name_c;

        if(pm.Esignature_Configuration_Fields_r == null) return dm;

        for(PM_Esignature_Configuration_Field_c f: pm.Esignature_Configuration_Fields_r){
            DmEsignatureConfigurationInfo.DmEsignatureConfigurationField dmf = new DmEsignatureConfigurationInfo.DmEsignatureConfigurationField();
            dmf.identifier = f.Id;
            dmf.fieldName = f.Field_Name_c;
            dmf.fieldType = f.Field_Type_c;
            dmf.fieldNameApi = f.Field_Name_Api_c;
            dmf.salesforceNameApi = f.Salesforce_Name_Api_c;
            dmf.sortOrder = f.Sort_Order_c;
            dmf.roleCode = f.Esignature_Configuration_Signer_r.Role_Code_c;
            dmf.roleOrder = Integer.valueOf(f.Esignature_Configuration_Signer_r.Role_Order_c);
            dm.fields.add(dmf);
        }

        return dm;
    }

    public void save(List<SObject> sobjs){
        m_dataProvider.save(sobjs);
    }
}