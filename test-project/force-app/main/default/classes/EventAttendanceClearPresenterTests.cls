@IsTest
private class EventAttendanceClearPresenterTests {
    private static final EventAttendanceClear.IPresenter sut;
    private static final MockOfEventAttendanceClearDataProvider mockDataProvider;
    private static final MockOfEventAttendanceClearHelper mockHelper;
    private static final Id seshId;

    static {
        mockDataProvider = new MockOfEventAttendanceClearDataProvider();
        mockHelper = new MockOfEventAttendanceClearHelper();
        seshId = ObjectFactory.getFakeId(EB_Event_Session__c.SObjectType, '1');
        sut = new EventAttendanceClearPresenter(mockDataProvider, mockHelper, seshId);
    }
    
    @IsTest
    static void it_should_call_methods_to_clear_attendances_and_return_a_vm_when_clearAttendance_is_called() {
        EB_Event_Session__c sesh = new EB_Event_Session__c();
        sesh.Id = seshId;
        Event_Attendance__c ea = new Event_Attendance__c();
        ea.Event_Session__c = sesh.Id;
        ea.Record_Attendance__c = true;
        List<Event_Attendance__c> relatedAttendances = new List<Event_Attendance__c>{ea};
        Event_Attendance__c handledRecord = new Event_Attendance__c();
        handledRecord.Event_Session__c = seshId;
        handledRecord.Record_Attendance__c = false;
        List<Event_Attendance__c> handledAttendances = new List<Event_Attendance__c>{handledRecord};
        
        mockDataProvider.setup('getAttendancesFromSessionId', new List<Object>{sesh.Id}).returns(relatedAttendances);
        mockHelper.setup('clearAttendance', new List<Object>{relatedAttendances}).returns(handledAttendances);

        EventAttendanceClear.clearerVm result = sut.clearAttendance();
        
        mockDataProvider.verify('save', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
        system.assertEquals(false, result.renderOkButton);
        system.assertEquals(false, result.renderVerify);
        system.assertEquals(true, result.renderSuccess);
        system.assertEquals(true, result.renderCloseButton);
    }
    @IsTest
    static void it_should_return_a_constructed_vm_when_buildInitialVm_is_called() {
        EventAttendanceClear.clearerVm result = sut.buildInitialVm();
        system.assertEquals(true, result.renderVerify);
        system.assertEquals(true, result.renderOkButton);
        system.assertEquals(true, result.renderCloseButton);
        system.assertEquals(false, result.renderSuccess);
    }

    @IsTest
    static void code_coverage_for_constructor() {
       EventAttendanceClearPresenter eacp = new EventAttendanceClearPresenter(seshId);
    }
    
    private class MockOfEventAttendanceClearDataProvider extends ApexMoq implements EventAttendanceClear.IEventAttendanceClearDataProvider {
        public List<Event_Attendance__c> getAttendancesFromSessionId(Id seshId){
            return (List<Event_Attendance__c>)handleMethodInvocation('getAttendancesFromSessionId', new List<Object>{seshId});
        }
        public void save(List<SObject> objs){
            handleMethodInvocation('save', new List<Object>{objs});
        }
    }

    private class MockOfEventAttendanceClearHelper extends ApexMoq implements EventAttendanceClear.IEventAttendanceClearHelper{
        public List<Event_Attendance__c> clearAttendance(List<Event_Attendance__c> attendancesToClear){
            return (List<Event_Attendance__c>)handleMethodInvocation('clearAttendance', new List<Object>{attendancesToClear});
        }
    }
}