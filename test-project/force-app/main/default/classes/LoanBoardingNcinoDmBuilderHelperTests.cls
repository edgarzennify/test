@IsTest
public class LoanBoardingNcinoDmBuilderHelperTests {

    private static LoanBoardingNcinoDmBuilderHelper sut;
    private static final Mock.ofIJson mockJson;

    static {
    	mockJson = new Mock.ofIJson();
        sut = new LoanBoardingNcinoDmBuilderHelper(mockJson);
    }

    @IsTest
    static void it_should_build_this_loan_dm() {
        Date dt = date.newInstance(2016,2,3);
        Id loanId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        
        PM_EB_Industry_Code_c code = new PM_EB_Industry_Code_c();
        code.Name = 'Solid Snake';

        PM_User testUser = new PM_User();
        testUser.Name = 'Kurt Russell';

        PM_LLCBI_Role_c testRole = new PM_LLCBI_Role_c();
        testRole.Name = 'Loan Coordinator';

        PM_LLCBI_LoanTeam_c teamMember = new PM_LLCBI_LoanTeam_c();
        teamMember.Primary_c = true;
        teamMember.LLCBI_User_r = testUser;
        teamMember.LLCBI_Assigned_Role_r = testRole;

        PM_EB_Unit_c unit = new PM_EB_Unit_c();
        unit.Name = 'unit name';
        unit.Branch_Number_c = 42.0;
        
        PM_LLCBI_Loan_c pmLoan = new PM_LLCBI_Loan_c();
        pmLoan.Id = loanId;
        pmLoan.Name = 'test-loan';
        pmLoan.LLCBI_lookupKey_c = '616-11-23405';
        pmLoan.LLCBI_Product_Line_c = 'test-productline';
        pmLoan.LLCBI_Product_Type_c = 'test-product-type';
        pmLoan.LLCBI_Product_c = 'test-product';
        pmLoan.Application_c = 2;
        pmLoan.Account_Number_c = '11223';
        pmLoan.LLCBI_Amount_c = 200.00;
        pmLoan.LLCBI_isRenewal_c = true;
        pmLoan.LLCBI_Is_Modification_c = false;
        pmLoan.Channel_c = 'test-channel';
        pmLoan.Reg_O_Loan_c = true;
        pmLoan.Employee_Loan_c = false;
        pmLoan.LLCBI_Risk_Grade_c = 'grade-3';
        pmLoan.Niche_Products_c = 'test-niche-product';   
        pmLoan.Niche_Products_fx_c = 'test-niche-product-fx';
        pmLoan.Loan_Characteristics_c = 'test-loan-characteristic'; 
        pmLoan.Use_of_Funds_Purpose_c = 'test-purpose';
        pmLoan.Other_Purpose_Description_c = 'test-other-purpose';
        pmLoan.LC_Comments_c = 'test-lc-comment';
        pmLoan.RM_Comments_c = 'test-rm-comment';
        pmLoan.Lending_Strategy_c = 'test-strategy';
        pmLoan.LLCBI_InterestRate_c = 2.00;
        pmLoan.LLCBI_Amortized_Term_Months_c = 60.0;
        pmLoan.LLCBI_Term_Months_c = 20.0;
        pmLoan.LLCBI_First_Payment_Date_c = dt;
        pmLoan.LLCBI_Pricing_Basis_c = 'test-basis';
        pmLoan.LLCBI_Payment_Type_c = 'test-payment-type';
        pmLoan.LLCBI_Payment_Schedule_c = '12';
        pmLoan.LLCBI_Index_c = '2';
        pmLoan.LLCBI_Spread_c = 3.0;
        pmLoan.LLCBI_Rate_Floor_c = 2.0;
        pmLoan.LLCBI_Rate_Ceiling_c = 2.0;
        pmLoan.LLCBI_Monthly_Payment_c = 120.00;
        pmLoan.LLCBI_Interest_Rate_Adjustment_Frequency_c = '12';
        pmLoan.LLCBI_Maturity_Date_c = dt;
        pmLoan.COVID_19_Related_Loan_c = 'Yes';
        pmLoan.EB_Industry_Code_r = code;
        pmLoan.LLCBI_Loan_Teams_r = new List<PM_LLCBI_LoanTeam_c>{teamMember};
        pmLoan.CreatedBy = testUser;
        pmLoan.Unit_r = unit;
        pmLoan.Originating_Officer_r = testUser;
        pmLoan.LLCBI_Loan_Officer_r = testUser;

        DmLoan results = sut.buildLoan(pmLoan);

        System.assertEquals(loanId, results.Id);
        System.assertEquals('test-loan', results.Name);
        System.assertEquals('616-11-23405', results.LookupKey);
        System.assertEquals('test-productline', results.ProductLine);
        System.assertEquals('test-product-type', results.ProductType);
        System.assertEquals('test-product', results.Product);
        System.assertEquals('2', results.Application);
        System.assertEquals('11223', results.AccountNumber);
        System.assertEquals(200, results.OriginalAmount);
        System.assertEquals(true, results.IsRenewal);
        System.assertEquals(false, results.IsModification);
        System.assertEquals('test-channel', results.Channel);
        System.assertEquals(true, results.RegOLoan);
        System.assertEquals(false, results.EmployeeLoan);
        System.assertEquals('grade-3', results.RiskGrade);
        System.assertEquals('test-niche-product', results.NicheProducts);
        System.assertEquals('test-niche-product-fx', results.NicheProductsFx);
        System.assertEquals('test-loan-characteristic', results.LoanCharacteristics);
        System.assertEquals('test-purpose', results.UseOfFunds);
        System.assertEquals('test-other-purpose', results.OtherPurposeDescription);
        System.assertEquals('test-lc-comment', results.LcComments);
        System.assertEquals('test-rm-comment', results.RmComments);
        System.assertEquals('test-strategy', results.LendingStrategy);
        System.assertEquals(2.00, results.InterestRate);
        System.assertEquals(60.0, results.amortizedMonth);
        System.assertEquals(20.0, results.MaturityMonth);
        System.assertEquals(dt, results.firstPaymentDate);
        System.assertEquals('test-basis', results.PricingBasis);
        System.assertEquals('test-payment-type', results.PaymentType);
        System.assertEquals('12', results.PaymentSchedule);
        System.assertEquals('2', results.Index);
        System.assertEquals(3.0, results.Spread);
        System.assertEquals(2.0, results.RateFloor);
        System.assertEquals(2.0, results.RateCeiling);
        System.assertEquals(120.00, results.MonthlyPayment);
        System.assertEquals('12', results.InterestRateAdjustmentFrequency);
        System.assertEquals(dt, results.MaturityDate);
        System.assertEquals('Yes', results.COVID_19_Related_Loan);
        System.assertEquals('Solid Snake', results.IndustryCode);
        System.assertEquals('Kurt Russell', results.LoanCoordinator.Name);
        System.assertEquals('Kurt Russell', results.CreatedBy.Name);
        System.assertEquals('unit name', results.Unit.Name);
        System.assertEquals(42, results.Unit.BranchCode);
        System.assertEquals('Kurt Russell', results.OriginationOfficer.Name);
        System.assertEquals('Kurt Russell', results.ServicingOfficer.Name);
    }

