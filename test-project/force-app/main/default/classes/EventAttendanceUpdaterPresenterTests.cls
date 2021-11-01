@IsTest
public class EventAttendanceUpdaterPresenterTests {
	private static final EventAttendanceUpdater.IPresenter sut;
    private static final MockOfEventAttendanceUpdaterHelper mockHelper;
    private static final MockOfEventAttendanceUpdaterDataProvider mockDataProvider;
    private static final MockOfFileDeconstructor mockFileDeconstructor;
    
    static {
        mockHelper = new MockOfEventAttendanceUpdaterHelper();
        mockDataProvider = new MockOfEventAttendanceUpdaterDataProvider();
        mockFileDeconstructor = new MockOfFileDeconstructor();
        sut = new EventAttendanceUpdaterPresenter(mockHelper, mockDataProvider, mockFileDeconstructor); 
    }
    
    @IsTest
    static void it_should_not_create_attendees_or_attendances_if_all_participant_emails_are_in_registrant_emails() {
        String fileString = 'User Type ,FirstName ,LastName ,Email \n Attendee,Chris,Davis,cdavis@enterprisebank.com';
        Blob fileBody = Blob.valueOf(fileString);
        List<String> fileItems = fileBody.toString().split('\n');
        Set<String> emailsFromFile = new Set<String>{'cdavis@enterprisebank.com'};
        Id seshId = ObjectFactory.getFakeId(Eb_Event_Session__c.SObjectType, '1');
        EB_Event_Attendees__c attendee = new EB_Event_Attendees__c();
        attendee.Email_Address__c = 'cdavis@enterprisebank.com';
        Event_Attendance__c attendance = new Event_Attendance__c();
        attendance.Event_Session__c = seshId;
        List<Event_Attendance__c> attendances = new List<Event_Attendance__c>{attendance};
        Set<String> emailAddressesFromRegistrants = new Set<String>{attendee.Email_Address__c};

        mockFileDeconstructor.setup('getCsvLineItems', new List<Object>{fileBody}).returns(fileItems);
        mockHelper.setup('getEmailAddressesFromFile', new List<Object>{fileItems}).returns(emailsFromFile);
        mockDataProvider.setup('getAttendanceRecordsBySessionId', new List<Object>{seshId}).returns(attendances);
        mockHelper.setup('getEmailAddressesFromRegistrants', new List<Object>{attendances}).returns(emailAddressesFromRegistrants);
        mockDataProvider.setup('getAttendancesByEmailList', new List<Object>{emailsFromFile, seshId}).returns(attendances);

        EventAttendanceUpdater.updaterVm result = sut.build(fileBody, seshId);

        mockFileDeconstructor.verify('getCsvLineItems', new List<Object>{fileBody}, Times.Once);
        mockDataProvider.verify('save', new List<Object>{attendances}, Times.Once);
        system.assertEquals(seshId, result.attendanceRecords[0].Event_Session__c);
        system.assertEquals(0, result.createdAttendees.size());
        system.assertEquals(0, result.createdAttendanceRecords.size());
    }

