@isTest
private class LoanAppWrapperBuilderTests {

	private static final LoanAppWrapperBuilder sut;

	static
	{
		sut = new LoanAppWrapperBuilder();
	}	

	private static testMethod void it_should_return_a_loan_app_wrapper_built_from_loan_app() {
		EB_Loan_Application__c loanApp = new EB_Loan_Application__c(Id=ObjectFactory.getFakeId(EB_Loan_Application__c.SObjectType, '1'));

		LoanAppWrapper loanAppWrapper = sut.getLoanAppWrapperForLoanApp(loanApp);

		System.assertNotEquals(null, loanAppWrapper);
	}


}