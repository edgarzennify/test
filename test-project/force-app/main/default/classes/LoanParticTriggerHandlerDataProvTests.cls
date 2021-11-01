@isTest
private class LoanParticTriggerHandlerDataProvTests {
	
	private static final LoanParticTriggerHandlerDataProv sut;

	static{
		sut = new LoanParticTriggerHandlerDataProv();
	}
	
	private static testMethod void it_should_return_all_associated_loan_app_ids() {
		TestUtilities.createLoanAppStages();
		EB_Loan_Application__c testLoanApp1 = ObjectFactory.getLoanApplication('EntityName', 'EBAccountName', 'EBAccountNumber', 'LoanAppName');
		EB_Loan_Application__c testLoanApp2 = ObjectFactory.getLoanApplication('EntityName', 'EBAccountName', 'EBAccountNumber', 'LoanAppName');
		EB_Loan_Application__c testLoanApp3 = ObjectFactory.getLoanApplication('EntityName', 'EBAccountName', 'EBAccountNumber', 'LoanAppName');
		EB_Loan_Application__c testLoanApp4NotIncluded = ObjectFactory.getLoanApplication('EntityName', 'EBAccountName', 'EBAccountNumber', 'LoanAppName');
		EB_Loan_Participation__c testLoanParticipation1 = new EB_Loan_Participation__c(Loan_Application_ID__c=testLoanApp1.Id,Participated_Amount__c=100,Participating_Institution__c='Test');
		EB_Loan_Participation__c testLoanParticipation2 = new EB_Loan_Participation__c(Loan_Application_ID__c=testLoanApp2.Id,Participated_Amount__c=100,Participating_Institution__c='Test');
		EB_Loan_Participation__c testLoanParticipation2b = new EB_Loan_Participation__c(Loan_Application_ID__c=testLoanApp2.Id,Participated_Amount__c=100,Participating_Institution__c='Test');
		EB_Loan_Participation__c testLoanParticipation3 = new EB_Loan_Participation__c(Loan_Application_ID__c=testLoanApp3.Id,Participated_Amount__c=100,Participating_Institution__c='Test');
		EB_Loan_Participation__c testLoanParticipation4NotIncluded = new EB_Loan_Participation__c(Loan_Application_ID__c=testLoanApp4NotIncluded.Id,Participated_Amount__c=100,Participating_Institution__c='Test');
		List<SObject> participationObjs = new List<SObject>();
		participationObjs.add(testLoanParticipation1);
		participationObjs.add(testLoanParticipation2);
		participationObjs.add(testLoanParticipation2b);
		participationObjs.add(testLoanParticipation3);
		participationObjs.add(testLoanParticipation4NotIncluded);
		//insert testLoanParticipation1;
		//insert testLoanParticipation2;
		//insert testLoanParticipation2b;
		//insert testLoanParticipation3;
		//insert testLoanParticipation4NotIncluded;
		insert participationObjs;
		Set<Id> loanParticIds = new Set<Id> {testLoanParticipation1.Id, testLoanParticipation2.Id, testLoanParticipation2b.Id, testLoanParticipation3.Id};

		Set<Id> returnedLoanAppIds = sut.getRelatedLoanAppIds(loanParticIds);

		System.assertEquals(3, returnedLoanAppIds.size());
		System.assert(returnedLoanAppIds.contains(testLoanApp1.Id));
		System.assert(returnedLoanAppIds.contains(testLoanApp2.Id));
		System.assert(returnedLoanAppIds.contains(testLoanApp3.Id));
	}
	
}