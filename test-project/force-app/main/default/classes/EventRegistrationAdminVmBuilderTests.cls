@IsTest
private class EventRegistrationAdminVmBuilderTests {

	private static final EventRegistrationAdminVmBuilder sut;

	static {
		sut = new EventRegistrationAdminVmBuilder();
	}

	public static testmethod void it_should_build_courses()
	{
		Datetime myDateTime = Datetime.newInstance(2015, 5, 15);
		Integer numberOfAttendees = 3;
		Integer capacity = 5;
		String region = 'sdf';
		String classId = 'dfsdf';
		String className = 'fsdfewrwer';
		String instructorName = 'sdfwersdf';

		DmEventInstructor dmInstructor = new DmEventInstructor();
		dmInstructor.name = instructorName;
		List<DmEventInstructor> dmInstructors = new List<DmEventInstructor> { dmInstructor };

		DmEventSession dmSession = new DmEventSession();
		dmSession.StartDateTime = myDateTime;
		dmSession.EndDateTime = myDateTime;
		dmSession.NumberOfAttendees = numberOfAttendees;
		dmSession.Capacity = capacity;
		dmSession.Region = region;
		dmSession.Instructors = dmInstructors;

		DmEventClass dmClass = new DmEventClass();
		dmClass.Id = classId;
		dmClass.name = className;
		dmClass.sessions = new List<DmEventSession> { dmSession };
		List<DmEventClass> dmClasses = new List<DmEventClass> { dmClass };

		List<EventRegistrationAdmin.Course> results = sut.build(dmClasses);

		System.assertEquals(classId, results[0].id);
		System.assertEquals(className, results[0].ClassName);
		System.assertEquals(myDateTime, results[0].StartDate);
		System.assertEquals(myDateTime, results[0].EndDate);
		System.assertEquals(numberOfAttendees, results[0].AttendeeCount);
		System.assertEquals(capacity, results[0].TotalSeats);
		System.assertEquals(region, results[0].Region);
		System.assertEquals(instructorName, results[0].Instructors[0]);
	}

	public static testmethod void it_should_build_attendance_when_first_name_exits()
	{
		String attendanceId = '3rwedf';
		String attendeeId = '3wersdf';
		String firstName = 'sdfsdfwer';
		String lastName = 'sfwersdf';
		Boolean present = true;

		DmEventAttendee dmAttendee = new DmEventAttendee();
		dmAttendee.FirstName = firstName;
		dmAttendee.LastName = lastName;
		dmAttendee.id = attendeeId;

		DmEventAttendance dmAttendance = new DmEventAttendance();
		dmAttendance.id = attendanceId;
		dmAttendance.attendee = dmAttendee;
		dmAttendance.Present = present;

		List<DmEventAttendance> dmAttendances = new List<DmEventAttendance> { dmAttendance };

		List<EventRegistrationAdmin.VmAttendance> results = sut.buildAttendances(dmAttendances);

		System.assertEquals(attendanceId, results[0].Id);
		System.assertEquals(present, results[0].Present);
		System.assertEquals(firstName, results[0].FirstName);
		System.assertEquals(lastName, results[0].LastName);
	}

	public static testmethod void it_should_build_attendance_when_first_name_does_not_exits()
	{
		String attendanceId = '3rwedf';
		String attendeeId = '3wersdf';
		String lastName = 'sfwersdf';
		Boolean present = true;
		String firstName = 'last-name';
		String leadid = 'lead-id';
		String entityid = 'entity-id';
		String rmId = 'RM-id';

		DmEventAttendee dmAttendee = new DmEventAttendee();
		dmAttendee.LastName = lastName;
		dmAttendee.id = attendeeId;
		dmAttendee.FirstName = firstname;
		dmAttendee.Lead = new DmLead();
		dmAttendee.Lead.Id = leadid ;
		dmAttendee.Entity = new DmEntity();
		dmAttendee.Entity.Id = entityid;
		dmAttendee.PrimaryRM = new DmUser();
		dmAttendee.PrimaryRM.Id = rmId;

		DmEventAttendance dmAttendance = new DmEventAttendance();
		dmAttendance.id = attendanceId;
		dmAttendance.attendee = dmAttendee;
		dmAttendance.Present = present;

		List<DmEventAttendance> dmAttendances = new List<DmEventAttendance> { dmAttendance };

		List<EventRegistrationAdmin.VmAttendance> results = sut.buildAttendances(dmAttendances);

		System.assertEquals(attendanceId, results[0].Id);
		System.assertEquals(present, results[0].Present);
		System.assertEquals(firstName, results[0].FirstName);
		System.assertEquals(lastName, results[0].LastName);

		System.assertEquals(firstname, results[0].firstname);
		System.assertEquals(entityid, results[0].EntityId);
		System.assertEquals(leadid, results[0].LeadId);
		System.assertEquals(rmId, results[0].PrimaryRmId);
	}

	public static testmethod void it_should_build_attendee() {

		String attendeeId = '3wersdf';
		String firstName = 'sdfsdfwer';
		String lastName = 'sfwersdf';
		String email = 'sdfdsf';
        String jobTitle = 'jsjsd';
        String company = 'wetlk';

		DmEventAttendee dmAttendee = new DmEventAttendee();
		dmAttendee.FirstName = firstName;
		dmAttendee.LastName = lastName;
		dmAttendee.id = attendeeId;
		dmAttendee.Email = email;
        dmAttendee.JobTitle = jobTitle;
        dmAttendee.Company = company;

		EventRegistrationAdmin.Attendee result = sut.buildAttendee(dmAttendee);

		System.assertEquals(firstName, result.FirstName);
		System.assertEquals(lastName, result.LastName);
		System.assertEquals(email, result.Email);
		System.assertEquals(attendeeId, result.Id);
        System.assertEquals(jobTitle, result.JobTitle);
        System.assertEquals(company, result.Company);
	}

	public static testmethod void it_should_build_search_results() {
		String classId = 'sdfsdf';
		String className = 'slsdfjlkjslfwer';

		DmEventClass dmClass = new DmEventClass();
		dmClass.id = classId;
		dmClass.name = className;

		List<DmEventClass> dmClasses = new List<DmEventClass>{dmClass};

		List<EventRegistrationAdmin.SearchResult> results = sut.buildSearch(dmClasses);

		System.assertEquals(classId, results[0].Id);
		System.assertEquals(className, results[0].ClassName);
		System.assertEquals('Class', results[0].Type);
		
	}

}