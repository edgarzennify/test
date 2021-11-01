@IsTest
private class EventAttendeeTriggerHandlerTests {

	private static final EventAttendeeTriggerHandler sut;
	private static final EventRegistrationMock.ofIDataProvider mockDataProvider;
	private static final MockICalculator mockCalculator;

	static {
		mockDataProvider = new EventRegistrationMock.ofIDataProvider();
		mockCalculator = new MockICalculator();
		sut = new EventAttendeeTriggerHandler(mockDataProvider, mockCalculator);
	}

	@IsTest
    static void it_should_call_the_dataprovider_to_get_session_pms_for_attendee_pms() {
		List<Eb_Event_Attendees__c> attendees = new List<Eb_Event_Attendees__c>();

		sut.bulkAfterInsert(attendees);

		mockDataProvider.verify('getSessionsFromEbtEmployeeAttendees', new List<Object>{attendees}, Times.Once);
	}

	@IsTest
    static void it_should_call_the_dataprovider_to_update_session_pms() {
		Id session1Id = ObjectFactory.getFakeId(Eb_Event_Session__c.SObjectType, '1');
		List<Eb_Event_Attendees__c> attendees = new List<Eb_Event_Attendees__c>();
		Eb_Event_Session__c session1 = new Eb_Event_Session__c();
		Map<Id, Eb_Event_Session__c> sessionMap = new Map<Id, Eb_Event_Session__c>{session1Id => session1};
		mockDataProvider.setup('getSessionsFromEbtEmployeeAttendees', new List<Object>{attendees}).returns(sessionMap);

		sut.bulkAfterInsert(attendees);

		mockDataProvider.verify('save', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
	}

	@IsTest
    static void it_should_call_the_calculator_to_update_number_of_attendees() {
		Id session1Id = ObjectFactory.getFakeId(Eb_Event_Session__c.SObjectType, '1');
		Eb_Event_Attendees__c attendee = new Eb_Event_Attendees__c(EB_Event_Course__c = session1Id);
		List<Eb_Event_Attendees__c> attendees = new List<Eb_Event_Attendees__c>{attendee};
		Eb_Event_Session__c session1 = new Eb_Event_Session__c();
		Map<Id, Eb_Event_Session__c> sessionMap = new Map<Id, Eb_Event_Session__c>{session1Id => session1};
		mockDataProvider.setup('getSessionsFromEbtEmployeeAttendees', new List<Object>{attendees}).returns(sessionMap);

		sut.bulkAfterInsert(attendees);

		mockCalculator.verify('updateNumberOfAttendees', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
	}

	public class MockICalculator extends ApexMoq implements EventAttendeeCalculator.ICalculator {
		public Eb_Event_Session__c updateNumberOfAttendees(Eb_Event_Session__c session, List<Eb_Event_Attendees__c> attendees){
			return (Eb_Event_Session__c)handleMethodInvocation('updateNumberOfAttendees', new List<Object>{session, attendees});
		}
	}
}