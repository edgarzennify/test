public class EventRegistrationAdminDmBldrHlp implements EventRegistrationAdmin.IDmBuilderHelper {
	public Integer NumberOfAttendeesByAttendance(Eb_Event_Session__c sessionPm) {
		return Integer.valueOf(sessionPm.Number_of_Attendees_By_Attendance__c);
	}
}