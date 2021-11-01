@IsTest
public class EventRegistrationMock {

	public class ofIPresenter extends ApexMoq implements EventRegistration.IPresenter {	
        public String getValidLogin(String lastName, String email) {
            return (String)handleMethodInvocation('getValidLogin', new List<Object>{lastNAme, email});
        }
        public EventRegistration.FormVm getFormVm(String attendeeId, String locationCode) {
        	return (EventRegistration.FormVm)handleMethodInvocation('getFormVm' ,new List<Object>{attendeeId, locationCode});
        }
        public EventRegistration.EventInstructor getInstructor(String instructorId) {
            return (EventRegistration.EventInstructor)handleMethodInvocation('getInstructor', new List<Object>{instructorId});
        }
		public void save(EventRegistration.FormVm vm, EventRegistration.EventAttendeeSm attendeeSm) {
			handleMethodInvocation('save' ,new List<Object>{vm, attendeeSm});
		}
	}

	public class ofIVmBuilder extends ApexMoq implements EventRegistration.IVmBuilder {	
        public EventRegistration.FormVm build(EventRegistration.VmBuilderParams params) {
        	return (EventRegistration.FormVm)handleMethodInvocation('build', new List<Object>{params});
        }
        public EventRegistration.EventInstructor buildInstructorVm(DmEventInstructor dm, Map<String, DmDocument> docs) {
            return (EventRegistration.EventInstructor)handleMethodInvocation('buildInstructorVm', new List<Object>{dm, docs});
        }
	}

	public class ofIVmBuilderHelper extends ApexMoq implements EventRegistration.IVmBuilderHelper {
		public EventRegistration.EventAttendee buildAttendee(DmEventAttendee dm, string lastName, string email) {
			return (EventRegistration.EventAttendee)handleMethodInvocation('buildAttendee', new List<Object>{dm, lastName, email});
		}
        public EventRegistration.EventClassVm buildSession(DmEventSession sdm, DmEventClass clsDm, Boolean isSelected, Map<String, DmDocument> docs) {
        	return (EventRegistration.EventClassVm)handleMethodInvocation('buildSession', new List<Object>{sdm, clsDm, isSelected, docs});
        }
        public List<EventRegistration.EventInstructor> buildInstructors(List<DmEventInstructor> instructors, Map<String, DmDocument> docs) {
        	return (List<EventRegistration.EventInstructor>)handleMethodInvocation('buildInstructors', new List<Object>{instructors, docs});
        }
        public EventRegistration.EventInstructor buildInstructor(DmEventInstructor dm, Map<String, DmDocument> docs) {
            return (EventRegistration.EventInstructor)handleMethodInvocation('buildInstructor', new List<Object>{dm, docs});
        }
        public List<EventRegistration.PickList> buildIndustries(List<String> industries) {
        	return (List<EventRegistration.PickList>)handleMethodInvocation('buildIndustries', new List<Object>{industries});
        }
        public List<EventRegistration.PickList> buildPickList(List<String> picklistValues) {
        	return (List<EventRegistration.PickList>)handleMethodInvocation('buildPickList', new List<Object>{picklistValues});
        }
        public EventRegistration.PickList buildPickList(String label, String val) {
        	return (EventRegistration.PickList)handleMethodInvocation('buildPickList', new List<Object>{label, val});
        }
	}

	public class ofIRepository extends ApexMoq implements EventRegistration.IRepository {		
        public DmEventAttendance getAttendance(String lastName, String email) {
        	return (DmEventAttendance)handleMethodInvocation('getAttendance', new List<Object>{lastName, email});
        }
        public DmEventAttendance getAttendance(String attendeeId) {
            return (DmEventAttendance)handleMethodInvocation('getAttendance', new List<Object>{attendeeId});
        }
        public List<DmEventClass> getAllClasses() {
        	return (List<DmEventClass>)handleMethodInvocation('getAllClasses');
        }
        public List<DmEventClass> getAllClassesByLocation(String locationCode) {
        	return (List<DmEventClass>)handleMethodInvocation('getAllClassesByLocation', new List<Object>{locationCode});
        }
        public Map<String, DmDocument> getDocuments(List<DmEventClass> dmClasses) {
        	return (Map<String, DmDocument>)handleMethodInvocation('getDocuments', new List<Object>{dmClasses});
        }
        public Map<String, DmDocument> getDocuments(DmEventInstructor dm) {
            return (Map<String, DmDocument>)handleMethodInvocation('getDocuments', new List<Object>{dm});
        }
        public DmEventInstructor getInstructor(String instructorId) {
            return (DmEventInstructor)handleMethodInvocation('getInstructor', new List<Object>{instructorId});
        }
		public List<String> getIndustries() {
			return (List<String>)handleMethodInvocation('getIndustries');
		}
		public List<String> getHowDidYouHearOptions() {
			return (List<String>)handleMethodInvocation('getHowDidYouHearOptions');
		}
        public List<String> getYearInSchoolOptions() {
			return (List<String>)handleMethodInvocation('getYearInSchoolOptions');
		}
        public EventRegistration.AttendeeSm saveAttendee(EventRegistration.formVm vm) {
            return (EventRegistration.AttendeeSm)handleMethodInvocation('saveAttendee', new List<Object>{vm});
        }
        public EventRegistration.AttendeeSm saveAttendee(EventRegistration.EventAttendeeSm attendeeSm) {
            return (EventRegistration.AttendeeSm)handleMethodInvocation('saveAttendee', new List<Object>{attendeeSm});
        }
        public  EventRegistration.AttendeeSm saveAttendee(String lastName, String email, String recordTypeId) {
            return (EventRegistration.AttendeeSm)handleMethodInvocation('saveAttendee', new List<Object>{lastName, email, recordTypeId});
        }
        public void saveAttendances(EventRegistration.AttendeeSm asm, EventRegistration.formVm vm) {
            handleMethodInvocation('saveAttendances', new List<Object>{asm, vm});
        }
	}

