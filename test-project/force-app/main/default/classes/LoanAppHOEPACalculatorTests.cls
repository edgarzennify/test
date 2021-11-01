@isTest
private class LoanAppHOEPACalculatorTests {
	
	private static final Mock.ofILoanAppWrapper mockLoanApp;
	private static final LoanAppHOEPACalculator sut;

	static {
		mockLoanApp = new Mock.ofILoanAppWrapper();
		sut = new LoanAppHOEPACalculator();
	}

	private static testMethod void it_should_be_HOEPA_when_it_is_hoepa_loan_type_is_not_business_purpose_is_not_hoepa_purpose_to_finance_init_const_of_principal_dwelling_and_has_real_estate_collateral() {
		mockLoanApp.setup('isHOEPAEligibleLoanType').returns(true);
		mockLoanApp.setup('isBusinessPurpose').returns(false);
		mockLoanApp.setup('isHOEPAPurposeToFinanceInitialConstructionOfPrincipalDwelling').returns(false);
		mockLoanApp.setup('hasRealEstateCollateral').returns(true);

		Boolean returnedHOEPADetermination = sut.DetermineIfHOEPA(mockLoanApp);

		System.assertEquals(true,returnedHOEPADetermination);
	}

	private static testMethod void it_should_not_be_HOEPA_when_it_is_not_hoepa_loan_type() {
		mockLoanApp.setup('isHOEPAEligibleLoanType').returns(false);
		mockLoanApp.setup('isBusinessPurpose').returns(false);
		mockLoanApp.setup('isHOEPAPurposeToFinanceInitialConstructionOfPrincipalDwelling').returns(false);
		mockLoanApp.setup('hasRealEstateCollateral').returns(true);

		Boolean returnedHOEPADetermination = sut.DetermineIfHOEPA(mockLoanApp);

		System.assertEquals(false,returnedHOEPADetermination);
	}
	
	private static testMethod void it_should_not_be_HOEPA_when_it_is_business_purpose() {
		mockLoanApp.setup('isHOEPAEligibleLoanType').returns(true);
		mockLoanApp.setup('isBusinessPurpose').returns(true);
		mockLoanApp.setup('isHOEPAPurposeToFinanceInitialConstructionOfPrincipalDwelling').returns(false);
		mockLoanApp.setup('hasRealEstateCollateral').returns(true);

		Boolean returnedHOEPADetermination = sut.DetermineIfHOEPA(mockLoanApp);

		System.assertEquals(false,returnedHOEPADetermination);
	}

	private static testMethod void it_should_not_be_HOEPA_when_it_is_hoepa_purpose_to_finance_init_const_of_principal_dwelling() {
		mockLoanApp.setup('isHOEPAEligibleLoanType').returns(true);
		mockLoanApp.setup('isBusinessPurpose').returns(false);
		mockLoanApp.setup('isHOEPAPurposeToFinanceInitialConstructionOfPrincipalDwelling').returns(true);
		mockLoanApp.setup('hasRealEstateCollateral').returns(true);

		Boolean returnedHOEPADetermination = sut.DetermineIfHOEPA(mockLoanApp);

		System.assertEquals(false,returnedHOEPADetermination);
	}

	private static testMethod void it_should_not_be_HOEPA_when_it_is_has_no_real_estate_collateral() {
		mockLoanApp.setup('isHOEPAEligibleLoanType').returns(true);
		mockLoanApp.setup('isBusinessPurpose').returns(false);
		mockLoanApp.setup('isHOEPAPurposeToFinanceInitialConstructionOfPrincipalDwelling').returns(false);
		mockLoanApp.setup('hasRealEstateCollateral').returns(false);

		Boolean returnedHOEPADetermination = sut.DetermineIfHOEPA(mockLoanApp);

		System.assertEquals(false,returnedHOEPADetermination);
	}


	
}