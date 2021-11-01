public class LoanBoardingVmBuilderHelper implements LoanBoarding.IVmBuilderHelper {
    
    private String APOSTROPHE_CHAR = '&#39;';
    private Integer SHORT_DESCRIPTION_LENGTH = 350;
    private String SHORT_DESCRIPTION_TRUNCATION_TEXT = '...[TEXT TRUNCATED]';
    private List<String> CUSTOMER_RELATIONSHIP_SORT_ORDER = new List<String>{
        'Primary Owner'
        ,'Primary Borrower'
        ,'Borrower'
        ,'Secondary Owner'
        ,'Co-Borrower'
        ,'Guarantor'
    };
    
    public LoanBoarding.LoanVm buildVmLoan(DmLoan dmLoan) {
        LoanBoarding.LoanVm vm = new LoanBoarding.LoanVm();
        vm.Id = dmLoan.Id;
        vm.Name = dmLoan.Name;
        vm.ProductType = dmLoan.ProductType;
        vm.ProductLine = dmLoan.ProductLine;
        vm.Product = dmLoan.Product;
        vm.AccountNumber = (dmLoan.IsRenewal || dmLoan.IsModification) ? dmLoan.Name : dmLoan.LookupKey;
        vm.OriginationAmount = dmLoan.OriginalAmount;
        vm.RenewalFlag = getFlag(dmLoan);
        vm.Channel = dmLoan.Channel;
        vm.IsRegOLoan = dmLoan.RegOLoan;
        vm.IsEmployeeLoan = dmLoan.EmployeeLoan;
        vm.RiskGrade = dmLoan.RiskGrade;
        vm.NicheProducts = dmLoan.NicheProducts;
        vm.NicheProductsFx = dmLoan.NicheProductsFx;
        vm.LoanCharacteristics = dmLoan.LoanCharacteristics;
        vm.Industry = dmLoan.IndustryCode;
        vm.UseOfFunds = dmLoan.UseOfFunds;
        vm.OtherPurposeForFunds = dmLoan.OtherPurposeDescription;
        vm.LcComments = replaceChar(dmLoan.LcComments, APOSTROPHE_CHAR, '`');
        vm.RmComments = replaceChar(dmLoan.RmComments, APOSTROPHE_CHAR, '`');
        vm.LoanCoordinator = dmLoan.LoanCoordinator.Name;
        vm.CreatedBy = dmLoan.CreatedBy.Name;
        vm.OriginatingOfficer = dmLoan.OriginationOfficer.Name;
        vm.ServicingOfficer = dmLoan.ServicingOfficer.Name;
        vm.LendingStrategy = dmLoan.LendingStrategy;
        vm.Unit = dmLoan.Unit.Name + ' (' + dmLoan.Unit.BranchCode + ')';
        vm.InterestRate = dmLoan.InterestRate;
        vm.FirstPaymentDate = dmLoan.FirstPaymentDate;
        vm.Amortized = dmLoan.AmortizedMonth;
        vm.Maturity = dmLoan.MaturityMonth;
        vm.CollateralCode = getCollateralCode(dmLoan);
        vm.PricingBasis = dmLoan.PricingBasis;
        vm.PaymentType = dmLoan.PaymentType;
        vm.PaymentSchedule = dmLoan.PaymentSchedule;
        vm.Index = dmLoan.Index;
        vm.Spread = dmLoan.Spread;
        vm.RateFloor = dmLoan.RateFloor;
        vm.RateCeiling = dmLoan.RateCeiling;
        vm.MonthlyPayment = dmLoan.MonthlyPayment;
        vm.InterestRateAdjustmentFrequency = dmLoan.InterestRateAdjustmentFrequency;
        vm.MaturityDate = dmLoan.MaturityDate;
        vm.LoanApplicationNumber = dmLoan.LoanApplicationNumber;
        vm.SubjectToMilitaryLendingAct = dmLoan.SubjectToMilitaryLendingAct;
        vm.GovtRelatedEntity = dmLoan.IsLoanToGovernmentRelatedEntity;
        vm.ReliantOnAgIncome = dmLoan.IsRepaymentReliantOnAgriculturalIncome;
        vm.ToFinancialInst = dmLoan.IsLoanToFinancialInstitution;
        vm.DoesFinancialInstAcceptDeposits = dmLoan.DoesFinancialInstitutionAcceptDeposits;
        vm.ImmediateFunding = dmLoan.IsImmediateFunding;
        vm.WireAmount = dmLoan.WireAmount;
        vm.DisbursingInstructions = dmLoan.DisbursingInstructions;
        vm.Covid_19_Loan = dmLoan.COVID_19_Related_Loan;
        return vm;
    }

    private String getflag(DmLoan dm){
        if (dm.isRenewal) { return 'Renewal'; }
        if (dm.isModification) { return 'Modification'; }
        return 'New';
    }

    private String replaceChar(String val, String frm, String to){
        if (String.isBlank(val)) { return val; }
        return val.replace(frm, to);
    }

    private String getCollateralCode(DmLoan loan){
        for(DmLoanCollateralRelationship dm : loan.pledgedCollateral){
            if(dm.isPrimary){
                return getCollateralCodeDescription(dm.collateral);
            }
        }
        return '';
    }
 
    private String getCollateralCodeDescription(DmCollateral dm) { 
        if (dm.isModifiedCollateralType) {
            return '***MODIFIED*** ' + dm.CollateralType.Name;
        }
        return dm.CollateralType.Name;
    }

    public LoanBoarding.CustomerVm buildAccountToCustomerRelationship(DmLoanEntityRelationship dm) {
        LoanBoarding.CustomerVm vm = new LoanBoarding.CustomerVm();
            vm.Name = dm.Name;
            vm.Liabilities = dm.Liabilities;
            vm.RelationshipType = dm.RelationshipType;
            vm.ContingentType = dm.ContingentType;
            vm.ContingentPercentage = dm.ContingentPercentage;
            vm.Limitations = dm.Limitations;
            vm.Loan = dm.Loan.Name;
            vm.Entity = dm.Entity.Name;
            vm.TaxId = dm.Entity.TaxId;
            vm.Phone = dm.Entity.Phone;
            vm.Sic = dm.Entity.SicCode;
            vm.Dob = dm.Entity.BirthDate;
            vm.LicenseNum = dm.Entity.DriversLicense;
            vm.RegOCode = dm.Entity.RegOCode;
            vm.Address = getAddress(dm.Entity);
            vm.SortOrder = getSortOrder(dm.RelationshipType);
        return vm;
    }

    private String getAddress(DmEntity dm) {
        return formatAddress(dm.billingStreet, dm.billingCity, dm.billingState, dm.billingPostalCode);
    }

    private String formatAddress(String street, String city, String state, String postalCode) {
        if (street == null) { return ''; }
        return String.format('{0}, {1}, {2} {3}', new List<String>{street, city, state, postalCode});
    }

    private Integer getSortOrder(String relationshipType) {
        Integer index = indexOf(relationshipType, CUSTOMER_RELATIONSHIP_SORT_ORDER);
        return (index == -1) ? CUSTOMER_RELATIONSHIP_SORT_ORDER.size() + 1 : index;
    }

    private Integer indexOf(String lookup, List<String> theList){
        for (Integer i=0; i<theList.size(); ++i) {
            if (theList[i] == lookup) { return i; }
        }
        return -1;
    }

    public LoanBoarding.CollateralVm buildVmCollateral(DmLoanCollateralRelationship dm) {
        LoanBoarding.CollateralVm vm = new LoanBoarding.CollateralVm();
        vm.name = dm.name;
        vm.lienPosition = dm.lienPosition;
        vm.lendableValue = dm.lendableValue;
        vm.abundanceOfCaution =  dm.abundanceOfCaution;
        vm.isPrimary = dm.isPrimary;
        vm.isOwnedByPrimaryBorrower = dm.isOwnedByPrimaryBorrower;
        vm.loan = dm.loan.name;
        vm.coreName = dm.collateral.coreName;
        vm.collateralName = dm.collateral.name;
        vm.description = getShortDescription(dm.collateral.description);
        vm.collateralType = getCollateralCodeDescription(dm.collateral);
        vm.appraisedValue = dm.collateral.appraisedValue;
        vm.appraisedValueDate = dm.collateral.appraisedValueDate;
        vm.floodRequired = dm.collateral.floodInsuranceRequired;
        vm.assignmentOfRents = dm.collateral.assignmentOfRents;
        vm.collateralAddress = getAddress(dm.collateral);
        vm.ownerName = dm.collateral.primaryOwner.name;
        vm.ownerAddress = getAddress(dm.collateral.primaryOwner);
        vm.parcelNumber = dm.collateral.parcelNumber;
        return vm;
    }

    private String getAddress(DmCollateral dm){
        return formatAddress(dm.street, dm.city, dm.state, dm.postalCode);
    }

    private String getShortDescription(String description){
        if(String.isNotBlank(description)){
            if(description.length() > SHORT_DESCRIPTION_LENGTH){
                return description.subString(0,SHORT_DESCRIPTION_LENGTH-1) + SHORT_DESCRIPTION_TRUNCATION_TEXT;
            }
        }
        return description;
    }

    public LoanBoarding.ParticipationVm buildVmParticipation(DmParticipation dm) {
        LoanBoarding.ParticipationVm vm = new LoanBoarding.ParticipationVm();
        vm.Name = dm.Name;
        vm.PercentParticipation = dm.PercentParticipation;
        vm.Bank = dm.Bank;
        vm.Amount = dm.Amount;
        vm.BoughtSold = (dm.ParticipationSold==true) ? 'Sold' : 'Bought'; 
        vm.Loan = dm.Loan.Name;
        return vm;
    }

    public LoanBoarding.MemoVm buildVmMemo(DmMemo dm) {
        LoanBoarding.MemoVm vm = new LoanBoarding.MemoVm();
        vm.Changes = dm.Changes;
        vm.Description = dm.Description;
        return vm;
    }

    public LoanBoarding.LoanPaymentStreamVm buildVmPayStream(DmLoanPaymentStream dm) {
        LoanBoarding.LoanPaymentStreamVm vm = new LoanBoarding.LoanPaymentStreamVm();
        vm.Index = dm.Index;
        vm.EffectiveDate = dm.EffectiveDate;
        vm.Duration = dm.Duration;
        vm.Frequency = dm.Frequency;
        vm.PaymentType = dm.PaymentType;
        vm.Amount = dm.Amount;
        return vm;
    }

    public LoanBoarding.LoanRateStreamVm buildVmRateStream(DmLoanRateStream dm) {
        LoanBoarding.LoanRateStreamVm vm = new LoanBoarding.LoanRateStreamVm();
        vm.Index = dm.Index;
        vm.Duration = dm.Duration;
        vm.Frequency = dm.Frequency;
        vm.PercentageOfLoan = dm.PercentageOfLoan;
        vm.RateType = dm.RateType;
        vm.EffectiveDate = dm.EffectiveDate;
        vm.InterestRate = dm.InterestRate;

        vm.PerformanceRules = new List<LoanBoarding.LoanPerformanceRuleVm>();
        for (DmLoanPerformanceRule prDm : dm.PerformanceRules) {
            LoanBoarding.LoanPerformanceRuleVm prVm = new LoanBoarding.LoanPerformanceRuleVm();
            prVm.IndicatorType = prDm.Name;
            
            if (prDm.Outcomes == null) {
                prVm.Outcomes = buildErrorVmOutcome();
            } else {
                prVm.Outcomes = buildValidVmOutcomes(prDm.Outcomes);
            }

            Vm.PerformanceRules.add(prVm);
        }

        return vm;
    }

    private List<LoanBoarding.LoanPerformanceRuleOutcomeVm> buildErrorVmOutcome() {
        List<LoanBoarding.LoanPerformanceRuleOutcomeVm> outcomeVms = new List<LoanBoarding.LoanPerformanceRuleOutcomeVm>();
        LoanBoarding.LoanPerformanceRuleOutcomeVm vm = new LoanBoarding.LoanPerformanceRuleOutcomeVm();
        vm.Outcome = '***Error*** Please Contact IT Dept.'; 
        outcomeVms.add(vm);
        return outcomeVms;
    }

    private List<LoanBoarding.LoanPerformanceRuleOutcomeVm> buildValidVmOutcomes(List<DmPerformanceRuleOutcome> dms) {
        List<LoanBoarding.LoanPerformanceRuleOutcomeVm> outcomeVMs = new List<LoanBoarding.LoanPerformanceRuleOutcomeVm>();
        
        for (DmPerformanceRuleOutcome dm : dms) {
            LoanBoarding.LoanPerformanceRuleOutcomeVm vm = new LoanBoarding.LoanPerformanceRuleOutcomeVm();
            List<Object> strPieces = new List<Object>{
                dm.ComparisonOperator,
                dm.ComparisonValue,
                dm.MinComparisonValue,
                dm.MaxComparisonValue,
                dm.AdjustmentAction,
                dm.AdjustmentAmount
            };
            
            if (dm.ComparisonOperator == 'In Between') {
                if (dm.AdjustmentAction == 'Leave Rate Unchanged') {
                    String strTemplate = '{0} {2} and {3} then {4}';
                    vm.Outcome = String.format(strTemplate, strPieces);
                    outcomeVMs.add(vm);
                } else {
                    String strTemplate = '{0} {2} and {3} then {4}: {5}%';
                    vm.Outcome = String.format(strTemplate, strPieces);
                    outcomeVMs.add(vm);
                }
            } else {
                if (dm.AdjustmentAction == 'Leave Rate Unchanged') {
                    String strTemplate = '{0} {1} then {4}';
                    vm.Outcome = String.format(strTemplate, strPieces);
                    outcomeVMs.add(vm);
                } else {
                    String strTemplate = '{0} {1} then {4}: {5}%';
                    vm.Outcome = String.format(strTemplate, strPieces);
                    outcomeVMs.add(vm);
                }
            }
        }
        return outcomeVMs;
    }
}