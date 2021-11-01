@IsTest
public class LoanBoardingDataProviderTest {
    private static final LoanBoardingDataProvider sut;
    private static final Date BIRTH_DATE = Date.newInstance(2020, 4, 4);
    
    static {
        sut = new LoanBoardingDataProvider();
    }

    @IsTest
    static void it_should_return_this_PM_LLCBI_Loan_c_when_getLoan_is_called() {
        Date firstPaymentDate = Date.newInstance(2020, 1, 1);
        Date maturityDate = Date.newInstance(2020, 2, 2);
        Date valuationDate = Date.newInstance(2020, 3, 3);
        
        EB_Unit__c testUnit = new EB_Unit__c(
            Name = 'test unit name',
            Branch_Number__c = 789,
            Phone_Number__c = '123456789',
            Unit_Reporting_Label__c = 'test reporting label'
        );
        insert testUnit;

        User testUser = ObjectFactory.getUser('ebapi');

        EB_Industry_Code__c testIndustryCode = new EB_Industry_Code__c(
            Name = 'test industry code'
        );
        insert testIndustryCode;

        Account testAccount = buildTestAccount();
        insert testAccount;

        LLC_BI__Loan__c loan = buildnCinoLoan(firstPaymentDate, maturityDate);
        loan.Unit__c = testUnit.Id;
        loan.Originating_Officer__c = testUser.Id;
        loan.LLC_BI__Loan_Officer__c = testUser.Id;
        loan.EB_Industry_Code__c = testIndustryCode.Id;
        loan.LLC_BI__Account__c = testAccount.Id;
        insert loan;

        List<LLC_BI__Collateral__c> testCollateral = buildCollateral(2, valuationDate, testAccount);
        insert testCollateral;
        LLC_BI__Loan_Collateral_Aggregate__c aggregate = new LLC_BI__Loan_Collateral_Aggregate__c();
        insert aggregate;
        List<LLC_BI__Loan_Collateral2__c> collateralPledges = buildLoanCollateralPledges(loan.Id, testCollateral, aggregate);
        insert collateralPledges;
        List<LLC_BI__Legal_Entities__c> testLegalEntities = buildLegalEntities(testAccount.Id, loan.Id);
        insert testLegalEntities;
        List<LLC_BI__Participation__c> testParticipations = buildParticipations(loan.Id);
        insert testParticipations;
        List<LLC_BI__LoanTeam__c> testTeamMembers = buildLoanTeamMembers(testUser, loan.Id);
        insert testTeamMembers;
        List<LLC_BI__Credit_Memo_Modifcation__c> testChangeMemos = buildMemos(loan.Id, testUser.Id);
        insert testChangeMemos;
        //act
        PM_LLCBI_Loan_c results = sut.getnCinoLoan(loan.Id);
        //assert
        System.assertEquals(loan.Id, results.Id);
        System.assertEquals('test loan', results.Name);
        System.assertEquals('test product type', results.LLCBI_Product_Type_c);
        System.assertEquals('test product line', results.LLCBI_Product_Line_c);
        System.assertEquals('test product', results.LLCBI_Product_c);
        System.assertEquals(100, results.LLCBI_Amount_Available_c);
        System.assertEquals(500.00, results.LLCBI_Amount_c);
        System.assertEquals(123456, results.Application_c);
        System.assertEquals('test account number', results.Account_Number_c);
        System.assertEquals('test lookupKey', results.LLCBI_LookupKey_c);
        System.assertEquals(false, results.LLCBI_isRenewal_c);
        System.assertEquals(false, results.LLCBI_Is_Modification_c);
        System.assertEquals('test channel', results.Channel_c);
        System.assertEquals(false, results.Reg_O_Loan_c);
        System.assertEquals(false, results.Employee_Loan_c);
        System.assertEquals('test risk grade', results.LLCBI_Risk_Grade_c);
        System.assertEquals('N/A', results.Niche_Products_c);
        System.assertEquals('N/A', results.Niche_Products_fx_c);
        System.assertEquals('Bank-qualified Tax Credit', results.Loan_Characteristics_c);
        System.assertEquals('test use of funds', results.Use_of_Funds_Purpose_c);
        System.assertEquals('test other purpose description', results.Other_Purpose_Description_c);
        System.assertEquals('test lc comments', results.LC_Comments_c);
        System.assertEquals('test rm comments', results.RM_Comments_c);
        System.assertEquals('test lending strat', results.Lending_Strategy_c);
        System.assertEquals(5.115, results.LLCBI_InterestRate_c);
        System.assertEquals(firstPaymentDate, results.LLCBI_First_Payment_Date_c);
        System.assertEquals(48, results.LLCBI_Amortized_Term_Months_c);
        System.assertEquals(48, results.LLCBI_Term_Months_c);
        System.assertEquals(maturityDate, results.LLCBI_Maturity_Date_c);
        System.assertEquals('test pricing basis', results.LLCBI_Pricing_Basis_c);
        System.assertEquals('test payment type', results.LLCBI_Payment_Type_c);
        System.assertEquals('test payment schedule', results.LLCBI_Payment_Schedule_c);
        System.assertEquals('test index', results.LLCBI_Index_c);
        System.assertEquals(0.1587, results.LLCBI_Spread_c);
        System.assertEquals(1.425, results.LLCBI_Rate_Floor_c);
        System.assertEquals(43.852, results.LLCBI_Rate_Ceiling_c);
        System.assertEquals(4563.20, results.LLCBI_Monthly_Payment_c);
        System.assertEquals('test interest rate adj freq', results.LLCBI_Interest_Rate_Adjustment_Frequency_c);
        System.assertNotEquals(null, results.Application_Number_c);
        System.assertEquals('No', results.Military_Lending_Act_c);
        System.assertEquals('test loan to gov related ent', results.Is_Loan_to_Gov_t_Related_Entity_c);
        System.assertEquals('test repayment reliant', results.Is_Repayment_Reliant_on_Ag_Income_c);
        System.assertEquals('test loan to financial', results.Is_Loan_to_Financial_Institution_c);
        System.assertEquals('test fina inst accept', results.Financial_Institution_Accept_Deposits_c);
        System.assertEquals(true , results.Immediate_Funding_c);
        System.assertEquals(11111.25 , results.Wire_Amount_c);
        System.assertEquals('test disburse instructions' , results.Disbursing_Instructions_c);
        System.assertEquals('No', results.COVID_19_Related_Loan_c);

        System.assertEquals('test unit name', results.Unit_r.Name);
        System.assertEquals(789, results.Unit_r.Branch_Number_c);

        System.assertEquals(testAccount.Id, results.LLCBI_Account_r.Id);
        System.assertEquals('test account name', results.LLCBI_Account_r.Name);
        System.assertEquals('Corporation', results.LLCBI_Account_r.Type);
        System.assertEquals('test b street', results.LLCBI_Account_r.BillingStreet);
        System.assertEquals('test b city', results.LLCBI_Account_r.BillingCity);
        System.assertEquals('test b postal code', results.LLCBI_Account_r.BillingPostalCode);
        System.assertEquals('test b state', results.LLCBI_Account_r.BillingState);
        System.assertEquals('Client', results.LLCBI_Account_r.RecordType.Name);
        
        System.assertEquals('EBAPI', results.Originating_Officer_r.Name); 
        System.assertEquals('EBAPI', results.LLCBI_Loan_Officer_r.Name);
        System.assertNotEquals(null, results.CreatedBy.Name);

        System.assertEquals(2, results.LLCBI_Loan_Collateral_r.size());
        System.assertEquals(collateralPledges[0].Id, results.LLCBI_Loan_Collateral_r[0].Id);
        System.assertNotEquals(null, results.LLCBI_Loan_Collateral_r[0].Name);
        System.assertEquals('test collateral description 0', results.LLCBI_Loan_Collateral_r[0].Description_c);
        System.assertEquals('test lien position', results.LLCBI_Loan_Collateral_r[0].LLCBI_Lien_Position_c);
        System.assertEquals('test col type name', results.LLCBI_Loan_Collateral_r[0].LLCBI_Collateral_Type_c);
        System.assertEquals(3985.12, results.LLCBI_Loan_Collateral_r[0].LLCBI_Current_Lendable_Value_c);
        System.assertEquals(true, results.LLCBI_Loan_Collateral_r[0].LLCBI_Is_Primary_c);
        System.assertEquals(false, results.LLCBI_Loan_Collateral_r[0].Abundance_of_Caution_c);
        System.assertEquals(3985.12, results.LLCBI_Loan_Collateral_r[0].LLCBI_Current_Lendable_Value_c);

        System.assertEquals(loan.Id, results.LLCBI_Loan_Collateral_r[0].LLCBI_Loan_r.Id);
        System.assertEquals('test loan', results.LLCBI_Loan_Collateral_r[0].LLCBI_Loan_r.Name);
        System.assertEquals('test lookupKey', results.LLCBI_Loan_Collateral_r[0].LLCBI_Loan_r.LLCBI_lookupKey_c);
        
        System.assertEquals(testCollateral[0].Id, results.LLCBI_Loan_Collateral_r[0].LLCBI_Collateral_r.Id);
        System.assertNotEquals(null, results.LLCBI_Loan_Collateral_r[0].LLCBI_Collateral_r.Name);
        System.assertEquals('test name 0', results.LLCBI_Loan_Collateral_r[0].LLCBI_Collateral_r.LLCBI_Collateral_Name_c);
        System.assertEquals('test col code', results.LLCBI_Loan_Collateral_r[0].LLCBI_Collateral_r.Change_Collateral_Code_c);
        System.assertEquals('test sync key', results.LLCBI_Loan_Collateral_r[0].LLCBI_Collateral_r.Sync_Key_c);
        System.assertNotEquals(null, results.LLCBI_Loan_Collateral_r[0].LLCBI_Collateral_r.CreatedDate);
        System.assertNotEquals(null, results.LLCBI_Loan_Collateral_r[0].LLCBI_Collateral_r.LLCBI_Lendable_Value_c);
        System.assertEquals('test ass rent', results.LLCBI_Loan_Collateral_r[0].LLCBI_Collateral_r.Assignment_of_Rent_c);
        System.assertEquals('No', results.LLCBI_Loan_Collateral_r[0].LLCBI_Collateral_r.Flood_Insurance_Required_c);
        System.assertEquals(6514.25, results.LLCBI_Loan_Collateral_r[0].LLCBI_Collateral_r.Appraised_Value_reviewed_c);
        System.assertEquals(valuationDate, results.LLCBI_Loan_Collateral_r[0].LLCBI_Collateral_r.Valuation_Date_c);
        System.assertEquals('test col description', results.LLCBI_Loan_Collateral_r[0].LLCBI_Collateral_r.LLCBI_Description_c);
        System.assertEquals('test col street address', results.LLCBI_Loan_Collateral_r[0].LLCBI_Collateral_r.LLCBI_Street_Address_c);
        System.assertEquals('test col city', results.LLCBI_Loan_Collateral_r[0].LLCBI_Collateral_r.LLCBI_City_c);
        System.assertEquals('test col state', results.LLCBI_Loan_Collateral_r[0].LLCBI_Collateral_r.LLCBI_State_c);
        System.assertEquals('63139', results.LLCBI_Loan_Collateral_r[0].LLCBI_Collateral_r.LLCBI_Zip_Code_c);
        System.assertEquals('123456', results.LLCBI_Loan_Collateral_r[0].LLCBI_Collateral_r.LLC_BI_Parcel_Number_c);

        System.assertEquals('test col type name', results.LLCBI_Loan_Collateral_r[0].LLCBI_Collateral_r.LLCBI_Collateral_Type_r.Name);
        System.assertEquals('test col type code', results.LLCBI_Loan_Collateral_r[0].LLCBI_Collateral_r.LLCBI_Collateral_Type_r.LLCBI_Collateral_Code_c);

        System.assertEquals('test col type name', results.LLCBI_Loan_Collateral_r[0].LLCBI_Collateral_r.Modified_Collateral_Type_r.Name);
        System.assertEquals('test col type code', results.LLCBI_Loan_Collateral_r[0].LLCBI_Collateral_r.Modified_Collateral_Type_r.LLCBI_Collateral_Code_c);

        System.assertEquals(testAccount.Id, results.LLCBI_Loan_Collateral_r[0].LLCBI_Collateral_r.Primary_Owner_r.Id);
        System.assertEquals('test account name', results.LLCBI_Loan_Collateral_r[0].LLCBI_Collateral_r.Primary_Owner_r.Name);
        System.assertEquals('test eb client name', results.LLCBI_Loan_Collateral_r[0].LLCBI_Collateral_r.Primary_Owner_r.EB_Client_Name_c);
        System.assertEquals('test b street', results.LLCBI_Loan_Collateral_r[0].LLCBI_Collateral_r.Primary_Owner_r.BillingStreet);
        System.assertEquals('test b city', results.LLCBI_Loan_Collateral_r[0].LLCBI_Collateral_r.Primary_Owner_r.BillingCity);
        System.assertEquals('test b state', results.LLCBI_Loan_Collateral_r[0].LLCBI_Collateral_r.Primary_Owner_r.BillingState);
        System.assertEquals('test b postal code', results.LLCBI_Loan_Collateral_r[0].LLCBI_Collateral_r.Primary_Owner_r.BillingPostalCode);
        System.assertEquals('Client', results.LLCBI_Loan_Collateral_r[0].LLCBI_Collateral_r.Primary_Owner_r.RecordType.Name);

        System.assertEquals(2, results.LLCBI_Legal_Entities_r.size());
        System.assertNotEquals(null, results.LLCBI_Legal_Entities_r[0].Id);
        System.assertEquals('test relationship type', results.LLCBI_Legal_Entities_r[0].LLCBI_Relationship_Type_c);
        System.assertEquals('test borrower type', results.LLCBI_Legal_Entities_r[0].LLCBI_Borrower_Type_c);
        System.assertEquals(5000, results.LLCBI_Legal_Entities_r[0].Liabilities_c);
        System.assertEquals('test address', results.LLCBI_Legal_Entities_r[0].LLCBI_Address_c);
        System.assertEquals('test contingent type', results.LLCBI_Legal_Entities_r[0].LLCBI_Contingent_Type_c);
        System.assertEquals(100.00, results.LLCBI_Legal_Entities_r[0].LLCBI_Ownership_c);
        System.assertEquals('test limitations', results.LLCBI_Legal_Entities_r[0].Limitations_c);
        
        System.assertEquals(testAccount.Id, results.LLCBI_Legal_Entities_r[0].LLCBI_Account_r.Id);
        System.assertEquals('test account name', results.LLCBI_Legal_Entities_r[0].LLCBI_Account_r.Name);
        System.assertNotEquals(null, results.LLCBI_Legal_Entities_r[0].LLCBI_Account_r.Entity_Name_c);
        System.assertEquals('test eb client name', results.LLCBI_Legal_Entities_r[0].LLCBI_Account_r.EB_Client_Name_c);
        System.assertNotEquals(null, results.LLCBI_Legal_Entities_r[0].LLCBI_Account_r.CreatedDate);
        System.assertEquals('test b street', results.LLCBI_Legal_Entities_r[0].LLCBI_Account_r.BillingStreet);
        System.assertEquals('test b city', results.LLCBI_Legal_Entities_r[0].LLCBI_Account_r.BillingCity);
        System.assertEquals('test b state', results.LLCBI_Legal_Entities_r[0].LLCBI_Account_r.BillingState);
        System.assertEquals('test b postal code', results.LLCBI_Legal_Entities_r[0].LLCBI_Account_r.BillingPostalCode);
        System.assertEquals('1111111111', results.LLCBI_Legal_Entities_r[0].LLCBI_Account_r.Phone);
        System.assertEquals('test sic', results.LLCBI_Legal_Entities_r[0].LLCBI_Account_r.Sic);
        System.assertEquals('test sub type', results.LLCBI_Legal_Entities_r[0].LLCBI_Account_r.Sub_Type_c); 
        System.assertEquals('test snn', results.LLCBI_Legal_Entities_r[0].LLCBI_Account_r.TIN_SSN_c);
        System.assertEquals('456', results.LLCBI_Legal_Entities_r[0].LLCBI_Account_r.SSNTIN_Encrypted_c);
        System.assertNotEquals(null, results.LLCBI_Legal_Entities_r[0].LLCBI_Account_r.SSN_TIN_Has_Value_c);
        System.assertEquals(BIRTH_DATE, results.LLCBI_Legal_Entities_r[0].LLCBI_Account_r.Birthdate_c);
        System.assertEquals('z', results.LLCBI_Legal_Entities_r[0].LLCBI_Account_r.Reg_O_Code_c);
        System.assertEquals('Client', results.LLCBI_Legal_Entities_r[0].LLCBI_Account_r.RecordType.Name);

        System.assertEquals(loan.Id, results.LLCBI_Legal_Entities_r[0].LLCBI_Loan_r.Id);
        System.assertEquals('test loan', results.LLCBI_Legal_Entities_r[0].LLCBI_Loan_r.Name);

        System.assertEquals(2, results.LLCBI_Participations_r.size());
        System.assertNotEquals(null, results.LLCBI_Participations_r[0].Id);
        System.assertNotEquals(null, results.LLCBI_Participations_r[0].Name);
        System.assertEquals(50.000, results.LLCBI_Participations_r[0].LLCBI_Participated_c);
        System.assertEquals('test bank__c', results.LLCBI_Participations_r[0].Bank_c);
        System.assertEquals(true, results.LLCBI_Participations_r[0].Participation_Sold_c);
        System.assertEquals(420.25, results.LLCBI_Participations_r[0].Amount_c);
        
        System.assertEquals(loan.Id, results.LLCBI_Participations_r[0].LLCBI_Loan_r.Id);
        System.assertEquals('test loan', results.LLCBI_Participations_r[0].LLCBI_Loan_r.Name);

        System.assert(containsId(results.LLCBI_Loan_Teams_r, testTeamMembers[0].Id));
        System.assert(containsId(results.LLCBI_Loan_Teams_r, testTeamMembers[1].Id));

        System.assertEquals(2, results.LLCBI_Change_Memos_r.size());
        System.assertNotEquals(null, results.LLCBI_Change_Memos_r[0].Id);
        System.assertEquals('test memo name 0', results.LLCBI_Change_Memos_r[0].Name);
        System.assertEquals('test memo type', results.LLCBI_Change_Memos_r[0].LLCBI_Memo_Type_c);
        System.assertEquals('asdgasfga', results.LLCBI_Change_Memos_r[0].LLCBI_Description_c);
        System.assertEquals(false, results.LLCBI_Change_Memos_r[0].Add_Collateral_c);
        System.assertEquals(false, results.LLCBI_Change_Memos_r[0].LLCBI_Approval_Required_c);
        System.assertEquals(false, results.LLCBI_Change_Memos_r[0].Changing_Borrower_s_Name_Address_or_Tax_c);
        System.assertEquals(false, results.LLCBI_Change_Memos_r[0].LLCBI_Collateral_Change_c);
        System.assertEquals(false, results.LLCBI_Change_Memos_r[0].Collateral_going_from_lesser_position_to_c);
        System.assertEquals(false, results.LLCBI_Change_Memos_r[0].Covenant_Changes_c);
        System.assertEquals(false, results.LLCBI_Change_Memos_r[0].LLCBI_Equity_Injection_Change_c);
        System.assertEquals(false, results.LLCBI_Change_Memos_r[0].Fees_Change_c);
        System.assertEquals(false, results.LLCBI_Change_Memos_r[0].LLCBI_Guarantor_Added_c);
        System.assertEquals(false, results.LLCBI_Change_Memos_r[0].LLCBI_Guarantor_Removed_c);
        System.assertEquals(false, results.LLCBI_Change_Memos_r[0].LLCBI_Life_Insurance_Change_c);
        System.assertEquals(false, results.LLCBI_Change_Memos_r[0].LLCBI_Amount_Change_c);
        System.assertEquals(false, results.LLCBI_Change_Memos_r[0].LLCBI_Loan_Term_Change_c);
        System.assertEquals(false, results.LLCBI_Change_Memos_r[0].Maturity_Date_Change_c);
        System.assertEquals(false, results.LLCBI_Change_Memos_r[0].LLCBI_New_Rate_Requested_c);
        System.assertEquals(false, results.LLCBI_Change_Memos_r[0].LLCBI_Notify_Attorney_c);
        System.assertEquals(false, results.LLCBI_Change_Memos_r[0].LLCBI_Other_c);
        System.assertEquals(false, results.LLCBI_Change_Memos_r[0].Post_Approval_Requirements_changes_c);
        System.assertEquals(false, results.LLCBI_Change_Memos_r[0].LLCBI_Post_Close_Items_c);
        System.assertEquals(false, results.LLCBI_Change_Memos_r[0].LLCBI_Ready_for_Approval_c);
        System.assertEquals(false, results.LLCBI_Change_Memos_r[0].LLCBI_Re_approval_After_Expiration_c);
        System.assertEquals(false, results.LLCBI_Change_Memos_r[0].LLCBI_Seller_Note_Change_c);
        System.assertEquals(false, results.LLCBI_Change_Memos_r[0].Shortening_Maturity_Date_or_Amortization_c);
        System.assertEquals(false, results.LLCBI_Change_Memos_r[0].LLCBI_Use_of_Proceeds_Change_c);
        System.assertEquals(false, results.LLCBI_Change_Memos_r[0].LLCBI_User_Initiated_c);
        System.assertEquals(loan.Id, results.LLCBI_Change_Memos_r[0].LLCBI_Loan_r.Id);
        System.assertEquals('test loan', results.LLCBI_Change_Memos_r[0].LLCBI_Loan_r.Name);
        System.assertEquals(testUser.Id, results.LLCBI_Change_Memos_r[0].Loan_Officer_r.Id);
        System.assertEquals('EBAPI', results.LLCBI_Change_Memos_r[0].Loan_Officer_r.Name);
    }

