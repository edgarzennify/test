@IsTest
public class LoanBoardingVmBuilderHelperTests {
    private static final LoanBoardingVmBuilderHelper sut;

    static {
        sut = new LoanBoardingVmBuilderHelper();
    }

    @IsTest
    static void it_should_return_this_vmLoan_when_given_this_dm() {
        DmLoan dm = buildTestDmLoan();
        //act
        LoanBoarding.LoanVm results = sut.buildVmLoan(dm);
        //assert
        System.assertEquals('loan-Id', results.Id);
        System.assertEquals('test-loan', results.Name);
        System.assertEquals('test-product-type', results.ProductType);
        System.assertEquals('test-product-line', results.ProductLine);
        System.assertEquals('test-product', results.Product);
        System.assertEquals(100000.00, results.OriginationAmount);
        System.assertEquals('test-channel', results.Channel);
        System.assertEquals(true, results.IsRegOLoan);
        System.assertEquals(false, results.IsEmployeeLoan);
        System.assertEquals('test-risk', results.RiskGrade);
        System.assertEquals('test-niche-products', results.NicheProducts);
        System.assertEquals('test-niche-products-fx', results.NicheProductsfx);
        System.assertEquals('test-loan-characteristics', results.LoanCharacteristics);
        System.assertEquals('test-industry-code', results.Industry);
        System.assertEquals('test-use-of-funds', results.UseOfFunds);
        System.assertEquals('test-other-description', results.OtherPurposeForFunds);
        System.assertEquals('test-lc', results.LoanCoordinator);
        System.assertEquals('test-creator', results.CreatedBy);
        System.assertEquals('test-orig-user-name', results.OriginatingOfficer);
        System.assertEquals('test-officer', results.ServicingOfficer);
        System.assertEquals('test-strategy', results.LendingStrategy);
        System.assertEquals('test-unit (999)', results.Unit);
        System.assertEquals(2.300, results.InterestRate);
        System.assertEquals(Date.newInstance(2016, 1,1), results.FirstPaymentDate);
        System.assertEquals(20, results.Amortized);
        System.assertEquals(60, results.Maturity);
        System.assertEquals('test-basis', results.PricingBasis);
        System.assertEquals('test-type', results.PaymentType);
        System.assertEquals('test-schedule', results.PaymentSchedule);
        System.assertEquals('test-idx1', results.Index);
        System.assertEquals(30.00, results.Spread);
        System.assertEquals(2.3, results.RateFloor);
        System.assertEquals(2.6, results.RateCeiling);
        System.assertEquals(2000.00, results.MonthlyPayment);
        System.assertEquals('1', results.InterestRateAdjustmentFrequency);
        System.assertEquals(Date.newInstance(2016,3,5), results.MaturityDate);
        System.assertEquals('#123456789', results.LoanApplicationNumber);
        System.assertEquals('military', results.SubjectToMilitaryLendingAct);
        System.assertEquals('government-entity', results.GovtRelatedEntity);
        System.assertEquals('ag-income', results.ReliantOnAgIncome);
        System.assertEquals('financial-institution', results.ToFinancialInst);
        System.assertEquals('accept-deposits', results.DoesFinancialInstAcceptDeposits);
        System.assertEquals(true, results.ImmediateFunding);
        System.assertEquals(45.00, results.WireAmount);
        System.assertEquals('disburse-instructions', results.DisbursingInstructions);
        System.assertEquals('chuck norris', results.Covid_19_Loan);
    }

    @IsTest
    static void it_should_return_dmLoan_name_when_isRenewal_is_true() {
        DmLoan dm = buildTestDmLoan();
        dm.IsRenewal = true;
        dm.IsModification = false;
        //act
        LoanBoarding.LoanVm results = sut.buildVmLoan(dm);
        //assert
        System.assertEquals('test-loan', results.AccountNumber);
    }

    @IsTest
    static void it_should_return_dmLoan_name_when_isModification_is_true() {
        DmLoan dm = buildTestDmLoan();
        dm.IsRenewal = false;
        dm.IsModification = true;
        //act
        LoanBoarding.LoanVm results = sut.buildVmLoan(dm);
        //assert
        System.assertEquals('test-loan', results.AccountNumber);
    }

