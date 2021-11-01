@IsTest
private class LoanDocPrepDmBuilderTests {

	private static final LoanDocPrepDmBuilder sut;
	private static final LoanDocPrepMock.MockOfIDmBuilderHelper mockDmBuilderHelper;

	static {
		mockDmBuilderHelper = new LoanDocPrepMock.MockOfIDmBuilderHelper();
		sut = new LoanDocPrepDmBuilder(mockDmBuilderHelper);
	}

	@IsTest
    static void it_should_call_the_helper_to_build_first_level_loan_dm() {
		LoanDocPrep.NcinoLoanPm pm = new LoanDocPrep.NcinoLoanPm();
		pm.loanApplication = new LLC_BI__Loan__c();
		pm.loanApplication.Id = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
		DmLoan dm = new DmLoan();
		mockDmBuilderHelper.setup('buildLoan', new List<Object>{pm}).returns(dm);

		sut.build(pm);

		mockDmBuilderHelper.verify('buildLoan', new List<Object>{pm}, Times.Once);
	}

	@IsTest
    static void it_should_call_the_helper_to_get_related_entities() {
		LoanDocPrep.NcinoLoanPm pm = new LoanDocPrep.NcinoLoanPm();
		pm.loanApplication = new LLC_BI__Loan__c();
		pm.loanApplication.Id = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
		LLC_BI__Legal_Entities__c entityRel = new LLC_BI__Legal_Entities__c();
		pm.loanAppEntities = new List<LLC_BI__Legal_Entities__c>{entityRel};
		DmLoan dm = new DmLoan();
		mockDmBuilderHelper.setup('buildLoan', new List<Object>{pm}).returns(dm);

		sut.build(pm);

		mockDmBuilderHelper.verify('buildRelatedEntity', new List<Object>{entityRel}, Times.Once);
	}

	@IsTest
    static void it_should_call_the_helper_to_get_related_collaterals() {
		LoanDocPrep.NcinoLoanPm pm = new LoanDocPrep.NcinoLoanPm();
		pm.loanApplication = new LLC_BI__Loan__c();
		pm.loanApplication.Id = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
		LLC_BI__Loan_Collateral2__c pledge = new LLC_BI__Loan_Collateral2__c();
		List<LLC_BI__Loan_Collateral2__c> pledges = new List<LLC_BI__Loan_Collateral2__c>{pledge};
		pm.loanAppCollaterals = pledges;
		LLC_BI__Account_Collateral__c ownership = new LLC_BI__Account_Collateral__c();
		List<LLC_BI__Account_Collateral__c> ownerships = new List<LLC_BI__Account_Collateral__c>{ownership};
		pm.loanAppCollateralOwnerships = ownerships;
		DmLoan dm = new DmLoan();
		mockDmBuilderHelper.setup('buildLoan', new List<Object>{pm}).returns(dm);

		sut.build(pm);

		mockDmBuilderHelper.verify('buildRelatedCollateral', new List<Object>{pledge, ownerships}, Times.Once);
	}

	@IsTest
    static void it_should_call_the_helper_to_get_the_fees() {
		LoanDocPrep.NcinoLoanPm pm = new LoanDocPrep.NcinoLoanPm();
		pm.loanApplication = new LLC_BI__Loan__c();
		pm.loanApplication.Id = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
		DmLoan dm = new DmLoan();
		LLC_BI__Fee__c fee = new LLC_BI__Fee__c();
		pm.loanAppFees = new List<LLC_BI__Fee__c>{fee};
		mockDmBuilderHelper.setup('buildLoan', new List<Object>{pm}).returns(dm);
		mockDmBuilderHelper.setup('buildFee', new List<Object>{fee}).returns(new DmFee());

		sut.build(pm);

		mockDmBuilderHelper.verify('buildFee', new List<Object>{fee}, Times.Once);
	}
}