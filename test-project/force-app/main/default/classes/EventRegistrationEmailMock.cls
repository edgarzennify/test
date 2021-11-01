public class EventRegistrationEmailMock {

	public class ofIDataProvider extends ApexMoq implements EventRegistrationEmail.IDataProvider {
		public List<Event_Attendance__c> getAttendancesByAttendee(Id attendeeId) {
			return (List<Event_Attendance__c>)handleMethodInvocation('getAttendancesByAttendee', new List<Object>{attendeeId});
		}
		public EmailTemplate getTemplate(Id templateId) {
			return (EmailTemplate)handleMethodInvocation('getTemplate', new List<Object>{templateId});
		}
		public List<Event_Attendance__c> getAttendancesByCreatedDate(DateTime dt, Id eventCollectionId) {
			return (List<Event_Attendance__c>)handleMethodInvocation('getAttendancesByCreatedDate', new List<Object>{dt,eventCollectionId});
		}
		public Event_Attendance__c getAttendance(Id attendanceId) {
			return (Event_Attendance__c)handleMethodInvocation('getAttendance', new List<Object>{attendanceId});
		}
	}

	public class ofIEmailHandler extends ApexMoq implements EventRegistrationEmail.IEmailHandler {
		public void handle(Id attendeeId, Id templateId) {
			handleMethodInvocation('handle', new List<Object>{attendeeId, templateId});
		}
		public List<Id> getAttendeesWithNewRegistration(Id eventCollectionId, Integer timeInMinutesWhenLastRegistered) {
			return (List<Id>)handleMethodInvocation('getAttendeesWithNewRegistration', new List<Object>{eventCollectionId, timeInMinutesWhenLastRegistered});
		}
	}
}