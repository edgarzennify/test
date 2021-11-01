trigger AgreementTestTrigger on Agreement_Test__c (before insert, before update,after update) {
    if(trigger.Isupdate && trigger.IsBefore){
        AgreementTestTriggerHelper helper = new AgreementTestTriggerHelper();
        helper.beforeUpdate(trigger.New);
    }

}