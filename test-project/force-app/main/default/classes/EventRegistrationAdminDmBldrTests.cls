@IsTest
private class EventRegistrationAdminDmBldrTests {

	private static final EventRegistrationAdminDmBuilder sut;
	private static final EventRegistrationAdminMock.ofIDmBuilderHelper mockDmHelper;

	static {
		mockDmHelper = new EventRegistrationAdminMock.ofIDmBuilderHelper();
		sut = new EventRegistrationAdminDmBuilder(mockDmHelper);
	}

	@IsTest
    static void it_should_build_classes() {
		String eventName = 'wetw';

		Id sessionId = ObjectFactory.getFakeId(EB_Event_Session__c.SObjectType, '3');
		Id sessionId2 = ObjectFactory.getFakeId(EB_Event_Session__c.SObjectType, 'r');
		Integer capacity = 34;
		Integer numOfAttendees = 1;
		Datetime sessionDateTime = Datetime.newInstance(2015, 6, 6);
		String region = 'wer23';

		String instructorName1 = 'sdfsdf-1';
		Id instructorId1 = ObjectFactory.getFakeId(Event_Instructor__c.SObjectType, '1');
		String instructorName2 = 'sdfsdf-2';
		Id instructorId2 = ObjectFactory.getFakeId(Event_Instructor__c.SObjectType, '2');
		String instructorName3 = 'sdfsdf-2';
		Id instructorId3 = ObjectFactory.getFakeId(Event_Instructor__c.SObjectType, '3');

		Event_Instructor__c instructor1 = new Event_Instructor__c();
		instructor1.Name = instructorName1;
		instructor1.Id = instructorId1;
		Event_Instructor__c instructor2 = new Event_Instructor__c();
		instructor2.Name = instructorName2;
		instructor2.Id = instructorId2;
		Event_Instructor__c instructor3 = new Event_Instructor__c();
		instructor3.Name = instructorName3;
		instructor3.Id = instructorId3;

		EB_Event_Session__c pmSession = new EB_Event_Session__c();
		pmSession.Id = sessionId;
		pmSession.Capacity__c = capacity;
		pmSession.Date_Time_of_Event__c = sessionDateTime;
		pmSession.End_Date_Time_of_Event__c = sessionDateTime;
		pmSession.Region__c = region;
		pmSession.Instructor_1__c = instructorId1;
		pmSession.Instructor_2__c = instructorId2;
		pmSession.Instructor_3__c = instructorId3;
		pmSession.Instructor_1__r = instructor1;
		pmSession.Instructor_2__r = instructor2;
		pmSession.Instructor_3__r = instructor3;
		pmSession.Event_Name__c = eventName;

		EB_Event_Session__c pmSession2 = new EB_Event_Session__c();
		pmSession2.Id = sessionId2;
		pmSession2.Capacity__c = capacity;
		pmSession2.Date_Time_of_Event__c = sessionDateTime;
		pmSession2.End_Date_Time_of_Event__c = sessionDateTime;
		pmSession2.Region__c = region;
		pmSession2.Instructor_1__c = instructorId1;
		pmSession2.Instructor_2__c = instructorId2;
		pmSession2.Instructor_3__c = instructorId3;
		pmSession2.Instructor_1__r = instructor1;
		pmSession2.Instructor_2__r = instructor2;
		pmSession2.Instructor_3__r = instructor3;
		pmSession.Event_Name__c = eventName;

		mockDmHelper.setup('NumberOfAttendeesByAttendance', new List<Object> { pmSession }).returns(numOfAttendees);
		mockDmHelper.setup('NumberOfAttendeesByAttendance', new List<Object> { pmSession2 }).returns(numOfAttendees);
		List<EB_Event_Session__c> pmSessions = new List<EB_Event_Session__c> { pmSession, pmSession2 };

		List<DmEventClass> result = sut.build(pmSessions);

		mockDmHelper.verify('NumberOfAttendeesByAttendance', new List<Object> { pmSession }, Times.Once);
		mockDmHelper.verify('NumberOfAttendeesByAttendance', new List<Object> { pmSession2 }, Times.Once);
		System.assertEquals(2, result.size());
		System.assertEquals(eventName, result[0].name);
		System.assertEquals(sessionId, result[0].sessions[0].Id);
		System.assertEquals(1, result[0].sessions.size()); 
		System.assertEquals(capacity, result[0].sessions[0].Capacity);
		System.assertEquals(numOfAttendees, result[0].sessions[0].NumberOfAttendees);
		
		System.assertEquals(3, result[0].sessions[0].Instructors.size());
		System.assertEquals(instructorName1, result[0].sessions[0].Instructors[0].name);
		System.assertEquals(instructorName2, result[0].sessions[0].Instructors[1].name);
		System.assertEquals(instructorName3, result[0].sessions[0].Instructors[2].name);
	}

