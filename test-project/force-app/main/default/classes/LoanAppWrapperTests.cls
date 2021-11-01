@IsTest
private class LoanAppWrapperTests {

	private static final EB_Loan_Application__c testLoanApplication;
	private static final MockofILoanAppWrapperHelper mockFormulaHelper;
	private static final LoanAppWrapper sut;

	static {
		testLoanApplication = new EB_Loan_Application__c(Id = ObjectFactory.getFakeId(EB_Loan_Application__c.getSObjectType(),'1'));
		mockFormulaHelper = new MockofILoanAppWrapperHelper();
		sut = new LoanAppWrapper(testLoanApplication, mockFormulaHelper);
	}

	@IsTest
    static void it_should_return_true_when_loan_application_record_type_is_new() {
		testLoanApplication.RecordType = Utility.recordTypeObject('EB_Loan_Application__c','New');

		Boolean returnedResult = sut.isCRAEligibleRecordType();
        
		System.assertEquals(true, returnedResult);
	}

	@IsTest
    static void it_should_return_true_when_loan_application_record_type_is_admin_renewal() {
		testLoanApplication.RecordType = Utility.recordTypeObject('EB_Loan_Application__c','Admin Renewal');

		Boolean returnedResult = sut.isCRAEligibleRecordType();
        
		System.assertEquals(true, returnedResult);
	}

	@IsTest
    static void it_should_return_true_when_loan_application_record_type_is_modification_full() {
		testLoanApplication.RecordType = Utility.recordTypeObject('EB_Loan_Application__c','Modification - Full');

		Boolean returnedResult = sut.isCRAEligibleRecordType();
        
		System.assertEquals(true, returnedResult);
	}
    
	@IsTest
    static void it_should_return_true_when_loan_application_record_type_is_new_guidance_line_advance() {
		testLoanApplication.RecordType = Utility.recordTypeObject('EB_Loan_Application__c','New - Guidance Line Advance');

		Boolean returnedResult = sut.isCRAEligibleRecordType();
        
		System.assertEquals(true, returnedResult);
	}

	@IsTest
    static void it_should_return_true_when_loan_application_record_type_is_renewal() {
		testLoanApplication.RecordType = Utility.recordTypeObject('EB_Loan_Application__c','Renewal');

		Boolean returnedResult = sut.isCRAEligibleRecordType();
        
		System.assertEquals(true, returnedResult);
	}
	
	@IsTest
    static void it_should_return_true_when_loan_application_record_type_is_renewal_modification() {
		testLoanApplication.RecordType = Utility.recordTypeObject('EB_Loan_Application__c','Renewal/Modification');

		Boolean returnedResult = sut.isCRAEligibleRecordType();
        
		System.assertEquals(true, returnedResult);
	}
    
    @IsTest
    static void it_should_return_false_when_loan_application_record_type_is_modification_change_guarantor() {
		testLoanApplication.RecordType = Utility.recordTypeObject('EB_Loan_Application__c','Modification - Change Guarantor');

		Boolean returnedResult = sut.isCRAEligibleRecordType();
        
		System.assertEquals(false, returnedResult);
	}
    
    @IsTest
    static void it_should_be_cra_eligible_loan_type_when_loan_type_is_fixed_line() {
		testLoanApplication.Loan_Type__c = 'Fixed Line';

		Boolean returnedValue = sut.isCRAEligibleLoanType();
        
		System.assertEquals(true, returnedValue);
	}

	@IsTest
    static void it_should_not_be_cra_eligible_loan_type_when_loan_type_is_home_equity_line() {
		testLoanApplication.Loan_Type__c = 'Home Equity Line';

		Boolean returnedValue = sut.isCRAEligibleLoanType();
        
		System.assertEquals(false, returnedValue);
	}

	@IsTest
    static void it_should_not_be_cra_eligible_loan_type_when_loan_type_is_guidance_line() {
		testLoanApplication.Loan_Type__c = 'Guidance Line - Fixed';

		Boolean returnedValue = sut.isCRAEligibleLoanType();
        
		System.assertEquals(false, returnedValue);
	}

	@IsTest
    static void it_should_not_be_cra_eligible_loan_type_when_loan_type_is_guidance_line_revolving() {
		testLoanApplication.Loan_Type__c = 'Guidance Line - Revolving';

		Boolean returnedValue = sut.isCRAEligibleLoanType();
        
		System.assertEquals(false, returnedValue);
	}

	@IsTest
    static void it_should_return_true_when_use_of_fund_is_set_to_agricultural_purpose()	{
		testLoanApplication.Use_of_Funds__c = 'Agricultural Purpose';

		Boolean returnedAgriculturalPurposeStatus = sut.IsAgriculturalPurpose();

		System.assertEquals(true, returnedAgriculturalPurposeStatus);
	}
	
	@IsTest
    static void it_should_return_false_when_use_of_fund_is_set_to_agricultural_purpose() {
		testLoanApplication.Use_of_Funds__c = 'Not Agricultural Purpose';

		Boolean returnedAgriculturalPurposeStatus = sut.IsAgriculturalPurpose();

		System.assertEquals(false, returnedAgriculturalPurposeStatus);
	}

	@IsTest
    static void it_should_return_true_when_all_residential_real_estate_collateral_is_taken_as_abundance_of_caution() {
		Collateral_Code__c testCollCode1 = new Collateral_Code__c(Category__c = 'Possessory',IsHMDADwelling__c = false, CRA_Real_Estate_Details__c = 'Non-Commercial');
		Collateral_Code__c testCollCode2 = new Collateral_Code__c(Category__c = 'Real Estate',IsHMDADwelling__c = false, CRA_Real_Estate_Details__c = 'Non-Commercial');
		Collateral_Code__c testCollCode3 = new Collateral_Code__c(Category__c = 'Real Estate',IsHMDADwelling__c = false, CRA_Real_Estate_Details__c = 'Non-Commercial');
		EB_Collateral__c testCollateral1 = new EB_Collateral__c (Collateral_Code__r = testCollCode1);
		EB_Collateral__c testCollateral2 = new EB_Collateral__c (Collateral_Code__r = testCollCode2);
		EB_Collateral__c testCollateral3 = new EB_Collateral__c (Collateral_Code__r = testCollCode3);		
		EB_Loan_App_Collateral_Relationship__c rel1 = new EB_Loan_App_Collateral_Relationship__c(EB_Collateral_ID__r =testCollateral1, Abundance_of_Caution__c='No' );
		EB_Loan_App_Collateral_Relationship__c rel2 = new EB_Loan_App_Collateral_Relationship__c(EB_Collateral_ID__r =testCollateral2, Abundance_of_Caution__c='Yes' );
		EB_Loan_App_Collateral_Relationship__c rel3 = new EB_Loan_App_Collateral_Relationship__c(EB_Collateral_ID__r =testCollateral3, Abundance_of_Caution__c='Yes' );
		mockFormulaHelper.setup('getLoanAppToCollateralRelationships', new List<Object>{testLoanApplication}).Returns(new List<EB_Loan_App_Collateral_Relationship__c>{rel1,rel2});

		Boolean status = sut.isAllResidentialRealEstateCollateralTakenAsAbundanceOfCaution();

		mockFormulaHelper.verify('getLoanAppToCollateralRelationships', new List<Object>{testLoanApplication}, Times.Once);
		System.assertEquals(true,status);
	}

