@IsTest
private class EventRegistrationEmailHandlerTests {

	private static final EventRegistrationEmailMock.ofIDataProvider mockOfIDataProvider;
	private static final Mock.ofISystem mockOfISystem;
	private static final Mock.ofIConfigurations mockOfConfigs;
	private static EventRegistrationEmailHandler sut;

	static {
		mockOfIDataProvider = new EventRegistrationEmailMock.ofIDataProvider();
		mockOfISystem = new Mock.ofISystem();
		mockOfConfigs = new Mock.ofIConfigurations();
		sut = new EventRegistrationEmailHandler(mockOfIDataProvider , mockOfISystem, mockOfConfigs);
	}
	
	@IsTest
    static void it_should_call_the_data_provider_to_handle_emails() {
		Id templateId = ObjectFactory.getFakeId(EmailTemplate.SObjectType, '0');
		String configValue = 'test-config-value';
		DateTime dt = DateTime.now();
		dt = dt.addDays(-2);
		Event_Collection__c coll = new Event_Collection__c();
		insert coll;
		Eb_Event__c event = new Eb_Event__c();
		event.Event_Collection__c = coll.Id;
		insert event;
		string lastName = 'last-name';
    	string email = 'email';
    	EB_Event_Session__c session = new EB_Event_Session__c();
    	session.EB_Event__r = event;
    	session.EB_Event__r.Event_Collection__r = coll;
    	session.EB_Event__r.Event_Collection__r.Id = coll.Id;
    	session.Date_Time_of_Event__c = dt;
    	session.End_Date_Time_of_Event__c = dt;
    	insert session;
    	Eb_Event_Attendees__c attendee = new Eb_Event_Attendees__c();
    	attendee.Attendee__c = 'first-name' + lastName;
    	attendee.Attendee_Last_Name__c = lastName;
    	attendee.Attendee_First_Name__c = 'first-name';
    	attendee.Email_Address__c = email;
    	attendee.EB_Event_Course__c = session.id;
    	insert attendee;
    	Event_Attendance__c attn = new Event_Attendance__c();
    	attn.Event_Attendee__r = attendee;
    	attn.Event_Attendee__c = attendee.Id;
    	attn.Event_Session__c = session.Id;
    	attn.Event_Session__r = session;
    	insert attn;

		List<Event_Attendance__c> attendances = new List<Event_Attendance__c>{attn};
		EmailTemplate template = new EmailTemplate();
		template.Id = templateId;
		template.HTMLValue = '<html></html>';
		mockOfIDataProvider.setup('get', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(configValue);
		mockOfIDataProvider.setup('getAttendancesByAttendee', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(attendances);
		mockOfIDataProvider.setup('getTemplate', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(template);
		
		sut.handle(attendee.Id, templateId);

		mockOfIDataProvider.verify('getAttendancesByAttendee', new List<Object>{attendee.Id}, Times.Once);
	}
}