    @IsTest
    static void it_should_build_a_dm_related_entity() {
        Date dt = Date.newInstance(2016,2,3);
        PM_LLCBI_Loan_c loan = new PM_LLCBI_Loan_c();
        loan.Id = '4321';
        loan.Name = 'test loan';
        
        PM_Account entity = new PM_Account();
        entity.Id = '1234';
        entity.Name = 'test-entity';
        entity.BillingStreet = 'test-street';
        entity.BillingCity = 'test-city';
        entity.BillingState = 'test-state';
        entity.BillingPostalCode = 'postal-code';
        entity.Phone = '22-333';
        entity.Sic = '1123';
        entity.Birthdate_c = dt;
        entity.Reg_O_Code_c = 'reg-o';

        PM_LLCBI_Legal_Entities_c inv = new PM_LLCBI_Legal_Entities_c();
        inv.Id = '789';
        inv.Name = 'asdf';
        inv.Liabilities_c = 1200.00;
        inv.LLCBI_Relationship_Type_c = 'rel type';
        inv.LLCBI_Borrower_Type_c = 'bor type';
        inv.LLCBI_Contingent_Type_c = 'con type';
        inv.LLCBI_Ownership_c = 100.00;
        inv.LLCBI_Loan_r = loan;
        inv.LLCBI_Account_r = entity;
        
        EB_Industry_Code__c code = new EB_Industry_Code__c();
        code.Industry_Code__c = '1223';
        code.Name = '1223-test code';
        List<EB_Industry_Code__c> codes = new List<EB_Industry_Code__c>{code};

        DmLoanEntityRelationship results = sut.buildRelatedEntities(inv, codes);

        System.assertEquals('789', results.Id);
        System.assertEquals('asdf', results.Name);
        System.assertEquals(1200.00, results.Liabilities);
        System.assertEquals('bor type', results.RelationshipType);
        System.assertEquals('con type', results.ContingentType);
        System.assertEquals(100.00, results.ContingentPercentage);

        System.assertEquals('4321', results.Loan.Id);
        System.assertEquals('test loan', results.Loan.Name);

        System.assertEquals('1234', results.Entity.Id);
        System.assertEquals('test-entity', results.Entity.Name);
        System.assertEquals('test-street', results.Entity.BillingStreet);
        System.assertEquals('test-city', results.Entity.BillingCity);
        System.assertEquals('test-state', results.Entity.BillingState);
        System.assertEquals('postal-code', results.Entity.BillingPostalCode);
        System.assertEquals('22-333', results.Entity.Phone);
        System.assertEquals('1123', results.Entity.SicCode);
        System.assertEquals(dt, results.Entity.BirthDate);
        System.assertEquals('reg-o', results.Entity.RegOCode);
    }

