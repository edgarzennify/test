public class EsignatureApplicationPresenter implements EsignatureApplication.IPresenter {
    
    private final string OUT_FOR_SIGNATURE = 'Out For Signature';
    private final EsignatureApplication.IRepository m_repository;
    private final EsignatureApplication.IVmBuilder m_vmBuilder;
    private final EsignatureApplication.IRequestBuilder m_requestBuilder;
    private final IUserInfoService m_userInfoSvc;
    private final DataViewer.IDocumentHandler m_docProvider;
    private final DigitalSignatureFormGeneratorProxy.IProxy m_proxy;
    private final ISchema m_schema;


    public EsignatureApplicationPresenter(EsignatureApplication.IRepository repository, 
            EsignatureApplication.IVmBuilder vmBuilder, EsignatureApplication.IRequestBuilder requestBuilder, 
            IUserInfoService userInfoSvc,DataViewer.IDocumentHandler docProvider, 
            DigitalSignatureFormGeneratorProxy.IProxy proxy, ISchema schema){
        m_repository = repository;
        m_vmBuilder = vmBuilder;
        m_userInfoSvc = userInfoSvc;
        m_requestBuilder = requestBuilder;
        m_docProvider = docProvider;
        m_proxy = proxy;
        m_schema = schema;
    }
    
    public EsignatureApplication.FormVm buildFormVm(String applicationId, String salesforceId) {
        DmEsignatureConfigurationInfo.DmEsignatureConfiguration dm = m_repository.buildDm(applicationId, salesforceId);
        Boolean hasPermission = m_userInfoSvc.isSystemAdministrator() || m_userInfoSvc.hasPermissionSet(dm.permissionSet);
        return m_vmBuilder.build(dm, hasPermission);
    }

    public void sendForSignature(String applicationId, String salesforceId, EsignatureApplication.SaveModel sm) {
        DigitalSignatureFormGeneratorProxy.SignatureRequest req = buildSignatureRequest(applicationId, sm, salesforceId);
        m_proxy.sendForSignature(req);
        if(req == null || String.isBlank(req.StatusObjectName) || String.isBlank(req.StatusFieldName)) return;

        ISobjectType t = m_schema.getSObjectType(req.StatusObjectName);
        SObject obj = t.newSObject();
        obj.Id = getRecordId(req.referenceId);
        obj.put(req.StatusFieldName, OUT_FOR_SIGNATURE);
        m_repository.save(new List<sobject>{obj});
        
    }

    public String getDocumentForSignaturePreview(String applicationId, String salesforceId, EsignatureApplication.SaveModel sm) {
        DigitalSignatureFormGeneratorProxy.SignatureRequest req = buildSignatureRequest(applicationId, sm, salesforceId);
        return m_proxy.getPdfAsbase64(req).base64Reports[0];
    }

    public EsignatureApplication.SignatureData getSignatureData(String applicationId) {
        return m_vmbuilder.Build(m_proxy.getData(applicationId));
    }

    public EsignatureApplication.SignatureData filterData(EsignatureApplication.SignatureData data, String filter ) {
        EsignatureApplication.SignatureData filtered = new EsignatureApplication.SignatureData();
        filtered.items = new List<EsignatureApplication.SignatureDataItem>();
        if (data ==null || data.items == null) {return filtered;}
        for (EsignatureApplication.SignatureDataItem i : data.Items) {
            if (i.status.toLowerCase() == filter.toLowerCase()) {
                filtered.items.add(i);
            }
        }
        return filtered;
    }

    public EsignatureApplication.SignatureData filterDataByRecordId(EsignatureApplication.SignatureData data, String recordId) {
        EsignatureApplication.SignatureData filtered = new EsignatureApplication.SignatureData();
        filtered.items = new List<EsignatureApplication.SignatureDataItem>();
        if (data ==null || data.items == null) {return filtered;}
        for (EsignatureApplication.SignatureDataItem i : data.Items) {
            if (i.referenceId.contains(recordId)) {
                filtered.items.add(i);
            }
        }
        return filtered;
    }

    private DigitalSignatureFormGeneratorProxy.SignatureRequest buildSignatureRequest(String applicationId, EsignatureApplication.SaveModel sm, String salesforceId) {
        DmEsignatureConfigurationInfo.DmEsignatureConfiguration dm = m_repository.buildDm(applicationId, salesforceId);
        Map<String, String> sms = new Map<String, String>();
        for (EsignatureApplication.SaveModelElement el : sm.saveData) {
            sms.put(el.fieldId, el.fieldValue);
        }
        return m_requestBuilder.buildRequest(dm, m_userInfoSvc.getCurrentUserId(), salesforceId, sm);
    }

    private string getRecordId(string referenceId){
        List<string> parts = referenceId.split('-');
        return parts != null && parts.size() == 3? parts[2]:'';
    }
}