	@IsTest
    static void it_should_return_false_when_not_all_residential_real_estate_collateral_is_taken_as_abundance_of_caution() {
		Collateral_Code__c testCollCode1 = new Collateral_Code__c(Category__c = 'Possessory',IsHMDADwelling__c = false, CRA_Real_Estate_Details__c = 'Non-Commercial');
		Collateral_Code__c testCollCode2 = new Collateral_Code__c(Category__c = 'Real Estate',IsHMDADwelling__c = false, CRA_Real_Estate_Details__c = 'Non-Commercial');
		Collateral_Code__c testCollCode3 = new Collateral_Code__c(Category__c = 'Real Estate',IsHMDADwelling__c = false, CRA_Real_Estate_Details__c = 'Non-Commercial');
		EB_Collateral__c testCollateral1 = new EB_Collateral__c (Collateral_Code__r = testCollCode1);
		EB_Collateral__c testCollateral2 = new EB_Collateral__c (Collateral_Code__r = testCollCode2);
		EB_Collateral__c testCollateral3 = new EB_Collateral__c (Collateral_Code__r = testCollCode3);	
		EB_Loan_App_Collateral_Relationship__c rel1 = new EB_Loan_App_Collateral_Relationship__c(EB_Collateral_ID__r =testCollateral1, Abundance_of_Caution__c='No' );
		EB_Loan_App_Collateral_Relationship__c rel2 = new EB_Loan_App_Collateral_Relationship__c(EB_Collateral_ID__r =testCollateral2, Abundance_of_Caution__c='Yes' );
		EB_Loan_App_Collateral_Relationship__c rel3 = new EB_Loan_App_Collateral_Relationship__c(EB_Collateral_ID__r =testCollateral3, Abundance_of_Caution__c='No' );
		mockFormulaHelper.setup('getLoanAppToCollateralRelationships', new List<Object>{testLoanApplication}).Returns(new List<EB_Loan_App_Collateral_Relationship__c>{rel1,rel2, rel3});

		Boolean status = sut.isAllResidentialRealEstateCollateralTakenAsAbundanceOfCaution();

		mockFormulaHelper.verify('getLoanAppToCollateralRelationships', new List<Object>{testLoanApplication}, Times.Once);
		System.assertEquals(false,status);
	}

	@IsTest
    static void it_should_return_false_when_any_of_related_collateral_has_collateral_code_47() {
		Collateral_Code__c testCollCode1 = new Collateral_Code__c(Collateral_Code_ID__c = '47',Category__c = 'Real Estate',IsHMDADwelling__c = false, CRA_Real_Estate_Details__c = 'Non-Commercial');
		Collateral_Code__c testCollCode2 = new Collateral_Code__c(Collateral_Code_ID__c = '54',Category__c = 'Real Estate',IsHMDADwelling__c = false, CRA_Real_Estate_Details__c = 'Commercial');
		EB_Collateral__c testCollateral1 = new EB_Collateral__c (Collateral_Code__r = testCollCode1);
		EB_Collateral__c testCollateral2 = new EB_Collateral__c (Collateral_Code__r = testCollCode2);	
		mockFormulaHelper.setup('getRelatedCollateralsForLoanApp', new List<Object>{testLoanApplication}).Returns(new List<EB_Collateral__c>{testCollateral1,testCollateral2});

		Boolean status =sut.hasCRAEligibleCollateral();

		mockFormulaHelper.verify('getRelatedCollateralsForLoanApp',new List<Object>{testLoanApplication}, Times.Once);
		System.assertEquals(false,status);
	}

	@IsTest
    static void it_should_return_false_when_any_of_related_collateral_has_collateral_code_55() {
		Collateral_Code__c testCollCode1 = new Collateral_Code__c(Collateral_Code_ID__c = '55',Category__c = 'Real Estate',IsHMDADwelling__c = false, CRA_Real_Estate_Details__c = 'Commercial');
		Collateral_Code__c testCollCode2 = new Collateral_Code__c(Collateral_Code_ID__c = '54',Category__c = 'Real Estate',IsHMDADwelling__c = false, CRA_Real_Estate_Details__c = 'Commercial');
		EB_Collateral__c testCollateral1 = new EB_Collateral__c (Collateral_Code__r = testCollCode1);
		EB_Collateral__c testCollateral2 = new EB_Collateral__c (Collateral_Code__r = testCollCode2);	
		mockFormulaHelper.setup('getRelatedCollateralsForLoanApp', new List<Object>{testLoanApplication}).Returns(new List<EB_Collateral__c>{testCollateral1,testCollateral2});

		Boolean status =sut.hasCRAEligibleCollateral();

		mockFormulaHelper.verify('getRelatedCollateralsForLoanApp',new List<Object>{testLoanApplication}, Times.Once);
		System.assertEquals(false,status);
	}

