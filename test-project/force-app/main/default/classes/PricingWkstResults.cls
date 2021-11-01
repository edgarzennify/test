public with sharing class PricingWkstResults {

	public Double targetReturnOnEquity {get;set;}
	public Double relationshipExpense {get;set;}
	public PricingWkst.ReturnOnEquitySummary existingSummary {get;set;}
	public PricingWkst.ReturnOnEquitySummary proposalSummary {get;set;}
	public List<PricingWkst.ExistingAccountDetails> existingAccountDetails {get;set;}
	public List<PricingWkst.ExistingAccountsSummary> existingAccountsSummaries {get;set;}
	public List<PricingWkst.ProposedLoansDisplay> proposedLoanPricingDetails {get;set;}
	public List<PricingWkst.ProposedDepositsDisplay> proposedDepositPricingDetails {get;set;}
	public List<PricingWkst.ProposedNonIntIncomeDisplay> proposedNonInterestIncomePricingDetails {get;set;}

	public PricingWkstResults() {
	}

}