    @IsTest
    static void it_should_return_dmLoan_lookupKey_when_isModification_is_false_and_isRenewal_is_false() {
        DmLoan dm = buildTestDmLoan();
        dm.IsModification = false;
        dm.IsRenewal = false;
        //act
        LoanBoarding.LoanVm results = sut.buildVmLoan(dm);
        //assert
        System.assertEquals('616-11-20200', results.AccountNumber);
    }

    @IsTest
    static void it_should_set_renewalFlag_to_renewal_when_isRenewal_is_true() {
        DmLoan dm = buildTestDmLoan();
        dm.IsRenewal = true;
        dm.IsModification = false;
        //act
        loanboarding.LoanVm results = sut.buildVmLoan(dm);
        //assert
        System.assertEquals('Renewal', results.RenewalFlag);
    }

    @IsTest
    static void it_should_set_renewalFlag_to_modification_when_isModification_is_true() {
        DmLoan dm = buildTestDmLoan();
        dm.IsRenewal = false;
        dm.IsModification = true;
        //act
        loanboarding.LoanVm results = sut.buildVmLoan(dm);
        //assert
        System.assertEquals('Modification', results.RenewalFlag);
    }

    @IsTest
    static void it_should_set_renewalFlag_to_new_when_isModification_is_true() {
        DmLoan dm = buildTestDmLoan();
        dm.IsRenewal = false;
        dm.IsModification = false;
        //act
        loanboarding.LoanVm results = sut.buildVmLoan(dm);
        //assert
        System.assertEquals('New', results.RenewalFlag);
    }

    @IsTest
    static void it_should_not_change_lcComments() {
        DmLoan dm = buildTestDmLoan();
        dm.LcComments = 'tim test comments';
        //act
        loanboarding.LoanVm results = sut.buildVmLoan(dm);
        //assert
        System.assertEquals('tim test comments', results.LcComments);
    }

    @IsTest
    static void it_should_replace_apostrohpes_in_lcComments_with_backticks() {
        DmLoan dm = buildTestDmLoan();
        dm.LcComments = 'timmy&#39;';
        //act
        loanboarding.LoanVm results = sut.buildVmLoan(dm);
        //assert
        System.assertEquals('timmy`', results.LcComments);
    }

    @IsTest
    static void it_should_return_an_empty_string_if_lcComments_is_blank() {
        DmLoan dm = buildTestDmLoan();
        dm.LcComments = '';
        //act
        loanboarding.LoanVm results = sut.buildVmLoan(dm);
        //assert
        System.assertEquals('', results.LcComments);
    }

    @IsTest
    static void it_should_not_change_rmComments() {
        DmLoan dm = buildTestDmLoan();
        dm.RmComments = 'tim test comments';
        //act
        loanboarding.LoanVm results = sut.buildVmLoan(dm);
        //assert
        System.assertEquals('tim test comments', results.RmComments);
    }

    @IsTest
    static void it_should_replace_apostrohpes_in_rmComments_with_backticks() {
        DmLoan dm = buildTestDmLoan();
        dm.RmComments = 'ronnie&#39;';
        //act
        loanboarding.LoanVm results = sut.buildVmLoan(dm);
        //assert
        System.assertEquals('ronnie`', results.RmComments);
    }

    @IsTest
    static void it_should_return_an_empty_string_if_rmComments_is_blank() {
        DmLoan dm = buildTestDmLoan();
        dm.RmComments = '';
        //act
        loanboarding.LoanVm results = sut.buildVmLoan(dm);
        //assert
        System.assertEquals('', results.RmComments);
    }

    @IsTest
    static void it_should_return_a_blank_string_when_there_is_no_DmLoanCollateralRelationship_with_isPrimary_set_to_true() {
        DmLoan dm = buildTestDmLoan();
        dm.PledgedCollateral = new List<DmLoanCollateralRelationship>();
        //act
        LoanBoarding.LoanVm results = sut.buildVmLoan(dm);
        //assert
        System.assertEquals('', results.CollateralCode);
    }

