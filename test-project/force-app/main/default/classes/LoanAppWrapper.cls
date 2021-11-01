public with sharing class LoanAppWrapper implements LoanAppWrapper.ILoanAppWrapper {

	public interface ILoanAppWrapper {
		Boolean isAgriculturalPurpose();
		Boolean isAllResidentialRealEstateCollateralTakenAsAbundanceOfCaution();
		Boolean isBusinessPurpose();
		Boolean isConstructionLandDevelopment();
		Boolean isHMDAEligibleLoanType();
		Boolean isHOEPAEligibleLoanType();
		Boolean isHOEPAPurposeToFinanceInitialConstructionOfPrincipalDwelling();
		Boolean isHomeImprovement();
		Boolean isLetterOfCredit();
		Boolean isLoanAmountOver500K();
		Boolean isLoanAmountOver1M();
		Boolean isModificationWithoutIncreasedLoanAmount();
		Boolean isOriginalLoanAmountOver500K();
		Boolean isOriginalLoanAmountOver1M();
		Boolean isPurchaseResidentialRealEstate();
		Boolean isPurposeOfLoanToBuySecurities();
        Boolean isCRAEligibleLoanType();
        Boolean isCRAEligibleRecordType();
		Boolean isRefinanceToPayoffExistingDebtBySameBorrower();
		Boolean isRefinanceResidentialRealEstate();
		Boolean isResidentialRehab();
		Boolean hasDwellingCollateral();
		Boolean hasNonCommercialRealEstateCollateral();
		Boolean hasPurchasedParticipation();
		Boolean hasRealEstateCollateral();
		Boolean hasCRAEligibleCollateral();
	}

	private final string AGRICULTURAL_PURPOSE = 'Agricultural Purpose';
	private final string BOUGHT = 'Bought';
	private final string BUY_OR_CARRY_SECURITIES = 'Buy or Carry Securities';
	private final string CONSTRUCTION_DEVELOPMENT = 'Construction / Land Development';
	private final string FIVE_ONE_ARM = '5/1 ARM';
	private final string FIXED_LINE = 'Fixed Line';
	private final string HOME_EQUITY_LINE = 'Home Equity Line';
	private final string HOME_IMPROVEMENT = 'Home Improvement';
	private final string LETTER_OF_CREDIT = 'Letter of Credit';
	private final string NON_COMMERCIAL = 'Non-Commercial';
	private final string PAYOFF_EXISTING_DEBT_SAME_BORROWER = 'Payoff of Exsisting Debt by the same Borrower';
	private final string PERMANENT_MORTGAGE = 'Permanent Mortgage';
	private final string PURCHASE_RESIDENTIAL_REAL_ESTATE = 'Purchase Residential Real Estate';
	private final string REAL_ESTATE = 'Real Estate';
	private final string REFINANCE_RESIDENTIAL_REAL_ESTATE = 'Refinance Residential Real Estate';
	private final string RESIDENTIAL_REHAB = 'Residential Rehab';
	private final string REVOLVING_LINE = 'Revolving Line';
	private final string GUIDANCE_LINE_FIXED = 'Guidance Line - Fixed';
	private final string GUIDANCE_LINE_REVOLVING = 'Guidance Line - Revolving';
	private final string TERM = 'Term';
	private final string YES = 'Yes';    
    private final string MODIFICATION_FULL = 'Modification - Full';
    private final string NEW_APP ='New';
    private final string ADMIN_RENEWAL ='Admin Renewal';
    private final string NEW_GUIDANCE_LINE_ADVANCE ='New - Guidance Line Advance';
    private final string RENEWAL ='Renewal';
    private final string RENEWAL_MODIFICATION ='Renewal/Modification';
    private final string COLLATERAL_CODE_47 ='47';
    private final string COLLATERAL_CODE_52 ='52';
    private final string COLLATERAL_CODE_55 ='55';
    private final string COLLATERAL_CODE_57 ='57';
    private final string COLLATERAL_CODE_65 ='65';
    private final string COLLATERAL_CODE_94 ='94';
    private final string COLLATERAL_CODE_95 ='95';
    private final string COLLATERAL_CODE_CM ='CM';
    private final string COLLATERAL_CODE_CR ='CR';

	private LoanAppWrapperHelper.ILoanAppWrapperHelper m_wrapperHelper;
	private EB_Loan_Application__c m_loanApp;

	private List<EB_Loan_Participation__c> relatedLoanParticipations;
	private List<EB_Loan_Participation__c> m_relatedLoanParticipations {
		get{ 
			if(relatedLoanParticipations == null){
				relatedLoanParticipations = m_wrapperHelper.getRelatedLoanParticipationsForLoanApp(m_loanApp);
			}
			return relatedLoanParticipations;
		}
	}

	private List<EB_Collateral__c> relatedCollateral;
	private List<EB_Collateral__c> m_relatedCollateral {
		get{ 
			if(relatedCollateral == null){
				relatedCollateral = m_wrapperHelper.getRelatedCollateralsForLoanApp(m_loanApp);
			}
			return relatedCollateral;
		}
	}

	private List<EB_Loan_App_Collateral_Relationship__c> loanAppCollateralRelationships;
	private List<EB_Loan_App_Collateral_Relationship__c> m_loanAppCollateralRelationships {
		get{ 
			if(loanAppCollateralRelationships == null){
				loanAppCollateralRelationships = m_wrapperHelper.getLoanAppToCollateralRelationships(m_loanApp);
			}
			return loanAppCollateralRelationships;
		}
	}

	public LoanAppWrapper(EB_Loan_Application__c loanApp){
		LoanAppWrapperHelper wrapperHelper = new LoanAppWrapperHelper();
		Initialize(loanApp, wrapperHelper);
	}

	public LoanAppWrapper(EB_Loan_Application__c loanApp, LoanAppWrapperHelper.ILoanAppWrapperHelper wrapperHelper){
		Initialize(loanApp, wrapperHelper);
	}

	public Boolean isAgriculturalPurpose(){
		return m_loanApp.Use_of_Funds__c == AGRICULTURAL_PURPOSE ? true : false;
	}

	public Boolean isAllResidentialRealEstateCollateralTakenAsAbundanceOfCaution()
	{
		Boolean foundAbundenceOfCaution = false;
		for(EB_Loan_App_Collateral_Relationship__c rel : m_loanAppCollateralRelationships)
		{
			if(rel.EB_Collateral_ID__r.Collateral_Code__r.Category__c == REAL_ESTATE 
				&& rel.EB_Collateral_ID__r.Collateral_Code__r.CRA_Real_Estate_Details__c == NON_COMMERCIAL){
				if(rel.Abundance_of_Caution__c == YES){
					foundAbundenceOfCaution = true;
				}else{
					return false;
				}
			}
		}
		return foundAbundenceOfCaution;
	}

	public Boolean isBusinessPurpose(){
		return m_loanApp.Business_Purpose__c == YES ? true : false;
	}

	public Boolean isConstructionLandDevelopment(){
		return m_loanApp.Use_of_Funds__c == CONSTRUCTION_DEVELOPMENT ? true : false;
	}

	public Boolean isHMDAEligibleLoanType(){
		if(m_loanApp.Loan_Type__c == HOME_EQUITY_LINE) return false;
		if(m_loanApp.Loan_Type__c == REVOLVING_LINE) return false;
		if(isGuidanceLineLoanType()) return false;
		return true;
	}

	public Boolean isCRAEligibleLoanType(){
		if(m_loanApp.Loan_Type__c == HOME_EQUITY_LINE) return false;
		if(isGuidanceLineLoanType()) return false;
		return true;
	}

	public Boolean isHOEPAEligibleLoanType(){
		if(m_loanApp.Loan_Type__c == FIVE_ONE_ARM) return true;
		if(m_loanApp.Loan_Type__c == FIXED_LINE) return true;
		if(m_loanApp.Loan_Type__c == HOME_EQUITY_LINE) return true;
		if(m_loanApp.Loan_Type__c == PERMANENT_MORTGAGE) return true;
		if(m_loanApp.Loan_Type__c == REVOLVING_LINE) return true;
		if(m_loanApp.Loan_Type__c == TERM) return true;
		return false;
	}

	public Boolean isCRAEligibleRecordType(){
		if(m_loanApp.RecordType.Name==NEW_APP) return true;
		if(m_loanApp.RecordType.Name==MODIFICATION_FULL) return true;
		if(m_loanApp.RecordType.Name==ADMIN_RENEWAL) return true;
		if(m_loanApp.RecordType.Name==NEW_GUIDANCE_LINE_ADVANCE) return true;
		if(m_loanApp.RecordType.Name==RENEWAL) return true;
		if(m_loanApp.RecordType.Name==RENEWAL_MODIFICATION) return true;
		return false;
	}

	public Boolean isHOEPAPurposeToFinanceInitialConstructionOfPrincipalDwelling(){
		return m_loanApp.HOEPA_Finance_Purchase_Or_Construction__c == YES ? true : false;
	}

	public Boolean isHomeImprovement(){
		return m_loanApp.Use_of_Funds__c == HOME_IMPROVEMENT ? true : false;
	}

	public Boolean isLetterOfCredit(){
		return m_loanApp.Loan_Type__c == LETTER_OF_CREDIT ? true : false;
	}

	public Boolean isLoanAmountOver500K(){
		return getLoanAmount() > 500000 ? true : false;
	}

	public Boolean isLoanAmountOver1M(){
		return getLoanAmount() > 1000000 ? true : false;
	}

	public Boolean isOriginalLoanAmountOver500K(){
		return getOriginalLoanAmount() > 500000 ? true : false;		
	}

	public Boolean isOriginalLoanAmountOver1M(){
		return getOriginalLoanAmount() > 1000000 ? true : false;		
	}

	public Boolean isModificationWithoutIncreasedLoanAmount(){
		if(m_LoanApp.RecordType.Name == MODIFICATION_FULL && m_LoanApp.Account_Number__r !=null)
        {
			return (m_loanApp.Bank_Owned_Loan_Amount__c > m_loanApp.Account_Number__r.Current_Loan_Amount__c) ? false : true;
		}
		return false;
	}

	public Boolean isPurchaseResidentialRealEstate(){
		return m_loanApp.Use_of_Funds__c == PURCHASE_RESIDENTIAL_REAL_ESTATE ? true : false;
	}

	public Boolean isPurposeOfLoanToBuySecurities(){
		return m_loanApp.Use_of_Funds__c == BUY_OR_CARRY_SECURITIES ? true : false;
	}

	public Boolean isRefinanceToPayoffExistingDebtBySameBorrower(){
		return m_loanApp.Refinance_Type__c == PAYOFF_EXISTING_DEBT_SAME_BORROWER ? true : false;
	}

	public Boolean isRefinanceResidentialRealEstate(){
		return m_loanApp.Use_of_Funds__c == REFINANCE_RESIDENTIAL_REAL_ESTATE ? true : false;
	}

	public Boolean isResidentialRehab(){
		return m_loanApp.Use_of_Funds__c == RESIDENTIAL_REHAB ? true : false;
	}

	public Boolean hasCRAEligibleCollateral(){
		for(EB_Collateral__c collateral : m_relatedCollateral)
		{
			if(collateral.Collateral_Code__r.Collateral_Code_ID__c == COLLATERAL_CODE_47) return false;
			if(collateral.Collateral_Code__r.Collateral_Code_ID__c == COLLATERAL_CODE_52) return false;
			if(collateral.Collateral_Code__r.Collateral_Code_ID__c == COLLATERAL_CODE_55) return false;
			if(collateral.Collateral_Code__r.Collateral_Code_ID__c == COLLATERAL_CODE_57) return false;
			if(collateral.Collateral_Code__r.Collateral_Code_ID__c == COLLATERAL_CODE_65) return false;
			if(collateral.Collateral_Code__r.Collateral_Code_ID__c == COLLATERAL_CODE_94) return false;
			if(collateral.Collateral_Code__r.Collateral_Code_ID__c == COLLATERAL_CODE_95) return false;
			if(collateral.Collateral_Code__r.Collateral_Code_ID__c == COLLATERAL_CODE_CM) return false;
			if(collateral.Collateral_Code__r.Collateral_Code_ID__c == COLLATERAL_CODE_CR) return false;
		}
		return true;
	}

	public Boolean hasDwellingCollateral(){
		for(EB_Collateral__c collateral : m_relatedCollateral)
		{
			if(collateral.Collateral_Code__r.IsHMDADwelling__c) return true;
		}
		return false;
	}

	public Boolean hasNonCommercialRealEstateCollateral(){
		for(EB_Collateral__c collateral : m_relatedCollateral)
		{
			if(collateral.Collateral_Code__r.CRA_Real_Estate_Details__c==NON_COMMERCIAL) return true;
		}
		return false;
	}

	public Boolean hasPurchasedParticipation(){
		for(EB_Loan_Participation__c participation : m_relatedLoanParticipations)
        {
			if(participation.RecordType.Name == BOUGHT) return true;		
		}
		return false;
	}

	public Boolean hasRealEstateCollateral(){
		for(EB_Collateral__c collateral : m_relatedCollateral)
		{
			if(collateral.Collateral_Code__r.Category__c == REAL_ESTATE) return true;
		}
		return false;
	}
    
    private void Initialize(EB_Loan_Application__c loanApp, LoanAppWrapperHelper.ILoanAppWrapperHelper wrapperHelper){
		m_loanApp = loanApp;
		m_wrapperHelper = wrapperHelper;
	}
    
    private Decimal getLoanAmount(){
		return m_loanApp.Bank_Owned_Loan_Amount__c == null ? 0.0 : m_loanApp.Bank_Owned_Loan_Amount__c;
	}
    
    private Boolean isGuidanceLineLoanType(){
		if(m_loanApp.Loan_Type__c == GUIDANCE_LINE_FIXED) return true;
		if(m_loanApp.Loan_Type__c == GUIDANCE_LINE_REVOLVING) return true;
		return false;
	}
    
    private Decimal getBoughtParticipationAmount(){
		Decimal totalBoughtParticipation = 0.0;
		for(EB_Loan_Participation__c participation : m_relatedLoanParticipations)
        {
			if(participation.RecordType.Name == BOUGHT && participation.Participated_Amount__c != null)
            {
				totalBoughtParticipation += participation.Participated_Amount__c;
			}
		}
		return totalBoughtParticipation;
	}
    
    private Decimal getOriginalLoanAmount(){
		return getLoanAmount() + getBoughtParticipationAmount();
	}

}