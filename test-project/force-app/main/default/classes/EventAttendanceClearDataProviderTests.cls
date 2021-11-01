@isTest
public class EventAttendanceClearDataProviderTests{
    private static final EventAttendanceClear.IEventAttendanceClearDataProvider sut;
    static{
        sut = new EventAttendanceClearDataProvider();
    }
    
    private static testMethod void it_should_return_a_list_of_attendances_when_getAttendancesFromSessionId_is_called_with_an_id(){
        EB_Event_Session__c sesh = new EB_Event_Session__c();
        insert sesh;
        Event_Attendance__c ea = new Event_Attendance__c();
        ea.Event_Session__c = sesh.Id;
        insert ea;
        List<Event_Attendance__c> results = sut.getAttendancesFromSessionId(sesh.Id);
        Object fieldInResult = results[0].Id;
        fieldInResult = results[0].Record_Attendance__c;
    }

}