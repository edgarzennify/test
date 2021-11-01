//
// Do not modify code below, trigger should be standard call to trigger factory where processing is managed
// and appropriate handler called based on object type.
//
trigger LoanParticipationTrigger on EB_Loan_Participation__c (after delete, after insert, after update, before delete, before insert, before update) {
    TriggerFactory.createHandler(EB_Loan_Participation__c.sObjectType);
}