	@IsTest
    static void it_should_return_false_when_any_of_related_collateral_has_collateral_code_52() {
		Collateral_Code__c testCollCode1 = new Collateral_Code__c(Collateral_Code_ID__c = '52',Category__c = 'Real Estate',IsHMDADwelling__c = false, CRA_Real_Estate_Details__c = 'Commercial');
		Collateral_Code__c testCollCode2 = new Collateral_Code__c(Collateral_Code_ID__c = '54',Category__c = 'Real Estate',IsHMDADwelling__c = false, CRA_Real_Estate_Details__c = 'Commercial');
		EB_Collateral__c testCollateral1 = new EB_Collateral__c (Collateral_Code__r = testCollCode1);
		EB_Collateral__c testCollateral2 = new EB_Collateral__c (Collateral_Code__r = testCollCode2);
		mockFormulaHelper.setup('getRelatedCollateralsForLoanApp', new List<Object>{testLoanApplication}).Returns(new List<EB_Collateral__c>{testCollateral1,testCollateral2});

		Boolean status =sut.hasCRAEligibleCollateral();

		mockFormulaHelper.verify('getRelatedCollateralsForLoanApp',new List<Object>{testLoanApplication}, Times.Once);
		System.assertEquals(false,status);
	}

	@IsTest
    static void it_should_return_false_when_any_of_related_collateral_has_collateral_code_57() {
		Collateral_Code__c testCollCode1 = new Collateral_Code__c(Collateral_Code_ID__c = '57',Category__c = 'Real Estate',IsHMDADwelling__c = false, CRA_Real_Estate_Details__c = 'Non-Commercial');
		Collateral_Code__c testCollCode2 = new Collateral_Code__c(Collateral_Code_ID__c = '54',Category__c = 'Real Estate',IsHMDADwelling__c = false, CRA_Real_Estate_Details__c = 'Commercial');
		EB_Collateral__c testCollateral1 = new EB_Collateral__c (Collateral_Code__r = testCollCode1);
		EB_Collateral__c testCollateral2 = new EB_Collateral__c (Collateral_Code__r = testCollCode2);
		mockFormulaHelper.setup('getRelatedCollateralsForLoanApp', new List<Object>{testLoanApplication}).Returns(new List<EB_Collateral__c>{testCollateral1,testCollateral2});

		Boolean status =sut.hasCRAEligibleCollateral();

		mockFormulaHelper.verify('getRelatedCollateralsForLoanApp',new List<Object>{testLoanApplication}, Times.Once);
		System.assertEquals(false,status);
	}

	@IsTest
    static void it_should_return_false_when_any_of_related_collateral_has_collateral_code_65() {
		Collateral_Code__c testCollCode1 = new Collateral_Code__c(Collateral_Code_ID__c = '65',Category__c = 'Real Estate',IsHMDADwelling__c = false, CRA_Real_Estate_Details__c = 'Non-Commercial');
		Collateral_Code__c testCollCode2 = new Collateral_Code__c(Collateral_Code_ID__c = '54',Category__c = 'Real Estate',IsHMDADwelling__c = false, CRA_Real_Estate_Details__c = 'Commercial');
		EB_Collateral__c testCollateral1 = new EB_Collateral__c (Collateral_Code__r = testCollCode1);
		EB_Collateral__c testCollateral2 = new EB_Collateral__c (Collateral_Code__r = testCollCode2);
		mockFormulaHelper.setup('getRelatedCollateralsForLoanApp', new List<Object>{testLoanApplication}).Returns(new List<EB_Collateral__c>{testCollateral1,testCollateral2});

		Boolean status =sut.hasCRAEligibleCollateral();

		mockFormulaHelper.verify('getRelatedCollateralsForLoanApp',new List<Object>{testLoanApplication}, Times.Once);
		System.assertEquals(false,status);
	}

	@IsTest
    static void it_should_return_false_when_any_of_related_collateral_has_collateral_code_94() {
		Collateral_Code__c testCollCode1 = new Collateral_Code__c(Collateral_Code_ID__c = '94',Category__c = 'Real Estate',IsHMDADwelling__c = false, CRA_Real_Estate_Details__c = 'Non-Commercial');
		Collateral_Code__c testCollCode2 = new Collateral_Code__c(Collateral_Code_ID__c = '54',Category__c = 'Real Estate',IsHMDADwelling__c = false, CRA_Real_Estate_Details__c = 'Commercial');
		EB_Collateral__c testCollateral1 = new EB_Collateral__c (Collateral_Code__r = testCollCode1);
		EB_Collateral__c testCollateral2 = new EB_Collateral__c (Collateral_Code__r = testCollCode2);
		mockFormulaHelper.setup('getRelatedCollateralsForLoanApp', new List<Object>{testLoanApplication}).Returns(new List<EB_Collateral__c>{testCollateral1,testCollateral2});

		Boolean status =sut.hasCRAEligibleCollateral();

		mockFormulaHelper.verify('getRelatedCollateralsForLoanApp',new List<Object>{testLoanApplication}, Times.Once);
		System.assertEquals(false,status);
	}

	@IsTest
    static void it_should_return_false_when_any_of_related_collateral_has_collateral_code_95() {
		Collateral_Code__c testCollCode1 = new Collateral_Code__c(Collateral_Code_ID__c = '95',Category__c = 'Real Estate',IsHMDADwelling__c = false, CRA_Real_Estate_Details__c = 'Non-Commercial');
		Collateral_Code__c testCollCode2 = new Collateral_Code__c(Collateral_Code_ID__c = '54',Category__c = 'Real Estate',IsHMDADwelling__c = false, CRA_Real_Estate_Details__c = 'Commercial');
		EB_Collateral__c testCollateral1 = new EB_Collateral__c (Collateral_Code__r = testCollCode1);
		EB_Collateral__c testCollateral2 = new EB_Collateral__c (Collateral_Code__r = testCollCode2);
		mockFormulaHelper.setup('getRelatedCollateralsForLoanApp', new List<Object>{testLoanApplication}).Returns(new List<EB_Collateral__c>{testCollateral1,testCollateral2});

		Boolean status =sut.hasCRAEligibleCollateral();

		mockFormulaHelper.verify('getRelatedCollateralsForLoanApp',new List<Object>{testLoanApplication}, Times.Once);
		System.assertEquals(false,status);
	}

