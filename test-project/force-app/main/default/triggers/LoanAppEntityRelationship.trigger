trigger LoanAppEntityRelationship on EB_Loan_App_Entity_Relationship__c (after insert, after update, before insert, 
before update) {
	if(trigger.isAfter){
     	if(trigger.isUpdate){
     		LoanAppEntityRelationshipTriggerHelper hlpr = new LoanAppEntityRelationshipTriggerHelper();
     		
     		
     		hlpr.AfterUpdate(trigger.new, trigger.newMap);
     	}
     }
}