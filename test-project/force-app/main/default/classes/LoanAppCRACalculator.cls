public class LoanAppCRACalculator implements LoanAppCRACalculator.ILoanAppCRACalculator {
	
	public interface ILoanAppCRACalculator{
		Boolean DetermineIfCRA(LoanAppWrapper.ILoanAppWrapper loanapp);
	}

    public Boolean DetermineIfCRA(LoanAppWrapper.ILoanAppWrapper loanapp)
    {
    	if (CRA_Eligible_Case_1(loanapp)) return true;
    	if (CRA_Eligible_Case_2(loanapp)) return true;
    	if (CRA_Eligible_Case_3(loanapp)) return true;
    	if (CRA_Eligible_Case_4(loanapp)) return true;
    	if (CRA_Eligible_Case_5(loanapp)) return true;
    	if (CRA_Eligible_Case_6(loanapp)) return true;
    	if (CRA_Eligible_Case_7(loanapp)) return true;
    	if (CRA_Eligible_Case_8(loanapp)) return true;
    	return false;
    }

	private Boolean CRA_Eligible_Case_1(LoanAppWrapper.ILoanAppWrapper loanapp)
	{
		return loanapp.isCRAEligibleLoanType() && loanapp.isCRAEligibleRecordType() && loanapp.hasCRAEligibleCollateral() &&
            !loanapp.isModificationWithoutIncreasedLoanAmount() && loanapp.isAgriculturalPurpose() && 
            !loanapp.isLoanAmountOver500K() && !loanapp.hasPurchasedParticipation();
	}

	private Boolean CRA_Eligible_Case_2(LoanAppWrapper.ILoanAppWrapper loanapp) // CRA_Elig_AgriPurpose_TRUE_AmtOver500k_FALSE_purchasedPart_TRUE_OrigAmtOver500K_FALSE_Case_2
	{
		return loanapp.isCRAEligibleLoanType() && loanapp.isCRAEligibleRecordType() && loanapp.hasCRAEligibleCollateral() &&
            !loanapp.isModificationWithoutIncreasedLoanAmount() && loanapp.isAgriculturalPurpose() && 
            !loanapp.isloanAmountOver500K() && loanapp.hasPurchasedParticipation() && 
            !loanapp.isOriginalLoanAmountOver500K() ;
	}

	private Boolean CRA_Eligible_Case_3(LoanAppWrapper.ILoanAppWrapper loanapp) // CRA_Elig_AgriPurpose_FALSE_BusPurpose_TRUE_AmtOver1M_FALSE_purchasedPart_TRUE_OrigOver1M_FALSE_LtOfCredit_FALSE_hasRelEstColl_FALSE_Security_TRUE_Case_3
	{
		return loanapp.isCRAEligibleLoanType() && loanapp.isCRAEligibleRecordType() && loanapp.hasCRAEligibleCollateral() &&
            !loanapp.isModificationWithoutIncreasedLoanAmount() && !loanapp.isAgriculturalPurpose() && 
            loanapp.isBusinessPurpose() && !loanapp.isloanAmountOver1M() && loanapp.hasPurchasedParticipation() && 
            !loanapp.isOriginalLoanAmountOVer1M() && !loanapp.isLetterOfCredit() 
			&& !loanapp.hasRealEstateCollateral() && !loanapp.isPurposeOfLoanToBuySecurities();
	}

	private Boolean CRA_Eligible_Case_4(LoanAppWrapper.ILoanAppWrapper loanapp) // CRA_Elig_AgriPurpose_FALSE_BusPurpose_TRUE_AmtOver1M_FALSE_purchasedPart_FALSE_LtOfCredit_FALSE_hasRelEstColl_FALSE_Security_FALSE_Case_4
	{
		return loanapp.isCRAEligibleLoanType() && loanapp.isCRAEligibleRecordType() && loanapp.hasCRAEligibleCollateral() &&
            !loanapp.isModificationWithoutIncreasedLoanAmount() && !loanapp.isAgriculturalPurpose() && 
            loanapp.isBusinessPurpose() && !loanapp.isloanAmountOver1M() && !loanapp.hasPurchasedParticipation() &&
            !loanapp.isLetterOfCredit() && !loanapp.hasRealEstateCollateral() 
			&& !loanapp.isPurposeOfLoanToBuySecurities();
	}

	private Boolean CRA_Eligible_Case_5(LoanAppWrapper.ILoanAppWrapper loanapp) // CRA_Elig_AgriPurpose_FALSE_BusPurpose_TRUE_AmtOver1M_FALSE_purchasedPart_TRUE_OrigOver1M_FALSE_LtOfCredit_FALSE_hasRelEstColl_TRUE_Construction_FALSE_NonCommercial_FALSE_Case_5
	{
		return loanapp.isCRAEligibleLoanType() && loanapp.isCRAEligibleRecordType() && loanapp.hasCRAEligibleCollateral() &&
            !loanapp.isModificationWithoutIncreasedLoanAmount() && !loanapp.isAgriculturalPurpose() && 
            loanapp.isBusinessPurpose() && !loanapp.isloanAmountOver1M() && loanapp.hasPurchasedParticipation() && 
            !loanapp.isOriginalLoanAmountOVer1M() && !loanapp.isLetterOfCredit() && loanapp.hasRealEstateCollateral() && 
            !loanapp.isConstructionLandDevelopment() && !loanapp.hasNonCommercialRealEstateCollateral(); 
	}

	private Boolean CRA_Eligible_Case_6(LoanAppWrapper.ILoanAppWrapper loanapp) // CRA_Elig_AgriPurpose_FALSE_BusPurpose_TRUE_AmtOver1M_FALSE_purchasedPart_FALSE_LtOfCredit_FALSE_hasRelEstColl_TRUE_Construction_FALSE_NonCommercial_FALSE_Case_6
	{
		return loanapp.isCRAEligibleLoanType() && loanapp.isCRAEligibleRecordType() && loanapp.hasCRAEligibleCollateral() &&
            !loanapp.isModificationWithoutIncreasedLoanAmount() && !loanapp.isAgriculturalPurpose() && 
            loanapp.isBusinessPurpose() && !loanapp.isloanAmountOver1M() && !loanapp.hasPurchasedParticipation() && 
            !loanapp.isLetterOfCredit() && loanapp.hasRealEstateCollateral() && !loanapp.isConstructionLandDevelopment() && 
            !loanapp.hasNonCommercialRealEstateCollateral(); 
	}	

	private Boolean CRA_Eligible_Case_7(LoanAppWrapper.ILoanAppWrapper loanapp) // CRA_Elig__AgriPurpose_FALSE_BusPurpose_TRUE_AmtOver1M_FALSE_purchasedPart_FALSE_LtOfCredit_FALSE_HasRelEstColl_TRUE_Contruction_FALSE_NonCommercial_TRUE_Case_RElAbundance_TRUE_Case_7
	{
		return loanapp.isCRAEligibleLoanType() && loanapp.isCRAEligibleRecordType() && loanapp.hasCRAEligibleCollateral() &&
            !loanapp.isModificationWithoutIncreasedLoanAmount() && !loanapp.isAgriculturalPurpose() && 
            loanapp.isBusinessPurpose() && !loanapp.isloanAmountOver1M() && !loanapp.hasPurchasedParticipation() && 
            !loanapp.isLetterOfCredit() && loanapp.hasRealEstateCollateral() && !loanapp.isConstructionLandDevelopment() && 
            loanapp.hasNonCommercialRealEstateCollateral() && loanapp.isAllResidentialRealEstateCollateralTakenAsAbundanceOfCaution();
	}

	private Boolean CRA_Eligible_Case_8(LoanAppWrapper.ILoanAppWrapper loanapp) // CRA_Elig__AgriPurpose_FALSE_BusPurpose_TRUE_AmtOver1M_FALSE_purchasedPart_TRUE_OrigAmtOver1M_FALSE_LtOfCredit_FALSE_HasRelEstColl_TRUE_Contruction_FALSE_NonCommercial_TRUE_Case_RElAbundance_TRUE_Case_8
	{
		return loanapp.isCRAEligibleLoanType() && loanapp.isCRAEligibleRecordType() && loanapp.hasCRAEligibleCollateral() &&
            !loanapp.isModificationWithoutIncreasedLoanAmount() && !loanapp.isAgriculturalPurpose() && 
            loanapp.isBusinessPurpose() && !loanapp.isloanAmountOver1M() && loanapp.hasPurchasedParticipation() && 
            !loanapp.isOriginalLoanAmountOVer1M() && !loanapp.isLetterOfCredit() && loanapp.hasRealEstateCollateral() && 
            !loanapp.isConstructionLandDevelopment() && loanapp.hasNonCommercialRealEstateCollateral() && 
            loanapp.isAllResidentialRealEstateCollateralTakenAsAbundanceOfCaution();
	}

}