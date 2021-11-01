trigger EbEventAttendees on EB_Event_Attendees__c (after delete, after insert, after update, before delete, before insert, before update) {
    TriggerFactory.createHandler(EB_Event_Attendees__c.sObjectType);
}