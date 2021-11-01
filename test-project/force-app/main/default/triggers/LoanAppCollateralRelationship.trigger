trigger LoanAppCollateralRelationship on EB_Loan_App_Collateral_Relationship__c (after insert, after update, before delete, 
before insert, before update) {
	if(trigger.isAfter){
     	if(trigger.isUpdate){
     		LoanAppCollateralRelTriggerHelper hlpr = new LoanAppCollateralRelTriggerHelper();
     		     		
     		hlpr.AfterUpdate(trigger.new, trigger.newMap);
     	}
     }

   	TriggerFactory.createHandler(EB_Loan_App_Collateral_Relationship__c.sObjectType);
}