	@IsTest
    static void it_should_return_false_when_any_of_related_collateral_has_collateral_code_CM() {
		Collateral_Code__c testCollCode1 = new Collateral_Code__c(Collateral_Code_ID__c = 'CM',Category__c = 'Real Estate',IsHMDADwelling__c = false, CRA_Real_Estate_Details__c = 'Non-Commercial');
		Collateral_Code__c testCollCode2 = new Collateral_Code__c(Collateral_Code_ID__c = '54',Category__c = 'Real Estate',IsHMDADwelling__c = false, CRA_Real_Estate_Details__c = 'Commercial');
		EB_Collateral__c testCollateral1 = new EB_Collateral__c (Collateral_Code__r = testCollCode1);
		EB_Collateral__c testCollateral2 = new EB_Collateral__c (Collateral_Code__r = testCollCode2);
		mockFormulaHelper.setup('getRelatedCollateralsForLoanApp', new List<Object>{testLoanApplication}).Returns(new List<EB_Collateral__c>{testCollateral1,testCollateral2});

		Boolean status =sut.hasCRAEligibleCollateral();

		mockFormulaHelper.verify('getRelatedCollateralsForLoanApp',new List<Object>{testLoanApplication}, Times.Once);
		System.assertEquals(false,status);
	}

	@IsTest
    static void it_should_return_false_when_any_of_related_collateral_has_collateral_code_CR() {
		Collateral_Code__c testCollCode1 = new Collateral_Code__c(Collateral_Code_ID__c = 'CR',Category__c = 'Real Estate',IsHMDADwelling__c = false, CRA_Real_Estate_Details__c = 'Non-Commercial');
		Collateral_Code__c testCollCode2 = new Collateral_Code__c(Collateral_Code_ID__c = '54',Category__c = 'Real Estate',IsHMDADwelling__c = false, CRA_Real_Estate_Details__c = 'Commercial');
		EB_Collateral__c testCollateral1 = new EB_Collateral__c (Collateral_Code__r = testCollCode1);
		EB_Collateral__c testCollateral2 = new EB_Collateral__c (Collateral_Code__r = testCollCode2);
		mockFormulaHelper.setup('getRelatedCollateralsForLoanApp', new List<Object>{testLoanApplication}).Returns(new List<EB_Collateral__c>{testCollateral1,testCollateral2});

		Boolean status =sut.hasCRAEligibleCollateral();

		mockFormulaHelper.verify('getRelatedCollateralsForLoanApp',new List<Object>{testLoanApplication}, Times.Once);
		System.assertEquals(false,status);
	}

	@IsTest
    static void it_should_return_true_when_all_of_related_collateral_is_cra_eligible() {
		Collateral_Code__c testCollCode1 = new Collateral_Code__c(Collateral_Code_ID__c = '50',Category__c = 'Real Estate',IsHMDADwelling__c = false, CRA_Real_Estate_Details__c = 'Commercial');
		Collateral_Code__c testCollCode2 = new Collateral_Code__c(Collateral_Code_ID__c = '70',Category__c = 'Real Estate',IsHMDADwelling__c = false, CRA_Real_Estate_Details__c = 'Commercial');
		Collateral_Code__c testCollCode3 = new Collateral_Code__c(Collateral_Code_ID__c = '54',Category__c = 'Real Estate',IsHMDADwelling__c = false, CRA_Real_Estate_Details__c = 'Non-Commercial');
		EB_Collateral__c testCollateral1 = new EB_Collateral__c (Collateral_Code__r = testCollCode1);
		EB_Collateral__c testCollateral2 = new EB_Collateral__c (Collateral_Code__r = testCollCode2);
		EB_Collateral__c testCollateral3 = new EB_Collateral__c (Collateral_Code__r = testCollCode3);	
		mockFormulaHelper.setup('getRelatedCollateralsForLoanApp', new List<Object>{testLoanApplication}).Returns(new List<EB_Collateral__c>{testCollateral1,testCollateral2, testCollateral3});

		Boolean status =sut.hasCRAEligibleCollateral();

		mockFormulaHelper.verify('getRelatedCollateralsForLoanApp',new List<Object>{testLoanApplication}, Times.Once);
		System.assertEquals(true,status);
	}

	@IsTest
    static void it_should_return_true_when_business_purpose_is_yes() {
		testLoanApplication.Business_Purpose__c = 'Yes';

		Boolean returnedBusinessPurposeStatus = sut.IsBusinessPurpose();

		System.assertEquals(true, returnedBusinessPurposeStatus);
	}

	@IsTest
    static void it_should_return_false_when_business_purpose_is_no() {
		testLoanApplication.Business_Purpose__c = 'No';

		Boolean returnedBusinessPurposeStatus = sut.IsBusinessPurpose();

		System.assertEquals(false, returnedBusinessPurposeStatus);
	}

	@IsTest
    static void it_should_return_true_when_use_of_fund_is_set_to_Construction_Land_Development() {
		testLoanApplication.Use_of_Funds__c = 'Construction / Land Development';

		Boolean returnedConstructionLandDevelopmentStatus = sut.IsConstructionLandDevelopment();

		System.assertEquals(true, returnedConstructionLandDevelopmentStatus );
	}

	@IsTest
    static void it_should_return_false_when_use_of_fund_is_not_set_to_Construction_Land_Development() {
		testLoanApplication.Use_of_Funds__c = 'Not Construction / Land Development';

		Boolean returnedConstructionLandDevelopmentStatus = sut.IsConstructionLandDevelopment();

		System.assertEquals(false, returnedConstructionLandDevelopmentStatus );
	}

	@IsTest
    static void it_should_be_HOEPA_loan_type_when_loan_type_is_five_one_arm() {
		testLoanApplication.Loan_Type__c = '5/1 ARM';

		Boolean returnedisHOEPAEligibleLoanType = sut.isHOEPAEligibleLoanType();

		System.assertEquals(true,returnedisHOEPAEligibleLoanType);
	}

	@IsTest
    static void it_should_be_HOEPA_loan_type_when_loan_type_is_fixed_line() {
		testLoanApplication.Loan_Type__c = 'Fixed Line';

		Boolean returnedisHOEPAEligibleLoanType = sut.isHOEPAEligibleLoanType();

		System.assertEquals(true,returnedisHOEPAEligibleLoanType);
	}

	@IsTest
    static void it_should_be_HOEPA_loan_type_when_loan_type_is_home_equity_line() {
		testLoanApplication.Loan_Type__c = 'Home Equity Line';

		Boolean returnedisHOEPAEligibleLoanType = sut.isHOEPAEligibleLoanType();

		System.assertEquals(true,returnedisHOEPAEligibleLoanType);
	}

