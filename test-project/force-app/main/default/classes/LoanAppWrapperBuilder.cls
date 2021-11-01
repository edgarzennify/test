public with sharing class LoanAppWrapperBuilder implements ILoanAppWrapperBuilder {

	public interface ILoanAppWrapperBuilder{
		LoanAppWrapper getLoanAppWrapperForLoanApp(EB_Loan_Application__c loanApp);
	}

	public LoanAppWrapper getLoanAppWrapperForLoanApp(EB_Loan_Application__c loanApp){
		return new LoanAppWrapper(loanApp);
	}
}