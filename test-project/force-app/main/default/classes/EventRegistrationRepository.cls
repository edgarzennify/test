public class EventRegistrationRepository implements EventRegistration.IRepository {

	private final String EVENT_ID = 'EventRegistrationApp';
	private final String EVENT_COLLECTION_ID = 'EventRegistrationApp';
	private final String OPTIONS_SOBJECT_TYPE = 'EB_Event_Attendees__c';
	private final String INDUSTRY_FIELD = 'Industry__c';
	private final String HOW_DID_YOU_HEAR_FIELD = 'Heard_From__c';
    private final String YEAR_IN_SCHOOL_FIELD = 'Year_In_School__c';

	private Id m_colectionId;
	
	private final EventRegistration.IDataProvider m_dataProvider;
	private final EventRegistration.IDmBuilder m_dmBuilder;
	private final Utility.IUtility m_util;
	private final Configurations.IConfigurations m_configs;
	private final EventRegistration.ISmBuilder m_smBuilder;
	private final EventRegistration.IDocumentProvider m_docProvider;


	public EventRegistrationRepository(EventRegistration.IDataProvider dataProvider, EventRegistration.IDmBuilder dmBuilder
							, Utility.IUtility util, Configurations.IConfigurations configs
							, EventRegistration.ISmBuilder smBuilder, EventRegistration.IDocumentProvider docProvider) {
		m_dataProvider = dataProvider;
		m_dmBuilder = dmBuilder;
		m_util = util;
		m_configs = configs;
		m_smBuilder = smBuilder;
		m_docProvider = docProvider;
	}

	private Id getCollectionId() {
		if(String.isBlank(m_colectionId)) {
			m_colectionId = m_configs.get(EVENT_COLLECTION_ID);
		}
        return m_colectionId;
	}

	public DmEventAttendance getAttendance(String lastName, String email) {
		List<Event_Attendance__c> attendances = getAllAttendances(lastName, email);	
		if(attendances == null || attendances.size() == 0) {
			List<EB_Event_Attendees__c> attendee= m_dataProvider.getAttendee(lastName, email);		
			DmEventAttendance newAttendance = m_dmBuilder.getNewAttendance(attendee, lastName, email);
			return newAttendance;
		}
		DmEventAttendance dmAttendance = m_dmBuilder.buildAttendance(attendances);

		return dmAttendance;
	}

	public DmEventAttendance getAttendance(String attendeeId) {
		List<Event_Attendance__c> attendances = m_dataProvider.getEventAttendee(getCollectionId(), attendeeId);
        if(attendances == null || attendances.size() == 0) {
            EB_Event_Attendees__c attendee = m_dataProvider.getAttendee(attendeeId);            
            DmEventAttendance newAttendance = m_dmBuilder.getNewAttendance(attendee);
			return newAttendance;
		}
		DmEventAttendance attn = m_dmBuilder.buildAttendance(attendances);
		return attn;
	}

    public List<DmEventClass> getAllClasses() {
    	Id eventCollectionId = m_configs.get(EVENT_COLLECTION_ID);
    	List<Eb_Event_Session__c> allSessions = m_dataProvider.getSessionsByEventId(eventCollectionId);
    	
    	return m_dmBuilder.buildClasses(allSessions);
    }

    public List<DmEventClass> getAllClassesByLocation(String locationCode) {
    	Id eventCollectionId = m_configs.get(EVENT_COLLECTION_ID);
    	List<Eb_Event_Session__c> allSessions = m_dataProvider.getSessionsByEventId(eventCollectionId);
    	List<Eb_Event_Session__c> allSessionsByLocation = new List<Eb_Event_Session__c>();
    	Map<String, String> locations = m_dataProvider.getEbtLocations();
    	String lcode = locationCode.tolowerCase();
    	String location = locations == null? '': locations.get(lcode);

    	for(Eb_Event_Session__c s : allSessions) {
    		if(s.Region__c.tolowerCase() == location){
    			allSessionsByLocation.add(s);
    		}
    	}
    	List<DmEventClass> classesByLocation = m_dmBuilder.buildClasses(allSessionsByLocation);
    	
    	return classesByLocation;
    }

    public DmEventInstructor getInstructor(String instructorId) {
    	Event_Instructor__C pm = m_dataProvider.getInstructor((Id)instructorId);
    	return m_dmBuilder.buildInstructor(pm);
    }

    public Map<String, DmDocument> getDocuments(DmEventInstructor dm) {
    	Set<String> documentSetIds = new Set<String>();
    	List<String> documentIds = new List<String>();
    	documentSetIds.add(dm.resumeLink);
    	documentSetIds.add(dm.pictureLink);
    	if(documentSetIds.size() >0) {
    		documentIds.addAll(documentSetIds);
    	}

    	return m_docProvider.getDocuments(documentIds);
    }

    public Map<String, DmDocument> getDocuments(List<DmEventClass> dmClasses) {
    	
    	Set<String> documentSetIds = new Set<String>();
    	List<String> documentIds = new List<String>();

    	for(DmEventClass dmClass : dmClasses){
    		for(DmEventSession dmSession : dmClass.sessions) {
    			for(DmEventInstructor dmInstructor : dmSession.instructors) {
    				documentSetIds.add(dmInstructor.resumeLink);
    				documentSetIds.add(dmInstructor.pictureLink);
    			}
    		}
    	}

    	if(documentSetIds.size() >0) {
    		documentIds.addAll(documentSetIds);
    	}

    	return m_docProvider.getDocuments(documentIds);
    }



	public List<String> getIndustries() {
		List<String> options = new List<String>();
		for(SelectOption o : m_util.ListValuesFromObject(OPTIONS_SOBJECT_TYPE, INDUSTRY_FIELD)) {
			options.add(o.getLabel());
		}

		return options;
	}

	public List<String> getHowDidYouHearOptions() {
		List<String> options = new List<String>();
		for(SelectOption o : m_util.ListValuesFromObject(OPTIONS_SOBJECT_TYPE, HOW_DID_YOU_HEAR_FIELD)) {
			options.add(o.getLabel());
		}
		return options;
	}
    
    public List<String> getYearInSchoolOptions() {
		List<String> options = new List<String>();
		for(SelectOption o : m_util.ListValuesFromObject(OPTIONS_SOBJECT_TYPE, YEAR_IN_SCHOOL_FIELD)) {
			options.add(o.getLabel());
		}
		return options;
	}

	public EventRegistration.AttendeeSm saveAttendee(EventRegistration.formVm vm) {	
		EventRegistration.AttendeeSm asm = m_smBuilder.buildAttendee(vm);
		m_dataProvider.save(new List<SObject>{asm.attendee});

		return asm;
	}

	public EventRegistration.AttendeeSm saveAttendee(EventRegistration.EventAttendeeSm attendeeSm) {	
		EventRegistration.AttendeeSm asm = m_smBuilder.buildAttendee(attendeeSm);
		m_dataProvider.save(new List<SObject>{asm.attendee});

		return asm;
	}

	public EventRegistration.AttendeeSm saveAttendee(String lastName, String email, String recordTypeId ) {
		EventRegistration.AttendeeSm asm = m_smBuilder.buildAttendee(lastName, email, recordTypeId);
		m_dataProvider.save(new List<SObject>{asm.attendee});

		return asm;
	}

	public void saveAttendances(EventRegistration.AttendeeSm asm, EventRegistration.formVm vm) {
		List<Event_Attendance__c> attendanceLookup = getAllAttendances(vm.attendee.lastName, vm.attendee.email);
		EventRegistration.AttendanceSm clsSm = m_smBuilder.buildAttendances(asm.attendee, vm, attendanceLookup);
		m_dataProvider.remove((List<SObject>)clsSm.removes);
		m_dataProvider.save((List<SObject>)clsSm.saves);
	}

	private List<Event_Attendance__c> getAllAttendances(String lastName, String email) {
		Id eventCollectionId = m_configs.get(EVENT_COLLECTION_ID);
		return m_dataProvider.getEventAttendee(eventCollectionId, lastName, email);
	}
}