    @IsTest
    static void it_should_return_test_name_when_dmPledge_is_primary_and_collateralType_is_not_modified() {
        DmCollateralType dmType = new DmCollateralType();
        dmType.Name = 'test name';
        
        DmCollateral DmCollateral = new DmCollateral();
        DmCollateral.IsModifiedCollateralType = false;
        DmCollateral.CollateralType = dmType;

        DmLoanCollateralRelationship dmPledge = new DmLoanCollateralRelationship();
        dmPledge.IsPrimary = true;
        dmPledge.Collateral = DmCollateral;
        
        DmLoan dm = buildTestDmLoan();
        dm.PledgedCollateral = new List<DmLoanCollateralRelationship>{dmPledge};
        //act
        LoanBoarding.LoanVm results = sut.buildVmLoan(dm);
        //assert
        System.assertEquals('test name', results.CollateralCode);
    }

    @IsTest
    static void it_should_return_modified_test_name_when_dmPledge_is_primary_and_collateralType_is_modified() {
        DmCollateralType dmType = new DmCollateralType();
        dmType.Name = 'test name';
        
        DmCollateral DmCollateral = new DmCollateral();
        DmCollateral.IsModifiedCollateralType = true;
        DmCollateral.CollateralType = dmType;

        DmLoanCollateralRelationship dmPledge = new DmLoanCollateralRelationship();
        dmPledge.IsPrimary = true;
        dmPledge.Collateral = DmCollateral;
        
        DmLoan dm = buildTestDmLoan();
        dm.PledgedCollateral = new List<DmLoanCollateralRelationship>{dmPledge};
        //act
        LoanBoarding.LoanVm results = sut.buildVmLoan(dm);
        //assert
        System.assertEquals('***MODIFIED*** test name', results.CollateralCode);
    }

    @IsTest
    static void it_should_return_this_customerVm_when_given_this_dm() {
        Date dt = Date.newInstance(2020, 4, 16);
        
        DmLoan dmLoan = new DmLoan();
        dmLoan.Name = 'loan name';

        DmEntity dmEntity = new DmEntity();
        dmEntity.Name = 'entity name';
        dmEntity.TaxId = 'tax id';
        dmEntity.Phone = 'phone';
        dmEntity.SicCode = 'sic code';
        dmEntity.BirthDate = dt;
        dmEntity.DriversLicense = 'drivers license';
        dmEntity.RegOCode = 'reg o code';
        dmEntity.BillingStreet = '123 Paper St';
        dmEntity.BillingCity = 'Hell';
        dmEntity.BillingState = 'NO';
        dmEntity.BillingPostalCode = '12345';

        DmLoanEntityRelationship dm = new DmLoanEntityRelationship();
        dm.Name = 'dm name';
        dm.Liabilities = 1.1;
        dm.RelationshipType = 'dm relationship type';
        dm.ContingentType = 'dm contingent type';
        dm.ContingentPercentage = 42.42;
        dm.Limitations = 'dm limitations';
        dm.Loan = dmLoan;
        dm.Entity = dmEntity;
        //act
        LoanBoarding.CustomerVm results = sut.buildAccountToCustomerRelationship(dm);
        //assert
        System.assertEquals('dm name', results.Name);
        System.assertEquals(1.1, results.Liabilities);
        System.assertEquals('dm relationship type', results.RelationshipType);
        System.assertEquals('dm contingent type', results.ContingentType);
        System.assertEquals(42.42, results.ContingentPercentage);
        System.assertEquals('dm limitations', results.Limitations);
        System.assertEquals('loan name', results.Loan);
        System.assertEquals('entity name', results.Entity);
        System.assertEquals('tax id', results.TaxId);
        System.assertEquals('phone', results.Phone);
        System.assertEquals('sic code', results.Sic);
        System.assertEquals(dt, results.Dob);
        System.assertEquals('drivers license', results.LicenseNum);
        System.assertEquals('reg o code', results.RegOCode);
        System.assertEquals('123 Paper St, Hell, NO 12345', results.Address);
    }

    @IsTest
    static void it_should_return_a_blank_address_when_dmEntity_has_no_billingStreet() {
        DmLoanEntityRelationship dm = new DmLoanEntityRelationship();
        dm.Loan = new DmLoan();
        dm.Entity = new DmEntity();
        //act
        LoanBoarding.CustomerVm results = sut.buildAccountToCustomerRelationship(dm);
        //assert
        System.assertEquals('', results.Address);
    }

