trigger AgreementClientrelationship on Agreement_Client_Relationships__c (before insert,after insert, after update, after delete, before delete) {
   
    AgreementClientRelationshipTriggerHelper helper = new AgreementClientRelationshipTriggerHelper();
    
    if(trigger.IsAfter){        
        helper.CallValidator(trigger.new);
    }
    
    if(trigger.isInsert && trigger.isBefore){
        helper.doBeforeInsert(trigger.new);
    }
    
    if(trigger.isInsert && trigger.isAfter){
        helper.doAfterInsert(trigger.new);
    }
    
    if(trigger.isBefore && trigger.isDelete){
        Agreement_Client_Relationships__c[] oldval = Trigger.old;
        if(oldval[0].Relationship__c == 'Primary Borrower'){
            trigger.old[0].Relationship__c.addError('The primary borrower cannot be deleted.');
        }
    }
    
    if(trigger.isUpdate && trigger.isAfter){
        helper.doAfterUpdate(trigger.old,trigger.new);   
    }
    
    if(trigger.isAfter && trigger.isDelete){
        helper.doAfterDelete(trigger.old);
    }
}