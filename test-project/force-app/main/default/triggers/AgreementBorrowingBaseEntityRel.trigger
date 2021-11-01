trigger AgreementBorrowingBaseEntityRel on Agreement_Borrowing_Base_Entity_Rel__c (after insert,after update,after delete) {
    
    if(trigger.IsAfter){
        AgreementBBEntityRelTriggerHelper bbentityhelper = new AgreementBBEntityRelTriggerHelper();
        bbentityhelper.CallValidator(trigger.new);
    }

}