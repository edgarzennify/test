global class TmBoardingDashboardController {

    @RemoteAction
    global static TmBoardingDashboard.FormVm getFormVm() {
        TmBoardingDashboard.IPresenter presenter =  TmBoardingDashboardBootstrap.getInstanceOfIPresenter();
        return presenter.buildVm();
    }

    @RemoteAction 
    global static TmBoardingDashboard.FormVm search(String param, String rmId, Stage stg) {
        TmBoardingDashboard.stageVm stageVm = new TmBoardingDashboard.stageVm();
        stageVm.id = stg.id;
        stageVm.name = stg.name;
        stageVm.type = stg.type;
        TmBoardingDashboard.IPresenter presenter = TmBoardingDashboardBootstrap.getInstanceOfIPresenter();
        return presenter.search(param, rmId, stageVm);
    }
    
    @RemoteAction 
    global static TmBoardingDashboard.AccessVm getAccess() {
        TmBoardingDashboard.IPresenter presenter = TmBoardingDashboardBootstrap.getInstanceOfIPresenter();
        
        return presenter.getAccess();
    }
    
    @RemoteAction
    global static List<TmBoardingDashboard.TmMaintenanceVm> getTmMaintenance(string search) {
        TmBoardingDashboard.IPresenter presenter = TmBoardingDashboardBootstrap.getInstanceOfIPresenter();
                
        return presenter.getTmMaintenances(search);
    }


    global class Stage {
        public String id{get;set;}
        public String name{get;set;}
        public String type{get;set;}
    }
}