    @IsTest
    static void it_should_return_0_when_relationshipType_is_primary_owner() {
        DmLoanEntityRelationship dm = new DmLoanEntityRelationship();
        dm.RelationshipType = 'Primary Owner';
        dm.Loan = new DmLoan();
        dm.Entity = new DmEntity();
        //act
        LoanBoarding.CustomerVm results = sut.buildAccountToCustomerRelationship(dm);
        //assert
        System.assertEquals(0, results.SortOrder);
    }

    @IsTest
    static void it_should_return_1_when_relationshipType_is_primary_borrower() {
        DmLoanEntityRelationship dm = new DmLoanEntityRelationship();
        dm.RelationshipType = 'Primary Borrower';
        dm.Loan = new DmLoan();
        dm.Entity = new DmEntity();
        //act
        LoanBoarding.CustomerVm results = sut.buildAccountToCustomerRelationship(dm);
        //assert
        System.assertEquals(1, results.SortOrder);
    }

    @IsTest
    static void it_should_return_2_when_relationshipType_is_borrower() {
        DmLoanEntityRelationship dm = new DmLoanEntityRelationship();
        dm.RelationshipType = 'Borrower';
        dm.Loan = new DmLoan();
        dm.Entity = new DmEntity();
        //act
        LoanBoarding.CustomerVm results = sut.buildAccountToCustomerRelationship(dm);
        //assert
        System.assertEquals(2, results.SortOrder);
    }

    @IsTest
    static void it_should_return_3_when_relationshipType_is_secondary_owner() {
        DmLoanEntityRelationship dm = new DmLoanEntityRelationship();
        dm.RelationshipType = 'Secondary Owner';
        dm.Loan = new DmLoan();
        dm.Entity = new DmEntity();
        //act
        LoanBoarding.CustomerVm results = sut.buildAccountToCustomerRelationship(dm);
        //assert
        System.assertEquals(3, results.SortOrder);
    }

    @IsTest
    static void it_should_return_4_when_relationshipType_is_secondary_coBorrower() {
        DmLoanEntityRelationship dm = new DmLoanEntityRelationship();
        dm.RelationshipType = 'Co-Borrower';
        dm.Loan = new DmLoan();
        dm.Entity = new DmEntity();
        //act
        LoanBoarding.CustomerVm results = sut.buildAccountToCustomerRelationship(dm);
        //assert
        System.assertEquals(4, results.SortOrder);
    }

    @IsTest
    static void it_should_return_5_when_relationshipType_is_secondary_guarantor() {
        DmLoanEntityRelationship dm = new DmLoanEntityRelationship();
        dm.RelationshipType = 'Guarantor';
        dm.Loan = new DmLoan();
        dm.Entity = new DmEntity();
        //act
        LoanBoarding.CustomerVm results = sut.buildAccountToCustomerRelationship(dm);
        //assert
        System.assertEquals(5, results.SortOrder);
    }

    @IsTest
    static void it_should_return_7_when_relationshipType_is_secondary_guarantor() {
        DmLoanEntityRelationship dm = new DmLoanEntityRelationship();
        dm.RelationshipType = 'not in list';
        dm.Loan = new DmLoan();
        dm.Entity = new DmEntity();
        //act
        LoanBoarding.CustomerVm results = sut.buildAccountToCustomerRelationship(dm);
        //assert
        System.assertEquals(7, results.SortOrder);
    }

