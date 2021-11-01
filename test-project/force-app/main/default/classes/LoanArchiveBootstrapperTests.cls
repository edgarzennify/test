@isTest
private class LoanArchiveBootstrapperTests {

    private static testMethod void it_should_get_a_valid_instance_of_IPresenter(){
        
        LoanArchive.IPresenter result = LoanArchiveBootstrapper.getInstanceOfIPresenter();
        
        System.assert(result != null);
    }
}