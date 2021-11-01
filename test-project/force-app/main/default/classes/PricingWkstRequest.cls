public with sharing class PricingWkstRequest {

	public Datetime asOfDate {get;set;}
	public List<EB_Account__c> existingAccounts {get;set;}
	public Map<Id,Pricing_Proposed_Loan__c> proposedLoans {get;set;}
	public Map<Id,Pricing_Proposed_Deposit__c> proposedDeposits {get;set;}
	public Map<Id,Pricing_Proposed_Non_Interest_Income__c> proposedNonInterestIncome {get;set;}
	public Map<Id,Pricing_Proposed_Account_Removal__c> proposedAccountRemovals {get;set;}

	public PricingWkstRequest() {
	}

}