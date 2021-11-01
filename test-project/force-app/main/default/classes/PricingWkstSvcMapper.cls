public with sharing class PricingWkstSvcMapper implements PricingWkst.IPricingWkstSvcMapper{

	public PricingWkstSvcMapper() {
	}
 
	public PricingWkst.PricingRequestForJSON convertToJSONRequestObject(PricingWkstRequest request){
	 	PricingWkst.PricingRequestForJSON requestObject = new PricingWkst.PricingRequestForJSON();
		requestObject.AsOfDate = Datetime.now();
		requestObject.ExistingAccounts = new List<PricingWkst.BankAccount>();
		requestObject.ProposedLoans = new List<PricingWkst.ProposedLoanRequest>();
		requestObject.ProposedDeposits = new List<PricingWkst.ProposedDepositRequest>();
		requestObject.ProposedNonInterestIncomes = new List<PricingWkst.ProposedNonInterestIncomeRequest>();
		requestObject.ProposedAccountRemovals = new List<PricingWkst.BankAccount>();

		for(EB_Account__c existingAcct : request.existingAccounts){
			PricingWkst.BankAccount newItem = new PricingWkst.BankAccount();
			newItem.Bank = existingAcct.EB_Bank__r.Bank_Name__c;
			newItem.Application = existingAcct.Application__c;
			newItem.Account = existingAcct.Account_Number__c;
			requestObject.ExistingAccounts.add(newItem);
		}

		for(Pricing_Proposed_Loan__c propLoan : request.proposedLoans.values()){
			PricingWkst.ProposedLoanRequest newItem = new PricingWkst.ProposedLoanRequest();
			newItem.key = propLoan.Id;
			newItem.rateType = getNonNullString(propLoan.Rate_Type__c);
			newItem.amount = getNonNullNumber(propLoan.Amount__c);
			newItem.rate = getNonNullNumber(propLoan.Rate__c);
			newItem.loanType = getNonNullString(propLoan.Loan_Type__c);
			newItem.expectedUsage = getNonNullNumber(propLoan.Expected_Usage__c);
			newItem.term = getNonNullString(propLoan.Term__c);
			newItem.collateral = getNonNullString(propLoan.Collateral__c);
			newItem.fee = getNonNullNumber(propLoan.Fee__c);
			newItem.risk = getNonNullString(propLoan.Risk__c);
			newItem.fullyAmortized = getNonNullBoolean(propLoan.Fully_Amortized__c);
			newItem.renewal = getNonNullBoolean(propLoan.Renewal__c);
			requestObject.ProposedLoans.add(newItem);
		}

		for(Pricing_Proposed_Deposit__c propDeposit : request.proposedDeposits.values()){
			PricingWkst.ProposedDepositRequest newItem = new PricingWkst.ProposedDepositRequest();
			newItem.key = propDeposit.Id;
			newItem.depositType = getNonNullString(propDeposit.Deposit_Type__c);
			newItem.avgBalance = getNonNullNumber(propDeposit.Average_Balance__c);
			newItem.interestRate = getNonNullNumber(propDeposit.Interest_Rate__c);
			newItem.grossMonthlyServiceCharge = getNonNullNumber(propDeposit.Gross_Monthly_Service_Charge__c);
			newItem.cdTerm = getNonNullString(propDeposit.CD_Term__c);
			newItem.waived = getNonNullBoolean(propDeposit.Waived__c);
			requestObject.ProposedDeposits.add(newItem);
		}

		for(Pricing_Proposed_Non_Interest_Income__c propNonInt : request.proposedNonInterestIncome.values()){
			PricingWkst.ProposedNonInterestIncomeRequest newItem = new PricingWkst.ProposedNonInterestIncomeRequest();
			newItem.key = propNonInt.Id;
			newItem.feeType = getNonNullString(propNonInt.Fee_Type__c);
			newItem.annualGrossFees = getNonNullNumber(propNonInt.Annual_Gross_Fees__c);
			requestObject.ProposedNonInterestIncomes.add(newItem);
		}

		for(Pricing_Proposed_Account_Removal__c propAcctRemoval : request.proposedAccountRemovals.values()){
			PricingWkst.BankAccount newItem = new PricingWkst.BankAccount();
			newItem.Bank = propAcctRemoval.EB_Account__r.EB_Bank__r.Bank_Name__c;
			newItem.Application = propAcctRemoval.EB_Account__r.Application__c;
			newItem.Account = propAcctRemoval.EB_Account__r.Account_Number__c;
			requestObject.ProposedAccountRemovals.add(newItem);
		}
		System.debug('*********** reqObjExistAccts:' + requestObject.ExistingAccounts);
		System.debug('*********** reqObjProposedAccountRemovals:' + requestObject.ProposedAccountRemovals);
		return requestObject;
	}

	public PricingWkstResults generatePricingRequestResults(PricingWkstRequest request, PricingWkst.PricingResponseForJSON response){
		PricingWkstResults results = new PricingWkstResults();
		if(response.targetReturnOnEquity != null){
			results.targetReturnOnEquity = response.targetReturnOnEquity;
		}
		if(response.relationshipExpense != null){
			results.relationshipExpense = response.relationshipExpense;
		}
		if(response.existingSummary != null){
			results.existingSummary = response.existingSummary;
		}
		if(response.proposalSummary != null){
			results.proposalSummary = response.proposalSummary;
		}
		if(response.existingAccountsSummaries != null){
			results.existingAccountsSummaries = response.existingAccountsSummaries;
		}
		if(response.existingAccountDetails != null){
			results.existingAccountDetails = response.existingAccountDetails;			
		}
		results.proposedLoanPricingDetails = new List<PricingWkst.ProposedLoansDisplay>();
    	if(response.proposedLoanPricingResults != null){
			for(PricingWkst.ProposedLoanPricingResponse responseItem : response.proposedLoanPricingResults){
				results.proposedLoanPricingDetails.add(new PricingWkst.ProposedLoansDisplay(request.proposedLoans.get(responseItem.key), responseItem));
			}
		}else{
			for(Pricing_Proposed_Loan__c item : request.proposedLoans.values()){
				results.proposedLoanPricingDetails.add(new PricingWkst.ProposedLoansDisplay(item));
			}
		}
		results.proposedDepositPricingDetails = new List<PricingWkst.ProposedDepositsDisplay>();
    	if(response.proposedDepositPricingResults != null){
			for(PricingWkst.ProposedDepositPricingResponse responseItem : response.proposedDepositPricingResults){
				results.proposedDepositPricingDetails.add(new PricingWkst.ProposedDepositsDisplay(request.proposedDeposits.get(responseItem.key), responseItem));
			}
		}else{
			for(Pricing_Proposed_Deposit__c item : request.proposedDeposits.values()){
				results.proposedDepositPricingDetails.add(new PricingWkst.ProposedDepositsDisplay(item));
			}
		}
		results.proposedNonInterestIncomePricingDetails = new List<PricingWkst.ProposedNonIntIncomeDisplay>();
    	if(response.proposedNonInterestIncomePricingResults != null){
			for(PricingWkst.ProposedNonInterestIncomePricingResponse responseItem : response.proposedNonInterestIncomePricingResults){
				results.proposedNonInterestIncomePricingDetails.add(new PricingWkst.ProposedNonIntIncomeDisplay(request.proposedNonInterestIncome.get(responseItem.key), responseItem));
			}
		}else{
			for(Pricing_Proposed_Non_Interest_Income__c item : request.proposedNonInterestIncome.values()){
				results.proposedNonInterestIncomePricingDetails.add(new PricingWkst.ProposedNonIntIncomeDisplay(item));
			}
		}
		return results;
	}

	private Decimal getNonNullNumber(Decimal field){
		if(field == null){
			return 0;
		}else{
			return field;
		}
	}

	private String getNonNullString(String field){
		if(field == null){
			return '';
		}else{
			return field;
		}
	}

	private Boolean getNonNullBoolean(Boolean field){
		if(field == null){
			return false;
		}else{
			return field;
		}
	}


}