    @IsTest
    static void it_should_return_this_PM_EB_Loan_when_getLoanForceLoan_is_called() {
        Date firstPaymentDate = Date.newInstance(2020, 1, 1);
        Date valuationDate = Date.newInstance(2020, 3, 3);

        Account testAccount = buildTestAccount();
        insert testAccount;
        EB_Loan_Application__c loanApp = buildLoanApplication();
        insert loanApp;
        List<EB_Loan_App_Collateral_Relationship__c> collateralRelationships = buildCollateralRelationships(loanApp.Id, testAccount);
        insert collateralRelationships;
        List<EB_Loan_Participation__c> participations = buildEBParticipations(loanApp.Id);
        insert participations;
        List<EB_Loan_App_Entity_Relationship__c> loanAppRelationships = buildEBRelationships(loanApp.Id, testAccount);
        insert loanAppRelationships;
        List<EB_Loan_App_Rate_Stream__c> rateStreams = buildRateStreams(loanApp.Id);
        insert rateStreams;
        List<EB_Loan_Application_Payment_Stream__c> paymentStreams = buildpaymentStreams(loanApp.Id);
        insert paymentStreams;
        //act
        PM_EB_Loan_Application_c results = sut.getLoanForceLoan(loanApp.Id);
        //assert
        System.assertEquals(loanApp.Id, results.Id);
        System.assertNotEquals(null, results.Name);
        System.assertEquals('alskdn', results.Account_Number_Assigned_c);
        System.assertNotEquals(null, results.Total_Loan_Amount_c);
        System.assertEquals('test use of funds', results.Use_of_Funds_c);
        System.assertEquals(14.1, results.Maturity_Term_In_Months_c);
        System.assertEquals('test loan type', results.Loan_Type_c);
        System.assertEquals('test credit rating', results.Credit_Rating_c);
        System.assertEquals('test niche products', results.Niche_Products_c);
        System.assertEquals('test purpose', results.Purpose_Of_Loan_c);
        System.assertEquals(Date.newInstance(2020, 2, 2), results.Maturity_Date_c);
        System.assertNotEquals(null, results.RM_c);

        System.assertNotEquals(null, results.Application_Stage_r.Id);

        System.assertNotEquals(null, results.Account_Number_r.Id);
        System.assertEquals('test eb acc name', results.Account_Number_r.Name);

        System.assertEquals('New', results.RecordType.Name);

        System.assertEquals('test industry code', results.EB_Account_Industry_Code_r.Name);

        System.assertEquals('test packet channel', results.EB_Loan_Packet_r.Channel_c);
        System.assertEquals('test rm commentary', results.EB_Loan_Packet_r.RM_Commentary_c);

        System.assertEquals('unit name', results.EB_Loan_Packet_r.Lead_Entity_r.EB_UnitID_r.Name);

        System.assertEquals(2, results.EB_Loan_App_Collateral_Relationships_r.size());
        System.assertNotEquals(null, results.EB_Loan_App_Collateral_Relationships_r[0].Lendable_Equity_c);
        System.assertNotEquals(null, results.EB_Loan_App_Collateral_Relationships_r[0].Loan_Value_c);
        System.assertEquals('test collateral description', results.EB_Loan_App_Collateral_Relationships_r[0].Description_c);
        System.assertEquals('test purpose of col', results.EB_Loan_App_Collateral_Relationships_r[0].Purpose_Of_Collateral_c);
        System.assertEquals('test abundance of caution', results.EB_Loan_App_Collateral_Relationships_r[0].Abundance_Of_Caution_c);
        System.assertNotEquals(null, results.EB_Loan_App_Collateral_Relationships_r[0].Collateral_Code_c);

        System.assertEquals(loanApp.Id, results.EB_Loan_App_Collateral_Relationships_r[0].EB_Loan_Application_ID_r.Id);
        System.assertNotEquals(null, results.EB_Loan_App_Collateral_Relationships_r[0].EB_Loan_Application_ID_r.Name);

        System.assertNotEquals(null, results.EB_Loan_App_Collateral_Relationships_r[0].EB_Collateral_ID_r.Id);
        System.assertEquals('test collateral name', results.EB_Loan_App_Collateral_Relationships_r[0].EB_Collateral_ID_r.Name);
        System.assertEquals('test collateral street', results.EB_Loan_App_Collateral_Relationships_r[0].EB_Collateral_ID_r.Street_c);
        System.assertEquals('test collateral state', results.EB_Loan_App_Collateral_Relationships_r[0].EB_Collateral_ID_r.State_c);
        System.assertEquals('test collateral city', results.EB_Loan_App_Collateral_Relationships_r[0].EB_Collateral_ID_r.City_c);
        System.assertEquals('test collateral zip', results.EB_Loan_App_Collateral_Relationships_r[0].EB_Collateral_ID_r.Zip_Code_c);
        System.assertEquals('test collateral lien position', results.EB_Loan_App_Collateral_Relationships_r[0].EB_Collateral_ID_r.Lien_Position_c);
        
        System.assertNotEquals(null, results.EB_Loan_App_Collateral_Relationships_r[0].EB_Collateral_ID_r.Collateral_Owner_r.Id);
        System.assertEquals('test account name', results.EB_Loan_App_Collateral_Relationships_r[0].EB_Collateral_ID_r.Collateral_Owner_r.Name);
        System.assertEquals('test eb client name', results.EB_Loan_App_Collateral_Relationships_r[0].EB_Collateral_ID_r.Collateral_Owner_r.EB_Client_Name_c);
        System.assertEquals('test b street', results.EB_Loan_App_Collateral_Relationships_r[0].EB_Collateral_ID_r.Collateral_Owner_r.BillingStreet);
        System.assertEquals('test b city', results.EB_Loan_App_Collateral_Relationships_r[0].EB_Collateral_ID_r.Collateral_Owner_r.BillingCity);
        System.assertEquals('test b state', results.EB_Loan_App_Collateral_Relationships_r[0].EB_Collateral_ID_r.Collateral_Owner_r.BillingState);
        System.assertEquals('test b postal code', results.EB_Loan_App_Collateral_Relationships_r[0].EB_Collateral_ID_r.Collateral_Owner_r.BillingPostalCode);

        System.assertEquals(2, results.EB_Loan_Participations_r.size());
        System.assertNotEquals(null, results.EB_Loan_Participations_r[0].Id);
        System.assertNotEquals(null, results.EB_Loan_Participations_r[0].Name);
        System.assertEquals('asdfasdf', results.EB_Loan_Participations_r[0].Participating_Institution_c);
        System.assertEquals(1500.25, results.EB_Loan_Participations_r[0].Participated_Amount_c);

        System.assertEquals(loanApp.Id, results.EB_Loan_Participations_r[0].Loan_Application_ID_r.Id);
        System.assertNotEquals(null, results.EB_Loan_Participations_r[0].Loan_Application_ID_r.Name);

        System.assertEquals('Bought', results.EB_Loan_Participations_r[0].RecordType.Name);

        System.assertEquals(2, results.EB_Loan_App_Entity_Relationships_r.size());
        System.assertNotEquals(null, results.EB_Loan_App_Entity_Relationships_r[0].Id);
        System.assertNotEquals(null, results.EB_Loan_App_Entity_Relationships_r[0].Name);
        System.assertEquals('qalbwfgriuj', results.EB_Loan_App_Entity_Relationships_r[0].Relationship_Type_c);

        System.assertEquals(loanApp.Id, results.EB_Loan_App_Entity_Relationships_r[0].Loan_Application_ID_r.Id);
        System.assertNotEquals(null, results.EB_Loan_App_Entity_Relationships_r[0].Loan_Application_ID_r.Name);

        System.assertEquals(testAccount.Id, results.EB_Loan_App_Entity_Relationships_r[0].Entity_Name_r.Id);
        System.assertEquals('test account name', results.EB_Loan_App_Entity_Relationships_r[0].Entity_Name_r.Name);
        System.assertEquals('test sub type', results.EB_Loan_App_Entity_Relationships_r[0].Entity_Name_r.Sub_Type_c);
        System.assertEquals('test snn', results.EB_Loan_App_Entity_Relationships_r[0].Entity_Name_r.TIN_SSN_c);
        System.assertNotEquals(null, results.EB_Loan_App_Entity_Relationships_r[0].Entity_Name_r.SSN_TIN_Has_Value_c);
        System.assertEquals('456', results.EB_Loan_App_Entity_Relationships_r[0].Entity_Name_r.SSNTIN_Encrypted_c);
        System.assertEquals('test b street', results.EB_Loan_App_Entity_Relationships_r[0].Entity_Name_r.BillingStreet);
        System.assertEquals('test b city', results.EB_Loan_App_Entity_Relationships_r[0].Entity_Name_r.BillingCity);
        System.assertEquals('test b state', results.EB_Loan_App_Entity_Relationships_r[0].Entity_Name_r.BillingState);
        System.assertEquals('test b postal code', results.EB_Loan_App_Entity_Relationships_r[0].Entity_Name_r.BillingPostalCode);
        System.assertEquals('1111111111', results.EB_Loan_App_Entity_Relationships_r[0].Entity_Name_r.Phone);
        System.assertEquals('test sic', results.EB_Loan_App_Entity_Relationships_r[0].Entity_Name_r.Sic);

        System.assertEquals(1, results.EB_Loan_App_Rate_Streams_r.size());
        System.assertNotEquals(null, results.EB_Loan_App_Rate_Streams_r[0].Id);
        System.assertNotEquals(null, results.EB_Loan_App_Rate_Streams_r[0].Name);
        System.assertEquals(42.00, results.EB_Loan_App_Rate_Streams_r[0].Fixed_Interest_Rate_c);
        System.assertEquals('test variance code', results.EB_Loan_App_Rate_Streams_r[0].Index_Variance_Code_c);
        System.assertEquals(41.00, results.EB_Loan_App_Rate_Streams_r[0].Interest_Rate_Ceiling_c);
        System.assertEquals(40.00, results.EB_Loan_App_Rate_Streams_r[0].Interest_Rate_Floor_c);
        System.assertEquals('test rate change', results.EB_Loan_App_Rate_Streams_r[0].Rate_Subject_To_Change_c);
        System.assertEquals(39.00, results.EB_Loan_App_Rate_Streams_r[0].Rate_Index_Variance_c);

        System.assertNotEquals(null, results.EB_Loan_App_Rate_Streams_r[0].EB_Floating_Rate_r.Name);

        System.assertEquals(1, results.EB_Loan_Application_Payment_Streams_r.size());
        System.assertNotEquals(null, results.EB_Loan_Application_Payment_Streams_r[0].Id);
        System.assertNotEquals(null, results.EB_Loan_Application_Payment_Streams_r[0].Name);
        System.assertEquals(42, results.EB_Loan_Application_Payment_Streams_r[0].Amortization_Schedule_in_Months_c);
        System.assertEquals(4200.00, results.EB_Loan_Application_Payment_Streams_r[0].Amount_c);
        System.assertEquals('test frequency', results.EB_Loan_Application_Payment_Streams_r[0].Frequency_c);

        System.assertEquals('Amortization', results.EB_Loan_Application_Payment_Streams_r[0].RecordType.Name);
    }