    @IsTest
    static void it_should_handle_matching_line_items_without_creating_duplicates() {
        String fileString = 'Attendee Number ,FirstName ,LastName ,Email \n Attendee,Chris,Davis,cdavis@enterprisebank.com \n Attendee,Chris,Davis,cdavis@enterprisebank.com';
        Blob fileBody = Blob.valueOf(fileString);
        List<String> fileItems = fileBody.toString().split('\n');
        Set<String> emailsFromFile = new Set<String>{'cdavis@enterprisebank.com'};
        Id seshId = ObjectFactory.getFakeId(Eb_Event_Session__c.SObjectType, '1');
        EB_Event_Attendees__c attendee = new EB_Event_Attendees__c();
        attendee.Email_Address__c = 'cdavis@enterprisebank.com';
        Event_Attendance__c attendance = new Event_Attendance__c();
        attendance.Event_Session__c = seshId;
        List<Event_Attendance__c> attendances = new List<Event_Attendance__c>{attendance};
        Set<String> emailAddressesFromRegistrants = new Set<String>{attendee.Email_Address__c};

        mockFileDeconstructor.setup('getCsvLineItems', new List<Object>{fileBody}).returns(fileItems);
        mockHelper.setup('getEmailAddressesFromFile', new List<Object>{fileItems}).returns(emailsFromFile);
        mockDataProvider.setup('getAttendanceRecordsBySessionId', new List<Object>{seshId}).returns(attendances);
        mockHelper.setup('getEmailAddressesFromRegistrants', new List<Object>{attendances}).returns(emailAddressesFromRegistrants);
        mockDataProvider.setup('getAttendancesByEmailList', new List<Object>{emailsFromFile, seshId}).returns(attendances);

        EventAttendanceUpdater.updaterVm result = sut.build(fileBody, seshId);

        mockFileDeconstructor.verify('getCsvLineItems', new List<Object>{fileBody}, Times.Once);
        mockDataProvider.verify('save', new List<Object>{attendances}, Times.Once);
        system.assertEquals(seshId, result.attendanceRecords[0].Event_Session__c);
        system.assertEquals(1, result.attendanceRecords.size());
        system.assertEquals(0, result.createdAttendees.size());
        system.assertEquals(0, result.createdAttendanceRecords.size());
    }