    @IsTest
    static void it_should_build_dm_related_entity_with_tin_when_ssn_is_missing() {
        PM_LLCBI_Loan_c loan = new PM_LLCBI_Loan_c();
        
        PM_Account entity = new PM_Account();
        entity.TIN_SSN_c = '122-223-tin';

        PM_LLCBI_Legal_Entities_c inv = new PM_LLCBI_Legal_Entities_c();
        inv.LLCBI_Loan_r = loan;
        inv.LLCBI_Account_r = entity;
        
        List<EB_Industry_Code__c> codes = new List<EB_Industry_Code__c>();
        //act
        DmLoanEntityRelationship results = sut.buildRelatedEntities(inv, codes);
        //assert
        System.assertEquals('122-223-tin', results.Entity.TaxId);
    }

    @IsTest
    static void it_should_build_dm_related_entity_with_ssn_when_tin_is_missing() {
        PM_LLCBI_Loan_c loan = new PM_LLCBI_Loan_c();
        
        PM_Account entity = new PM_Account();
        entity.SSNTIN_Encrypted_c = '122-223-ssn';

        PM_LLCBI_Legal_Entities_c inv = new PM_LLCBI_Legal_Entities_c();
        inv.LLCBI_Loan_r = loan;
        inv.LLCBI_Account_r = entity;
        
        List<EB_Industry_Code__c> codes = new List<EB_Industry_Code__c>();
        //act
        DmLoanEntityRelationship results = sut.buildRelatedEntities(inv, codes);
        //assert
        System.assertEquals('122-223-ssn', results.Entity.TaxId);
    }

    @IsTest
    static void it_should_build_a_dm_related_collateral_when_collateral_is_owned() {
        Date dt = Date.newInstance(2020, 1, 1);
        PM_RecordType entityRT = new PM_RecordType();
        entityRT.Name = 'Pepsi';

        PM_Account pmEntity = new PM_Account();
        pmEntity.Id = '1234';
        pmEntity.Name = 'test pmEntity';
        pmEntity.EB_Client_Name_c = 'test core name';
        pmEntity.BillingStreet = 'test street';
        pmEntity.BillingCity = 'test city';
        pmEntity.BillingState = 'test state';
        pmEntity.BillingPostalCode = 'postal code';
        pmEntity.RecordType = entityRT;

        PM_LLCBI_Collateral_c pmCollateral = new PM_LLCBI_Collateral_c();
        pmCollateral.Id = '1';
        pmCollateral.Name = 'test-collateral';
        pmCollateral.LLCBI_Collateral_Name_c = 'collateral-name-field';
        pmCollateral.LLCBI_Lendable_Value_c = 10000.42;
        pmCollateral.Assignment_of_Rent_c = 'rent';
        pmCollateral.Flood_Insurance_Required_c = 'false';
        pmCollateral.Appraised_Value_reviewed_c = 615.25;
        pmCollateral.Valuation_Date_c = dt;
        pmCollateral.LLCBI_Street_Address_c = 'street';
        pmCollateral.LLCBI_City_c = 'city';
        pmCollateral.LLCBI_State_c = 'state';
        pmCollateral.LLCBI_Zip_Code_c = 'zip';
        pmCollateral.LLCBI_Collateral_Type_r = new PM_LLCBI_Collateral_Type_c();
        pmCollateral.Primary_Owner_r = pmEntity;
        pmCollateral.LLC_BI_Parcel_Number_c = '123456';

        PM_LLCBI_Loan_c pmLoan = new PM_LLCBI_Loan_c();
        pmLoan.Id = 'loanId';
        pmLoan.Name = 'test-loan-name';
        pmLoan.LLCBI_lookupKey_c = '789';

        PM_LLCBI_Loan_Collateral2_c pmPledge = new PM_LLCBI_Loan_Collateral2_c();
        pmPledge.Id = '1';
        pmPledge.Name = 'pmPledge-name';
        pmPledge.LLCBI_Lien_Position_c = 'test-position';
        pmPledge.LLCBI_Current_Lendable_Value_c = 4200.00;
        pmPledge.LLCBI_Is_Primary_c = true;
        pmPledge.Abundance_of_Caution_c = true;
        pmPledge.LLCBI_Collateral_r = pmCollateral;
        pmPledge.LLCBI_Loan_r = pmLoan;
        //act
        DmLoanCollateralRelationship results = sut.buildPledgedCollateral(pmPledge);
        //assert
        System.assertEquals('1', results.Id);
        System.assertEquals('pmPledge-name', results.Name);
        System.assertEquals('test-position', results.LienPosition);
        System.assertEquals(4200.00, results.LendableValue);
        System.assertEquals(true, results.IsPrimary);
        System.assertEquals(true, results.AbundanceOfCaution);

        System.assertEquals('loanId', results.Loan.Id);
        System.assertEquals('test-loan-name', results.Loan.Name);
        System.assertEquals('789', results.Loan.LookupKey);

        System.assertEquals('1', results.Collateral.Id);
        System.assertEquals('test-collateral', results.Collateral.Name);
        System.assertEquals('collateral-name-field', results.Collateral.CoreName);
        System.assertEquals(10000.42, results.Collateral.LendableValue);
        System.assertEquals('rent', results.Collateral.AssignmentOfRents);
        System.assertEquals('false', results.Collateral.FloodInsuranceRequired);
        System.assertEquals(615.25, results.Collateral.AppraisedValue);
        System.assertEquals(dt, results.Collateral.AppraisedValueDate);
        System.assertEquals('street', results.Collateral.Street);
        System.assertEquals('city', results.Collateral.City);
        System.assertEquals('state', results.Collateral.State);
        System.assertEquals('zip', results.Collateral.PostalCode);
        System.assertEquals('123456', results.Collateral.parcelNumber);
        
        System.assertEquals('1234', results.Collateral.PrimaryOwner.Id);
        System.assertEquals('test pmEntity', results.Collateral.PrimaryOwner.Name);
        System.assertEquals('test core name', results.Collateral.PrimaryOwner.CoreName);
        System.assertEquals('test street', results.Collateral.PrimaryOwner.BillingStreet);
        System.assertEquals('test city', results.Collateral.PrimaryOwner.BillingCity);
        System.assertEquals('test state', results.Collateral.PrimaryOwner.BillingState);
        System.assertEquals('postal code', results.Collateral.PrimaryOwner.BillingPostalCode);

        System.assertEquals('Pepsi', results.Collateral.PrimaryOwner.RecordType.Name);
    }

