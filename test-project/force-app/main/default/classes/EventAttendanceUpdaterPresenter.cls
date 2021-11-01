public class EventAttendanceUpdaterPresenter implements EventAttendanceUpdater.IPresenter{
    private final EventAttendanceUpdater.IEventAttendanceUpdaterHelper m_helper;
    private final EventAttendanceUpdater.IEventAttendanceUpdaterDataProvider m_dataProvider;
    private final EventAttendanceUpdater.updaterVm vm;
    private final FileDeconstructor.IFileDeconstructor m_fileDeconstructor;
    List<EB_Event_Attendees__c> createdAttendees = new List<EB_Event_Attendees__c>();
    List<Event_Attendance__c> createdAttendanceRecords = new List<Event_Attendance__c>();
    List<Event_Attendance__c> attendanceRecords = new List<Event_Attendance__c>();
    
    public EventAttendanceUpdaterPresenter(EventAttendanceUpdater.IEventAttendanceUpdaterHelper helper
                                           ,EventAttendanceUpdater.IEventAttendanceUpdaterDataProvider dataProvider
                                           ,FileDeconstructor.IFileDeconstructor fileDeconstructor)
    {
        m_helper = helper;
        m_dataProvider = dataProvider;
        m_fileDeconstructor = fileDeconstructor;
        vm = new EventAttendanceUpdater.updaterVm();
    }
    
    public EventAttendanceUpdater.updaterVm build(Blob fileBody,Id seshId){
        List<String> fileItems = m_fileDeconstructor.getCsvLineItems(fileBody);
        system.debug('fileItems is: ' + fileItems);
        Set<String> emailsFromFile = m_helper.getEmailAddressesFromFile(fileItems);
        system.debug('emailsFromFile is: ' + emailsFromFile);
        List<Event_Attendance__c> attendanceRecordsFromSession = m_dataProvider.getAttendanceRecordsBySessionId(seshId);
        system.debug('attendanceRecordsFromSession is: ' + attendanceRecordsFromSession);
        Set<String> emailAddressesFromRegistrants = m_helper.getEmailAddressesFromRegistrants(attendanceRecordsFromSession);
        system.debug('emailAddressesFromRegistrants is: ' + emailAddressesFromRegistrants);
        List<String> lineItemsInFileNotInRegistrants = m_helper.getParticipantsFromFileNotInRegistrants(fileItems, emailAddressesFromRegistrants);
        system.debug('lineItemsInFileNotInRegistrants is: ' + lineItemsInFileNotInRegistrants);
        if(fileContainsParticipantsWhoDidNotRegister(lineItemsInFileNotInRegistrants)){
            createAttendeeAndAttendanceRecords(lineItemsInFileNotInRegistrants, fileItems, emailAddressesFromRegistrants, seshId);
        }
        attendanceRecords = m_dataProvider.getAttendancesByEmailList(emailsFromFile, seshId);
        system.debug('attendanceRecords is: ' + attendanceRecords);
        updateAttendanceRecords();
        return buildVm();
    }
    
    ////////
    private void createAttendeeAndAttendanceRecords(List<String> lineItemsInFileNotInRegistrants, List<String> fileItems, Set<String> emailAddressesFromRegistrants, Id seshId){
        Set<String> emailsInFileNotInRegistrants = m_helper.getEmailsFromFileNotInRegistrants(fileItems, emailAddressesFromRegistrants);
        system.debug('emailsInFileNotInRegistrants is: ' + lineItemsInFileNotInRegistrants);
        List<EB_event_Attendees__c> unregisteredExistingAttendees = m_dataProvider.getAttendeesByEmailSet(emailsInFileNotInRegistrants);
        system.debug('unregisteredExistingAttendees is: ' + unregisteredExistingAttendees);
        if(noExistingAttendeesForUnregisteredParticipants(unregisteredExistingAttendees)){
            createAttendeesAndAttendancesForEachLineItem(lineItemsInFileNotInRegistrants, seshId);
        }else{
            unregisteredExistingAttendees = m_helper.deDupeAttendeesList(unregisteredExistingAttendees);
            createAttendeesIfMissingAndAttendancesForAll(unregisteredExistingAttendees, emailsInFileNotInRegistrants, lineItemsInFileNotInRegistrants, seshId);
        }
    }
    private Boolean noExistingAttendeesForUnregisteredParticipants(List<EB_Event_Attendees__c> unregisteredExistingAttendees){
        return unregisteredExistingAttendees == null || unregisteredExistingAttendees.size()==0;
    }
    private void updateAttendanceRecords(){
        for(Event_Attendance__c attendance : attendanceRecords){
            attendance.Record_Attendance__c = true;
        }
        m_dataProvider.save(attendanceRecords);
    }
    private EventAttendanceUpdater.updaterVm buildVm(){
        EventAttendanceUpdater.updaterVm vm = new EventAttendanceUpdater.updaterVm();
        vm.createdAttendees = createdAttendees;
        vm.createdAttendanceRecords = createdAttendanceRecords;
        vm.attendanceRecords = attendanceRecords;
        return vm;
    }
    private void createAttendeesAndAttendancesForEachLineItem(List<String> lineItemsInFileNotInRegistrants, Id seshId){
        createdAttendees = m_helper.getAttendeesToCreate(lineItemsInFileNotInRegistrants);
        system.debug('createdAttendees is: ' + createdAttendees);
        Set<String> attendeeEmails = m_helper.getAttendanceToCreateEmails(createdAttendees);
        system.debug('attendeeEmails is: ' + attendeeEmails);
        m_dataProvider.save(createdAttendees);
        List<Event_Attendance__c> attendanceRecordsToCreate = m_helper.getAttendancesToCreate(createdAttendees,seshId);
        system.debug('attendanceRecordsToCreate is: ' + attendanceRecordsToCreate);
        m_dataProvider.save(attendanceRecordsToCreate);
        createdAttendanceRecords = m_dataProvider.getAttendancesByEmailList(attendeeEmails, seshId);
        system.debug('createdAttendanceRecords is: ' + createdAttendanceRecords);
    }
    private void createAttendeesIfMissingAndAttendancesForAll(List<EB_Event_Attendees__c> unregisteredExistingAttendees, Set<String> emailsInFileNotInRegistrants, List<String> lineItemsInFileNotInRegistrants, Id seshId){
        Set<String> missingEmails = m_helper.getMissingAttendeeEmails(unregisteredExistingAttendees, emailsInFileNotInRegistrants);
        system.debug('missingEmails is: ' + missingEmails);
        List<EB_Event_Attendees__c> attendeesThatNeedAnAttendanceCreated = new List<EB_Event_Attendees__c>();
        system.debug('unregisteredExistingAttendees is: ' + unregisteredExistingAttendees);
        attendeesThatNeedAnAttendanceCreated.addAll(unregisteredExistingAttendees);
        system.debug('attendeesThatNeedAnAttendanceCreated is: ' + attendeesThatNeedAnAttendanceCreated);
        Set<String> attendeeEmails = new Set<String>();
        if(missingEmails != null || missingEmails.size() > 0){
            List<String> missingLineItems = m_helper.getMissingLineItems(missingEmails, lineItemsInFileNotInRegistrants);
            system.debug('missingLineItems is: ' + attendeesThatNeedAnAttendanceCreated);
            createdAttendees = m_helper.getAttendeesToCreate(missingLineItems);
            system.debug('createdAttendees is: ' + createdAttendees);
            m_dataProvider.save(createdAttendees);
            List<EB_Event_Attendees__c> newlyCreatedAttendees = m_dataProvider.getAttendeesByEmailSet(missingEmails);
            system.debug('newlyCreatedAttendees before dupe is: ' + newlyCreatedAttendees);
            newlyCreatedAttendees = m_helper.deDupeAttendeesList(newlyCreatedAttendees);
            system.debug('newlyCreatedAttendees after dupe is: ' + newlyCreatedAttendees);
            attendeesThatNeedAnAttendanceCreated.addAll(newlyCreatedAttendees); 
            system.debug('attendeesThatNeedAnAttendanceCreated after dupe is: ' + attendeesThatNeedAnAttendanceCreated);
        }
        attendeeEmails = m_helper.getAttendanceToCreateEmails(attendeesThatNeedAnAttendanceCreated);
        system.debug('attendeeEmails after dupe is: ' + attendeeEmails);
        List<Event_Attendance__c> attendanceRecordsToCreate = m_helper.getAttendancesToCreate(attendeesThatNeedAnAttendanceCreated,seshId);
        system.debug('attendanceRecordsToCreate after dupe is: ' + attendanceRecordsToCreate);
		m_dataProvider.save(attendanceRecordsToCreate); 
        createdAttendanceRecords = m_dataProvider.getAttendancesByEmailList(attendeeEmails, seshId);
        system.debug('createdAttendanceRecords after dupe is: ' + createdAttendanceRecords);
    }
    private Boolean fileContainsParticipantsWhoDidNotRegister(List<String> lineItemsInFileNotInRegistrants){
        return lineItemsInFileNotInRegistrants != null && lineItemsInFileNotInRegistrants.size() >0;
    }
}