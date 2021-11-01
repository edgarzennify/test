@IsTest
private class EventRegistrationEmailControllerTests {

	private static testMethod void it_should_call_the_bootstrap() {

		Id attendanceId = ObjectFactory.getFakeId(Event_Attendance__c.SObjectType, '0');
		String recordJson = '{"AttendanceId":"' + attendanceId +'", "EmailClient":"test"}';

		try{
            EventRegistrationEmailController.bootstrap(recordJson);

        }catch(exception ex){
            
        } 

	} 
}