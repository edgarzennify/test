public with sharing class PricingWkstComponentROESummary extends PricingWkstComponentBase {

	public Decimal committedTotal {get;set;}
	public Decimal balFeeTotal {get;set;}
	public Decimal incomeTotal {get;set;}
	public Decimal loanFeesTotal {get;set;}
	public Decimal riskExpenseTotal {get;set;}
	public Decimal adminExpenseTotal {get;set;}
	public Decimal capitalTotal {get;set;}
	public String roeMessage {get;set;}
	public Boolean displayAccountDetails {
		get {
			return displayAccountDetails = displayAccountDetails == null ? false : displayAccountDetails;
		}
		set;
	}
	public List<PricingWkst.ExistingAccountDetails> existingAccountDetails {get;set;}

	private final String ROE_UNDER_TARGET_MESSAGE = 'DOES NOT MEET TARGET';

	public PricingWkstComponentROESummary() {
	}

	public override void updateTotals()	{
		updateColumnTotals();
		updateROEMessage();
		existingAccountDetails = pricingResults.existingAccountDetails;
	}

	private void updateColumnTotals() {
		committedTotal = 0;
		balFeeTotal = 0;
		incomeTotal = 0;
		loanFeesTotal = 0;
		riskExpenseTotal = 0;
		adminExpenseTotal = 0;
		capitalTotal = 0;
		for (PricingWkst.ExistingAccountsSummary item : pricingResults.existingAccountsSummaries) {
			if (item.committedAmount != null) {
				committedTotal += item.committedAmount;		
			}
			if (item.balanceOrFees != null) {
				balFeeTotal += item.balanceOrFees;		
			}
			if (item.income != null) {
				incomeTotal += item.income;		
			}
			if (item.loanFees != null) {
				loanFeesTotal += item.loanFees;		
			}
			if (item.riskExpense != null) {
				riskExpenseTotal += item.riskExpense;		
			}
			if (item.adminExpense != null) {
				adminExpenseTotal += item.adminExpense;		
			}
			if (item.capitalRequirements != null) {
				capitalTotal += item.capitalRequirements;		
			}
		}
	}

	private void updateROEMessage() {
		if (pricingResults.targetReturnOnEquity > pricingResults.proposalSummary.returnOnEquity) {
			roeMessage = ROE_UNDER_TARGET_MESSAGE;
		} else {
			roeMessage = '';
		}
	}

	public PageReference showAccountDetails() {
		displayAccountDetails = true;
		return null;
	}

	public PageReference hideAccountDetails() {
		displayAccountDetails = false;
		return null;
	}
}