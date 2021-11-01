@IsTest
public class EventAttendanceUpdaterControllerTests {
	private static final EventAttendanceUpdaterController sut;
    private static final mockOfIPresenter mockPresenter;
    private static final Mock.ofIApexPages mockPageWrapper;

    static {
        mockPresenter = new mockOfIPresenter();
        mockPageWrapper = new Mock.ofIApexPages();
        sut = new EventAttendanceUpdaterController(mockPresenter, mockPageWrapper);
    }

    @IsTest
    static void it_should_code_cover_the_constructor() {
        ApexPages.StandardController sc = new ApexPages.StandardController(new EB_Event_Session__c	());
        EventAttendanceUpdaterController controller = new EventAttendanceUpdaterController(sc);
    }

    @IsTest
    static void it_should_call_build_on_the_presenter_with_a_blob_and_id_when_importFile_is_called() {
        String fileString = 'User Type ,FirstName ,LastName ,Email \n Attendee,Chris,Davis,cdavis@enterprisebank.com';
        Blob fileBody = Blob.valueOf(fileString);
        Id seshId = ObjectFactory.getFakeId(Eb_Event_Session__c.SObjectType, '1');
        Map<String,String> wrapperMap = new Map<String,String>();
        wrapperMap.put('Id', seshId);
        sut.fileBody = fileBody;
        mockPageWrapper.setup('getParameters').returns(wrapperMap);
        sut.importFile();
        mockPresenter.verify('build',new List<Object>{fileBody, seshId}, Times.Once);
    }    
    
    private class mockOfIPresenter extends ApexMoq implements EventAttendanceUpdater.IPresenter {
        public EventAttendanceUpdater.updaterVm build(Blob fileBody, Id seshId){
            return (EventAttendanceUpdater.updaterVm)handleMethodInvocation('build', new List<Object>{fileBody, seshId});
        }
    }
}