    @IsTest
    static void it_should_return_these_PM_LLCBI_Pricing_Payment_Component_cs_when_getnCinoPayStreams_is_called(){
        Date effectiveDate = Date.newInstance(2020, 1, 1);
        
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        insert loan;

        LLC_BI__Pricing_Stream__c pStream01 = new LLC_BI__Pricing_Stream__c();
        pStream01.name = 'pStream01 name';
        pStream01.LLC_BI__Effective_Date__c = effectiveDate;
        pStream01.LLC_BI__Sequence__c = 1;
        pStream01.LLC_BI__Term_Length__c = 1000;
        pStream01.LLC_BI__Term_Unit__c = 'asdf';
        pStream01.LLC_BI__Context_Id__c = loan.Id;
        pStream01.LLC_BI__Is_Payment_Stream__c = true;
        pStream01.LLC_BI__Is_Rate_Stream__c = false;

        LLC_BI__Pricing_Stream__c pStream02 = new LLC_BI__Pricing_Stream__c();
        pStream02.name = 'pStream02 name';
        pStream02.LLC_BI__Effective_Date__c = effectiveDate;
        pStream02.LLC_BI__Sequence__c = 2;
        pStream02.LLC_BI__Term_Length__c = 2000;
        pStream02.LLC_BI__Term_Unit__c = 'fdsa';
        pStream02.LLC_BI__Context_Id__c = loan.Id;
        pStream02.LLC_BI__Is_Payment_Stream__c = true;
        pStream02.LLC_BI__Is_Rate_Stream__c = false;
        insert new list<LLC_BI__Pricing_Stream__c>{pStream01, pStream02};

        LLC_BI__Pricing_Payment_Component__c ppComponent01 = new LLC_BI__Pricing_Payment_Component__c();
        ppComponent01.Name = 'ppComponent01 name';
        ppComponent01.LLC_BI__Amount__c = 45312.12;
        ppComponent01.LLC_BI__Type__c = 'asdfggh';
        ppComponent01.LLC_BI__Pricing_Stream__c = pStream01.Id;
        
        LLC_BI__Pricing_Payment_Component__c ppComponent02 = new LLC_BI__Pricing_Payment_Component__c();
        ppComponent02.Name = 'ppComponent02 name';
        ppComponent02.LLC_BI__Amount__c = 12.12;
        ppComponent02.LLC_BI__Type__c = 'oiumnr';
        ppComponent02.LLC_BI__Pricing_Stream__c = pStream02.Id;
        insert new List<LLC_BI__Pricing_Payment_Component__c>{ppComponent01, ppComponent02};
        //act
        List<PM_LLCBI_Pricing_Payment_Component_c> results = sut.getnCinoPayStreams((String)loan.Id); 
        //assert
        System.assertEquals(2, results.size());
        
        System.assertEquals(ppComponent01.Id, results[0].Id);
        System.assertEquals('ppComponent01 name', results[0].Name);
        System.assertEquals(45312.12, results[0].LLCBI_Amount_c);
        System.assertEquals('asdfggh', results[0].LLCBI_Type_c);

        System.assertEquals(pStream01.Id, results[0].LLCBI_Pricing_Stream_r.Id);
        System.assertEquals('pStream01 name', results[0].LLCBI_Pricing_Stream_r.Name);
        System.assertEquals(effectiveDate, results[0].LLCBI_Pricing_Stream_r.LLCBI_Effective_Date_c);
        System.assertEquals(1, results[0].LLCBI_Pricing_Stream_r.LLCBI_Sequence_c);
        System.assertEquals(1000, results[0].LLCBI_Pricing_Stream_r.LLCBI_Term_Length_c);
        System.assertEquals('asdf', results[0].LLCBI_Pricing_Stream_r.LLCBI_Term_Unit_c);
        System.assertEquals(true, results[0].LLCBI_Pricing_Stream_r.LLCBI_Is_Payment_Stream_c);
        System.assertEquals(false, results[0].LLCBI_Pricing_Stream_r.LLCBI_Is_Rate_Stream_c);
       
        
        System.assertEquals(ppComponent02.Id, results[1].Id);
        System.assertEquals('ppComponent02 name', results[1].Name);
        System.assertEquals(12.12, results[1].LLCBI_Amount_c);
        System.assertEquals('oiumnr', results[1].LLCBI_Type_c);

        System.assertEquals(pStream02.Id, results[1].LLCBI_Pricing_Stream_r.Id);
        System.assertEquals('pStream02 name', results[1].LLCBI_Pricing_Stream_r.Name);
        System.assertEquals(effectiveDate, results[1].LLCBI_Pricing_Stream_r.LLCBI_Effective_Date_c);
        System.assertEquals(2, results[1].LLCBI_Pricing_Stream_r.LLCBI_Sequence_c);
        System.assertEquals(2000, results[1].LLCBI_Pricing_Stream_r.LLCBI_Term_Length_c);
        System.assertEquals('fdsa', results[1].LLCBI_Pricing_Stream_r.LLCBI_Term_Unit_c);
        System.assertEquals(true, results[1].LLCBI_Pricing_Stream_r.LLCBI_Is_Payment_Stream_c);
        System.assertEquals(false, results[1].LLCBI_Pricing_Stream_r.LLCBI_Is_Rate_Stream_c);
    }

