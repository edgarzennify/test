public class BarcodeGeneratorBootstrapper {
    
    public static BarcodeGenerator.IPresenter getInstanceOfIPresenter() {
        BarcodeGenerator.IDataprovider bgDataProvider = new BarcodeGeneratorDataProvider();
        DataProvider.IDataProvider genericDataProvider = new DataProvider();
        IUserInfoService userInfo = UserInfoService.bootstrap();
        Utility.IUtility utility = new Utility();
        BarcodeGenerator.IPmBuilder pmBuilder = new BarcodeGeneratorPmBuilder(utility);
        BarcodeGenerator.IDmBuilder dmBuilder = new BarcodeGeneratorDmBuilder();
        BarcodeGenerator.IRepository repository = new BarcodeGeneratorRepository(bgDataProvider, pmBuilder, dmBuilder);
        BarcodeGenerator.IVmBuilder vmBuilder = new BarcodeGeneratorVmBuilder(userInfo, genericDataProvider);
        Configurations.IConfigurations configs = Configurations.bootstrap();
        ReportUrlProvider.IReportUrlProvider reportUrlProvider = new ReportUrlProvider(configs);      
        return new BarcodeGeneratorPresenter(vmBuilder, repository, reportUrlProvider, configs);
    }

    public static ImagingServiceProxy.IImagingServiceProxy getImagingServiceProxyInstance(){
        IJson json = new JsonWrapper();
        GatewayApiMetadataProvider.IGatewayApiMetadataProvider gatewayMetadataProvider = new GatewayApiMetadataProvider();
        Configurations.IConfigurations configurations = Configurations.bootstrap();
        Webservices.IRESTService restService = new RestService(gatewayMetadataProvider, configurations);
        Utility.IUtility utility = new Utility();
        return new ImagingServiceProxy(restService, json, utility);
    }
}