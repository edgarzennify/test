trigger LoanApplicationTrigger on EB_Loan_Application__c (after delete, after insert, after update, before delete, before insert, before update) {
	LoanApplicationTriggerHelper las = new LoanApplicationTriggerHelper();
	// on Insert
	if(trigger.isInsert && trigger.isBefore ){
	    las.doBeforeInsert(trigger.new, trigger.newMap);
	}
	if(trigger.isInsert && trigger.isAfter ){
		las.doAfterInsert(trigger.new, trigger.newMap);
	}
	
	// on Update
	if(trigger.isUpdate && trigger.isBefore){
	   	las.doBeforeUpdate(trigger.old, trigger.new, trigger.newMap);
	}
	if(trigger.isUpdate && trigger.isAfter){
	   	las.doAfterUpdate(trigger.old, trigger.new, trigger.newMap); 
	}

	TriggerFactory.createHandler(EB_Loan_Application__c.sObjectType);
}