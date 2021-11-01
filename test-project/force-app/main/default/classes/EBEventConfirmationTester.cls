public class EBEventConfirmationTester {
	private static String externalURL='http://enterprisebank.force.com/ebeventmessage?Id=';
	private static String productionURL= utility.getServerUrl() + '/apex/ebeventmessage?Id=';
	private static String sandboxURL=Utility.getServerUrl() + '/apex/ebeventmessage?Id=';
	private static String pageURL = externalURL;
	
    private static EB_Event__c testEvent;
    private static EB_Event_Session__c testSession;
    private static EB_Event_Attendees__c testAttendee;
    
    public static void testWithValues(){
    	setupTestObjects();
    	runTest();
    }
    
    public static void testWithNulls(){
    	testEvent = null;
    	testSession = null;
    	testAttendee = null;
    	runTest();
    }
    
    private static void setupTestObjects(){
    	testEvent = new EB_Event__c( Name = 'Salesforce Event Test');
    	insert testEvent;
    	
    	DateTime dtnow = System.Now();
    	dtnow = dtnow.addDays(10);
    	
    	testSession = new EB_Event_Session__c(EB_Event__c = testEvent.Id ,
														Event_Location__c = 'KC' ,
 														Capacity__c = 3,
 														Date_Time_of_Event__c = dtnow);
    	insert testSession;
    	
    	testAttendee = new EB_Event_Attendees__c(EB_Event_Course__c = testSession.Id,
    																 Attendee__c = 'Rajiv');
    	insert testAttendee;
    }
        
    private static void runTest(){    	
    	try{
			PageReference pr = testhelper(pageURL + testAttendee.Id );
			test.setCurrentPage(pr);
		    ApexPages.StandardController sc = new Apexpages.Standardcontroller(testAttendee);
		    EBEventConfirmation testcontroller = new EBEventConfirmation(sc);
		    testcontroller.recId = testAttendee.Id;
		    testcontroller.initialize();	    	
	    	testcontroller.getName();
	    	testcontroller.getTime();
    	}catch(Exception ex){
    		
    	}    	
    }
    
    public static PageReference testhelper(String url){
		PageReference newPage = new PageReference(url);
		newPage.setRedirect(true);
		return newPage;
	}
}