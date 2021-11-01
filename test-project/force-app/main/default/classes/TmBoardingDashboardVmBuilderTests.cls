@IsTest
private class TmBoardingDashboardVmBuilderTests {

    private static final TmBoardingDashboardMock.ofIChartVmBuilder mockChart1;
    private static final TmBoardingDashboardMock.ofIChartVmBuilder mockChart2;
    private static final TmBoardingDashboardMock.ofIVmFilter mockFilter;
    private static final Mock.ofIUtility mockUtility;
    private static final TmBoardingDashboardMock.ofIRepository mockRepository;
    private static final TmBoardingDashboardVmBuilder sut;
    
    static {
        mockChart1 = new TmBoardingDashboardMock.ofIChartVmBuilder();
        mockChart2 = new TmBoardingDashboardMock.ofIChartVmBuilder();
        mockFilter = new TmBoardingDashboardMock.ofIVmFilter();
        mockUtility = new Mock.ofIUtility();
        List<TmBoardingDashboardMock.ofIChartVmBuilder> mockCharts = new List<TmBoardingDashboardMock.ofIChartVmBuilder>{
            mockChart1, mockChart2
        };
        mockRepository = new TmBoardingDashboardMock.ofIRepository();
        sut = new TmBoardingDashboardVmBuilder(mockCharts, mockFilter, mockUtility, mockRepository);
    }

    @IsTest
	static void it_should_build_the_all_rm_list_based_on_packets() {
        TmBoardingDashboard.stageVm stageVm = new TmBoardingDashboard.stageVm();
        stageVm.type = TmBoardingDashboard.PACKET;
        stageVm.id = 'Pending';
        stageVm.name = 'Pending';

        TmBoardingDashboard.SearchDm dm = new TmBoardingDashboard.SearchDm();
        DmUser tmRep = new DmUser();
        tmRep.id = '1';
        tmRep.name = 'test';
        tmRep.officerCode = 'dwsf';

        DmUser anotherTmRep = new DmUser();
        anotherTmRep.id = '2';
        anotherTmRep.name = 'test2';
        anotherTmRep.officerCode = 'dwsf';

        DmTmPacket packet1 = new DmTmPacket();
        packet1.entity = new DmEntity();
        packet1.entity.tmrep = tmrep;
        List<DmTmPacket> allPacketsInOrg = new List<DmTmPacket>{
            packet1
        };

        dm.packetsWithFilteredProducts = new List<DmTmPacket>();
        dm.currentUser = new DmUser();
        dm.isUserTmo = true;
        dm.allPacketsInOrg = allPacketsInOrg;
        dm.packetStages = new List<DmTmPacketStage>{new DmTmPacketStage()};
        dm.productStages = new List<DmTmRequestStage>{new DmTmRequestStage()};
        
        DmTmPacket packet = new DmTmPacket();
        DmEntity entity = new DmEntity();
       
        entity.tmRep = tmRep;
        entity.name = '';
        packet.entity = entity;
        packet.name = 'test';
        packet.createdBy = new DmUser();
        packet.lastModifiedBy = new DmUser();


        List<DmUser> tmos = new List<DmUser> {tmRep, anotherTmRep};
        dm.tmos = tmos;

        dm.packets = new List<DmTmPacket>{packet};
        TmBoardingDashboard.ChartVm chart1 = new TmBoardingDashboard.ChartVm();
        List<TmBoardingDashboard.ChartType> chartTypes = new List<TmBoardingDashboard.ChartType>{
            TmBoardingDashboard.ChartType.packets
            ,TmBoardingDashboard.ChartType.requests
        };
        Map<string,List<ObjectActionLogService.Data>> logs = new Map<string,List<ObjectActionLogService.Data>>();
        mockChart1.setup('handle').returns(TmBoardingDashboard.ChartType.packets);
        mockChart1.setup('type').returns('packets');
        mockChart1.setup('build', new List<OBject>{dm.packets}).returns(chart1);
        mockChart2.setup('handle').returns(TmBoardingDashboard.ChartType.requests);
        mockFilter.setup('buildFakeStages').returns(new List<TmBoardingDashboard.StageVm>());

        TmBoardingDashboard.FormVm result = sut.build(dm, '', chartTypes, stageVm);

        System.assertEquals(result.allRms.size(), 2);
        System.assertEquals(result.allRms[0].id, '1');
    }