    @IsTest
    static void it_should_return_a_null_dmEntity_when_collateral_is_not_owned() {
        PM_LLCBI_Collateral_c pmCollateral = new PM_LLCBI_Collateral_c();
        pmCollateral.LLCBI_Collateral_Type_r = new PM_LLCBI_Collateral_Type_c();
        pmCollateral.Primary_Owner_r = null;

        PM_LLCBI_Loan_c pmLoan = new PM_LLCBI_Loan_c();

        PM_LLCBI_Loan_Collateral2_c pmPledge = new PM_LLCBI_Loan_Collateral2_c();
        pmPledge.LLCBI_Collateral_r = pmCollateral;
        pmPledge.LLCBI_Loan_r = pmLoan;
        //act
        DmLoanCollateralRelationship results = sut.buildPledgedCollateral(pmPledge);
        //assert
        System.assertEquals(null, results.Collateral.PrimaryOwner.Id);
        System.assertEquals(null, results.Collateral.PrimaryOwner.Name);
        System.assertEquals(null, results.Collateral.PrimaryOwner.CoreName);
        System.assertEquals(null, results.Collateral.PrimaryOwner.BillingStreet);
        System.assertEquals(null, results.Collateral.PrimaryOwner.BillingCity);
        System.assertEquals(null, results.Collateral.PrimaryOwner.BillingState);
        System.assertEquals(null, results.Collateral.PrimaryOwner.BillingPostalCode);
    }

    @IsTest
    static void it_should_return_description_from_the_pmPledge_record() {
        PM_LLCBI_Collateral_c pmCollateral = new PM_LLCBI_Collateral_c();
        pmCollateral.LLCBI_Collateral_Type_r = new PM_LLCBI_Collateral_Type_c();

        PM_LLCBI_Loan_c pmLoan = new PM_LLCBI_Loan_c();

        PM_LLCBI_Loan_Collateral2_c pmPledge = new PM_LLCBI_Loan_Collateral2_c();
        pmPledge.Description_c = 'description from pledge';
        pmPledge.LLCBI_Collateral_r = pmCollateral;
        pmPledge.LLCBI_Loan_r = pmLoan;
        //act
        DmLoanCollateralRelationship results = sut.buildPledgedCollateral(pmPledge);
        //assert
        System.assertEquals('description from pledge', results.Collateral.Description);
    }

