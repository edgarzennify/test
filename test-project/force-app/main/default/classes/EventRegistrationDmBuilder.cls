public class EventRegistrationDmBuilder implements EventRegistration.IDmBuilder {

	private final Utility.IUtility m_util;

	public EventRegistrationDmBuilder(Utility.IUtility util) {
		m_util = util;
	}

	public DmEventAttendance getNewAttendance(List<EB_Event_Attendees__c> attendee, String lastName, String email) {
		DmEventAttendance attn = new DmEventAttendance();
		DmEventAttendee ate = new DmEventAttendee();
		RecordType rec = m_util.RecordTypeObject('EB_Event_Attendees__c', 'EB Course');
		ate.recordType = buildRecordType(rec.Id, rec.Name);

		if(attendee != null && attendee.size() > 0) {		
			ate.id = attendee[0].id;
	    }
	    ate.lastName = lastName;
	    ate.email = email;
	    ate.SignupForAnnouncement = true;    

		attn.attendee = ate;
		attn.classes = new List<DmEventClass>();

		return attn;
	}

	public DmEventAttendance getNewAttendance(EB_Event_Attendees__c attendee) {
		DmEventAttendance attn = new DmEventAttendance();
		attn.attendee = buildAttendee(attendee);
		attn.classes = new List<DmEventClass>();

		return attn;
	}

	public DmEventAttendance buildAttendance(List<Event_Attendance__c> attendances) {
		DmEventAttendance dm = new DmEventAttendance();
		if(attendances == null || attendances.size() == 0){
			dm.attendee = new DmEventAttendee();
			RecordType rec = m_util.RecordTypeObject('EB_Event_Attendees__c', 'EB Course');
			dm.attendee.recordType = buildRecordType(rec.Id, rec.Name);
			dm.classes = new List<DmEventClass>();
			return dm;
		}

		dm.attendee = buildAttendee(attendances[0].Event_Attendee__r);
		List<Eb_Event_Session__c> sessions = new List<Eb_Event_Session__c>();
		for(Event_Attendance__c a : attendances) {
			sessions.add(a.Event_Session__r);
		}

		dm.classes = buildClasses(sessions);

		return dm;
	}

	public List<DmEventClass> buildClasses(List<Eb_Event_Session__c> sessions) {
		Map<string, DmEventClass> dms = new Map<string, DmEventClass>();

		for(Eb_Event_session__c s : sessions) {
			DmEventClass cls = buildClass(s);

			if(!dms.containsKey(cls.id)){
				dms.put(cls.id, cls);
			}else{
				dms.get(cls.id).sessions.add(cls.sessions[0]);
			}
		}

		return dms.values();
	}

	public DmEventInstructor buildInstructor(Event_Instructor__c pm) {
		DmEventInstructor dm = new DmEventInstructor();
		dm.id = pm.Id;
		dm.name = pm.Name;
		dm.institutionFrom = pm.Institution_From__c;
		dm.detail = pm.Detail__c;
		dm.resumeLink = (Id)pm.Resume_Link__c;
		dm.pictureLink = (Id)pm.Picture_Link__c;

		return dm;
	}

	public DmEventAttendee buildAttendee(Eb_Event_Attendees__c attendeePm) {
		DmEventAttendee dm = new DmEventAttendee();
		dm.id = attendeePm.id;
		dm.firstName = attendeePm.Attendee_First_Name__c;
		dm.lastName = attendeePm.Attendee_Last_Name__c;
		dm.jobTitle = attendeePm.Job_Title__c;
		dm.email = attendeePm.Email_Address__c;
		dm.company = attendeePm.Company__c;
		dm.street = attendeePm.Company_Address_Street__c;
		dm.city = attendeePm.Company_Address_City__c;
		dm.state = attendeePm.Company_Address_State__c;
		dm.zip = attendeePm.Company_Address_Zip__c;
		dm.phone = attendeePm.Phone__c;
		dm.heardFrom = attendeePm.Heard_From__c;
		dm.ebtEmployeeName = attendeePm.Heard_From_EBT_Employee__c;
		dm.industry = attendeePm.Industry__c;
		dm.signupForAnnouncement = attendeePm.Signup_For_Announcement__c;
        dm.permissionToContact = attendeePM.Permission_To_Contact__c;
		dm.recordType = buildRecordType(attendeePm.RecordTypeId, attendeePm.RecordType.Name);

		return dm;
	}

	private DmEventClass buildClass(EB_Event_Session__c session) {
		DmEventClass dm = new DmEventClass();
		if(session == null) return dm;
		dm.id = session.Id;
		dm.name = session.Event_Name__c;
		dm.category = session.Category__c;
		DmEventSession s = buildSession(session);
		dm.sessions = new List<DmEventSession>{s};

		return dm;
	}

	private DmEventSession buildSession(Eb_Event_Session__c sessionPm) {
		Integer capacity = Integer.valueof(sessionPm.Capacity__c);
		if (sessionPm.Date_Time_of_Event__c < System.now()) {
			capacity = 0;
		}
		DmEventSession dm = new DmEventSession();
		dm.id = sessionPm.Id;
		dm.name = sessionPm.Name;
		dm.address = sessionPm.Address__c;
		dm.capacity = capacity;
		dm.Description = sessionPm.Description__c;
		dm.numberOfAttendees = Integer.valueof(sessionPm.Number_of_Attendees_By_Attendance__c);
		dm.seatsAvailable = Integer.valueof(sessionPm.Seats_Available_By_Attendance__c);
		dm.startDateTime = sessionPm.Date_Time_of_Event__c;
		dm.endDateTime = sessionPm.End_Date_Time_of_Event__c;
		dm.location = sessionPm.Location__c;
		dm.region = sessionPm.Region__c;
    	dm.location = sessionPm.Location__c;
    	dm.instructor  = sessionPm.Instructor__c;
    	dm.instructors = buildInstructors(sessionPm);
        dm.TimeZone = sessionPm.Time_Zone__c;
        dm.SurveyLink = sessionPm.Survey_Link__c;
        dm.WebinarLink = sessionPm.Webinar_Link__c;
        dm.WebinarPassword = sessionPm.Webinar_Password__c;

		return dm;
	}

	private DmRecordType buildRecordType(Id recordTypeId, String recordTypeName) {
		DmRecordType dm = new DmRecordType();
		if(!String.isBlank(recordTypeId)) {
			dm.id = recordTypeId;
			dm.name = recordTypeName;
		}else {
			RecordType rec = m_util.RecordTypeObject('EB_Event_Attendees__c', 'EB Course');
			dm.id = rec.id;
			dm.name = rec.name;
		}

		return dm;
	}

	private List<DmEventInstructor>  buildInstructors(Eb_Event_Session__c pm) {
		List<DmEventInstructor> dms = new List<DmEventInstructor>();
		
		if(pm.Instructor_1__r != null) {
			dms.add(buildInstructor(pm.Instructor_1__r));
		}

		if(pm.Instructor_2__r != null) {
			dms.add(buildInstructor(pm.Instructor_2__r));
		}
        
        if(pm.Instructor_3__r != null) {
			dms.add(buildInstructor(pm.Instructor_3__r));
		}

		return dms;
	}
}