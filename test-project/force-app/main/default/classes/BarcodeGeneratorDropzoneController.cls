global class BarcodeGeneratorDropzoneController {
    private final IApexPages m_apexPages;
    
    private static final string tokenInfoParamater = 'tokenInfo';
    private static final string defaultToken = 'e30=';
    
    public String objectIdAttribute { get;set; }
    public Boolean isUploadSplit {get;set;}

    public String tokenInfo { get;set; }

    public BarcodeGeneratorDropzoneController(){
        m_apexPages = new ApexPagesWrapper();
        initTokenInfo();
    }

    public BarcodeGeneratorDropzoneController(IApexPages apexPages) {
        m_apexPages = apexPages;
        initTokenInfo();
    }

    private void initTokenInfo() {
        try{
        	tokenInfo = defaultToken;
        	if (m_apexPages.currentPage() != null && m_apexPages.getParameter(tokenInfoParamater) != null) {
	            tokenInfo = m_apexPages.getParameter(tokenInfoParamater);
	        }    
        }catch(Exception ex){
        }
    }
    
    @RemoteAction
    global static Boolean isEnabledForCurrentUser(){
        IUserInfoService userSvc = UserInfoService.bootstrap();
        return userSvc.isSystemAdministrator() || userSvc.hasPermissionSet('Function - Barcode Generator - Drag And Drop');
    }

    @RemoteAction
    global static BarcodeGenerator.FormVm init(String contextId){
        if(!isEnabledForCurrentUser()) return null;
        BarcodeGenerator.IPresenter presenter = BarcodeGeneratorBootstrapper.getInstanceOfIPresenter();
        return presenter.getFormVm(contextId);
    }
    
    @RemoteAction
    global static String getTokenForChunkedUpload(Integer chunkCount){
        if(!isEnabledForCurrentUser()) return null;
        try{
            ImagingServiceProxy.IImagingServiceProxy imgSvc = BarcodeGeneratorBootstrapper.getImagingServiceProxyInstance();
            ImagingServiceProxy.RequestMessageToken req = new ImagingServiceProxy.RequestMessageToken();
            req.shardCount = chunkCount;
            return imgSvc.initializeChunkedDocument(req);            
        }catch(exception ex){
            throw new UploadDocumentException(ex.getMessage());
        }
    }

    @RemoteAction
    global static void uploadDocumentChunk(String messageToken, String chunkContent, Integer sequenceNumber) {
        if(!isEnabledForCurrentUser()) return;
        try{
            ImagingServiceProxy.IImagingServiceProxy imgSvc = BarcodeGeneratorBootstrapper.getImagingServiceProxyInstance();
            ImagingServiceProxy.RequestChunk req = new ImagingServiceProxy.RequestChunk();
            req.messageToken = messageToken;
            req.chunk = chunkContent;
            req.sequence = sequenceNumber;
            imgSvc.appendChunkedDocument(req);            
        }catch(exception ex){
            throw new UploadDocumentException(ex.getMessage());
        }
    }
    
    @RemoteAction
    global static String finalizeUpload(UploadFinalizationRequest request){
        if(!isEnabledForCurrentUser()) return null;
        try{
            ImagingServiceProxy.IImagingServiceProxy imgSvc = BarcodeGeneratorBootstrapper.getImagingServiceProxyInstance();
            Configurations.IConfigurations config = Configurations.bootstrap();
            Documents.IDocumentDataService inowSvc = new ImageNowDataService(new RestService(new GatewayApiMetadataProvider(), config), new WebserviceCache(), new EbObjectLookup(new EbObjectLookupDataProvider()));
            
            ImagingServiceProxy.RequestFinalization finalization = buildRequestFinalization(request, config.barcodeGeneratorUploadDrawerName());            
            ImagingServiceProxy.DocumentMetadata doc = imgSvc.finalizeChunkedDocument(finalization);
            inowSvc.ExpireCache(request.contextId);

            return config.get('EbtDocManagerDocUrlTemplate').replace('{documentId}', doc.documentId);                        
        }catch(exception ex){
           throw new UploadDocumentException(ex.getMessage());            
        }  
    }
    
    private static ImagingServiceProxy.RequestFinalization buildRequestFinalization(UploadFinalizationRequest request, String drawerName){
        ImagingServiceProxy.RequestFinalization finalization = new ImagingServiceProxy.RequestFinalization();
        finalization.messageToken = request.messageToken;
        finalization.drawerName = drawerName;
        finalization.documentType = request.documentType;
        finalization.externalObjectSource = request.externalObjectSource;
        finalization.externalObjectKeys = request.externalObjectKeys;
        finalization.externalDocumentKey = String.valueOf(DateTime.now().getTime());
        finalization.documentDate = TryParseDate(request.documentDate);
        finalization.comments = request.comments;
        finalization.userEmail = request.userEmail;
        finalization.fileName = request.fileName;
        finalization.fileExtension = request.fileExtension;
        return finalization;
    }
    
    private static Date TryParseDate(String value){
        try{
            return Date.parse(value);
        }catch(Exception ex){
            return Date.parse('1/1/1900');
        }
    }
        
    global class UploadFinalizationRequest{
        public String contextId {get;set;}
        public String messageToken {get;set;}
        public String categoryName {get;set;}
        public String documentType {get;set;}
        public String externalObjectSource {get;set;}
        public List<String> externalObjectKeys {get;set;}
        public String externalDocumentKey {get;set;}
        public String documentDate {get;set;}
        public String comments {get;set;}
        public String userEmail {get;set;}
        public String fileName {get;set;}
        public String fileExtension {get;set;}
    }
    
    public class UploadDocumentException extends Exception {}
    public class DocManagerInitializationException extends Exception {}
}