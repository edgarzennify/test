@isTest
private class PricingWkstSvcMapperTests {

	private static final EB_Account__c acct1;
	private static final EB_Account__c acct2;
	private static final EB_Account__c acct3;
	private static final EB_Account__c acct4;
	private static final Pricing_Proposed_Loan__c propLoan1;
	private static final Pricing_Proposed_Loan__c propLoan2;
	private static final Pricing_Proposed_Deposit__c propDeposit1;
	private static final Pricing_Proposed_Deposit__c propDeposit2;
	private static final Pricing_Proposed_Non_Interest_Income__c propNonInt1;
	private static final Pricing_Proposed_Non_Interest_Income__c propNonInt2;
	private static final Pricing_Proposed_Account_Removal__c propAcctRem1;
	private static final Pricing_Proposed_Account_Removal__c propAcctRem2;
	private static final PricingWkstRequest requestObject;
	private static final PricingWkstSvcMapper sut;

	static{
		acct1 = new EB_Account__c(Id=ObjectFactory.getFakeId(EB_Account__c.SObjectType, '1'), Account_Number__c='1234');
		acct2 = new EB_Account__c(Id=ObjectFactory.getFakeId(EB_Account__c.SObjectType, '2'), Account_Number__c='2234');
		acct3 = new EB_Account__c(Id=ObjectFactory.getFakeId(EB_Account__c.SObjectType, '3'), Account_Number__c='3234');
		acct4 = new EB_Account__c(Id=ObjectFactory.getFakeId(EB_Account__c.SObjectType, '4'), Account_Number__c='4234');
		List<EB_Account__c> existingAccts = new List<EB_Account__c>{acct1, acct2, acct3, acct4};

		propLoan1 = new Pricing_Proposed_Loan__c(Id=ObjectFactory.getFakeId(Pricing_Proposed_Loan__c.SObjectType, '1'));
		propLoan1.Rate_Type__c = 'Fixed';
		propLoan1.Amount__c = 200000;
		propLoan1.Rate__c = 3.875;
		propLoan1.Loan_Type__c = 'Term';
		propLoan1.Expected_Usage__c = 100000;
		propLoan1.Term__c = '2 - 9m';
		propLoan1.Collateral__c = 'Other';
		propLoan1.Fee__c = 1000;
		propLoan1.Risk__c = '1';
		propLoan1.Fully_Amortized__c = false;
		propLoan1.Renewal__c = true;
		propLoan2 = new Pricing_Proposed_Loan__c(Id=ObjectFactory.getFakeId(Pricing_Proposed_Loan__c.SObjectType, '2'));
		propLoan2.Rate_Type__c = 'Floating';
		propLoan2.Amount__c = 101101;
		propLoan2.Rate__c = 5.5;
		propLoan2.Loan_Type__c = 'Construction';
		propLoan2.Expected_Usage__c = 5000;
		propLoan2.Term__c = '18m';
		propLoan2.Collateral__c = 'EB CD';
		propLoan2.Fee__c = 575;
		propLoan2.Risk__c = '2';
		propLoan2.Fully_Amortized__c = true;
		propLoan2.Renewal__c = false;
		Map<Id, Pricing_Proposed_Loan__c> propLoans = new Map<Id, Pricing_Proposed_Loan__c>{propLoan1.Id => propLoan1, propLoan2.Id => propLoan2};

		propDeposit1 = new Pricing_Proposed_Deposit__c(Id=ObjectFactory.getFakeId(Pricing_Proposed_Deposit__c.SObjectType, '1'));
		propDeposit1.Deposit_Type__c = 'Optima';
		propDeposit1.Average_Balance__c = 5000;
		propDeposit1.Interest_Rate__c = 3.575;
		propDeposit1.Gross_Monthly_Service_Charge__c = 10;
		propDeposit1.CD_Term__c = '0 - 6m';
		propDeposit1.Waived__c = false;
		propDeposit2 = new Pricing_Proposed_Deposit__c(Id=ObjectFactory.getFakeId(Pricing_Proposed_Deposit__c.SObjectType, '2'));
		propDeposit2.Deposit_Type__c = 'MMA';
		propDeposit2.Average_Balance__c = 3000;
		propDeposit2.Interest_Rate__c = 1.185;
		propDeposit2.Gross_Monthly_Service_Charge__c = 5;
		propDeposit2.CD_Term__c = '54+';
		propDeposit2.Waived__c = true;
		Map<Id, Pricing_Proposed_Deposit__c> propDeposits = new Map<Id, Pricing_Proposed_Deposit__c>{propDeposit1.Id => propDeposit1, propDeposit2.Id => propDeposit2};

		propNonInt1 = new Pricing_Proposed_Non_Interest_Income__c(Id=ObjectFactory.getFakeId(Pricing_Proposed_Non_Interest_Income__c.SObjectType, '1'));
		propNonInt1.Fee_Type__c = 'Advisory';
		propNonInt1.Annual_Gross_Fees__c = 100;
		propNonInt2 = new Pricing_Proposed_Non_Interest_Income__c(Id=ObjectFactory.getFakeId(Pricing_Proposed_Non_Interest_Income__c.SObjectType, '2'));
		propNonInt2.Fee_Type__c = 'Swap Fee';
		propNonInt2.Annual_Gross_Fees__c = 200;
		Map<Id, Pricing_Proposed_Non_Interest_Income__c> propNonInts = new Map<Id, Pricing_Proposed_Non_Interest_Income__c>{propNonInt1.Id => propNonInt1, propNonInt2.Id => propNonInt2};

		propAcctRem1 = new Pricing_Proposed_Account_Removal__c(Id=ObjectFactory.getFakeId(Pricing_Proposed_Account_Removal__c.SObjectType, '1'));
		propAcctRem1.EB_Account__c = acct2.Id;
		propAcctRem1.EB_Account__r = acct2;
		propAcctRem2 = new Pricing_Proposed_Account_Removal__c(Id=ObjectFactory.getFakeId(Pricing_Proposed_Account_Removal__c.SObjectType, '2'));
		propAcctRem2.EB_Account__c = acct3.Id;
		propAcctRem2.EB_Account__r = acct3;
		Map<Id, Pricing_Proposed_Account_Removal__c> propAcctRems = new Map<Id, Pricing_Proposed_Account_Removal__c>{propAcctRem1.Id => propAcctRem1, propAcctRem2.Id => propAcctRem2};

		requestObject = new PricingWkstRequest();
		requestObject.ExistingAccounts = existingAccts;
		requestObject.ProposedLoans = propLoans;
		requestObject.ProposedDeposits = propDeposits;
		requestObject.proposedNonInterestIncome = propNonInts;
		requestObject.proposedAccountRemovals = propAcctRems;

		sut = new PricingWkstSvcMapper();
	}
	
