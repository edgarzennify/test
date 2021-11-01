public with sharing class CollateralTriggerHandlerDataProv implements CollateralTriggerHandlerDataProv.ICollateralTriggerHandlerDataProv {

	public interface ICollateralTriggerHandlerDataProv {
		Set<Id> getRelatedLoanAppIds(Set<Id> collateralIds);
	}

	public Set<Id> getRelatedLoanAppIds(Set<Id> collateralIds)
	{
		List<EB_Loan_App_Collateral_Relationship__c> collatRels = [SELECT EB_Loan_Application_ID__c FROM EB_Loan_App_Collateral_Relationship__c WHERE EB_Collateral_ID__c In: collateralIds];
		Set<Id> loanAppIds = new Set<Id>();
		for(EB_Loan_App_Collateral_Relationship__c collatRel : collatRels){
			loanAppIds.add(collatRel.EB_Loan_Application_ID__c);
		}
		return loanAppIds;
	}

}