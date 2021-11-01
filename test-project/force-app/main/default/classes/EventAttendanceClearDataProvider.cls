public class EventAttendanceClearDataProvider extends DataProvider implements EventAttendanceClear.IEventAttendanceClearDataProvider {
    public List<Event_Attendance__c> getAttendancesFromSessionId(Id seshId){
        return [SELECT Id, Record_Attendance__c FROM Event_Attendance__c WHERE Event_Session__c =: seshId];
    }

}