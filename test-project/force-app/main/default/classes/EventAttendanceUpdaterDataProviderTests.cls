@isTest
public class EventAttendanceUpdaterDataProviderTests {
	private static final EventAttendanceUpdater.IEventAttendanceUpdaterDataProvider sut;
    static{
        sut = new EventAttendanceUpdaterDataProvider();
    }
    private static testMethod void it_should_return_a_list_of_event_attendances_when_getAttendanceRecordsBySessionId_is_called_with_an_event_session_id(){ 
		Eb_Event_Session__c sesh = new Eb_Event_Session__c();
        insert sesh;
        EB_Event_Attendees__c attendee = new EB_Event_Attendees__c();
        attendee.Email_Address__c = 'cdavis@enterprisebank.com';
        insert attendee;
        Event_Attendance__c ea = new Event_Attendance__c();
        ea.Event_Attendee__r   = attendee;
        ea.Event_Session__c    = sesh.Id;
        insert ea;
        List<Event_Attendance__c> results = sut.getAttendanceRecordsBySessionId(sesh.Id);
        Object fieldInResult = results[0].Id;
        fieldInResult = results[0].Event_Attendee__r.Email_Address__c;
    }
    private static testMethod void it_should_return_a_list_of_event_attendees_when_getAlreadyExistingEBAttendees_is_called_with_a_list_of_strings(){
        EB_Event_Attendees__c attendee = new EB_Event_Attendees__c();
        attendee.Email_Address__c = 'cdavis@enterprisebank.com';
        insert attendee;
        Set<String> emailsInFileNotInRegistrants = new Set<String>{attendee.Email_Address__c};
        List<EB_Event_Attendees__c> results = sut.getAttendeesByEmailSet(emailsInFileNotInRegistrants);
        Object fieldInResult = results[0].Id;
        	   fieldInResult = results[0].Email_Address__c;
        system.assertEquals(attendee.Email_Address__c, results[0].Email_Address__c);
    }
    private static testMethod void it_should_return_a_list_of_event_attendees_when_getCreatedAttendees_is_called_with_a_list_of_strings(){
        EB_Event_Attendees__c attendee = new EB_Event_Attendees__c();
        attendee.Email_Address__c = 'cdavis@enterprisebank.com';
        insert attendee;
        Set<String> emailsInFileNotInRegistrants = new Set<String>{attendee.Email_Address__c};
        List<EB_Event_Attendees__c> results = sut.getCreatedAttendees(emailsInFileNotInRegistrants);
        Object fieldInResult = results[0].Id;
        fieldInResult = results[0].Email_Address__c;
        fieldInResult = results[0].Attendee__c;
        system.assertEquals(attendee.Email_Address__c, results[0].Email_Address__c);
    }
    private static testMethod void it_should_return_a_list_of_event_attendances_when_getAttendancesByEmailList_is_called_with_a_set_of_email_addresses(){
		Eb_Event_Session__c sesh = new Eb_Event_Session__c();
        insert sesh;
        EB_Event_Attendees__c attendee = new EB_Event_Attendees__c();
        attendee.Email_Address__c = 'cdavis@enterprisebank.com';
        insert attendee;
        Event_Attendance__c ea = new Event_Attendance__c();
        ea.Event_Attendee__c   = attendee.Id;
        ea.Event_Session__c    = sesh.Id;
        insert ea;
        Set<String> emailsFromFile        = new Set<String>{attendee.Email_Address__c};
        List<Event_Attendance__c> results = sut.getAttendancesByEmailList(emailsFromFile, sesh.Id);
        Object fieldInResult = results[0].Id;
        	   fieldInResult = results[0].Event_Attendee__r.Email_Address__c;
        	   fieldInResult = results[0].Event_Session__r.Event_Name__c;
        	   fieldInResult = results[0].Record_Attendance__c;
    }
}