trigger LLCBI_Loan on LLC_BI__Loan__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
	TriggerFactory.createHandler(LLC_BI__Loan__c.sObjectType);
}