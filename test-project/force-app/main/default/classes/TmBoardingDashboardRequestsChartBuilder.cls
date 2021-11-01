public class TmBoardingDashboardRequestsChartBuilder implements TmBoardingDashboard.IChartVmBuilder {
		public String type() {
			return 'requests';
		}
		public TmBoardingDashboard.ChartType handle(){
			return TmBoardingDashboard.ChartType.Requests;
		}
		public TmBoardingDashboard.ChartVm build(List<DmTmPacket> packetDms) {
			TmBoardingDashboard.ChartVm vm = new TmBoardingDashboard.ChartVm();
			vm.labels = new List<String>();
			vm.dataSet = new List<Integer>();

			Map<String, Integer> requestMap = new Map<String, Integer>();

			for(DmTmPacket p : packetDms) {
				if(p.tmRequests != null) {
					for(DmTmRequest r : p.tmRequests) {
						if(!requestMap.containsKey(r.stage.name)) {
							requestMap.put(r.stage.name, 0);
						}
						Integer newCount = requestMap.get(r.stage.name) + 1;
						requestMap.put(r.stage.name, newCount);
					}
				}
			}

			for(String key : requestMap.keyset()) {
				vm.labels.add(key);
				vm.dataSet.add(requestMap.get(key));
			}

			return vm;
		}
}