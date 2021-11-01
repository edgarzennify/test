public class EsignatureApplicationBootstrapper {
	 public static EsignatureApplication.IPresenter getInstanceOfIPresenter(){
        Configurations.IConfigurations configs = Configurations.bootstrap();
        IEncodingUtil eutil = new EncodingUtilProvider();
        Utility.IUtility util = new Utility();
        IUserInfoService userInfoSvc = new UserInfoService(configs, new UserInfoServiceDataProv());
        EsignatureApplication.IDataProvider dp = new EsignatureApplicationDataProvider();
        EsignatureApplication.IRepository repo = new EsignatureApplicationRepository(dp);
        EsignatureApplication.IFieldHelper fldHelper = new EsignatureApplicationFieldHelper();
        EsignatureApplication.IFieldBuilder fieldBuilder1 = new EsignatureApplicationFieldBuilder(fldHelper);
        EsignatureApplication.IFieldBuilder fieldBuilder2 = new EsignatureApplicationSfFieldBuilder(fldHelper, repo);
        List<EsignatureApplication.IFieldBuilder> fldBuilders = new List<EsignatureApplication.IFieldBuilder>{fieldBuilder1, fieldBuilder2};
        EsignatureApplication.IVmBuilder vmBuilder = new EsignatureApplicationVmBuilder(fldBuilders, util);
        ISystem sys = new SystemWrapper();
        EsignatureApplication.IRequestBuilder reqBuilder = new EsignatureApplicationRequestBuilder(sys, eutil);
        DataViewer.IDocumentHandler docProvider = DataViewerBootstrapper.getDocumentHandlerInstance(eutil);
        DigitalSignatureFormGeneratorProxy.IProxy proxy = getDigitalSignatureFormGeneratorProxyInstance(configs);
        SObjectFieldFactory.ISObjectFieldFactory schemaFactory= new SObjectFieldFactory();
        CachedMap.ICachedMap cache = CachedMap.getInstance();
        SchemaProvider.ISchemaProviderHelper schHelper = new SchemaProviderHelper(schemaFactory, cache);
        ISchema schProvider = new SchemaProvider(schHelper);
        return new EsignatureApplicationPresenter(repo, vmBuilder, reqBuilder, userInfoSvc,docProvider, proxy, schProvider);
    }

    private static DigitalSignatureFormGeneratorProxy.IProxy getDigitalSignatureFormGeneratorProxyInstance(Configurations.IConfigurations configs){
        GatewayApiMetadataProvider.IGatewayApiMetadataProvider gatewayMetadataProvider = new GatewayApiMetadataProvider();
        IJson json = new JsonWrapper();
        WebServices.IRESTService svc =new RestService(gatewayMetadataProvider, configs);
        return new DigitalSignatureFormGeneratorProxy(svc,json);
    }
}