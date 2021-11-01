trigger LoanActionChgOffAndRecTracking on EB_Loan_Action__c (after insert, after update, before insert, before update){
    LoanActionTriggerHelper helper = new LoanActionTriggerHelper();
    
    if(trigger.isAfter && trigger.new.size() == 1){
    	//Charge-off recovery tracking only
    	if(helper.RecordTypeChargeOffRecoveryMap.get(trigger.New[0].RecordTypeId) != null){
            if(helper.RecordTypeChargeOffRecoveryMap.get(trigger.New[0].RecordTypeId).Name == 'Charge-Off')
                helper.createCoRcvryObjects(trigger.new);        
        }
    }
    
    if(trigger.isBefore){        	
        //Only for Loan Transactions i.e. Loan Credit/Loan Debit
        if(trigger.isInsert && helper.RecordTypeLoanTransMap.get(trigger.New[0].RecordTypeId) !=null && trigger.new.size() == 1){
            helper.BeforeInsertAccountActionForLoanTransaction(trigger.new);
        }
        if(trigger.isUpdate &&  helper.RecordTypeLoanTransMap.get(trigger.new[0].RecordTypeId) !=null && trigger.new.size() == 1){
            helper.BeforeUpdateAccountActionForLoanTransaction(trigger.oldMap,trigger.new);
        }
    }

    if(trigger.isAfter && trigger.isInsert){
        helper.executeAfterInsert(trigger.new);            
    }
    
    if(trigger.isBefore && trigger.isUpdate){
    	helper.executeBeforeUpdate(trigger.new);
    }
}