    @IsTest
	static void it_should_build_the_all_rm_list_based_on_requests() {
        TmBoardingDashboard.stageVm stageVm1 = new TmBoardingDashboard.stageVm();
        stageVm1.type = TmBoardingDashboard.REQUEST;
        stageVm1.id = 'New';
        stageVm1.name = 'New';
        stageVm1.type = 'request';

        TmBoardingDashboard.SearchDm dm = new TmBoardingDashboard.SearchDm();
        DmUser tmRep = new DmUser();
        tmRep.id = '1';
        tmRep.name = 'test';
        tmRep.officerCode = 'dwsf';

        DmUser anotherTmRep = new DmUser();
        anotherTmRep.id = '2';
        anotherTmRep.name = 'test2';
        anotherTmRep.officerCode = 'dwsf';

        DmTmPacket packet1 = new DmTmPacket();
        packet1.entity = new DmEntity();
        packet1.entity.tmrep = tmrep;
        List<DmTmPacket> allPacketsInOrg = new List<DmTmPacket>{
            packet1
        };

        dm.packetsWithFilteredProducts = new List<DmTmPacket>();
        dm.currentUser = new DmUser();
        dm.isUserTmo = true;
        dm.allPacketsInOrg = allPacketsInOrg;
        dm.packetStages = new List<DmTmPacketStage>{new DmTmPacketStage()};
        dm.productStages = new List<DmTmRequestStage>{new DmTmRequestStage()};
        
        DmTmPacket packet = new DmTmPacket();
        DmEntity entity = new DmEntity();
       
        entity.tmRep = tmRep;
        entity.name = '';
        packet.entity = entity;
        packet.name = 'test';
        packet.createdBy = new DmUser();
        packet.lastModifiedBy = new DmUser();

        List<DmUser> tmos = new List<DmUser> {tmRep, anotherTmRep};
        dm.tmos = tmos;

        dm.packets = new List<DmTmPacket>{packet};
        TmBoardingDashboard.ChartVm chart1 = new TmBoardingDashboard.ChartVm();
        List<TmBoardingDashboard.ChartType> chartTypes = new List<TmBoardingDashboard.ChartType>{
            TmBoardingDashboard.ChartType.packets
            ,TmBoardingDashboard.ChartType.requests
        };
        Map<string,List<ObjectActionLogService.Data>> logs = new Map<string,List<ObjectActionLogService.Data>>();
        mockChart1.setup('handle').returns(TmBoardingDashboard.ChartType.packets);
        mockChart1.setup('type').returns('packets');
        mockChart1.setup('build', new List<OBject>{dm.packets}).returns(chart1);
        mockChart2.setup('handle').returns(TmBoardingDashboard.ChartType.requests);
        mockFilter.setup('buildFakeStages').returns(new List<TmBoardingDashboard.StageVm>{stageVm1});

        TmBoardingDashboard.FormVm result = sut.build(dm, '', chartTypes, stageVm1);

        System.assertEquals(result.allRms.size(), 2);
        System.assertEquals(result.allRms[0].id, '1');
    }

    @IsTest
	static void it_should_build_the_all_rm_list_based_on_requests_all_actives() {
        TmBoardingDashboard.stageVm stageVm1 = new TmBoardingDashboard.stageVm();
        stageVm1.type = TmBoardingDashboard.ALLACTIVE;
        stageVm1.id = 'New';
        stageVm1.name = 'New';
        stageVm1.type = 'request';

        TmBoardingDashboard.SearchDm dm = new TmBoardingDashboard.SearchDm();
        DmUser tmRep = new DmUser();
        tmRep.id = '1';
        tmRep.name = 'test';
        tmRep.officerCode = 'dwsf';

        DmUser anotherTmRep = new DmUser();
        anotherTmRep.id = '2';
        anotherTmRep.name = 'test2';
        anotherTmRep.officerCode = 'dwsf';

        DmTmPacket packet1 = new DmTmPacket();
        packet1.entity = new DmEntity();
        packet1.entity.tmrep = tmrep;
        List<DmTmPacket> allPacketsInOrg = new List<DmTmPacket>{
            packet1
        };

        dm.packetsWithFilteredProducts = new List<DmTmPacket>();
        dm.currentUser = new DmUser();
        dm.isUserTmo = true;
        dm.allPacketsInOrg = allPacketsInOrg;
        dm.packetStages = new List<DmTmPacketStage>{new DmTmPacketStage()};
        dm.productStages = new List<DmTmRequestStage>{new DmTmRequestStage()};
        
        DmTmPacket packet = new DmTmPacket();
        DmEntity entity = new DmEntity();
       
        entity.tmRep = tmRep;
        entity.name = '';
        packet.entity = entity;
        packet.name = 'test';
        packet.createdBy = new DmUser();
        packet.lastModifiedBy = new DmUser();

        List<DmUser> tmos = new List<DmUser> {tmRep, anotherTmRep};
        dm.tmos = tmos;
        List<DmTmPacket> packets = new List<DmTmPacket>{packet};
        dm.packets = packets;
        TmBoardingDashboard.ChartVm chart1 = new TmBoardingDashboard.ChartVm();
        List<TmBoardingDashboard.ChartType> chartTypes = new List<TmBoardingDashboard.ChartType>{
            TmBoardingDashboard.ChartType.packets
            ,TmBoardingDashboard.ChartType.requests
        };
        Map<string,List<ObjectActionLogService.Data>> logs = new Map<string,List<ObjectActionLogService.Data>>();
        mockChart1.setup('handle').returns(TmBoardingDashboard.ChartType.packets);
        mockChart1.setup('type').returns('packets');
        mockChart1.setup('build', new List<OBject>{dm.packets}).returns(chart1);
        mockChart2.setup('handle').returns(TmBoardingDashboard.ChartType.requests);
        mockFilter.setup('buildFakeStages').returns(new List<TmBoardingDashboard.StageVm>{stageVm1});
        mockFilter.setup('filterPacketsByRequests', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(packets);

        TmBoardingDashboard.FormVm result = sut.build(dm, '', chartTypes, stageVm1);

        System.assertEquals(result.allRms.size(), 2);
        System.assertEquals(result.allRms[0].id, '1');
    }

    @IsTest
	static void it_should_build_tm_maintenance() {

        TmBoardingDashboard.TmMaintenanceDm dm = new TmBoardingDashboard.TmMaintenanceDm();
        dm.status = 'test status';
        List<TmBoardingDashboard.TmMaintenanceDm> request = new List<TmBoardingDashboard.TmMaintenanceDm>{dm};

        List<TmBoardingDashboard.TmMaintenanceVm> results = sut.buildTmMaintenanceVms(request);

        System.assertEquals('test status', results[0].status);
    }
}