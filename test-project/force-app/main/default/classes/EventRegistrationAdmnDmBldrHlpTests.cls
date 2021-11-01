@isTest
private class EventRegistrationAdmnDmBldrHlpTests {

	private static final EventRegistrationAdminDmBldrHlp sut;

	static {
		sut = new EventRegistrationAdminDmBldrHlp();
	}

	private static testmethod void it_should_get_number_of_attendees() {
		EB_Event_Session__c session = new EB_Event_Session__c();

		Integer result = sut.NumberOfAttendeesByAttendance(session);

		System.assertEquals(null, result); 
	}
}