public class TmBoardingServiceRequestBuilder implements TmBoarding.IServiceRequestBuilder {

    private final String TMBOARDING_SIGNATURE_EMAIL_DEBUG = 'TmBoardingSignatureEmailDebug';
    private final String TMBOARDING_SIGNATURE_EMAIL = 'TmBoardingSignatureEmail';
    private final String TMBOARDING_SIGNATURE_EMAIL_FIRST_NAME = 'TmBoardingSignatureEmailFirstName';
    private final String TMBOARDING_SIGNATURE_EMAIL_INITIAL = 'TmBoardingSignatureEmailInitial';
    private final String TMBOARDING_SIGNATURE_EMAIL_LAST_NAME = 'TmBoardingSignatureEmailLastName';
    private final String DEBUG_TRUE = 'true';
    private final String DEFAULT_PRIMARY_SIGNER = 'PS';
    private final String MASTER_AGREEMENT = 'Master Agreement';
    private final String TMSA_ENTITY_TEMPLATE_NAME = 'TM Master Service Agreement';

    private final TmBoarding.IReportHelper m_productBuilder;
    private final TmConfiguration.IRepository m_configRepository;
    private final IEncodingUtil m_eutil;
    private final Utility.IUtility m_util;
    private final IJson m_jsonSerializer;
    private final TmBoarding.IServiceClientInfoProvider m_clientInfoProvider;
    private final EbDocRepoProvider.IEbDocRepoProvider m_docProvider;

    public TmBoardingServiceRequestBuilder(TmConfiguration.IRepository configRepository, TmBoarding.IReportHelper productBuilder, 
                            IEncodingUtil eutil, Utility.IUtility util, IJson jsonSerializer, TmBoarding.IServiceClientInfoProvider clientInfoProvider, EbDocRepoProvider.IEbDocRepoProvider docProvider){
        m_productBuilder = productBuilder;
        m_eutil = eutil;
        m_util = util;
        m_jsonSerializer = jsonSerializer;
        m_configRepository = configRepository;
        m_clientInfoProvider = clientInfoProvider;
        m_docProvider = docProvider;
    }

    public List<TmBoardingServiceProxy.HtmlToSignatureRequest> build(String packetId, List<TmBoarding.SignerInfo> signers, List<String> products , Boolean includeMaster, Integer applicationId){
        Map<String, TmConfiguration.ProductInfo> allProductInfos = m_configRepository.getProductInfosByRequestId(packetId);     
        TmBoarding.ReportDataHolder dataHolder = m_productBuilder.buildBulkRequestPmData(allProductInfos, products);                     
        Map<String, TmBoarding.BoardingData> allData = dataHolder.allBoardingData;
        TmBoarding.RequestPm requestPm = dataHolder.requestPms.values()[0];
        String clientName = requestPm.entityPm.Name;
        Map<String, Contact> contacts = new Map<String, Contact>();
       
        for(Contact c : requestPm.contactPms){
            String contactId = m_util.convertid15ToId18(c.Id);
            contacts.put(contactId, c);
        }
        
        List<TmBoardingServiceProxy.ClientInfo> clientInfos = m_clientInfoProvider.getClientInfo(contacts, signers, DEFAULT_PRIMARY_SIGNER);

        return build(clientName, packetId, allProductInfos, allData, clientInfos, includeMaster, applicationId);        
    }

    public List<TmBoardingServiceProxy.HtmlToSignatureRequest> buildTMSADataForEntity(string clientName, string entityId, List<TmBoarding.SignerInfo> signers, List<string> items , integer applicationId){
        Map<String, Contact> contacts = new Map<string, Contact>();

        for(TmBoarding.SignerInfo info: signers){
            Contact c = new Contact();
            c.FirstName= info.Tmo.FirstName;
            c.LastName= info.Tmo.LastName;
            c.Email = info.Tmo.Email;
            c.Phone = info.Tmo.Phone;
            contacts.put(info.SignerId,c);
        }
        
        List<TmBoardingServiceProxy.ClientInfo> clientInfos = m_clientInfoProvider.getClientInfo(contacts, signers, DEFAULT_PRIMARY_SIGNER);
        return build(clientName, entityId, clientInfos, applicationId);        
    }

    private List<TmBoardingServiceProxy.HtmlToSignatureRequest> build(String clientName, String entityId, List<TmBoardingServiceProxy.ClientInfo> clientInfos, Integer applicationId){
        List<TmBoardingServiceProxy.HtmlToSignatureRequest> sendForSignatureRequests = new List<TmBoardingServiceProxy.HtmlToSignatureRequest>();
        Integer signers = 0;
        if (clientInfos !=null) {
            for (TmBoardingServiceProxy.ClientInfo c : clientInfos) {
                if (c.SignatureRoleIdentifier.tolowercase() != 'tms') {
                    signers = signers + 1;
                }
            }
        }
        
        TmBoardingServiceProxy.HtmlToSignatureRequest mRequest = buildMasterDocumentRequestForEntity(clientName, entityId, clientInfos, applicationId);
        sendForSignatureRequests.add(mRequest);
        return sendForSignatureRequests;
    }

