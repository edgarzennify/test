@IsTest
private class TmBoardingDashboardPacketsChartBldrTests {
	private static final TmBoardingDashboardPacketsChartBuilder sut;
    static {
        sut = new TmBoardingDashboardPacketsChartBuilder();
    }
    
    private static testMethod void it_should_handle() {
        
        TmBoardingDashboard.ChartType result = sut.handle();
        
        System.assertEquals(TmBoardingDashboard.ChartType.packets ,result);
    }
    
    private static testMethod void it_should_return_type() {
        
        String result = sut.type();
        
        System.assertEquals('packets' ,result);
    }
    
    private static testMethod void it_should_build_chart_data() {
        DmTmPacket dm = new DmTmPacket();
        dm.id = 'x';
        dm.name = 'y';
        dm.status = 'Pending';
        
        List<DmTmPacket> packetDms = new List<DmTmPacket>{new DmTmPacket()};
        TmBoardingDashboard.ChartVm result = sut.build(packetDms);
        
        System.assertEquals(1,result.dataSet.size());
    }
    
}