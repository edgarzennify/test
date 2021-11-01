@IsTest
private class EventRegistrationVmBuilderHelperTests {
    
    private static final Mock.ofIEncodingUtil mockEncodingUtil;
    private static final EventRegistrationVmBuilderHelper sut;
    
    static {
        mockEncodingUtil = new Mock.ofIEncodingUtil();
        sut = new EventRegistrationVmBuilderHelper(mockEncodingUtil);
    }

    @IsTest
    static void it_should_not_call_the_encoding_util_when_building_instructors() {
        String docId = 'doc-id';
        String instructorName = 'instructor-name';
        Blob b;
        DmEventInstructor instructor = new DmEventInstructor();
        DmDocument dm = new DmDocument();
        dm.body = b;
        instructor.pictureLink = docId;
        instructor.name = instructorName;
        List<DmEventInstructor> instructors = new List<DmEventInstructor>{instructor};
        Map<String, DmDocument> docs = new Map<String, DmDocument>{docId => dm};
        
        List<EventRegistration.EventInstructor> result = sut.buildInstructors(instructors, docs);

        mockEncodingUtil.verify('toBase64', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Never);
        System.assertEquals(instructorName, result[0].name);
    }

    @IsTest
    static void it_should_call_the_encoding_util_when_building_instructor() {
        String docId = 'doc-id';
        String instructorName = 'instructor-name';
        Blob b;
        DmEventInstructor instructor = new DmEventInstructor();
        DmDocument dm = new DmDocument();
        dm.body = b;
        instructor.pictureLink = docId;
        instructor.name = instructorName;
        Map<String, DmDocument> docs = new Map<String, DmDocument>{docId => dm};
        
        EventRegistration.EventInstructor result = sut.buildInstructor(instructor, docs);

        mockEncodingUtil.verify('toBase64', new List<Object>{b}, Times.Once);
        System.assertEquals(instructorName, result.name);
    }

    @IsTest
    static void it_should_build_vm_industries_when_dm_is_provided() {
        List<String>  industries = new List<string>{'industry-1', 'industry-2'};
        
        List<EventRegistration.PickList> result =  sut.buildIndustries(industries);

        System.assertEquals('industry-1', result[0].label);
        System.assertEquals('industry-1', result[0].value);
        System.assertEquals('industry-2', result[1].label);
        System.assertEquals('industry-2', result[1].value);
    }

    @IsTest
    static void it_should_build_an_attendee_when_dm_attendee_is_provided() {
        String lastName = 'last-name';
        String email = 'email';
        DmEventAttendee dm = new DmEventAttendee();

        dm.lastName = lastName;
        dm.email = email;
        dm.recordType = new DmRecordType();
        
        EventRegistration.EventAttendee result =  sut.buildAttendee(dm, lastName, email);

        System.assertEquals(lastName, result.lastName);
        System.assertEquals(email, result.email);
    }

    @IsTest
    static void it_should_build_a_vm_session_when_dm_is_provided() {
        DateTime dt = DateTime.newInstance(2016, 1, 2, 14, 1, 1);
        String docId = 'doc-id';
        String className = 'cls-name';
        DmDocument docDm = new DmDocument();
        DmEventSession session = new DmEventSession();
        session.startDateTime = dt;
        session.endDateTime = dt;
        session.Instructors = new List<DmEventInstructor>();
        session.TimeZone = 'CDT';
        session.WebinarLink = 'www.google.com';
        session.WebinarPassword = 'test2020';
        session.SurveyLink = 'www.bing.com';
        DmEventClass cls = new DmEventClass();
        cls.Name = className;
        Boolean isSelected = true;
        Map<String, DmDocument>  docs = new Map<String, DmDocument>{docId => docDm};

        EventRegistration.EventClassVm result =  sut.buildSession( session,  cls, isSelected, docs);
    
        System.assertEquals(true, result.selected);
        System.assertEquals(className, result.SelectedClass.name);
        System.assertEquals('CDT', result.SelectedClass.TimeZone);
        System.assertEquals('www.google.com', result.SelectedClass.WebinarLink);
        System.assertEquals('test2020', result.SelectedClass.WebinarPassword);
        System.assertEquals('www.bing.com', result.SelectedClass.SurveyLink);
        System.assertEquals('20160102T200101Z', result.SelectedClass.SessionStartTimeCalender);
    }

    @IsTest
    static void it_should_build_a_picklist_when_label_and_val_is_provided() {
        String label = 'test-label';
        String val = 'test-val';

        EventRegistration.PickList result =  sut.buildPickList(label, val);

        System.assertEquals(label ,result.label);
        System.assertEquals(val, result.value);
    }

    @IsTest
    static void it_should_build_a_pickplist_when_labels_are_provided() {
        List<String> picklistValues = new List<String>{'label-1', 'label-2'};

        List<EventRegistration.PickList> result = sut.buildPickList(picklistValues);
        
        System.assertEquals(2, result.size());
        System.assertEquals('label-1', result[0].label);
        System.assertEquals('label-1', result[0].value);
        System.assertEquals('label-2', result[1].label);
        System.assertEquals('label-2', result[1].value);
    }
}