    @IsTest
    static void it_should_create_an_attendance_for_an_unregistered_participant_with_an_existing_attendee_record() {
        String fileString = 'Attendee Number ,FirstName ,LastName ,Email \n Attendee,Chris,Davis,cdavis@enterprisebank.com \n Attendee,Thornton,Melon,t_melon@grandlakes.edu';
        Blob fileBody = Blob.valueOf(fileString);
        List<String> fileItems = fileBody.toString().split('\n');
        Set<String> emailsFromFile = new Set<String>{'cdavis@enterprisebank.com', 't_melon@grandlakes.edu'};
        Id seshId = ObjectFactory.getFakeId(Eb_Event_Session__c.SObjectType, '1');
        List<String> lineItemsInFileNotInRegistrants = new List<String>{fileItems[1], fileItems[2]};
        Set<String> emailAddressesFromRegistrants;
        Set<String> emailsInFileNotInRegistrants = new Set<String>{'cdavis@enterprisebank.com', 't_melon@grandlakes.edu'};
        Set<String> missingEmails = new Set<String>{'t_melon@grandlakes.edu'};
        List<String> missingLineItems = new List<String>{fileItems[2]};
        EB_Event_Attendees__c existingAttendee = new EB_Event_Attendees__c();
        existingAttendee.Email_Address__c = 'cdavis@enterprisebank.com';
        List<EB_Event_Attendees__c> unregisteredExistingAttendees = new List<EB_Event_Attendees__c>{existingAttendee};
        EB_Event_Attendees__c attendeeToCreate = new EB_Event_Attendees__c();
        attendeeToCreate.Email_Address__c = 'cdavis@enterprisebank.com';
        List<EB_Event_Attendees__c> attendeesToCreate = new List<EB_Event_Attendees__c>{attendeeToCreate};
        Set<String> createdAttendeeEmails = new Set<String>{attendeeToCreate.Email_Address__c};
        Event_Attendance__c attendance1 = new Event_Attendance__c();
        attendance1.Event_Session__c = seshId;
        attendance1.Event_Attendee__r = existingAttendee;
        Event_Attendance__c attendance2 = new Event_Attendance__c();
        attendance2.Event_Session__c = seshId;
        attendance2.Event_Attendee__r = attendeeToCreate;
        List<Event_Attendance__c> attendances = new List<Event_Attendance__c>{attendance1, attendance2};
        Event_Attendance__c updatedAttendance1 = new Event_Attendance__c();
        updatedAttendance1.Event_Session__c = seshId;
        updatedAttendance1.Event_Attendee__r = existingAttendee;
        updatedAttendance1.Record_Attendance__c = true;
        Event_Attendance__c updatedAttendance2 = new Event_Attendance__c();
        updatedAttendance2.Event_Session__c = seshId;
        updatedAttendance2.Event_Attendee__r = attendeeToCreate;
        updatedAttendance2.Record_Attendance__c = true;
        List<Event_Attendance__c> updatedAttendances = new List<Event_Attendance__c>{updatedAttendance1, updatedAttendance2};
        Set<String> createdAttendanceAttendeeEmails = new Set<String>{existingAttendee.Email_Address__c};

        mockFileDeconstructor.setup('getCsvLineItems', new List<Object>{fileBody}).returns(fileItems);
        mockHelper.setup('getEmailAddressesFromFile', new List<Object>{fileItems}).returns(emailsFromFile);
        mockHelper.setup('getParticipantsFromFileNotInRegistrants', new List<Object>{fileItems, emailAddressesFromRegistrants}).returns(lineItemsInFileNotInRegistrants);
        mockHelper.setup('getEmailsFromFileNotInRegistrants', new List<Object>{fileItems, emailAddressesFromRegistrants}).returns(emailsInFileNotInRegistrants);
        mockDataProvider.setup('getAttendeesByEmailSet', new List<Object>{emailsInFileNotInRegistrants}).returns(unregisteredExistingAttendees);
        mockHelper.setup('deDupeAttendeesList', new List<Object>{unregisteredExistingAttendees}).returns(unregisteredExistingAttendees);
        mockHelper.setup('getMissingAttendeeEmails', new List<Object>{unregisteredExistingAttendees, emailsInFileNotInRegistrants}).returns(missingEmails);
        mockHelper.setup('getMissingLineItems', new List<Object>{missingEmails, lineItemsInFileNotInRegistrants}).returns(missingLineItems);
        mockHelper.setup('getAttendeesToCreate', new List<Object>{missingLineItems}).returns(attendeesToCreate);
        mockDataProvider.setup('getAttendeesByEmailSet', new List<Object>{missingEmails}).returns(attendeesToCreate);
        mockHelper.setup('getAttendanceToCreateEmails', new List<Object>{attendeesToCreate}).returns(createdAttendeeEmails);
        mockHelper.setup('getAttendancesToCreate', new List<Object>{attendeesToCreate,seshId}).returns(attendances);
        mockDataProvider.setup('getCreatedAttendees', new List<Object>{createdAttendeeEmails}).returns(attendeesToCreate);
        mockDataProvider.setup('getAttendancesByEmailList', new List<Object>{createdAttendanceAttendeeEmails, seshId}).returns(attendances);
        mockDataProvider.setup('getAttendancesByEmailList', new List<Object>{emailsFromFile, seshId}).returns(attendances);

        EventAttendanceUpdater.updaterVm result = sut.build(fileBody, seshId);

        mockDataProvider.verify('save', new List<Object>{attendeesToCreate}, Times.Once);
        mockDataProvider.verify('save', new List<Object>{attendances}, Times.Once);
        mockDataProvider.verify('save', new List<Object>{updatedAttendances}, Times.Once);
        system.assertEquals(seshId, result.attendanceRecords[0].Event_Session__c);
        system.assertEquals(attendeeToCreate.Email_Address__c, result.createdAttendees[0].Email_Address__c);
    }

