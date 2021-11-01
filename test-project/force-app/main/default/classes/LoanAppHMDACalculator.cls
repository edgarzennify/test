public with sharing class LoanAppHMDACalculator implements LoanAppHMDACalculator.ILoanAppHMDACalculator {
	
	public interface ILoanAppHMDACalculator{
		Boolean DetermineIfHMDA(LoanAppWrapper.ILoanAppWrapper loanapp);
	}

    public Boolean DetermineIfHMDA(LoanAppWrapper.ILoanAppWrapper loanapp)
    {
		if (!loanapp.isHMDAEligibleLoanType())  return false;
		if (loanapp.isHomeImprovement())  return true;
		if (loanapp.isResidentialRehab()) return true; 
		if (loanapp.isPurchaseResidentialRealEstate() && loanapp.hasDwellingCollateral()) return true;
		if (loanapp.isRefinanceResidentialRealEstate() && loanapp.isRefinanceToPayoffExistingDebtBySameBorrower()) return true;
		return false;
	}
}