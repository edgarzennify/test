@IsTest
private class EventRegistrationDmBuilderTests {
	
	private static final Mock.ofIUtility mockUtility;
	private static final EventRegistrationDmBuilder sut;

    static {
    	mockUtility = new Mock.ofIUtility();
        sut = new EventRegistrationDmBuilder(mockUtility);
    }

    private static testMethod void it_should_build_a_dm_attendance_when_pm_is_provided() {
    	
    	Eb_Event_Attendees__c ate = new Eb_Event_Attendees__c();
    	ate.Id = ObjectFactory.getFakeId(Eb_Event_Attendees__c.SObjectType, '0');
    	ate.Email_Address__c = 'email';
    	ate.Attendee_Last_Name__c = 'last-name';
    	Eb_Event_Session__c session = new Eb_Event_Session__c();
    	session.id = ObjectFactory.getFakeId(Eb_Event_Session__c.SObjectType, '0');
    	session.Description__c = 'test-description';
    	Event_Attendance__c attendance = new Event_Attendance__c();
    	attendance.Event_Attendee__c = ate.Id;
    	attendance.Event_Attendee__r = ate;
    	attendance.Event_Session__c = session.Id;
    	attendance.Event_Session__r = session;
    	List<Event_Attendance__c>  attendances = new List<Event_Attendance__c>{attendance};
        RecordType recType = new RecordType();
        mockUtility.setup('RecordTypeObject', new List<Object>{'EB_Event_Attendees__c', 'EB Course'}).returns(recType);
    	
    	DmEventAttendance result = sut.buildAttendance(attendances);
    
    	System.assertEquals('email' , result.attendee.email);
    	System.assertEquals('last-name' , result.attendee.lastName);
    	System.assertEquals(1, result.classes.size());
    	System.assertEquals('test-description', result.classes[0].sessions[0].description);
    }

    private static testMethod void it_should_call_the_util_to_get_recordtype_when_dm_attendance_is_empty() {

    	RecordType record = new RecordType();
    	record.name = 'EB Course';
    	record.SobjectType = 'EB_Event_Attendees__c';
    	mockUtility.setup('RecordTypeObject', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(record);

    	DmEventAttendance result = sut.buildAttendance(null);
    
    	System.assertEquals(record.name , result.attendee.recordtype.name);
    	System.assertEquals(record.id , result.attendee.recordtype.id);  	
    }

    private static testMethod void it_should_build_dm_classes_from_pm_sessions() {
    	
    	Eb_Event_Session__c pm = new Eb_Event_Session__c();
    	pm.description__c = 'test-description';
    	pm.Instructor_1__r = new Event_Instructor__c();
    	pm.Instructor_1__r.Name = 'instructor-1';
    	pm.Instructor_2__r = new Event_Instructor__c();
    	pm.Instructor_2__r.Name = 'instructor-2';
        pm.Instructor_3__r = new Event_Instructor__c();
    	pm.Instructor_3__r.Name = 'instructor-3';
        pm.Survey_Link__c = 'www.google.com';
        pm.Time_Zone__c = 'CDT';
        pm.Webinar_Link__c = 'www.bing.com';
        pm.Webinar_Password__c = 'test2020';
    	List<Eb_Event_Session__c> pms = new List<Eb_Event_Session__c>{pm};

    	List<DmEventClass> result =  sut.buildClasses(pms);

    	System.assertEquals(1, result.size());
    	System.assertEquals(1, result[0].sessions.size());
    	System.assertEquals('test-description', result[0].sessions[0].description);
    	System.assertEquals('instructor-1', result[0].sessions[0].instructors[0].name);
    	System.assertEquals('instructor-2', result[0].sessions[0].instructors[1].name);
        System.assertEquals('instructor-3', result[0].sessions[0].instructors[2].name);
        System.assertEquals('www.google.com', result[0].sessions[0].SurveyLink);
        System.assertEquals('CDT', result[0].sessions[0].TimeZone);
        System.assertEquals('www.bing.com', result[0].sessions[0].WebinarLink);
        System.assertEquals('test2020', result[0].sessions[0].WebinarPassword);
    }

    private static testMethod void it_should_build_a_new_attendance() {
    	
    	EB_Event_Attendees__c att = new EB_Event_Attendees__c();
    	att.Id = ObjectFactory.getFakeId(EB_Event_Attendees__c.SObjectType, '0');
    	List<EB_Event_Attendees__c> attendee = new List<Eb_Event_Attendees__c>{att};
    	String lastName = 'last-name';
    	String email = 'email';
    	RecordType rec = Utility.RecordTypeObject('EB_Event_Attendees__c', 'EB Course'); 	
    	mockUtility.setup('RecordTypeObject', new List<Object>{'EB_Event_Attendees__c', 'EB Course'}).Returns(rec);

    	DmEventAttendance result = sut.getNewAttendance(attendee, lastName, email);
    	
    	System.assertEquals(att.Id , result.attendee.id);
    	System.assertEquals(lastName , result.attendee.lastName);
    	System.assertEquals(email , result.attendee.email);
    	System.assertEquals(0, result.classes.size());
    }

    private static testMethod void it_should_build_an_instructor_when_a_pm_instructor_is_passed() {
    	
    	Event_Instructor__c pm = new Event_Instructor__c();
    	pm.Id = ObjectFactory.getFakeId(Event_Instructor__c.SObjecttype, '0');
    	pm.Name = 'test-instructor';

    	DmEventInstructor result = sut.buildInstructor(pm);

    	System.assertEquals(result.id, pm.Id);
    	System.assertEquals(result.name, result.Name);
    }
}