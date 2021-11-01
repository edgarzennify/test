@IsTest
private class EventRegistrationControllerTests {
	
    private static final EventRegistrationController sut;
    
    static{
        sut = new EventRegistrationController();
    }

    /*private static testMethod void it_should_call_the_bootstrap_code_coverage() {

    	String recordJson = '{"LastName":"example","Email":"r@example.com","Location":"stl"}';
 
    	EventRegistration.FormVm result = EventRegistrationController.bootstrap(recordJson);
    	
    	System.assertEquals(null, result);
    }*/

    private static testMethod void it_should_call_the_save_code_coverage() {

    	EventRegistrationController.SaveData sd = new EventRegistrationController.SaveData();
    	sd.RequestType = 'not-save';

    	EventRegistration.FormVm result = EventRegistrationController.save(sd);

    	System.assertEquals(null, result);
    }
}