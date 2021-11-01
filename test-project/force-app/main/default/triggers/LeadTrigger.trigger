//
// Do not modify code below, trigger should be standard call to trigger factory where processing is managed
// and appropriate handler called based on object type.
//
trigger LeadTrigger on Lead (after delete, after insert, after update, before delete, before insert, before update) {
    TriggerFactory.createHandler(Lead.sObjectType);
}