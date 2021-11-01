@isTest
private class PricingWkstComponentROESummaryTests {

	@IsTest
    static void it_should_update_totals_when_object_is_set() {
		PricingWkst.ExistingAccountsSummary loansSummary = new PricingWkst.ExistingAccountsSummary();
		loansSummary.committedAmount = 111;
		loansSummary.balanceOrFees = 222;
		loansSummary.income = 333;
		loansSummary.loanFees = 444;
		loansSummary.riskExpense = 555;
		loansSummary.adminExpense = 888;
		loansSummary.capitalRequirements = 999;
		PricingWkst.ExistingAccountsSummary depositsSummary = new PricingWkst.ExistingAccountsSummary();
		depositsSummary.committedAmount = 111000;
		depositsSummary.balanceOrFees = 222000;
		depositsSummary.income = 333000;
		depositsSummary.loanFees = 444000;
		depositsSummary.riskExpense = 555000;
		depositsSummary.adminExpense = 888000;
		depositsSummary.capitalRequirements = 999000;
		List<PricingWkst.ExistingAccountsSummary> existAcctSummary = new List<PricingWkst.ExistingAccountsSummary>{loansSummary, depositsSummary};
		PricingWkstResults testResults = new PricingWkstResults();
		testResults.existingAccountsSummaries = existAcctSummary;
		testResults.existingSummary = new PricingWkst.ReturnOnEquitySummary();
		testResults.proposalSummary = new PricingWkst.ReturnOnEquitySummary();
		PricingWkstComponentROESummary sut = new PricingWkstComponentROESummary();

		sut.pricingResults = testResults;

		System.assertEquals(111111, sut.committedTotal);
		System.assertEquals(222222, sut.balFeeTotal);
		System.assertEquals(333333, sut.incomeTotal);
		System.assertEquals(444444, sut.loanFeesTotal);
		System.assertEquals(555555, sut.riskExpenseTotal);
		System.assertEquals(888888, sut.adminExpenseTotal);
		System.assertEquals(999999, sut.capitalTotal);
	}

	@IsTest
    static void it_should_update_the_ROE_Message_if_targetROE_is_greater_than_proposed() {
		PricingWkst.ExistingAccountsSummary loansSummary = new PricingWkst.ExistingAccountsSummary();
		loansSummary.committedAmount = 111;
		loansSummary.balanceOrFees = 222;
		loansSummary.income = 333;
		loansSummary.loanFees = 444;
		loansSummary.riskExpense = 555;
		loansSummary.adminExpense = 888;
		loansSummary.capitalRequirements = 999;
		PricingWkst.ExistingAccountsSummary depositsSummary = new PricingWkst.ExistingAccountsSummary();
		depositsSummary.committedAmount = 111000;
		depositsSummary.balanceOrFees = 222000;
		depositsSummary.income = 333000;
		depositsSummary.loanFees = 444000;
		depositsSummary.riskExpense = 555000;
		depositsSummary.adminExpense = 888000;
		depositsSummary.capitalRequirements = 999000;
		List<PricingWkst.ExistingAccountsSummary> existAcctSummary = new List<PricingWkst.ExistingAccountsSummary>{loansSummary, depositsSummary};
		PricingWkstResults testResults = new PricingWkstResults();
		testResults.existingAccountsSummaries = existAcctSummary;
		testResults.existingSummary = new PricingWkst.ReturnOnEquitySummary();
		testResults.existingSummary.income = 100;
		testResults.existingSummary.expenses = 20;
		testResults.existingSummary.taxes = 30;
		testResults.existingSummary.capitalRequired = 50;
		testResults.proposalSummary = new PricingWkst.ReturnOnEquitySummary();
		testResults.proposalSummary.income = 100;
		testResults.proposalSummary.expenses = 10;
		testResults.proposalSummary.taxes = 20;
		testResults.proposalSummary.capitalRequired = 35;
		testResults.proposalSummary.returnOnEquity = 15;
		testResults.targetReturnOnEquity = 18;
		PricingWkstComponentROESummary sut = new PricingWkstComponentROESummary();
		sut.pricingResults = testResults;

		sut.updateTotals();

		System.assertEquals('DOES NOT MEET TARGET', sut.roeMessage);
	}
	
