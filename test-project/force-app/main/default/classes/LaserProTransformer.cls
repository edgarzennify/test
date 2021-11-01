public class LaserProTransformer {
    public interface IService {
        LpLoan trialExport(DmLoan dm);
        ExportResponse export(DmLoan dm);
    }
    
    public class ExportResponse {
        public String Status {get;set;}
        public String ExportPath {get;set;}
    }
    
	public class LpLoan {
        //Loan Request
        public Double AmountRequested {get;set;}
        public String BorrowerState {get;set;}
        public String PaymentType {get;set;}
        public Integer NumberOfPayments {get;set;}
        public String RateType {get;set;}
        public String CollateralOffered {get;set;}
        public String LoanPurpose {get;set;}
        
        //Interest Rate
        public String IndexRateCode {get;set;}
        public String InterestRateAdjustmentFrequency {get;set;}
        public Double InterestRate {get;set;}
        public String Margin {get;set;}
        public String RateCeiling {get;set;}
        public String RateFloor {get;set;}
        
        //Classification
        public DateTime ApplicationDate {get;set;}
        public String ApplicationNumber {get;set;}
        public String HostSystemLoanType {get;set;}
        public String LoanNumber {get;set;}
        public DateTime LoanDate {get;set;}
        public String Branch {get;set;}
        public String Officer {get;set;}        
        
        //Classification 2
        public String AutomaticLoanPaymentsYesOrNo {get;set;}
        public String EmployeeLoanYesOrNo {get;set;}
        public String DepositAccountNumber {get;set;}
        public String RegOLoan {get;set;}
        
        public List<LpEntity> Entities {get;set;}
        public List<LpCollateral> Collaterals {get;set;}
        public List<LpFee> Fees {get;set;}
    }
    
    public class LpCollateral {
        public String Type {get;set;}
        public String LegalState {get;set;}
        public String SubType {get;set;}
        public String Description {get;set;}
        public String CollateralCode {get;set;}
        public Double MarketValue {get;set;}
        public String StreetAddress {get;set;}
        public String StreetAddressCity {get;set;}
        public String StreetAddressState {get;set;}
        public String StreetAddressPostalCode {get;set;}
        public String StreetAddressCounty {get;set;}
        public List<LpGrantor> RelatedGrantors {get;set;}
        public Boolean InsuranceRequiredYesOrNo {get;set;}
        public Boolean IncludeAgreementToProvideInsuranceYesOrNo {get;set;}
        public String InsuranceAmount {get;set;}
        public String InsuranceBasis {get;set;}
        public String ProveCoverageBy {get;set;}
        public String InsuranceReturnProofTo {get;set;}
        public Boolean ExcludeFromExtract {get;set;}
    }
    
    public class LpGrantor {
        public String Capacity {get;set;}
        public String EntityType {get;set;}
        public String LastName {get;set;}
    }
    
    public class LpEntity {
        public String Capacity {get;set;}
        public String EntityType {get;set;}
        public String FirstName {get;set;}
        public String LastNameOrCompanyName {get;set;}
        public String SsnTin {get;set;}
        public String Authority {get;set;}
        public String StreetAddressFormat {get;set;}
        public String StreetAddress {get;set;}
        public String StreetAddressCity {get;set;}
        public String StreetAddressState {get;set;}
        public String StreetAddressPostalCode {get;set;}
        public String StreetAddressCountry {get;set;}
        public String PrimaryPhone {get;set;}
        public String EmailAddress {get;set;}
        public String BirthDate {get;set;}
        public String CustomerNumber {get;set;}
        public String SicCode {get;set;}
        public Boolean ExcludeFromExtract {get;set;}
    }
    
    public class LpFee {
        public Double CashFee {get;set;}
        public Double FinFee {get;set;}
        public String FeeDescription {get;set;}
    }
}