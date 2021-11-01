public class EsignatureApplicationRequestBuilder implements EsignatureApplication.IRequestBuilder {

    private final string FIRST_NAME = 'First_Name';
    private final string LAST_NAME = 'Last_Name';
    private final string EMAIL = 'Email';
    private final string SECURITY_PIN = 'Pin';

    private final ISystem m_sys;
    private final IEncodingUtil m_eutil;

    public EsignatureApplicationRequestBuilder(ISystem sys, IEncodingUtil eutil){
        m_sys = sys;
        m_eutil = eutil;
    }

    public DigitalSignatureFormGeneratorProxy.SignatureRequest buildRequest(DmEsignatureConfigurationInfo.DmEsignatureConfiguration dm,string userId,string salesforceId, EsignatureApplication.SaveModel sm){
        Map<String, String> sms = new Map<String, String>();
        for (EsignatureApplication.SaveModelElement el : sm.saveData) {
            sms.put(el.fieldId, el.fieldValue);
        }

        DigitalSignatureFormGeneratorProxy.SignatureRequest req = new DigitalSignatureFormGeneratorProxy.SignatureRequest();

        req.Signers = new List<DigitalSignatureFormGeneratorProxy.SignerInfo>();
        req.ApplicationId = Integer.valueof(dm.applicationId);
        req.ReferenceId = getReferenceId(dm,salesforceId);
        req.DocumentProfileName = '';
        req.TransactionName = dm.signatureDocumentName;
        req.TemplateFileName = dm.templateFileName;
        req.SignerTemplateFileName = dm.signerTemplateFileName;
        req.TemplateAsBytes = m_eutil.fromBase64(sm.dynamicFileTemplateAsBase64);
        req.IsTemplatePdf = dm.isPdf;
        req.IsTemplateDynamic = dm.isTemplateDynamic;
        req.IsSignerAttachmentRequired = dm.IsSignerAttachmentRequired;
        req.IsNotificationOnCompleteRequired = dm.IsNotificationRequired;
        req.NotifyOnCompleteEmail = sm.notificationEmail;
        req.Comments = sm.comments;
        req.DynamicFileTemplateName = sm.dynamicFileTemplateName == null?'':sm.dynamicFileTemplateName;
        req.UserId = userId;
        req.StatusObjectName = dm.objectNameApi;
        req.StatusFieldName = dm.statusFieldName;
        req.StatusValue = dm.statusValue;

        req.Signers = buildSigners(dm, sms);
        req.Data = buildData(dm, sms);
        return req;

    }

    /*public DigitalSignatureFormGeneratorProxy.SignatureRequest build(DmEsignatureConfigurationInfo.DmEsignatureConfiguration dm, Map<string,string> sms, string userId, string templateAsBase64, string id, string notificationEmail){
        DigitalSignatureFormGeneratorProxy.SignatureRequest req = new DigitalSignatureFormGeneratorProxy.SignatureRequest();

        req.Signers = new List<DigitalSignatureFormGeneratorProxy.SignerInfo>();
        req.ApplicationId = Integer.valueof(dm.applicationId);
        req.ReferenceId = getReferenceId(dm,id);
        req.DocumentProfileName = '';
        req.TransactionName = dm.signatureDocumentName;
        req.TemplateFileName = dm.templateFileName;
        req.SignerTemplateFileName = dm.signerTemplateFileName;
        req.TemplateAsBytes = m_eutil.fromBase64(templateAsBase64);
        req.IsTemplatePdf = dm.isPdf;
        req.IsTemplateDynamic = dm.isTemplateDynamic;
        req.IsSignerAttachmentRequired = dm.IsSignerAttachmentRequired;
        req.IsNotificationOnCompleteRequired = dm.IsNotificationRequired;
        req.NotifyOnCompleteEmail = notificationEmail;
        req.UserId = userId;
        req.Signers = buildSigners(dm, sms);
        req.Data = buildData(dm, sms);
        return req;
    }*/

    private List<DigitalSignatureFormGeneratorProxy.SignerInfo> buildSigners(DmEsignatureConfigurationInfo.DmEsignatureConfiguration dm, Map<string,string> sms){

        Map<Integer, DigitalSignatureFormGeneratorProxy.SignerInfo> signerInfos = new Map<Integer, DigitalSignatureFormGeneratorProxy.SignerInfo>();

        for(DmEsignatureConfigurationInfo.DmEsignatureConfigurationField f : dm.fields){
            if(string.isNotBlank(f.roleCode)){
                if(sms.containsKey(f.identifier)){
                    if(!signerInfos.containsKey(f.roleOrder)){
                        DigitalSignatureFormGeneratorProxy.SignerInfo newSignatureInfo = new DigitalSignatureFormGeneratorProxy.SignerInfo();
                        newSignatureInfo.SignatureRoleOrder = f.roleOrder;
                        signerInfos.put(f.roleOrder, newSignatureInfo);
                    }
                    if(f.fieldType == FIRST_NAME){
                        signerInfos.get(f.roleOrder).FirstName = sms.get(f.identifier);
                        signerInfos.get(f.roleOrder).SignatureRoleCode = f.roleCode;
                    }
                    if(f.fieldType == LAST_NAME){
                        signerInfos.get(f.roleOrder).LastName = sms.get(f.identifier);
                    }
                    if(f.fieldType == EMAIL){
                        signerInfos.get(f.roleOrder).Email = sms.get(f.identifier);
                    }
                    if(f.fieldType == SECURITY_PIN){
                        signerInfos.get(f.roleOrder).Security = sms.get(f.identifier);
                    }
                }
            }
        }
      
        return signerInfos.values();
    }

    private Map<string,string> buildData(DmEsignatureConfigurationInfo.DmEsignatureConfiguration dm, Map<string, string> sms){      
        Map<string, string> data = new Map<string, string>();

        for(DmEsignatureConfigurationInfo.DmEsignatureConfigurationField f : dm.fields){
            if(sms.containsKey(f.identifier)){
                data.put(buildKey(f),sms.get(f.identifier));
            }
        }
        return data;
    }

    private string buildKey(DmEsignatureConfigurationInfo.DmEsignatureConfigurationField f ){
        if(String.isNotBlank(f.fieldNameApi)){
            return f.fieldNameApi;
        }

        string apiKey = f.fieldName.replace(' ', '-');
        return apiKey;
    }

    private string getReferenceId(DmEsignatureConfigurationInfo.DmEsignatureConfiguration dm, string id){
        string referenceId = String.format('{0}-{1}', new List<string>{dm.applicationId,string.valueof(m_sys.now().getTime())});
        return string.isNotBlank(dm.referenceIdType) && dm.referenceIdType.toLowerCase().contains('salesforce')
                                ? String.format('{0}-{1}', new List<string>{referenceId,id})
                                : referenceId;
    }
}