	@IsTest
    static void it_should_be_HOEPA_loan_type_when_loan_type_is_permanent_mortgage() {
		testLoanApplication.Loan_Type__c = 'Permanent Mortgage';

		Boolean returnedisHOEPAEligibleLoanType = sut.isHOEPAEligibleLoanType();

		System.assertEquals(true,returnedisHOEPAEligibleLoanType);
	}

	@IsTest
    static void it_should_be_HOEPA_loan_type_when_loan_type_is_revolving_line() {
		testLoanApplication.Loan_Type__c = 'Revolving Line';

		Boolean returnedisHOEPAEligibleLoanType = sut.isHOEPAEligibleLoanType();

		System.assertEquals(true,returnedisHOEPAEligibleLoanType);
	}

	@IsTest
    static void it_should_be_HOEPA_loan_type_when_loan_type_is_term() {
		testLoanApplication.Loan_Type__c = 'Term';

		Boolean returnedisHOEPAEligibleLoanType = sut.isHOEPAEligibleLoanType();

		System.assertEquals(true,returnedisHOEPAEligibleLoanType);
	}

	@IsTest
    static void it_should_be_HOEPA_loan_type_when_loan_type_not_a_hoepa_loan_type() {
		testLoanApplication.Loan_Type__c = 'Not Hoepa Type';

		Boolean returnedisHOEPAEligibleLoanType = sut.isHOEPAEligibleLoanType();

		System.assertEquals(false,returnedisHOEPAEligibleLoanType);
	}

	@IsTest
    static void it_should_be_HOEPA_purpose_to_finance_initial_construction_of_principal_dwelling_when_hoepa_finance_purchase_or_construction_is_yes() {
		testLoanApplication.HOEPA_Finance_Purchase_Or_Construction__c = 'Yes';

		Boolean returnedValue = sut.isHOEPAPurposeToFinanceInitialConstructionOfPrincipalDwelling();

		System.assertEquals(true,returnedValue);
	}

	@IsTest
    static void it_should_not_be_HOEPA_purpose_to_finance_initial_construction_of_principal_dwelling_when_hoepa_finance_purchase_or_construction_is_yes() {
		testLoanApplication.HOEPA_Finance_Purchase_Or_Construction__c = 'No';

		Boolean returnedValue = sut.isHOEPAPurposeToFinanceInitialConstructionOfPrincipalDwelling();

		System.assertEquals(false,returnedValue);
	}

	@IsTest
    static void it_should_be_Home_Improvement_when_use_of_funds_is_home_improvement() {
		testLoanApplication.Use_of_Funds__c = 'Home Improvement';

		Boolean returnedValue = sut.isHomeImprovement();

		System.assertEquals(true,returnedValue);
	}

	@IsTest
    static void it_should_not_be_Home_Improvement_when_use_of_funds_is_not_home_improvement() {
		testLoanApplication.Use_of_Funds__c = 'Other';

		Boolean returnedValue = sut.isHomeImprovement();

		System.assertEquals(false,returnedValue);
	}

	@IsTest
    static void it_should_return_true_when_loan_type_is_set_to_letter_of_credit() {
		testLoanApplication.Loan_Type__c = 'Letter of Credit';

		Boolean returnedLoanTypeLetterOfCreditStatus = sut.IsLetterOfCredit();

		System.assertEquals(true, returnedLoanTypeLetterOfCreditStatus );
	}

	@IsTest
    static void it_should_return_false_when_loan_type_is_not_set_to_letter_of_credit() {
		testLoanApplication.Loan_Type__c = 'Not Letter of Credit';

		Boolean returnedLoanTypeLetterOfCreditStatus = sut.IsLetterOfCredit();

		System.assertEquals(false, returnedLoanTypeLetterOfCreditStatus );
	}

	@IsTest
    static void it_should_return_true_when_loan_amount_is_over_500K() {
		testLoanApplication.Bank_Owned_Loan_Amount__c=500001.0;

		Boolean returnedLoanAmountOver500K = sut.IsloanAmountOver500K();

		System.assertEquals(true, returnedLoanAmountOver500K);
	}

	@IsTest
    static void it_should_return_false_when_loan_amount_is_less_500K() {
		testLoanApplication.Bank_Owned_Loan_Amount__c=400000.0;

		Boolean returnedLoanAmountOver500K = sut.IsloanAmountOver500K();

		System.assertEquals(false, returnedLoanAmountOver500K);
	}

	@IsTest
    static void it_should_return_true_when_loan_amount_is_over_1M() {
		testLoanApplication.Bank_Owned_Loan_Amount__c=1000001.0;

		Boolean returnedLoanAmountOver1M = sut.IsloanAmountOver1M();

		System.assertEquals(true, returnedLoanAmountOver1M );
	}

	@IsTest
    static void it_should_return_false_when_loan_amount_is_less_1M() {
		testLoanApplication.Bank_Owned_Loan_Amount__c=900000.0;

		Boolean returnedLoanAmountOver1M = sut.IsloanAmountOver1M();

		System.assertEquals(false, returnedLoanAmountOver1M );
	}

	@IsTest
    static void it_should_return_true_when_it_is_a_modification_without_an_increase_in_loan_amount() {
		
		RecordType loanRecordType = Utility.RecordTypeObject('EB_Account__c','Loan');
		EB_Account__c testEBAccount = new EB_Account__c(RecordType = loanRecordType, Current_Loan_Amount__c = 1000.00);

		testLoanApplication.RecordType = Utility.recordTypeObject('EB_Loan_Application__c','Modification - Full');
		testLoanApplication.Account_Number__r = testEBAccount;
		testLoanApplication.Bank_Owned_Loan_Amount__c=1000.0;

		Boolean returnedValue = sut.isModificationWithoutIncreasedLoanAmount();

		System.assertEquals(true, returnedValue );
	}

	@IsTest
    static void it_should_return_false_when_it_is_not_a_modification_with_an_increase_in_loan_amount() {
		RecordType loanRecordType = Utility.RecordTypeObject('EB_Account__c','Loan');
		EB_Account__c testEBAccount = new EB_Account__c(RecordType = loanRecordType, Current_Loan_Amount__c = 1000.00);

		testLoanApplication.RecordType = Utility.recordTypeObject('EB_Loan_Application__c','Renewal');
		testLoanApplication.Account_Number__r = testEBAccount;
		testLoanApplication.Bank_Owned_Loan_Amount__c=900000.0;

		Boolean returnedValue = sut.isModificationWithoutIncreasedLoanAmount();

		System.assertEquals(false, returnedValue );
	}

