trigger TmMaintenanceTrigger on TM_Maintenance__c (after delete, after insert, after update, before delete, before insert, before update) {
    TriggerFactory.createHandler(TM_Maintenance__c.sObjectType);
}