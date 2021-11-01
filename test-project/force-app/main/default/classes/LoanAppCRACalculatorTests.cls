@isTest
private class LoanAppCRACalculatorTests {
	
	private static final Mock.ofILoanAppWrapper mockLoanApp;
	private static final LoanAppCRACalculator sut;

	static {
		mockLoanApp = new Mock.ofILoanAppWrapper();
		sut = new LoanAppCRACalculator();
	}

	public static testMethod void it_should_be_CRA_Eligible_when_Use_of_Funds_is_Agricultural_Purpose_and_Loan_Amount_les_than_500k_and_has_not_purchased_participations()
	{
		mockLoanApp.setup('isCRAEligibleLoanType').Returns(true);
        mockLoanApp.setup('isCRAEligibleRecordType').Returns(true);
        mockLoanApp.setup('hasCRAEligibleCollateral').Returns(true);
		mockLoanApp.setup('isModificationWithoutIncreasedLoanAmount').Returns(false);
		mockLoanApp.setup('isAgriculturalPurpose').Returns(true);
		mockLoanApp.setup('isLoanAmountOver500K').Returns(false);
		mockLoanApp.setup('hasPurchasedParticipation').Returns(false);

		Boolean returnedCRADetermination = sut.DetermineIfCRA(mockLoanApp);

		System.assertEquals(true,returnedCRADetermination);
	}

	public static testMethod void it_should_be_CRA_Eligible_when_Use_of_Funds_is_Agricultural_Purpose_and_Loan_Amount_les_than_500k_and_has_purchased_participations_and_orig_loan_amt_less_than_500K()
	{
		mockLoanApp.setup('isCRAEligibleLoanType').Returns(true);
        mockLoanApp.setup('isCRAEligibleRecordType').Returns(true);
        mockLoanApp.setup('hasCRAEligibleCollateral').Returns(true);
		mockLoanApp.setup('isModificationWithoutIncreasedLoanAmount').Returns(false);
		mockLoanApp.setup('isAgriculturalPurpose').Returns(true);
		mockLoanApp.setup('isLoanAmountOver500K').Returns(false);
		mockLoanApp.setup('hasPurchasedParticipation').Returns(true);
		mockLoanApp.setup('isOriginalLoanAmountOver500K').Returns(false);

		Boolean returnedCRADetermination = sut.DetermineIfCRA(mockLoanApp);

		System.assertEquals(true,returnedCRADetermination);
	}

	public static testMethod void it_should_be_CRA_Eligible_when_is_not_Agricultural_and_loan_is_busines_purpose_and_loan_amt_less_than_1M_and_has_participations_and_orig_loan_amt_less_1M_and_is_not_letter_of_credit_not_commercial_RE_and_not_to_buy_securities()
	{
		mockLoanApp.setup('isCRAEligibleLoanType').Returns(true);
        mockLoanApp.setup('isCRAEligibleRecordType').Returns(true);
        mockLoanApp.setup('hasCRAEligibleCollateral').Returns(true);
		mockLoanApp.setup('isModificationWithoutIncreasedLoanAmount').Returns(false);
		mockLoanApp.setup('isAgriculturalPurpose').Returns(false);
		mockLoanApp.setup('isBusinessPurpose').Returns(true);
		mockLoanApp.setup('isLoanAmountOver1M').Returns(false);
		mockLoanApp.setup('hasPurchasedParticipation').Returns(true);
		mockLoanApp.setup('isOriginalLoanAmountOver1M').Returns(false);
		mockLoanApp.setup('isLetterOfCredit').Returns(false);
		mockLoanApp.setup('hasRealEstateCollateral').Returns(false);
		mockLoanApp.setup('isPurposeOfLoanToBuySecurities').Returns(false);

		Boolean returnedCRADetermination = sut.DetermineIfCRA(mockLoanApp);

		System.assertEquals(true,returnedCRADetermination);
	}

	public static testMethod void it_should_be_CRA_Eligible_when_is_not_Agricultural_and_loan_is_busines_purpose_and_loan_amt_less_than_1M_and_has_not_participations_and_is_not_letter_of_credit_not_commercial_RE_and_not_to_buy_securities()
	{
		mockLoanApp.setup('isCRAEligibleLoanType').Returns(true);
        mockLoanApp.setup('isCRAEligibleRecordType').Returns(true);
        mockLoanApp.setup('hasCRAEligibleCollateral').Returns(true);
		mockLoanApp.setup('isModificationWithoutIncreasedLoanAmount').Returns(false);
		mockLoanApp.setup('isAgriculturalPurpose').Returns(false);
		mockLoanApp.setup('isBusinessPurpose').Returns(true);
		mockLoanApp.setup('isLoanAmountOver1M').Returns(false);
		mockLoanApp.setup('hasPurchasedParticipation').Returns(false);		
		mockLoanApp.setup('isLetterOfCredit').Returns(false);
		mockLoanApp.setup('hasRealEstateCollateral').Returns(false);
		mockLoanApp.setup('isPurposeOfLoanToBuySecurities').Returns(false);

		Boolean returnedCRADetermination = sut.DetermineIfCRA(mockLoanApp);

		System.assertEquals(true,returnedCRADetermination);
	}

