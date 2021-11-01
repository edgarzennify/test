@IsTest
private class TmBoardingDashboardVmFilterTests {
    private static TmBoardingDashboardVmFilter sut;
    static {
        sut = new TmBoardingDashboardVmFilter();
    }
    
    private static testMethod void it_should_filter_by_packet_and_stage() {
        DmTmPacket packet = new DmTmPacket();
        packet.status = 'Pending';
        List<DmTmPacket> packetDms = new List<DmTmPacket>{packet};
        TmBoardingDashboard.StageVm vm = new TmBoardingDashboard.StageVm();
        vm.type = 'packet';
        vm.id = 'Pending';
        vm.name = 'Pending';
        
        List<DmTmPacket> result = sut.filterByPacketAndStage(packetDms , vm);
        
        System.assertEquals(1, result.size());
    }
    
    private static testMethod void it_should_filter_by_request_and_stage() {
        DmTmPacket packet = new DmTmPacket();
        DmTmRequest req = new DmTmRequest();
        req.stage = new DmTmRequestStage();
        req.stage.id = 'x1';
        packet.tmRequests = new List<DmTmRequest>{req};
        TmBoardingDashboard.StageVm stageVm = new TmBoardingDashboard.StageVm();
        stageVm.type = 'request';
        stageVm.id = 'x1';
        List<DmTmPacket> packetDms = new List<DmTmPacket>{packet};
            
        List<DmTmPacket> result = sut.filterByRequestAndStage( packetDms , stageVm);
        
        System.assertEquals(1, result.size());
    }
    
    private static testMethod void it_should_build_filtered_user() {
        String tmId = 'x1';
        DmUser dusr = new DmUser();
        dusr.id = tmId;
        dusr.name = 'name';
        List<DmUser> userDms = new List<DmUser>{dusr};
        
        TmBoardingDashBoard.UserVm result = sut.buildFilteredUser(userDms, tmId);
        
        System.assertEquals(tmId, result.id);
    }
    
    private static testMethod void it_should_build_an_empty_stage() {
        TmBoardingDashBoard.StageVm stageVm = new TmBoardingDashBoard.StageVm();
        
        TmBoardingDashBoard.StageVm result =  sut.buildFilteredStage(stageVm);
        
        System.assertEquals('', result.name);
    }

    private static void it_should_fileter_packets_by_requests() {
        TmBoardingDashboard.SearchDm dm = new TmBoardingDashboard.SearchDm();
        DmTmPacket packetDm = new DmTmPacket();
        List<DmTmPacket> packetsWithFilteredProducts = new List<DmTmPacket>{packetDm};

        List<DmTmPacket> result = sut.filterPacketsByRequests(dm, packetsWithFilteredProducts);

        System.assertEquals(1, result.size());
    }

    private static void it_should_filter_packets_by_packets(){
        DmTmPacket dm = new DmTmPacket();
        dm.id = 'test-packet-id';
        List<DmTmPacket> packets = new List<DmTmPacket>{dm};
        List<DmTmPacket> packetsWithFilteredProducts = new List<DmTmPacket>{dm};

        List<DmTmPacket> result = sut.filterPacketsByPackets( packets,  packetsWithFilteredProducts);

        System.assertEquals(1, result.size());
    }
}