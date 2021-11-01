public class TmBoardingDashboardRepository implements TmBoardingDashboard.IRepository{

	private final String RELATIONSHIP_MANAGER = 'Relationship Manager';
	private final String PACKET_STATUS_CONFIG_KEY = 'TmBoardingPacketStatuses';
	private final String STATUS_DELIM = '\\|';

	private final TmBoardingDashboard.IDataProvider m_dataProvider;
	private final TmBoardingDashboard.IDmBuilder m_dmBuilder;
	private final TmConfiguration.IStageRepository m_stageRepository;
	private final IUserInfoService m_userSvc;
	private final Utility.IUtility m_util;

	public TmBoardingDashboardRepository(TmBoardingDashboard.IDataProvider dataProvider, TmBoardingDashboard.IDmBuilder dmBuilder, TmConfiguration.IStageRepository stageRepository,
	 IUserInfoService userSvc, Utility.IUtility util) {
		m_dataProvider = dataProvider;
		m_dmBuilder = dmBuilder;
		m_stageRepository = stageRepository;
		m_userSvc = userSvc;
		m_util = util;
	}

	public TmboardingDashboard.searchDm getAllActivePackets() {
		List<Tm_Service_Request__c> requestPms = new List<Tm_Service_Request__c>();
		List<Tm_Service_Request__c> filteredForTestrequestPms = new List<Tm_Service_Request__c>();
		List<Tm_Service_Request__c> filteredForTestAllrequestInOrgPms = new List<Tm_Service_Request__c>();
		TmboardingDashboard.searchDm searchDm = new TmboardingDashboard.searchDm();
		searchDm.currentUser = currentUser();
		
		requestPms = m_dataProvider.getRequestWithActivePackets();
		searchDm.tmos = getTmos(requestPms);
		searchDm.isUserTmo = isCurrentUserTmo(searchDm.tmos);
		if(searchDm.isUserTmo == true){
			filteredForTestrequestPms = filter(requestPms, searchDm.currentUser.id);
		}else{
			filteredForTestrequestPms = filter(requestPms, '');
		}
		filteredForTestAllrequestInOrgPms = filter(requestPms, '');
		List<DmTmPacket> allPacketsInOrg = m_dmBuilder.build(filteredForTestAllrequestInOrgPms);
		List<DmTmPacket> allPackets = m_dmBuilder.build(filteredForTestrequestPms);
		searchDm.allPacketsInOrg = allPacketsInOrg;
		searchDm.packets = allPackets;
		searchDm.packetsWithFilteredProducts = searchDm.packets;
		searchDm.packetStages = getPacketStages();
		searchDm.productStages = m_stageRepository.getAllStages();
		return searchDm;
	}

	public TmboardingDashboard.searchDm searchAllPacket(String param, String rmId) {
		param = sanatizedParam(param);
		List<Tm_Service_Request__c> allrequestInOrgPms = m_dataProvider.getRequestWithAllPackets();
		List<Tm_Service_Request__c> requestPms = m_dataProvider.getRequestWithActivePacketsBySearch(param);
		List<Tm_Service_Request__c> allrequestPm = getAllRequestForPacketIds(requestPms);		
		
		List<Tm_Service_Request__c> allrequestInOrgFilteredPms = filter(allrequestInOrgPms, '');
		List<Tm_Service_Request__c> allfilteredForTestrequestPms = filter(allrequestPm, rmId);
		List<Tm_Service_Request__c> filteredForTestrequestPms = filter(requestPms, rmId);

		List<DmTmPacket> allInOrgDms = m_dmBuilder.build(allrequestInOrgFilteredPms);
		List<DmTmPacket> allDms = m_dmBuilder.build(allfilteredForTestrequestPms);
		List<DmTmPacket> filteredDms = m_dmBuilder.build(filteredForTestrequestPms);

		TmboardingDashboard.searchDm searchDm = new TmboardingDashboard.searchDm();
		searchDm.currentUser = currentUser();
		
		searchDm.tmos = getTmos(requestPms);
		searchDm.isUserTmo = isCurrentUserTmo(searchDm.tmos);
		searchDm.allPacketsInOrg = allInOrgDms;
		searchDm.packets = allDms;
		searchDm.packetsWithFilteredProducts = filteredDms;
		searchDm.packetStages = getPacketStages();
		searchDm.productStages = m_stageRepository.getAllStages();

		return searchDm;
	}

	public TmboardingDashboard.searchDm searchAllPacket(String param, String rmId, String stageId) {
		param = sanatizedParam(param);
		List<Tm_Service_Request__c> allrequestInOrgPms = m_dataProvider.getRequestWithAllPackets();
		List<Tm_Service_Request__c> requestPms = m_dataProvider.getRequestWithActivePacketsBySearch(param);
		List<Tm_Service_Request__c> allrequestPm = getAllRequestForPacketIds(requestPms);		
		
		List<Tm_Service_Request__c> allrequestInOrgFilteredPms = filter(allrequestInOrgPms, '');
		List<Tm_Service_Request__c> allfilteredForTestrequestPms = filter(allrequestPm, rmId);
		List<Tm_Service_Request__c> filteredForTestrequestPms = filter(requestPms, rmId);

		List<DmTmPacket> allInOrgDms = m_dmBuilder.build(allrequestInOrgFilteredPms);
		List<DmTmPacket> allDms = m_dmBuilder.build(allfilteredForTestrequestPms);
		List<DmTmPacket> filteredDms = m_dmBuilder.build(filteredForTestrequestPms);

		TmboardingDashboard.searchDm searchDm = new TmboardingDashboard.searchDm();
		searchDm.currentUser = currentUser();
		
		searchDm.tmos = getTmos(requestPms);
		searchDm.isUserTmo = isCurrentUserTmo(searchDm.tmos);

		searchDm.allPacketsInOrg = allInOrgDms;
		searchDm.packets = allDms;
		searchDm.packetsWithFilteredProducts = filteredDms;
		searchDm.packetStages = getPacketStages();
		searchDm.productStages = m_stageRepository.getAllStages();

		return searchDm;
	}



	public List<DmUser> getTmos() {
		List<DmUser> tmos = new List<DmUser>();
		for(Eb_Team_Member__c t :  m_dataProvider.getTeamMembers()) {
			if(String.isNotBlank(t.User__c)) {
				DmUser dm = m_dmBuilder.build(t.User__r);
				dm.officerCode = t.Officer_Code__c;
				tmos.add(dm);
			}
		}
		return tmos;
	}

	public List<DmUser> getTmos(List<Tm_Service_Request__c> requests) {
		Set<Id> ids = new Set<Id>();
		List<DmUser> tmos = new List<DmUser>();
		for(Tm_Service_Request__c r : requests) {
			User u = r.TM_Service_Request_Packet__r.Entity__r.Team_Treasury_Management_Representative__r.User__r;
			if(u != null && !ids.contains(u.Id) ){
				DmUser dm = m_dmBuilder.build(u);
				tmos.add(dm);
				ids.add(u.id);
			}		
		}
		return tmos;
	}

	public DmUser currentUser() {
		Id userId = m_userSvc.getCurrentUserId();
		for(User u : m_userSvc.getUserRoleRelationship().keyset()) {
			if(u.Id == userId) {
				return m_dmBuilder.build(u);
			}
		}
		return null;
	}

	public boolean isCurrentUserTmo(List<DmUser> users){
		DmUser currentUser = currentUser();
		for(DmUser u : users) {
			if(u.id == currentUser.id) {
				return true;
			}
		}
		return false;
	}
    
    public List<TmBoardingDashboard.TmMaintenanceDm> getTmMaintenances(string search) {
        if (String.isBlank(search)) {
			List<PM_Entity_Action_c> pmMaints = m_dataProvider.getEntityActions();
			return m_dmBuilder.buildTmMaintenances(pmMaints);
        }
        
        List<PM_Entity_Action_c> pmMaintSearched = m_dataProvider.getSearchedEntityActions(search);
        return m_dmBuilder.buildTmMaintenances(pmMaintSearched);
    }

	public Map<string, PM_Object_Action_Log_c> getStageLogsForTmRequests(){
		return m_dataProvider.getStageLogsForTMRequests();
	}

	private List<DmTmPacketStage> getPacketStages() {
		List<DmTmPacketStage> stages = new List<DmTmPacketStage>();

		for(SelectOption o : m_util.ListValuesFromObject('TM_Service_Request_Packet__c', 'Stage__c')){
			DmTmPacketStage stage = new DmTmPacketStage();
			if(o.getLabel() != '--None--'){
				stage.id = o.getLabel();
				stage.name = o.getLabel();
				stages.add(stage);
			}
		}

		return stages;
	}

	private List<TM_Service_Request__c> getAllRequestForPacketIds(List<TM_Service_Request__c> requestPms) {
		Set<Id> packetIds = new Set<Id>();
		for(TM_Service_Request__c r : requestPms) {
			packetIds.add(r.TM_Service_Request_Packet__c);
		}
		List<Id> packetIdList = new List<Id>(packetIds);
		return m_dataProvider.getRequestWithActivePackets(packetIdList);
	}

	private List<DmTmPacket> filterByRm(List<DmTmPacket> dms , DmUser currentUser) {
		List<DmTmPacket> filteredDms = new List<DmTmPacket>();
		for(DmTmPacket dm : dms) {
			if(dm.entity.relationshipManager.id == currentUser.id) {
				filteredDms.add(dm);
			}
		}
		return filteredDms;
	}

	private String sanatizedParam(String searchTerm) {
		searchTerm = searchTerm.replace('*', ' ');                      
        searchTerm = searchTerm.trim();
        searchTerm = searchTerm.replace('  ', ' ');
        searchTerm = searchTerm.replace('  ', ' ');
        searchTerm = searchTerm.replace(' ', '%');
        searchTerm = '%' + searchTerm + '%';

        return searchTerm;
	}

	private List<Tm_Service_Request__c>  filter(List<Tm_Service_Request__c> pms, String rmId) {
		List<Tm_Service_Request__c> filtered = new List<Tm_Service_Request__c>();
		if(pms == null){return filtered;}
		for(Tm_Service_Request__c r : pms) {
			if(r.TM_Service_Request_Packet__r != null && r.TM_Service_Request_Packet__r.name != null 
               && r.TM_Service_Request_Packet__r.Entity__r != null
               && r.TM_Service_Request_Packet__r.Entity__r.Name != null
              ){
				if(!r.TM_Service_Request_Packet__r.name.tolowercase().contains('test') &&
                  !r.TM_Service_Request_Packet__r.Entity__r.Name.tolowercase().contains('buffalo bill')
                  ) {
					if(String.isBlank(rmId) == true) {
						filtered.add(r);
					}else if(r.TM_Service_Request_Packet__r.Entity__r.Team_Treasury_Management_Representative__r != null && String.valueof(r.TM_Service_Request_Packet__r.Entity__r.Team_Treasury_Management_Representative__r.User__c) == rmId){
						filtered.add(r);
					}				
				}
			} 
		}
		return filtered;
	}
}