	@IsTest
    static void it_should_not_update_the_ROE_Message_if_targetROE_is_less_than_proposed() {
		PricingWkst.ExistingAccountsSummary loansSummary = new PricingWkst.ExistingAccountsSummary();
		loansSummary.committedAmount = 111;
		loansSummary.balanceOrFees = 222;
		loansSummary.income = 333;
		loansSummary.loanFees = 444;
		loansSummary.riskExpense = 555;
		loansSummary.adminExpense = 888;
		loansSummary.capitalRequirements = 999;
		PricingWkst.ExistingAccountsSummary depositsSummary = new PricingWkst.ExistingAccountsSummary();
		depositsSummary.committedAmount = 111000;
		depositsSummary.balanceOrFees = 222000;
		depositsSummary.income = 333000;
		depositsSummary.loanFees = 444000;
		depositsSummary.riskExpense = 555000;
		depositsSummary.adminExpense = 888000;
		depositsSummary.capitalRequirements = 999000;
		List<PricingWkst.ExistingAccountsSummary> existAcctSummary = new List<PricingWkst.ExistingAccountsSummary>{loansSummary, depositsSummary};
		PricingWkstResults testResults = new PricingWkstResults();
		testResults.existingAccountsSummaries = existAcctSummary;
		testResults.existingSummary = new PricingWkst.ReturnOnEquitySummary();
		testResults.existingSummary.income = 100;
		testResults.existingSummary.expenses = 20;
		testResults.existingSummary.taxes = 30;
		testResults.existingSummary.capitalRequired = 50;
		testResults.proposalSummary = new PricingWkst.ReturnOnEquitySummary();
		testResults.proposalSummary.income = 100;
		testResults.proposalSummary.expenses = 10;
		testResults.proposalSummary.taxes = 20;
		testResults.proposalSummary.capitalRequired = 35;
		testResults.proposalSummary.returnOnEquity = 20;
		testResults.targetReturnOnEquity = 18;
		PricingWkstComponentROESummary sut = new PricingWkstComponentROESummary();
		sut.pricingResults = testResults;

		sut.updateTotals();

		System.assertEquals('', sut.roeMessage);
	}

	@IsTest
	static void it_should_set_displayAccountDetails_to_false_on_load() {
		PricingWkst.ExistingAccountsSummary loansSummary = new PricingWkst.ExistingAccountsSummary();
		loansSummary.committedAmount = 111;
		loansSummary.balanceOrFees = 222;
		loansSummary.income = 333;
		loansSummary.loanFees = 444;
		loansSummary.riskExpense = 555;
		loansSummary.adminExpense = 888;
		loansSummary.capitalRequirements = 999;
		PricingWkst.ExistingAccountsSummary depositsSummary = new PricingWkst.ExistingAccountsSummary();
		depositsSummary.committedAmount = 111000;
		depositsSummary.balanceOrFees = 222000;
		depositsSummary.income = 333000;
		depositsSummary.loanFees = 444000;
		depositsSummary.riskExpense = 555000;
		depositsSummary.adminExpense = 888000;
		depositsSummary.capitalRequirements = 999000;
		List<PricingWkst.ExistingAccountsSummary> existAcctSummary = new List<PricingWkst.ExistingAccountsSummary>{loansSummary, depositsSummary};
		PricingWkstResults testResults = new PricingWkstResults();
		testResults.existingAccountsSummaries = existAcctSummary;
		testResults.existingSummary = new PricingWkst.ReturnOnEquitySummary();
		testResults.existingSummary.income = 100;
		testResults.existingSummary.expenses = 20;
		testResults.existingSummary.taxes = 30;
		testResults.existingSummary.capitalRequired = 50;
		testResults.proposalSummary = new PricingWkst.ReturnOnEquitySummary();
		testResults.proposalSummary.income = 100;
		testResults.proposalSummary.expenses = 10;
		testResults.proposalSummary.taxes = 20;
		testResults.proposalSummary.capitalRequired = 35;
		testResults.proposalSummary.returnOnEquity = 20;
		testResults.targetReturnOnEquity = 18;
		PricingWkstComponentROESummary sut = new PricingWkstComponentROESummary();
		sut.pricingResults = testResults;

		sut.updateTotals();
		Boolean results = sut.displayAccountDetails;

		System.assertEquals(false, results);
	}

