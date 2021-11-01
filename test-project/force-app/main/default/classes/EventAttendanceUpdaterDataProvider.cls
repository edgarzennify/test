public class EventAttendanceUpdaterDataProvider extends DataProvider implements EventAttendanceUpdater.IEventAttendanceUpdaterDataProvider{
    public List<Event_Attendance__c> getAttendanceRecordsBySessionId(Id seshId){
        return [SELECT 
                	Id
                	,Event_Attendee__r.Email_Address__c
                	,Event_Session__r.Event_Name__c
                FROM Event_Attendance__c 
                WHERE Event_Session__c =: seshId];
    }
    public List<Eb_Event_Attendees__c> getAttendeesByEmailSet(Set<String> emailSet){
        return [SELECT 
                	Id
                	,Email_Address__c 
                FROM Eb_Event_Attendees__c 
                WHERE Email_Address__c IN: emailSet];
    }
    public List<Event_Attendance__c> getAttendancesByEmailList(Set<String> emailsFromFile, Id seshId){
        return [SELECT 
            	Id
                ,Record_Attendance__c
                ,Event_Attendee__r.Email_Address__c
                ,Event_Session__r.Event_Name__c 
            FROM Event_Attendance__c 
            WHERE Event_Attendee__r.Email_Address__c IN: emailsFromFile AND Event_Session__c =: seshId];
    }
    public List<Eb_Event_Attendees__c> getCreatedAttendees(Set<String> emailSet){
        return [SELECT 
                	Id
                	,Email_Address__c 
                	,Attendee__c
                FROM Eb_Event_Attendees__c 
                WHERE Email_Address__c IN: emailSet];
    }
}