	private static testMethod void it_should_build_a_PricingRequestForJSON_from_a_PricingWkstRequest() {
		PricingWkst.PricingRequestForJSON pricingReqForJSON = sut.convertToJSONRequestObject(requestObject);

		Integer indexOfacct1 = -1;
		Integer indexOfacct2 = -1;
		Integer indexOfacct3 = -1;
		Integer indexOfacct4 = -1;
		Integer indexOfpropLoan1 = -1;
		Integer indexOfpropLoan2 = -1;
		Integer indexOfpropDeposit1 = -1;
		Integer indexOfpropDeposit2 = -1;
		Integer indexOfpropNonInt1 = -1;
		Integer indexOfpropNonInt2 = -1;
		Integer indexOfpropAcctRem1 = -1;
		Integer indexOfpropAcctRem2 = -1;
		for(Integer index = 0; index < pricingReqForJSON.ExistingAccounts.size(); index++){
			if(acct1.Account_Number__c == pricingReqForJSON.ExistingAccounts[index].Account){
				indexOfacct1 = index;
			}		
			if(acct2.Account_Number__c == pricingReqForJSON.ExistingAccounts[index].Account){
				indexOfacct2 = index;
			}		
			if(acct3.Account_Number__c == pricingReqForJSON.ExistingAccounts[index].Account){
				indexOfacct3 = index;
			}		
			if(acct4.Account_Number__c == pricingReqForJSON.ExistingAccounts[index].Account){
				indexOfacct4 = index;
			}		
		}
		for(Integer index = 0; index < pricingReqForJSON.ProposedLoans.size(); index++){
			if(propLoan1.Id == pricingReqForJSON.ProposedLoans[index].key){
				indexOfpropLoan1 = index;
			}		
			if(propLoan2.Id == pricingReqForJSON.ProposedLoans[index].key){
				indexOfpropLoan2 = index;
			}		
		}
		for(Integer index = 0; index < pricingReqForJSON.ProposedDeposits.size(); index++){
			if(propDeposit1.Id == pricingReqForJSON.ProposedDeposits[index].key){
				indexOfpropDeposit1 = index;
			}		
			if(propDeposit2.Id == pricingReqForJSON.ProposedDeposits[index].key){
				indexOfpropDeposit2 = index;
			}		
		}
		for(Integer index = 0; index < pricingReqForJSON.ProposedNonInterestIncomes.size(); index++){
			if(propNonInt1.Id == pricingReqForJSON.ProposedNonInterestIncomes[index].key){
				indexOfpropNonInt1 = index;
			}		
			if(propNonInt2.Id == pricingReqForJSON.ProposedNonInterestIncomes[index].key){
				indexOfpropNonInt2 = index;
			}		
		}
		for(Integer index = 0; index < pricingReqForJSON.ProposedAccountRemovals.size(); index++){
			if(propAcctRem1.EB_Account__r.Account_Number__c == pricingReqForJSON.ProposedAccountRemovals[index].Account){
				indexOfpropAcctRem1 = index;
			}		
			if(propAcctRem2.EB_Account__r.Account_Number__c == pricingReqForJSON.ProposedAccountRemovals[index].Account){
				indexOfpropAcctRem2 = index;
			}		
		}

		System.assertNotEquals(-1, indexOfacct1);
		System.assertNotEquals(-1, indexOfacct2);
		System.assertNotEquals(-1, indexOfacct3);
		System.assertNotEquals(-1, indexOfacct4);
		System.assertNotEquals(-1, indexOfpropLoan1);
		System.assertNotEquals(-1, indexOfpropLoan2);
		System.assertNotEquals(-1, indexOfpropDeposit1);
		System.assertNotEquals(-1, indexOfpropDeposit2);
		System.assertNotEquals(-1, indexOfpropNonInt1);
		System.assertNotEquals(-1, indexOfpropNonInt2);
		System.assertNotEquals(-1, indexOfpropAcctRem1);
		System.assertNotEquals(-1, indexOfpropAcctRem2);
		System.assertEquals(propLoan1.Rate_Type__c, pricingReqForJSON.ProposedLoans[indexOfpropLoan1].rateType);
		System.assertEquals(propLoan1.Amount__c, pricingReqForJSON.ProposedLoans[indexOfpropLoan1].amount);
		System.assertEquals(propLoan1.Rate__c, pricingReqForJSON.ProposedLoans[indexOfpropLoan1].rate);
		System.assertEquals(propLoan1.Loan_Type__c, pricingReqForJSON.ProposedLoans[indexOfpropLoan1].loanType);
		System.assertEquals(propLoan1.Expected_Usage__c, pricingReqForJSON.ProposedLoans[indexOfpropLoan1].expectedUsage);
		System.assertEquals(propLoan1.Term__c, pricingReqForJSON.ProposedLoans[indexOfpropLoan1].term);
		System.assertEquals(propLoan1.Collateral__c, pricingReqForJSON.ProposedLoans[indexOfpropLoan1].collateral);
		System.assertEquals(propLoan1.Fee__c, pricingReqForJSON.ProposedLoans[indexOfpropLoan1].fee);
		System.assertEquals(propLoan1.Risk__c, pricingReqForJSON.ProposedLoans[indexOfpropLoan1].risk);
		System.assertEquals(propLoan1.Fully_Amortized__c, pricingReqForJSON.ProposedLoans[indexOfpropLoan1].fullyAmortized);
		System.assertEquals(propLoan1.Renewal__c, pricingReqForJSON.ProposedLoans[indexOfpropLoan1].renewal);

		System.assertEquals(propLoan2.Rate_Type__c, pricingReqForJSON.ProposedLoans[indexOfpropLoan2].rateType);
		System.assertEquals(propLoan2.Amount__c, pricingReqForJSON.ProposedLoans[indexOfpropLoan2].amount);
		System.assertEquals(propLoan2.Rate__c, pricingReqForJSON.ProposedLoans[indexOfpropLoan2].rate);
		System.assertEquals(propLoan2.Loan_Type__c, pricingReqForJSON.ProposedLoans[indexOfpropLoan2].loanType);
		System.assertEquals(propLoan2.Expected_Usage__c, pricingReqForJSON.ProposedLoans[indexOfpropLoan2].expectedUsage);
		System.assertEquals(propLoan2.Term__c, pricingReqForJSON.ProposedLoans[indexOfpropLoan2].term);
		System.assertEquals(propLoan2.Collateral__c, pricingReqForJSON.ProposedLoans[indexOfpropLoan2].collateral);
		System.assertEquals(propLoan2.Fee__c, pricingReqForJSON.ProposedLoans[indexOfpropLoan2].fee);
		System.assertEquals(propLoan2.Risk__c, pricingReqForJSON.ProposedLoans[indexOfpropLoan2].risk);
		System.assertEquals(propLoan2.Fully_Amortized__c, pricingReqForJSON.ProposedLoans[indexOfpropLoan2].fullyAmortized);
		System.assertEquals(propLoan2.Renewal__c, pricingReqForJSON.ProposedLoans[indexOfpropLoan2].renewal);

		System.assertEquals(propDeposit1.Deposit_Type__c, pricingReqForJSON.ProposedDeposits[indexOfpropDeposit1].depositType);
		System.assertEquals(propDeposit1.Average_Balance__c, pricingReqForJSON.ProposedDeposits[indexOfpropDeposit1].avgBalance);
		System.assertEquals(propDeposit1.Interest_Rate__c, pricingReqForJSON.ProposedDeposits[indexOfpropDeposit1].interestRate);
		System.assertEquals(propDeposit1.Gross_Monthly_Service_Charge__c, pricingReqForJSON.ProposedDeposits[indexOfpropDeposit1].grossMonthlyServiceCharge);
		System.assertEquals(propDeposit1.CD_Term__c, pricingReqForJSON.ProposedDeposits[indexOfpropDeposit1].cdTerm);
		System.assertEquals(propDeposit1.Waived__c, pricingReqForJSON.ProposedDeposits[indexOfpropDeposit1].waived);

		System.assertEquals(propDeposit2.Deposit_Type__c, pricingReqForJSON.ProposedDeposits[indexOfpropDeposit2].depositType);
		System.assertEquals(propDeposit2.Average_Balance__c, pricingReqForJSON.ProposedDeposits[indexOfpropDeposit2].avgBalance);
		System.assertEquals(propDeposit2.Interest_Rate__c, pricingReqForJSON.ProposedDeposits[indexOfpropDeposit2].interestRate);
		System.assertEquals(propDeposit2.Gross_Monthly_Service_Charge__c, pricingReqForJSON.ProposedDeposits[indexOfpropDeposit2].grossMonthlyServiceCharge);
		System.assertEquals(propDeposit2.CD_Term__c, pricingReqForJSON.ProposedDeposits[indexOfpropDeposit2].cdTerm);
		System.assertEquals(propDeposit2.Waived__c, pricingReqForJSON.ProposedDeposits[indexOfpropDeposit2].waived);

		System.assertEquals(propNonInt1.Fee_Type__c, pricingReqForJSON.ProposedNonInterestIncomes[indexOfpropNonInt1].feeType);
		System.assertEquals(propNonInt1.Annual_Gross_Fees__c, pricingReqForJSON.ProposedNonInterestIncomes[indexOfpropNonInt1].annualGrossFees);

		System.assertEquals(propNonInt2.Fee_Type__c, pricingReqForJSON.ProposedNonInterestIncomes[indexOfpropNonInt2].feeType);
		System.assertEquals(propNonInt2.Annual_Gross_Fees__c, pricingReqForJSON.ProposedNonInterestIncomes[indexOfpropNonInt2].annualGrossFees);

	}

