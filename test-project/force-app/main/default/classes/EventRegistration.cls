global class EventRegistration {

	public interface IPresenter {
        String getValidLogin(String lastName, String email);	
        FormVm getFormVm(String attendeeId, String locationCode);
        EventInstructor getInstructor(String instructorId);
        void save(FormVm vm, EventAttendeeSm attendeeSm);
	}

	public interface IVmBuilder {	
        FormVm build(VmBuilderParams params);
        EventInstructor buildInstructorVm(DmEventInstructor dm, Map<String, DmDocument> docs);
	}

    public interface IVmBuilderHelper {
        EventAttendee buildAttendee(DmEventAttendee dm, string lastName, string email);
        EventClassVm buildSession(DmEventSession sdm, DmEventClass clsDm, Boolean isSelected, Map<String, DmDocument> docs);
        List<EventInstructor> buildInstructors(List<DmEventInstructor> instructors, Map<String, DmDocument> docs);
        EventInstructor buildInstructor(DmEventInstructor dm, Map<String, DmDocument> docs);
        List<PickList> buildIndustries(List<String> industries);
        List<PickList> buildPickList(List<String> picklistValues);
        PickList buildPickList(String label, String val);
    }

	public interface IRepository {	
        DmEventInstructor getInstructor(String instructorId);	
        DmEventAttendance getAttendance(String lastName, String email);
        DmEventAttendance getAttendance(String attendeeId);
        List<DmEventClass> getAllClasses();
        List<DmEventClass> getAllClassesByLocation(String locationCode);
        Map<String, DmDocument> getDocuments(List<DmEventClass> dmClasses);
        Map<String, DmDocument> getDocuments(DmEventInstructor dm);
		List<String> getIndustries();
		List<String> getHowDidYouHearOptions();
        List<String> getYearInSchoolOptions();
        AttendeeSm saveAttendee(EventAttendeeSm attendeeSm);
        AttendeeSm saveAttendee(FormVm vm);
        AttendeeSm saveAttendee(String lastName, String email, String recordTypeId);
        void saveAttendances(AttendeeSm asm, formVm vm);
	}

	public interface ISmBuilder {
        AttendeeSm buildAttendee(FormVm vm);
        AttendeeSm buildAttendee(EventAttendeeSm attendeeSm);
        AttendeeSm buildAttendee(String lastName, String email, String recordTypeId);
        AttendanceSm buildAttendances(Eb_Event_Attendees__c afterSaveAttendee, FormVm vm, List<Event_Attendance__c> attendanceLookup);
	}

	public interface IDmBuilder {
        DmEventAttendance getNewAttendance(List<EB_Event_Attendees__c> attendee, String lastName, String email);
        DmEventAttendance getNewAttendance(EB_Event_Attendees__c attendee);
        DmEventAttendance buildAttendance(List<Event_Attendance__c> attendances);
        DmEventAttendee buildAttendee(Eb_Event_Attendees__c attendeePm);
        List<DmEventClass> buildClasses(List<Eb_Event_Session__c> sessions);
        DmEventInstructor buildInstructor(Event_Instructor__c pm);
    }

    public interface IDocumentProvider {
        Map<String,DmDocument> getDocuments(List<String> documentIds);
    }

	public interface IDataProvider extends DataProvider.IDataProvider {
        List<Eb_Event_Attendees__c> getAttendee(String lastName, String email);
        Eb_Event_Attendees__c getAttendee(String attendeeId);
		List<EB_Event_Session__c> getSessionsByEventId(String eventId);
		List<Event_Attendance__c> getEventAttendee(Id eventCollectionId, String lastName, String attendeeEmail);
        List<Event_Attendance__c> getEventAttendee(Id eventCollectionId, String attendeeId);
        Event_Instructor__c getInstructor(Id instructorId);
        Map<String, String> getEbtLocations();
        Map<Id, Eb_Event_Session__c> getSessionsFromEbtEmployeeAttendees(List<Eb_Event_Attendees__c> attendees);
    }

	global class FormVm {
        public boolean LoginExists {get;set;}
		public EventAttendee Attendee { get; set; }
        public Event EventDetail { get; set; }
        public List<PickList> Locations { get; set; }
        public List<EventClassVm> Classes { get; set; }
        public List<EventClassByCategoryVm> ClassesGroupedByCategory { get; set; }
        public List<PickList> Industries { get; set; }
        public List<PickList> HowDidYouHear { get; set; }
        public List<PickList> YearInSchool {get;set;}
	}

    public class EventAttendee {
    	public String Id {get;set;}
        public String Email { get; set; }
        public String LastName { get; set; }
    }

    public class Event {
        public String Name { get; set; }
        public String EventReason { get; set; }
        public String Location { get; set; }
    }

    public class EventClassByCategoryVm implements Comparable {
        public String CategoryName { get; set; }
        public List<EventClassVm> Classes { get; set; }
        public Integer compareTo(Object compareTo) {
            EventClassByCategoryVm compareToCategory = (EventClassByCategoryVm)compareTo;
            if (CategoryName == compareToCategory.CategoryName) return 0;
            if (CategoryName > compareToCategory.CategoryName) return 1;
            return -1;    
        }
    }

    public class EventClassVm {
        public Boolean Selected { get; set; }
        public EventClass SelectedClass { get; set; }
    }

    public class EventClass {
        public String Id { get; set; }
        public String Name { get; set; }
        public String Content { get; set; }
        public String Location { get; set; }
        public String SessionDate { get; set; }
        public String SessionStartTime { get; set; }
        public String SessionEndTime { get; set; }
        public String SessionStartTimeCalender {get;set;}
        public String SessionEndTimeCalender {get;set;}
        public String Instructor { get; set; }
        public List<EventInstructor> Instructors {get;set;}
        public String Address { get; set; }
        public String Category { get; set; }
        public boolean Available {get;set;}
        public String TimeZone {get;set;}
        public String WebinarLink {get;set;}
        public String WebinarPassword {get;set;}
        public String SurveyLink {get;set;}
    }

    global class EventInstructor {
        public String Id {get;set;}
        public String Name {get;set;}
        public String ResumeAsText {get;set;}
        public String InstitutionFrom {get;set;}
        public String Picture {get;set;}
        public String Resume {get;set;}
    }

    public class PickList {
        public String Label { get; set; }
        public String Value { get; set; }
    }

    public class AttendeeDm {
        public DmEventAttendance attendeeInfo {get;set;}
        public Map<String, String> attendanceLookup{get;set;}
    }

    public class EventSessionSm {
    	public EventAttendee attendee {get;set;}
    	public Map<String, EventClass> attendeeSessionInserts {get;set;}
    	public Map<String, EventClass> attendeeSessionUpdates {get;set;}
    	public Map<String, EventClass> attendeeSessionRemoves {get;set;}
    }

    public class AttendeeSm {
        public Eb_Event_Attendees__c attendee {get;set;}
    }

    public class AttendanceSm {
        public List<Event_Attendance__c> saves {get;set;}
        public List<Event_Attendance__c> removes {get;set;}
    }

    global class EventAttendeeSm {
        public String Id {get;set;}
        public String RecordTypeId {get;set;}
        public String Name { get; set; }
        public String FirstName { get; set; }
        public String LastName { get; set; }
        public String JobTitle {get;set;}
        public String Company { get; set; }  
        public String City { get; set; }
        public String State { get; set; }
        public String Street { get; set; }
        public String Zip { get; set; }
        public String Email { get; set; }
        public String Location { get; set; }
        public String Phone { get; set; }
        public String Industry { get; set; }
        public String HowDidYouHear { get; set; }
        public String EbtEmployeeName {get;set;}
        public Boolean IsEmployee { get; set; }
        public Boolean SignupForAnnouncement {get;set;}
        public Boolean PermissionToContact {get;set;}
        public String College { get; set; }
        public String Year { get; set; }
        public String Degree { get; set; }
    }


    public class VmBuilderParams {
        public DmEventAttendance Attendance{get;set;}
        public List<DmEventClass> AllClasses{get;set;}
        public List<String> EbtAwareness{get;set;}
        public List<String> Industries{get;set;}
        public List<String> YearInSchool{get;set;}
        public String LastName{get;set;}
        public String Email{get;set;}
        public Map<String, DmDocument> InstructorDocuments{get;set;}
    }

	public class BootstrapException extends Exception {}
    public class InstructorException extends Exception {}
    public class SaveException extends Exception {}
}