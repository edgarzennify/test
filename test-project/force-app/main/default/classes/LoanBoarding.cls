public class LoanBoarding {
    public interface IPresenter {
        FormVm build(String loanId);
    }

    public interface IVmBuilder {
        FormVm buildFormVm(DmLoan dmLoan);
    }

    public interface IVmBuilderHelper {
        LoanBoarding.LoanVm buildVmLoan(DmLoan dmLoan);
        LoanBoarding.CustomerVm buildAccountToCustomerRelationship(DmLoanEntityRelationship dm);
        LoanBoarding.CollateralVm buildVmCollateral(DmLoanCollateralRelationship dm);
        LoanBoarding.ParticipationVm buildVmParticipation(DmParticipation dm);
        LoanBoarding.MemoVm buildVmMemo(DmMemo dm);
        LoanBoarding.LoanPaymentStreamVm buildVmPayStream(DmLoanPaymentStream dm);
        LoanBoarding.LoanRateStreamVm buildVmRateStream(DmLoanRateStream dm);
    }

    public interface IDataProvider {
        PM_LLCBI_Loan_c getnCinoLoan(Id loanId);
        PM_EB_Loan_Application_c getLoanForceLoan(Id loanId);
        List<PM_EB_Collateral_Client_Relationship_c> getLoanForceCollateralEntityRelationships(List<Id> collateralIds);
        List<EB_Industry_Code__c> getIndustryCodes();
        List<PM_LLCBI_Pricing_Payment_Component_c> getnCinoPayStreams(String loanId);
        List<PM_LLCBI_Pricing_Rate_Component_c> getnCinoRateStreams(String loanId);
    }

    public interface IDmBuilder {
        SObjectType isType();
        DmLoan buildDmLoan(String loanId);
    }

    public interface IDmBuilderHelper {
        DmLoan buildLoan(Object pm);
        DmLoanEntityRelationship buildRelatedEntities(Object pm, List<EB_Industry_Code__c> industryCodes);
        DmLoanCollateralRelationship buildPledgedCollateral(Object pm);
        DmParticipation buildParticipation(Object pm);
        DmMemo buildMemo(Object pm);
        DmLoanPaymentStream buildPayStream(Object pm);
        DmLoanRateStream buildRateStream(Object pm);
    }

    public static IPresenter bootstrapIPresenter() {
        IDataProvider dataProvider = new LoanBoardingDataProvider();
        IJson json = new JsonWrapper();
		IDmBuilderHelper dmBuilderNcinoHelper = new LoanBoardingNcinoDmBuilderHelper(json);
		IDmBuilder dmBuilderNcino = new LoanBoardingNcinoDmBuilder(dataProvider, dmBuilderNcinoHelper);
		IDmBuilderHelper dmBuilderLoanForceHelper = new LoanBoardingLoanForceDmBuilderHelper();		
		IDmBuilder dmBuilderLoanForce = new LoanBoardingLoanForceDmBuilder(dataProvider, dmBuilderLoanForceHelper);
        List<IDmBuilder> dmBuilders = new List<IDmBuilder>{dmBuilderNcino, dmBuilderLoanForce};
        IVmBuilderHelper vmBuilderHelper = new LoanBoardingVmBuilderHelper();
		IVmBuilder vmBuilder = new LoanBoardingVmBuilder(vmBuilderHelper);
		IPresenter presenter = new LoanBoardingPresenter(dmbuilders, vmBuilder);
		return presenter;
    }
    
    public class FormVm {
        public LoanVm Loan {get;set;}   
        public List<CustomerVm> AccountToCustomerRelationships {get;set;}
        public List<CollateralVm> BorrowerCollateral {get;set;}
        public List<CollateralVm> OtherCollateral {get;set;}
        public List<ParticipationVm> Participations {get;set;}
        public List<MemoVm> ChangeMemos {get;set;}
        public List<LoanPaymentStreamVm> PayStreams {get;set;}
        public List<LoanRateStreamVm> RateStreams {get;set;}
    }

    public class LoanVm {
        public String Id {get;set;}
        public String Name {get;set;}
        public String RenewalFlag {get;set;}
        public String AccountNumber {get;set;}
        public String Product {get;set;}
        public String ProductType {get;set;}
        public String ProductLine {get;set;}    
        public Decimal OriginationAmount {get;set;}
        public String Channel {get;set;}
        public Boolean IsRegOLoan {get;set;}
        public Boolean IsEmployeeLoan {get;set;}
        public String RiskGrade {get;set;}
        public String NicheProducts {get;set;}
        public String NicheProductsfx {get;set;}
        public String LoanCharacteristics {get;set;}
        public String Industry {get;set;}
        public String UseOfFunds {get;set;}
        public String OtherPurposeForFunds {get;set;}
        public String LcComments {get;set;}
        public String RmComments {get;set;}
        public String LoanCoordinator {get;set;}
        public String CreatedBy {get;set;}
        public String ServicingOfficer {get;set;}
        public String OriginatingOfficer {get;set;}
        public String Unit {get;set;}
        public String LendingStrategy {get;set;}
        public String CollateralCode {get;set;}       
        public Decimal InterestRate {get;set;}
        public Decimal Maturity {get;set;}
        public Decimal Amortized {get;set;}
        public Date FirstPaymentDate {get;set;}
        public String PricingBasis {get;set;}
        public String PaymentType {get;set;}
        public String PaymentSchedule {get;set;}
        public String Index {get;set;}
        public Decimal Spread {get;set;}
        public Decimal RateFloor {get;set;}
        public Decimal RateCeiling {get;set;}
        public Decimal MonthlyPayment {get;set;}
        public String InterestRateAdjustmentFrequency {get;set;}
        public Date MaturityDate {get;set;}
        public String LoanApplicationNumber {get;set;}
        public String SubjectToMilitaryLendingAct {get;set;}
        public String GovtRelatedEntity {get;set;}
        public String ReliantOnAgIncome {get;set;}
        public String ToFinancialInst {get;set;}
        public String DoesFinancialInstAcceptDeposits {get;set;}
        public Boolean ImmediateFunding {get;set;}
        public Decimal WireAmount {get;set;}
        public String DisbursingInstructions {get;set;}
        public String Covid_19_Loan {get;set;}
    }

    public class CustomerVm implements Comparable {
        public String Name {get;set;}
        public String Loan {get;set;}
        public String Entity {get;set;}
        public String Key {get;set;}
        public Decimal Liabilities{get;set;}
        public String RelationshipType {get;set;}
        public String TaxId {get;set;}
        public String Address {get;set;}
        public String Phone {get;set;}
        public String Sic {get;set;}
        public Date Dob {get;set;}
        public String LicenseNum {get;set;}
        public String ContingentType {get;set;}
        public Decimal ContingentPercentage {get;set;}
        public String Limitations {get;set;}
        public String RegOCode {get;set;}
        public Decimal SortOrder {get;set;}

        public Integer compareTo(Object compareTo) {
            CustomerVm compareToObject = (CustomerVm)compareTo;
            if (sortOrder < compareToObject.sortOrder) return -1;
            if (sortOrder == compareToObject.sortOrder) return 0;
            return 1;
        }
    }

    public class CollateralVm {
        public String Name {get;set;}
        public String CoreName {get;set;}
        public String Loan {get;set;}
        public String LienPosition{get;set;}
        public Decimal LendableValue{get;set;}
        public Decimal AppraisedValue{get;set;}
        public Date AppraisedValueDate{get;set;}
        public String FloodRequired{get;set;}
        public String AssignmentOfRents{get;set;}
        public String CollateralName {get;set;}
        public String Description {get;set;}
        public Boolean AbundanceOfCaution {get;set;}
        public Boolean IsPrimary {get;set;}
        public String CollateralType{get;set;}
        public String CollateralAddress {get;set;}
        public String OwnerName{get;set;}
        public String OwnerAddress{get;set;}
        public String OwnerRelationshipType{get;set;}
        public Boolean IsOwnedByPrimaryBorrower {get;set;}
        public String ParcelNumber{get;set;}
    }

    public class ParticipationVm {
        public String Name {get;set;}
        public Decimal PercentParticipation {get;set;}
        public String Loan{get;set;}
        public String Bank {get;set;}
        public Decimal Amount {get;set;}
        public String BoughtSold {get;set;}
    }

    public class MemoVm {
        public String Changes {get;set;}
        public String Description {get;set;}
    }

    public class LoanPaymentStreamVm {
        public Decimal Index {get;set;}
        public String PaymentType {get;set;}
        public String Frequency {get;set;}
        public Decimal Duration {get;set;}
        public Decimal Amount {get;set;}
        public Datetime EffectiveDate {get;set;}
    }
    
    public class LoanRateStreamVm {
        public Decimal Index {get;set;}
        public Decimal Duration {get;set;}
        public String Frequency {get;set;}
        public Decimal PercentageOfLoan {get;set;}
        public String RateType {get;set;}
        public Decimal InterestRate {get;set;}
        public Datetime EffectiveDate {get;set;}
        public List<LoanPerformanceRuleVm> PerformanceRules {get;set;}
    }

    public class LoanPerformanceRuleOutcomeVm {
        public String Outcome {get;set;}
    }

    public class LoanPerformanceRuleVm {
        public String IndicatorType {get;set;}
        public List<LoanPerformanceRuleOutcomeVm> Outcomes {get;set;}
    }

    public class LoanForceLoanPm {
        public EB_Loan_Application__c LoanApplication {get;set;}
        public List<EB_Loan_App_Collateral_Relationship__c> LoanAppCollaterals {get;set;}
        public List<EB_Loan_Participation__c> Participations {get;set;}
        public List<EB_Loan_App_Entity_Relationship__c> LoanAppEntities {get;set;}
        public List<EB_Loan_App_Rate_Stream__c> RateStreams {get;set;}
        public List<EB_Loan_Application_Payment_Stream__c> PayStreams {get;set;}
    }

    public class NcinoLoanPm {
        public LLC_BI__Loan__c LoanApplication {get;set;}
        public List<LLC_BI__Loan_Collateral2__c> LoanAppCollaterals {get;set;}
        public List<LLC_BI__Participation__c> Participations {get;set;}
        public List<LLC_BI__Legal_Entities__c> LoanAppEntities {get;set;}
        public List<LLC_BI__Credit_Memo_Modifcation__c> Memos {get;set;}
    }
}