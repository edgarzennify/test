trigger PaymentDecision on Payment_Decision__c (after delete, after insert, after update, before delete, before insert, before update) {
    TriggerFactory.createHandler(Payment_Decision__c.sObjectType);
}