public class LoanBoardingLoanForceDmBuilderHelper implements LoanBoarding.IDmBuilderHelper {    
                    
    public DmLoan buildLoan(Object o) {        
        PM_EB_Loan_Application_c pm = (PM_EB_Loan_Application_c)o; 
        DmLoan dm = new DmLoan();
        dm.Id = pm.Id;
        dm.Name = pm.Name;
        dm.LoanApplicationNumber = pm.Name;
        dm.ProductLine = '';
        dm.ProductType = '';
        dm.Application = '';
        dm.LcComments = '';
        dm.Product = pm.Loan_Type_c;
        dm.OriginalAmount = pm.Total_Loan_Amount_c;
        dm.RiskGrade = pm.Credit_Rating_c;
        dm.NicheProducts = pm.Niche_Products_c;       
        dm.UseOfFunds = pm.Use_of_Funds_c;
        dm.OtherPurposeDescription = pm.Purpose_Of_Loan_c;
        dm.MaturityMonth = pm.Maturity_Term_In_Months_c;
        dm.MaturityDate = pm.Maturity_Date_c;
        dm.lookupKey = (pm.Account_Number_r.Id == null) ? pm.Account_Number_Assigned_c : pm.Account_Number_r.Name;
        dm.accountNumber = (dm.lookupKey == null) ? pm.Name : dm.lookupKey;
        dm.isRenewal = pm.RecordType.Name.contains('Renewal') ? true : false;
        dm.isModification =  pm.RecordType.Name == 'New' ? false : !dm.isRenewal;
        dm.IndustryCode = pm.EB_Account_Industry_Code_r.Name;
        dm.RmComments = pm.Eb_Loan_Packet_r.RM_Commentary_c;
        dm.Channel = pm.Eb_Loan_Packet_r.Channel_c;
        dm.LoanCoordinator = new DmUser();
        dm.CreatedBy = new DmUser();

        List<PM_EB_Loan_App_Rate_Stream_c> rateStreams = pm.EB_Loan_App_Rate_Streams_r;
        if (rateStreams != null && rateStreams.size() > 0) {
            PM_EB_Loan_App_Rate_Stream_c rateStream = rateStreams[0];
            dm.interestRate = rateStream.Fixed_Interest_Rate_c;
            dm.rateFloor = rateStream.Interest_Rate_Floor_c;
            dm.rateCeiling = rateStream.Interest_Rate_Ceiling_c;
            dm.interestRateAdjustmentFrequency = rateStream.Rate_Subject_To_Change_c;
            dm.spread = rateStream.Rate_Index_Variance_c;
            dm.pricingBasis = rateStream.Index_Variance_Code_c;
            dm.index = rateStream.EB_Floating_Rate_r.Name;
        }

        List<PM_EB_Loan_Application_Payment_Stream_c> paymentStreams = pm.EB_Loan_Application_Payment_Streams_r;
        if (paymentStreams != null && paymentStreams.size() > 0) {
            PM_EB_Loan_Application_Payment_Stream_c paymentStream = paymentStreams[0];
            dm.amortizedMonth = paymentStream.Amortization_Schedule_in_Months_c;
            dm.paymentSchedule = paymentStream.Frequency_c;      
            dm.monthlyPayment = paymentStream.Amount_c;
            dm.paymentType = paymentStream.RecordType.Name;
        }

        DmUnit unitDm = new DmUnit();
        unitDm.Name = pm.Eb_Loan_Packet_r.Lead_Entity_r.EB_UnitID_r.Name;
        dm.Unit = unitDm;

        DmUser dmOriginationOfficer = new DmUser();
        if (pm.RecordType.Name == 'New') {
            dmOriginationOfficer.name = pm.RM_c;
        }
        dm.originationOfficer = dmOriginationOfficer; 

        DmUser dmServicingOfficer = new DmUser();
        dmServicingOfficer.Name = pm.RM_c;
        dm.servicingOfficer = dmServicingOfficer;

        return dm;
    }
    
    public DmLoanEntityRelationship buildRelatedEntities(Object o, List<EB_Industry_Code__c> codes) {
        PM_EB_Loan_App_Entity_Relationship_c pm = (PM_EB_Loan_App_Entity_Relationship_c)o;
        DmLoanEntityRelationship dm = new DmLoanEntityRelationship();
        dm.Id = pm.Id;
        dm.Name = pm.Name;
        dm.RelationshipType = pm.Relationship_Type_c;

        DmLoan loanDm = new DmLoan();
        loanDm.Id = pm.Loan_Application_ID_r.Id;
        loanDm.Name = pm.Loan_Application_ID_r.Name;
        dm.Loan = loanDm; 

        DmEntity entityDm = new DmEntity();
        entityDm.Id = pm.Entity_Name_r.Id;
        entityDm.Name = pm.Entity_Name_r.Name;
        entityDm.TaxId = getSsn(pm.Entity_Name_r);
        entityDm.BillingStreet = pm.Entity_Name_r.BillingStreet;
        entityDm.BillingCity = pm.Entity_Name_r.BillingCity;
        entityDm.BillingState = pm.Entity_Name_r.BillingState;
        entityDm.BillingPostalCode = pm.Entity_Name_r.BillingPostalCode;
        entityDm.Phone = pm.Entity_Name_r.Phone;
        entityDm.SicCode = getSic(pm.Entity_Name_r, codes);
        dm.entity = entityDm;
        
        return dm;
    }
    