    @IsTest
    static void it_should_return_this_vmCollateral_when_given_this_dm() {
        Date dt = Date.newInstance(2020, 4, 16);
        
        DmLoan dmLoan = new DmLoan();
        dmLoan.Name = 'loan name';

        DmCollateralType dmColType = new DmCollateralType();
        dmColType.Name = 'col type name';

        DmEntity dmOwner = new DmEntity();
        dmOwner.Name = 'owner name';
        dmOwner.BillingStreet = '321 Confetti Rd';
        dmOwner.BillingCity = 'Saint Louis';
        dmOwner.BillingState = 'MO';
        dmOwner.BillingPostalCode = '63139';

        DmCollateral dmCol = new DmCollateral();
        dmCol.CoreName = 'core name';
        dmCol.Name = 'name';
        dmCol.IsModifiedCollateralType = false;
        dmCol.AppraisedValue = 1.1;
        dmCol.AppraisedValueDate = dt;
        dmCol.FloodInsuranceRequired = 'no';
        dmCol.AssignmentOfRents = 'assign rents';
        dmCol.Street = '123 Paper St';
        dmCol.City = 'Dodge';
        dmCol.State = 'KS';
        dmCol.PostalCode = '12345';
        dmCol.CollateralType = dmColType;
        dmCol.PrimaryOwner = dmOwner;
        dmCol.parcelNumber = '123456';

        DmLoanCollateralRelationship dm = new DmLoanCollateralRelationship();
        dm.Name = 'dm name';
        dm.LienPosition = 'lien pos';
        dm.LendableValue = 4200.00;
        dm.AbundanceOfCaution = false;
        dm.IsPrimary = false;
        dm.IsOwnedByPrimaryBorrower = false;
        dm.Loan = dmLoan;
        dm.Collateral = dmCol;
        //act
        LoanBoarding.CollateralVm results = sut.buildVmCollateral(dm);
        //assert
        System.assertEquals('dm name', results.Name);
        System.assertEquals('lien pos', results.LienPosition);
        System.assertEquals(4200.00, results.LendableValue);
        System.assertEquals(false, results.AbundanceOfCaution);
        System.assertEquals(false, results.IsPrimary);
        System.assertEquals(false, results.IsOwnedByPrimaryBorrower);

        System.assertEquals('loan name', results.Loan);

        System.assertEquals('core name', results.CoreName);
        System.assertEquals('name', results.CollateralName);
        System.assertEquals('col type name', results.CollateralType);
        System.assertEquals(1.1, results.AppraisedValue);
        System.assertEquals(dt, results.AppraisedValueDate);
        System.assertEquals('no', results.FloodRequired);
        System.assertEquals('assign rents', results.AssignmentOfRents);
        System.assertEquals('123 Paper St, Dodge, KS 12345', results.CollateralAddress);
        System.assertEquals('owner name', results.OwnerName);
        System.assertEquals('321 Confetti Rd, Saint Louis, MO 63139', results.OwnerAddress);
        System.assertEquals('123456', results.parcelNumber);
    }

    @IsTest
    static void it_should_return_the_description_when_collateral_description_is_less_than_350_chars() {
        DmCollateral dmCol = new DmCollateral();
        dmCol.Description = 'the description';
        dmcol.IsModifiedCollateralType = false;
        dmCol.CollateralType = new DmCollateralType();
        dmCol.PrimaryOwner = new DmEntity();

        DmLoanCollateralRelationship dm = new DmLoanCollateralRelationship();
        dm.Collateral = dmCol;
        dm.Loan = new DmLoan();
        //act
        LoanBoarding.CollateralVm results = sut.buildVmCollateral(dm);
        //assert
        System.assertEquals('the description', results.Description);
    }

    @IsTest
    static void it_should_return_the_truncated_description_when_collateral_description_is_greater_than_350_chars() {
        DmCollateral dmCol = new DmCollateral();
        dmCol.Description = '123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901';
        dmcol.IsModifiedCollateralType = false;
        dmCol.CollateralType = new DmCollateralType();
        dmCol.PrimaryOwner = new DmEntity();

        DmLoanCollateralRelationship dm = new DmLoanCollateralRelationship();
        dm.Collateral = dmCol;
        dm.Loan = new DmLoan();
        //act
        LoanBoarding.CollateralVm results = sut.buildVmCollateral(dm);
        //assert
        System.assertEquals(true, results.Description.contains('...[TEXT TRUNCATED]'));
    }

    @IsTest
    static void it_should_return_this_vmParticipation_when_participationSold_is_true() {
        DmLoan dmLoan = new DmLoan();
        dmLoan.Name = 'loan name';

        DmParticipation dm = new DmParticipation();
        dm.Name = 'dm name';
        dm.PercentParticipation = 50.00;
        dm.Bank = 'bank';
        dm.Amount = 42.42;
        dm.ParticipationSold = true;
        dm.Loan = dmLoan;
        //act
        LoanBoarding.ParticipationVm results = sut.buildVmParticipation(dm);
        //assert
        System.assertEquals('dm name', results.Name);
        System.assertEquals(50.00, results.PercentParticipation);
        System.assertEquals('bank', results.Bank);
        System.assertEquals(42.42, results.Amount);
        System.assertEquals('Sold', results.BoughtSold);
        System.assertEquals('loan name', results.Loan);
    }

