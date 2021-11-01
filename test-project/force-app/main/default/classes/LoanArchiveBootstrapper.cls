public class LoanArchiveBootstrapper {
    public static LoanArchive.IPresenter getInstanceOfIPresenter(){
        LoanArchive.IVmBuilder vmBuilder = new LoanArchiveVmBuilder();
        LoanArchive.IDataProvider dataProvider = new LoanArchiveDataProvider();
        List<LoanArchive.IHandler> handlers = getInstancesOfIHandler(dataProvider);
        LoanArchive.IMergeProcessorHelper helper = new LoanArchiveMergeProcessorHelper();
        LoanArchive.IMergeProcessor mergeProcessor = new LoanArchiveMergeProcessor(handlers, helper);
        ImagingServiceProxy.IImagingServiceProxy imagingService = getImagingServiceProxyInstance();
        LoanArchive.IProcessor processor = new LoanArchiveProcessor(dataProvider, mergeProcessor, imagingService);
        Configurations.IConfigurations configs = Configurations.bootstrap();
        ISystem sys = new SystemWrapper();
        LoanArchive.IValidator validator = new LoanArchiveValidator(configs, sys);
        return new LoanArchivePresenter(vmBuilder, dataProvider, processor, validator); 
    }

    private static List<LoanArchive.IHandler> getInstancesOfIHandler(LoanArchive.IDataProvider dataProvider){
        LoanArchiveHandlerEntityHelper entityHelper = new LoanArchiveHandlerEntityHelper();
        LoanArchiveHandlerCollateralHelper collateralHelper = new LoanArchiveHandlerCollateralHelper();
        LoanArchiveHandlerLoanHelper loanHelper = new LoanArchiveHandlerLoanHelper();
        return new List<LoanArchive.IHandler>{
            new LoanArchiveHandlerCollateral(dataProvider, collateralHelper),
            new LoanArchiveHandlerEntity(dataProvider, entityHelper),
            new LoanArchiveHandlerEbCollateral(dataProvider),
            new LoanArchiveHandlerLoan(dataProvider, loanHelper)
        };
    }

    private static ImagingServiceProxy.IImagingServiceProxy getImagingServiceProxyInstance(){
        IJson json = new JsonWrapper();
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