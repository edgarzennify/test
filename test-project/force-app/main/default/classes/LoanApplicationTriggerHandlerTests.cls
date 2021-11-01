@IsTest
private class LoanApplicationTriggerHandlerTests {

	private static final TriggerHandlerTester tester;
	private static final Mock.ofILoanAppComplianceCalculator mockLoanAppComplianceCalculator;
	private static final LoanApplicationTriggerHandler sut; 

	static {
		tester = new TriggerHandlerTester();
		mockLoanAppComplianceCalculator = new Mock.ofILoanAppComplianceCalculator();
		tester.triggerOld = new List<EB_Loan_Application__c>();
		tester.triggerNew = new List<EB_Loan_Application__c>();
		sut = new LoanApplicationTriggerHandler(mockLoanAppComplianceCalculator);
	}

	@IsTest
    static void it_should_call_the_default_constructor_without_error() {
		LoanApplicationTriggerHandler sutDef = new LoanApplicationTriggerHandler();
	}

	@IsTest
    static void it_should_send_all_loan_apps_from_after_insert_trigger_call_to_have_cra_calculations_performed() {
		EB_Loan_Application__c testLoanApp1 = new EB_Loan_Application__c(Id=ObjectFactory.getFakeId(EB_Loan_Application__c.SObjectType, '1'));
		EB_Loan_Application__c testLoanApp2 = new EB_Loan_Application__c(Id=ObjectFactory.getFakeId(EB_Loan_Application__c.SObjectType, '2'));	
		EB_Loan_Application__c testLoanApp3 = new EB_Loan_Application__c(Id=ObjectFactory.getFakeId(EB_Loan_Application__c.SObjectType, '3'));
		Set<Id> testLoanAppIds = new Set<Id> {testLoanApp1.Id, testLoanApp2.Id, testLoanApp3.Id};
		tester.triggerNew.add(testLoanApp1);
		tester.triggerNew.add(testLoanApp2);
		tester.triggerNew.add(testLoanApp3);

		tester.afterTriggerInsertSequence(sut);

		mockLoanAppComplianceCalculator.verify('updateComplianceFieldsForLoanApps', new List<Object>{testLoanAppIds}, Times.Once);
	}

	@IsTest
    static void it_should_send_all_loan_apps_from_after_update_trigger_call_to_have_cra_calculations_performed() {
		EB_Loan_Application__c testLoanApp1 = new EB_Loan_Application__c(Id=ObjectFactory.getFakeId(EB_Loan_Application__c.SObjectType, '1'));
		EB_Loan_Application__c testLoanApp2 = new EB_Loan_Application__c(Id=ObjectFactory.getFakeId(EB_Loan_Application__c.SObjectType, '2'));	
		EB_Loan_Application__c testLoanApp3 = new EB_Loan_Application__c(Id=ObjectFactory.getFakeId(EB_Loan_Application__c.SObjectType, '3'));
		Set<Id> testLoanAppIds = new Set<Id> {testLoanApp1.Id, testLoanApp2.Id, testLoanApp3.Id};
		tester.triggerOld.add(testLoanApp1);
		tester.triggerOld.add(testLoanApp2);
		tester.triggerOld.add(testLoanApp3);
		tester.triggerNew.add(testLoanApp1);
		tester.triggerNew.add(testLoanApp2);
		tester.triggerNew.add(testLoanApp3);

		tester.afterTriggerUpdateSequence(sut);

		mockLoanAppComplianceCalculator.verify('updateComplianceFieldsForLoanApps', new List<Object>{testLoanAppIds}, Times.Once);
	}
}