@IsTest
public class EventRegistrationAdminMock {
	public class ofIPresenter extends ApexMoq implements EventRegistrationAdmin.IPresenter {
		public List<EventRegistrationAdmin.Course> getClasses() {
			return(List<EventRegistrationAdmin.Course>) handleMethodInvocation('getClasses');
		}

		public EventRegistrationAdmin.Course getClass(String classId) {
			return(EventRegistrationAdmin.Course) handleMethodInvocation('getClass', new List<Object> { classId });
		}

		public List<EventRegistrationAdmin.VmAttendance> getAttendeesForClass(String classId) {
			return(List<EventRegistrationAdmin.VmAttendance>) handleMethodInvocation('getAttendeesForClass', new List<Object> { classId });
		}

		public EventRegistrationAdmin.Attendee getAttendee(String attendeeId) {
			return(EventRegistrationAdmin.Attendee) handleMethodInvocation('getAttendee', new List<Object> { attendeeId });
		}

		public Boolean setAttendeeAttendance(String attendanceId, Boolean present) {
			return(Boolean) handleMethodInvocation('setAttendeeAttendance', new List<Object> { attendanceId, present });
		}

		public Boolean setClassAttendance(String classId, Boolean present) {
			return(Boolean) handleMethodInvocation('setClassAttendance', new List<Object> { classId, present });
		}

		public Boolean addAttendeeToClass(EventRegistrationAdmin.Attendee attendee, String classId, Boolean present) {
			return(Boolean) handleMethodInvocation('addAttendeeToClass', new List<Object> { attendee, classId, present });
		}

		public List<EventRegistrationAdmin.SearchResult> search(String param) {
			return(List<EventRegistrationAdmin.SearchResult>) handleMethodInvocation('search', new List<Object> { param });
		}
	}

	public class ofIVmBuilder extends ApexMoq implements EventRegistrationAdmin.IVmBuilder {
		public List<EventRegistrationAdmin.Course> build(List<DmEventClass> classes) {
			return(List<EventRegistrationAdmin.Course>) handleMethodInvocation('build', new List<Object> { classes });
		}

		public List<EventRegistrationAdmin.VmAttendance> buildAttendances(List<DmEventAttendance> attendances) {
			return(List<EventRegistrationAdmin.VmAttendance>) handleMethodInvocation('buildAttendances', new List<Object> { attendances });
		}

		public EventRegistrationAdmin.Attendee buildAttendee(DmEventAttendee attendeeDm) {
			return(EventRegistrationAdmin.Attendee) handleMethodInvocation('buildAttendee', new List<Object> { attendeeDm });
		}

		public List<EventRegistrationAdmin.SearchResult> buildSearch(List<DmEventClass> classes) {
			return(List<EventRegistrationAdmin.SearchResult>) handleMethodInvocation('buildSearch', new List<Object> { classes });
		}
	}

	public class ofIRepository extends ApexMoq implements EventRegistrationAdmin.IRepository {
		public List<DmEventClass> getAllClasses() {
			return(List<DmEventClass>) handleMethodInvocation('getAllClasses');
		}

		public DmEventClass getClass(String classId) {
			return(DmEventClass) handleMethodInvocation('getClass', new List<Object> { classId });
		}

		public List<DmEventAttendance> getAttendeesForClass(String classId) {
			return(List<DmEventAttendance>) handleMethodInvocation('getAttendeesForClass', new List<Object> { classId });
		}

		public DmEventAttendee getAttendee(String attendeeId) {
			return(DmEventAttendee) handleMethodInvocation('getAttendee', new List<Object> { attendeeId });
		}

		public void setAttendeeAttendance(List<DmEventAttendance> attendances) {
			handleMethodInvocation('setAttendeeAttendance', new List<Object> { attendances });
		}

		public String saveAttendee(List<DmEventAttendee> attendees) {
			return(String) handleMethodInvocation('saveAttendee', new List<Object> { attendees });
		}

		public void createAttendance(String attendeeId, String classId, Boolean present) {
			handleMethodInvocation('createAttendance', new List<Object> { attendeeId, classId, present });
		}

		public List<DmEventClass> search(String param) {
			return(List<DmEventClass>) handleMethodInvocation('search', new List<Object> { param });
		}
	}

	public class ofIDataProvider extends Mock.ofIDataProvider implements EventRegistrationAdmin.IDataProvider {
		public List<Eb_Event_Session__c> allClasses(String collectionId, Date now) {
			return(List<Eb_Event_Session__c>) handleMethodInvocation('allClasses', new List<Object> { collectionId, now });
		}
		public Eb_Event_Session__c getClass(String classId) {
			return(Eb_Event_Session__c) handleMethodInvocation('getClass', new List<Object> { classId });
		}
		public List<Event_Attendance__c> allAttendeesForClass(String classId) {
			return(List<Event_Attendance__c>) handleMethodInvocation('allAttendeesForClass', new List<Object> { classId });
		}
		public EB_Event_Attendees__c attendee(String attendeeId) {
			return(EB_Event_Attendees__c) handleMethodInvocation('attendee', new List<Object> { attendeeId });
		}
		public List<Eb_Event_Session__c> search(String collectionId, String param) {
			return(List<Eb_Event_Session__c>) handleMethodInvocation('search', new List<Object> { collectionId, param });
		}
	}

	public class ofIDmBuilder extends ApexMoq implements EventRegistrationAdmin.IDmBuilder {
		public List<DmEventClass> build(List<Eb_Event_Session__c> pms) {
			return(List<DmEventClass>) handleMethodInvocation('build', new List<Object> { pms });
		}
		public List<DmEventAttendance> buildAttendance(List<Event_Attendance__c> attendees) {
			return(List<DmEventAttendance>) handleMethodInvocation('buildAttendance', new List<Object> { attendees });
		}
		public DmEventAttendee buildAttendee(Eb_Event_Attendees__c attendeePm) {
			return(DmEventAttendee) handleMethodInvocation('buildAttendee', new List<Object> { attendeePm });
		}
	}

	public class ofIDmBuilderHelper extends ApexMoq implements EventRegistrationAdmin.IDmBuilderHelper {
		public Integer NumberOfAttendeesByAttendance(Eb_Event_Session__c sessionPm) {
			return(Integer) handleMethodInvocation('NumberOfAttendeesByAttendance', new List<Object> { sessionPm });
		}

	}
}