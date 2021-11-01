@IsTest
private class EventAttendeeCalculatorTests {

	private static final EventAttendeeCalculator sut;

	static{
		sut = new EventAttendeeCalculator();
	}

	private static testMethod void it_should_calculate_the_nummber_of_attendees_in_the_session() {
		EB_Event_Session__c session = new EB_Event_Session__c();
		session.Number_of_Attendee_From_Trigger__c = 1;
		EB_Event_Attendees__c attendee1 = new EB_Event_Attendees__c();
		EB_Event_Attendees__c attendee2 = new EB_Event_Attendees__c();
		List<EB_Event_Attendees__c> attendees = new List<EB_Event_Attendees__c>{attendee1, attendee2};

		Eb_Event_Session__c result = sut.updateNumberOfAttendees(session, attendees);

		System.assertEquals(2, result.Number_of_Attendee_From_Trigger__c);
	}

	private static testMethod void it_should_calculate_the_nummber_of_attendees_in_the_session_when_initial_count_is_null() {
		EB_Event_Session__c session = new EB_Event_Session__c();
		session.Number_of_Attendee_From_Trigger__c = 1;

		Eb_Event_Session__c result = sut.updateNumberOfAttendees(session, null);

		System.assertEquals(0, result.Number_of_Attendee_From_Trigger__c);
	}
}