    @IsTest
    static void it_should_return_these_PM_LLCBI_Pricing_Rate_Component_cs_when_getnCinoRateStreams_is_called() {
        Date effectiveDate = Date.newInstance(2020, 1, 1);
        
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        insert loan;

        LLC_BI__Pricing_Stream__c pStream01 = new LLC_BI__Pricing_Stream__c();
        pStream01.Name = 'pStream01 name';
        pStream01.LLC_BI__Effective_Date__c = effectiveDate;
        pStream01.LLC_BI__Sequence__c = 1;
        pStream01.LLC_BI__Term_Length__c = 1000;
        pStream01.LLC_BI__Term_Unit__c = 'asdf';
        pStream01.LLC_BI__Context_Id__c = loan.Id;
        pStream01.LLC_BI__Is_Payment_Stream__c = false;
        pStream01.LLC_BI__Is_Rate_Stream__c = true;

        LLC_BI__Pricing_Stream__c pStream02 = new LLC_BI__Pricing_Stream__c();
        pStream02.Name = 'pStream02 name';
        pStream02.LLC_BI__Effective_Date__c = effectiveDate;
        pStream02.LLC_BI__Sequence__c = 2;
        pStream02.LLC_BI__Term_Length__c = 2000;
        pStream02.LLC_BI__Term_Unit__c = 'fdsa';
        pStream02.LLC_BI__Context_Id__c = loan.Id;
        pStream02.LLC_BI__Is_Payment_Stream__c = false;
        pStream02.LLC_BI__Is_Rate_Stream__c = true;
        insert new list<LLC_BI__Pricing_Stream__c>{pStream01, pStream02};
        
        LLC_BI__Pricing_Rate_Component__c prComponent01 = new LLC_BI__Pricing_Rate_Component__c();
        prComponent01.Name = 'prComponent01 name';
        prComponent01.LLC_BI__Applied_Loan_Percentage__c = 50.25;
        prComponent01.LLC_BI__Is_Fixed__c = true;
        prComponent01.LLC_BI__Rate__c = 12.58;
        prComponent01.LLC_BI__Pricing_Stream__c = pStream01.Id;

        LLC_BI__Pricing_Rate_Component__c prComponent02 = new LLC_BI__Pricing_Rate_Component__c();
        prComponent02.Name = 'prComponent02 name';
        prComponent02.LLC_BI__Applied_Loan_Percentage__c = 12.52;
        prComponent02.LLC_BI__Is_Fixed__c = false;
        prComponent02.LLC_BI__Rate__c = 65.84;
        prComponent02.LLC_BI__Pricing_Stream__c = pStream02.Id;
        insert new List<LLC_BI__Pricing_Rate_Component__c>{prComponent01, prComponent02};

        LLC_BI__Covenant2__c covenantMgmt = new LLC_BI__Covenant2__c();
        insert CovenantMgmt;

        LLC_BI__Pricing_Covenant__c covenant01 = new LLC_BI__Pricing_Covenant__c();
        covenant01.Name = 'covenant01 name';
        covenant01.LLC_BI__Rules__c = 'test for now';
        covenant01.LLC_BI__Pricing_Rate_Component__c = prComponent01.Id;
        covenant01.LLC_BI__Covenant2__c = CovenantMgmt.Id;

        LLC_BI__Pricing_Covenant__c covenant02 = new LLC_BI__Pricing_Covenant__c();
        covenant02.Name = 'covenant02 name';
        covenant02.LLC_BI__Rules__c = 'test for now2';
        covenant02.LLC_BI__Pricing_Rate_Component__c = prComponent01.Id;
        covenant02.LLC_BI__Covenant2__c = CovenantMgmt.Id;
        insert new List<LLC_BI__Pricing_Covenant__c>{covenant01, covenant02};

        //act
        List<PM_LLCBI_Pricing_Rate_Component_c> results = sut.getnCinoRateStreams(loan.Id);
        //assert
        System.assertEquals(2, results.size());

        System.assertEquals(prComponent01.Id, results[0].Id);
        System.assertEquals('prComponent01 name', results[0].Name);
        System.assertEquals(50.25, results[0].LLCBI_Applied_Loan_Percentage_c);
        System.assertEquals(true, results[0].LLCBI_Is_Fixed_c);
        System.assertEquals(12.58, results[0].LLCBI_Rate_c);

        System.assertEquals(pStream01.Id, results[0].LLCBI_Pricing_Stream_r.Id);
        System.assertEquals('pStream01 name', results[0].LLCBI_Pricing_Stream_r.Name);
        System.assertEquals(effectiveDate, results[0].LLCBI_Pricing_Stream_r.LLCBI_Effective_Date_c);
        System.assertEquals(1, results[0].LLCBI_Pricing_Stream_r.LLCBI_Sequence_c);
        System.assertEquals(1000, results[0].LLCBI_Pricing_Stream_r.LLCBI_Term_Length_c);
        System.assertEquals('asdf', results[0].LLCBI_Pricing_Stream_r.LLCBI_Term_Unit_c);
        System.assertEquals(false, results[0].LLCBI_Pricing_Stream_r.LLCBI_Is_Payment_Stream_c);
        System.assertEquals(true, results[0].LLCBI_Pricing_Stream_r.LLCBI_Is_Rate_Stream_c);

        System.assertEquals(2, results[0].LLCBI_Pricing_Covenants_r.size());
        System.assertEquals(covenant01.Id, results[0].LLCBI_Pricing_Covenants_r[0].Id);
        System.assertEquals(covenant01.Name, results[0].LLCBI_Pricing_Covenants_r[0].Name);
        System.assertEquals('test for now', results[0].LLCBI_Pricing_Covenants_r[0].LLCBI_Rules_c);
        System.assertEquals(covenant02.Id, results[0].LLCBI_Pricing_Covenants_r[1].Id);
        System.assertEquals(covenant02.Name, results[0].LLCBI_Pricing_Covenants_r[1].Name);
        System.assertEquals('test for now2', results[0].LLCBI_Pricing_Covenants_r[1].LLCBI_Rules_c);

        System.assertEquals(prComponent02.Id, results[1].Id);
        System.assertEquals('prComponent02 name', results[1].Name);
        System.assertEquals(12.52, results[1].LLCBI_Applied_Loan_Percentage_c);
        System.assertEquals(false, results[1].LLCBI_Is_Fixed_c);
        System.assertEquals(65.84, results[1].LLCBI_Rate_c);
        
        System.assertEquals(pStream02.Id, results[1].LLCBI_Pricing_Stream_r.Id);
        System.assertEquals('pStream02 name', results[1].LLCBI_Pricing_Stream_r.Name);
        System.assertEquals(effectiveDate, results[1].LLCBI_Pricing_Stream_r.LLCBI_Effective_Date_c);
        System.assertEquals(2, results[1].LLCBI_Pricing_Stream_r.LLCBI_Sequence_c);
        System.assertEquals(2000, results[1].LLCBI_Pricing_Stream_r.LLCBI_Term_Length_c);
        System.assertEquals('fdsa', results[1].LLCBI_Pricing_Stream_r.LLCBI_Term_Unit_c);
        System.assertEquals(false, results[1].LLCBI_Pricing_Stream_r.LLCBI_Is_Payment_Stream_c);
        System.assertEquals(true, results[1].LLCBI_Pricing_Stream_r.LLCBI_Is_Rate_Stream_c);
        
        
        System.assertEquals(0, results[1].LLCBI_Pricing_Covenants_r.size());
    }
    
