public class DataViewerBootstrapper {

    public static DataViewer.IPresenter getPresenterInstance(){
        IApexPages apexPages = new ApexPagesWrapper();
        IJson json = new JsonWrapper();
        DataViewer.IDataProvider dataProvider = new DataViewerDataProvider();
        AttachmentHandler.IAttachmentHandler attachmentHandler = new AttachmentHandler();
        IEncodingUtil encodingUtil = new EncodingUtilProvider();
        DataViewer.IHelper helper = new DataViewerHelper(dataProvider, attachmentHandler);
        DataViewer.IDocumentHandler dvDocumentHandler = getDocumentHandlerInstance(encodingUtil);
        return new DataViewerPresenter(apexPages, json, dvDocumentHandler,encodingUtil, helper);
    }

    public static DataViewer.IDocumentHandler getDocumentHandlerInstance(IEncodingUtil encodingUtil){
        Configurations.IConfigurations cfgs = Configurations.bootstrap();
        Documents.ISalesforceDocumentProvider sfDocs = new SalesforceDocumentProvider();
        ISystem systemDate = new SystemWrapper();
        UserInfoService.IUserInfoServiceDataProv uSvcdataProv = new UserInfoServiceDataProv(); 
        IUserInfoService userInfo = new UserInfoService(cfgs,uSvcdataProv);
        return new DataViewerDocumentHandler(getHtmlReportingSvcInstance(),sfDocs,systemDate,userInfo,encodingUtil);
    }

    private static HtmlReportingServiceProxy.IHtmlReportingService getHtmlReportingSvcInstance() {
        Configurations.IConfigurations cfg = Configurations.bootstrap();
        GatewayApiMetadataProvider.IGatewayApiMetadataProvider gtProvider = new GatewayApiMetadataProvider();
        WebServices.IRESTService restSvc = new RESTService(gtProvider, cfg);
        IEncodingUtil eutil = new EncodingUtilProvider();
        StaticResourceDataProvider.IStaticResource sresource = new StaticResourceDataProvider();
        IJson j = new JsonWrapper();
        HtmlCoding.IHtmlCoding htmlCoding = new HtmlCoding();
        return new HtmlReportingServiceProxy(restSvc, eutil, sresource, j, htmlCoding);
    }
}