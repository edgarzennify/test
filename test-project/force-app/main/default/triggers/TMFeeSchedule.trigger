trigger TMFeeSchedule on TM_Fee_Schedule__c (after delete, after insert, after update, before delete, before insert, before update) {
    TriggerFactory.createHandler(TM_Fee_Schedule__c.sObjectType);
}