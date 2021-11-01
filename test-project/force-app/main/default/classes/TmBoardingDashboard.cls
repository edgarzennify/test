global class TmBoardingDashboard {

	public interface IDataProvider {
		List<Tm_Service_Request__c> getRequestWithActivePackets();
		List<Tm_Service_Request__c> getRequestWithAllPackets();
		List<Tm_Service_Request__c> getRequestWithActivePackets(List<Id> packetIds);
		List<Tm_Service_Request__c> getRequestWithActivePacketsBySearch(String search);
		List<EB_Team_Member__c> getTeamMembers();
        List<TM_Maintenance__c> getAllTmMaintenances();
        List<TM_Maintenance__c> getSearchedTmMaintenances(string search);
		List<PM_Entity_Action_c> getEntityActions();
		List<PM_Entity_Action_c> getSearchedEntityActions(string search);
		Map<string, PM_Object_Action_Log_c> getStageLogsForTMRequests();
	}

	public interface IDmBuilder {
		List<DmTmPacket> build(List<Tm_Service_Request__c> requests);
		DmUser build(User pm);
        List<TmMaintenanceDm> buildTmMaintenances(List<TM_Maintenance__c> requests);
		List<TmMaintenanceDm> buildTmMaintenances(List<PM_Entity_Action_c> pms);
	}

	public interface IRepository {
		SearchDm getAllActivePackets();
		SearchDm searchAllPacket(String param, String rmId);
		DmUser currentUser();
        List<TmMaintenanceDm> getTmMaintenances(string search);
		Map<string, PM_Object_Action_Log_c> getStageLogsForTmRequests();
	}
	public interface IChartVmBuilder {
		String type();
		ChartType handle();
		ChartVm build(List<DmTmPacket> packetDms);
	}

	public interface IVmBuilder {
		FormVm build(SearchDm dm, String rmId, List<ChartType> chartTypes, StageVm stageVm);
        List<TmMaintenanceVm> buildTmMaintenanceVms(List<TmMaintenanceDm> request);
	}

	public interface IVmFilter {
		List<DmTmPacket> filterByPacketAndStage(List<DmTmPacket> packetDms , StageVm vm);
		List<DmTmPacket> filterByRequestAndStage(List<DmTmPacket> packetDms , StageVm vm);
		List<DmTmPacket> filterPacketsByRequests(SearchDm dm, List<DmTmPacket> packetsWithFilteredProducts);
		List<DmTmPacket> filterPacketsByPackets(List<DmTmPacket> packets, List<DmTmPacket> packetsWithFilteredProducts);
		UserVm buildFilteredUser(List<DmUser> userDms, String tmId);
		StageVm buildFilteredStage(StageVm stageVm);
		List<TmBoardingDashBoard.StageVm> buildFakeStages();
		List<DmTmPacket> removeComplete(List<DmTmPacket> packets);
	}

	public interface IPresenter {
		FormVm buildVm();
		FormVm search(String param, String rmId, StageVm stageVm);
        AccessVm getAccess();
        List<TmMaintenanceVm> getTmMaintenances(string search);
	}

	global class FormVm {
		public Map<String, ChartVm> charts {get;set;}
		public UserVm currentUser {get;set;}
		public List<UserVm> allRms {get;set;}
		public List<StageVm> stages {get;set;}
		public StageVm filterByStage {get;set;}
		public UserVm filterByUser {get;set;}
		public List<LayoutComponent> packets{get;set;}
		public List<LayoutComponent> products{get;set;}
		public String serverUrl{get;set;}
		public boolean isUserTmo{get;set;}
	}

	global class FormVm2{
		List<PacketComponent> packets{get;set;}
		List<ProductComponent> products{get;set;}
	}

	public class PacketComponent{
		public String id {get;set;}
        public String name {get;set;}
        public String entity {get;set;}
        public String entityId {get;set;}
		public String tmRep {get;set;}
        public String tmRepId {get;set;}
        public String stage {get;set;}
		public DateTime lastStageChange {get;set;}
		public DateTime createdDate{get;set;}
		public String createdBy{get;set;}
        public String createdById{get;set;}
        public String lastModifiedBy{get;set;}
        public String lastModifiedById{get;set;}
		public List<string> productIds{get;set;}
	}

	public class ProductComponent{
		public String id {get;set;}
        public String name {get;set;}
		public String stage {get;set;}
		public DateTime lastStageChange {get;set;}
		public String notes {get;set;}
		public String assignedTo {get;set;}
		public Boolean rushed {get;set;}
		public DateTime createdDate{get;set;}
		public DateTime opsStageDate{get;set;}
        public String createdBy{get;set;}
        public String createdById{get;set;}
        public String lastModifiedBy{get;set;}
        public String lastModifiedById{get;set;}
	}

	public class ChartVm {
		public List<String> labels {get;set;}
		public List<Integer> dataSet {get;set;}
	}

	public class LayoutComponent implements Comparable {
		public String id {get;set;}
        public String name {get;set;}
        public String entity {get;set;}
        public String entityId {get;set;}
        public String tmRep {get;set;}
        public String tmRepId {get;set;}
        public String stage {get;set;}
		public DateTime lastStageChange {get;set;}
        public String product {get;set;}
		public String notes {get;set;}
        public String type {get;set;}
        public String assignedTo {get;set;}
		public Boolean rushed {get;set;}
        public String relatedToPacketId {get;set;}
        public DateTime createdDate{get;set;}
		public DateTime opsStageDate{get;set;}
        public String createdBy{get;set;}
        public String createdById{get;set;}
        public String lastModifiedBy{get;set;}
        public String lastModifiedById{get;set;}
        public Integer relationshipCount{get;set;}

		public Integer compareTo(Object compareTo) {
			LayoutComponent other = (LayoutComponent) compareTo;
			if(product == ''){
				if(name == other.name) {
						return 0;
					}else {
						return -1;
					}
			}else {
				if (product < other.product) return - 1;
				if (product == other.product) return 0;
			}
			
			return 1;
		}
	}

	global class UserVm implements Comparable {
		public String id {get;set;}
		public String name {get;set;}
		public String officerCode {get;set;}

		public Integer compareTo(Object compareTo) {

			UserVm other = (UserVm) compareTo;
			if(name < other.name) return -1;
			if(name == other.name) return 0;
			return 1;
		}
	}

	public class StageVm {
		public String id {get;set;}
		public String name {get;set;}
		public String type{get;set;}
	}

     global class AccessVm {
        public Boolean tmBoarding {get;set;}
        public Boolean maintenance {get;set;}
    }
    
    global class TmMaintenanceVm {
        public string status {get;set;}
		public string esignStatus{get;set;}
        public string type {get;set;}
        public string contactId {get;set;}
        public string contactName {get;set;}
        public string entityId {get;set;}
        public string entityName {get;set;}
        public string tmMaintenanceId {get;set;}
        public string tmMaintenanceName {get;set;}
        public datetime submissionDate {get;set;}
		public string assignedTo{get;set;}
		public string createdBy{get;set;}
		public DateTime lastStageUpdateDate{get;set;}
        public decimal userChangesCount {get;set;}
        public decimal entitlementChangesCount {get;set;}
    }
    
	public class searchDm {
		public List<DmTmPacket> allPacketsInOrg{get;set;}
		public List<DmTmPacket> packets{get;set;}
		public List<DmTmPacket> packetsWithFilteredProducts{get;set;}
		public List<DmUser> tmos{get;set;}
		public List<DmTmPacketStage> packetStages{get;set;}
		public List<DmTmRequestStage> productStages{get;set;}
		public DmUser currentUser{get;set;}
		public boolean isUserTmo{get;set;}
	}
    
    public class TmMaintenanceDm {
        public string status {get;set;}
		public string esignStatus{get;set;}
        public string type {get;set;}
        public string contactId {get;set;}
        public string contactName {get;set;}
        public string entityId {get;set;}
        public string entityName {get;set;}
        public string tmMaintenanceId {get;set;}
        public string tmMaintenanceName {get;set;}
        public datetime submissionDate {get;set;}
		public string assignedTo{get;set;}
		public string createdBy{get;set;}
		public DateTime lastStageUpdateDate{get;set;}
        public decimal userChangesCount {get;set;}
        public decimal entitlementChangesCount {get;set;}
    }
    
   

	public static String PACKET = 'packet';
	public static String REQUEST = 'request';

	public static String COMPLETE = 'Complete';
	public static String PENDING = 'Pending';
	public static String READY_FOR_OPS_SETUP = 'Ready for Ops Setup';

	public static String ALL = 'All';
	public static String ALLACTIVE = 'AllActive';
	public static String ALL_ACTIVE = 'All - Active';

	public Enum ChartType {Packets, Requests}
}