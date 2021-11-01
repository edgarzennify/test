@IsTest
private class EventRegistrationAdminRepoTests {
	private static final EventRegistrationAdminMock.ofIDataProvider mockDataProvider;
	private static final EventRegistrationAdminMock.ofIDmBuilder mockDmBuilder;
	private static final Mock.ofIConfigurations mockConfig;
	private static final Mock.ofIUtility mockUtil;
	private static final String Attendee_Default_Session = 'EU Attendee Default Session';
	private static final String EVENT_COLLECTION_ID = 'EventRegistrationApp';
	private static final EventRegistrationAdminRepository sut;

	static {
		mockDataProvider = new EventRegistrationAdminMock.ofIDataProvider();
		mockConfig = new Mock.ofIConfigurations();
		mockDmBuilder = new EventRegistrationAdminMock.ofIDmBuilder();
		mockUtil = new Mock.ofIUtility();
		sut = new EventRegistrationAdminRepository(mockConfig, mockDataProvider, mockDmBuilder, mockUtil);
	}

	@IsTest
    static void it_should_get_all_classes() {
		String collectionId = 'sdfsdf';
		Date tdy = Date.today();
		List<Eb_Event_Session__c> pmClasses = new List<EB_Event_Session__c> ();
		List<DmEventClass> dmClasses = new List<DmEventClass> ();

		mockConfig.setup('get', new List<Object> { EVENT_COLLECTION_ID }).returns(collectionId);
		mockDataProvider.setup('allClasses', new List<Object> { collectionId, tdy }).returns(pmClasses);
		mockDmBuilder.setup('build', new List<Object> { pmClasses }).returns(dmClasses);

		List<DmEventClass> results = sut.getAllClasses();

		mockConfig.verify('get', new List<Object> { EVENT_COLLECTION_ID }, Times.Once);
		mockDataProvider.verify('allClasses', new List<Object> { collectionId, tdy }, Times.Once);
		mockDmBuilder.verify('build', new List<Object> { pmClasses }, Times.Once);
	}

	@IsTest
    static void it_should_get_one_class() {
		String classId = 'dfsdfsdf';
		EB_Event_Session__c pmClass = new EB_Event_Session__c();
		List<EB_Event_Session__c> pmClasses = new List<EB_Event_Session__c> { pmClass };
		DmEventClass dmClass = new DmEventClass();
		dmClass.id = classId;
		List<DmEventClass> dmClasses = new List<DmEventClass> { dmClass };

		mockDataProvider.setup('getClass', new List<Object> { classId }).returns(pmClass);
		mockDmBuilder.setup('build', new List<Object> { pmClasses }).returns(dmClasses);

		DmEventClass result = sut.getClass(classId);

		mockDmBuilder.verify('build', new List<Object> { pmClasses }, Times.Once);
		mockDataProvider.verify('getClass', new List<Object> { classId }, Times.Once);
		System.assertEquals(result.id, classId);
	}

	@IsTest
    static void it_should_get_all_attendees_for_class() {
		String classId = 'fsdf';
		List<Event_Attendance__c> pmAttendees = new List<Event_Attendance__c> ();
		List<DmEventAttendance> dmAttendances = new List<DmEventAttendance> ();
		mockDataProvider.setup('allAttendeesForClass', new List<Object> { classId }).returns(pmAttendees);
		mockDmBuilder.setup('buildAttendance', new List<Object> { pmAttendees }).returns(dmAttendances);

		sut.getAttendeesForClass(classId);

		mockDataProvider.verify('allAttendeesForClass', new List<Object> { classId }, Times.Once);
		mockDmBuilder.verify('buildAttendance', new List<Object> { pmAttendees }, Times.Once);
	}

