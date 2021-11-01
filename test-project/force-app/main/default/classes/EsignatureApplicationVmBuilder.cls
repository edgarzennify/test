public class EsignatureApplicationVmBuilder implements EsignatureApplication.IVmBuilder{

    private final string SALESFORCE_RECORD_ID = 'salesforce record id';

    private final List<EsignatureApplication.IFieldBuilder> m_fieldBuilders;
    private final Utility.IUtility m_util;

    public EsignatureApplicationVmBuilder(List<EsignatureApplication.IFieldBuilder> fieldBuilders, Utility.IUtility util){
        m_fieldBuilders = fieldBuilders;
        m_util = util;
    }
    
    public EsignatureApplication.FormVm build(DmEsignatureConfigurationInfo.DmEsignatureConfiguration dm, boolean hasPermission){
        EsignatureApplication.FormVm vm = new EsignatureApplication.FormVm();
        EsignatureApplication.IFieldBuilder fieldBuilder = locate(m_fieldBuilders,dm);
        vm.ApplicationName = dm.name;
        vm.department = dm.department;
        vm.hasPermission = hasPermission;
        vm.error = !hasPermission?'User does not have permission to access this application. Please contact IT.':'';
        vm.isTemplateDynamic = dm.isTemplateDynamic;
        vm.isNotificationRequired = dm.IsNotificationRequired;
        vm.isSalesforceIdAvailable = dm.referenceIdType.toLowerCase() == SALESFORCE_RECORD_ID;
        vm.salesforceRecordUrl = vm.isSalesforceIdAvailable?m_util.getServerUrl() + '/' + dm.salesforceRecordId : '';
        if(vm.isSalesforceIdAvailable && String.isBlank(dm.salesforceRecordId)) throw new EsignatureApplication.RecordIdNotFoundException();
        
        EsignatureApplication.FieldData fieldData = fieldBuilder.buildFields(dm);
        vm.signerFields = fieldData.SignerFields;
        vm.otherFields = fieldData.OtherFields;

        vm.signerFields.sort();
        vm.otherFields.sort();

        return vm;
    }

    public EsignatureApplication.SignatureData Build(DigitalSignatureFormGeneratorProxy.SignatureStatusDataResponse response){
        EsignatureApplication.SignatureData data = new EsignatureApplication.SignatureData();
        data.Items = new List<EsignatureApplication.SignatureDataItem>();
        for(DigitalSignatureFormGeneratorProxy.SignatureStatusDataItemResponse i : response.Items){
            EsignatureApplication.SignatureDataItem item = new EsignatureApplication.SignatureDataItem();
            item.ApplicationId = i.ApplicationId;
            item.Status = i.Status;
            item.Name = i.Name;
            item.Email = i.Email;
            item.SecurityPin = i.SecurityPin;
            item.ReferenceId = i.ReferenceId;
            item.TransactionId = i.TransactionId;
            item.SentDate = i.SentDate;
            item.SignedDate = i.SignedDate;
            item.DocumentUrl = i.DocumentUrl;
            item.comments = i.Comments;
            item.templateFileName = i.TemplateFileName;
            item.UserId = i.UserId;
            item.Created = i.Created;
            data.Items.add(item);
        }
        return data;
    }

    private EsignatureApplication.IFieldBuilder locate(List<EsignatureApplication.IFieldBuilder> fldBuilders,
                    DmEsignatureConfigurationInfo.DmEsignatureConfiguration dm){       
        for(EsignatureApplication.IFieldBuilder f: fldBuilders){
            if(f.handle(dm)) return f;
        }                
        throw new EsignatureApplication.NoHandlerFoundForRequestException();
    }
}