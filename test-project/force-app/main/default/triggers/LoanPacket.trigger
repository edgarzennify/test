trigger LoanPacket on EB_Loan_Packet__c (after insert, after update, before insert, before update) {
    if(trigger.isUpdate && trigger.isAfter){
        LoanAppPacketTriggerHelper las = new LoanAppPacketTriggerHelper();
        las.updateLoanAppPacketFromList(trigger.old, trigger.newMap);
    }
    if(trigger.isUpdate && trigger.isBefore){
        LoanAppPacketTriggerHelper las = new LoanAppPacketTriggerHelper();
        las.updateBeforeLoanPacketFromList(trigger.new);
        las.validate(trigger.new);
    }
    if(trigger.isInsert && trigger.isBefore){
        LoanAppPacketTriggerHelper las = new LoanAppPacketTriggerHelper();
        las.validate(trigger.new);
    }
}