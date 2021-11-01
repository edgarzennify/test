public class TmOpportunityConverterBootstrapper {
    public static TmOpportunityConverter.IPresenter getInstanceOfIPresenter() {   
        TmBoarding.IDataProvider dataProvider = new TmBoardingDataProvider();
        Utility.IUtility util = new Utility();
        TmOpportunityConverter.IDmBuilder dmBuilder = new TmOpportunityConverterDmBuilder();
        TmOpportunityConverter.IOpportunityBuilder opportunityBuilder = new TmOpportunityConverterBuilder(); 
        TmConfiguration.IStageRepository stageRepository = new TmConfigurationStageRepository(dataProvider);
        TmOpportunityConverter.IConfiguration config = new TmOpportunityConverterConfiguration();
        List<TmOpportunityConverter.IMapper> productFieldMappers = getMappers(config);
        List<TmOpportunityConverter.IOpportunityMapper> opportunityMappers = getOpportunityMappers(config);
        TmOpportunityConverter.IRepository repo = new TmOpportunityConverterRepository(dataProvider,dmBuilder,opportunityBuilder, util, stageRepository, productFieldMappers, opportunityMappers);
        TmOpportunityConverter.IVmBuilder vmBuilder = new TmOpportunityConverterVmBuilder(util);
        TmOpportunityConverter.IPresenter presenter = new TmOpportunityConverterPresenter(vmBuilder, repo);
        return presenter; 
    }

    public static List<TmOpportunityConverter.IMapper> getMappers(TmOpportunityConverter.IConfiguration config) {
        return new List<TmOpportunityConverter.IMapper> {
            new TmOpportunityConverterLockboxMapper(config)
           ,new TmOpportunityConverterInvSweepMapper(config)
        };
    }

    public static List<TmOpportunityConverter.IOpportunityMapper> getOpportunityMappers(TmOpportunityConverter.IConfiguration config){
        return new List<TmOpportunityConverter.IOpportunityMapper>{
            new TmOpportunityConverterBusinessBankMapper(config)
        };
    }

}