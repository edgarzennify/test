@IsTest
public class EventAttendanceClearControllerTests {
    private static final EventAttendanceClearController sut;
    private static final mockOfIPresenter mockPresenter;
    private static final Id seshId;
    
    static {
        seshId = ObjectFactory.getFakeId(Event_Attendance__c.SObjectType, '1');
        mockPresenter = new mockOfIPresenter();
        sut = new EventAttendanceClearController(seshId, mockPresenter);
    }
    
    @IsTest
    static void it_should_return_a_record_page_reference_if_close_is_called() {
        PageReference result = sut.close();
        system.assertEquals(true, result.getUrl().contains(seshId));
    }
    @IsTest
    static void it_should_call_the_presenter_to_clear_records_when_clearAttendance_is_called() {
        sut.clearAttendance();
        mockPresenter.verify('clearAttendance', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
    }
    @IsTest
    static void it_should_call_the_presenter_to_build_an_initial_vm_when_init_is_called() {
        sut.init();
        mockPresenter.verify('buildInitialVm', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
    }
    @IsTest
    static void code_coverage_for_constructor() {
        EB_Event_Session__c sesh = new EB_Event_Session__c();
        ApexPages.StandardController sc = new ApexPages.StandardController(sesh);
        EventAttendanceClearController eacc = new EventAttendanceClearController(sc);
    }
    
    private class mockOfIPresenter extends ApexMoq implements EventAttendanceClear.IPresenter {
        public EventAttendanceClear.clearerVm clearAttendance(){
            return (EventAttendanceClear.clearerVm)handleMethodInvocation('clearAttendance');
        }
        public EventAttendanceClear.clearerVm buildInitialVm(){
            return (EventAttendanceClear.clearerVm)handleMethodInvocation('buildInitialVm');
        }
    }
}