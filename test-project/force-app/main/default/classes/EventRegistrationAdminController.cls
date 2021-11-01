global class EventRegistrationAdminController {

	@RemoteAction
	global static List<EventRegistrationAdmin.Course> getAllClasses() {
		EventRegistrationAdmin.IPresenter presenter = EventRegistrationAdminBootstrapper.getInstanceOfIPresenter();
		return presenter.getClasses();
	}


	@RemoteAction
	global static EventRegistrationAdmin.Course getClass(String classId) {
		EventRegistrationAdmin.IPresenter presenter = EventRegistrationAdminBootstrapper.getInstanceOfIPresenter();
		return presenter.getClass(classId);
	}

	@RemoteAction
	global static List<EventRegistrationAdmin.VmAttendance> getAttendeesForClass(String classId) {
		EventRegistrationAdmin.IPresenter presenter = EventRegistrationAdminBootstrapper.getInstanceOfIPresenter();
		return presenter.getAttendeesForClass(classId);
	}		

	@RemoteAction
	global static EventRegistrationAdmin.Attendee getAttendee(String attendeeId) {
		EventRegistrationAdmin.IPresenter presenter = EventRegistrationAdminBootstrapper.getInstanceOfIPresenter();
		return presenter.getAttendee(attendeeId);
	}

	@RemoteAction
	global static Boolean setAttendeeAttendance(String attendanceId, Boolean present) {
		EventRegistrationAdmin.IPresenter presenter = EventRegistrationAdminBootstrapper.getInstanceOfIPresenter();
		return presenter.setAttendeeAttendance(attendanceId, present);		
	}

	@RemoteAction
	global static Boolean setClassAttendance(String classId, Boolean present) {
		EventRegistrationAdmin.IPresenter presenter = EventRegistrationAdminBootstrapper.getInstanceOfIPresenter();
		return presenter.setClassAttendance(classId, present);		
	}

	@RemoteAction
	global static Boolean addAttendeeToClass(EventRegistrationAdmin.Attendee attendee, String classId, Boolean present) {
		EventRegistrationAdmin.IPresenter presenter = EventRegistrationAdminBootstrapper.getInstanceOfIPresenter();		
		return presenter.addAttendeeToClass(attendee, classId, present);
	}

	@RemoteAction
	global static List<EventRegistrationAdmin.SearchResult> search(String param) {
		EventRegistrationAdmin.IPresenter presenter = EventRegistrationAdminBootstrapper.getInstanceOfIPresenter();		
		return presenter.search(param);
	}
	

}