public class TmArchivingBootstrapper {
	
	public static TmArchivingManager getInstanceOfTmArchivingManager() {
		TmArchiving.IConfiguration cfg = new TmArchivingConfiguration();
		Utility.IUtility utility = new Utility();
		ErrorRepository.IErrorRepository errors = new ErrorRepository(); 
		TmBoarding.IRepository tmRepository = TmBoardingBootstrapper.getInstanceOfIRepository(utility, errors );
		TmConfiguration.IRepository configRepository = TmConfigurationBootstrapper.getInstanceOfRepository();
		TmArchiving.IMapperHelper mapperHelper = new TmArchivingMapperHelper(configRepository, cfg); 
		TmArchiving.IDataProvider dataProvider = new TmArchivingDataProvider(); 
		TmArchiving.IRepository archiveRepository = new TmArchivingRepository(dataProvider);
		TmArchiving.IMapper remitMapper = new TmArchivingRemitPlusMapper(mapperHelper, cfg, archiveRepository);
        TmArchiving.IMapper achMapper = new TmArchivingACHMapper(mapperHelper, cfg);
		TmArchiving.IMapper wiresMapper = new TmArchivingWiresMapper(mapperHelper, cfg);
        TmArchiving.IOnlineBankingMapperHelper onlineBkHelper = new TmArchivingOnlineBkMapperHelper(achMapper,wiresMapper, configRepository, cfg);
		TmArchiving.IMapper onlineBankingMapper = new TmArchivingOnlineBankingMapper(mapperHelper, cfg, onlineBkHelper); 
		TmArchiving.IZbaMapperHelper zbaHelper = new TmarchivingZbaMapperHelper();
		TmArchiving.ISmManager smManager = new TmArchivingSmManager(); 

		TmArchiving.IVmBuilder vmBuilder = new TmArchivingVmBuilder();

		return new TmArchivingManager(buildMappers(achMapper,remitMapper,onlineBankingMapper, mapperHelper, cfg, zbaHelper, onlineBkHelper), utility, tmRepository, configRepository, smManager, cfg,archiveRepository, vmBuilder);
	}


	public static List<TmArchiving.IMapper> buildMappers(TmArchiving.IMapper achMapper, TmArchiving.IMapper remitMapper, TmArchiving.IMapper onlineBankingMapper, TmArchiving.IMapperHelper hlp, TmArchiving.IConfiguration cfg, TmArchiving.IZbaMapperHelper zbaHelper, TmArchiving.IOnlineBankingMapperHelper onlineBkHelper) {
		return new List<TmArchiving.IMapper>{
			achMapper
			,new TmArchivingAchFtpMapper(hlp, cfg)
			,new TmArchivingAchSameDayMapper(hlp, cfg)
			,new TmArchivingAchDebitFilterMapper(hlp, cfg)
            ,new TmArchivingAchPositivePayMapper(hlp, cfg)
			,new TmArchivingCtrlDisbrmtMapper(hlp, cfg)
			,new TmArchivingEapMapper(hlp, cfg)
			,new TmArchivingEbRomMapper(hlp, cfg)
			,new TmArchivingEdiMapper(hlp, cfg)
			,new TmArchivingInvstmtSweepMapper(hlp, cfg)
			,new TmArchivingLnInvstmtSweepMapper(hlp, cfg)
			,new TmArchivingLnSweepMapper(hlp, cfg)
			,new TmArchivingLockboxMapper(hlp, cfg)
			,new TmArchivingLockboxDataEntryMapper(hlp, cfg)
			,new TmArchivingLockboxDataExtractMapper(hlp, cfg)
			,new TmArchivingLockboxDataRemtncMapper(hlp, cfg)
			,onlineBankingMapper
			,new TmArchivingPositivePayMapper(hlp, cfg)
			,new TmArchivingPositivePayAutomationMapper(hlp, cfg)
			,new TmArchivingPositivePayWizardMapper(hlp, cfg)
			,new TmArchivingRemoteDepositDesktopMapper(hlp, cfg)
		    ,new TmArchivingRemoteDepositMobileMapper(hlp, cfg)
			,remitMapper
			,new TmArchivingWiresMapper(hlp, cfg)
			,new TmArchivingZbaMapper(hlp, zbaHelper, cfg)
			,new TmArchivingOtherTmProductMapper(hlp, cfg)
		};
		
	}
}