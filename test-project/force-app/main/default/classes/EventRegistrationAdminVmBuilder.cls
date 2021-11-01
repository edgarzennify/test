public class EventRegistrationAdminVmBuilder implements EventRegistrationAdmin.IVmBuilder {
    public List<EventRegistrationAdmin.Course> build(List<DmEventClass> classes) {
        List<EventRegistrationAdmin.Course> courses = new List<EventRegistrationAdmin.Course>();
        for(DmEventClass cls : classes) {
            EventRegistrationAdmin.Course course = new EventRegistrationAdmin.Course();
            course.Id = cls.Id;
            course.ClassName = cls.Name;
            course.StartDate = cls.sessions[0].StartDateTime;
            course.EndDate = cls.sessions[0].EndDateTime;
            course.AttendeeCount = cls.sessions[0].NumberOfAttendees;
            course.TotalSeats = cls.sessions[0].Capacity;
            course.Region = cls.sessions[0].Region;
            course.Instructors = new List<String>();
            for(DmEventInstructor inst : cls.sessions[0].instructors) {
                course.Instructors.Add(inst.Name);
            }
            courses.Add(course);
    
        }
        return courses;
    }

    public List<EventRegistrationAdmin.VmAttendance> buildAttendances(List<DmEventAttendance> attendances) {
        List<EventRegistrationAdmin.VmAttendance> results = new List<EventRegistrationAdmin.VmAttendance>();
        for(DmEventAttendance a: attendances) {
            EventRegistrationAdmin.VmAttendance at = new EventRegistrationAdmin.VmAttendance();
            at.Id = a.Id;
            at.AttendeeId = a.attendee.Id;
            if (String.isNotBlank(a.attendee.firstname)) {
                at.FirstName = a.attendee.firstname;
            }else {
                at.FirstName = '';
            }
            at.LastName = a.attendee.lastname;
            at.Present = a.Present;
            at.EntityId = a.attendee.Entity == null?'': a.attendee.Entity.id;
            at.Entity = a.attendee.Entity == null?'': a.attendee.Entity.Name;
            at.LeadId = a.attendee.Lead == null?'':a.attendee.Lead.id;
            at.Lead = a.attendee.Lead == null?'':a.attendee.Lead.Name;
            at.PrimaryRMId = a.attendee.PrimaryRM ==null?'': a.attendee.PrimaryRM.Id;
            at.PrimaryRM = a.attendee.PrimaryRM ==null?'':a.attendee.PrimaryRM.Name;
            at.RelatedTo = getRelatedTo(a.attendee);
            at.RelatedToId = getRelatedToId(a.attendee);
            
            results.Add(at);
        }
        return results;
    }

    public EventRegistrationAdmin.Attendee buildAttendee(DmEventAttendee attendeeDm) {
        EventRegistrationAdmin.Attendee attendee = new EventRegistrationAdmin.Attendee();
        attendee.Id = attendeeDm.Id;
        attendee.FirstName = attendeeDm.FirstName;
        attendee.LastName = attendeeDm.LastName;
        attendee.Email = attendeeDm.Email;
        attendee.JobTitle = attendeeDm.JobTitle;
        attendee.Company = attendeeDm.Company;
        attendee.EntityId = attendeeDm.Entity == null?'':attendeeDm.Entity.id;
        attendee.Entity = attendeeDm.Entity == null?'':attendeeDm.Entity.Name;
        attendee.LeadId = attendeeDm.Lead == null?'':attendeeDm.Lead.id;
        attendee.Lead = attendeeDm.Lead == null?'':attendeeDm.Lead.Name;
        attendee.PrimaryRMId = attendeeDm.PrimaryRM == null? '':attendeeDm.PrimaryRM.Id;
        attendee.PrimaryRM = attendeeDm.PrimaryRM == null?'':attendeeDm.PrimaryRM.Name;
        attendee.RelatedTo = getRelatedTo(attendeeDm);
        attendee.RelatedToId = getRelatedToId(attendeeDm);

        return attendee;
    }

    public List<EventRegistrationAdmin.SearchResult> buildSearch(List<DmEventClass> classes) {
        List<EventRegistrationAdmin.SearchResult> results = new List<EventRegistrationAdmin.SearchResult>();
        for(DmEventClass c:classes) {
            EventRegistrationAdmin.SearchResult r= new EventRegistrationAdmin.SearchResult();
            r.Id = c.Id;
            r.Type = 'Class';
            r.ClassName = c.Name;
            results.Add(r);
        }
        return results;
    }

    private String getRelatedTo(DmEventAttendee dm) {

        String relTo = '';
        if(dm == null) return relTo;
        if(dm.lead != null && String.isNotBlank(dm.lead.id)) {
            relTo = dm.lead.Name;
        }
        if(dm.Entity != null && String.isNotBlank(dm.entity.id)){
            relTo = dm.entity.name;
        }
        return relTo;
    }

    private String getRelatedToId(DmEventAttendee dm) {
        String relTo = '';
        if(dm == null) return relTo;
        if(dm.lead != null && String.isNotBlank(dm.lead.id)) {
            relTo = dm.lead.id;
        }
        if(dm.Entity != null && String.isNotBlank(dm.entity.id)){
            relTo = dm.entity.id;
        }
        return relTo;
    }
}