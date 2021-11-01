@IsTest
private class LoanParticTriggerHandlerTests {
	
	private static final TriggerHandlerTester tester;
	private static final MockofILoanParticTriggerHandlerDataProv mockDataProv;
	private static final Mock.ofILoanAppComplianceCalculator mockLoanAppComplianceCalculator;
	private static final LoanParticTriggerHandler sut; 

	static {
		tester = new TriggerHandlerTester();
		mockDataProv = new MockofILoanParticTriggerHandlerDataProv();
		mockDataProv.setup('getRelatedLoanAppIds', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(new Set<Id>());
		mockLoanAppComplianceCalculator = new Mock.ofILoanAppComplianceCalculator();
		sut = new LoanParticTriggerHandler(mockDataProv, mockLoanAppComplianceCalculator);
	}

	@IsTest
    static void it_should_call_the_default_constructor_without_error() {
		LoanParticTriggerHandler sutDef = new LoanParticTriggerHandler();
	}

	@IsTest
    static void it_should_get_loan_app_ids_for_all_participations() {
		EB_Loan_Participation__c testParticipation = new EB_Loan_Participation__c(Id=ObjectFactory.getFakeId(EB_Loan_Participation__c.SObjectType, '1'));
		EB_Loan_Participation__c testParticipation2 = new EB_Loan_Participation__c(Id=ObjectFactory.getFakeId(EB_Loan_Participation__c.SObjectType, '2'));
		Set<Id> testParticipationIds = new Set<Id> {testParticipation.Id, testParticipation2.Id};
		tester.triggerOld.add(testParticipation);
		tester.triggerOld.add(testParticipation2);
		tester.triggerNew.add(testParticipation);
		tester.triggerNew.add(testParticipation2);

		tester.afterTriggerUpdateSequence(sut);

		mockDataProv.verify('getRelatedLoanAppIds', new List<Object>{testParticipationIds}, Times.Once);
	}

	@IsTest
    static void it_should_send_all_loan_apps_from_after_update_trigger_call_to_have_cra_calculations_performed() {
		EB_Loan_Participation__c testParticipation = new EB_Loan_Participation__c(Id=ObjectFactory.getFakeId(EB_Loan_Participation__c.SObjectType, '1'));
		EB_Loan_Participation__c testParticipation2 = new EB_Loan_Participation__c(Id=ObjectFactory.getFakeId(EB_Loan_Participation__c.SObjectType, '2'));
		Set<Id> testParticipationIds = new Set<Id> {testParticipation.Id, testParticipation2.Id};
		EB_Loan_Application__c testLoanApp1 = new EB_Loan_Application__c(Id=ObjectFactory.getFakeId(EB_Loan_Application__c.SObjectType, '1'));
		EB_Loan_Application__c testLoanApp2 = new EB_Loan_Application__c(Id=ObjectFactory.getFakeId(EB_Loan_Application__c.SObjectType, '2'));	
		Set<Id> testLoanAppIds = new Set<Id> {testLoanApp1.Id, testLoanApp2.Id};
		mockDataProv.setup('getRelatedLoanAppIds', new List<Object>{testParticipationIds}).returns(testLoanAppIds);
		tester.triggerOld.add(testParticipation);
		tester.triggerOld.add(testParticipation2);
		tester.triggerNew.add(testParticipation);
		tester.triggerNew.add(testParticipation2);

		tester.afterTriggerUpdateSequence(sut);

		mockLoanAppComplianceCalculator.verify('updateComplianceFieldsForLoanApps', new List<Object>{testLoanAppIds}, Times.Once);
	}

	private class MockofILoanParticTriggerHandlerDataProv extends ApexMoq implements LoanParticTriggerHandlerDataProv.ILoanParticTriggerHandlerDataProv {
		public Set<Id> getRelatedLoanAppIds(Set<Id> loanParticIds){
			return (Set<Id>)handleMethodInvocation('getRelatedLoanAppIds', new List<Object>{loanParticIds});
		}
	}
}