    @IsTest
    static void it_should_return_this_vmParticipation_when_participationSold_is_false() {
        DmParticipation dm = new DmParticipation();
        dm.ParticipationSold = false;
        dm.Loan = new DmLoan();
        //act
        LoanBoarding.ParticipationVm results = sut.buildVmParticipation(dm);
        //assert
        System.assertEquals('Bought', results.BoughtSold);
    }

    @IsTest
    static void it_should_return_this_vmMemo_when_given_this_dm() {
        DmMemo dm = new DmMemo();
        dm.Changes = 'everyone hates change';
        dm.Description = 'this description is not good enough';
        //act
        Loanboarding.MemoVm results = sut.buildVmMemo(dm);
        //assert
        System.assertEquals('everyone hates change', results.Changes);
        System.assertEquals('this description is not good enough', results.Description);
    }

    @IsTest
    static void it_should_return_this_vmPayStream_when_given_this_dm() {
        Datetime dt = Datetime.newInstance(2020, 4, 16);
        DmLoanPaymentStream dm = new DmLoanPaymentStream();
        dm.Index = 1.1;
        dm.EffectiveDate = dt;
        dm.Duration = 2.2;
        dm.Frequency = 'frequency';
        dm.PaymentType = 'payment type';
        dm.Amount = 3.3; 
        //act
        LoanBoarding.LoanPaymentStreamVm results = sut.buildVmPayStream(dm);        
        //assert
        System.assertEquals(1.1, results.Index);
        System.assertEquals(dt, results.EffectiveDate);
        System.assertEquals(2.2, results.Duration);
        System.assertEquals('frequency', results.Frequency);
        System.assertEquals('payment type', results.PaymentType);
        System.assertEquals(3.3, results.Amount);
    }

    @IsTest
    static void it_should_return_this_vmRateStream_when_given_this_dmRateStream() {
        Datetime dt = Datetime.newInstance(2020, 4, 16);

        DmLoanRateStream dm = new DmLoanRateStream();
        dm.Index = 1.1;
        dm.Duration = 2.2;
        dm.Frequency = 'frequency';
        dm.PercentageOfLoan = 3.3;
        dm.RateType = 'rate type';
        dm.InterestRate = 4.4;
        dm.EffectiveDate = dt;
        dm.PerformanceRules = new List<DmLoanPerformanceRule>();
        //act
        LoanBoarding.LoanRateStreamVm results = sut.buildVmRateStream(dm);
        //assert
        System.assertEquals(1.1, results.Index);
        System.assertEquals(2.2, results.Duration);
        System.assertEquals('frequency', results.Frequency);
        System.assertEquals(3.3, results.PercentageOfLoan);
        System.assertEquals('rate type', results.RateType);
        System.assertEquals(4.4, results.InterestRate);
        System.assertEquals(dt, results.EffectiveDate);
    }

    @IsTest
    static void it_should_use_the_in_between_and_leave_rate_unchanged_string_template_when_building_vmOutcomes() {
        DmPerformanceRuleOutcome outcome01 = new DmPerformanceRuleOutcome();
        outcome01.ComparisonOperator = 'In Between';
        outcome01.MinComparisonValue = 5.00;
        outcome01.MaxComparisonValue = 10.00;
        outcome01.AdjustmentAction = 'Leave Rate Unchanged';

        DmLoanPerformanceRule dmRule01 = new DmLoanPerformanceRule();
        dmRule01.Name = 'rule name1';
        dmRule01.Outcomes = new List<DmPerformanceRuleOutcome>();
        dmRule01.Outcomes.add(outcome01);

        List<DmLoanPerformanceRule> dmRules = new List<DmLoanPerformanceRule>{dmRule01};

        DmLoanRateStream dm = new DmLoanRateStream();
        dm.PerformanceRules = dmRules;
        //act
        LoanBoarding.LoanRateStreamVm results = sut.buildVmRateStream(dm);
        //assert
        System.assertEquals('In Between 5.00 and 10.00 then Leave Rate Unchanged', results.PerformanceRules[0].Outcomes[0].Outcome);
    }

