public with sharing class PricingWkst {
	public interface IPricingWkstSvcProxy
	{
		PricingWkstResults getPricingInformation(PricingWkstRequest request);
	}

	public interface IPricingWkstSvcMapper
	{
		PricingWkst.PricingRequestForJSON convertToJSONRequestObject(PricingWkstRequest request);
		PricingWkstResults generatePricingRequestResults(PricingWkstRequest request, PricingWkst.PricingResponseForJSON response);
	}

	public interface IPricingWkstDataProv
	{
		List<EB_Account__c> getEBAccountsForEntities(Set<Id> entityIDs, Set<Integer> applicationCodes);
		void addPricingWorksheet(Pricing_Worksheet__c worksheet);
		Pricing_Worksheet__c getPricingWorksheet(Id worksheetId);
		void updatePricingWorksheet(Pricing_Worksheet__c worksheet);
		List<EB_Loan_Packet__c> getLoanPacketsForEntities(Set<Id> entityIDs);
		Map<Id, Pricing_Proposed_Loan__c> getPricingProposedLoansForWorksheet(Id worksheetId);
		Map<Id, Pricing_Proposed_Deposit__c> getPricingProposedDepositsForWorksheet(Id worksheetId);
		Map<Id, Pricing_Proposed_Non_Interest_Income__c> getPricingProposedNonIntIncomeForWorksheet(Id worksheetId);
		Map<Id, Pricing_Proposed_Account_Removal__c> getPricingProposedAcctRemovalsForWorksheet(Id worksheetId);
		void addPricingProposedLoans(List<Pricing_Proposed_Loan__c> propLoans);
		void addPricingProposedDeposits(List<Pricing_Proposed_Deposit__c> propDeposits);
		void addPricingProposedNonIntIncomes(List<Pricing_Proposed_Non_Interest_Income__c> propNonIntIncomes);
		void addPricingProposedAcctRemovals(List<Pricing_Proposed_Account_Removal__c> propAcctRemovals);
		Pricing_Proposed_Loan__c getPricingProposedLoan(Id propLoanId);
		Pricing_Proposed_Deposit__c getPricingProposedDeposit(Id propDepositId);
		Pricing_Proposed_Non_Interest_Income__c getPricingProposedNonIntIncome(Id propNonIntIncomeId);
		Pricing_Proposed_Account_Removal__c getPricingProposedAcctRemoval(Id propAcctRemovalId);
		String getWorksheetIdForEntity(Id entityId);
		void updatePricingProposedLoans(List<Pricing_Proposed_Loan__c> propLoans);
		void updatePricingProposedDeposits(List<Pricing_Proposed_Deposit__c> propDeposits);
		void updatePricingProposedNonIntIncomes(List<Pricing_Proposed_Non_Interest_Income__c> propNonIntIncomes);
		void updatePricingProposedAcctRemovals(List<Pricing_Proposed_Account_Removal__c> propAcctRemovals);
		void deletePricingProposedLoans(List<Pricing_Proposed_Loan__c> propLoans);
		void deletePricingProposedDeposits(List<Pricing_Proposed_Deposit__c> propDeposits);
		void deletePricingProposedNonIntIncomes(List<Pricing_Proposed_Non_Interest_Income__c> propNonIntIncomes);
		void deletePricingProposedAcctRemovals(List<Pricing_Proposed_Account_Removal__c> propAcctRemovals);
	}

	public class PricingRequestForJSON
	{
		public Datetime AsOfDate {get;set;}
    	public List<PricingWkst.BankAccount> existingAccounts {get;set;}
    	public List<PricingWkst.ProposedLoanRequest> proposedLoans {get;set;}
    	public List<PricingWkst.ProposedDepositRequest> proposedDeposits {get;set;}
    	public List<PricingWkst.ProposedNonInterestIncomeRequest> proposedNonInterestIncomes {get;set;}
    	public List<PricingWkst.BankAccount> proposedAccountRemovals {get;set;}
	}

	public class BankAccount
	{
	    public String bank {get;set;}
	    public Decimal application {get;set;}
	    public String account {get;set;}
	}

	public class ProposedLoanRequest
	{
		public String key {get;set;}
		public String rateType {get;set;}
		public Decimal amount {get;set;}
		public Decimal rate {get;set;}
		public String loanType {get;set;}
		public Decimal expectedUsage {get;set;}
		public String term {get;set;}
		public String collateral {get;set;}
		public Decimal fee {get;set;}
		public String risk {get;set;}
		public Boolean fullyAmortized {get;set;}
		public Boolean renewal {get;set;}
	}

	public class ProposedDepositRequest
	{
		public String key {get;set;}
		public String depositType {get;set;}
		public Decimal avgBalance {get;set;}
		public Decimal interestRate {get;set;}
		public Decimal grossMonthlyServiceCharge {get;set;}
		public String cdTerm {get;set;}
		public Boolean waived {get;set;}
	}

	public class ProposedNonInterestIncomeRequest
	{
		public String key {get;set;}
		public String feeType {get;set;}
		public Decimal annualGrossFees {get;set;}
	}


	public class PricingResponseForJSON
	{
		public Double targetReturnOnEquity {get;set;}
		public Double relationshipExpense {get;set;}
		public PricingWkst.ReturnOnEquitySummary existingSummary {get;set;}
		public PricingWkst.ReturnOnEquitySummary proposalSummary {get;set;}
		public List<PricingWkst.ExistingAccountDetails> existingAccountDetails {get;set;}
		public List<PricingWkst.ExistingAccountsSummary> existingAccountsSummaries {get;set;}
		public List<PricingWkst.ProposedLoanPricingResponse> proposedLoanPricingResults {get;set;}
		public List<PricingWkst.ProposedDepositPricingResponse> proposedDepositPricingResults {get;set;}
		public List<PricingWkst.ProposedNonInterestIncomePricingResponse> proposedNonInterestIncomePricingResults {get;set;}
	}

	public class ReturnOnEquitySummary
	{
		public Decimal income {get;set;}
		public Decimal expenses {get;set;}
		public Decimal taxes {get;set;}
		public Decimal capitalRequired {get;set;}
		public Decimal relationshipCost {get; set;}
		public Decimal returnOnEquity {get;set;}
		public Decimal preTaxNetIncome {get;set;}
		public Decimal postTaxNetIncome {get;set;}
	}

	public class ExistingAccountsSummary
	{
		public String accountType {get;set;}
		public Decimal committedAmount {get;set;}
		public Decimal balanceOrFees {get;set;}
		public Decimal income {get;set;}
		public Decimal loanFees {get;set;}
		public Decimal riskExpense {get;set;}
		public Decimal adminExpense {get;set;}
		public Decimal capitalRequirements {get;set;}
	}

	public class ExistingAccountDetails
	{
	    public String bank {get;set;}
	    public Decimal application {get;set;}
	    public String accountTitle {get;set;}
	    public String account {get;set;}
		public String accountType {get;set;}
		public Decimal income {get;set;}
		public Decimal averageBalance {get;set;}
		public Decimal capitalRequirements {get;set;}
		public Decimal loanFees {get;set;}
		public Decimal riskExpense {get;set;}
		public Decimal committedAmount {get;set;}
		public Decimal transferRate {get;set;}
	}

	public class ProposedLoanPricingResponse
	{
		public Id key {get;set;}
		public Decimal transferRate {get;set;}
		public Decimal riskExpense {get;set;}
		public Decimal adminExpense {get;set;}
		public Decimal capitalRequirements {get;set;}
		public Decimal income {get;set;}
		public Decimal fee {get;set;}
	}

	public class ProposedDepositPricingResponse
	{
		public Id key {get;set;}
		public Decimal transferRate {get;set;}
		public Decimal capitalRequirements {get;set;}
		public Decimal income {get;set;}

	}

	public class ProposedNonInterestIncomePricingResponse
	{
		public Id key {get;set;}
		public Decimal profitMargin {get;set;}
		public Decimal income {get;set;}
	}


	public class ProposedLoansDisplay
	{
		public Pricing_Proposed_Loan__c proposedLoan {get;set;}
		public Decimal transferRate {get;set;}
		public Decimal riskExpense {get;set;}
		public Decimal adminFees {get;set;}
		public Decimal capital {get;set;}
		public Decimal income {get;set;}
		public ProposedLoansDisplay(Pricing_Proposed_Loan__c propLoan)
		{
			proposedLoan = propLoan;
		}
		public ProposedLoansDisplay(Pricing_Proposed_Loan__c propLoan, PricingWkst.ProposedLoanPricingResponse propLoanDetails)
		{
			proposedLoan = propLoan;
			transferRate = propLoanDetails.transferRate;
			riskExpense = propLoanDetails.riskExpense;
			adminFees = propLoanDetails.adminExpense;
			capital = propLoanDetails.capitalRequirements;
			if(propLoanDetails.fee == null){
				income = propLoanDetails.income;	
			}else {
				income = propLoanDetails.income + propLoanDetails.fee;
			}
		}
	}

	public class ProposedDepositsDisplay
	{
		public Pricing_Proposed_Deposit__c proposedDeposit {get;set;}
		public Decimal transferRate {get;set;}
		public Decimal capital {get;set;}
		public Decimal income {get;set;}
		public ProposedDepositsDisplay(Pricing_Proposed_Deposit__c propDeposit)
		{
			proposedDeposit = propDeposit;
		}
		public ProposedDepositsDisplay(Pricing_Proposed_Deposit__c propDeposit, PricingWkst.ProposedDepositPricingResponse propDepositDetails)
		{
			proposedDeposit = propDeposit;
			transferRate = propDepositDetails.transferRate;
			capital = propDepositDetails.capitalRequirements;
			income = propDepositDetails.income;
		}
	}

	public class ProposedNonIntIncomeDisplay
	{
		public Pricing_Proposed_Non_Interest_Income__c proposedNonIntIncome {get;set;}
		public Decimal margin {get;set;}
		public Decimal income {get;set;}
		public ProposedNonIntIncomeDisplay(Pricing_Proposed_Non_Interest_Income__c propNonIntIncome)
		{
			proposedNonIntIncome = propNonIntIncome;
		}
		public ProposedNonIntIncomeDisplay(Pricing_Proposed_Non_Interest_Income__c propNonIntIncome, PricingWkst.ProposedNonInterestIncomePricingResponse propNonIntIncomeDetails)
		{
			proposedNonIntIncome = propNonIntIncome;
			margin = propNonIntIncomeDetails.profitMargin;
			income = propNonIntIncomeDetails.income;
		}
	}


}