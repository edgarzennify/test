trigger LoanArchivedStage on EB_Booked_Loan_App__c (after insert, after update, before delete, 
before insert, before update) {
	   /*if(trigger.isInsert && trigger.isAfter ){
			LoanArchivedStageTriggerHelper las = new LoanArchivedStageTriggerHelper();
			las.insertLoanArchivedStageAfterFromList(trigger.new);			
	    } 
	    if(trigger.isInsert && trigger.isBefore ){
	    	LoanArchivedStageTriggerHelper las = new LoanArchivedStageTriggerHelper();
	    	las.insertLoanArchivedStageBeforeFromList(trigger.new);
	    }*/
	    if(trigger.isUpdate && trigger.isAfter){
	    	LoanArchivedStageTriggerHelper las = new LoanArchivedStageTriggerHelper();
	    	las.updateLoanArchivedStageFromList(trigger.old, trigger.newMap, trigger.new); 
	    }
	    if(trigger.isUpdate && trigger.isBefore){
	    	LoanArchivedStageTriggerHelper las = new LoanArchivedStageTriggerHelper();
	    	las.updateBeforeLoanArchivedStageFromList(trigger.new);
	   	
	    }


}