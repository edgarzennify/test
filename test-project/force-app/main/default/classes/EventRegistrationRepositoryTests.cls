@IsTest
public class EventRegistrationRepositoryTests {
	
	private static final EventRegistrationMock.ofIDataProvider mockDataProvider;
	private static final EventRegistrationMock.ofIDmBuilder mockDmBuilder;
	private static final Mock.ofIUtility mockUtility;
	private static final Mock.ofIConfigurations mockConfiguration;
	private static final EventRegistrationMock.ofISmBuilder mockSmBuilder;
	private static final EventRegistrationMock.ofIDocumentProvider mockDocProvider;
    private static final EventRegistrationRepository sut;
    
    static {
        mockDataProvider = new EventRegistrationMock.ofIDataProvider();
        mockDmBuilder = new EventRegistrationMock.ofIDmBuilder();
        mockUtility = new Mock.ofIUtility();
        mockConfiguration = new Mock.ofIConfigurations();
        mockSmBuilder = new EventRegistrationMock.ofISmBuilder();
        mockDocProvider = new EventRegistrationMock.ofIDocumentProvider();
        sut = new EventRegistrationRepository(mockDataProvider, mockDmBuilder, mockUtility, mockConfiguration, mockSmBuilder, mockDocProvider);
    }

    @IsTest
    static void it_should_call_the_data_provider_to_build_dm_attendance() {
    	String lastName = 'last-name';
    	String email = 'email';
    	Id eventCollectionId = ObjectFactory.getFakeId(Event_Collection__c.SObjectType, '1');
    	mockConfiguration.setup('get',new List<Object>{'EventRegistrationApp'}).returns(eventCollectionId);

    	DmEventAttendance result = sut.getAttendance(lastName, email);
    
    	mockDataProvider.verify('getEventAttendee', new List<Object>{eventCollectionId, lastName, email}, Times.Once);
    }

