trigger EbAppraisalOrderTrigger on EB_Appraisal_Order__c (after delete, after insert, after update, before delete, before insert, before update) {

  TriggerFactory.createHandler(EB_Appraisal_Order__c.sObjectType);
    
}