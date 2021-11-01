trigger TMFee on TM_Fee__c (after delete, after insert, after update, before delete, before insert, before update) {
    TriggerFactory.createHandler(TM_Fee__c.sObjectType); 
}