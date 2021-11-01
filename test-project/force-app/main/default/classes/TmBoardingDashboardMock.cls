@IsTest
public class TmBoardingDashboardMock {
	public class ofIDataProvider extends ApexMoq implements TmBoardingDashboard.IDataProvider {
        public List<Tm_Service_Request__c> getRequestWithActivePackets(){
            return (List<Tm_Service_Request__c>)handleMethodInvocation('getRequestWithActivePackets');
        }
        public List<Tm_Service_Request__c> getRequestWithAllPackets() {
            return (List<Tm_Service_Request__c>)handleMethodInvocation('getRequestWithAllPackets');
        }
        public List<Tm_Service_Request__c> getRequestWithActivePackets(List<Id> packetIds) {
            return (List<Tm_Service_Request__c>)handleMethodInvocation('getRequestWithActivePackets', new List<OBject>{packetIds});
        }
        public List<Tm_Service_Request__c> getRequestWithActivePacketsBySearch(String search){
            return (List<Tm_Service_Request__c>)handleMethodInvocation('getRequestWithActivePacketsBySearch', new List<Object>{search});
        }
        public List<Eb_Team_Member__c> getTeamMembers() {
            return (List<Eb_Team_Member__c>)handleMethodInvocation('getTeamMembers');
        }
        public List<TM_Maintenance__c> getAllTmMaintenances() {
            return (List<TM_Maintenance__c>)handleMethodInvocation('getAllTmMaintenances');
        }
        public List<TM_Maintenance__c> getSearchedTmMaintenances(string search) {
            return (List<TM_Maintenance__c>)handleMethodInvocation('getSearchedTmMaintenances', new List<Object>{search});
        }
        public Map<string, PM_Object_Action_Log_c> getStageLogsForTMRequests(){
            return (Map<string, PM_Object_Action_Log_c>)handleMethodInvocation('getStageLogsForTMRequests');
        }
        public List<PM_Entity_Action_c> getEntityActions(){
            return (List<PM_Entity_Action_c>)handleMethodInvocation('getEntityActions');
        }
		public List<PM_Entity_Action_c> getSearchedEntityActions(string search){
            return (List<PM_Entity_Action_c>)handleMethodInvocation('getSearchedEntityActions', new List<Object>{search});
        }
	}

	public class ofIDmBuilder extends ApexMoq implements TmBoardingDashboard.IDmBuilder {
        public List<DmTmPacket> build(List<Tm_Service_Request__c> requests){
            return (List<DmTmPacket>)handleMethodInvocation('build', new List<OBject>{requests});
        }
        public DmUser build(User pm){
            return (DmUser)handleMethodInvocation('build', new List<OBject>{pm});
        }
        public List<TmBoardingDashboard.TmMaintenanceDm> buildTmMaintenances(List<TM_Maintenance__c> requests) {
            return (List<TmBoardingDashboard.TmMaintenanceDm>)handleMethodInvocation('buildTmMaintenances', new List<Object>{requests});
        }
        public List<TmBoardingDashboard.TmMaintenanceDm> buildTmMaintenances(List<PM_Entity_Action_c> pms){
            return (List<TmBoardingDashboard.TmMaintenanceDm>)handleMethodInvocation('buildTmMaintenances', new List<Object>{pms});
        }
	}