    @IsTest
    static void it_should_call_the_dm_builder_to_build_dm_attendance_when_new_attendee_registers() {
    	String lastName = 'last-name';
    	String email = 'email';
    	Id eventCollectionId = ObjectFactory.getFakeId(Event_Collection__c.SObjectType, '1');
    	List<Event_Attendance__c> dms = new List<Event_Attendance__c>();
    	mockConfiguration.setup('get',new List<Object>{'EventRegistrationApp'}).returns(eventCollectionId);
    	mockDataProvider.setup('getEventAttendee', new List<Object>{eventCollectionId, lastName, email}).returns(dms);

    	DmEventAttendance result = sut.getAttendance(lastName, email);
    
    	mockDmBuilder.verify('getNewAttendance' , ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
    }

    @IsTest
    static void it_should_call_the_dm_builder_to_build_dm_attendance_when_attendances_exit() {
    	String lastName = 'last-name';
    	String email = 'email';
    	Id eventCollectionId = ObjectFactory.getFakeId(Event_Collection__c.SObjectType, '1');
    	Id attendeeId = ObjectFactory.getFakeId(Eb_Event_Attendees__c.SObjectType, '1');
    	Id sessionId = ObjectFactory.getFakeId(Eb_Event_Session__c.SObjectType, '1');
    	Event_Attendance__c attn = new Event_Attendance__c();
    	attn.Event_Attendee__c = attendeeId;
    	attn.Event_Session__c = sessionId;
    	List<Event_Attendance__c> dms = new List<Event_Attendance__c>{attn};
    	mockConfiguration.setup('get',new List<Object>{'EventRegistrationApp'}).returns(eventCollectionId);
    	mockDataProvider.setup('getEventAttendee', new List<Object>{eventCollectionId, lastName, email}).returns(dms);

    	DmEventAttendance result = sut.getAttendance(lastName, email);
    
    	mockDmBuilder.verify('buildAttendance' , new List<Object>{dms}, Times.Once);
    }

    @IsTest
    static void it_should_call_the_data_provider_to_get_sessions_to_build_classes() {
    	Id eventCollectionId = ObjectFactory.getFakeId(Event_Collection__c.SObjectType, '1');
    	mockConfiguration.setup('get',new List<Object>{'EventRegistrationApp'}).returns(eventCollectionId);

    	List<DmEventClass> result = sut.getAllClasses();

    	mockDataProvider.getSessionsByEventId(eventCollectionId);
    }

    @IsTest
    static void it_should_call_data_provider_to_build_classes_by_location() {
    	String locationCode = 'stl';
    	Eb_Event_Session__c session = new Eb_Event_Session__c();
    	session.Region__c = 'Saint Louis';
    	List<Eb_Event_Session__c> sessions = new List<Eb_Event_Session__c>{session};
    	Id eventCollectionId = ObjectFactory.getFakeId(Event_Collection__c.SObjectType, '1');
    	mockConfiguration.setup('get',new List<Object>{'EventRegistrationApp'}).returns(eventCollectionId);
    	mockDataProvider.setup('getSessionsByEventId', new List<Object>{eventCollectionId}).returns(sessions);

    	List<DmEventClass> result = sut.getAllClassesByLocation(locationCode);

    	mockDataProvider.verify('getEbtLocations', Times.Once);
    }

    @IsTest
    static void it_should_call_the_doc_provider_to_build_documents_from_classes() {
    	DmEventClass dmClass = new DmEventClass();
    	DmEventSession dmSession = new DmEventSession();
    	DmEventInstructor dmInstructor = new DmEventInstructor();
    	dmInstructor.resumeLink = 'qqq1122';
    	dmInstructor.pictureLink = 'asw123';
    	dmSession.instructors = new List<DmEventInstructor>{dmInstructor};
    	dmClass.sessions = new List<DmEventSession>{dmSession};
    	List<DmEventClass> dmClasses = new List<DmEventClass>{dmClass};

    	Map<String, DmDocument> result = sut.getDocuments(dmClasses);

    	mockDocProvider.verify('getDocuments',ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
    	List<Object> arguments = (List<Object>)mockDocProvider.getArgumentsFromCall('getDocuments');
        List<String> documentIds = (List<String>) arguments[0];
        System.assertEquals(2, documentIds.size());
        System.assertEquals('qqq1122', documentIds[0]);
        System.assertEquals('asw123', documentIds[1]);
    }

    @IsTest
    static void it_should_call_the_doc_provider_to_build_documents_for_a_dm_instructor() {      
        DmEventInstructor dmInstructor = new DmEventInstructor();
        dmInstructor.resumeLink = 'qqq1122';
        dmInstructor.pictureLink = 'asw123';
       
        Map<String, DmDocument> result = sut.getDocuments(dmInstructor);

        mockDocProvider.verify('getDocuments',ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
        List<Object> arguments = (List<Object>)mockDocProvider.getArgumentsFromCall('getDocuments');
        List<String> documentIds = (List<String>) arguments[0];
        System.assertEquals(2, documentIds.size());
        System.assertEquals('qqq1122', documentIds[0]);
        System.assertEquals('asw123', documentIds[1]);
    }

    @IsTest
    static void it_should_call_the_util_to_get_industries() {
    	String OPTIONS_SOBJECT_TYPE = 'EB_Event_Attendees__c';
	    String INDUSTRY_FIELD = 'Industry__c';
	    SelectOption option1 = new SelectOption('value-1','label-1');
	    SelectOption option2 = new SelectOption('value-2','label-2');

	    List<SelectOption> options = new List<SelectOption>{option1, option2};
    	mockUtility.setup('ListValuesFromObject', new List<Object>{OPTIONS_SOBJECT_TYPE,INDUSTRY_FIELD}).returns(options);

    	List<String> result =  sut.getIndustries();

    	System.assertEquals(2, result.size());
    	System.assertEquals('label-1', result[0]);
    	System.assertEquals('label-2', result[1]);
    }

    @IsTest
    static void it_should_call_the_utility_to_get_hear_from_options() {
    	String OPTIONS_SOBJECT_TYPE = 'EB_Event_Attendees__c';
    	String HOW_DID_YOU_HEAR_FIELD = 'Heard_From__c';
    	SelectOption option1 = new SelectOption('value-1','label-1');
	    SelectOption option2 = new SelectOption('value-2','label-2');
	    List<SelectOption> options = new List<SelectOption>{option1, option2};
    	mockUtility.setup('ListValuesFromObject', new List<Object>{OPTIONS_SOBJECT_TYPE, HOW_DID_YOU_HEAR_FIELD}).returns(options);

    	List<String> result = sut.getHowDidYouHearOptions();

    	System.assertEquals(2, result.size());
    	System.assertEquals('label-1', result[0]);
    	System.assertEquals('label-2', result[1]);
    }

    @IsTest
    static void it_should_call_sm_builder_to_save_attendee() {
    	String lastName = 'last-name';
    	String email = 'email';
    	EventRegistration.formVm vm = new EventRegistration.formVm();
    	vm.attendee = new EventRegistration.EventAttendee();
    	vm.attendee.lastName = lastName;
    	vm.attendee.email = email;
    	EventRegistration.AttendeeSm asm = new EventRegistration.AttendeeSm();
    	asm.attendee = new EB_Event_Attendees__c();
    	asm.attendee.Email_Address__c = email;
    	asm.attendee.Attendee_Last_Name__c = lastName;
    	mockSmBuilder.setup('buildAttendee', new List<Object>{vm}).returns(asm);

    	EventRegistration.AttendeeSm result = sut.saveAttendee(vm);

    	mockDataProvider.verify('save', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
    	List<Object> arguments = (List<Object>)mockDataProvider.getArgumentsFromCall('save');  
        List<SObject> attendees = (List<SObject>) arguments[0];
        EB_Event_Attendees__c attendee = (EB_Event_Attendees__c)attendees[0];
        System.assertEquals(email , attendee.Email_Address__c);
        System.assertEquals(lastName, attendee.Attendee_Last_Name__c);
    }

    @IsTest
    static void it_should_call_sm_builder_to_save_attendee_from_eventattendeesm_provided_bycontroller() {
        String lastName = 'last-name';
        String email = 'email';
        EventRegistration.EventAttendeeSm EventAttendeeSm = new EventRegistration.EventAttendeeSm();
        EventAttendeeSm.lastName = lastName;
        EventAttendeeSm.email = email;
        EventRegistration.AttendeeSm asm = new EventRegistration.AttendeeSm();
        asm.attendee = new EB_Event_Attendees__c();
        asm.attendee.Email_Address__c = email;
        asm.attendee.Attendee_Last_Name__c = lastName;
        mockSmBuilder.setup('buildAttendee', new List<Object>{EventAttendeeSm}).returns(asm);

        EventRegistration.AttendeeSm result = sut.saveAttendee(EventAttendeeSm);

        mockDataProvider.verify('save', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
        List<Object> arguments = (List<Object>)mockDataProvider.getArgumentsFromCall('save');  
        List<SObject> attendees = (List<SObject>) arguments[0];
        EB_Event_Attendees__c attendee = (EB_Event_Attendees__c)attendees[0];
        System.assertEquals(email , attendee.Email_Address__c);
        System.assertEquals(lastName, attendee.Attendee_Last_Name__c);
    }

    @IsTest
    static void it_should_call_the_sm_builder_to_build_attendances() {
    	String lastName = 'last-name';
    	String email = 'email';
    	EventRegistration.formVm vm = new EventRegistration.formVm();
    	vm.attendee = new EventRegistration.EventAttendee();
    	vm.attendee.lastName = lastName;
    	vm.attendee.email = email;
    	EventRegistration.AttendeeSm asm = new EventRegistration.AttendeeSm();
    	asm.attendee = new EB_Event_Attendees__c();
    	asm.attendee.Email_Address__c = email;
    	asm.attendee.Attendee_Last_Name__c = lastName;
    	Id configId = ObjectFactory.getFakeId(Event_Collection__c.SObjectType, '0');
    	Event_Attendance__c attn = new Event_Attendance__c();
    	List<Event_Attendance__c> attns = new List<Event_Attendance__c>{attn};
    	EventRegistration.AttendanceSm sm = new EventRegistration.AttendanceSm();
    	sm.removes = new List<Event_Attendance__c>();
    	sm.saves = new List<Event_Attendance__c>();
    	mockConfiguration.setup('get', new List<Object>{'EventRegistrationApp'}).returns(configId);
		mockDataProvider.setup('getEventAttendee', new List<Object>{configId,lastName, email}).returns(attns);
		mocksmBuilder.setup('buildAttendances', new List<Object>{asm.attendee, vm, attns}).returns(sm);

    	sut.saveAttendances(asm, vm);

    	mocksmBuilder.verify('buildAttendances', new List<Object>{asm.attendee, vm, attns}, Times.Once);
    }

    @IsTest
    static void it_should_call_the_sm_builder_to_save_an_attendee() {
    	String lastName = 'last-name';
    	String email = 'email';
        String recordTypeId = 'recordtype-1';

    	EventRegistration.AttendeeSm sm = new EventRegistration.AttendeeSm();
    	sm.attendee = new EB_Event_Attendees__c();
    	mocksmBuilder.setup('buildAttendee', new List<Object>{lastName, email, recordTypeId}).returns(sm);

    	sut.saveAttendee(lastName, email, recordTypeId);

    	mockSmBuilder.verify('buildAttendee', new List<Object>{lastName, email, recordTypeId}, Times.Once);
    }

    @IsTest
    static void it_should_call_the_dataprovider_to_get_instructor_pm() {
		String instructorId = ObjectFactory.getFakeId(Event_Instructor__c.SObjectType, '1');

		DmEventInstructor result = sut.getInstructor(instructorId);

		mockDataProvider.verify('getInstructor', new List<Object>{(Id)instructorId}, Times.Once);
    }

    @IsTest
    static void it_should_call_the_dm_build_to_build_a_instructor_dm() {
    	String instructorId = ObjectFactory.getFakeId(Event_Instructor__c.SObjectType, '1');
    	Event_Instructor__c instructorPm = new Event_Instructor__c();
    	instructorPm.id = instructorId; 
    	mockDataProvider.setup('getInstructor', new List<Object>{(Id)instructorId}).returns(instructorPm);

		DmEventInstructor result = sut.getInstructor(instructorId);

		mockDmBuilder.verify('buildInstructor', new List<Object>{instructorPm}, Times.Once);
    }
}