    @IsTest
    static void it_should_return_description_from_the_pmCollateral_record() {
        PM_LLCBI_Collateral_c pmCollateral = new PM_LLCBI_Collateral_c();
        pmCollateral.LLCBI_Description_c = 'description from col';
        pmCollateral.LLCBI_Collateral_Type_r = new PM_LLCBI_Collateral_Type_c();

        PM_LLCBI_Loan_c pmLoan = new PM_LLCBI_Loan_c();

        PM_LLCBI_Loan_Collateral2_c pmPledge = new PM_LLCBI_Loan_Collateral2_c();
        pmPledge.Description_c = 'description from pledge';
        pmPledge.LLCBI_Collateral_r = pmCollateral;
        pmPledge.LLCBI_Loan_r = pmLoan;
        //act
        DmLoanCollateralRelationship results = sut.buildPledgedCollateral(pmPledge);
        //assert
        System.assertEquals('description from col', results.Collateral.Description);
    }

    @IsTest
    static void it_should_return_the_collateral_type_when_change_collateral_code_is_no() {
        PM_LLCBI_Collateral_Type_c colType = new PM_LLCBI_Collateral_Type_c();
        colType.Name = 'col type name';
        colType.LLCBI_Collateral_Code_c = 'code';

        PM_LLCBI_Collateral_c pmCollateral = new PM_LLCBI_Collateral_c();
        pmCollateral.Change_Collateral_Code_c = 'No';
        pmCollateral.LLCBI_Collateral_Type_r = colType;
        pmCollateral.Modified_Collateral_Type_r = null;

        PM_LLCBI_Loan_c pmLoan = new PM_LLCBI_Loan_c();

        PM_LLCBI_Loan_Collateral2_c pmPledge = new PM_LLCBI_Loan_Collateral2_c();
        pmPledge.LLCBI_Collateral_r = pmCollateral;
        pmPledge.LLCBI_Loan_r = pmLoan;
        //act
        DmLoanCollateralRelationship results = sut.buildPledgedCollateral(pmPledge);
        //assert
        System.assertEquals('col type name', results.Collateral.CollateralType.Name);
        System.assertEquals('code', results.Collateral.CollateralType.CollateralCode);
        System.assertEquals(false, results.Collateral.IsModifiedCollateralType);
    }

    @IsTest
    static void it_should_return_the_modified_collateral_type_when_change_collateral_code_is_yes() {
        PM_LLCBI_Collateral_Type_c colType = new PM_LLCBI_Collateral_Type_c();
        colType.Name = 'col type name';
        colType.LLCBI_Collateral_Code_c = 'code';

        PM_LLCBI_Collateral_c pmCollateral = new PM_LLCBI_Collateral_c();
        pmCollateral.Change_Collateral_Code_c = 'Yes';
        pmCollateral.LLCBI_Collateral_Type_r = null;
        pmCollateral.Modified_Collateral_Type_r = colType;

        PM_LLCBI_Loan_c pmLoan = new PM_LLCBI_Loan_c();

        PM_LLCBI_Loan_Collateral2_c pmPledge = new PM_LLCBI_Loan_Collateral2_c();
        pmPledge.LLCBI_Collateral_r = pmCollateral;
        pmPledge.LLCBI_Loan_r = pmLoan;
        //act
        DmLoanCollateralRelationship results = sut.buildPledgedCollateral(pmPledge);
        //assert
        System.assertEquals('col type name', results.Collateral.CollateralType.Name);
        System.assertEquals('code', results.Collateral.CollateralType.CollateralCode);
        System.assertEquals(true, results.Collateral.IsModifiedCollateralType);
    }

    @IsTest
    static void it_should_build_a_dmParticipation() {
        PM_LLCBI_Loan_c pmLoan = new PM_LLCBI_Loan_c();
        pmLoan.Id = 'loanId';
        pmLoan.Name = 'loanName';
        
        PM_LLCBI_Participation_c pmPart = new PM_LLCBI_Participation_c();
        pmPart.Id = 'pmPartId';
        pmPart.Name = 'test name';
        pmPart.LLCBI_Participated_c = 12.00;
        pmPart.Bank_c = 'test bank';
        pmPart.Amount_c = 42.42;
        pmpart.LLCBI_Loan_r = pmLoan;
        //act
        DmParticipation results = sut.buildParticipation(pmPart);
        //assert
        System.assertEquals('pmPartId', results.Id);
        System.assertEquals('test name', results.Name);
        System.assertEquals(12.00, results.PercentParticipation);
        System.assertEquals('test bank', results.Bank);
        System.assertEquals(42.42, results.Amount);

        System.assertEquals('loanId', results.Loan.Id);
        System.assertEquals('loanName', results.Loan.Name);
    }

