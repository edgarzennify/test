global class EventRegistrationAdminPresenter implements EventRegistrationAdmin.IPresenter {
    public final EventRegistrationAdmin.IRepository m_repository;
    public final EventRegistrationAdmin.IVmBuilder m_vmBuilder;

    public EventRegistrationAdminPresenter(EventRegistrationAdmin.IRepository repository, EventRegistrationAdmin.IVmBuilder vmBuilder) {
        m_repository = repository;
        m_vmBuilder = vmBuilder;
    }

    public List<EventRegistrationAdmin.Course> getClasses() {
        List<DmEventClass> classes = m_repository.getAllClasses();
        return m_vmBuilder.build(classes);
    }

    public EventRegistrationAdmin.Course getClass(String classId) {
        DmEventClass r_class = m_repository.getClass(classId);
        List<DmEventClass> classes = new List<DmEventClass>();
        classes.Add(r_class);
        return m_vmBuilder.build(classes)[0];	
    }

    public List<EventRegistrationAdmin.VmAttendance> getAttendeesForClass(String classId) {
        List<DmEventAttendance> attendances = m_repository.getAttendeesForClass(classId);
        return m_vmBuilder.buildAttendances(attendances);
    }

    public EventRegistrationAdmin.Attendee getAttendee(String attendeeId) {
        DmEventAttendee attendee = m_repository.getAttendee(attendeeId);
        return m_vmBuilder.buildAttendee(attendee);
    }
    
    public Boolean setAttendeeAttendance(String attendanceId, Boolean present){
        DmEventAttendance attendance = new DmEventAttendance();
        attendance.Id = attendanceId;
        attendance.Present = present;
        m_repository.setAttendeeAttendance(new List<DmEventAttendance>{attendance});
        return true;
    }
    
    public Boolean setClassAttendance(String classId, Boolean present){
        List<DmEventAttendance> attendances = m_repository.getAttendeesForClass(classId);
        for(DmEventAttendance att: attendances) {
            att.Present = present;
        }
        m_repository.setAttendeeAttendance(attendances);
        return true;
    }
	
    public Boolean addAttendeeToClass(EventRegistrationAdmin.Attendee attendee, String classId, Boolean present){
        if (attendee.Id == '0' || attendee.Id == null) {
            DmEventAttendee savedAttendee = saveAttendee(attendee);
            m_repository.createAttendance(savedAttendee.Id, classId, present);
        }else {
            saveAttendee(attendee);
        }
        return true;
    }
	
    private DmEventAttendee saveAttendee(EventRegistrationAdmin.Attendee attendee){
        DmEventAttendee attendeeDm = new DmEventAttendee();
        if (attendee.Id != '0') {
            attendeeDm.Id = attendee.Id;
        }
        attendeeDm.FirstName = attendee.FirstName;
        attendeeDm.LastName = attendee.LastName;
        attendeeDm.Email = attendee.Email;
        attendeeDm.Company = attendee.Company;
        attendeeDm.JobTitle = attendee.JobTitle;
        attendeeDm.Id = m_repository.saveAttendee(new List<DmEventAttendee>{attendeeDm});
        return attendeeDm;
    }
	
    public List<EventRegistrationAdmin.SearchResult> search(String param){
        List<DmEventClass> classes = m_repository.search(param);
        return m_vmBuilder.buildSearch(classes);
    }
    
}