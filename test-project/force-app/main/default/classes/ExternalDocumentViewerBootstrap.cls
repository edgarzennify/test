public class ExternalDocumentViewerBootstrap {
    public static Documents.IDocumentProvider getProviderInstance(){
        GatewayApiMetadataProvider.IGatewayApiMetadataProvider mdProv = new GatewayApiMetadataProvider();
        Configurations.IConfigurations cfgs = Configurations.bootstrap();
        Webservices.IRESTService restSvc = new RestService(mdProv, cfgs);
        IJson json = new JsonWrapper();
        Utility.IUtility util = new Utility();
        ImagingServiceProxy.IImagingServiceProxy imgSvc = new ImagingServiceProxy(restSvc,json,util); 
        Documents.ISalesforceDocumentProvider sfDocs = new SalesforceDocumentProvider();
        Documents.IDocumentDmBuilder builder = new DocumentDmBuilder();
        Documents.IDocumentCache docCache = new DocumentCache(sfDocs, builder);
        ISystem systemDate = new SystemWrapper();
        return new DocumentProvider(imgSvc, docCache, util, systemDate);
    }
    
    public static Documents.IDocumentRequestBuilder getRequestBuilderInstance(){
        ExternalDocumentMetaDataProvider.IExternalDocumentMetaDataProvider metaDataProvider = new ExternalDocumentMetaDataProvider();
        IUserInfoService userInfoService = UserInfoService.bootstrap();
        return new DocumentRequestBuilder(metaDataProvider, userInfoService);
    }

    public static ExternalDocumentViewer.IPresenter getPresenterInstance(){
        GatewayApiMetadataProvider.IGatewayApiMetadataProvider mdProv = new GatewayApiMetadataProvider();
        Configurations.IConfigurations cfgs = Configurations.bootstrap();
        Webservices.IRESTService restSvc = new RestService(mdProv, cfgs);
        IJson json = new JsonWrapper();
        Utility.IUtility util = new Utility();
        ImagingServiceProxy.IImagingServiceProxy imgSvc = new ImagingServiceProxy(restSvc,json,util); 
        Documents.ISalesforceDocumentProvider sfDocs = new SalesforceDocumentProvider();
        Documents.IDocumentDmBuilder builder = new DocumentDmBuilder();
        Documents.IDocumentCache docCache = new DocumentCache(sfDocs, builder);
        ISystem systemDate = new SystemWrapper();
        Documents.IDocumentProvider docProvider = new DocumentProvider(imgSvc, docCache, util, systemDate);

        ExternalDocumentMetaDataProvider.IExternalDocumentMetaDataProvider metaDataProvider = new ExternalDocumentMetaDataProvider();
        IUserInfoService userInfoService = UserInfoService.bootstrap();
        Documents.IDocumentRequestBuilder reqBuilder = new DocumentRequestBuilder(metaDataProvider, userInfoService);
        ExternalDocumentViewer.IRequestHandler imgHandler = new ExternalDocumentViewerImgDocHandler(reqBuilder, docProvider);
        ExternalDocumentViewer.IRequestHandler dvHandler = new ExternalDocumentViewerDvRptHandler(); 

        return new ExternalDocumentViewerPresenter(new List<ExternalDocumentViewer.IRequestHandler>{imgHandler,dvHandler});
    }
}