    @IsTest
    static void it_should_return_participationSold_as_false_when_given_this_pm() {
        PM_LLCBI_Loan_c pmLoan = new PM_LLCBI_Loan_c();
        
        PM_LLCBI_Participation_c pmPart = new PM_LLCBI_Participation_c();
        pmPart.Participation_Sold_c = null;
        pmpart.LLCBI_Loan_r = pmLoan;
        //act
        DmParticipation results = sut.buildParticipation(pmPart);
        //assert
        System.assertEquals(false, results.ParticipationSold);
    }

    @IsTest
    static void it_should_return_participationSold_as_true_when_given_this_pm() {
        PM_LLCBI_Loan_c pmLoan = new PM_LLCBI_Loan_c();
        
        PM_LLCBI_Participation_c pmPart = new PM_LLCBI_Participation_c();
        pmPart.Participation_Sold_c = true;
        pmpart.LLCBI_Loan_r = pmLoan;
        //act
        DmParticipation results = sut.buildParticipation(pmPart);
        //assert
        System.assertEquals(true, results.ParticipationSold);
    }

    @IsTest
    static void it_should_a_dmMemo_without_changes() {
        PM_LLCBI_Change_Memo_c pmMemo = new PM_LLCBI_Change_Memo_c();
        pmMemo.Name = 'test name';
        pmMemo.LLCBI_Description_c = 'test description';
        pmMemo.Add_Collateral_c = false;
        pmMemo.LLCBI_Approval_Required_c = false;
        pmMemo.Changing_Borrower_s_Name_Address_or_Tax_c = false;
        pmMemo.LLCBI_Collateral_Change_c = false;
        pmMemo.Collateral_going_from_lesser_position_to_c = false;
        pmMemo.Covenant_Changes_c = false;
        pmMemo.LLCBI_Equity_Injection_Change_c = false;
        pmMemo.Fees_Change_c = false;
        pmMemo.LLCBI_Guarantor_Added_c = false;
        pmMemo.LLCBI_Guarantor_Removed_c = false;
        pmMemo.LLCBI_Life_Insurance_Change_c = false;
        pmMemo.LLCBI_Amount_Change_c = false;
        pmMemo.LLCBI_Loan_Term_Change_c = false;
        pmMemo.Maturity_Date_Change_c = false;
        pmMemo.LLCBI_New_Rate_Requested_c = false;
        pmMemo.LLCBI_Notify_Attorney_c = false;
        pmMemo.LLCBI_Other_c = false;
        pmMemo.Post_Approval_Requirements_changes_c = false;
        pmMemo.LLCBI_Post_Close_Items_c = false;
        pmMemo.LLCBI_Ready_for_Approval_c = false;
        pmMemo.LLCBI_Re_approval_After_Expiration_c = false;
        pmMemo.LLCBI_Seller_Note_Change_c = false;
        pmMemo.Shortening_Maturity_Date_or_Amortization_c = false;
        pmMemo.LLCBI_Use_of_Proceeds_Change_c = false;
        pmMemo.LLCBI_User_Initiated_c = false;
        //act
        DmMemo results = sut.buildMemo(pmMemo);
        //assert
        System.assertEquals('test name', results.Name);
        System.assertEquals('test description', results.Description);
        System.assertEquals('', results.Changes);
    }

    @IsTest
    static void it_should_a_dmMemo_with_changes() {
        PM_LLCBI_Change_Memo_c pmMemo = new PM_LLCBI_Change_Memo_c();
        pmMemo.Add_Collateral_c = true;
        pmMemo.LLCBI_Approval_Required_c = false;
        pmMemo.Changing_Borrower_s_Name_Address_or_Tax_c = false;
        pmMemo.LLCBI_Collateral_Change_c = false;
        pmMemo.Collateral_going_from_lesser_position_to_c = false;
        pmMemo.Covenant_Changes_c = false;
        pmMemo.LLCBI_Equity_Injection_Change_c = false;
        pmMemo.Fees_Change_c = false;
        pmMemo.LLCBI_Guarantor_Added_c = false;
        pmMemo.LLCBI_Guarantor_Removed_c = false;
        pmMemo.LLCBI_Life_Insurance_Change_c = false;
        pmMemo.LLCBI_Amount_Change_c = false;
        pmMemo.LLCBI_Loan_Term_Change_c = false;
        pmMemo.Maturity_Date_Change_c = false;
        pmMemo.LLCBI_New_Rate_Requested_c = false;
        pmMemo.LLCBI_Notify_Attorney_c = false;
        pmMemo.LLCBI_Other_c = true;
        pmMemo.Post_Approval_Requirements_changes_c = false;
        pmMemo.LLCBI_Post_Close_Items_c = false;
        pmMemo.LLCBI_Ready_for_Approval_c = false;
        pmMemo.LLCBI_Re_approval_After_Expiration_c = false;
        pmMemo.LLCBI_Seller_Note_Change_c = false;
        pmMemo.Shortening_Maturity_Date_or_Amortization_c = false;
        pmMemo.LLCBI_Use_of_Proceeds_Change_c = false;
        pmMemo.LLCBI_User_Initiated_c = true;
        //act
        DmMemo results = sut.buildMemo(pmMemo);
        //assert
        System.assertEquals('Add Collateral,Other,User Initiated,', results.Changes);
    }

