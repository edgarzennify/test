public with sharing class LoanParticTriggerHandlerDataProv implements LoanParticTriggerHandlerDataProv.ILoanParticTriggerHandlerDataProv {

	public interface ILoanParticTriggerHandlerDataProv {
		Set<Id> getRelatedLoanAppIds(Set<Id> loanParticIds);
	}

	public Set<Id> getRelatedLoanAppIds(Set<Id> loanParticIds)
	{
		List<EB_Loan_Participation__c> participations = [SELECT Loan_Application_ID__c FROM EB_Loan_Participation__c WHERE Id In: loanParticIds];
		Set<Id> loanAppIds = new Set<Id>();
		for(EB_Loan_Participation__c participation : participations){
			loanAppIds.add(participation.Loan_Application_ID__c);
		}
		return loanAppIds;
	}
}