	public class ofISmBuilder extends ApexMoq implements EventRegistration.ISmBuilder {
        public EventRegistration.AttendeeSm buildAttendee(EventRegistration.FormVm vm) {
        	return (EventRegistration.AttendeeSm)handleMethodInvocation('buildAttendee', new List<Object>{vm});
        }
        public EventRegistration.AttendeeSm buildAttendee(EventRegistration.EventAttendeeSm attendeeSm) {
            return (EventRegistration.AttendeeSm)handleMethodInvocation('buildAttendee', new List<Object>{attendeeSm});
        }
        public EventRegistration.AttendeeSm buildAttendee(String lastName, String email, String recordTypeId) {
            return (EventRegistration.AttendeeSm)handleMethodInvocation('buildAttendee', new List<Object>{lastName, email, recordTypeId});
        }
        public EventRegistration.AttendanceSm buildAttendances(Eb_Event_Attendees__c afterSaveAttendee, EventRegistration.FormVm vm, List<Event_Attendance__c> attendanceLookup) {
            return (EventRegistration.AttendanceSm)handleMethodInvocation('buildAttendances', new List<Object>{afterSaveAttendee, vm, attendanceLookup});
        }
	}

	public class ofIDmBuilder extends ApexMoq implements EventRegistration.IDmBuilder {
        public DmEventAttendance getNewAttendance(List<EB_Event_Attendees__c> attendee, String lastName, String email) {
            return (DmEventAttendance)handleMethodInvocation('getNewAttendance', new List<Object>{attendee, lastName, email});
        }
        public DmEventAttendance getNewAttendance(EB_Event_Attendees__c attendee) {
            return (DmEventAttendance)handleMethodInvocation('getNewAttendance', new List<OBject>{attendee});
        }
        public DmEventAttendance buildAttendance(List<Event_Attendance__c> attendances) {
        	return (DmEventAttendance)handleMethodInvocation('buildAttendance', new List<Object>{attendances});
        }
        public List<DmEventClass> buildClasses(List<Eb_Event_Session__c> sessions) {
        	return (List<DmEventClass>)handleMethodInvocation('buildClasses', new List<Object>{sessions});
        }
        public DmEventInstructor buildInstructor(Event_Instructor__c pm) {
            return (DmEventInstructor)handleMethodInvocation('buildInstructor', new List<Object>{pm});
        }
        public DmEventAttendee buildAttendee(Eb_Event_Attendees__c attendeePm) {
            return (DmEventAttendee)handleMethodInvocation('buildAttendee', new List<Object>{attendeePm});
        }
	}

	public class ofIDocumentProvider extends ApexMoq implements EventRegistration.IDocumentProvider {
        public Map<String,DmDocument> getDocuments(List<String> documentIds) {
        	return (Map<String,DmDocument>)handleMethodInvocation('getDocuments', new List<Object>{documentIds});
        }
    }

    public class ofIDataProvider extends Mock.ofIDataProvider implements EventRegistration.IDataProvider {
		public List<Eb_Event_Attendees__c> getAttendee(String lastName, String email) {
            return (List<Eb_Event_Attendees__c>)handleMethodInvocation('getAttendee', new List<Object>{lastName, email});
        }
        public EB_Event_Attendees__c getAttendee(String attendeeId) {
            return (EB_Event_Attendees__c)handleMethodInvocation('getAttendee', new List<Object>{attendeeId});
        }
        public List<EB_Event_Session__c> getSessionsByEventId(String eventId) {
			return (List<EB_Event_Session__c>)handleMethodInvocation('getSessionsByEventId', new List<Object>{eventId});
		}
		public List<Event_Attendance__c> getEventAttendee(Id eventCollectionId, String lastName, String attendeeEmail) {
			return (List<Event_Attendance__c>)handleMethodInvocation('getEventAttendee', new List<Object>{eventCollectionId, lastName, attendeeEmail});
		}
        public Event_Instructor__c getInstructor(Id instructorId) {
            return (Event_Instructor__c)handleMethodInvocation('getInstructor', new List<Object>{instructorId});
        }
        public Map<String, String> getEbtLocations() {
            return (Map<String, String>)handleMethodInvocation('getEbtLocations');
        }
        public Map<Id, Eb_Event_Session__c> getSessionsFromEbtEmployeeAttendees(List<Eb_Event_Attendees__c> attendees) {
            return (Map<Id, Eb_Event_Session__c>)handleMethodInvocation('getSessionsFromEbtEmployeeAttendees', new List<Object>{attendees});
        }
        public List<Event_Attendance__c> getEventAttendee(Id collectionId, String attendeeId) {
            return (List<Event_Attendance__c>)handleMethodInvocation('getEventAttendee', new List<Object>{collectionId, attendeeId});
        }
	}
}