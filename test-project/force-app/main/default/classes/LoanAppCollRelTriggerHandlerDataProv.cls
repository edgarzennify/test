public with sharing class LoanAppCollRelTriggerHandlerDataProv implements LoanAppCollRelTriggerHandlerDataProv.ILoanAppCollRelTriggerHandlerDataProv {

	public interface ILoanAppCollRelTriggerHandlerDataProv {
		Set<Id> getRelatedLoanAppIds(Set<Id> collateralRelIds);
	}

	public Set<Id> getRelatedLoanAppIds(Set<Id> collateralRelIds)
	{
		List<EB_Loan_App_Collateral_Relationship__c> collatRels = [SELECT EB_Loan_Application_ID__c FROM EB_Loan_App_Collateral_Relationship__c WHERE Id In: collateralRelIds];
		Set<Id> loanAppIds = new Set<Id>();
		for(EB_Loan_App_Collateral_Relationship__c collatRel : collatRels){
			loanAppIds.add(collatRel.EB_Loan_Application_ID__c);
		}
		return loanAppIds;
	}

}