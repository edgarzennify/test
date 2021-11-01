public class EventRegistrationPresenter implements EventRegistration.IPresenter {
	
	private final EventRegistration.IVmBuilder m_vmBuilder;
	private final EventRegistration.IRepository m_repository;

	public EventRegistrationPresenter(EventRegistration.IVmBuilder vmBuilder, EventRegistration.IRepository repository) {
		m_vmBuilder = vmBuilder;
		m_repository = repository;
	}

	public String getValidLogin(String lastName, String email) {
		DmEventAttendance attn = m_repository.getAttendance(lastName, email);
		if(String.isBlank(attn.attendee.id)){
			EventRegistration.AttendeeSm sm = m_repository.saveAttendee(attn.attendee.lastName, attn.attendee.email, attn.attendee.recordType.Id);
			attn.attendee.id = sm.attendee.id;
		}
		return attn.attendee.id;
	}

	public EventRegistration.FormVm getFormVm(String attendeeId, String locationCode) {
		EventRegistration.VmBuilderParams params = new EventRegistration.VmBuilderParams();
		DmEventAttendance attn = m_repository.getAttendance(attendeeId);
        params.attendance = attn;	
		params.allClasses = getClasses(locationCode);
		params.instructordocuments = new Map<String, DmDocument>();
		params.EbtAwareness = m_repository.getHowDidYouHearOptions();
		params.industries = m_repository.getIndustries();
        params.YearInSchool = m_repository.getYearInSchoolOptions();
		params.lastName = attn.attendee.lastName;
		params.email = attn.attendee.email;	
		EventRegistration.FormVm formVm = m_vmBuilder.build(params);
		return formVm;
	}

	public EventRegistration.EventInstructor getInstructor(String instructorId) {
		DmEventInstructor dm = m_repository.getInstructor(instructorId);
		Map<String, DmDocument> docs = m_repository.getDocuments(dm);
		EventRegistration.EventInstructor ins = m_vmBuilder.buildInstructorVm(dm, docs);
		return ins;
	}

	public void save(EventRegistration.FormVm vm, EventRegistration.EventAttendeeSm attendeeSm) {
		EventRegistration.attendeeSm asm = m_repository.saveAttendee(attendeeSm);
		m_repository.saveAttendances(asm, vm);
	}

	private List<DmEventClass> getClasses(String locationCode) {
		return String.isBlank(locationCode)
			   ? m_repository.getAllClasses()
			   : m_repository.getAllClassesByLocation(locationCode);
	}

}