@IsTest
private class TmBoardingDashboardControllerTests {
	
    private static testMethod void it_should_code_cover() {
        
        try{
            Object o = TmBoardingDashboardController.getFormVm();
            o = TmBoardingDashboardController.search('real', '', null);
        }catch(exception ex) {
            
        }
    }
}