trigger BorrowingBaseReport on Borrowing_Base__c (before insert, after insert) {

        if(trigger.isBefore && trigger.new.size() ==1 ){
            BorrowingBaseTriggerHelper bb = new BorrowingBaseTriggerHelper();
            bb.NewBorrowingBaseReport(trigger.new);
            bb.UpdateCreatedDateMinus45Minutes(trigger.new);
        }
        if(trigger.isAfter && trigger.new.size() ==1){
            BorrowingBaseTriggerHelper bb = new BorrowingBaseTriggerHelper();
            bb.CreateBorrowingBaseColl(trigger.new);
    }
}