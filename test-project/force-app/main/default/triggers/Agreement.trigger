trigger Agreement on Agreement__c (before insert, after insert, before update, after update) {
    AgreementTriggerHelper helper = new AgreementTriggerHelper();
    
    // on insert
    if(trigger.isInsert && trigger.isBefore){
        helper.doBeforeInsert(trigger.new);
    }
    if(trigger.isInsert && trigger.isAfter){
        system.debug('###agreement after/insert');
        helper.doAfterInsert(trigger.new, trigger.newMap);
    }
    
    // on update
    if(trigger.isUpdate && trigger.isBefore){
        helper.doBeforeUpdate(trigger.old, trigger.new, trigger.newMap);
    }
    if(trigger.isUpdate && trigger.isAfter){
        helper.doAfterUpdate(trigger.old, trigger.new, trigger.oldMap, trigger.newMap);
    }
}