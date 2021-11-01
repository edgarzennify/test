public with sharing class AgreementTestWorkflowDataProvider implements IAgreementTestWorkflowDataProvider {
	public interface IAgreementTestWorkflowDataProvider{
		Agreement_Test__c getAgreementTestById(Id agreementTestId);
		void saveAgreementTest(Agreement_Test__c agmtTest);
		Boolean isApprovalRequired(Agreement_Test__c agmtTest);
		Boolean isActionReady(Agreement_Test__c agmtTest);
	}

	public Agreement_Test__c getAgreementTestById(Id agreementTestId){
		return [SELECT
					Id
					,Agreement__c
					,Agreement__r.Name
					,Agreement__r.Borrower_Name__c
					,Test_Type__c
					,Test_Date__c
					,Approval_Process__c
					,Approver_One__c
					,Approver_Two__c
					,Approver_Three__c
					,Needs_Approval__c
					,Action_Ready__c
				FROM
					Agreement_Test__c
				WHERE
					Id =: agreementTestId];
	}

	public void saveAgreementTest(Agreement_Test__c agmtTest){
		update agmtTest;
	}

	public Boolean isApprovalRequired(Agreement_Test__c agmtTest){
		return (agmtTest.Needs_Approval__c == 'Yes') ? true : false;
	}

	public Boolean isActionReady(Agreement_Test__c agmtTest){
		return (agmtTest.Action_Ready__c == 'Yes') ? true : false;
	}
}