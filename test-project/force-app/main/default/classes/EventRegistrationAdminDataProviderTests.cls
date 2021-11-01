@IsTest
private class EventRegistrationAdminDataProviderTests {
	private final static EventRegistrationAdminDataProvider sut;
	static {
		sut = new EventRegistrationAdminDataProvider();
	}

	private static testmethod void it_should_get_all_classes() {
		Date now = Date.newInstance(2017, 5, 5);

		Event_Collection__c collection = new Event_Collection__c();
		insert collection;

		EB_Event__c myEvent = new EB_Event__c();
		myEvent.Name = 'sdfwer';
		myEvent.Event_Collection__c = collection.Id;
		insert myEvent;

		Event_Instructor__c instructor1 = new Event_Instructor__c();
		instructor1.Name = 'sdfsfd';
		insert instructor1;
		Event_Instructor__c instructor2 = new Event_Instructor__c();
		instructor2.Name = 'sfdwertwe';
		insert instructor2;

		EB_Event_Session__c myClass = new EB_Event_Session__c();
		myClass.Event_Collection__c = collection.id;
		myClass.EB_Event__c = myEvent.Id;
		myClass.Instructor_1__c = instructor1.Id;
		myClass.Instructor_2__c = instructor2.Id;
		myClass.Capacity__c = 34;
		myClass.Date_Time_of_Event__c = Datetime.newInstance(2017, 6, 5);
		myClass.End_Date_Time_of_Event__c = Datetime.newInstance(2017, 3, 3);
		myClass.Region__c = 'Phoenix';
		insert myClass;

		Event_Attendance__c attendance = new Event_Attendance__c();
		attendance.Event_Session__c = myClass.Id;
		insert attendance;

		List<EB_Event_Session__c> results = sut.allClasses(collection.Id, now);

		System.assertEquals(1, results.size());
		Object fieldObject;
		fieldObject = results[0].Capacity__c;
		fieldObject = results[0].Date_Time_of_Event__c;
		fieldObject = results[0].End_Date_Time_of_Event__c;
		fieldObject = results[0].Region__c;
		fieldObject = results[0].Instructor_1__r.Name;
		fieldObject = results[0].Instructor_2__r.Name;
		fieldObject = results[0].Event_Name__c;
		fieldObject = Integer.valueOf(results[0].Number_of_Attendees_By_Attendance__c);
	}

	private static testmethod void it_should_get_a_class() {

		EB_Event__c myEvent = new EB_Event__c();
		myEvent.Name = 'sdfwer';
		insert myEvent;

		Event_Instructor__c instructor1 = new Event_Instructor__c();
		instructor1.Name = 'sdfsfd';
		insert instructor1;
		Event_Instructor__c instructor2 = new Event_Instructor__c();
		instructor2.Name = 'sfdwertwe';
		insert instructor2;

		EB_Event_Session__c myClass = new EB_Event_Session__c();
		myClass.EB_Event__c = myEvent.Id;
		myClass.Instructor_1__c = instructor1.Id;
		myClass.Instructor_2__c = instructor2.Id;
		myClass.Capacity__c = 34;
		myClass.Date_Time_of_Event__c = Datetime.newInstance(2017, 5, 5);
		myClass.End_Date_Time_of_Event__c = Datetime.newInstance(2017, 3, 3);
		myClass.Region__c = 'Phoenix';
		insert myClass;

		Event_Attendance__c attendance = new Event_Attendance__c();
		attendance.Event_Session__c = myClass.Id;

		insert attendance;

		EB_Event_Session__c result = sut.getClass(myClass.Id);

		Object fieldObject;
		fieldObject = result.Capacity__c;
		fieldObject = result.Date_Time_of_Event__c;
		fieldObject = result.End_Date_Time_of_Event__c;
		fieldObject = result.Region__c;
		fieldObject = result.Instructor_1__r.Name;
		fieldObject = result.Instructor_2__r.Name;
		fieldObject = result.Event_Name__c;
		fieldObject = Integer.valueOf(result.Number_of_Attendees_By_Attendance__c);

	}

