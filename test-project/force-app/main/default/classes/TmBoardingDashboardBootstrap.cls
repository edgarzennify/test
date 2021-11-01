public class TmBoardingDashboardBootstrap {
    
	public static TmBoardingDashboard.IPresenter getInstanceOfIPresenter() {
		IUserInfoService userSvc = UserInfoService.bootstrap();
		Utility.IUtility util = new Utility();
		TmBoarding.IDataProvider mainDataProvider = new TmBoardingDataProvider();
		TmBoardingDashboard.IDataProvider dataProvider = new TmBoardingDashboardDataProvider();
		TmBoardingDashboard.IDmBuilder dmBuilder = new TmBoardingDashboardDmBuilder(userSvc);
		TmConfiguration.IStageRepository stageRepository = new TmConfigurationStageRepository(mainDataProvider);
		Configurations.IConfigurations configs = Configurations.bootstrap();
		TmBoardingDashboard.IRepository repository = new TmBoardingDashboardRepository(dataProvider, dmBuilder, stageRepository, userSvc, util);
		List<TmBoardingDashboard.IChartVmBuilder> chartBuilders = getChartBuilders();
		TmBoardingDashboard.IVmFilter filter = new TmBoardingDashboardVmFilter();
		
		TmBoardingDashboard.IVmBuilder vmBuilder = new TmBoardingDashboardVmBuilder(chartBuilders, filter, util, repository);

		return new TmBoardingDashboardPresenter(vmBuilder, repository, configs, userSvc);
    }

    private static List<TmBoardingDashboard.IChartVmBuilder> getChartBuilders(){
    	return new List<TmBoardingDashboard.IChartVmBuilder> {
    		new TmBoardingDashboardRequestsChartBuilder()
    	   ,new TmBoardingDashboardPacketsChartBuilder()
    	};
    }
}