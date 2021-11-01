global class EventRegistrationEmail {
	public interface IEmailHandler {
		void handle(Id attendeeId, Id templateId);
		List<Id> getAttendeesWithNewRegistration(Id eventCollectionId, Integer timeInMinutesWhenLastRegistered);
	}
	public interface IDataProvider {
		List<Event_Attendance__c> getAttendancesByAttendee(Id attendeeId);
		EmailTemplate getTemplate(Id templateId);
		List<Event_Attendance__c> getAttendancesByCreatedDate(DateTime dt, Id eventCollectionId);
		Event_Attendance__c getAttendance(Id attendanceId);
	}


	global class FormVm {
		public String EmailClient {get;set;}
		public EmailDetails Details{get;set;}
	}

	global class EmailDetails {
		public String Location {get;set;}
		public String Name {get;set;}
		public String StartTime {get;set;}
		public String EndTime{get;set;}
		public String WebinarLink {get;set;}
        public String WebinarPassword {get;set;}
	}

	public class BootstrapException extends Exception {}
}