    @IsTest
    static void it_should_use_the_in_between_and_increase_rate_string_template_when_building_vmOutcomes() { 
        DmPerformanceRuleOutcome outcome01 = new DmPerformanceRuleOutcome();
        outcome01.ComparisonOperator = 'In Between';
        outcome01.MinComparisonValue = 5.00;
        outcome01.MaxComparisonValue = 10.00;
        outcome01.AdjustmentAction = 'Increase Rate';
        outcome01.AdjustmentAmount = 5;

        DmLoanPerformanceRule dmRule01 = new DmLoanPerformanceRule();
        dmRule01.Name = 'rule name1';
        dmRule01.Outcomes = new List<DmPerformanceRuleOutcome>();
        dmRule01.Outcomes.add(outcome01);

        List<DmLoanPerformanceRule> dmRules = new List<DmLoanPerformanceRule>{dmRule01};

        DmLoanRateStream dm = new DmLoanRateStream();
        dm.PerformanceRules = dmRules;
        //act
        LoanBoarding.LoanRateStreamVm results = sut.buildVmRateStream(dm);
        //assert
        System.assertEquals('In Between 5.00 and 10.00 then Increase Rate: 5%', results.PerformanceRules[0].Outcomes[0].Outcome);
    }

    @IsTest
    static void it_should_use_the_greater_than_and_leave_rate_unchanged_string_template_when_building_vmOutcomes() { 
        DmPerformanceRuleOutcome outcome01 = new DmPerformanceRuleOutcome();
        outcome01.ComparisonOperator = 'Greater Than';
        outcome01.ComparisonValue = 6.6;
        outcome01.AdjustmentAction = 'Leave Rate Unchanged';

        DmLoanPerformanceRule dmRule01 = new DmLoanPerformanceRule();
        dmRule01.Name = 'rule name1';
        dmRule01.Outcomes = new List<DmPerformanceRuleOutcome>();
        dmRule01.Outcomes.add(outcome01);

        List<DmLoanPerformanceRule> dmRules = new List<DmLoanPerformanceRule>{dmRule01};

        DmLoanRateStream dm = new DmLoanRateStream();
        dm.PerformanceRules = dmRules;
        //act
        LoanBoarding.LoanRateStreamVm results = sut.buildVmRateStream(dm);
        //assert
        System.assertEquals('Greater Than 6.6 then Leave Rate Unchanged', results.PerformanceRules[0].Outcomes[0].Outcome);
    }

    @IsTest
    static void it_should_use_the_greater_than_and_set_rate_string_template_when_building_vmOutcomes() { 
        DmPerformanceRuleOutcome outcome01 = new DmPerformanceRuleOutcome();
        outcome01.ComparisonOperator = 'Greater Than';
        outcome01.ComparisonValue = 6.6;
        outcome01.AdjustmentAction = 'Set Rate';
        outcome01.AdjustmentAmount = 5;

        DmLoanPerformanceRule dmRule01 = new DmLoanPerformanceRule();
        dmRule01.Name = 'rule name1';
        dmRule01.Outcomes = new List<DmPerformanceRuleOutcome>();
        dmRule01.Outcomes.add(outcome01);

        List<DmLoanPerformanceRule> dmRules = new List<DmLoanPerformanceRule>{dmRule01};

        DmLoanRateStream dm = new DmLoanRateStream();
        dm.PerformanceRules = dmRules;
        //act
        LoanBoarding.LoanRateStreamVm results = sut.buildVmRateStream(dm);
        //assert
        System.assertEquals('Greater Than 6.6 then Set Rate: 5%', results.PerformanceRules[0].Outcomes[0].Outcome);
    }

