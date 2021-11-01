@IsTest
private class TmBoardingDashboardRequestsChartBldTests {
	private static final TmBoardingDashboardRequestsChartBuilder sut;
    static {
        sut = new TmBoardingDashboardRequestsChartBuilder();
    }
    
     private static testMethod void it_should_handle() {
        
        TmBoardingDashboard.ChartType result = sut.handle();
        
        System.assertEquals(TmBoardingDashboard.ChartType.requests ,result);
    }
    
    private static testMethod void it_should_return_type() {
        
        String result = sut.type();
        
        System.assertEquals('requests' ,result);
    }
    
    private static testMethod void it_should_build_chart_data() {
        DmTmRequest dmr = new DmTmRequest();
        dmr.id = '1';
        dmr.name = '1name';
        dmr.stage = new DmTmRequestStage();
        dmr.stage.name = 'new';
        dmr.recordType = new DmRecordtype();
        dmr.recordType.name = 'lockbox';
        DmTmPacket dm = new DmTmPacket();
        dm.id = 'x';
        dm.name = 'y';
        dm.status = 'Pending';
        dm.tmRequests = new List<DmTmRequest>{dmr};
        
        
        List<DmTmPacket> packetDms = new List<DmTmPacket>{dm};
        TmBoardingDashboard.ChartVm result = sut.build(packetDms);
        
        System.assertEquals(1,result.dataSet.size());
    }
}