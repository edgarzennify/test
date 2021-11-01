public class EventAttendanceClearHelper implements EventAttendanceClear.IEventAttendanceClearHelper{
    
    public List<Event_Attendance__c> clearAttendance(List<Event_Attendance__c> attendancesToClear){
        List<Event_Attendance__c> attendancesToReturn = new List<Event_Attendance__c>();
        for(Event_Attendance__c ea : attendancesToClear){
            if(ea.Record_Attendance__c == true){
                ea.Record_Attendance__c = false;
                attendancesToReturn.add(ea);
            }
        }
        return attendancesToReturn;
    }
}