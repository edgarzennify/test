public class EbtDocManagerBootstrapper {
	public static EbtDocManager.IAdapter getInstanceOfIEbtDocManagerAdapter(){
        IJson json = new JsonWrapper();
        Configurations.IConfigurations configs = Configurations.bootstrap();
        ImagingServiceProxy.IImagingServiceProxy imagingProxy = getImagingServiceProxyInstance(json);
        
        EbtDocManager.IDataProvider dataProvider = new EbtDocManagerDataProvider();
        List<EbtDocManager.IPlugin> plugins = getPluginInstances(dataProvider);
        EbtDocManager.IPluginManager pluginManager = new EbtDocManagerPluginManager(plugins);
        EbtDocManager.IStoreBuilderHelper storeBuilderHelper = new EbtDocManagerStoreBuilderHelper(dataProvider);
        EbtDocManager.IStoreBuilder storeBuilder = new EbtDocManagerStoreBuilder(configs, storeBuilderHelper);
        EbtDocManager.IInternalStore internalStore = new EbtDocManagerInternalStore(storeBuilder, dataProvider);
        
    	return new EbtDocManagerAdapter(imagingProxy, json, pluginManager, internalStore);
    }
    
    private static List<EbtDocManager.IPlugin> getPluginInstances(EbtDocManager.IDataProvider dataProvider) {
        return new List<EbtDocManager.IPlugin>{
            new EbtDocManagerPluginLoan(dataProvider),
            new EbtDocManagerPluginEntity(dataProvider),
            new EbtDocManagerPluginCollateral(dataProvider)
        };
    }
    
    private static ImagingServiceProxy.IImagingServiceProxy getImagingServiceProxyInstance(IJson json){
        Webservices.IRESTService restService = getRestServiceInstance();   
        Utility.IUtility utility = new Utility();
        return new ImagingServiceProxy(restService, json, utility);
    }
    
    private static Webservices.IRESTService getRestServiceInstance(){
        GatewayApiMetadataProvider.IGatewayApiMetadataProvider gatewayMetadataProvider = new GatewayApiMetadataProvider();
        Configurations.IConfigurations configurations = Configurations.bootstrap();
        return new RestService(gatewayMetadataProvider, configurations);
    }
}