@isTest
public class EventAttendanceUpdaterHelperTests {
	private static final EventAttendanceUpdater.IEventAttendanceUpdaterHelper sut;
    static{
        sut = new EventAttendanceUpdaterHelper();
    }
    private static testMethod void it_should_return_a_set_of_email_addresses_when_getEmailAddressesFromFile_is_called_with_file_line_items(){
        String fileString1 = 'Attendee Number,First Name,Last Name,Email Address \n';
        String fileString2 = '1,Lloyd,Christmas,lloyd@muttcutts.com';
        List<String> fileItems = new List<String>{fileString1, fileString2};
        Set<String> expectedResult = new Set<String>{'lloyd@muttcutts.com'};
        Set<String> results = sut.getEmailAddressesFromFile(fileItems); 
        system.assertEquals(expectedResult, results);
    }
    private static testMethod void it_should_return_a_set_of_attendee_email_addresses_when_getEmailAddressesFromRegistrants_is_called_with_a_list_of_attendance(){
        EB_Event_Attendees__c attendee1 = new EB_Event_Attendees__c();
        attendee1.Email_Address__c = 'lloyd@muttcutts.com';
        EB_Event_Attendees__c attendee2 = new EB_Event_Attendees__c();
        attendee2.Email_Address__c = 't_melon@grandlakes.edu';
        Event_Attendance__c attendance1 = new Event_Attendance__c();
        attendance1.Event_Attendee__r = attendee1;
        Event_Attendance__c attendance2 = new Event_Attendance__c();
        attendance2.Event_Attendee__r = attendee2;
        List<Event_Attendance__c> attendanceList = new List<Event_Attendance__c>{attendance1, attendance2};
        Set<String> expectedResults = new Set<String>{attendee1.Email_Address__c, attendee2.Email_Address__c};
        Set<String> results = sut.getEmailAddressesFromRegistrants(attendanceList);
        system.assertEquals(expectedResults, results);
    }
    private static testMethod void it_should_return_a_file_lineitem_if_a_email_address_is_missing_from_the_registrants_list_when_getParticipantsFromFileNotInRegistrants_is_called(){
        String fileString1 = 'Attendee Number,First Name,Last Name,Email Address \n';
        String fileString2 = '1,Lloyd,Christmas,lloyd@muttcutts.com \n';
        String fileString3 = '2,Thornton,Melon,t_melon@grandlakes.edu';
        List<String> fileItems = new List<String>{fileString1, fileString2, fileString3};
        Set<String> emailAddressesFromRegistrants = new Set<String>{'lloyd@muttcutts.com'};
        List<String> results = sut.getParticipantsFromFileNotInRegistrants(fileItems, emailAddressesFromRegistrants);
        system.assertEquals(fileString3, results[0]);
    }
    private static testMethod void it_should_return_a_set_of_emails_extracted_from_the_file_for_participants_who_didnt_register_when_getEmailsFromFileNotInRegistrants_is_called(){
        String fileString1 = 'Attendee Number,First Name,Last Name,Email Address \n';
        String fileString2 = '1,Lloyd,Christmas,lloyd@muttcutts.com \n';
        String fileString3 = '2,Thornton,Melon,t_melon@grandlakes.edu';
        List<String> fileItems = new List<String>{fileString1, fileString2, fileString3};
        Set<String> emailAddressesFromRegistrants = new Set<String>{'lloyd@muttcutts.com'};
        Set<String> expectedResults = new Set<String>{'t_melon@grandlakes.edu'};
        Set<String> results = sut.getEmailsFromFileNotInRegistrants(fileItems, emailAddressesFromRegistrants);
        system.assertEquals(expectedResults, results);
    }
    private static testMethod void it_should_return_a_list_of_attendees_constructed_from_file_items_when_getAttendeesToCreate_is_called_with_file_items(){
        String fileString1 = '1,Lloyd,Christmas,lloyd@muttcutts.com';
        String fileString2 = '2,Thornton,Melon,t_melon@grandlakes.edu';
        List<String> lineItems = new List<String>{fileString1, fileString2};
        List<EB_Event_Attendees__c> results = sut.getAttendeesToCreate(lineItems);
        system.assertEquals('Thornton Melon', results[1].Attendee__c);
        system.assertEquals('lloyd@muttcutts.com', results[0].Email_Address__c);
    }
    private static testMethod void it_should_return_a_set_of_emails_not_found_in_unregisteredAttendees_when_getMissingAttendeeEmails_is_called_with_unregistered_attendees_and_unregistered_participant_emails(){
        EB_Event_Attendees__c attendee = new EB_Event_Attendees__c();
        attendee.Email_Address__c = 'lloyd@muttcutts.com';
        String missingAttendeeEmail = 't_melon@grandlakes.edu';
        List<EB_Event_Attendees__c> unregisteredExistingAttendees = new List<EB_Event_Attendees__c>{attendee};
        Set<String> emailsInFileNotInRegistrants = new Set<String>{attendee.Email_Address__c, missingAttendeeEmail};
        Set<String> expectedResults = new Set<String>{missingAttendeeEmail};
        Set<String> results = sut.getMissingAttendeeEmails(unregisteredExistingAttendees, emailsInFileNotInRegistrants);
        system.assertEquals(expectedResults, results);
    }
    private static testMethod void it_should_get_the_missing_line_item(){
        String fileString1 = '1,Lloyd,Christmas,lloyd@muttcutts.com';
        String fileString2 = '2,Thornton,Melon,t_melon@grandlakes.edu';
        Set<String> missingAttendeeEmails = new Set<String>{'t_melon@grandlakes.edu'};
        List<String> lineItemsInFileNotInRegistrants = new List<String>{fileString1, fileString2};
        
        List<String> results = sut.getMissingLineItems(missingAttendeeEmails, lineItemsInFileNotInRegistrants);
        system.assertEquals(fileString2, results[0]);
    }
    private static testMethod void it_should_return_a_list_of_attendances_when_getAttendancesToCreate_is_called(){
        EB_Event_Attendees__c attendee1 = new EB_Event_Attendees__c();
        attendee1.Email_Address__c = 'lloyd@muttcutts.com';
        attendee1.Id = ObjectFactory.getFakeId(EB_Event_Attendees__c.SObjectType, '1');
        EB_Event_Attendees__c attendee2 = new EB_Event_Attendees__c();
        attendee2.Email_Address__c = 't_melon@grandlakes.edu';
        attendee2.Id = ObjectFactory.getFakeId(EB_Event_Attendees__c.SObjectType, '2');
        List<EB_Event_Attendees__c> createdAttendees = new List<EB_Event_Attendees__c>{attendee1, attendee2};
        Id seshId = ObjectFactory.getFakeId(EB_Event_Session__c.SObjectType, '1');
        List<Event_Attendance__c> results = sut.getAttendancesToCreate(createdAttendees, seshId);
        system.assertEquals(attendee1.Id, results[0].Event_Attendee__c);
        system.assertEquals(attendee2.Id, results[1].Event_Attendee__c);
        system.assertEquals(seshId, results[1].Event_Session__c);
    }
    private static testMethod void it_should_return_a_set_of_email_addresses_when_getAttendanceToCreateEmails_is_called_with_a_list_of_eb_event_attendees(){
        EB_Event_Attendees__c attendee1 = new EB_Event_Attendees__c();
        attendee1.Email_Address__c = 'lloyd@muttcutts.com';
        EB_Event_Attendees__c attendee2 = new EB_Event_Attendees__c();
        attendee2.Email_Address__c = 't_melon@grandlakes.edu';
        Set<String> expectedResults = new Set<String>{attendee1.Email_Address__c, attendee2.Email_Address__c};
        List<EB_Event_Attendees__c> createdAttendees = new List<EB_Event_Attendees__c>{attendee1, attendee2};
        Set<String> results = sut.getAttendanceToCreateEmails(createdAttendees);
        system.assertEquals(expectedResults, results);
    }
    private static testMethod void it_should_deduplicate_a_list_of_attendees_based_on_their_email_address(){
        EB_Event_Attendees__c attendee1 = new EB_Event_Attendees__c();
        attendee1.Email_Address__c = 'lloyd@muttcutts.com';
        EB_Event_Attendees__c attendee2 = new EB_Event_Attendees__c();
        attendee2.Email_Address__c = 't_melon@grandlakes.edu';
        EB_Event_Attendees__c attendee3 = new EB_Event_Attendees__c();
        attendee3.Email_Address__c = 't_melon@grandlakes.edu';
        List<Eb_Event_Attendees__c> attendeesToDeDupe = new List<Eb_Event_Attendees__c>{attendee1, attendee2, attendee3};
        List<Eb_Event_Attendees__c> results = sut.deDupeAttendeesList(attendeesToDeDupe);
        system.assertEquals(2, results.size());
    }
}