public class LoanDocPrepBootstrapper {
	public static LoanDocPrep.IPresenter getInstanceOfIPresenter(){
		LoanDocPrep.IDataProvider dataProvider = new LoanDocPrepDataProvider();
        IJson json = new JsonWrapper();
        Webservices.IRESTService restService = getRestServiceInstance();
        LaserProTransformer.IService lpService = new LaserProTransformerServiceProxy(restService, json);
        LoanDocPrep.IDmBuilderHelper dmHelper = new LoanDocPrepDmBuilderHelper();
        LoanDocPrep.IDmBuilder dmBuilder = new LoanDocPrepDmBuilder(dmHelper);
        return new LoanDocPrepPresenter(dataProvider, lpService, dmBuilder);
	}

	public static IApexPages getInstanceOfIApexPages(){
		return new ApexPagesWrapper();
	}
    
    private static Webservices.IRESTService getRestServiceInstance(){
        GatewayApiMetadataProvider.IGatewayApiMetadataProvider gatewayMetadataProvider = new GatewayApiMetadataProvider();
        Configurations.IConfigurations configurations = Configurations.bootstrap();
        return new RestService(gatewayMetadataProvider, configurations);
    }
}