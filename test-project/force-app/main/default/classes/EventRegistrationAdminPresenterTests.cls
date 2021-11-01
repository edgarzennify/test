@IsTest
private class EventRegistrationAdminPresenterTests {
	private static final EventRegistrationAdminMock.ofIVmBuilder mockVmBuilder;
	private static final EventRegistrationAdminMock.ofIRepository mockRepository;
	private static final EventRegistrationAdminPresenter sut;

	static {
		mockVmBuilder = new EventRegistrationAdminMock.ofIVmBuilder();
		mockRepository = new EventRegistrationAdminMock.ofIRepository();

		sut = new EventRegistrationAdminPresenter(mockRepository, mockVmBuilder);
	}

	@IsTest
    static void it_should_get_all_classes() {
		List<DmEventClass> dmClasses = new List<DmEventClass> ();
		EventRegistrationAdmin.Course c = new EventRegistrationAdmin.Course();
		c.Id = 'dfd';
		List<EventRegistrationAdmin.Course> vmClasses = new List<EventRegistrationAdmin.Course> { c };

		mockRepository.setup('getAllClasses').returns(dmClasses);
		mockVmBuilder.setup('build', new List<Object> { dmClasses }).returns(vmClasses);

		List<EventRegistrationAdmin.Course> results = sut.getClasses();

		mockRepository.verify('getAllClasses', Times.Once);
		mockVmBuilder.verify('build', new List<Object> { dmClasses }, Times.Once);
		System.assertEquals(results[0].Id, c.Id);
	}

	@IsTest
    static void it_should_get_a_class() {
		String classId = 'sdf';
		DmEventClass dmClass = new DmEventClass();
		List<DmEventClass> dmClasses = new List<DmEventClass> { dmClass };
		EventRegistrationAdmin.Course c = new EventRegistrationAdmin.Course();
		c.Id = 'dfd';
		List<EventRegistrationAdmin.Course> vmClasses = new List<EventRegistrationAdmin.Course> { c };

		mockRepository.setup('getClass', new List<Object> { classId }).returns(dmClass);
		mockVmBuilder.setup('build', new List<Object> { dmClasses }).returns(vmClasses);

		EventRegistrationAdmin.Course result = sut.getClass(classId);

		mockRepository.verify('getClass', new List<Object> { classId }, Times.Once);
		mockVmBuilder.verify('build', new List<Object> { dmClasses }, Times.Once);
		System.assertEquals(result.Id, c.Id);
	}

	@IsTest
    static void it_should_get_attendees_for_class() {
		String classId = 'dsf';
		List<DmEventAttendance> dmAttendances = new List<DmEventAttendance> ();
		EventRegistrationAdmin.VmAttendance vmAtt = new EventRegistrationAdmin.VmAttendance();
		vmAtt.Id = 'wew';
		List<EventRegistrationAdmin.VmAttendance> vmAttendances = new List<EventRegistrationAdmin.VmAttendance> { vmAtt };

		mockRepository.setup('getAttendeesForClass', new List<Object> { classId }).returns(dmAttendances);
		mockVmBuilder.setup('buildAttendances', new List<Object> { dmAttendances }).returns(vmAttendances);

		List<EventRegistrationAdmin.VmAttendance> results = sut.getAttendeesForClass(classId);

		mockRepository.verify('getAttendeesForClass', new List<Object> { classId }, Times.Once);
		mockVmBuilder.verify('buildAttendances', new List<Object> { dmAttendances }, Times.Once);
		System.assertEquals(results[0].Id, vmAtt.Id);
	}

	@IsTest
    static void it_should_get_an_attendee() {
		String attendeeId = 'sdf';
		DmEventAttendee dmAttendee = new DmEventAttendee();
		EventRegistrationAdmin.Attendee vmAttendee = new EventRegistrationAdmin.Attendee();
		vmAttendee.id = 'dfd';

		mockRepository.setup('getAttendee', new List<Object> { attendeeId }).returns(dmAttendee);
		mockVmBuilder.setup('buildAttendee', new List<Object> { dmAttendee }).returns(vmAttendee);

		EventRegistrationAdmin.Attendee result = sut.getAttendee(attendeeId);

		mockRepository.verify('getAttendee', new List<Object> { attendeeId }, Times.Once);
		mockVmBuilder.verify('buildAttendee', new List<Object> { dmAttendee }, Times.Once);
		System.assertEquals(result.Id, vmAttendee.Id);
	}

	@IsTest
    static void it_should_set_attendee_attendance() {
		String attendanceId = 'sdfsfd';
		Boolean present = true;
		List<DmEventAttendance> dmAttendances = new List<DmEventAttendance>();
		DmEventAttendance dmAttendance = new DmEventAttendance();
		dmAttendance.id = attendanceId;
		dmAttendance.Present = present;
		dmAttendances.add(dmAttendance);
		mockRepository.setup('setAttendeeAttendance', new List<Object> { dmAttendances });

		sut.setAttendeeAttendance(attendanceId, present);

		mockRepository.verify('setAttendeeAttendance', new List<Object> { dmAttendances }, Times.Once);
	}

	@IsTest
    static void it_should_set_class_attenance() {
		String classId = 'dfd';
		Boolean present = true;
		DmEventAttendance dmAttendance = new DmEventAttendance();
		List<DmEventAttendance> dmAttendances = new List<DmEventAttendance> {dmAttendance};
		mockRepository.setup('getAttendeesForClass', new List<Object> { classId }).returns(dmAttendances);

		sut.setClassAttendance(classId, present);

		mockRepository.verify('getAttendeesForClass', new List<Object>{classId}, Times.Once);
		mockRepository.verify('setAttendeeAttendance', new List<Object>{dmAttendances}, Times.Once);
	}

	@IsTest
    static void it_should_update_attendee_on_save() {
		EventRegistrationAdmin.Attendee attendee = new EventRegistrationAdmin.Attendee();
		DmEventAttendee dmAttendee = new DmEventAttendee();
		attendee.Id = 'dfdf';
		attendee.FirstName = 'sdf';
		attendee.LastName = 'ffd';
        attendee.JobTitle = 'sfwer';
        attendee.Company = 'sfqwerqwetwet';
		String classId = '123';
		Boolean present = false;

		sut.addAttendeeToClass(attendee, classId, present);

		mockRepository.verify('saveAttendee',ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
	}

	@IsTest
    static void it_should_insert_an_attendee_on_save() {
	EventRegistrationAdmin.Attendee attendee = new EventRegistrationAdmin.Attendee();
		DmEventAttendee dmAttendee = new DmEventAttendee();
		attendee.Id = '0';
		attendee.FirstName = 'sdf';
		attendee.LastName = 'ffd';
		String classId = '123';
		Boolean present = false;

		sut.addAttendeeToClass(attendee, classId, present);

		mockRepository.verify('saveAttendee', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
		mockRepository.verify('createAttendance', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
	}

	@IsTest
    static void it_should_get_search_results() {
		List<EventRegistrationAdmin.SearchResult> searchResults = new List<EventRegistrationAdmin.SearchResult>();
		String searchParam = 'dfdf';
		List<DmEventClass> dmSearchResults = new List<DmEventClass>();
		mockRepository.setup('search', new List<Object>{searchParam}).returns(dmSearchResults);
		mockVmBuilder.setup('buildSearch', new List<Object>{dmSearchResults}).returns(searchResults);

		sut.search(searchParam);

		mockRepository.verify('search', new List<Object>{searchParam}, Times.Once);
		mockVmBuilder.verify('buildSearch', new List<Object>{dmSearchResults}, Times.Once);
	}
}