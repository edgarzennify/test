public class EventRegistrationAdminDmBuilder implements EventRegistrationAdmin.IDmBuilder {

	public final EventRegistrationAdmin.IDmBuilderHelper m_dmHelper;

	public EventRegistrationAdminDmBuilder(EventRegistrationAdmin.IDmBuilderHelper dmHelper) {
		m_dmHelper = dmHelper;
	}

	public List<DmEventClass> build(List<Eb_Event_Session__c> pms) {
		Map<string, DmEventClass> dms = new Map<string, DmEventClass> ();

		for (Eb_Event_session__c s : pms) {
			DmEventClass cls = buildClass(s);

			if (!dms.containsKey(cls.id)) {
				dms.put(cls.id, cls);
			} else {
				dms.get(cls.id).sessions.add(cls.sessions[0]);
			}
		}

		return dms.values();
	}

	public List<DmEventAttendance> buildAttendance(List<Event_Attendance__c> attendees)
	{
		List<DmEventAttendance> attendances = new List<DmEventAttendance> ();
		for (Event_Attendance__c attendance : attendees) {
			if (attendance.Event_Attendee__r != null) {
				DmEventAttendance att = createAttendance(attendance);
				attendances.Add(att);
			}
		}
		return attendances;
	}

	public DmEventAttendance createAttendance(Event_Attendance__c attendance) {
		DmEventAttendance dm = new DmEventAttendance();
		dm.Present = attendance.Record_Attendance__c;
		dm.attendee = buildAttendee(attendance.Event_Attendee__r);
		dm.Id = attendance.Id;

		return dm;
	}

	public DmEventAttendee buildAttendee(Eb_Event_Attendees__c attendeePm) {
		DmEventAttendee dm = new DmEventAttendee();
		dm.id = attendeePm.id;
		dm.firstName = attendeePm.Attendee_First_Name__c;
		dm.lastName = attendeePm.Attendee_Last_Name__c;
		dm.email = attendeePm.Email_Address__c;
        dm.jobTitle = attendeePm.Job_Title__c;
        dm.company = attendeePm.Company__c;
		dm.entity = new DmEntity();
		dm.entity.id = attendeePm.EntityId__c;
		dm.entity.name = attendeePm.EntityId__r == null?'': attendeePm.EntityId__r.Name;
		dm.lead = new DmLead();
		dm.lead.id = attendeePm.LeadId__c;
		dm.lead.name = attendeePm.LeadId__r == null?'' : attendeePm.LeadId__r.Name;
		dm.primaryRM = new DmUser();
		dm.primaryRM = getPrimaryRM(attendeePm);
		dm.relatedTo = attendeePm.Related_To__c;

		return dm;
	}

	private DmUser getPrimaryRM(Eb_Event_Attendees__c attendeePm) {
		DmUser owner = new DmUser();
		if(attendeePm.LeadId__c != null) {
			owner.Id = attendeePm.LeadId__r.Owner == null?null:attendeePm.LeadId__r.Owner.Id;
			owner.Name = attendeePm.LeadId__r.Owner == null?'':attendeePm.LeadId__r.Owner.Name;
		}
		if(attendeePm.EntityId__c != null) {
			owner.Id = attendeePm.EntityId__r.Owner == null?null: attendeePm.EntityId__r.Owner.Id;
			owner.Name = attendeePm.EntityId__r.Owner == null? '':attendeePm.EntityId__r.Owner.Name;
		}
		return owner;
	}

	private DmEventClass buildClass(EB_Event_Session__c session) {
		DmEventClass dm = new DmEventClass();
		dm.id = session.Id;
		dm.name = session.Event_Name__c;
		DmEventSession s = buildSession(session);
		dm.sessions = new List<DmEventSession> { s };

		return dm;
	}

	private DmEventSession buildSession(Eb_Event_Session__c sessionPm) {
		DmEventSession dm = new DmEventSession();
		dm.id = sessionPm.Id;
		dm.capacity = Integer.valueof(sessionPm.Capacity__c);
		dm.numberOfAttendees = m_dmHelper.NumberOfAttendeesByAttendance(sessionPm);
		dm.startDateTime = sessionPm.Date_Time_of_Event__c;
		dm.endDateTime = sessionPm.End_Date_Time_of_Event__c;
		dm.region = sessionPm.Region__c;
		dm.instructors = buildInstructors(sessionPm);

		return dm;
	}

	private List<DmEventInstructor> buildInstructors(Eb_Event_Session__c pm) {
		List<DmEventInstructor> dms = new List<DmEventInstructor>();

		if (pm.Instructor_1__c != null) {
			DmEventInstructor instructor = new DmEventInstructor();
			instructor.Name = pm.Instructor_1__r.Name;
			dms.add(instructor);
		}

		if (pm.Instructor_2__c != null) {
			DmEventInstructor instructor = new DmEventInstructor();
			instructor.Name = pm.Instructor_2__r.Name;
			dms.add(instructor);
		}

		if (pm.Instructor_3__c != null) {
			DmEventInstructor instructor = new DmEventInstructor();
			instructor.Name = pm.Instructor_3__r.Name;
			dms.add(instructor);
		}

		return dms;
	}
}