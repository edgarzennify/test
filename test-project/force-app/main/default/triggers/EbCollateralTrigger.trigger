trigger EbCollateralTrigger on EB_Collateral__c (after delete, after insert, after update, before delete, before insert, before update) {
	TriggerFactory.createHandler(EB_Collateral__c.sObjectType);

	if(trigger.isUpdate && trigger.isAfter && trigger.new.size() == 1){
		EbCollateralTriggerHelper helper = new EbCollateralTriggerHelper();
		helper.updateValidationForRelatedCollaterals(trigger.new);
	}
}