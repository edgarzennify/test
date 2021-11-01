trigger EB_Trigger on EB_Account__c (before delete, before insert, before update, after insert) {
	EBAccountTriggerHelper eb = new EBAccountTriggerHelper();
	
    if(trigger.isDelete){    
        eb.preventEBAccountDeletion(trigger.old);
    }
    if(trigger.isInsert && trigger.isBefore){
    	eb.updateAccountOfficerEmail(trigger.new);
        if(trigger.new.size()==1){
            eb.initializeOREOAccounts(trigger.new);
        }
    }
    if(trigger.isUpdate && trigger.isBefore){
    	eb.updateAccountOfficerEmail(trigger.new);
    	if(trigger.new.size()==1){
    		eb.ensureOREOAccountsLine1IsCorrect(trigger.new);
    	}
    }
}