	private static testMethod void it_should_build_a_PricingWkstResults_from_a_PricingWkstRequest_and_PricingResponseForJSON() {
		PricingWkst.PricingResponseForJSON response = new PricingWkst.PricingResponseForJSON();
		response.targetReturnOnEquity = 111;
		response.relationshipExpense = 222;
		PricingWkst.ReturnOnEquitySummary existingSummary = new PricingWkst.ReturnOnEquitySummary();
		existingSummary.expenses = 333;
		response.existingSummary = existingSummary;
		PricingWkst.ReturnOnEquitySummary proposalSummary = new PricingWkst.ReturnOnEquitySummary();
		proposalSummary.Income = 444;
		response.proposalSummary = proposalSummary;
		PricingWkst.ExistingAccountsSummary existingAccountsSummary = new PricingWkst.ExistingAccountsSummary();
		existingAccountsSummary.loanFees = 555;
		List<PricingWkst.ExistingAccountsSummary> existingAccountsSummaries = new List<PricingWkst.ExistingAccountsSummary>{existingAccountsSummary};
		response.existingAccountsSummaries = existingAccountsSummaries;
		List<PricingWkst.ProposedLoanPricingResponse> proposedLoanPricingResponse = new List<PricingWkst.ProposedLoanPricingResponse>();
		List<PricingWkst.ProposedDepositPricingResponse> proposedDepositPricingResponse = new List<PricingWkst.ProposedDepositPricingResponse>();
		List<PricingWkst.ProposedNonInterestIncomePricingResponse> proposedNonInterestIncomePricingResponse = new List<PricingWkst.ProposedNonInterestIncomePricingResponse>();
		for(Pricing_Proposed_Loan__c propLoan : requestObject.proposedLoans.values()){
			PricingWkst.ProposedLoanPricingResponse result = new PricingWkst.ProposedLoanPricingResponse();
			result.key = propLoan.Id;
			result.transferRate = 1;
			result.riskExpense = 2; 
			result.adminExpense = 10; 
			result.capitalRequirements = 3; 
			result.income = 4;
			proposedLoanPricingResponse.add(result);
		}

		for(Pricing_Proposed_Deposit__c propDeposit : requestObject.proposedDeposits.values()){
			PricingWkst.ProposedDepositPricingResponse result = new PricingWkst.ProposedDepositPricingResponse();
			result.key = propDeposit.Id;
			result.transferRate = 1;
			result.capitalRequirements = 10; 
			result.income = 4;
			proposedDepositPricingResponse.add(result);
		}

		for(Pricing_Proposed_Non_Interest_Income__c propNonInt : requestObject.proposedNonInterestIncome.values()){
			PricingWkst.ProposedNonInterestIncomePricingResponse result = new PricingWkst.ProposedNonInterestIncomePricingResponse();
			result.key = propNonInt.Id;
			result.profitMargin = 1;
			result.income = 10; 
			proposedNonInterestIncomePricingResponse.add(result);
		}
		response.proposedLoanPricingResults = proposedLoanPricingResponse;
		response.proposedDepositPricingResults = proposedDepositPricingResponse;
		response.proposedNonInterestIncomePricingResults = proposedNonInterestIncomePricingResponse; 

		PricingWkstResults pricWkstResults = sut.generatePricingRequestResults(requestObject, response);

		System.assertEquals(111, pricWkstResults.targetReturnOnEquity);
		System.assertEquals(222, pricWkstResults.relationshipExpense);
		System.assertEquals(existingSummary, pricWkstResults.existingSummary);
		System.assertEquals(333, pricWkstResults.existingSummary.expenses);
		System.assertEquals(proposalSummary, pricWkstResults.proposalSummary);
		System.assertEquals(444, pricWkstResults.proposalSummary.income);
		System.assertEquals(existingAccountsSummaries, pricWkstResults.existingAccountsSummaries);
		System.assertEquals(555, pricWkstResults.existingAccountsSummaries[0].loanFees);
		System.assertEquals(2, pricWkstResults.proposedLoanPricingDetails.size());
		System.assertEquals(2, pricWkstResults.proposedDepositPricingDetails.size());
		System.assertEquals(2, pricWkstResults.proposedNonInterestIncomePricingDetails.size());
	}
	
}