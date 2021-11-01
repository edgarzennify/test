@IsTest
private class EventRegistrationPresenterTests {
	
    private static final EventRegistrationMock.ofIVmBuilder mockVmBuilder;
    private static final EventRegistrationMock.ofIRepository mockRepository;
    private static final EventRegistrationPresenter sut;
    
    static {
        mockVmBuilder = new EventRegistrationMock.ofIVmBuilder();
        mockRepository = new EventRegistrationMock.ofIRepository();
        sut = new EventRegistrationPresenter(mockVmBuilder, mockRepository);
    }

    @IsTest
    static void it_should_call_the_repository_to_get_attendance() {
    	String lastName = 'lname';
    	String email = 'abc@example.com';
        String attendeeId = 'attendee-1';
    	String locationCode = 'stl';
        DmEventAttendance attendance = new DmEventAttendance();
        attendance.attendee = new DmEventAttendee();
        attendance.attendee.lastName = lastName;
        attendance.attendee.email = email;
        EventRegistration.formVm vm = new EventRegistration.formVm();
        vm.attendee = new EventRegistration.EventAttendee();
        vm.attendee.lastName = lastName;
        vm.attendee.email = email;
        mockVmBuilder.setup('build', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(vm);
        mockRepository.setup('getAttendance' ,new List<Object>{attendeeId}).returns(attendance);

    	EventRegistration.FormVm result = sut.getFormVm(attendeeId, locationCode);

    	mockRepository.verify('getAttendance', new List<Object>{attendeeId}, Times.Once);
    }

    @IsTest
    static void it_should_call_the_repository_to_save_attendee() {
        EventRegistration.formVm vm = new EventRegistration.FormVm();
        EventRegistration.EventAttendeeSm EventAttendeeSm = new EventRegistration.EventAttendeeSm();

        sut.save(vm, EventAttendeeSm);

        mockRepository.verify('saveAttendee', new List<Object>{EventAttendeeSm}, Times.Once);
    }

    @IsTest
    static void it_should_call_the_repository_to_save_attendances() {
        EventRegistration.formVm vm = new EventRegistration.FormVm();
        EventRegistration.EventAttendeeSm EventAttendeeSm = new EventRegistration.EventAttendeeSm();
        EventRegistration.attendeeSm asm = new EventRegistration.attendeeSm();
        mockRepository.setup('saveAttendee', new List<Object>{EventAttendeeSm}).returns(asm);

        sut.save(vm,EventAttendeeSm);

        mockRepository.verify('saveAttendances', new List<Object>{asm, vm}, Times.Once);     
    }

    @IsTest
    static void it_should_build_a_instructor_vm() {
        String instructorId = 'test-id';
        DmEventInstructor dm = new DmEventInstructor();
        DmEventClass cls = new DmEventClass();
        List<DmEventClass> classes = new List<DmEventClass>{cls};
        DmDocument doc = new DmDocument();
        doc.id = 'doc-id';
        Map<String, DmDocument> docs = new Map<String, DmDocument>{doc.id => doc};
        mockRepository.setup('getInstructor', new List<Object>{instructorId}).returns(dm);
        mockRepository.setup('getDocuments', new List<Object>{dm}).returns(docs);

        EventRegistration.EventInstructor result = sut.getInstructor(instructorId);
    
        mockVmBuilder.verify('buildInstructorVm', new List<Object>{dm, docs}, Times.Once);
    }
}