trigger CreditRelationship on Credit_Relationship__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    TriggerFactory.createHandler(Credit_Relationship__c.sObjectType);
}