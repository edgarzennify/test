public with sharing class LoanAppHOEPACalculator implements LoanAppHOEPACalculator.ILoanAppHOEPACalculator {
	
	public interface ILoanAppHOEPACalculator{
		Boolean DetermineIfHOEPA(LoanAppWrapper.ILoanAppWrapper loanapp);
	}

    public Boolean DetermineIfHOEPA(LoanAppWrapper.ILoanAppWrapper loanapp)
    {		
		if (loanapp.isHOEPAEligibleLoanType() && !loanapp.isBusinessPurpose() 
			&& loanapp.hasRealEstateCollateral() && !loanapp.isHOEPAPurposeToFinanceInitialConstructionOfPrincipalDwelling())
		{
			return true;
		}
		return false;
	}
}