	@IsTest
    static void it_should_return_false_when_it_is_a_modification_with_an_increase_in_loan_amount() {
		RecordType loanRecordType = Utility.RecordTypeObject('EB_Account__c','Loan');
		EB_Account__c testEBAccount = new EB_Account__c(RecordType = loanRecordType, Current_Loan_Amount__c = 1000.00);

		testLoanApplication.RecordType = Utility.recordTypeObject('EB_Loan_Application__c','Modification - Full');
		testLoanApplication.Account_Number__r = testEBAccount;
		testLoanApplication.Bank_Owned_Loan_Amount__c=10001.0;

		Boolean returnedValue = sut.isModificationWithoutIncreasedLoanAmount();

		System.assertEquals(false, returnedValue );
	}

	@IsTest
    static void it_should_not_be_HMDA_when_loan_type_is_guidance_line_fixed() {
		testLoanApplication.Loan_Type__c = 'Guidance Line - Fixed';

		Boolean returnedValue = sut.isHMDAEligibleLoanType();

		System.assertEquals(false,returnedValue);
	}

	@IsTest
    static void it_should_not_be_HMDA_when_loan_type_is_guidance_line_revolving() {
		testLoanApplication.Loan_Type__c = 'Guidance Line - Revolving';

		Boolean returnedValue = sut.isHMDAEligibleLoanType();

		System.assertEquals(false,returnedValue);
	}

	@IsTest
    static void it_should_not_be_HMDA_loan_type_when_loan_type_is_home_equity_line() {
		testLoanApplication.Loan_Type__c = 'Home Equity Line';

		Boolean returnedValue = sut.isHMDAEligibleLoanType();

		System.assertEquals(false,returnedValue);
	}

	@IsTest
    static void it_should_not_be_HMDA_loan_type_when_loan_type_is_revolving_line() {
		testLoanApplication.Loan_Type__c = 'Revolving Line';

		Boolean returnedValue = sut.isHMDAEligibleLoanType();

		System.assertEquals(false,returnedValue);
	}

	@IsTest
    static void it_should_be_HMDA_loan_type_when_loan_type_is_not_home_equity_line_or_revolving_line_or_guidance_line() {
		testLoanApplication.Loan_Type__c = 'Other';

		Boolean returnedValue = sut.isHMDAEligibleLoanType();

		System.assertEquals(true,returnedValue);
	}

	@IsTest
    static void it_should_return_true_when_original_loan_amount_is_more_than_fivehundredthousand() {
		testLoanApplication.Bank_Owned_Loan_Amount__c =  497001.00;
		RecordType boughtRecordType = Utility.RecordTypeObject('EB_Loan_Participation__c','Bought');
		EB_Loan_Participation__c testParticipation1 = new EB_Loan_Participation__c(RecordType = boughtRecordType, Participated_Amount__c = 1000.00);
		EB_Loan_Participation__c testParticipation2 = new EB_Loan_Participation__c(RecordType = boughtRecordType, Participated_Amount__c = 2000.00);
		List<EB_Loan_Participation__c> relatedParticipations = new List<EB_Loan_Participation__c> {testParticipation1, testParticipation2};
		mockFormulaHelper.setup('getRelatedLoanParticipationsForLoanApp', new List<Object>{testLoanApplication}).returns(relatedParticipations);

		Boolean returnedTotalLoanAmount = sut.IsOriginalLoanAmountOver500K();

		System.assertEquals(true, returnedTotalLoanAmount);
	}

	@IsTest
    static void it_should_return_false_when_original_loan_amount_is_less_than_fivehundredthousand() {
		testLoanApplication.Bank_Owned_Loan_Amount__c =  496000.00;
		RecordType boughtRecordType = Utility.RecordTypeObject('EB_Loan_Participation__c','Bought');
		EB_Loan_Participation__c testParticipation1 = new EB_Loan_Participation__c(RecordType = boughtRecordType, Participated_Amount__c = 1000.00);
		EB_Loan_Participation__c testParticipation2 = new EB_Loan_Participation__c(RecordType = boughtRecordType, Participated_Amount__c = 2000.00);
		List<EB_Loan_Participation__c> relatedParticipations = new List<EB_Loan_Participation__c> {testParticipation1, testParticipation2};
		mockFormulaHelper.setup('getRelatedLoanParticipationsForLoanApp', new List<Object>{testLoanApplication}).returns(relatedParticipations);

		Boolean returnedTotalLoanAmount = sut.IsOriginalLoanAmountOver500K();

		System.assertEquals(false, returnedTotalLoanAmount);
	}

	@IsTest
    static void it_should_return_true_when_original_loan_amount_is_over_1m() {
		testLoanApplication.Bank_Owned_Loan_Amount__c =  997001.00;
		RecordType boughtRecordType = Utility.RecordTypeObject('EB_Loan_Participation__c','Bought');
		EB_Loan_Participation__c testParticipation1 = new EB_Loan_Participation__c(RecordType = boughtRecordType, Participated_Amount__c = 1000.00);
		EB_Loan_Participation__c testParticipation2 = new EB_Loan_Participation__c(RecordType = boughtRecordType, Participated_Amount__c = 2000.00);
		List<EB_Loan_Participation__c> relatedParticipations = new List<EB_Loan_Participation__c> {testParticipation1, testParticipation2};
		mockFormulaHelper.setup('getRelatedLoanParticipationsForLoanApp', new List<Object>{testLoanApplication}).returns(relatedParticipations);

		Boolean returnedOriginalLoanAmountOver1M = sut.IsOriginalLoanAmountOver1M();

		System.assertEquals(true, returnedOriginalLoanAmountOver1M);
	}

	@IsTest
    static void it_should_return_false_when_original_loan_amount_is_less_than_1m() {
		testLoanApplication.Bank_Owned_Loan_Amount__c =  996001.00;
		RecordType boughtRecordType = Utility.RecordTypeObject('EB_Loan_Participation__c','Bought');
		EB_Loan_Participation__c testParticipation1 = new EB_Loan_Participation__c(RecordType = boughtRecordType, Participated_Amount__c = 1000.00);
		EB_Loan_Participation__c testParticipation2 = new EB_Loan_Participation__c(RecordType = boughtRecordType, Participated_Amount__c = 2000.00);
		List<EB_Loan_Participation__c> relatedParticipations = new List<EB_Loan_Participation__c> {testParticipation1, testParticipation2};
		mockFormulaHelper.setup('getRelatedLoanParticipationsForLoanApp', new List<Object>{testLoanApplication}).returns(relatedParticipations);

		Boolean returnedOriginalLoanAmountOver1M = sut.IsOriginalLoanAmountOver1M();

		System.assertEquals(false, returnedOriginalLoanAmountOver1M);
	}

