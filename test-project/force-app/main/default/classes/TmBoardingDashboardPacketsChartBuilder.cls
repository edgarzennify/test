public class TmBoardingDashboardPacketsChartBuilder implements TmBoardingDashboard.IChartVmBuilder {
		public String type() {
			return 'packets';
		}

		public TmBoardingDashboard.ChartType handle(){
			return TmBoardingDashboard.ChartType.Packets;
		}

		public TmBoardingDashboard.ChartVm build(List<DmTmPacket> packetDms) {

			TmBoardingDashboard.ChartVm vm = new TmBoardingDashboard.ChartVm();
			vm.labels = new List<String>();
			vm.dataSet = new List<Integer>();
			Map<String, Integer> packetMap = new Map<String, Integer>();

			for(DmTmPacket p : packetDms) {
				if(!packetMap.containsKey(p.status)) {
					packetMap.put(p.status, 0);
				}
				Integer newCount = packetMap.get(p.status) + 1;
				packetMap.put(p.status, newCount);
			}

			for(String key : packetMap.keyset()) {
				vm.labels.add(key);
				vm.dataSet.add(packetMap.get(key));
			}

			return vm;
		}
}