	public static testMethod void it_should_be_CRA_Eligible_when_is_not_Agricultural_and_loan_is_busines_purpose_and_loan_amt_less_than_1M_and_has_participations_and_orig_loan_amt_less_1M_and_is_not_letter_of_credit_has_commercial_RE_and_not_construction_land_dev()
	{
		mockLoanApp.setup('isCRAEligibleLoanType').Returns(true);
        mockLoanApp.setup('isCRAEligibleRecordType').Returns(true);
        mockLoanApp.setup('hasCRAEligibleCollateral').Returns(true);
		mockLoanApp.setup('isModificationWithoutIncreasedLoanAmount').Returns(false);
		mockLoanApp.setup('isAgriculturalPurpose').Returns(false);
		mockLoanApp.setup('isBusinessPurpose').Returns(true);
		mockLoanApp.setup('isLoanAmountOver1M').Returns(false);
		mockLoanApp.setup('hasPurchasedParticipation').Returns(true);
		mockLoanApp.setup('isOriginalLoanAmountOver1M').Returns(false);
		mockLoanApp.setup('isLetterOfCredit').Returns(false);
		mockLoanApp.setup('hasRealEstateCollateral').Returns(true);
		mockLoanApp.setup('isConstructionLandDevelopment').Returns(false);
		mockLoanApp.setup('hasNonCommercialRealEstateCollateral').Returns(false);

		Boolean returnedCRADetermination = sut.DetermineIfCRA(mockLoanApp);

		System.assertEquals(true,returnedCRADetermination);
	}

	public static testMethod void it_should_be_CRA_Eligible_when_is_not_Agricultural_and_loan_is_busines_purpose_and_loan_amt_less_than_1M_and_has_not_participations_and_is_not_letter_of_credit_and_is_commercial_RE_and_not_constr_land_dev_and_not_commerc_re_coll()
	{
		mockLoanApp.setup('isCRAEligibleLoanType').Returns(true);
        mockLoanApp.setup('isCRAEligibleRecordType').Returns(true);
        mockLoanApp.setup('hasCRAEligibleCollateral').Returns(true);
		mockLoanApp.setup('isModificationWithoutIncreasedLoanAmount').Returns(false);
		mockLoanApp.setup('isAgriculturalPurpose').Returns(false);
		mockLoanApp.setup('isBusinessPurpose').Returns(true);
		mockLoanApp.setup('isLoanAmountOver1M').Returns(false);
		mockLoanApp.setup('hasPurchasedParticipation').Returns(false);
		mockLoanApp.setup('isLetterOfCredit').Returns(false);
		mockLoanApp.setup('hasRealEstateCollateral').Returns(true);
		mockLoanApp.setup('isConstructionLandDevelopment').Returns(false);
		mockLoanApp.setup('hasNonCommercialRealEstateCollateral').Returns(false);

		Boolean returnedCRADetermination = sut.DetermineIfCRA(mockLoanApp);

		System.assertEquals(true,returnedCRADetermination);
	}

	private static testMethod void it_should_not_be_CRA_Eligible_when_above_conditions_are_not_met() {
		mockLoanApp.setup('isCRAEligibleLoanType').Returns(true);
        mockLoanApp.setup('isCRAEligibleRecordType').Returns(true);
        mockLoanApp.setup('hasCRAEligibleCollateral').Returns(true);
		mockLoanApp.setup('isModificationWithoutIncreasedLoanAmount').Returns(true);
		mockLoanApp.setup('isAgriculturalPurpose').Returns(false);
		mockLoanApp.setup('isBusinessPurpose').Returns(true);
		mockLoanApp.setup('isLoanAmountOver1M').Returns(false);
		mockLoanApp.setup('hasPurchasedParticipation').Returns(false);
		mockLoanApp.setup('isLetterOfCredit').Returns(false);
		mockLoanApp.setup('hasRealEstateCollateral').Returns(true);
		mockLoanApp.setup('isConstructionLandDevelopment').Returns(false);
		mockLoanApp.setup('hasNonCommercialRealEstateCollateral').Returns(false);

		Boolean returnedCRADetermination = sut.DetermineIfCRA(mockLoanApp);

		System.assertEquals(false,returnedCRADetermination);
	}
	
}