	@IsTest
    static void it_should_be_purchase_residential_real_estate_when_use_of_funds_is_purchase_residential_real_estate() {
		testLoanApplication.Use_of_Funds__c = 'Purchase Residential Real Estate';

		Boolean returnedValue = sut.isPurchaseResidentialRealEstate();

		System.assertEquals(true,returnedValue);
	}

	@IsTest
    static void it_should_not_be_purchase_residential_real_estate_when_use_of_funds_is_not_purchase_residential_real_estate() {
		testLoanApplication.Use_of_Funds__c = 'Other';

		Boolean returnedValue = sut.isPurchaseResidentialRealEstate();

		System.assertEquals(false,returnedValue);
	}

	@IsTest
    static void it_should_return_true_when_use_of_funds_is_buy_or_carry_securities() {
		testLoanApplication.Use_of_Funds__c = 'Buy or Carry Securities';

		Boolean returnedValue = sut.isPurposeOfLoanToBuySecurities();

		System.assertEquals(true,returnedValue);
	}

	@IsTest
    static void it_should_return_false_when_use_of_funds_is_not_buy_or_carry_securities() {
		testLoanApplication.Use_of_Funds__c = 'Other';

		Boolean returnedValue = sut.isPurposeOfLoanToBuySecurities();

		System.assertEquals(false,returnedValue);
	}

	@IsTest
    static void it_should_return_true_when_refinance_type_is_to_payoff_existing_debt_by_same_borrower() {
		testLoanApplication.Refinance_Type__c = 'Payoff of Exsisting Debt by the same Borrower';

		Boolean returnedValue = sut.isRefinanceToPayoffExistingDebtBySameBorrower();

		System.assertEquals(true,returnedValue);
	}

	@IsTest
    static void it_should_return_false_when_refinance_type_is_not_to_payoff_existing_debt_by_same_borrower() {
		testLoanApplication.Refinance_Type__c = 'Other';

		Boolean returnedValue = sut.isRefinanceToPayoffExistingDebtBySameBorrower();

		System.assertEquals(false,returnedValue);
	}

	@IsTest
    static void it_should_return_true_when_use_of_funds_is_refinance_residential_real_estate() {
		testLoanApplication.Use_of_Funds__c = 'Refinance Residential Real Estate';

		Boolean returnedValue = sut.isRefinanceResidentialRealEstate();

		System.assertEquals(true,returnedValue);
	}

	@IsTest
    static void it_should_return_false_when_use_of_funds_is_not_refinance_residential_real_estate() {
		testLoanApplication.Use_of_Funds__c = 'Other';

		Boolean returnedValue = sut.isRefinanceResidentialRealEstate();

		System.assertEquals(false,returnedValue);
	}

	@IsTest
    static void it_should_return_true_when_use_of_funds_is_residential_rehab() {
		testLoanApplication.Use_of_Funds__c = 'Residential Rehab';

		Boolean returnedValue = sut.isResidentialRehab();

		System.assertEquals(true,returnedValue);
	}

	@IsTest
    static void it_should_return_false_when_use_of_funds_is_not_residential_rehab() {
		testLoanApplication.Use_of_Funds__c = 'Other';

		Boolean returnedValue = sut.isResidentialRehab();

		System.assertEquals(false,returnedValue);
	}

	@IsTest
    static void it_should_return_true_when_any_of_the_related_Collateral_isDwelling() {
		Collateral_Code__c testCollCode1 = new Collateral_Code__c(IsHMDADwelling__c = false);
		Collateral_Code__c testCollCode2 = new Collateral_Code__c(IsHMDADwelling__c = true);
		EB_Collateral__c testCollateral1 = new EB_Collateral__c(Collateral_Code__r = testCollCode1);
		EB_Collateral__c testCollateral2 = new EB_Collateral__c(Collateral_Code__r = testCollCode2);
		List<EB_Collateral__c> relatedCollaterals = new List<EB_Collateral__c> {testCollateral1, testCollateral2};
		mockFormulaHelper.setup('getRelatedCollateralsForLoanApp', new List<Object>{testLoanApplication}).returns(relatedCollaterals);

		Boolean hasDwellingCollateralStatus = sut.HasDwellingCollateral();

		System.assertEquals(true,hasDwellingCollateralStatus);
	}

	@IsTest
    static void it_should_return_false_when_all_of_the_related_Collateral_is_not_Dwelling() {
		Collateral_Code__c testCollCode1 = new Collateral_Code__c(IsHMDADwelling__c = false);
		Collateral_Code__c testCollCode2 = new Collateral_Code__c(IsHMDADwelling__c = false);
		EB_Collateral__c testCollateral1 = new EB_Collateral__c(Collateral_Code__r = testCollCode1);
		EB_Collateral__c testCollateral2 = new EB_Collateral__c(Collateral_Code__r = testCollCode2);
		List<EB_Collateral__c> relatedCollaterals = new List<EB_Collateral__c> {testCollateral1, testCollateral2};
		mockFormulaHelper.setup('getRelatedCollateralsForLoanApp', new List<Object>{testLoanApplication}).returns(relatedCollaterals);

		Boolean hasDwellingCollateralStatus = sut.HasDwellingCollateral();

		System.assertEquals(false,hasDwellingCollateralStatus);
	}

	@IsTest
    static void it_should_return_true_when_at_least_one_collateral_code_is_non_commercial() {
		Collateral_Code__c testCollCode1 = new Collateral_Code__c(CRA_Real_Estate_Details__c = 'Commercial');
		Collateral_Code__c testCollCode2 = new Collateral_Code__c(CRA_Real_Estate_Details__c = 'Non-Commercial');
		EB_Collateral__c testCollateral1 = new EB_Collateral__c(Collateral_Code__r = testCollCode1);
		EB_Collateral__c testCollateral2 = new EB_Collateral__c(Collateral_Code__r = testCollCode2);
		List<EB_Collateral__c> relatedCollaterals = new List<EB_Collateral__c> {testCollateral1, testCollateral2};
		mockFormulaHelper.setup('getRelatedCollateralsForLoanApp', new List<Object>{testLoanApplication}).returns(relatedCollaterals);

		Boolean status = sut.HasNonCommercialRealEstateCollateral();

		System.assertEquals(true,status);
	}

