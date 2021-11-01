global class EventRegistrationAdmin {
    public interface IPresenter {
        List<Course> getClasses();
        Course getClass(String classId);
		List<VmAttendance> getAttendeesForClass(String classId);
		Attendee getAttendee(String attendeeId);
		Boolean setAttendeeAttendance(String attendanceId, Boolean present);
		Boolean setClassAttendance(String classId, Boolean present);
		Boolean addAttendeeToClass(Attendee attendee, String classId, Boolean present);
		List<SearchResult> search(String param);
	}

	public interface IDataProvider extends DataProvider.IDataProvider {
		List<Eb_Event_Session__c> allClasses(String collectionId, Date now);
		Eb_Event_Session__c getClass(String classId);
		List<Event_Attendance__c> allAttendeesForClass(String classId);
		EB_Event_Attendees__c attendee(String attendeeId);
		List<Eb_Event_Session__c> search(String collectionId, String param);
	}

	public interface IRepository {
		List<DmEventClass> getAllClasses(); 
		DmEventClass getClass(String classId);
		List<DmEventAttendance> getAttendeesForClass(String classId);
     	DmEventAttendee getAttendee(String attendeeId);
		void setAttendeeAttendance(List<DmEventAttendance> attendances);
		String saveAttendee(List<DmEventAttendee> attendees);
		void createAttendance(String attendeeId, String classId, Boolean present);
		List<DmEventClass> search(String param);
	}

	public interface IDmBuilder {
		List<DmEventClass> build(List<Eb_Event_Session__c> pms);
		List<DmEventAttendance> buildAttendance(List<Event_Attendance__c> attendees);
		DmEventAttendee buildAttendee(Eb_Event_Attendees__c attendeePm);
	}

	public interface IDmBuilderHelper {
		Integer NumberOfAttendeesByAttendance(Eb_Event_Session__c sessionPm);
	}

	public interface IVmBuilder {
		List<Course> build(List<DmEventClass> classes);
		List<VmAttendance> buildAttendances(List<DmEventAttendance> attendances);
		EventRegistrationAdmin.Attendee buildAttendee(DmEventAttendee attendeeDm);
		List<SearchResult> buildSearch(List<DmEventClass> classes);
	}

	global class Attendance {
		public String Id {get;set;}
		public String ClassId {get;set;}
		public String AttendeeId {get;set;}
		public Boolean Present {get;set;}
	}

	global class VmAttendance {
		public String Id {get;set;}		
		public String AttendeeId {get;set;}
		public String Email {get;set;}		
		public String FirstName {get;set;}		
		public String LastName {get;set;}
		public String EntityId{get;set;}
		public String Entity{get;set;}
		public String LeadId{get;set;}
		public String Lead{get;set;}
		public String PrimaryRM{get;set;}
		public String PrimaryRMId{get;set;}
		public String RelatedTo{get;set;}
		public String RelatedToId{get;set;}		
		public Boolean Present {get;set;}		
	}

	global class Attendee {
		public String Id {get;set;}
		public String FirstName {get;set;}
		public String LastName {get;set;}
		public String Email {get;set;}
		public String EntityId{get;set;}
		public String Entity{get;set;}
		public String LeadId{get;set;}
		public String Lead{get;set;}
		public String PrimaryRM{get;set;}
		public String PrimaryRMId{get;set;}
		public String RelatedTo{get;set;}
		public String RelatedToId{get;set;}
        public String JobTitle {get;set;}
        public String Company {get;set;}
	}

	global class Course {
		public String Id {get;set;}
		public String ClassName {get;set;}
		public Datetime StartDate {get;set;}
		public Datetime EndDate {get;set;}
		public String Region {get;set;}
		public Integer AttendeeCount {get;set;}
		public Integer TotalSeats {get;set;}
		public List<String> Instructors {get;set;}
		public List<ClassDocument> ClassDocuments {get;set;}
	}

	global class ClassDocument {
		public String Id {get;set;}
		public String Name {get;set;}
		public String Link {get;set;}
	}

	global class SearchResult {
		public String Id {get;set;}
		public String ClassName {get;set;}
		public String Type {get;set;}
	}

}