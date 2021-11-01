public with sharing class LoanAppWrapperHelper implements LoanAppWrapperHelper.ILoanAppWrapperHelper {

	public interface ILoanAppWrapperHelper{
		List<EB_Loan_App_Collateral_Relationship__c> getLoanAppToCollateralRelationships(EB_Loan_Application__c loanapp);
		List<EB_Collateral__c> getRelatedCollateralsForLoanApp(EB_Loan_Application__c loanapp);
		List<EB_Loan_Participation__c> getRelatedLoanParticipationsForLoanApp(EB_Loan_Application__c loanapp);
	}

	public List<EB_Loan_App_Collateral_Relationship__c> getLoanAppToCollateralRelationships(EB_Loan_Application__c loanapp){
		return (loanapp.EB_Loan_App_Collateral_Relationships__r != null) ? loanapp.EB_Loan_App_Collateral_Relationships__r : new List<EB_Loan_App_Collateral_Relationship__c>();
	}

	public List<EB_Collateral__c> getRelatedCollateralsForLoanApp(EB_Loan_Application__c loanapp){
		List<EB_Collateral__c> relatedCollaterals = new List<EB_Collateral__c>();
  		for(EB_Loan_App_Collateral_Relationship__c collateralRel : loanapp.EB_Loan_App_Collateral_Relationships__r){
  			if(collateralRel.EB_Collateral_ID__r != null){
  				relatedCollaterals.add(collateralRel.EB_Collateral_ID__r);
	  		}
  		}
  		return relatedCollaterals;
	}

	public List<EB_Loan_Participation__c> getRelatedLoanParticipationsForLoanApp(EB_Loan_Application__c loanapp){
		return (loanapp.EB_Loan_Participations__r != null) ? loanapp.EB_Loan_Participations__r : new List<EB_Loan_Participation__c>();
	}

}