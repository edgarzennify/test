@isTest
private class LoanAppHMDACalculatorTests {

	private static final Mock.ofILoanAppWrapper mockLoanApp;
	private static final LoanAppHMDACalculator sut;

	static {
		mockLoanApp = new Mock.ofILoanAppWrapper();
		sut = new LoanAppHMDACalculator();
	}

	private static testMethod void it_should_not_be_HMDA_if_loan_type_is_Home_equity_line(){
		mockLoanApp.setup('isHMDAEligibleLoanType').returns(false);
		mockLoanApp.setup('isHomeImprovement').returns(true);
		mockLoanApp.setup('isResidentialRehab').returns(true);
		mockLoanApp.setup('isPurchaseResidentialRealEstate').returns(true);
		mockLoanApp.setup('hasDwellingCollateral').returns(true);
		mockLoanApp.setup('isRefinanceResidentialRealEstate').returns(true);
		mockLoanApp.setup('isRefinanceToPayoffExistingDebtBySameBorrower').returns(true);
	
		Boolean returnedHMDADetermination = sut.DetermineIfHMDA(mockLoanApp);

		System.assertEquals(false,returnedHMDADetermination);		
	}

	private static testMethod void it_should_be_HMDA_if_it_is_home_improvement_and_not_home_equity_line(){
		mockLoanApp.setup('isHMDAEligibleLoanType').returns(true);
		mockLoanApp.setup('isHomeImprovement').returns(true);
		mockLoanApp.setup('isResidentialRehab').returns(false);
		mockLoanApp.setup('isPurchaseResidentialRealEstate').returns(false);
		mockLoanApp.setup('hasDwellingCollateral').returns(false);
		mockLoanApp.setup('isRefinanceResidentialRealEstate').returns(false);
		mockLoanApp.setup('isRefinanceToPayoffExistingDebtBySameBorrower').returns(false);

		Boolean returnedHMDADetermination = sut.DetermineIfHMDA(mockLoanApp);

		System.assertEquals(true,returnedHMDADetermination);		
	}

	private static testMethod void it_should_be_HMDA_if_it_is_residential_rehab_and_not_home_equity_line(){
		mockLoanApp.setup('isHMDAEligibleLoanType').returns(true);
		mockLoanApp.setup('isHomeImprovement').returns(false);
		mockLoanApp.setup('isResidentialRehab').returns(true);
		mockLoanApp.setup('isPurchaseResidentialRealEstate').returns(false);
		mockLoanApp.setup('hasDwellingCollateral').returns(false);
		mockLoanApp.setup('isRefinanceResidentialRealEstate').returns(false);
		mockLoanApp.setup('isRefinanceToPayoffExistingDebtBySameBorrower').returns(false);

		Boolean returnedHMDADetermination = sut.DetermineIfHMDA(mockLoanApp);

		System.assertEquals(true,returnedHMDADetermination);		
	}

	private static testMethod void it_should_be_HMDA_if_it_is_purchase_residential_real_estate_and_has_dwelling_collateral_and_not_home_equity_line(){
		mockLoanApp.setup('isHMDAEligibleLoanType').returns(true);
		mockLoanApp.setup('isHomeImprovement').returns(false);
		mockLoanApp.setup('isResidentialRehab').returns(false);
		mockLoanApp.setup('isPurchaseResidentialRealEstate').returns(true);
		mockLoanApp.setup('hasDwellingCollateral').returns(true);
		mockLoanApp.setup('isRefinanceResidentialRealEstate').returns(false);
		mockLoanApp.setup('isRefinanceToPayoffExistingDebtBySameBorrower').returns(false);

		Boolean returnedHMDADetermination = sut.DetermineIfHMDA(mockLoanApp);

		System.assertEquals(true,returnedHMDADetermination);		
	}

	private static testMethod void it_should_be_HMDA_if_it_is_refinance_residential_real_estate_and_refinance_is_to_payoff_existing_debt_by_same_borrower_and_not_home_equity_line(){
		mockLoanApp.setup('isHMDAEligibleLoanType').returns(true);
		mockLoanApp.setup('isHomeImprovement').returns(false);
		mockLoanApp.setup('isResidentialRehab').returns(false);
		mockLoanApp.setup('isPurchaseResidentialRealEstate').returns(false);
		mockLoanApp.setup('hasDwellingCollateral').returns(false);
		mockLoanApp.setup('isRefinanceResidentialRealEstate').returns(true);
		mockLoanApp.setup('isRefinanceToPayoffExistingDebtBySameBorrower').returns(true);

		Boolean returnedHMDADetermination = sut.DetermineIfHMDA(mockLoanApp);

		System.assertEquals(true,returnedHMDADetermination);		
	}