    @IsTest
    static void it_should_return_a_list_of_PM_EB_Collateral_Client_Relationship_c_when_getLoanForceCollateralEntityRelationships_is_called(){
        Account testAccount = buildTestAccount();
        EB_Collateral__c testEBCollateral = buildEBCollateral();
        List<SObject> testObjs = new List<SObject>{testAccount,testEBCollateral};
        insert testObjs;

        List<EB_Collateral_Client_Relationship__c> testRels = new List<EB_Collateral_Client_Relationship__c>();
        for (Integer i = 0; i < 2; i++) {
            EB_Collateral_Client_Relationship__c rel = new EB_Collateral_Client_Relationship__c(
                Key__c = 'test key',
                Client_ID__c = testAccount.Id,
                EB_Collateral_ID__c = testEBCollateral.Id
            );
            testRels.add(rel);
        }
        insert testRels;    
        //act
        List<PM_EB_Collateral_Client_Relationship_c> results = sut.getLoanForceCollateralEntityRelationships(new List<Id>{testEBCollateral.Id});
        //assert
        System.assertEquals(2, results.size());
        System.assertNotEquals(null, results[0].Id);
        System.assertNotEquals(null, results[0].Name);
        System.assertEquals('test collateral description', results[0].Description_c);
        System.assertEquals('test key', results[0].Key_c);

        System.assertEquals(testAccount.Id, results[0].Client_ID_r.Id);
        System.assertEquals('test account name', results[0].Client_ID_r.Name);
        System.assertEquals('test eb client name', results[0].Client_ID_r.EB_Client_Name_c);
        System.assertEquals('test b street', results[0].Client_ID_r.BillingStreet);
        System.assertEquals('test b city', results[0].Client_ID_r.BillingCity);
        System.assertEquals('test b state', results[0].Client_ID_r.BillingState);
        System.assertEquals('test b postal code', results[0].Client_ID_r.BillingPostalCode);

        System.assertEquals(testEBCollateral.Id, results[0].EB_Collateral_ID_r.Id);
        System.assertEquals('test collateral name', results[0].EB_Collateral_ID_r.Name);
    }

