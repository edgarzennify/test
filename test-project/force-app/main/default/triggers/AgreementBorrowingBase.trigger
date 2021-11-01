trigger AgreementBorrowingBase on Agreement_Borrowing_Base_Relationship__c (after insert,  after update, after delete) {
    if(trigger.IsAfter){
        AgreementBorrowingBaseTriggerHelper bbhelper = new AgreementBorrowingBaseTriggerHelper();
        bbhelper.CallValidator(trigger.new);
    }
}