	@IsTest
    static void it_should_return_false_when_none_of_the_collateral_code_is_non_commercial() {
		Collateral_Code__c testCollCode1 = new Collateral_Code__c(CRA_Real_Estate_Details__c = 'Commercial');
		Collateral_Code__c testCollCode2 = new Collateral_Code__c(CRA_Real_Estate_Details__c = 'Commercial');
		EB_Collateral__c testCollateral1 = new EB_Collateral__c(Collateral_Code__r = testCollCode1);
		EB_Collateral__c testCollateral2 = new EB_Collateral__c(Collateral_Code__r = testCollCode2);
		List<EB_Collateral__c> relatedCollaterals = new List<EB_Collateral__c> {testCollateral1, testCollateral2};
		mockFormulaHelper.setup('getRelatedCollateralsForLoanApp', new List<Object>{testLoanApplication}).returns(relatedCollaterals);

		Boolean status = sut.HasNonCommercialRealEstateCollateral();

		System.assertEquals(false,status);
	}

	@IsTest
    static void it_should_return_true_when_one_of_the_loan_participation_has_record_type_bought() {
		RecordType boughtRecordType = Utility.RecordTypeObject('EB_Loan_Participation__c','Bought');
		RecordType soldRecordType = Utility.RecordTypeObject('EB_Loan_Participation__c','Sold');
		EB_Loan_Participation__c testParticipation1 = new EB_Loan_Participation__c(RecordType = boughtRecordType);
		EB_Loan_Participation__c testParticipation2 = new EB_Loan_Participation__c(RecordType = soldRecordType);
		List<EB_Loan_Participation__c> relatedParticipations = new List<EB_Loan_Participation__c> {testParticipation1, testParticipation2};
		mockFormulaHelper.setup('getRelatedLoanParticipationsForLoanApp', new List<Object>{testLoanApplication}).returns(relatedParticipations);

		Boolean returnedHasPurchasedParticipationStatus = sut.HasPurchasedParticipation();

		System.assertEquals(true, returnedHasPurchasedParticipationStatus);
	}

	@IsTest
    static void it_should_return_false_when_none_the_loan_participation_has_record_type_bought() {
		RecordType soldRecordType = Utility.RecordTypeObject('EB_Loan_Participation__c','Sold');
		EB_Loan_Participation__c testParticipation1 = new EB_Loan_Participation__c(RecordType = soldRecordType);
		EB_Loan_Participation__c testParticipation2 = new EB_Loan_Participation__c(RecordType = soldRecordType);
		List<EB_Loan_Participation__c> relatedParticipations = new List<EB_Loan_Participation__c> {testParticipation1, testParticipation2};
		mockFormulaHelper.setup('getRelatedLoanParticipationsForLoanApp', new List<Object>{testLoanApplication}).returns(relatedParticipations);

		Boolean returnedHasPurchasedParticipationStatus = sut.HasPurchasedParticipation();

		System.assertEquals(false, returnedHasPurchasedParticipationStatus);
	}

	@IsTest
    static void it_should_return_true_when_at_least_one_collateral_code_is_real_estate() {
		Collateral_Code__c testCollCode1 = new Collateral_Code__c(Category__c = 'Not Real Estate');
		Collateral_Code__c testCollCode2 = new Collateral_Code__c(Category__c = 'Real Estate');
		EB_Collateral__c testCollateral1 = new EB_Collateral__c(Collateral_Code__r = testCollCode1);
		EB_Collateral__c testCollateral2 = new EB_Collateral__c(Collateral_Code__r = testCollCode2);
		List<EB_Collateral__c> relatedCollaterals = new List<EB_Collateral__c> {testCollateral1, testCollateral2};
		mockFormulaHelper.setup('getRelatedCollateralsForLoanApp', new List<Object>{testLoanApplication}).returns(relatedCollaterals);

		Boolean status = sut.HasRealEstateCollateral();

		System.assertEquals(true,status);
	}

	@IsTest
    static void it_should_return_false_when_none_of_the_collateral_code_is_real_estate() {
		Collateral_Code__c testCollCode1 = new Collateral_Code__c(Category__c = 'Not Real Estate');
		Collateral_Code__c testCollCode2 = new Collateral_Code__c(Category__c = 'Not Real Estate');
		EB_Collateral__c testCollateral1 = new EB_Collateral__c(Collateral_Code__r = testCollCode1);
		EB_Collateral__c testCollateral2 = new EB_Collateral__c(Collateral_Code__r = testCollCode2);
		List<EB_Collateral__c> relatedCollaterals = new List<EB_Collateral__c> {testCollateral1, testCollateral2};
		mockFormulaHelper.setup('getRelatedCollateralsForLoanApp', new List<Object>{testLoanApplication}).returns(relatedCollaterals);

		Boolean status = sut.HasRealEstateCollateral();

		System.assertEquals(false,status);
	}

	private class MockofILoanAppWrapperHelper extends ApexMoq implements LoanAppWrapperHelper.ILoanAppWrapperHelper {
		public List<EB_Loan_App_Collateral_Relationship__c> getLoanAppToCollateralRelationships(EB_Loan_Application__c loanapp){
			return (List<EB_Loan_App_Collateral_Relationship__c>)handleMethodInvocation('getLoanAppToCollateralRelationships', new List<Object>{loanapp});
		}
		public List<EB_Collateral__c> getRelatedCollateralsForLoanApp(EB_Loan_Application__c loanapp){
			return (List<EB_Collateral__c>)handleMethodInvocation('getRelatedCollateralsForLoanApp', new List<Object>{loanapp});
		}
		public List<EB_Loan_Participation__c> getRelatedLoanParticipationsForLoanApp(EB_Loan_Application__c loanapp){
			return (List<EB_Loan_Participation__c>)handleMethodInvocation('getRelatedLoanParticipationsForLoanApp', new List<Object>{loanapp});
		}
	}
}