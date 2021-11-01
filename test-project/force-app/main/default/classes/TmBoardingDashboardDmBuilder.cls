public class TmBoardingDashboardDmBuilder implements TmBoardingDashboard.IDmBuilder {

	private Map<Id, User> m_user;
	private Map<Id, UserRole> m_role;
	private final IUserInfoService m_userSvc;

	public TmBoardingDashboardDmBuilder(IUserInfoService userSvc) {
		m_userSvc = userSvc;
	}

	public List<DmTmPacket> build(List<Tm_Service_Request__c> requests) {
		Map<Id, DmTmPacket> packetDms = new Map<Id,DmTmPacket>();
		for(Tm_Service_Request__c r: requests){
			if(!packetDms.containsKey(r.TM_Service_Request_Packet__c)){
				DmTmPacket p = buildPacket(r.TM_Service_Request_Packet__r);
				packetDms.put(r.TM_Service_Request_Packet__c, p);
			}
			packetDms.get(r.TM_Service_Request_Packet__c).tmRequests.add(buildRequest(r));
		} 
		return packetDms.values();
	}

	public DmUser build(User pm) {
		DmUser dm = new DmUser();
		if(pm == null) return dm;
		dm.id = pm.Id;
		dm.name = pm.name;
		return dm;
	}

	public List<TmBoardingDashboard.TmMaintenanceDm> buildTmMaintenances(List<PM_Entity_Action_c> pms){
		List<TmBoardingDashboard.TmMaintenanceDm> maintenances = new List<TmBoardingDashboard.TmMaintenanceDm>();
		for(PM_Entity_Action_c pm : pms){
			TmBoardingDashboard.TmMaintenanceDm dm = new TmBoardingDashboard.TmMaintenanceDm();
			dm.status = pm.status_c;
			dm.esignStatus = pm.Esignature_Status_c;
			dm.type = pm.RecordType.name;
			dm.entityId = pm.Entity_r.id;
            dm.entityName = pm.Entity_r.name;
			dm.tmMaintenanceId = pm.id;
            dm.tmMaintenanceName = pm.Name;
			dm.submissionDate = pm.CreatedDate;
			dm.createdBy = pm.createdBy.name;
			dm.assignedTo = pm.Assigned_To_c;
			dm.lastStageUpdateDate = pm.Date_of_Last_Stage_Change_c;
			maintenances.add(dm);
		}
		return maintenances;
	}
    
    public List<TmBoardingDashboard.TmMaintenanceDm> buildTmMaintenances(List<TM_Maintenance__c> requests) {
        List<TmBoardingDashboard.TmMaintenanceDm> maintenances = new List<TmBoardingDashboard.TmMaintenanceDm>();
        
        for (TM_Maintenance__c tm : requests) {
            TmBoardingDashboard.TmMaintenanceDm dm = new TmBoardingDashboard.TmMaintenanceDm();
            dm.status = tm.status__c;
            dm.type = tm.type__c;
            dm.contactId = tm.Contact__c;
            dm.contactName = tm.Contact__r.Name;
            dm.entityId = tm.Contact__r.Account.Id;
            dm.entityName = tm.Contact__r.Account.Entity_Name__c;
            dm.tmMaintenanceId = tm.Id;
            dm.tmMaintenanceName = tm.Name;
            dm.userChangesCount = tm.User_Changes_Count__c;
            dm.entitlementChangesCount = tm.Entitlement_Changes_Count__c;
            dm.submissionDate = tm.CreatedDate;
            
            maintenances.add(dm);
        }
        
        return maintenances;
    }

	private DmEntity buildEntity(Account pm) {
		DmEntity dm = new DmEntity();
		if(pm == null) return dm;
		dm.id = pm.Id;
		dm.name = pm.Name;
		dm.tmRep = new DmUser();
		if(pm.Team_Treasury_Management_Representative__r != null && pm.Team_Treasury_Management_Representative__r.User__c != null){
			User u = getUser(pm.Team_Treasury_Management_Representative__r.User__c);
			dm.tmRep = build(u);
		}
		return dm;
	}

	private DmTmPacket buildPacket(TM_Service_Request_Packet__c pm) {
		DmTmPacket dm = new DmTmPacket();
		if(pm == null) return dm;
		dm.id = pm.Id;
		dm.name = pm.Name;
		dm.status = pm.stage__c;
		dm.LastStatusDate = pm.Last_Stage_Change_Date__c;
		dm.IsRushed = pm.Is_Rushed__c;
		dm.createdDate = pm.createdDate;		
		User u = getUser(pm.createdById);
		User modifiedByUser = getUser(pm.lastModifiedById);
		dm.createdBy = build(u);
		dm.lastModifiedBy = build(modifiedByUser);
		dm.entity = buildEntity(pm.Entity__r);
		dm.tmRequests = new List<DmTmRequest>();

		return dm;
	}

	private DmTmRequest buildRequest(Tm_Service_Request__c pm) {
		DmTmRequest dm = new DmTmRequest();
		dm.id = pm.id;
		dm.name = pm.name;
		dm.recordType = new DmRecordType();
		dm.recordType.id = pm.recordtypeid;
		dm.notes = pm.notes__c;
		dm.recordType.name = pm.recordtype.Name;
		if(pm.Stage__r != null){
			dm.stage = new DmTmRequestStage();
			dm.stage.id = pm.Stage__c;
			dm.stage.name = pm.Stage__r.Name;
		}
		
		dm.createdBy = new DmUser();
		User u = getUser(pm.createdById);
		User modifiedByUser = getUser(pm.lastModifiedById);
		dm.createdBy = build(u);
		dm.createdDate = pm.createdDate;
		dm.lastModifiedBy = build(modifiedByUser);
		dm.assignedTo = pm.Assigned_To__c;

		return dm;
	}

	private User getUser(Id userId) {
		loadUsers();
		return m_user.get(userId);
	}

	private void loadUsers() {
		if(m_user == null) {
			m_user = new Map<Id, User>();
			for(User u :m_userSvc.getUserRoleRelationship().keySet()) {
				m_user.put(u.Id, u); 
			}
		}
	}
}