public class EventAttendanceUpdater {
    public interface IPresenter {
        updaterVM build(Blob fileBody, Id seshId);
    }
    public interface IEventAttendanceUpdaterHelper{
        Set<String> getEmailAddressesFromFile(List<String> fileItems);
        Set<String> getEmailAddressesFromRegistrants(List<Event_Attendance__c> matchingAttendance);
        List<String> getParticipantsFromFileNotInRegistrants(List<String> fileItems, Set<String> emailAddressesFromRegistrants);
        Set<String> getEmailsFromFileNotInRegistrants(List<String> fileItems, Set<String> emailAddressesFromRegistrants);
        List<EB_Event_Attendees__c> getAttendeesToCreate(List<String> lineItemsInFileNotInRegistrants);
        Set<String> getMissingAttendeeEmails(List<EB_Event_Attendees__c> unregisteredExistingAttendees, Set<String> emailsInFileNotInRegistrants);
        List<String> getMissingLineItems(Set<String> missingAttendeeEmails, List<String> lineItemsInFileNotInRegistrants);
        List<Event_Attendance__c> getAttendancesToCreate(List<EB_Event_Attendees__c> createdAttendees, Id seshId);
        Set<String> getAttendanceToCreateEmails(List<EB_Event_Attendees__c> createdAttendees);
        List<EB_Event_Attendees__c> deDupeAttendeesList(List<EB_Event_Attendees__c> attendeesToDeDupe);
    }
    public interface IEventAttendanceUpdaterDataProvider{
        List<Event_Attendance__c> getAttendanceRecordsBySessionId(Id seshId);
        List<Eb_Event_Attendees__c> getAttendeesByEmailSet(Set<String> emailSet);
        void save(List<SObject> objs); 
        List<Event_Attendance__c> getAttendancesByEmailList(Set<String> emailsFromFile, Id seshId);
        List<Eb_Event_Attendees__c> getCreatedAttendees(Set<String> emailSet);
    }
    public class updaterVm{
        public List<EB_Event_Attendees__c> createdAttendees {get;set;}
        public List<Event_Attendance__c> createdAttendanceRecords {get;set;}
        public List<Event_Attendance__c> attendanceRecords {get;set;}
    }
    public static IPresenter constructPresenter(){
        IPresenter presenter = new EventAttendanceUpdaterPresenter(new EventAttendanceUpdaterHelper(), new EventAttendanceUpdaterDataProvider(), new FileDeconstructor());
        return presenter;
    }
}