    @IsTest
    static void it_should_create_an_attendee_and_attendance_for_an_unregistered_participant_without_an_existing_attendee_record() {
        String fileString = 'User Type ,FirstName ,LastName ,Email \n Attendee,Chris,Davis,cdavis@enterprisebank.com';
        Blob fileBody = Blob.valueOf(fileString);
        List<String> fileItems = fileBody.toString().split('\n');
        Set<String> emailsFromFile = new Set<String>{'cdavis@enterprisebank.com'};
        Id seshId = ObjectFactory.getFakeId(Eb_Event_Session__c.SObjectType, '1');
        List<String> lineItemsInFileNotInRegistrants = new List<String>{fileItems[1]};
        Set<String> emailAddressesFromRegistrants;
        Set<String> emailsInFileNotInRegistrants = new Set<String>{'cdavis@enterprisebank.com'};
        EB_Event_Attendees__c attendee = new EB_Event_Attendees__c();
        attendee.Attendee__c = 'Chris Davis';
        attendee.Email_Address__c = 'cdavis@enterprisebank.com';
        Event_Attendance__c attendance = new Event_Attendance__c();
        attendance.Event_Session__c = seshId;
        attendance.Event_Attendee__r = attendee;
        List<EB_Event_Attendees__c> attendees = new List<EB_Event_Attendees__c>{attendee};
        List<Event_Attendance__c> attendances = new List<Event_Attendance__c>{attendance};
        Event_Attendance__c updatedAttendance = new Event_Attendance__c();
        updatedAttendance.Event_Session__c = seshId;
        updatedAttendance.Event_Attendee__r = attendee;
        updatedAttendance.Record_Attendance__c = true;
        List<Event_Attendance__c> updatedAttendances = new List<Event_Attendance__c>{updatedAttendance};
        Set<String> createdAttendanceAttendeeEmails = new Set<String>{attendee.Email_Address__c};

        mockFileDeconstructor.setup('getCsvLineItems', new List<Object>{fileBody}).returns(fileItems);
        mockHelper.setup('getEmailAddressesFromFile', new List<Object>{fileItems}).returns(emailsFromFile);
        mockHelper.setup('getParticipantsFromFileNotInRegistrants', new List<Object>{fileItems, emailAddressesFromRegistrants}).returns(lineItemsInFileNotInRegistrants);
        mockHelper.setup('getEmailsFromFileNotInRegistrants', new List<Object>{fileItems, emailAddressesFromRegistrants}).returns(emailsInFileNotInRegistrants);
        mockHelper.setup('getAttendeesToCreate', new List<Object>{lineItemsInFileNotInRegistrants}).returns(attendees);
        mockHelper.setup('getAttendanceToCreateEmails', new List<Object>{attendees}).returns(emailsInFileNotInRegistrants);
        mockHelper.setup('getAttendancesToCreate', new List<Object>{attendees,seshId}).returns(attendances);
        mockDataProvider.setup('getCreatedAttendees', new List<Object>{emailsInFileNotInRegistrants}).returns(attendees);
        mockDataProvider.setup('getAttendancesByEmailList', new List<Object>{createdAttendanceAttendeeEmails, seshId}).returns(attendances);
        mockDataProvider.setup('getAttendancesByEmailList', new List<Object>{emailsFromFile, seshId}).returns(attendances);
        
        EventAttendanceUpdater.updaterVm result = sut.build(fileBody, seshId);
    
        mockDataProvider.verify('save', new List<Object>{attendees}, Times.Once);
        mockDataProvider.verify('save', new List<Object>{attendances}, Times.Once);
        mockDataProvider.verify('save', new List<Object>{updatedAttendances}, Times.Once);
        system.assertEquals(seshId, result.attendanceRecords[0].Event_Session__c);
        system.assertEquals(attendee.Attendee__c, result.createdAttendees[0].Attendee__c);
        system.assertEquals(attendee.Email_Address__c, result.createdAttendanceRecords[0].Event_Attendee__r.Email_Address__c);
    }
    
