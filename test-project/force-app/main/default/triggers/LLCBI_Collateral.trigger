trigger LLCBI_Collateral on LLC_BI__Collateral__c (after delete, after insert, after update, before delete, before insert, before update) {
	TriggerFactory.createHandler(LLC_BI__Collateral__c.sObjectType);
}