    @IsTest
    static void it_should_return_a_outcomeVM_that_tells_the_user_to_check_the_loan_record_for_details_and_alert_it_dept() { 
        DmLoanPerformanceRule dmRule01 = new DmLoanPerformanceRule();
        dmRule01.Name = 'rule name1';
        dmRule01.Outcomes = null;

        List<DmLoanPerformanceRule> dmRules = new List<DmLoanPerformanceRule>{dmRule01};

        DmLoanRateStream dm = new DmLoanRateStream();
        dm.PerformanceRules = dmRules;
        //act
        LoanBoarding.LoanRateStreamVm results = sut.buildVmRateStream(dm);
        //assert
        System.assertEquals('***Error*** Please Contact IT Dept.', results.PerformanceRules[0].Outcomes[0].Outcome);
    }

    private static DmLoan buildTestDmLoan() {
        DmLoan dm = new DmLoan();
        dm.Id = 'loan-Id';
        dm.Name = 'test-loan';
        dm.LookupKey = '616-11-20200';
        dm.ProductLine = 'test-product-line';
        dm.ProductType = 'test-product-type';
        dm.Product = 'test-product';
        dm.Application = '11';
        dm.AccountNumber = '20200';
        dm.OriginalAmount = 100000.00;
        dm.IsRenewal = true;
        dm.IsModification = false;
        dm.Channel = 'test-channel';
        dm.RegOLoan = true;
        dm.EmployeeLoan = false;
        dm.RiskGrade = 'test-risk';
        dm.NicheProducts = 'test-niche-products';
        dm.NicheProductsFx = 'test-niche-products-fx';
        dm.LoanCharacteristics = 'test-loan-characteristics';       
        dm.IndustryCode = 'test-industry-code';
        dm.UseOfFunds = 'test-use-of-funds';
        dm.OtherPurposeDescription = 'test-other-description';
        dm.LcComments = 'test-lc-comments';
        dm.RmComments = 'test-rm-comments';
        DmUnit unitDm = new DmUnit();
        unitDm.Name = 'test-unit';
        unitDm.BranchCode = 999;
        dm.Unit = unitDm;
        DmUser origUserDm = new DmUser();
        origUserDm.Name = 'test-orig-user-name';
        dm.OriginationOfficer = origUserDm; 
        DmUser svcUserDm = new DmUser();
        svcUserDm.Name = 'test-officer';
        dm.ServicingOfficer = svcUserDm;
        dm.LendingStrategy = 'test-strategy';
        dm.InterestRate = 2.300;
        dm.AmortizedMonth = 20;
        dm.MaturityMonth = 60;
        dm.FirstPaymentDate = date.newInstance(2016, 1,1);
        dm.PricingBasis = 'test-basis';
        dm.PaymentType = 'test-type';
        dm.PaymentSchedule = 'test-schedule';
        dm.Index = 'test-idx1';
        dm.Spread = 30.00;
        dm.RateFloor = 2.3;
        dm.RateCeiling = 2.6;
        dm.MonthlyPayment = 2000.00;
        dm.InterestRateAdjustmentFrequency = '1';
        dm.MaturityDate = Date.newInstance(2016,3,5);
        dm.LoanApplicationNumber = '#123456789';
        dm.COVID_19_Related_Loan = 'chuck norris';
        dm.SubjectToMilitaryLendingAct = 'military';
        dm.IsLoanToGovernmentRelatedEntity = 'government-entity';
        dm.IsRepaymentReliantOnAgriculturalIncome = 'ag-income';
        dm.IsLoanToFinancialInstitution = 'financial-institution';
        dm.DoesFinancialInstitutionAcceptDeposits = 'accept-deposits';
        dm.IsImmediateFunding = true;
        dm.WireAmount = 45.00;
        dm.DisbursingInstructions = 'disburse-instructions';
        DmUser createdByDm = new DmUser();
        createdByDm.Name = 'test-creator';
        dm.CreatedBy = createdByDm;
        DmUser loanCoordinatorDm = new DmUser();
        loanCoordinatorDm.Name = 'test-lc';
        dm.LoanCoordinator = loanCoordinatorDm;
        dm.RelatedEntities = new List<DmLoanEntityRelationship>();
        dm.PledgedCollateral = new List<DmLoanCollateralRelationship>();
        dm.Participations = new List<DmParticipation>();
        dm.Memos = new List<DmMemo>();
        dm.Fees = new List<DmFee>();
        dm.PayStreams = new List<DmLoanPaymentStream>();
        dm.RateStreams = new List<DmLoanRateStream>();
        
        return dm;
    }
}