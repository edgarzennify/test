public class LoanBoardingNcinoDmBuilderHelper implements LoanBoarding.IDmBuilderHelper{

    private final IJson m_json;
    private String PREFIX = 'Unit_';

    public LoanBoardingNcinoDmBuilderHelper(IJson json) {
        m_json = json;
    }

    public DmLoanEntityRelationship buildRelatedEntities(Object involvement, List<EB_Industry_Code__c> industryCodes) {
        PM_LLCBI_Legal_Entities_c pm = (PM_LLCBI_Legal_Entities_c)involvement;
        
        DmLoanEntityRelationship dm = new DmLoanEntityRelationship();
        dm.Id = pm.Id;
        dm.Name = pm.Name;
        dm.Liabilities = pm.Liabilities_c;
        dm.RelationshipType = pm.LLCBI_Borrower_Type_c;
        dm.ContingentType = pm.LLCBI_Contingent_Type_c;
        dm.ContingentPercentage = pm.LLCBI_Ownership_c;
        dm.Limitations = pm.Limitations_c;
        
        DmLoan loanDm = new DmLoan();
        loanDm.Id = pm.LLCBI_Loan_r.Id;
        loanDm.Name = pm.LLCBI_Loan_r.Name;
        dm.Loan = loanDm;
        
        DmEntity entityDm = new DmEntity();
        entityDm.Id = pm.LLCBI_Account_r.Id;
        entityDm.Name = pm.LLCBI_Account_r.Name;
        entityDm.TaxId = getSsn(pm.LLCBI_Account_r);
        entityDm.BillingStreet = pm.LLCBI_Account_r.BillingStreet;
        entityDm.BillingCity = pm.LLCBI_Account_r.BillingCity;
        entityDm.BillingState = pm.LLCBI_Account_r.BillingState;
        entityDm.BillingPostalCode = pm.LLCBI_Account_r.BillingPostalCode;
        entityDm.Phone = pm.LLCBI_Account_r.Phone;
        entityDm.SicCode = getSic(pm.LLCBI_Account_r, industryCodes);
        entityDm.BirthDate = pm.LLCBI_Account_r.Birthdate_c;
        entityDm.RegOCode = pm.LLCBI_Account_r.Reg_O_Code_c;
        dm.entity = entityDm;

        return dm;
    }

    private String getSsn(PM_Account a) {
        return String.isBlank(a.SSNTIN_Encrypted_c) ? a.TIN_SSN_c : a.SSNTIN_Encrypted_c;
    }

    public DmLoanCollateralRelationship buildPledgedCollateral(Object pledge) {
        PM_LLCBI_Loan_Collateral2_c pm = (PM_LLCBI_Loan_Collateral2_c)pledge;
        
        DmLoanCollateralRelationship dm = new DmLoanCollateralRelationship();
        dm.Id = pm.Id;
        dm.Name = pm.Name;
        dm.LienPosition = pm.LLCBI_Lien_Position_c;
        dm.LendableValue = pm.LLCBI_Current_Lendable_Value_c;
        dm.IsPrimary = pm.LLCBI_Is_Primary_c;
        dm.AbundanceOfCaution = pm.Abundance_Of_Caution_c;
        
        DmLoan dmLoan = new DmLoan();
        dmLoan.Id = pm.LLCBI_Loan_r.Id;
        dmLoan.Name = pm.LLCBI_Loan_r.Name;
        dmLoan.LookupKey = pm.LLCBI_Loan_r.LLCBI_lookupKey_c;
        dm.loan = dmLoan;
               
        DmEntity entityDm = new DmEntity();
        PM_Account owner = pm.LLCBI_Collateral_r.Primary_Owner_r;
        if(owner != null){
            entityDm.id = owner.Id;
            entityDm.name = owner.Name;
            entityDm.coreName = owner.EB_Client_Name_c;
            entityDm.billingStreet = owner.BillingStreet;
            entityDm.billingCity = owner.BillingCity;
            entityDm.billingState = owner.BillingState; 
            entityDm.billingPostalCode = owner.BillingPostalCode;

            DmRecordType recordTypeDm = new DmRecordType();
            recordTypeDm.name = owner.RecordType.Name;
            entityDm.recordType = recordTypeDm;
        }
        
        DmCollateralType colTypeDm = new DmCollateralType(); 
        if (pm.LLCBI_Collateral_r != null && pm.LLCBI_Collateral_r.Change_Collateral_Code_c == 'Yes') {
            colTypeDm.Name = pm.LLCBI_Collateral_r.Modified_Collateral_Type_r.Name;
            colTypeDm.CollateralCode = pm.LLCBI_Collateral_r.Modified_Collateral_Type_r.LLCBI_Collateral_Code_c;
        }
        else {
            colTypeDm.name = pm.LLCBI_Collateral_r.LLCBI_Collateral_Type_r.Name;
            colTypeDm.collateralCode = pm.LLCBI_Collateral_r.LLCBI_Collateral_Type_r.LLCBI_Collateral_Code_c;    
        }
        
        DmCollateral colDm = new DmCollateral();
        colDm.id = pm.LLCBI_Collateral_r.Id;
        colDm.name = pm.LLCBI_Collateral_r.Name;
        colDm.coreName = pm.LLCBI_Collateral_r.LLCBI_Collateral_Name_c;
        colDm.description = pm.LLCBI_Collateral_r.LLCBI_Description_c == null ? pm.Description_c : pm.LLCBI_Collateral_r.LLCBI_Description_c;
        colDm.lendableValue = pm.LLCBI_Collateral_r.LLCBI_Lendable_Value_c; 
        colDm.isModifiedCollateralType = pm.LLCBI_Collateral_r.Change_Collateral_Code_c == 'Yes';
        colDm.assignmentOfRents = pm.LLCBI_Collateral_r.Assignment_of_Rent_c;
        colDm.floodInsuranceRequired = pm.LLCBI_Collateral_r.Flood_Insurance_Required_c;
        colDm.appraisedValue = pm.LLCBI_Collateral_r.Appraised_Value_reviewed_c;
        colDm.appraisedValueDate = pm.LLCBI_Collateral_r.Valuation_Date_c;
        colDm.street = pm.LLCBI_Collateral_r.LLCBI_Street_Address_c;
        colDm.city = pm.LLCBI_Collateral_r.LLCBI_City_c;
        colDm.state = pm.LLCBI_Collateral_r.LLCBI_State_c;
        colDm.postalCode = pm.LLCBI_Collateral_r.LLCBI_Zip_Code_c;
        colDm.collateralType = colTypeDm;
        colDm.primaryOwner = entityDm;
        colDm.parcelNumber = pm.LLCBI_Collateral_r.LLC_BI_Parcel_Number_c;
        
        dm.collateral = colDm;

        return dm;
    }

    public DmParticipation buildParticipation(Object participation) {
        PM_LLCBI_Participation_c pm = (PM_LLCBI_Participation_c)participation;
        
        DmParticipation dm = new DmParticipation();
        dm.Id = pm.Id;
        dm.Name = pm.Name;
        dm.PercentParticipation = pm.LLCBI_Participated_c;
        dm.Bank = pm.Bank_c;
        dm.ParticipationSold = (pm.Participation_Sold_c == null) ? false : pm.Participation_Sold_c;
        dm.Amount = pm.Amount_c;
        
        DmLoan loanDm = new DmLoan();
        loanDm.Id = pm.LLCBI_Loan_r.Id;
        loanDm.Name = pm.LLCBI_Loan_r.Name;
        dm.Loan = loanDm;
        
        return dm;
    }

    public DmMemo buildMemo(Object memo) {
        PM_LLCBI_Change_Memo_c pm = (PM_LLCBI_Change_Memo_c)memo;
        
        DmMemo dm = new DmMemo();
        dm.Name = pm.Name;
        dm.Description = pm.LLCBI_Description_c;
        dm.Changes = getChanges(pm);

        return dm;
    }

    private String getChanges(PM_LLCBI_Change_Memo_c pm) {
        String changes = '';
        if (pm.Add_Collateral_c) {changes += 'Add Collateral,';}
        if (pm.LLCBI_Approval_Required_c) {changes += 'Approval Required,';}
        if (pm.Changing_Borrower_s_Name_Address_or_Tax_c) {changes += 'Changing Borrower Name Address or Tax,';}
        if (pm.LLCBI_Collateral_Change_c) {changes += 'Collateral Change';}
        if (pm.Collateral_going_from_lesser_position_to_c) {changes += 'Collateral going from lesser position to,';}
        if (pm.Covenant_Changes_c) {changes += 'Covenant Changes,';}
        if (pm.LLCBI_Equity_Injection_Change_c) {changes += 'Equity Injection Change,';}
        if (pm.Fees_Change_c) {changes += 'Fees Change,';}
        if (pm.LLCBI_Guarantor_Added_c) {changes += 'Guarantor Added,';}
        if (pm.LLCBI_Guarantor_Removed_c) {changes += 'Guarantor Removed,';}
        if (pm.LLCBI_Life_Insurance_Change_c) {changes += 'Life Insurance Change,';}
        if (pm.LLCBI_Amount_Change_c) {changes += 'Loan Amount Change,';}
        if (pm.LLCBI_Loan_Term_Change_c) {changes += 'Loan Term Change,';}
        if (pm.Maturity_Date_Change_c) {changes += 'Maturity Date Change,';}
        if (pm.LLCBI_New_Rate_Requested_c) {changes += 'New Rate Requested,';}
        if (pm.LLCBI_Notify_Attorney_c) {changes += 'Notify Attorney,';}
        if (pm.LLCBI_Other_c) {changes += 'Other,';}
        if (pm.Post_Approval_Requirements_changes_c) {changes += 'Post Approval Requirements changes,';}
        if (pm.LLCBI_Post_Close_Items_c) {changes += 'Post Close Items,';}
        if (pm.LLCBI_Ready_for_Approval_c) {changes += 'Ready for Approval,';}
        if (pm.LLCBI_Re_approval_After_Expiration_c) {changes += 'Re-Approval After Expiration,';}
        if (pm.LLCBI_Seller_Note_Change_c) {changes += 'Seller Note Change,';}
        if (pm.Shortening_Maturity_Date_or_Amortization_c) {changes += 'Shortening Maturity Date or Amortization,';}
        if (pm.LLCBI_Use_of_Proceeds_Change_c) {changes += 'Use of Proceeds Change,';}
        if (pm.LLCBI_User_Initiated_c) {changes += 'User Initiated,';}

        return changes;
    }

    public DmLoanPaymentStream buildPayStream(Object payStream) {
        PM_LLCBI_Pricing_Payment_Component_c pm = (PM_LLCBI_Pricing_Payment_Component_c)payStream;

        DmLoanPaymentStream dm = new DmLoanPaymentStream();
        dm.PaymentType = pm.LLCBI_Type_c;
        dm.Amount = pm.LLCBI_Amount_c;
        dm.Index = pm.LLCBI_Pricing_Stream_r.LLCBI_Sequence_c;
        dm.Frequency = removeNcinoFieldPrefix(pm.LLCBI_Pricing_Stream_r.LLCBI_Term_Unit_c);
        dm.Duration = pm.LLCBI_Pricing_Stream_r.LLCBI_Term_Length_c;
        dm.EffectiveDate = pm.LLCBI_Pricing_Stream_r.LLCBI_Effective_Date_c;
        
        return dm;
    }
    
    public DmLoanRateStream buildRateStream(Object rateStream) {
        PM_LLCBI_Pricing_Rate_Component_c pm = (PM_LLCBI_Pricing_Rate_Component_c)rateStream;

        DmLoanRateStream dm = new DmLoanRateStream();
        dm.PercentageOfLoan = pm.LLCBI_Applied_Loan_Percentage_c;
        dm.InterestRate = pm.LLCBI_Rate_c;
        dm.RateType = (pm.LLCBI_Is_Fixed_c == true) ? 'Fixed' : 'Variable';        
        dm.Index = pm.LLCBI_Pricing_Stream_r.LLCBI_Sequence_c;
        dm.Frequency = removeNcinoFieldPrefix(pm.LLCBI_Pricing_Stream_r.LLCBI_Term_Unit_c);
        dm.Duration = pm.LLCBI_Pricing_Stream_r.LLCBI_Term_Length_c;
        dm.EffectiveDate = pm.LLCBI_Pricing_Stream_r.LLCBI_Effective_Date_c;
        
        dm.PerformanceRules = new List<DmLoanPerformanceRule>();
        for (PM_LLCBI_Pricing_Covenant_c pc: pm.LLCBI_Pricing_Covenants_r) {
            DmLoanPerformanceRule dmpr = new DmLoanPerformanceRule();
            dmpr.Name = pc.Name;
            dmpr.Outcomes = buildOutcomeDms(pc);
            dm.PerformanceRules.add(dmpr);
        }

        return dm;
    }

    private List<DmPerformanceRuleOutcome> buildOutcomeDms (PM_LLCBI_Pricing_Covenant_c pc) {
        try {
            return (List<DmPerformanceRuleOutcome>)m_json.deserialize(pc.LLCBI_Rules_c, List<DmPerformanceRuleOutcome>.class);
        } catch (Exception e) {
            return null;
        }
    }
    
    private String removeNcinoFieldPrefix(String field){
        return field.remove(PREFIX);
    }
    
    public DmLoan buildLoan(Object loan){
        PM_LLCBI_Loan_c pm = (PM_LLCBI_Loan_c)loan;
        
        DmLoan dm = new DmLoan();
        dm.Id = pm.Id;
        dm.Name = pm.Name;
        dm.LookupKey = pm.LLCBI_lookupKey_c;
        dm.ProductLine = pm.LLCBI_Product_Line_c;
        dm.ProductType = pm.LLCBI_Product_Type_c;
        dm.Product = pm.LLCBI_Product_c;
        dm.Application = String.valueOf(pm.Application_c);
        dm.AccountNumber = pm.Account_Number_c;
        dm.OriginalAmount = pm.LLCBI_Amount_c;
        dm.IsRenewal = pm.LLCBI_isRenewal_c;
        dm.IsModification = pm.LLCBI_Is_Modification_c;
        dm.Channel = pm.Channel_c;
        dm.RegOLoan = pm.Reg_O_Loan_c;
        dm.EmployeeLoan = pm.Employee_Loan_c;
        dm.RiskGrade = pm.LLCBI_Risk_Grade_c;
        dm.NicheProducts = pm.Niche_Products_c;  
        dm.NicheProductsFx = pm.Niche_Products_fx_c;
        dm.LoanCharacteristics = pm.Loan_Characteristics_c;
        dm.UseOfFunds = pm.Use_of_Funds_Purpose_c;
        dm.OtherPurposeDescription = pm.Other_Purpose_Description_c;
        dm.LcComments = pm.LC_Comments_c;
        dm.RmComments = pm.RM_Comments_c;
        dm.LendingStrategy = pm.Lending_Strategy_c;
        dm.InterestRate = pm.LLCBI_InterestRate_c;
        dm.AmortizedMonth = pm.LLCBI_Amortized_Term_Months_c;
        dm.MaturityMonth = pm.LLCBI_Term_Months_c;
        dm.FirstPaymentDate = pm.LLCBI_First_Payment_Date_c;
        dm.PricingBasis = pm.LLCBI_Pricing_Basis_c;
        dm.PaymentType = pm.LLCBI_Payment_Type_c;
        dm.PaymentSchedule = pm.LLCBI_Payment_Schedule_c;
        dm.Index = pm.LLCBI_Index_c;
        dm.Spread = pm.LLCBI_Spread_c;
        dm.RateFloor = pm.LLCBI_Rate_Floor_c;
        dm.RateCeiling = pm.LLCBI_Rate_Ceiling_c;
        dm.MonthlyPayment = pm.LLCBI_Monthly_Payment_c;
        dm.InterestRateAdjustmentFrequency = pm.LLCBI_Interest_Rate_Adjustment_Frequency_c;
        dm.MaturityDate = pm.LLCBI_Maturity_Date_c;
        dm.LoanApplicationNumber = pm.Application_Number_c;
        dm.SubjectToMilitaryLendingAct = pm.Military_Lending_Act_c;
        dm.IsLoanToGovernmentRelatedEntity = pm.Is_Loan_to_Gov_t_Related_Entity_c;
        dm.IsRepaymentReliantOnAgriculturalIncome = pm.Is_Repayment_Reliant_on_Ag_Income_c;
        dm.IsLoanToFinancialInstitution = pm.Is_Loan_to_Financial_Institution_c;
        dm.DoesFinancialInstitutionAcceptDeposits = pm.Financial_Institution_Accept_Deposits_c;
        dm.IsImmediateFunding = pm.Immediate_Funding_c;
        dm.WireAmount = pm.Wire_Amount_c;
        dm.DisbursingInstructions = pm.Disbursing_Instructions_c;
        dm.COVID_19_Related_Loan = pm.COVID_19_Related_Loan_c;
        dm.IndustryCode = pm.EB_Industry_Code_r.Name;
        dm.LoanCoordinator = getLoanCoordinator(pm.LLCBI_Loan_Teams_r);
        dm.CreatedBy = getCreatedBy(pm.CreatedBy);
        
        DmUnit dmUnit = new DmUnit();
        dmUnit.Name = pm.Unit_r.Name;
        dmUnit.BranchCode = Integer.valueOf(pm.Unit_r.Branch_Number_c);
        dm.unit = dmUnit;
        
        DmUser OriginationOfficer = new DmUser();
        OriginationOfficer.Name = pm.Originating_Officer_r.Name;
        dm.originationOfficer = OriginationOfficer; 
        
        DmUser ServicingOfficer = new DmUser();
        ServicingOfficer.Name = pm.LLCBI_Loan_Officer_r.Name;
        dm.servicingOfficer = ServicingOfficer;

        return dm;
    }
    
    private DmUser getLoanCoordinator(List<PM_LLCBI_LoanTeam_c> teamMembers) {
        DmUser userDm = new DmUser();
        for (PM_LLCBI_LoanTeam_c teamMember : teamMembers) {
            if (teamMember.LLCBI_Assigned_Role_r.Name == 'Loan Coordinator' && teamMember.Primary_c == true) {
                userDm.Name = teamMember.LLCBI_User_r.Name;
            }
        }
        return userDm;
    }
    
    private DmUser getCreatedBy(PM_User pm) {
        DmUser userDm = new DmUser();
        userDm.Name = pm.Name;        
        return userDm;
    }

    private String getSic(PM_Account entity, List<EB_Industry_Code__c> codes) {
        if (entity == null) {return '';}
        for (EB_Industry_Code__c code : codes) {
            if (entity.Sic != null && entity.Sic.Trim() == code.Industry_Code__c ) {
                return code.Name;
            }
        }
        return entity.Sic;
    }
}