	@IsTest
    static void it_should_set_displayAccountDetails_to_true_when_existing_value_is_false() {
        PricingWkst.ExistingAccountsSummary loansSummary = new PricingWkst.ExistingAccountsSummary();
		loansSummary.committedAmount = 111;
		loansSummary.balanceOrFees = 222;
		loansSummary.income = 333;
		loansSummary.loanFees = 444;
		loansSummary.riskExpense = 555;
		loansSummary.adminExpense = 888;
		loansSummary.capitalRequirements = 999;
		PricingWkst.ExistingAccountsSummary depositsSummary = new PricingWkst.ExistingAccountsSummary();
		depositsSummary.committedAmount = 111000;
		depositsSummary.balanceOrFees = 222000;
		depositsSummary.income = 333000;
		depositsSummary.loanFees = 444000;
		depositsSummary.riskExpense = 555000;
		depositsSummary.adminExpense = 888000;
		depositsSummary.capitalRequirements = 999000;
		List<PricingWkst.ExistingAccountsSummary> existAcctSummary = new List<PricingWkst.ExistingAccountsSummary>{loansSummary, depositsSummary};
		PricingWkstResults testResults = new PricingWkstResults();
		testResults.existingAccountsSummaries = existAcctSummary;
		testResults.existingSummary = new PricingWkst.ReturnOnEquitySummary();
		testResults.existingSummary.income = 100;
		testResults.existingSummary.expenses = 20;
		testResults.existingSummary.taxes = 30;
		testResults.existingSummary.capitalRequired = 50;
		testResults.proposalSummary = new PricingWkst.ReturnOnEquitySummary();
		testResults.proposalSummary.income = 100;
		testResults.proposalSummary.expenses = 10;
		testResults.proposalSummary.taxes = 20;
		testResults.proposalSummary.capitalRequired = 35;
		testResults.proposalSummary.returnOnEquity = 20;
		testResults.targetReturnOnEquity = 18;
		PricingWkstComponentROESummary sut = new PricingWkstComponentROESummary();
		sut.pricingResults = testResults;

		sut.updateTotals();
		sut.showAccountDetails();

        Boolean results = sut.displayAccountDetails;

        System.assertEquals(true, results);
    }

    @IsTest
    static void it_should_set_displayAccountDetails_to_false_when_existing_value_is_true() {
        PricingWkst.ExistingAccountsSummary loansSummary = new PricingWkst.ExistingAccountsSummary();
		loansSummary.committedAmount = 111;
		loansSummary.balanceOrFees = 222;
		loansSummary.income = 333;
		loansSummary.loanFees = 444;
		loansSummary.riskExpense = 555;
		loansSummary.adminExpense = 888;
		loansSummary.capitalRequirements = 999;
		PricingWkst.ExistingAccountsSummary depositsSummary = new PricingWkst.ExistingAccountsSummary();
		depositsSummary.committedAmount = 111000;
		depositsSummary.balanceOrFees = 222000;
		depositsSummary.income = 333000;
		depositsSummary.loanFees = 444000;
		depositsSummary.riskExpense = 555000;
		depositsSummary.adminExpense = 888000;
		depositsSummary.capitalRequirements = 999000;
		List<PricingWkst.ExistingAccountsSummary> existAcctSummary = new List<PricingWkst.ExistingAccountsSummary>{loansSummary, depositsSummary};
		PricingWkstResults testResults = new PricingWkstResults();
		testResults.existingAccountsSummaries = existAcctSummary;
		testResults.existingSummary = new PricingWkst.ReturnOnEquitySummary();
		testResults.existingSummary.income = 100;
		testResults.existingSummary.expenses = 20;
		testResults.existingSummary.taxes = 30;
		testResults.existingSummary.capitalRequired = 50;
		testResults.proposalSummary = new PricingWkst.ReturnOnEquitySummary();
		testResults.proposalSummary.income = 100;
		testResults.proposalSummary.expenses = 10;
		testResults.proposalSummary.taxes = 20;
		testResults.proposalSummary.capitalRequired = 35;
		testResults.proposalSummary.returnOnEquity = 20;
		testResults.targetReturnOnEquity = 18;
		PricingWkstComponentROESummary sut = new PricingWkstComponentROESummary();
		sut.pricingResults = testResults;

		sut.updateTotals();
		sut.showAccountDetails();
		sut.hideAccountDetails();

        Boolean results = sut.displayAccountDetails;

        System.assertEquals(false, results);
    }
}