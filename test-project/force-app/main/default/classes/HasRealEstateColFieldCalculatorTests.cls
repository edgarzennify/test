@IsTest
private class HasRealEstateColFieldCalculatorTests {

    private static HasRealEstateColFieldCalculator sut;

    static {
        sut = new HasRealEstateColFieldCalculator();
    }

    @IsTest 
    static void it_should_update_the_HasRealEstateCollateral_field_to_true_when_any_related_collateral_is_real_estate() {
		Id loanId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
		LLC_BI__Loan__c ln = new LLC_BI__Loan__c(Id = loanId);
        List<LLC_BI__Loan__c> loans = new List<LLC_BI__Loan__c>{ln};

		LLC_BI__Collateral_Type__c realEstateType = new LLC_BI__Collateral_Type__c();
        realEstateType.Collateral_Record_Type__c = 'Real Estate';
		LLC_BI__Collateral__c realEstateCollateral = new LLC_BI__Collateral__c();
		realEstateCollateral.LLC_BI__Collateral_Type__r = realEstateType;
		LLC_BI__Loan_Collateral2__c realEstatePledge = new LLC_BI__Loan_Collateral2__c();
        realEstatePledge.LLC_BI__Loan__c = loanId;
		realEstatePledge.LLC_BI__Collateral__r = realEstateCollateral;

        LLC_BI__Collateral_Type__c otherCollateralType = new LLC_BI__Collateral_Type__c();
        otherCollateralType.Collateral_Record_Type__c = 'asdf';
		LLC_BI__Collateral__c otherCollateral = new LLC_BI__Collateral__c();
		otherCollateral.LLC_BI__Collateral_Type__r = otherCollateralType;
		LLC_BI__Loan_Collateral2__c otherPledge = new LLC_BI__Loan_Collateral2__c();
        otherPledge.LLC_BI__Loan__c = loanId;
		otherPledge.LLC_BI__Collateral__r = otherCollateral;

		List<LLC_BI__Loan_Collateral2__c> pledges = new List<LLC_BI__Loan_Collateral2__c>{realEstatePledge,  otherPledge};

		sut.calculate(loans, pledges);

		System.assertEquals(true, ln.HasRealEstateCollateral__c);
	}

	@IsTest
    static void it_should_update_the_HasRealEstateCollateral_field_to_false_when_no_related_collateral_is_real_estate() {
		Id loanId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
		LLC_BI__Loan__c ln = new LLC_BI__Loan__c(Id = loanId);
        List<LLC_BI__Loan__c> loans = new List<LLC_BI__Loan__c>{ln};

        LLC_BI__Collateral_Type__c otherCollateralType = new LLC_BI__Collateral_Type__c();
        otherCollateralType.Collateral_Record_Type__c = 'asdf';
		LLC_BI__Collateral__c otherCollateral = new LLC_BI__Collateral__c();
		otherCollateral.LLC_BI__Collateral_Type__r = otherCollateralType;
		LLC_BI__Loan_Collateral2__c otherPledge = new LLC_BI__Loan_Collateral2__c();
        otherPledge.LLC_BI__Loan__c = loanId;
		otherPledge.LLC_BI__Collateral__r = otherCollateral;

		List<LLC_BI__Loan_Collateral2__c> pledges = new List<LLC_BI__Loan_Collateral2__c>{otherPledge,  otherPledge};

		sut.calculate(loans, pledges);

		System.assertEquals(false, ln.HasRealEstateCollateral__c);
	}

    @IsTest
    static void it_should_update_the_HasRealEstateCollateral_field_to_false_when_there_is_no_collateral() {
		Id loanId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
		LLC_BI__Loan__c ln = new LLC_BI__Loan__c(Id = loanId);
        List<LLC_BI__Loan__c> loans = new List<LLC_BI__Loan__c>{ln};

		List<LLC_BI__Loan_Collateral2__c> pledges = new List<LLC_BI__Loan_Collateral2__c>();

		sut.calculate(loans, pledges);

		System.assertEquals(false, ln.HasRealEstateCollateral__c);
	}
}