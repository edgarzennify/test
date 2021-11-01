public class EventAttendanceUpdaterHelper implements EventAttendanceUpdater.IEventAttendanceUpdaterHelper{
    public Set<String> getEmailAddressesFromFile(List<String> fileItems){
        Set<String> returnSet = new Set<String>();
        for(Integer i=1;i<fileItems.size();i++){
            List<String> workingLine = fileItems[i].split(',');
            if(workingLine[0].isNumeric()){
                 workingLine[3].deleteWhiteSpace();
                 returnSet.add(workingLine[3].toLowerCase());
            }
        }
        return returnSet;
    }
    public Set<String> getEmailAddressesFromRegistrants(List<Event_Attendance__c> matchingAttendance){
        Set<String> returnSet = new Set<String>();
        if(matchingAttendance != null){
            for(Event_Attendance__c ea : matchingAttendance){
                if(ea.Event_Attendee__r.Email_Address__c != null){
                    returnSet.add(ea.Event_Attendee__r.Email_Address__c.toLowerCase());
                }
            }
        }
        return returnSet;
    }
    public List<String> getParticipantsFromFileNotInRegistrants(List<String> fileItems, Set<String> emailAddressesFromRegistrants){
        Set<String> builderSet  = new Set<String>();
        List<String> returnList = new List<String>();
        for(Integer i=1; i<fileItems.size();i++){
            List<String> workingLine = fileItems[i].split(',');
            workingLine[3] = workingLine[3].toLowerCase();
            workingLine[3] = workingLine[3].deleteWhiteSpace();
            if(!emailAddressesFromRegistrants.contains(workingLine[3]) && workingLine[0].isNumeric()){
                String updatedFileItem;
                for(String s : workingLine){
                    if(updatedFileItem == null){
                        updatedFileItem = s;
                    }else{
                        updatedFileItem = updatedFileItem + ',' +s;
                    }
                }
                builderSet.add(updatedFileItem);
            }
        }
        for(String s : builderSet){
            returnList.add(s);
        }
        return returnList;
    }
    public Set<String> getEmailsFromFileNotInRegistrants(List<String> fileItems, Set<String> emailAddressesFromRegistrants){
        Set<String> returnSet = new Set<String>();
        for(Integer i=1; i<fileItems.size();i++){
            List<String> workingLine = fileItems[i].split(',');
            workingLine[3] = workingLine[3].toLowerCase();
            workingLine[3] = workingLine[3].deleteWhiteSpace();
            if(!emailAddressesFromRegistrants.contains(workingLine[3].toLowerCase()) && workingLine[0].isNumeric()){
                workingLine[3].toLowerCase();
                workingLine[3] = workingLine[3].deleteWhiteSpace();
                returnSet.add(workingLine[3]);
            }
        }
        return returnSet;
    }
    public List<EB_Event_Attendees__c> getAttendeesToCreate(List<String> lineItems){
        List<Eb_Event_Attendees__c> attendeesToCreate = new List<Eb_Event_Attendees__c>();
        Set<EB_Event_Attendees__c> attendeesToCreateSet = new Set<EB_Event_Attendees__c>();
        for(Integer i=0; i<lineItems.size(); i++){
            List<String> workingLine  = lineItems[i].split(',');
            if(workingLine[0].isNumeric()){
                Eb_Event_Attendees__c eea = new Eb_Event_Attendees__c();
                eea.Attendee__c           = workingLine[1] + ' ' + workingLine[2];
                eea.Attendee_First_Name__c = workingLine[1];
                eea.Attendee_Last_Name__c = workingLine[2];
                eea.Email_Address__c      = workingLine[3];
                attendeesToCreateSet.add(eea);
            }
        }
        for(EB_Event_Attendees__c attendee : attendeesToCreateSet){
            attendeesToCreate.add(attendee);
        }
        return attendeesToCreate;
    }
    public Set<String> getMissingAttendeeEmails(List<EB_Event_Attendees__c> unregisteredExistingAttendees, Set<String> emailsInFileNotInRegistrants){
        List<EB_Event_Attendees__c> attendeesThatNeedAnAttendanceCreated = new List<EB_Event_Attendees__c>();
        Set<String> existingAttendeeEmails = getExistingAttendeeEmails(unregisteredExistingAttendees);
        Set<String> returnSet = new Set<String>();
        for(String s : emailsInFileNotInRegistrants){
            if(!existingAttendeeEmails.contains(s.toLowerCase())){
                returnSet.add(s.deleteWhitespace());
            }
        }
        return returnSet;
    }
    private Set<String> getExistingAttendeeEmails(List<Eb_Event_Attendees__c> unregisteredExistingAttendees){
        Set<String> existingEmails = new Set<String>();
        for(EB_Event_Attendees__c eea : unregisteredExistingAttendees){
            existingEmails.add(eea.Email_Address__c.toLowerCase());
        }
        return existingEmails;
    }
    public List<String> getMissingLineItems(Set<String> missingAttendeeEmails, List<String> lineItemsInFileNotInRegistrants){
        List<String> returnList = new List<String>();
        for(Integer i=0; i<lineItemsInFileNotInRegistrants.size(); i++){
            List<String> workingLine  = lineItemsInFileNotInRegistrants[i].split(',');
            if(missingAttendeeEmails.contains(workingLine[3].deleteWhiteSpace())){
                returnList.add(lineItemsInFileNotInRegistrants[i]);
            } 
        }
        return returnList;
    }
    public List<Event_Attendance__c> getAttendancesToCreate(List<EB_Event_Attendees__c> createdAttendees, Id seshId){
        List<Event_Attendance__c> returnList = new List<Event_Attendance__c>();
        for(EB_Event_Attendees__c attendee : createdAttendees){
            Event_Attendance__c attendance = new Event_Attendance__c();
            attendance.Event_Attendee__c = attendee.Id;
            attendance.Event_Session__c = seshId;
            returnList.add(attendance);
        }
        return returnList;
    }
    public Set<String> getAttendanceToCreateEmails(List<EB_Event_Attendees__c> createdAttendees){
        Set<String> returnSet = new Set<String>();
        for(EB_Event_Attendees__c attendee : createdAttendees){
            returnSet.add(attendee.Email_Address__c);
        }
        return returnSet;
    }
    public List<EB_Event_Attendees__c> deDupeAttendeesList(List<EB_Event_Attendees__c> attendeesToDeDupe){
        List<EB_Event_Attendees__c> returnList = new List<EB_Event_Attendees__c>();
        Set<String> emailSet = new Set<String>();
        for(EB_Event_Attendees__c attendee : attendeesToDeDupe){
            if(!emailSet.contains(attendee.Email_Address__c.toLowerCase())){
                emailSet.add(attendee.Email_Address__c.toLowerCase());
                returnList.add(attendee);
            }
        }
        return returnList; 
    }
}