    @IsTest
    static void it_should_build_a_dmPaystream() {
        Datetime dt = Datetime.newInstance(2020, 1, 1);
        
        PM_LLCBI_Pricing_Stream_c pmPricingStream = new PM_LLCBI_Pricing_Stream_c();
        pmPricingStream.LLCBI_Sequence_c = 1.1;
        pmPricingStream.LLCBI_Term_Unit_c = 'Unit_asdf';
        pmPricingStream.LLCBI_Term_Length_c = 2.2;
        pmPricingStream.LLCBI_Effective_Date_c = dt;

        PM_LLCBI_Pricing_Payment_Component_c pmPayStream = new PM_LLCBI_Pricing_Payment_Component_c();
        pmPayStream.LLCBI_Type_c = 'test type';
        pmPayStream.LLCBI_Amount_c = 42.00;
        pmPayStream.LLCBI_Pricing_Stream_r = pmPricingStream;
        //act
        DmLoanPaymentStream results = sut.buildPayStream(pmPayStream);
        //assert
        System.assertEquals('test type', results.PaymentType);
        System.assertEquals(42.00, results.Amount);
        System.assertEquals(1.1, results.Index);
        System.assertEquals('asdf', results.Frequency);
        System.assertEquals(2.2, results.Duration);
        System.assertEquals(dt, results.EffectiveDate);
    }

    @IsTest
    static void it_should_build_a_dmRatestream_with_a_fixed_rateType() {
        Datetime dt = Datetime.newInstance(2020, 1, 1);
        
        PM_LLCBI_Pricing_Stream_c pmPricingStream = new PM_LLCBI_Pricing_Stream_c();
        pmPricingStream.LLCBI_Sequence_c = 1.1;
        pmPricingStream.LLCBI_Term_Unit_c = 'Unit_asdf';
        pmPricingStream.LLCBI_Term_Length_c = 2.2;
        pmPricingStream.LLCBI_Effective_Date_c = dt;

        PM_LLCBI_Pricing_Rate_Component_c pmRateStream = new PM_LLCBI_Pricing_Rate_Component_c();
        pmRateStream.LLCBI_Applied_Loan_Percentage_c = 3.3;
        pmRateStream.LLCBI_Rate_c = 4.4;
        pmRateStream.LLCBI_Is_Fixed_c = true;
        pmRateStream.LLCBI_Pricing_Stream_r = pmPricingStream;
        pmRateStream.LLCBI_Pricing_Covenants_r = new List<PM_LLCBI_Pricing_Covenant_c>();
        //act
        DmLoanRateStream results = sut.buildRateStream(pmRateStream);
        //assert
        System.assertEquals(3.3, results.PercentageOfLoan);
        System.assertEquals(4.4, results.InterestRate);
        System.assertEquals('Fixed', results.RateType);
        System.assertEquals(1.1, results.Index);
        System.assertEquals('asdf', results.Frequency);
        System.assertEquals(2.2, results.Duration);
        System.assertEquals(dt, results.EffectiveDate);
    }

    @IsTest
    static void it_should_build_a_dmRatestream_with_a_variable_rateType() {
        PM_LLCBI_Pricing_Stream_c pmPricingStream = new PM_LLCBI_Pricing_Stream_c();
        pmPricingStream.LLCBI_Term_Unit_c = 'Unit_asdf';
        PM_LLCBI_Pricing_Rate_Component_c pmRateStream = new PM_LLCBI_Pricing_Rate_Component_c();
        pmRateStream.LLCBI_Is_Fixed_c = false;
        pmRateStream.LLCBI_Pricing_Stream_r = pmPricingStream;
        pmRateStream.LLCBI_Pricing_Covenants_r = new List<PM_LLCBI_Pricing_Covenant_c>();
        //act
        DmLoanRateStream results = sut.buildRateStream(pmRateStream);
        //assert
        System.assertEquals('Variable', results.RateType);
    }