    @IsTest
    static void it_should_verify_the_fields_were_called_when_getindustrycodes_is_called(){
        EB_Industry_Code__c code = new EB_Industry_Code__c();
        code.Name = '1234-some description';
        code.Industry_Code__c = '1234';
        insert code;
        
        List<EB_Industry_Code__c> result = sut.getIndustryCodes();
        
        Object fieldInResult = result[0].Name;
        fieldInResult = result[0].Industry_Code__c;
    }
//////////////////////////////////////////////////////////////////////
    private static LLC_BI__Loan__c buildnCinoLoan(Date firstPaymentDate, Date maturityDate) {
        return new LLC_BI__Loan__c (
            Name = 'test loan',
            LLC_BI__Product_Type__c = 'test product type',
            LLC_BI__Product_Line__c = 'test product line',
            LLC_BI__Product__c = 'test product',
            LLC_BI__Availability_From_Core__c = 100,
            LLC_BI__Amount__c = 500.00,
            Application__c = 123456,
            Account_Number__c = 'test account number',
            LLC_BI__lookupKey__c = 'test lookupKey',
            LLC_BI__isRenewal__c = false,
            LLC_BI__Is_Modification__c = false,
            Channel__c = 'test channel',
            Reg_O_Loan__c = false,
            Employee_Loan__c = false,
            LLC_BI__Risk_Grade__c = 'test risk grade',
            Niche_Products__c = 'N/A',
            Niche_Products_fx__c = 'N/A',
            Loan_Characteristics__c = 'Bank-qualified Tax Credit',
            Use_of_Funds_Purpose__c = 'test use of funds',
            Other_Purpose_Description__c = 'test other purpose description',
            LC_Comments__c = 'test lc comments',
            RM_Comments__c = 'test rm comments',
            Lending_Strategy__c = 'test lending strat',
            LLC_BI__InterestRate__c = 5.115,
            LLC_BI__First_Payment_Date__c = firstPaymentDate,
            LLC_BI__Amortized_Term_Months__c = 48,
            LLC_BI__Term_Months__c = 48,
            LLC_BI__Maturity_Date__c = maturityDate,
            LLC_BI__Pricing_Basis__c = 'test pricing basis',
            LLC_BI__Payment_Type__c = 'test payment type',
            LLC_BI__Payment_Schedule__c = 'test payment schedule',
            LLC_BI__Index__c = 'test index',
            LLC_BI__Spread__c =  0.1587,
            LLC_BI__Rate_Floor__c = 1.425,
            LLC_BI__Rate_Ceiling__c = 43.852,
            LLC_BI__Monthly_Payment__c = 4563.20,
            LLC_BI__Interest_Rate_Adjustment_Frequency__c = 'test interest rate adj freq',
            Military_Lending_Act__c = 'No',
            Is_Loan_to_Gov_t_Related_Entity__c = 'test loan to gov related ent',
            Is_Repayment_Reliant_on_Ag_Income__c = 'test repayment reliant',
            Is_Loan_to_Financial_Institution__c = 'test loan to financial',
            Financial_Institution_Accept_Deposits__c = 'test fina inst accept',
            Immediate_Funding__c = true,
            Wire_Amount__c = 11111.25,
            Disbursing_Instructions__c = 'test disburse instructions',
            COVID_19_Related_Loan__c = 'No'
        );
    }

