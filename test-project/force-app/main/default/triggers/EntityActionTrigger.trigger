trigger EntityActionTrigger on Entity_Action__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    TriggerFactory.createHandler(Entity_Action__c.sObjectType);

}