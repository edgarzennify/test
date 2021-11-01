@IsTest
private class LoanAppCollRelTriggerHandlerTests {
	
	private static final TriggerHandlerTester tester;
	private static final MockofILoanAppCollRelTriggerHandlerDataProv mockDataProv;
	private static final Mock.ofILoanAppComplianceCalculator mockLoanAppComplianceCalculator;
	private static final LoanAppCollRelTriggerHandler sut; 

	static {
		tester = new TriggerHandlerTester();
		mockDataProv = new MockofILoanAppCollRelTriggerHandlerDataProv();
		mockDataProv.setup('getRelatedLoanAppIds', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(new Set<Id>());
		mockLoanAppComplianceCalculator = new Mock.ofILoanAppComplianceCalculator();
		tester.triggerOld = new List<EB_Loan_App_Collateral_Relationship__c>();
		tester.triggerNew = new List<EB_Loan_App_Collateral_Relationship__c>();
		sut = new LoanAppCollRelTriggerHandler(mockDataProv, mockLoanAppComplianceCalculator);
	}

	@IsTest
    static void it_should_call_the_default_constructor_without_error() {
		LoanAppCollRelTriggerHandler sutDef = new LoanAppCollRelTriggerHandler();
	}

	@IsTest
    static void it_should_get_loan_app_ids_for_all_loan_app_collateral_relationships() {
		EB_Loan_App_Collateral_Relationship__c testLoanAppCollatRel1 = new EB_Loan_App_Collateral_Relationship__c(Id=ObjectFactory.getFakeId(EB_Loan_App_Collateral_Relationship__c.SObjectType, '1'));
		EB_Loan_App_Collateral_Relationship__c testLoanAppCollatRel2 = new EB_Loan_App_Collateral_Relationship__c(Id=ObjectFactory.getFakeId(EB_Loan_App_Collateral_Relationship__c.SObjectType, '2'));
		Set<Id> testLoanAppCollatRelIds = new Set<Id> {testLoanAppCollatRel1.Id, testLoanAppCollatRel2.Id};
		tester.triggerOld.add(testLoanAppCollatRel1);
		tester.triggerOld.add(testLoanAppCollatRel2);
		tester.triggerNew.add(testLoanAppCollatRel1);
		tester.triggerNew.add(testLoanAppCollatRel2);

		tester.afterTriggerUpdateSequence(sut);

		mockDataProv.verify('getRelatedLoanAppIds', new List<Object>{testLoanAppCollatRelIds}, Times.Once);
	}

	@IsTest
    static void it_should_send_all_loan_apps_from_after_update_trigger_call_to_have_cra_calculations_performed() {
		EB_Loan_App_Collateral_Relationship__c testLoanAppCollatRel1 = new EB_Loan_App_Collateral_Relationship__c(Id=ObjectFactory.getFakeId(EB_Loan_App_Collateral_Relationship__c.SObjectType, '1'));
		EB_Loan_App_Collateral_Relationship__c testLoanAppCollatRel2 = new EB_Loan_App_Collateral_Relationship__c(Id=ObjectFactory.getFakeId(EB_Loan_App_Collateral_Relationship__c.SObjectType, '2'));
		Set<Id> testLoanAppCollatRelIds = new Set<Id> {testLoanAppCollatRel1.Id, testLoanAppCollatRel2.Id};
		EB_Loan_Application__c testLoanApp1 = new EB_Loan_Application__c(Id=ObjectFactory.getFakeId(EB_Loan_Application__c.SObjectType, '1'));
		EB_Loan_Application__c testLoanApp2 = new EB_Loan_Application__c(Id=ObjectFactory.getFakeId(EB_Loan_Application__c.SObjectType, '2'));	
		Set<Id> testLoanAppIds = new Set<Id> {testLoanApp1.Id, testLoanApp2.Id};
		mockDataProv.setup('getRelatedLoanAppIds', new List<Object>{testLoanAppCollatRelIds}).returns(testLoanAppIds);
		tester.triggerOld.add(testLoanAppCollatRel1);
		tester.triggerOld.add(testLoanAppCollatRel2);
		tester.triggerNew.add(testLoanAppCollatRel1);
		tester.triggerNew.add(testLoanAppCollatRel2);

		tester.afterTriggerUpdateSequence(sut);

		mockLoanAppComplianceCalculator.verify('updateComplianceFieldsForLoanApps', new List<Object>{testLoanAppIds}, Times.Once);
	}

	private class MockofILoanAppCollRelTriggerHandlerDataProv extends ApexMoq implements LoanAppCollRelTriggerHandlerDataProv.ILoanAppCollRelTriggerHandlerDataProv {
		public Set<Id> getRelatedLoanAppIds(Set<Id> collateralRelIds){
			return (Set<Id>)handleMethodInvocation('getRelatedLoanAppIds', new List<Object>{collateralRelIds});
		}
	}	
}