    private static List<LLC_BI__Collateral__c> buildCollateral(Integer numToReturn, Date valuationDate, Account testAccount) {
        List<LLC_BI__Collateral__c> collateral = new List<LLC_BI__Collateral__c>();
        LLC_BI__Collateral_Type__c colType = new LLC_BI__Collateral_Type__c(
            Name = 'test col type name',
            LLC_BI__Collateral_Code__c = 'test col type code'
        );
        insert colType;

        for (Integer i = 0; i < numToReturn; i++) {
            LLC_BI__Collateral__c c = new LLC_BI__Collateral__c(
                LLC_BI__Collateral_Name__c = 'test name ' + String.valueOf(i),
                Change_Collateral_Code__c = 'test col code',
                Sync_Key__c = 'test sync key',
                Assignment_of_Rent__c = 'test ass rent',
                Flood_Insurance_Required__c = 'No',
                Appraised_Value_reviewed__c = 6514.25,
                Valuation_Date__c = valuationDate,
                LLC_BI__Description__c = 'test col description',
                LLC_BI__Is_Leased_Asset__c = true,
                LLC_BI__Value__c = 3215.27,
                LLC_BI__Street_Address__c = 'test col street address',
                LLC_BI__City__c = 'test col city',
                LLC_BI__State__c = 'test col state',
                LLC_BI__Zip_Code__c = '63139',
                LLC_BI__Collateral_Type__c = colType.Id,
                Modified_Collateral_Type__c = colType.Id,
                Primary_Owner__c = testAccount.Id,
                LLC_BI__Parcel_Number__c = '123456'
            );
            collateral.add(c);
        }
        return collateral;
    }

    private static List<LLC_BI__Loan_Collateral2__c> buildLoanCollateralPledges(Id loanId, List<LLC_BI__Collateral__c> collateral, LLC_BI__Loan_Collateral_Aggregate__c aggregate) {
        List<LLC_BI__Loan_Collateral2__c> pledges = new List<LLC_BI__Loan_Collateral2__c>();

        for (Integer i = 0; i < collateral.size(); i++) {
            LLC_BI__Loan_Collateral2__c c = new LLC_BI__Loan_Collateral2__c(
                Description__c = 'test collateral description ' + String.valueOf(i),
                LLC_BI__Loan__c = loanId,
                LLC_BI__Collateral__c = collateral[i].Id,
                LLC_BI__Loan_Collateral_Aggregate__c = aggregate.Id,
                LLC_BI__Lien_Position__c = 'test lien position',
                LLC_BI__Current_Lendable_Value__c = 3985.12,
                LLC_BI__Is_Primary__c = true,
                Abundance_of_Caution__c = false
            );
            pledges.add(c);
        }
        return pledges;
    }

    private static List<LLC_BI__Legal_Entities__c> buildLegalEntities(Id accountId, Id loanId) {
        List<LLC_BI__Legal_Entities__c> legalEntities = new List<LLC_BI__Legal_Entities__c>();

        for (Integer i = 0; i < 2; i++) {
            LLC_BI__Legal_Entities__c le = new LLC_BI__Legal_Entities__c(
                LLC_BI__Tax_ID__c  = 'test tax id',
                LLC_BI__Relationship_Type__c = 'test relationship type',
                LLC_BI__Borrower_Type__c = 'test borrower type',
                Liabilities__c = 5000,
                LLC_BI__Address__c = 'test address',
                LLC_BI__Contingent_Type__c = 'test contingent type',
                LLC_BI__Ownership__c = 100.00,
                Limitations__c = 'test limitations',
                LLC_BI__Account__c = accountId,
                LLC_BI__Loan__c = loanId
            );
            legalEntities.add(le);
        }
        return legalEntities;
    }

    private static List<LLC_BI__Participation__c> buildParticipations(Id loanId) {
        Participating_Bank__c pBank = new Participating_Bank__c(
            Name = 'test pBank',
            Street__c = 'pBank Street',
            City__c = 'pBank City',
            State__c = 'MO',
            Zip_Code__c = 'pBank Zip'
        );
        insert pBank;

        List<LLC_BI__Participation__c> participations = new List<LLC_BI__Participation__c>();
        for (Integer i = 0; i < 2; i++) {
            LLC_BI__Participation__c p = new LLC_BI__Participation__c();
            p.LLC_BI__Participated__c = 50.000;
            p.Bank__c = 'test bank__c';
            p.Participation_Sold__c = true;
            p.Amount__c = 420.25;
            p.LLC_BI__Loan__c = loanId;
            p.Name_of_Signer__c = 'asdf';
            p.Title_of_Signer__c = 'asdf';
            p.Bank_Participations_Bank__c = pBank.Id;
            participations.add(p);
        }
        return participations;
    }

    private static List<LLC_BI__LoanTeam__c> buildLoanTeamMembers(User testUser, Id loanId) {
        LLC_BI__Role__c role = new LLC_BI__Role__c(
            Name = 'test role name'
        );
        insert role;

        List<LLC_BI__LoanTeam__c> teamMembers = new List<LLC_BI__LoanTeam__c>();
        for (Integer i = 0; i < 2; i++) {
            LLC_BI__LoanTeam__c member = new LLC_BI__LoanTeam__c(
                Primary__c = true,
                LLC_BI__User__c = testUser.Id,
                LLC_BI__Assigned_Role__c = role.Id,
                LLC_BI__Loan__c = loanId
            );
            teamMembers.add(member);
        }
        return teamMembers;
    }

    private static List<LLC_BI__Credit_Memo_Modifcation__c> buildMemos(Id loanId, Id officerId) {
        List<LLC_BI__Credit_Memo_Modifcation__c> memos = new List<LLC_BI__Credit_Memo_Modifcation__c>();

        for (Integer i = 0; i < 2; i++) {
            LLC_BI__Credit_Memo_Modifcation__c memo = new LLC_BI__Credit_Memo_Modifcation__c(
                Name = 'test memo name ' + String.valueOf(i),
                LLC_BI__Memo_Type__c = 'test memo type',
                LLC_BI__Description__c = 'asdgasfga',
                Add_Collateral__c = false,
                LLC_BI__Approval_Required__c = false,
                Changing_Borrower_s_Name_Address_or_Tax__c = false,
                LLC_BI__Collateral_Change__c = false,
                Collateral_going_from_lesser_position_to__c = false,
                Covenant_Changes__c = false,
                LLC_BI__Equity_Injection_Change__c = false,
                Fees_Change__c = false,
                LLC_BI__Guarantor_Added__c = false,
                LLC_BI__Guarantor_Removed__c = false,
                LLC_BI__Life_Insurance_Change__c = false,
                LLC_BI__Amount_Change__c = false,
                LLC_BI__Loan_Term_Change__c = false,
                Maturity_Date_Change__c = false,
                LLC_BI__New_Rate_Requested__c = false,
                LLC_BI__Notify_Attorney__c = false,
                LLC_BI__Other__c = false,
                Post_Approval_Requirements_changes__c = false,
                LLC_BI__Post_Close_Items__c = false,
                LLC_BI__Ready_for_Approval__c = false,
                LLC_BI__Re_approval_After_Expiration__c = false,
                LLC_BI__Seller_Note_Change__c = false,
                Shortening_Maturity_Date_or_Amortization__c = false,
                LLC_BI__Use_of_Proceeds_Change__c = false,
                LLC_BI__User_Initiated__c = false,
                LLC_BI__Loan__c = loanId,
                Loan_Officer__c = officerId
            );
            memos.add(memo);
        }
        return memos;
    }

