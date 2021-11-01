trigger TmServiceRequest on TM_Service_Request__c (after delete, after insert, after update, before delete, before insert, before update) {
    TriggerFactory.createHandler(TM_Service_Request__c.sObjectType);
}