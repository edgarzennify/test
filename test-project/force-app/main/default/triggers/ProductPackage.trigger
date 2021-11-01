trigger ProductPackage on LLC_BI__Product_Package__c (after delete, after insert, after update, before delete, before insert, before update) {
	TriggerFactory.createHandler(LLC_BI__Product_Package__c.sObjectType);
}