    @IsTest
    static void it_should_build_a_dmRateStream_with_a_dmLoanPerformanceRule() {
        DmPerformanceRuleOutcome dmOutcome01 = new DmPerformanceRuleOutcome();
        dmOutcome01.ComparisonOperator = '1';
        dmOutcome01.ComparisonValue = 1.1;
        dmOutcome01.AdjustmentAction = 'dvorak';
        dmOutcome01.AdjustmentAmount = 2.2;
        DmPerformanceRuleOutcome dmOutcome02 = new DmPerformanceRuleOutcome();
        dmOutcome02.ComparisonOperator = '2';
        dmOutcome02.ComparisonValue = 1.1;
        dmOutcome02.AdjustmentAction = 'dvorak';
        dmOutcome02.AdjustmentAmount = 2.2;
        List<DmPerformanceRuleOutcome> outcomes01 = new List<DmPerformanceRuleOutcome>{dmOutcome01,dmOutcome02};
        
        List<DmPerformanceRuleOutcome> outcomes02 = new List<DmPerformanceRuleOutcome>();

        DmLoanPerformanceRule dmRule01 = new DmLoanPerformanceRule();
        dmRule01.Outcomes = outcomes01;
        DmLoanPerformanceRule dmRule02 = new DmLoanPerformanceRule();
        dmRule02.Outcomes = outcomes02;

        PM_LLCBI_Pricing_Stream_c pmPricingStream = new PM_LLCBI_Pricing_Stream_c();
        pmPricingStream.LLCBI_Term_Unit_c = 'Unit_asdf';

        PM_LLCBI_Pricing_Covenant_c pmCov01 = new PM_LLCBI_Pricing_Covenant_c();
        pmCov01.Name = 'cov name01';
        pmCov01.LLCBI_Rules_c = JSON.serialize(outcomes01);
        PM_LLCBI_Pricing_Covenant_c pmCov02 = new PM_LLCBI_Pricing_Covenant_c();
        pmCov02.Name = 'cov name02';
        pmCov02.LLCBI_Rules_c = JSON.serialize(outcomes02);
        
        List<PM_LLCBI_Pricing_Covenant_c> covenants = new List<PM_LLCBI_Pricing_Covenant_c>{pmCov01,pmCov02};

        PM_LLCBI_Pricing_Rate_Component_c pmRateStream = new PM_LLCBI_Pricing_Rate_Component_c();
        pmRateStream.LLCBI_Pricing_Stream_r = pmPricingStream;
        pmRateStream.LLCBI_Pricing_Covenants_r = covenants;

        mockJson.setup('deserialize', new List<Object>{pmCov01.LLCBI_Rules_c, List<DmPerformanceRuleOutcome>.class}).returns(outcomes01);
        mockJson.setup('deserialize', new List<Object>{pmCov02.LLCBI_Rules_c, List<DmPerformanceRuleOutcome>.class}).returns(outcomes02);
        //act
        DmLoanRateStream results = sut.buildRateStream(pmRateStream);
        //assert
        System.assertEquals(2, results.PerformanceRules.size());
        System.assertEquals('cov name01', results.PerformanceRules[0].Name);
        System.assertEquals(dmOutcome01, results.PerformanceRules[0].Outcomes[0]);
        System.assertEquals(dmOutcome02, results.PerformanceRules[0].Outcomes[1]);
        System.assertEquals('cov name02', results.PerformanceRules[1].Name);
        System.assertEquals(0, results.PerformanceRules[1].Outcomes.size());
    }

    @IsTest
    static void it_should_build_a_dmRateStream_with_a_dmLoanPerformanceRule_with_a_dummy_outcome_when_deserialize_fails() {
        PM_LLCBI_Pricing_Stream_c pmPricingStream = new PM_LLCBI_Pricing_Stream_c();
        pmPricingStream.LLCBI_Term_Unit_c = 'Unit_asdf';

        PM_LLCBI_Pricing_Covenant_c pmCov01 = new PM_LLCBI_Pricing_Covenant_c();
        pmCov01.Name = 'cov name01';
        pmCov01.LLCBI_Rules_c = 'improper json string';
        
        List<PM_LLCBI_Pricing_Covenant_c> covenants = new List<PM_LLCBI_Pricing_Covenant_c>{pmCov01};

        PM_LLCBI_Pricing_Rate_Component_c pmRateStream = new PM_LLCBI_Pricing_Rate_Component_c();
        pmRateStream.LLCBI_Pricing_Stream_r = pmPricingStream;
        pmRateStream.LLCBI_Pricing_Covenants_r = covenants;

        mockJson.setup('deserialize', new List<Object>{pmCov01.LLCBI_Rules_c, List<DmPerformanceRuleOutcome>.class})
            .throws(new applicationException());
        //act
        DmLoanRateStream results = sut.buildRateStream(pmRateStream);
        //assert
        System.assertEquals(null, results.PerformanceRules[0].Outcomes);
    }
}