    private class MockOfEventAttendanceUpdaterHelper extends ApexMoq implements EventAttendanceUpdater.IEventAttendanceUpdaterHelper {
        public Set<String> getEmailAddressesFromFile(List<String> fileItems){
            return (Set<String>)handleMethodInvocation('getEmailAddressesFromFile', new List<Object>{fileItems});
        }
        public Set<String> getEmailAddressesFromRegistrants(List<Event_Attendance__c> matchingAttendance){
            return (Set<String>)handleMethodInvocation('getEmailAddressesFromRegistrants', new List<Object>{matchingAttendance});
        }
        public List<String> getParticipantsFromFileNotInRegistrants(List<String> fileItems, Set<String>emailAddressesFromRegistrants){
            return (List<String>)handleMethodInvocation('getParticipantsFromFileNotInRegistrants', new List<Object>{fileItems, emailAddressesFromRegistrants});
        }
        public Set<String> getEmailsFromFileNotInRegistrants(List<String> fileItems, Set<String>emailAddressesFromRegistrants){
            return (Set<String>)handleMethodInvocation('getEmailsFromFileNotInRegistrants', new List<Object>{fileItems, emailAddressesFromRegistrants});
        }
        public List<EB_Event_Attendees__c> getAttendeesToCreate(List<String> lineItemsInFileNotInRegistrants){
            return (List<EB_Event_Attendees__c>)handleMethodInvocation('getAttendeesToCreate', new List<Object>{lineItemsInFileNotInRegistrants});
        }
        public Set<String> getMissingAttendeeEmails(List<EB_Event_Attendees__c> unregisteredExistingAttendees, Set<String> emailsInFileNotInRegistrants ){
            return (Set<String>)handleMethodInvocation('getMissingAttendeeEmails', new List<Object>{unregisteredExistingAttendees, emailsInFileNotInRegistrants});
        }
        public List<String> getMissingLineItems(Set<String> missingAttendeeEmails, List<String> lineItemsInFileNotInRegistrants){
            return (List<String>)handleMethodInvocation('getMissingLineItems', new List<Object>{missingAttendeeEmails, lineItemsInFileNotInRegistrants});
        }
        public List<Event_Attendance__c> getAttendancesToCreate(List<EB_Event_Attendees__c> createdAttendees, Id seshId){
            return(List<Event_Attendance__c>)handleMethodInvocation('getAttendancesToCreate', new List<Object>{createdAttendees, seshId});
        }
        public Set<String> getAttendanceToCreateEmails(List<EB_Event_Attendees__c> createdAttendees){
            return(Set<String>)handleMethodInvocation('getAttendanceToCreateEmails', new List<Object>{createdAttendees});
        }
        public List<EB_Event_Attendees__c> deDupeAttendeesList(List<EB_Event_Attendees__c> attendeesToDeDupe){
            return(List<EB_Event_Attendees__c>)handleMethodInvocation('deDupeAttendeesList', new List<Object>{attendeesToDeDupe});
        }
    }

    private class MockOfEventAttendanceUpdaterDataProvider extends ApexMoq implements EventAttendanceUpdater.IEventAttendanceUpdaterDataProvider {
        public List<Event_Attendance__c> getAttendanceRecordsBySessionId(Id seshId){
            return (List<Event_Attendance__c>)handleMethodInvocation('getAttendanceRecordsBySessionId', new List<Object>{seshId});
        }
        public List<EB_Event_Attendees__c> getAttendeesByEmailSet(Set<String> emailSet){
            return (List<EB_Event_Attendees__c>)handleMethodInvocation('getAttendeesByEmailSet', new List<Object>{emailSet});
        }
        public void save(List<SObject> objs){
            handleMethodInvocation('save', new List<Object>{objs});
        }
        public List<Event_Attendance__c> getAttendancesByEmailList(Set<String> emailsFromFile, Id seshId){
            return (List<Event_Attendance__c>)handleMethodInvocation('getAttendancesByEmailList', new List<Object>{emailsFromFile, seshId});
        }
        public List<EB_Event_Attendees__c> getCreatedAttendees(Set<String> emailSet){
            return (List<EB_Event_Attendees__c>)handleMethodInvocation('getCreatedAttendees', new List<Object>{emailSet});
        }
    }

    private class MockOfFileDeconstructor extends ApexMoq implements FileDeconstructor.IFileDeconstructor {
        public List<String> getCsvLineItems(Blob fileBody){
            return (List<String>)handleMethodInvocation('getCsvLineItems', new List<Object>{fileBody});
        }
    }
}