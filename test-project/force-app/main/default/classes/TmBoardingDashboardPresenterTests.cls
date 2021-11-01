@IsTest
private class TmBoardingDashboardPresenterTests {
	
    private static final TmBoardingDashboardPresenter sut;
    private static final TmBoardingDashboardMock.ofIVmBuilder mockVmBuilder;
    private static final TmBoardingDashboardMock.ofIRepository mockRepository;
    private static final Mock.ofIConfigurations mockConfigs;
    private static final Mock.ofIUserInfoService mockUserInfo;

    static {
        mockVmBuilder = new TmBoardingDashboardMock.ofIVmBuilder();
        mockRepository = new TmBoardingDashboardMock.ofIRepository();
        mockConfigs = new Mock.ofIConfigurations();
        mockUserInfo = new Mock.ofIUserInfoService();
        sut = new TmBoardingDashboardPresenter(mockVmBuilder, mockRepository, mockConfigs, mockUserInfo);
    }

    @IsTest
    static void it_should_call_the_repository_to_get_packet_data() {
        TmBoardingDashboard.searchDm dm = new TmBoardingDashboard.searchDm();
        dm.currentUser = new DmUser();
        mockRepository.setup('getAllActivePackets').returns(dm);

        TmBoardingDashboard.FormVm vm = sut.buildVm();
        
        mockRepository.verify('getAllActivePackets', Times.Once);
    }
	
    @IsTest
    static void it_should_call_the_vm_builder_to_build_form_vm() {
        TmBoardingDashboard.searchDm dm = new TmBoardingDashboard.searchDm();
        dm.currentUser = new DmUser();
        List<TmBoardingDashboard.ChartType> chartTypes = new List<TmBoardingDashboard.ChartType> {
			TmBoardingDashboard.ChartType.Requests
			,TmBoardingDashboard.ChartType.Packets
		};
        mockRepository.setup('getAllActivePackets').returns(dm);
        
        TmBoardingDashboard.FormVm vm = sut.buildVm();

        mockVmBuilder.verify('build', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
    }

    @IsTest
    static void it_should_call_the_repository_to_search_packets() {
        TmBoardingDashboard.searchDm dm = new TmBoardingDashboard.searchDm();
        String rmId = '1234';
        String param = 'real';
        dm.currentUser = new DmUser();
        TmBoardingDashBoard.StageVm stageVm = new TmBoardingDashBoard.StageVm();
        List<TmBoardingDashboard.ChartType> chartTypes = new List<TmBoardingDashboard.ChartType> {
            TmBoardingDashboard.ChartType.Requests
            ,TmBoardingDashboard.ChartType.Packets
        };
        mockRepository.setup('searchAllPacket', new List<OBject>{param, rmId}).returns(dm.packets);

        TmBoardingDashboard.FormVm result = sut.search(param, rmId, stageVm);

        mockVmBuilder.verify('build', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
    }

    @IsTest
    static void it_should_get_access() {
        String configGet = 'TmMaintenancePermissionName';
        string configResponse = 'yes';

        mockConfigs.setup('get', new List<Object>{configGet}).returns(configResponse);
        mockUserInfo.setup('hasPermissionSet', new List<Object>{configResponse}).returns(true);
        mockUserInfo.setup('isSystemAdministrator').returns(true);

        TmBoardingDashboard.AccessVm results = sut.getAccess();

        System.assertEquals(true, results.maintenance);
        System.assertEquals(true, results.tmBoarding);
        mockUserInfo.verify('isSystemAdministrator', Times.Never);
    }

    @IsTest
    static void it_should_get_access_via_admin() {
        String configGet = 'TmMaintenancePermissionName';
        string configResponse = 'yes';

        mockConfigs.setup('get', new List<Object>{configGet}).returns(configResponse);
        mockUserInfo.setup('hasPermissionSet', new List<Object>{configResponse}).returns(false);
        mockUserInfo.setup('isSystemAdministrator').returns(true);

        TmBoardingDashboard.AccessVm results = sut.getAccess();

        System.assertEquals(true, results.maintenance);
        System.assertEquals(true, results.tmBoarding);
        mockUserInfo.verify('isSystemAdministrator', Times.Once);
    }

    @IsTest
    static void it_should_get_maintenance() {
        String search = 'sear';
        List<TmBoardingDashboard.TmMaintenanceDm> repoResults = new List<TmBoardingDashboard.TmMaintenanceDm>();
        TmBoardingDashboard.TmMaintenanceVm vm = new TmBoardingDashboard.TmMaintenanceVm();
        vm.status = 'test';
        List<TmBoardingDashboard.TmMaintenanceVm> vmResults = new List<TmBoardingDashboard.TmMaintenanceVm>{vm};

        mockRepository.setup('getTmMaintenances', new List<Object>{search}).returns(repoResults);
        mockVmBuilder.setup('buildTmMaintenanceVms', new List<Object>{repoResults}).returns(vmResults);

        List<TmBoardingDashboard.TmMaintenanceVm> results = sut.getTmMaintenances(search);

        mockRepository.verify('getTmMaintenances', new List<Object>{search}, Times.Once);
        mockVmBuilder.verify('buildTmMaintenanceVms', new List<Object>{repoResults}, Times.Once);
        System.assertEquals('test', results[0].status);
    }
}