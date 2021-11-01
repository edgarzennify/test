public class TmBoardingDashboardVmFilter implements TmBoardingDashboard.IVmFilter {

	public List<DmTmPacket> filterByPacketAndStage(List<DmTmPacket> packetDms , TmBoardingDashboard.StageVm vm) {
		if(vm.type != TmBoardingDashboard.PACKET){return packetDms;}

		List<DmTmPacket> filtered = new List<DmTmPacket>();
		for(DmTmPacket p : packetDms) {
			if(String.isNotBlank(p.status) && p.status.toLowerCase() == vm.id) {
				filtered.add(p);
			}
		}
		
		return filtered;
	}

	public List<DmTmPacket> filterByRequestAndStage(List<DmTmPacket> packetDms , TmBoardingDashboard.StageVm vm) {
		if(vm.type != TmBoardingDashboard.REQUEST){return packetDms;}

		List<DmTmPacket> filtered = new List<DmTmPacket>();
		for(DmTmPacket p : packetDms) {
			if(p.tmRequests != null){
				DmTmPacket newPacket = p;
				List<DmTmRequest> filteredRequests = new List<DmTmRequest>();
				for(DmTmRequest r : p.tmRequests) {
					if(String.isNotBlank(r.stage.id) && r.stage.id == vm.id) {
						filteredRequests.add(r);
					}
				}
				if(filteredRequests.size() > 0) {
					p.tmRequests = filteredRequests;
					filtered.add(newPacket);
				}
			}			
		}

		return filtered;
	}

	public List<DmTmPacket> filterPacketsByRequests(TmBoardingDashboard.SearchDm dm, List<DmTmPacket> packetsWithFilteredProducts) {	
		Set<String> packetIds = new Set<String>();
		List<DmTmPacket> newPackets = new List<DmTmPacket>();
		for(DmTmPacket p : packetsWithFilteredProducts ){
			packetIds.add(p.id);
		}
		for(DmTmPacket  p :  dm.packets) {
			if(packetIds.contains(p.id)){
				newPackets.add(p);
			}
		}
		return newPackets;
	}

	public List<DmTmPacket> filterPacketsByPackets(List<DmTmPacket> packets, List<DmTmPacket> packetsWithFilteredProducts) {		
			Set<String> packetIds = new Set<String>();
			List<DmTmPacket> newFilteredPackets = new List<DmTmPacket>();
			for(DmTmPacket p : packets ){
				packetIds.add(p.id);
			}
			for(DmTmPacket  p :  packetsWithFilteredProducts) {
				if(packetIds.contains(p.id)){
					newFilteredPackets.add(p);
				}
			}
			return newFilteredPackets;
	}

	public TmBoardingDashBoard.UserVm buildFilteredUser(List<DmUser> userDms, String tmId) {
		TmBoardingDashboard.UserVm vm = new TmBoardingDashboard.UserVm();
		vm.id = '';
		vm.name = '';
		vm.officerCode = '';

		for(DmUser dm : userDms) {
			if (dm.id == tmId) {
				vm.id = dm.id;
				vm.name = dm.name.unescapeHtml4();
				vm.officerCode = dm.officerCode;
				return vm;
			}	
		}

		return vm;
	}

	public TmBoardingDashBoard.StageVm buildFilteredStage(TmBoardingDashBoard.StageVm stageVm) {
		if (stageVm.id == null) {
			stageVm.id ='';
			stageVm.name = '';
			stageVm.type ='';
		}
		return stageVm;
	}

	public List<TmBoardingDashBoard.StageVm> buildFakeStages() {
		TmBoardingDashBoard.StageVm allStage = new TmBoardingDashBoard.StageVm();
		allStage.id=TmBoardingDashboard.ALL;
		allStage.name = TmBoardingDashboard.ALL;
		allStage.type = TmBoardingDashboard.ALL;

		TmBoardingDashBoard.StageVm allActiveStage = new TmBoardingDashBoard.StageVm();
		allActiveStage.id=TmBoardingDashboard.ALLACTIVE;
		allActiveStage.name = TmBoardingDashboard.ALL_ACTIVE;
		allActiveStage.type = TmBoardingDashboard.ALL;

		return new List<TmBoardingDashBoard.StageVm>{allStage, allActiveStage};
	}

	public List<DmTmPacket> removeComplete(List<DmTmPacket> packets) {
		List<DmTmPacket> filtered = new List<DmTmPacket>();

		for(DmTmPacket p : packets) {
			DmTmPacket currP = p;
			List<DmTmRequest> requests = new List<DmTmRequest>();
			if(p.status != TmBoardingDashboard.COMPLETE) {
				for(DmTmRequest r : p.tmRequests) {
					if(r.stage.name != TmBoardingDashboard.COMPLETE) {
						requests.add(r);
					}
				}
				if(requests.size() > 0) {
					p.tmRequests = requests;
					filtered.add(p);
				}
			}

		}

		return filtered;
	} 
}