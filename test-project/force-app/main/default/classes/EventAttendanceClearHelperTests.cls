@isTest
public class EventAttendanceClearHelperTests {
    private static final EventAttendanceClear.IEventAttendanceClearHelper sut;
    static{
        sut = new EventAttendanceClearHelper();
    }
    private static testMethod void it_should_return_a_list_of_updated_attendances_when_clearAttendance_is_called_with_a_list_of_attendances(){
        Event_Attendance__c ea1 = new Event_Attendance__c();
        ea1.Record_Attendance__c = true;
        ea1.Id = ObjectFactory.getFakeId(Event_Attendance__c.SObjectType, '1');
        Event_Attendance__c ea2 = new Event_Attendance__c();
        ea2.Record_Attendance__c = false;
        ea2.Id = ObjectFactory.getFakeId(Event_Attendance__c.SObjectType, '1');
        List<Event_Attendance__c> attendances = new List<Event_Attendance__c>{ea1, ea2};
        List<Event_Attendance__c> results = sut.clearAttendance(attendances);
        system.assertEquals(1, results.size());
        system.assertEquals(true, results[0].Id == ea1.Id);
        system.assertEquals(false, results[0].Record_Attendance__c);
    }

}