    private List<TmBoardingServiceProxy.HtmlToSignatureRequest> build(
        String clientName
        ,String packetId
        ,Map<String , TmConfiguration.ProductInfo> allProductInfos
        ,Map<String, TmBoarding.BoardingData> allData
        ,List<TmBoardingServiceProxy.ClientInfo> clientInfos
        ,Boolean includeMaster,
        Integer applicationId) {

        List<TmBoardingServiceProxy.HtmlToSignatureRequest> sendForSignatureRequests = new List<TmBoardingServiceProxy.HtmlToSignatureRequest>();
        
        Integer signers = 0;
        if (clientInfos !=null) {
            for (TmBoardingServiceProxy.ClientInfo c : clientInfos) {
                if (c.SignatureRoleIdentifier.tolowercase() != 'tms') {
                    signers = signers + 1;
                }
            }
        }

        if (includeMaster == true) {
             TmBoardingServiceProxy.HtmlToSignatureRequest mRequest = buildMasterDocumentRequest(clientName,packetId, clientInfos, applicationId);
             sendForSignatureRequests.add(mRequest);
        }

        for (String requestId : allProductInfos.keyset()) {
            TmConfiguration.ProductInfo info = allProductInfos.get(requestId); 
            String product = info.productType.name;
            Blob templateBytes = buildTemplate(product, info.TemplateFileName, info.configId);
            
            if (templateBytes != null && allData.containsKey(requestId)) {
                TmBoarding.BoardingData data = allData.get(requestId);
                data.signers = signers;

                String jsonData = m_jsonSerializer.serialize(data);

                TmBoardingServiceProxy.HtmlToSignatureRequest htmlRequest = new TmBoardingServiceProxy.HtmlToSignatureRequest();
                htmlRequest.ApplicationId = applicationId;
                htmlRequest.PacketId= packetId;
                htmlRequest.RequestId = requestId;
                htmlRequest.ClientName = clientName;
                htmlRequest.ProductType = product;
                htmlRequest.DocumentProfileName = product;
                htmlRequest.Base64HtmlTemplate = m_eutil.toBase64(templateBytes);
                htmlRequest.ReportDataJson = jsonData;
                htmlRequest.HasInitials = info.requiresInitialSignature == true ? true : false;
                htmlRequest.MimeType = MimeType.Pdf;
                htmlRequest.Clients = clientInfos;
                sendForSignatureRequests.add(htmlRequest);
            }
        }
        return sendForSignatureRequests;
    }
    
    private Blob buildTemplate(String productName, String templateFileName, String productId) {
        if (String.isBlank(templateFileName)) {return null;}
        return m_configRepository.getTemplateFromAttachment(templateFileName, productId);
    }
    
    private TmBoardingServiceProxy.HtmlToSignatureRequest buildMasterDocumentRequest(String clientName, String packetId, List<TmBoardingServiceProxy.ClientInfo> clientInfos, Integer applicationId) {
        TmBoardingServiceProxy.HtmlToSignatureRequest req = new TmBoardingServiceProxy.HtmlToSignatureRequest();
        
        blob mAgreement = m_productBuilder.getMasterServiceAgreement(packetId);
        req.ApplicationId = applicationId;
        req.PacketId = packetId;
        req.RequestId = packetId;
        req.ClientName = clientName;
        req.ProductType = MASTER_AGREEMENT;
        req.DocumentProfileName = MASTER_AGREEMENT;  
        req.ReportDataJson = '';
        req.HasInitials = false;
        req.PdfBytes = mAgreement;  
        req.MimeType = MimeType.Pdf;
        req.Clients = clientInfos;
        return req;
    }

    private TmBoardingServiceProxy.HtmlToSignatureRequest buildMasterDocumentRequestForEntity(String clientName, String entityId, List<TmBoardingServiceProxy.ClientInfo> clientInfos, Integer applicationId) {
        TmBoardingServiceProxy.HtmlToSignatureRequest req = new TmBoardingServiceProxy.HtmlToSignatureRequest();
        blob mAgreement = getMasterAgreementForEntity();
        req.ApplicationId = applicationId;
        req.PacketId = entityId;
        req.RequestId = entityId;
        req.ClientName = clientName;
        req.ProductType = MASTER_AGREEMENT;
        req.DocumentProfileName = MASTER_AGREEMENT;  
        req.ReportDataJson = '';
        req.HasInitials = false;
        req.PdfBytes = mAgreement;  
        req.MimeType = MimeType.Pdf;
        req.Clients = clientInfos;
        return req;
    }

    private blob getMasterAgreementForEntity() {
        DmDocument masterSvcDoc = m_docProvider.GetFileByEbDocName(TMSA_ENTITY_TEMPLATE_NAME);
        if(masterSvcDoc == null) return Blob.valueOf('');
        return masterSvcDoc.body;
    }
}