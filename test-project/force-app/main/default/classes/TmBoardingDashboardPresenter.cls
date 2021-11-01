public class TmBoardingDashboardPresenter implements TmBoardingDashboard.IPresenter {

	private final string TM_MAINTENANACE_PERMISSION_NAME = 'TmMaintenancePermissionName';
	private final TmBoardingDashboard.IVmBuilder m_vmBuilder;
	private final TmBoardingDashboard.IRepository m_repository;
	private final Configurations.IConfigurations m_configs;
	private final IUserInfoService m_userInfo;

	public TmBoardingDashboardPresenter(TmBoardingDashboard.IVmBuilder vmBuilder, TmBoardingDashboard.IRepository repository, 
										Configurations.IConfigurations configs, IUserInfoService userInfo) {
		m_vmBuilder = vmBuilder;
		m_repository = repository;
		m_configs = configs;
		m_userInfo = userInfo;
	}

	public TmBoardingDashboard.FormVm buildVm() {
		TmBoardingDashboard.stageVm allActiveStage = new TmBoardingDashboard.stageVm();
		allActiveStage.id = TmBoardingDashboard.ALLACTIVE;
		allActiveStage.name = TmBoardingDashboard.ALL_ACTIVE;
		allActiveStage.type = TmBoardingDashboard.ALL;
		TmBoardingDashboard.searchDm dm = m_repository.getAllActivePackets();
		TmBoardingDashboard.FormVm vm = m_vmBuilder.build(dm, dm.currentUser.id, chartTypes(), allActiveStage);
		return vm;
	}

	public TmBoardingDashboard.FormVm search(String param, String rmId, TmBoardingDashBoard.StageVm stageVm) {
		TmBoardingDashboard.searchDm dm = m_repository.searchAllPacket(param, rmId);
		
		return m_vmBuilder.build(dm, rmId, chartTypes(), stageVm);
	}
    
    public TmBoardingDashboard.AccessVm getAccess() {
        TmBoardingDashboard.AccessVm access = new TmBoardingDashboard.AccessVm();
		String permissionName = m_configs.get(TM_MAINTENANACE_PERMISSION_NAME);
		Boolean hasMaintenancePermission = m_userInfo.hasPermissionSet(permissionName);

        access.tmBoarding = true;
        access.maintenance = hasMaintenancePermission || m_userInfo.isSystemAdministrator();
        
        return access;
    }
    
    public List<TmBoardingDashboard.TmMaintenanceVm> getTmMaintenances(string search) {
        List<TmBoardingDashboard.TmMaintenanceDm> maintenances = m_repository.getTmMaintenances(search);
        
        return m_vmBuilder.buildTmMaintenanceVms(maintenances);
    }

	private List<TmBoardingDashboard.ChartType> chartTypes() {
		return new List<TmBoardingDashboard.ChartType> {
			TmBoardingDashboard.ChartType.Requests
			,TmBoardingDashboard.ChartType.Packets
		};
	}
}