	public class ofIRepository extends ApexMoq implements  TmBoardingDashboard.IRepository {
        public TmBoardingDashboard.SearchDm getAllActivePackets(){
            return (TmBoardingDashboard.SearchDm)handleMethodInvocation('getAllActivePackets');
        }
        public TmBoardingDashboard.SearchDm searchAllPacket(String param, String rmId){
            return (TmBoardingDashboard.SearchDm)handleMethodInvocation('searchAllPacket', new List<Object>{param, rmId});
        }
        public DmUser currentUser(){
            return (DmUser)handleMethodInvocation('currentUser');
        }
        public List<TmBoardingDashboard.TmMaintenanceDm> getTmMaintenances(string search) {
            return (List<TmBoardingDashboard.TmMaintenanceDm>)handleMethodInvocation('getTmMaintenances', new List<Object>{search});
        }
        public Map<string, PM_Object_Action_Log_c> getStageLogsForTmRequests(){
            return (Map<string, PM_Object_Action_Log_c>)handleMethodInvocation('getStageLogsForTmRequests');
        }
	}
	public class ofIChartVmBuilder extends ApexMoq implements TmBoardingDashboard.IChartVmBuilder {
        public String type(){
            return (String)handleMethodInvocation('type');
        }
        public TmBoardingDashboard.ChartType handle(){
            return (TmBoardingDashboard.ChartType)handleMethodInvocation('handle');
        }
        public TmBoardingDashboard.ChartVm build(List<DmTmPacket> packetDms){
            return (TmBoardingDashboard.ChartVm)handleMethodInvocation('build', new List<OBject>{packetDms});
        }
	}

	public class ofIVmBuilder extends ApexMoq implements TmBoardingDashboard.IVmBuilder {
        public TmBoardingDashboard.FormVm build(TmBoardingDashboard.SearchDm dm, String rmId, List<TmBoardingDashboard.ChartType> chartTypes, TmBoardingDashBoard.StageVm stageVm){
            return (TmBoardingDashboard.FormVm)handleMethodInvocation('build', new List<Object>{dm, rmId, chartTypes, stageVm });
        }
        public List<TmBoardingDashboard.TmMaintenanceVm> buildTmMaintenanceVms(List<TmBoardingDashboard.TmMaintenanceDm> request) {
            return (List<TmBoardingDashboard.TmMaintenanceVm>)handleMethodInvocation('buildTmMaintenanceVms', new List<Object>{request});
        }
	}

    public class ofIVmFilter extends ApexMoq implements TmBoardingDashboard.IVmFilter {
        public List<DmTmPacket> filterByPacketAndStage(List<DmTmPacket> packetDms , TmBoardingDashboard.StageVm vm) {
            return (List<DmTmPacket>)handleMethodInvocation('filterByPacketAndStage', new List<Object>{packetDms, vm});
        }
        public List<DmTmPacket> filterByRequestAndStage(List<DmTmPacket> packetDms , TmBoardingDashboard.StageVm vm) {
            return (List<DmTmPacket>)handleMethodInvocation('filterByRequestAndStage', new List<Object>{packetDms, vm});
        }
        public List<DmTmPacket> filterPacketsByRequests(TmBoardingDashboard.SearchDm dm, List<DmTmPacket> packetsWithFilteredProducts){
            return (List<DmTmPacket>)handleMethodInvocation('filterPacketsByRequests', new List<Object>{dm, packetsWithFilteredProducts});
        }
        public List<DmTmPacket> filterPacketsByPackets(List<DmTmPacket> packets, List<DmTmPacket> packetsWithFilteredProducts) {
            return (List<DmTmPacket>)handleMethodInvocation('filterPacketsByPackets', new List<Object>{packets, packetsWithFilteredProducts});
        }
        public TmBoardingDashboard.UserVm buildFilteredUser(List<DmUser> userDms, String tmId) {
            return (TmBoardingDashboard.UserVm)handleMethodInvocation('buildFilteredUser', new List<Object>{userDms, tmId});
        }
        public TmBoardingDashboard.StageVm buildFilteredStage(TmBoardingDashboard.StageVm stageVm) {
            return (TmBoardingDashboard.StageVm)handleMethodInvocation('buildFilteredStage', new List<Object>{stageVm});
        }
        public List<TmBoardingDashBoard.StageVm> buildFakeStages() {
            return (List<TmBoardingDashBoard.StageVm>)handleMethodInvocation('buildFakeStages');
        }
        public List<DmTmPacket> removeComplete(List<DmTmPacket> packets) {
            return (List<DmTmPacket>)handleMethodInvocation('removeComplete', new List<Object>{packets});
        }
    }
}