	@IsTest
    static void it_should_build_attendance() {
		Boolean present = true;
		Id attendeeId = ObjectFactory.getFakeId(EB_Event_Attendees__c.SObjectType, '3');
		Id attendanceId = ObjectFactory.getFakeId(Event_Attendance__c.SObjectType, '4');
		String firstName = 'sdkflsdfj';
		String lastName = 'sdfsfwqer';
		String email = 'sdfwerwersdf';

		EB_Event_Attendees__c pmAttendee = new EB_Event_Attendees__c();
		pmAttendee.Attendee_First_Name__c = firstName;
		pmAttendee.Attendee_Last_Name__c = lastName;
		pmAttendee.Email_Address__c = email;
		pmAttendee.Id = attendeeId;

		Event_Attendance__c pmAttendance = new Event_Attendance__c();
		pmAttendance.Id = attendanceId;
		pmAttendance.Record_Attendance__c = present;
		pmAttendance.Event_Attendee__r = pmAttendee;

		List<Event_Attendance__c> pmAttendances = new List<Event_Attendance__c> { pmAttendance };

		List<DmEventAttendance> results = sut.buildAttendance(pmAttendances);

		System.assertEquals(1, results.size());
		System.assertEquals(results[0].id, attendanceId);
		System.assertEquals(results[0].attendee.Id, attendeeId);
	}

	@IsTest
    static void it_should_create_attendance() {
		Boolean present = true;
		Id attendeeId = ObjectFactory.getFakeId(EB_Event_Attendees__c.SObjectType, '3');
		String firstName = 'sdkflsdfj';
		String lastName = 'sdfsfwqer';
		String email = 'sdfwerwersdf';

		EB_Event_Attendees__c pmAttendee = new EB_Event_Attendees__c();
		pmAttendee.Attendee_First_Name__c = firstName;
		pmAttendee.Attendee_Last_Name__c = lastName;
		pmAttendee.Email_Address__c = email;
		pmAttendee.Id = attendeeId;

		Event_Attendance__c pmAttendance = new Event_Attendance__c();
		pmAttendance.Record_Attendance__c = present;
		pmAttendance.Event_Attendee__r = pmAttendee;

		DmEventAttendance result = sut.createAttendance(pmAttendance);

		System.assertEquals(attendeeId, result.attendee.Id);
		System.assertEquals(present, result.Present);
		System.assertEquals(firstName, result.attendee.FirstName);
	}

	@IsTest
    static void it_should_build_attendee() {
		Id attendeeId = ObjectFactory.getFakeId(EB_Event_Attendees__c.SObjectType, '3');
		String firstName = 'sdkflsdfj';
		String lastName = 'sdfsfwqer';
		String email = 'sdfwerwersdf';

		EB_Event_Attendees__c pmAttendee = new EB_Event_Attendees__c();
		pmAttendee.Attendee_First_Name__c = firstName;
		pmAttendee.Attendee_Last_Name__c = lastName;
		pmAttendee.Email_Address__c = email;
		pmAttendee.Id = attendeeId;

		DmEventAttendee result = sut.buildAttendee(pmAttendee);

		System.assertEquals(attendeeId, result.Id);
		System.assertEquals(firstName, result.FirstName);
		System.assertEquals(lastName, result.LastName);
	}
}