	public static testmethod void it_should_get_all_attendees_for_class() {
		EB_Event__c myEvent = new EB_Event__c();
		insert myEvent;

		EB_Event_Session__c mySession = new EB_Event_Session__c();
		mySession.EB_Event__c = myEvent.Id;
		insert mySession;


		EB_Event_Attendees__c attendee = new EB_Event_Attendees__c();
		attendee.EB_Event_Course__c = mySession.Id;
		insert attendee;

		Event_Attendance__c attendance = new Event_Attendance__c();
		attendance.Event_Attendee__c = attendance.Id;
		attendance.Event_Session__c = mySession.Id;
		insert attendance;

		List<Event_Attendance__c> results = sut.allAttendeesForClass(mySession.Id);

		System.assertEquals(1, results.size());

		Object fieldObject;
		fieldObject = results[0].Event_Attendee__r.Attendee_First_Name__c;
		fieldObject = results[0].Event_Attendee__r.Attendee_Last_Name__c;
		fieldObject = results[0].Event_Attendee__r.Email_Address__c;
        fieldObject = results[0].Event_Attendee__r.Job_Title__c;
        fieldObject = results[0].Event_Attendee__r.Company__c;
		fieldObject = results[0].Record_Attendance__c;
	}

	public static testmethod void it_should_get_one_attendee() {
		EB_Event_Session__c course = new EB_Event_Session__c();
		insert course;

		EB_Event_Attendees__c attendee = new EB_Event_Attendees__c();
		attendee.EB_Event_Course__c = course.Id;
		insert attendee;

		EB_Event_Attendees__c result = sut.attendee(attendee.Id);

		Object fieldObject;
		fieldObject = result.Id;
		fieldObject = result.Attendee_Last_Name__c;
		fieldObject = result.Attendee_First_Name__c;
		fieldObject = result.Email_Address__c;
        fieldObject = result.Job_Title__c;
        fieldObject = result.Company__c;
	}

	public static testmethod void it_should_get_classes_by_search() {
		Date now = Date.newInstance(2017, 5, 5);
		String searchParam = 'custom';

		Event_Collection__c collection = new Event_Collection__c();
		insert collection;

		Event_Instructor__c instructor1 = new Event_Instructor__c();
		instructor1.Name = 'sdfsfd';
		insert instructor1;
		Event_Instructor__c instructor2 = new Event_Instructor__c();
		instructor2.Name = 'sfdwertwe';
		insert instructor2;

		EB_Event_Session__c myClass = new EB_Event_Session__c();
		myClass.Event_Collection__c = collection.id;
		myClass.Instructor_1__c = instructor1.Id;
		myClass.Instructor_2__c = instructor2.Id;
		myClass.Capacity__c = 34;
		myClass.Date_Time_of_Event__c = Datetime.newInstance(2017, 6, 5);
		myClass.End_Date_Time_of_Event__c = Datetime.newInstance(2017, 3, 3);
		myClass.Region__c = 'Phoenix';
		myClass.Event_Name__c = 'custom';
		insert myClass;

		Event_Attendance__c attendance = new Event_Attendance__c();
		attendance.Event_Session__c = myClass.Id;
		insert attendance;

		List<EB_Event_Session__c> results = sut.search(collection.Id, searchParam);

		System.assertEquals(1, results.size());

		Object fieldObject;
		fieldObject = results[0].Capacity__c;
		fieldObject = results[0].Date_Time_of_Event__c;
		fieldObject = results[0].Instructor_1__r.Name;
		fieldObject = results[0].Instructor_2__r.Name;
		fieldObject = results[0].End_Date_Time_of_Event__c;
		fieldObject = results[0].Number_of_Attendees_By_Attendance__c;
		fieldObject = results[0].Region__c;
		fieldObject = results[0].Event_Name__c;
	}
}