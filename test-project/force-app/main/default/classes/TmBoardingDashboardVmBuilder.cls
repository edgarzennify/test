public class TmBoardingDashboardVmBuilder implements TmBoardingDashboard.IVmBuilder {

	private Map<string, PM_Object_Action_Log_c> m_logs;
	private final List<TmBoardingDashboard.IChartVmBuilder> m_chartVmBuilders;
	private final TmBoardingDashboard.IVmFilter m_filter;
	private final Utility.IUtility m_util;
	private final TmBoardingDashboard.IRepository m_repo;

	public TmBoardingDashboardVmBuilder(List<TmBoardingDashboard.IChartVmBuilder> chartVmBuilders, TmBoardingDashboard.IVmFilter filter, Utility.IUtility util, TmBoardingDashboard.IRepository repo) {
		m_chartVmBuilders = chartVmBuilders;
		m_filter = filter;
		m_util = util;
		m_repo = repo;
	}

	public TmBoardingDashboard.FormVm build(TmBoardingDashboard.SearchDm dm, String rmId, List<TmBoardingDashboard.ChartType> chartTypes, TmBoardingDashboard.StageVm stageVm) {	
		TmBoardingDashboard.FormVm formVm = new TmBoardingDashboard.FormVm();
		Map<String, TmBoardingDashboard.ChartVm> charts = new Map<String, TmBoardingDashboard.ChartVm>();
		List<DmTmPacket> packets = new List<DmTmPacket>();
		List<DmTmPacket> packetsWithFilteredProducts = new List<DmTmPacket>();
		packets = m_filter.filterByPacketAndStage(dm.packets, stageVm);
		packetsWithFilteredProducts = m_filter.filterByRequestAndStage(dm.packetsWithFilteredProducts, stageVm);

		if(stageVm.type == TmBoardingDashboard.REQUEST) {
			packets = m_filter.filterPacketsByRequests(dm, packetsWithFilteredProducts);
		}

		if(stageVm.type == TmBoardingDashboard.PACKET) {
			packetsWithFilteredProducts = m_filter.filterPacketsByPackets(packets, packetsWithFilteredProducts);
		}

		formVm.charts = new Map<String, TmBoardingDashboard.ChartVm>();

		formVm.allRms = build(dm.tmos);

		formVm.currentUser = new TmBoardingDashboard.UserVm();
		formVm.currentUser.id = dm.currentUser.id;
		formVm.currentUser.name = dm.currentUser.name;
		Map<string, PM_Object_Action_Log_c> logs = buildLogRequests(packets);
		formVm.packets = build(packets, stageVm, logs);
		Map<string, PM_Object_Action_Log_c> filteredlogs = buildLogRequests(packetsWithFilteredProducts);
		formVm.products = build(packetsWithFilteredProducts, stageVm, filteredlogs);
		formVm.serverUrl = m_util.getServerUrl();
		formVm.isUserTmo = dm.isUserTmo;
		formVm.stages = buildStages(dm.packetStages, dm.productStages);
		formVm.filterByStage = m_filter.buildFilteredStage(stageVm);
		formVm.filterByUser = m_filter.buildFilteredUser(dm.tmos, rmId);
		formVm.packets.sort();
		formVm.products.sort();
		formVm.allRms.sort();

		return formVm;
	}
    
    public List<TmBoardingDashboard.TmMaintenanceVm> buildTmMaintenanceVms(List<TmBoardingDashboard.TmMaintenanceDm> request) {
        List<TmBoardingDashboard.TmMaintenanceVm> vms = new List<TmBoardingDashboard.TmMaintenanceVm>();
        
        for (TmBoardingDashboard.TmMaintenanceDm dm: request) {
            TmBoardingDashboard.TmMaintenanceVm vm = new TmBoardingDashboard.TmMaintenanceVm();
            vm.status = dm.status;
			vm.esignStatus = dm.esignStatus;
            vm.type = dm.type;
            vm.contactId = dm.contactId;
            vm.contactName = dm.contactName;
            vm.entityId = dm.entityId;
            vm.entityName = dm.entityName;
            vm.tmMaintenanceId = dm.tmMaintenanceId;
            vm.tmMaintenanceName = dm.tmMaintenanceName;
            vm.submissionDate = dm.submissionDate;
			vm.createdBy = dm.createdBy;
			vm.assignedTo = dm.assignedTo;
			vm.lastStageUpdateDate = dm.lastStageUpdateDate;
            vm.userChangesCount = dm.userChangesCount;
            vm.entitlementChangesCount = dm.entitlementChangesCount;
            vms.add(vm);
        }
        
        return vms;
    }

	private Map<string, PM_Object_Action_Log_c> buildLogRequests(List<DmTmPacket> packets){
		Map<string, PM_Object_Action_Log_c> requests = new Map<string, PM_Object_Action_Log_c>();
		if(packets == null){return new Map<string, PM_Object_Action_Log_c>();}
		Set<string> requestIds = new Set<string>();
		if(m_logs == null){
			m_logs = m_repo.getStageLogsForTMRequests();
		}
		return m_logs;
	}

	private List<TmBoardingDashboard.StageVm> buildStages(List<DmTmPacketStage> packetStages, List<DmTmRequestStage> productStages) {
		List<TmBoardingDashboard.StageVm> stageVms = new List<TmBoardingDashboard.StageVm>();
		stageVms.addall(m_filter.buildFakeStages());
		if (packetStages != null) {
			for (DmTmPacketStage stage: packetStages) {
				TmBoardingDashboard.StageVm vm = new TmBoardingDashboard.StageVm();
				vm.id = stage.id;
				vm.name = stage.name;
				vm.type = TmBoardingDashboard.PACKET;
				stageVms.add(vm);
			}
		}

		if (productStages != null) {
			for (DmTmRequestStage stage: productStages) {
				TmBoardingDashboard.StageVm vm = new TmBoardingDashboard.StageVm();
				vm.id = stage.id;
				vm.name = stage.name;
				vm.type = TmBoardingDashboard.REQUEST;
				stageVms.add(vm);
			}
		}

		return stageVms;
	}

	private Map<String, TmBoardingDashboard.ChartVm> buildCharts(List<TmBoardingDashboard.ChartType> chartTypes, LIst<DmTmPacket> packets) {
		Map<String, TmBoardingDashboard.ChartVm> charts = new Map<String, TmBoardingDashboard.ChartVm>();
		if(chartTypes != null){
			for(TmBoardingDashboard.ChartType ct : chartTypes) {
				TmBoardingDashboard.IChartVmBuilder chtBuilder = find(ct);
				charts.put(chtBuilder.type(), chtBuilder.build(packets));
			}
		}
		return charts;
	}

	private List<TmBoardingDashboard.UserVm> build(List<DmUser> userDms) {
		List<TmBoardingDashboard.UserVm> vms = new List<TmBoardingDashboard.UserVm>();
		for(DmUser dm : userDms) {
				TmBoardingDashboard.UserVm vm = new TmBoardingDashboard.UserVm();
				vm.id = dm.id;
				vm.name = dm.name.unescapeHtml4();
				vm.officerCode = dm.officerCode;
				vms.add(vm);
		}
		return vms;
	}

	private List<TmBoardingDashboard.LayoutComponent> build(List<DmTmPacket> packetDms, TmBoardingDashboard.stageVm stageVm, Map<string, PM_Object_Action_Log_c> logs) {
		List<TmBoardingDashboard.LayoutComponent> layouts = new List<TmBoardingDashboard.LayoutComponent>();
		if(packetDms == null){return layouts;}
		if(stageVm.id == TmBoardingDashboard.ALLACTIVE) {
			packetDms = m_filter.removeComplete(packetDms);
		}

		for(DmTmPacket dm : packetDms) {
			TmBoardingDashboard.LayoutComponent p = buildPacket(dm);
			if(p != null)layouts.add(p);
			List<TmBoardingDashboard.LayoutComponent> rs = buildRequests(dm, logs);
			if(rs != null && rs.size() > 0){layouts.addAll(rs);}
		}

		return layouts;
	}

	private TmBoardingDashboard.LayoutComponent buildPacket(DmTmPacket dm) {
		TmBoardingDashboard.LayoutComponent l = new TmBoardingDashboard.LayoutComponent();

		l.id = dm.id;
		l.name = dm.name;
		l.entity = dm.entity.name;
		l.entityId = dm.entity.id;
		l.tmRepId = dm.entity.tmRep.id;
		l.tmRep = dm.entity.tmRep.name;
		l.stage = dm.status;
		l.lastStageChange = dm.LastStatusDate;
		l.type = TmBoardingDashboard.PACKET;
		l.rushed = dm.IsRushed;
		l.createdDate = dm.createdDate;
		l.createdBy = dm.createdBy.name;
		l.createdById = dm.createdBy.id;
		l.lastModifiedBy = dm.lastModifiedBy.name;
		l.lastModifiedById = dm.lastModifiedBy.id;
		l.product = '';
		if(dm.tmRequests != null){
			l.relationshipCount = dm.tmRequests.size();
			l.assignedTo = getAssignees(dm.tmRequests);
		}
		return l;
	}

	private  List<TmBoardingDashboard.LayoutComponent> buildRequests(DmTmPacket dm, Map<string, PM_Object_Action_Log_c> logs) {
		List<TmBoardingDashboard.LayoutComponent> layouts = new List<TmBoardingDashboard.LayoutComponent>();
		
		if(dm.tmRequests == null){return layouts;}

		for(DmTmRequest r : dm.tmRequests) {
			TmBoardingDashboard.LayoutComponent l = new TmBoardingDashboard.LayoutComponent();
			l.id = r.id;
			l.name = r.name;
			l.entity = dm.entity.name;
			l.entityId = dm.entity.id;
			l.tmRepId = dm.entity.tmRep.id;
			l.tmRep = dm.entity.tmRep.name;
			l.stage = r.stage.name;
			l.type = TmBoardingDashBoard.REQUEST;
			l.relatedToPacketId = dm.id;
			l.createdDate = r.createdDate;
			l.opsStageDate = getOppsDate(l.id,logs);
			l.createdBy = r.createdBy.name;
			l.createdById = r.createdBy.id;
			l.lastModifiedBy = dm.lastModifiedBy.name;
			l.lastModifiedById = dm.lastModifiedBy.id;
			l.relationshipCount = 0;
			l.product = r.recordType.name;
            l.notes = r.notes;
			l.assignedTo = r.assignedTo;
			layouts.add(l);
		}

		return layouts;
	}

	private TmBoardingDashboard.IChartVmBuilder find(TmBoardingDashboard.ChartType ct) {
		for(TmBoardingDashboard.IChartVmBuilder c : m_chartVmBuilders) {
			if(c.handle() == ct) {
				return c;
			}
		}
		return null;
	}

	private String getAssignees(List<DmTmRequest> assignees) {
		if(assignees.size() == 0){return '';}
		Set<String> assigneeSet = new Set<String>();
		for(DmTmRequest r : assignees){
            if(String.IsNotBlank(r.assignedTo)){
				assigneeSet.add(r.assignedTo);
            }
		}
		List<String> placeHolder = new List<String>(assigneeSet);

		return placeHolder.size() > 0? String.Join(placeHolder, ','): '';
	}

	private DateTime getOppsDate(String recordId, Map<string, PM_Object_Action_Log_c> logs){
		PM_Object_Action_Log_c logById = logs.get(recordId);
		if(logById == null){return null;}
		return logById.Action_Date_Time_c;
	}
}