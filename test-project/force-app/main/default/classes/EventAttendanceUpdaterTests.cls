@isTest
public class EventAttendanceUpdaterTests {
	private static final EventAttendanceUpdater sut;
    static{
        sut = new EventAttendanceUpdater();
    }
    private static testMethod void it_should_construct_and_return_a_presenter_when_constructPresenter_is_called(){
        EventAttendanceUpdater.IPresenter results = EventAttendanceUpdater.constructPresenter();
        system.assertEquals(true, results != null);
    }
}