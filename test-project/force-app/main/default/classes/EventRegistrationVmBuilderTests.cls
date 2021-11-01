@IsTest
private class EventRegistrationVmBuilderTests {
    
	private static final EventRegistrationMock.ofIVmBuilderHelper mockHelper;
    private static final EventRegistrationVmBuilder sut;
    
    static {
        mockHelper = new EventRegistrationMock.ofIVmBuilderHelper();
        sut = new EventRegistrationVmBuilder(mockHelper);
    }

    @IsTest
    static void it_should_call_the_helper_to_build_attendee() {
    	String lastName = 'last-name';
    	String email = 'email';
    	EventRegistration.VmBuilderParams params = buildTestVmParams(lastName, email);
    	EventRegistration.EventClassVm classVm = new EventRegistration.EventClassVm();
    	classVm.selected = true;
    	classVm.SelectedClass = new EventRegistration.EventClass();
    	mockHelper.setup('buildSession', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(classVm);

    	EventRegistration.FormVm result =  sut.build(params);

    	mockHelper.verify('buildAttendee', new List<Object>{params.attendance.attendee, params.lastName, params.email}, Times.Once);
    }

    @IsTest
    static void it_should_call_the_helper_to_build_industries() {
    	String lastName = 'last-name';
    	String email = 'email';
    	EventRegistration.VmBuilderParams params = buildTestVmParams(lastName, email);
    	EventRegistration.EventClassVm classVm = new EventRegistration.EventClassVm();
    	classVm.selected = true;
    	classVm.SelectedClass = new EventRegistration.EventClass();
    	mockHelper.setup('buildSession', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(classVm);

    	EventRegistration.FormVm result =  sut.build(params);

    	mockHelper.verify('buildIndustries', new List<Object>{params.industries}, Times.Once);
    }

    @IsTest
    static void it_should_call_the_picklist_builder_to_build_awareness() {
    	String lastName = 'last-name';
    	String email = 'email';
    	EventRegistration.VmBuilderParams params = buildTestVmParams(lastName, email);
    	EventRegistration.EventClassVm classVm = new EventRegistration.EventClassVm();
    	classVm.selected = true;
    	classVm.SelectedClass = new EventRegistration.EventClass();
    	mockHelper.setup('buildSession', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(classVm);

    	EventRegistration.FormVm result =  sut.build(params);

    	mockHelper.verify('buildPickList', new List<Object>{params.ebtAwareness});
    }

    @IsTest
    static void it_should_build_classes() {
    	String lastName = 'last-name';
    	String email = 'email';
    	EventRegistration.VmBuilderParams params = buildTestVmParams(lastName, email);
    	EventRegistration.EventClassVm classVm = new EventRegistration.EventClassVm();
    	classVm.selected = true;
    	classVm.SelectedClass = new EventRegistration.EventClass();
    	classVm.SelectedClass.Category = 'Finance';
    	mockHelper.setup('buildSession', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(classVm);

    	EventRegistration.FormVm result =  sut.build(params);

    	System.assertEquals(1 , result.classes.size());
    	System.assertEquals('Finance' , result.classes[0].SelectedClass.Category);
    }

    @IsTest
    static void it_should_build_classes_by_category() {
    	String lastName = 'last-name';
    	String email = 'email';
    	EventRegistration.VmBuilderParams params = buildTestVmParams(lastName, email);
    	EventRegistration.EventClassVm classVm1 = new EventRegistration.EventClassVm();
    	classVm1.selected = true;
    	classVm1.SelectedClass = new EventRegistration.EventClass();
    	classVm1.SelectedClass.Category = 'Finance';

    	EventRegistration.EventClassVm classVm2 = new EventRegistration.EventClassVm();
    	classVm2.selected = true;
    	classVm2.SelectedClass = new EventRegistration.EventClass();
    	classVm2.SelectedClass.Category = 'not-Finance';
    	mockHelper.setupSequence('buildSession', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(classVm1).returns(classVm2);

    	EventRegistration.FormVm result =  sut.build(params);

    	System.assertEquals(1 , result.ClassesGroupedByCategory[0].classes.size());
    	System.assertEquals(2 , result.ClassesGroupedByCategory.size());
    	System.assertEquals('Finance' , result.ClassesGroupedByCategory[0].classes[0].selectedClass.category);
    }

    private static EventRegistration.VmBuilderParams buildTestVmParams(String lastName, String email) {
    	Blob b;
    	String doc1Id = 'doc1';
    	DmDocument doc1Dm = new DmDocument();
    	doc1Dm.body = b;
    	EventRegistration.VmBuilderParams params = new EventRegistration.VmBuilderParams();
    	params.LastName = lastName;
    	params.email = email;
    	DmEventInstructor instructor1 = new DmEventInstructor();
    	instructor1.picturelink = doc1Id;
    	DmEventSession session1 = new DmEventSession();
    	session1.instructors = new List<DmEventInstructor>{instructor1};
    	DmEventClass class1 = new DmEventClass();
    	class1.Category = 'Finance';
    	class1.sessions = new List<DmEventSession>{session1};
    	params.allClasses = new List<DmEventClass>{class1};
    	params.instructorDocuments = new Map<String, DmDocument>();
    	params.instructorDocuments.put(doc1Id, doc1Dm);
    	DmEventAttendance attendance = new DmEventAttendance();
    	attendance.attendee = new DmEventAttendee();
    	attendance.attendee.lastName = lastName;
    	attendance.attendee.email = email; 
    	params.attendance = attendance;
    	params.attendance.classes = new List<DmEventClass>{class1};
    	params.industries = new List<string>{'industry-1', 'industry-2'};
    	params.ebtAwareness = new List<String>{'awe1'}; 
    	return params;
    }

    @IsTest
    static void it_should_call_the_vm_builder_helper_to_build_an_instructor() {
    	String docId = 'test-doc-id';
    	DmEventInstructor dm = new DmEventInstructor();
    	dm.id = 'test-id';
    	dm.name = 'test-name';
    	DmDocument doc = new DmDocument();
    	doc.id = docId;
    	doc.name = 'test-doc-name';
    	EventRegistration.EventInstructor instructorVm = new EventRegistration.EventInstructor();
    	instructorVm.id = dm.id;
    	instructorVm.name = dm.name;
    	Map<String, DmDocument> docs = new Map<String, DmDocument>{docId => doc};
    	mockHelper.setup('buildInstructor', new List<Object>{dm, docs}).returns(instructorVm);

    	EventRegistration.EventInstructor result = sut.buildInstructorVm( dm, docs);

    	mockHelper.verify('buildInstructor', new List<Object>{dm, docs}, Times.Once);
    	System.assertEquals(instructorVm.id, result.id);
    	System.assertEquals(instructorVm.name, result.name);
    }

    @IsTest
    static void it_should_call_the_vm_builder_helper_to_build_an_instructor_vm() {
    	String docId = 'doc-id';
    	DmEventInstructor dm = new DmEventInstructor();
    	DmDocument doc = new DmDocument();
    	doc.id = docId;
    	Map<String, DmDocument> docs = new Map<String, DmDocument>{doc.id => doc};

    	EventRegistration.EventInstructor result = sut.buildInstructorVm(dm, docs);

    	mockHelper.verify('buildInstructor', new List<Object>{dm, docs});
    }
}