	@IsTest
    static void it_should_get_attendee() {
		String attendeeId = 'sdfsdf';
		EB_Event_Attendees__c pmAttendee = new EB_Event_Attendees__c();
		DmEventAttendee dmAttendee = new DmEventAttendee();
		dmAttendee.Id = attendeeId;
		mockDataProvider.setup('attendee', new List<Object> { attendeeId }).returns(pmAttendee);
		mockDmBuilder.setup('buildAttendee', new List<Object> { pmAttendee }).returns(dmAttendee);

		DmEventAttendee result = sut.getAttendee(attendeeId);

		System.assertEquals(attendeeId, result.id);
	}

	@IsTest
    static void it_should_set_attendee_attendance() {
		DmEventAttendance dmAttendance = new DmEventAttendance();
		List<DmEventAttendance> dmAttendances = new List<DmEventAttendance> { dmAttendance };

		sut.setAttendeeAttendance(dmAttendances);

		mockDataProvider.verify('save', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
	}

	@IsTest
    static void it_should_save_attendee() {
		String ATTENDEE_OBJ = 'EB_Event_Attendees__c';
    	String EB_COURSE = 'EB Course';
    	RecordType recType = new RecordType();
		String attendeeId = ObjectFactory.getFakeId(EB_Event_Attendees__c.SObjectType, '3');
		String courseId = ObjectFactory.getFakeId(EB_Event_Session__c.SObjectType, '3');
		List<EB_Event_Attendees__c> pmAttendees = new List<EB_Event_Attendees__c> ();
		DmEventAttendee dmAttendee = new DmEventAttendee();
		dmAttendee.id = attendeeId;
		List<DmEventAttendee> dmAttendees = new List<DmEventAttendee> { dmAttendee };

		mockConfig.setup('get', new List<Object> { Attendee_Default_Session }).returns(courseId);
		mockUtil.setup('RecordTypeObject', new List<Object>{ATTENDEE_OBJ, EB_COURSE}).returns(recType);

		String result = sut.saveAttendee(dmAttendees);

		mockDataProvider.verify('save', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
		mockUtil.verify('RecordTypeObject', new List<Object>{ATTENDEE_OBJ, EB_COURSE}, Times.Once);
	}

	@IsTest
    static void it_should_create_attendance() {
		String attendeeId = ObjectFactory.getFakeId(EB_Event_Attendees__c.SObjectType, '3');
		String courseId = ObjectFactory.getFakeId(EB_Event_Session__c.SObjectType, '3');
		Boolean present = true;

		Eb_Event_Attendees__c pmAttendee = new EB_Event_Attendees__c(Id = attendeeId);
		Eb_Event_Session__c pmSession = new EB_Event_Session__c(Id = courseId);

		mockDataProvider.setup('attendee', new List<Object> { attendeeId }).returns(pmAttendee);
		mockDataProvider.setup('getClass', new List<Object> { courseId }).returns(pmSession);

		sut.createAttendance(attendeeId, courseId, present);

		mockDataProvider.verify('save', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
		mockDataProvider.verify('attendee', new List<Object> { attendeeId }, Times.Once);
		mockDataProvider.verify('getClass', new List<Object> { courseId }, Times.Once);
	}

	@IsTest
    static void it_should_search() {
		List<DmEventClass> dmClasses = new List<DmEventClass> ();
		List<EB_Event_Session__c> pmClasses = new List<EB_Event_Session__c>();
		String collectionId = 'sdfsdf';
		String param = 'sfdewersdfsdfs';
		mockConfig.setup('get', new List<Object> { EVENT_COLLECTION_ID }).returns(collectionId);
		mockDataProvider.setup('search', new List<Object>{collectionId, param}).returns(pmClasses);
		mockDmBuilder.setup('build', pmClasses).returns(dmClasses);

		List<DmEventClass> results = sut.search(param);

		mockDataProvider.verify('search', new List<Object> { collectionId, param }, Times.Once);
		mockConfig.verify('get', new List<Object> { EVENT_COLLECTION_ID }, Times.Once);
		mockDmBuilder.verify('build', new List<Object> { pmClasses }, Times.Once);
	}
}