    private String getSic(PM_Account entity, List<EB_Industry_Code__c> codes) {
        for (EB_Industry_Code__c code : codes) {
            if (entity.Sic != null && entity.Sic.Trim() == code.Industry_Code__c ) {
                return code.Name;
            }
        }
        return entity.Sic;
    }

    private String getSsn(PM_Account a) {
        return String.isBlank(a.SSNTIN_Encrypted_c) ? a.TIN_SSN_c : a.SSNTIN_Encrypted_c;
    }

    public DmParticipation buildParticipation(Object o) {
        PM_EB_Loan_Participation_c pm = (PM_EB_Loan_Participation_c)o;
        DmParticipation dm = new DmParticipation();
        dm.Id = pm.Id;
        dm.Name = pm.name;
        dm.Amount = pm.Participated_Amount_c;
        dm.Bank = pm.Participating_Institution_c;
        dm.ParticipationSold = (pm.RecordType == null || pm.RecordType.Name != 'Bought') ? false : true;
        
        DmLoan loanDm = new DmLoan();
        loanDm.Id = pm.Loan_Application_ID_r.Id;
        loanDm.Name = pm.Loan_Application_ID_r.Name;
        dm.Loan = loanDm;
        
        return dm;
    }
    
    public DmLoanCollateralRelationship buildPledgedCollateral(Object o) {
        PM_EB_Loan_App_Collateral_Relationship_c pm = (PM_EB_Loan_App_Collateral_Relationship_c)o;
        
        DmLoanCollateralRelationship dm = new DmLoanCollateralRelationship();
        dm.Id = pm.Id;
        dm.Name = pm.Name;
        dm.LendableValue = pm.Lendable_Equity_c;
        dm.LienPosition = pm.EB_Collateral_ID_r.Lien_Position_c;
        dm.isPrimary = (pm.Purpose_Of_Collateral_c == 'Primary') ? true : false;
        dm.abundanceOfCaution = (pm.Abundance_Of_Caution_c == 'Yes') ? true : false;
        
        DmLoan dmLoan = new DmLoan();
        dmLoan.Id = pm.EB_Loan_Application_ID_r.Id;
        dmLoan.Name = pm.EB_Loan_Application_ID_r.Name;
        dmLoan.LookupKey = '';
        dm.Loan = dmLoan;

        DmEntity entityDm = new DmEntity();
        if (pm.EB_Collateral_ID_r.Collateral_Owner_r != null) {
            entityDm.Id = pm.EB_Collateral_ID_r.Collateral_Owner_r.Id;
            entityDm.Name = pm.EB_Collateral_ID_r.Collateral_Owner_r.Name;
            entityDm.CoreName = pm.EB_Collateral_ID_r.Collateral_Owner_r.EB_Client_Name_c;
            entityDm.BillingStreet = pm.EB_Collateral_ID_r.Collateral_Owner_r.BillingStreet;
            entityDm.BillingCity = pm.EB_Collateral_ID_r.Collateral_Owner_r.BillingCity;
            entityDm.BillingState = pm.EB_Collateral_ID_r.Collateral_Owner_r.BillingState;  
            entityDm.BillingPostalCode = pm.EB_Collateral_ID_r.Collateral_Owner_r.BillingPostalCode;
        }

        DmCollateralType colTypeDm = new DmCollateralType();
        colTypeDm.Name = pm.Collateral_Code_c;
        
        DmCollateral colDm = new DmCollateral();
        colDm.Description = pm.Description_c; 
        colDm.LendableValue = pm.Lendable_Equity_c; 
        colDm.Id = pm.EB_Collateral_ID_r.Id;
        colDm.Name = pm.EB_Collateral_ID_r.Name;
        colDm.Street = pm.EB_Collateral_ID_r.Street_c;
        colDm.City = pm.EB_Collateral_ID_r.City_c;
        colDm.State = pm.EB_Collateral_ID_r.State_c;
        colDm.PostalCode = pm.EB_Collateral_ID_r.Zip_Code_c;
        colDm.CollateralType = colTypeDm;
        colDm.PrimaryOwner = entityDm;
        dm.Collateral = colDm;       

        return dm;
    }
    
    public DmMemo buildMemo(Object o) {
        return new DmMemo();
    }
    
    public DmLoanPaymentStream buildPayStream(Object o) {
        return new DmLoanPaymentStream();
    }

    public DmLoanRateStream buildRateStream(Object o) {
        return new DmLoanRateStream();
    }
}