    private static EB_Loan_Application__c buildLoanApplication() {
        Date maturityDate = Date.newInstance(2020, 2, 2);
        List<EB_Loan_App_Stage__c> appstages = TestUtilities.createLoanAppStages();
        
        Eb_Account__c testEbAccount = ObjectFactory.getAccount('test acc title', '1111');
        testEbAccount.Name = 'test eb acc name';
        update testEbAccount;
        
        EB_Unit__c testUnit = ObjectFactory.getUnit('unit name', 42);
        Id entityRecordTypeId = ObjectFactory.getRecordTypeIdByNameAndObject('Client', 'Account');
        EB_Team_Member__c relationshipManager = ObjectFactory.getTeamMember('EBAPI');
        Account testEntity = ObjectFactory.getEntity('test entity name', entityRecordTypeId,  relationshipManager);
        testEntity.EB_UnitID__c = testUnit.Id;
        update testEntity;
        
        EB_Industry_Code__c testIndustryCode = new EB_Industry_Code__c(
            Name = 'test industry code'
        );
        insert testIndustryCode;

        EB_Loan_Packet__c testPacket = new EB_Loan_Packet__c(
            Channel__c = 'test packet channel',
            RM_Commentary__c = 'test rm commentary',
            Lead_Entity__c = testEntity.Id
        );
        insert testPacket;

        EB_Loan_Application__c lnApp = new EB_Loan_Application__c(
            Account_Number_Assigned__c = 'alskdn',
            Use_of_Funds__c = 'test use of funds',
            Maturity_Term_In_Months__c = 14.1,
            Loan_Type__c = 'test loan type',
            Credit_Rating__c = 'test credit rating',
            Niche_Products__c = 'test niche products',
            Purpose_Of_Loan__c = 'test purpose',
            Bank_Owned_Loan_Amount__c = 100,
            Application_Stage__c = TestUtilities.getStageByName('Documentation').Id,
            Maturity_Date__c = maturityDate,
            Account_Number__c = testEbAccount.Id,
            EB_Loan_Packet__c = testPacket.Id,
            RecordTypeId = ObjectFactory.getRecordTypeIdByNameAndObject('New', 'EB_Loan_Application__c'),
            EB_Account_Industry_Code__c = testIndustryCode.Id
        );
        return lnApp;
    }

    private static List<EB_Loan_App_Collateral_Relationship__c> buildCollateralRelationships(Id loanAppId, Account testAccount) {
        List<EB_Loan_App_Collateral_Relationship__c> colRels = new List<EB_Loan_App_Collateral_Relationship__c>();
        EB_Collateral__c testCol = buildEBCollateral();
        testCol.Collateral_Owner__c = testAccount.Id;
        insert testCol;
        
        for (Integer i = 0; i < 2; i++) {
            EB_Loan_App_Collateral_Relationship__c colRel = new EB_Loan_App_Collateral_Relationship__c(
                Purpose_Of_Collateral__c = 'test purpose of col',
                Abundance_Of_Caution__c = 'test abundance of caution',
                EB_Collateral_ID__c = testCol.Id,
                EB_Loan_Application_ID__c = loanAppId
            );
            colRels.add(colRel);
        }
        return colRels;
    }

    private static EB_Collateral__c buildEBCollateral() {
        Collateral_Code__c colCode = new Collateral_Code__c(
            Collateral_Code_ID__c = 'test col code'
        );
        insert colCode;
        
        EB_Collateral__c testCol = new EB_Collateral__c(
            Collateral_Description__c = 'test collateral description',
            Name = 'test collateral name',
            Street__c = 'test collateral street',
            State__c = 'test collateral state',
            City__c = 'test collateral city',
            Zip_Code__c = 'test collateral zip',
            Lien_Position__c = 'test collateral lien position',
            Collateral_Code__c = colCode.Id
        );
        return testCol;
    }

    private static List<EB_Loan_Participation__c> buildEBParticipations(Id loanAppId) {
        List<EB_Loan_Participation__c> participations = new List<EB_Loan_Participation__c>();

        for (Integer i = 0; i < 2; i++) {
            EB_Loan_Participation__c p = new EB_Loan_Participation__c(
                Participating_Institution__c = 'asdfasdf',
                Participated_Amount__c = 1500.25,
                Loan_Application_ID__c = loanAppId,
                RecordTypeID = ObjectFactory.getRecordTypeIdByNameAndObject('Bought', 'EB_Loan_Participation__c')
            );
            participations.add(p);
        }
        return participations;
    }

    private static List<EB_Loan_App_Entity_Relationship__c> buildEBRelationships(Id loanAppId, Account testAccount) {
        List<EB_Loan_App_Entity_Relationship__c> loanAppRelationships = new List<EB_Loan_App_Entity_Relationship__c>();

        for (Integer i = 0; i < 2; i++) {
            EB_Loan_App_Entity_Relationship__c r = new EB_Loan_App_Entity_Relationship__c(
                Relationship_Type__c = 'qalbwfgriuj',
                Loan_Application_ID__c = loanAppId,
                Entity_Name__c = testAccount.Id
            );
            loanAppRelationships.add(r);
        }
        return loanAppRelationships;
    }

    private static Account buildTestAccount() {
        Account testAccount = new Account(
            Name = 'test account name',
            Type = 'Corporation',
            BillingStreet = 'test b street',
            BillingCity = 'test b city',
            BillingState = 'test b state',
            BillingPostalCode = 'test b postal code',
            EB_Client_Name__c = 'test eb client name',
            Phone = '1111111111',
            Sic = 'test sic',
            Sub_Type__c = 'test sub type',
            TIN_SSN__c = 'test snn',
            SSN_TIN_Has_Value__c = true,
            Birthdate__c = BIRTH_DATE,
            Reg_O_Code__c = 'z',
            SSNTIN_Encrypted__c = '456',
            RecordTypeId = ObjectFactory.getRecordTypeIdByNameAndObject('Client', 'Account')
        );
        return testAccount;
    }

    private static List<EB_Loan_App_Rate_Stream__c> buildRateStreams(Id loanAppId) {
        List<EB_Loan_App_Rate_Stream__c> rateStreams = new List<EB_Loan_App_Rate_Stream__c>();

        EB_Floating_Rate__c indexRate = new EB_Floating_Rate__c();
        insert indexRate;

        for (Integer i = 0; i < 2; i++) {
            EB_Loan_App_Rate_Stream__c stream = new EB_Loan_App_Rate_Stream__c(
                Fixed_Interest_Rate__c = 42.00,
                Index_Variance_Code__c = 'test variance code',
                Interest_Rate_Ceiling__c = 41.00,
                Interest_Rate_Floor__c = 40.00,
                Rate_Subject_To_Change__c = 'test rate change',
                Rate_Index_Variance__c = 39.00,
                Stream_Number__c = '1',
                EB_Floating_Rate__c = indexRate.Id,
                EB_Loan_Application__c = loanAppId
            );
            rateStreams.add(stream);
        }
        return rateStreams;
    }

    private static List<EB_Loan_Application_Payment_Stream__c> buildpaymentStreams(Id loanAppId) {
        List<EB_Loan_Application_Payment_Stream__c> payStreams = new List<EB_Loan_Application_Payment_Stream__c>();

        for (Integer i = 0; i < 2; i++) {
            EB_Loan_Application_Payment_Stream__c stream = new EB_Loan_Application_Payment_Stream__c(
                Amortization_Schedule_in_Months__c = 42,
                Amount__c = 4200.00,
                Frequency__c = 'test frequency',
                EB_Loan_Application__c = loanAppId,
                Stream_Number__c = '1',
                RecordTypeId = ObjectFactory.getRecordTypeIdByNameAndObject('Amortization', 'EB_Loan_Application_Payment_Stream__c')
            );
            payStreams.add(stream);
        }
        return payStreams;
    }

    private static Boolean containsId(List<PM_SObject> objs, Id objId) {
        for (PM_SObject o : objs) {
            if (o.Id == objId) { return true; } 
        }
        return false;
    }
}