	private static testMethod void it_should_not_be_HMDA_if_it_is_not_home_equity_line_and_not_home_improvement_and_not_residential_rehab_and_not_purchased_residential_real_estate_and_not_refinance_residential_real_estate(){
		mockLoanApp.setup('isHMDAEligibleLoanType').returns(true);
		mockLoanApp.setup('isHomeImprovement').returns(false);
		mockLoanApp.setup('isResidentialRehab').returns(false);
		mockLoanApp.setup('isPurchaseResidentialRealEstate').returns(false);
		mockLoanApp.setup('hasDwellingCollateral').returns(true);
		mockLoanApp.setup('isRefinanceResidentialRealEstate').returns(false);
		mockLoanApp.setup('isRefinanceToPayoffExistingDebtBySameBorrower').returns(true);

		Boolean returnedHMDADetermination = sut.DetermineIfHMDA(mockLoanApp);

		System.assertEquals(false,returnedHMDADetermination);		
	}

	private static testMethod void it_should_not_be_HMDA_if_it_is_not_home_equity_line_and_not_home_improvement_and_not_residential_rehab_and_not_dwelling_collateral_and_not_refinance_residential_real_estate(){
		mockLoanApp.setup('isHMDAEligibleLoanType').returns(true);
		mockLoanApp.setup('isHomeImprovement').returns(false);
		mockLoanApp.setup('isResidentialRehab').returns(false);
		mockLoanApp.setup('isPurchaseResidentialRealEstate').returns(true);
		mockLoanApp.setup('hasDwellingCollateral').returns(false);
		mockLoanApp.setup('isRefinanceResidentialRealEstate').returns(false);
		mockLoanApp.setup('isRefinanceToPayoffExistingDebtBySameBorrower').returns(true);

		Boolean returnedHMDADetermination = sut.DetermineIfHMDA(mockLoanApp);

		System.assertEquals(false,returnedHMDADetermination);		
	}

	private static testMethod void it_should_not_be_HMDA_if_it_is_not_home_equity_line_and_not_home_improvement_and_not_residential_rehab_and_not_purchased_residential_real_estate_and_not_refinance_to_payoff_existing_debt_by_same_borrower(){
		mockLoanApp.setup('isHMDAEligibleLoanType').returns(true);
		mockLoanApp.setup('isHomeImprovement').returns(false);
		mockLoanApp.setup('isResidentialRehab').returns(false);
		mockLoanApp.setup('isPurchaseResidentialRealEstate').returns(false);
		mockLoanApp.setup('hasDwellingCollateral').returns(true);
		mockLoanApp.setup('isRefinanceResidentialRealEstate').returns(true);
		mockLoanApp.setup('isRefinanceToPayoffExistingDebtBySameBorrower').returns(false);

		Boolean returnedHMDADetermination = sut.DetermineIfHMDA(mockLoanApp);

		System.assertEquals(false,returnedHMDADetermination);		
	}

	private static testMethod void it_should_not_be_HMDA_if_it_is_not_home_equity_line_and_not_home_improvement_and_not_residential_rehab_and_not_dwelling_collateral_real_estate_and_not_refinance_to_payoff_existing_debt_by_same_borrower(){
		mockLoanApp.setup('isHMDAEligibleLoanType').returns(true);
		mockLoanApp.setup('isHomeImprovement').returns(false);
		mockLoanApp.setup('isResidentialRehab').returns(false);
		mockLoanApp.setup('isPurchaseResidentialRealEstate').returns(true);
		mockLoanApp.setup('hasDwellingCollateral').returns(false);
		mockLoanApp.setup('isRefinanceResidentialRealEstate').returns(true);
		mockLoanApp.setup('isRefinanceToPayoffExistingDebtBySameBorrower').returns(false);

		Boolean returnedHMDADetermination = sut.DetermineIfHMDA(mockLoanApp);

		System.assertEquals(false,returnedHMDADetermination);		
	}


	
}