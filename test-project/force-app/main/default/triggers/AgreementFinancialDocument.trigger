trigger AgreementFinancialDocument on Agreement_Financial_Documents__c (after insert, after update, after delete, before delete) {
        //if(trigger.IsAfter){
    AgreementFinancialDocTriggerHelper bbfinancialDochelper = new AgreementFinancialDocTriggerHelper();
    if(trigger.new != null && trigger.new.size() > 0){
        bbfinancialDochelper.CallValidator(trigger.new);
    }else{
        bbfinancialDochelper.CallValidator(trigger.old);
    }
        //}
}