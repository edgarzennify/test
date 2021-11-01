public class EventRegistrationVmBuilderHelper  implements EventRegistration.IVmBuilderHelper {

    private final IEncodingUtil m_encodeUtil;

    public EventRegistrationVmBuilderHelper(IEncodingUtil encodeUtil) {
        m_encodeUtil = encodeUtil;
    }

    public EventRegistration.EventAttendee buildAttendee(DmEventAttendee dm, string lastName, string email) {
        EventRegistration.EventAttendee vm = new EventRegistration.EventAttendee();
        vm.Id = dm.id;
        vm.Email = email;
        vm.LastName = lastName;

        return vm;
    }

    public EventRegistration.EventClassVm buildSession(DmEventSession sdm, DmEventClass clsDm, Boolean isSelected, Map<String, DmDocument> docs) {
        
        EventRegistration.EventClassVm vm = new EventRegistration.EventClassVm();
        vm.SelectedClass = new EventRegistration.EventClass();
        vm.Selected = isSelected;
        vm.SelectedClass.Id = sdm.id;
        vm.SelectedClass.Name = clsDm.name;           
        vm.SelectedClass.Content = sDm.description;                  
        vm.SelectedClass.Location = sdm.region;
        vm.SelectedClass.SessionDate = getDateText(sdm.startDateTime);
        vm.SelectedClass.SessionStartTime = getTime(sdm.startDateTime);
        vm.SelectedClass.SessionEndTime = getTime(sdm.endDateTime);
        vm.SelectedClass.SessionStartTimeCalender = FormatForCalendar(sdm.startDateTime);
        vm.SelectedClass.SessionEndTimeCalender = FormatForCalendar(sdm.endDateTime);
        vm.SelectedClass.Instructor = sdm.instructor;
        vm.SelectedClass.Instructors = buildInstructors(sdm.instructors, docs);     
        vm.SelectedClass.Address = sdm.address;
        vm.SelectedClass.Category = clsDm.category;
        vm.SelectedClass.Available = sdm.capacity > 0;
        vm.SelectedClass.SurveyLink = sdm.SurveyLink;
        vm.SelectedClass.WebinarLink = sdm.WebinarLink;
        vm.SelectedClass.WebinarPassword = sdm.WebinarPassword;
        vm.SelectedClass.TimeZone = sdm.TimeZone;
        
        return vm;
    }

    public List<EventRegistration.EventInstructor> buildInstructors(List<DmEventInstructor> instructors, Map<String, DmDocument> docs) {
        List<EventRegistration.EventInstructor> vms = new List<EventRegistration.EventInstructor>();
        if(instructors == null || instructors.size() == 0) {return vms;}
        
        for(DmEventInstructor dm : instructors) {
            vms.add(buildInstructor(dm, null));
        }

        return vms;
    }

    public EventRegistration.EventInstructor buildInstructor(DmEventInstructor dm, Map<String, DmDocument> docs) {      
        EventRegistration.EventInstructor vm = new EventRegistration.EventInstructor();
        vm.id = dm.id;
        vm.name = dm.name;
        vm.institutionFrom = dm.institutionFrom;
        vm.resumeAsText = dm.detail;
        if(docs != null && docs.keySet().size() > 0) {
            DmDocument picDm = docs.get(dm.pictureLink);
            DmDocument resumeDm = docs.get(dm.resumeLink);
            vm.Picture = picDm == null ? null : m_encodeUtil.toBase64(picDm.body);
            vm.Resume = resumeDm == null ? null : m_encodeUtil.toBase64(resumeDm.body);      
        }
        
        return vm;
    }

    public List<EventRegistration.PickList> buildIndustries(List<String> industries) {
        List<EventRegistration.PickList> industryOptions = new List<EventRegistration.PickList>();
        for(String i : industries) {
            industryOptions.add(buildPickList(i, i));
        }

        return industryOptions;
    }

    public List<EventRegistration.PickList> buildPickList(List<String> picklistValues) {
        List<EventRegistration.PickList> options = new List<EventRegistration.PickList>();
        for(String s : picklistValues) {
            options.add(buildPickList(s,s));
        }

        return options;
    }

    public EventRegistration.PickList buildPickList(String label, String val) {
        EventRegistration.PickList p = new EventRegistration.PickList();
        p.Label = label;
        p.Value = val;

        return p;
    }

    private String getDateText(DateTime dt) {
        if(dt==null) return '';
        return dt.format('EEEE, MMMM d, yyyy');
    }

    private String getTime(DateTime dt) {
        if(dt == null) return '';
        return dt.format('hh:mm a');
    }

    private String FormatForCalendar(DateTime dt) {
        if(dt == null) return '';
        return dt.formatGmt('yyyyMMdd\'T\'HHmmss\'Z\'');
    }
}