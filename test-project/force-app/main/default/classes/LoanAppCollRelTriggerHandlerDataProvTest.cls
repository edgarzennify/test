@isTest
private class LoanAppCollRelTriggerHandlerDataProvTest {

	private static final LoanAppCollRelTriggerHandlerDataProv sut;

	static{
		sut = new LoanAppCollRelTriggerHandlerDataProv();
	}
	
	private static testMethod void it_should_return_all_associated_loan_app_ids() {
		TestUtilities.createLoanAppStages();
		Collateral_Code__c testCollateralCode = ObjectFactory.getCollateralCode('testcollat', '123');
		EB_Collateral__c testCollateral = ObjectFactory.getCollateral('collat Desc', testCollateralCode, false);
		EB_Loan_Application__c testLoanApp = ObjectFactory.getLoanApplication('EntityName', 'EBAccountName', 'EBAccountNumber', 'LoanAppName');
		Id relationshipTypeRecordId = ObjectFactory.getRecordTypeIdByNameAndObject('All', 'EB_Loan_App_Collateral_Relationship__c');
		EB_Loan_App_Collateral_Relationship__c testLoanAppCollatRel1 = ObjectFactory.relateCollateralToLoanAppObj(testCollateral, testLoanApp, relationshipTypeRecordId);
		EB_Collateral__c testCollateral2 = ObjectFactory.getCollateral('collat Desc2', testCollateralCode, false);
		EB_Loan_App_Collateral_Relationship__c testLoanAppCollatRel2 = ObjectFactory.relateCollateralToLoanAppObj(testCollateral2, testLoanApp, relationshipTypeRecordId);
		EB_Collateral__c testCollateral3 = ObjectFactory.getCollateral('collat Desc3', testCollateralCode, false);
		EB_Loan_Application__c testLoanApp2 = ObjectFactory.getLoanApplication('EntityName', 'EBAccountName', 'EBAccountNumber', 'LoanAppName');
		EB_Loan_App_Collateral_Relationship__c testLoanAppCollatRel3 = ObjectFactory.relateCollateralToLoanAppObj(testCollateral3, testLoanApp2, relationshipTypeRecordId);
		EB_Loan_Application__c testLoanApp3NotIncluded = ObjectFactory.getLoanApplication('EntityName', 'EBAccountName', 'EBAccountNumber', 'LoanAppName');
		EB_Loan_App_Collateral_Relationship__c testLoanAppCollatRel4NotIncluded = ObjectFactory.relateCollateralToLoanAppObj(testCollateral3, testLoanApp3NotIncluded, relationshipTypeRecordId);
		Set<Id> loanAppCollRelIds = new Set<Id> {testLoanAppCollatRel1.Id, testLoanAppCollatRel2.Id, testLoanAppCollatRel3.Id};

		Set<Id> returnedLoanAppIds = sut.getRelatedLoanAppIds(loanAppCollRelIds);

		System.assertEquals(2, returnedLoanAppIds.size());
		System.assert(returnedLoanAppIds.contains(testLoanApp.Id));
		System.assert(returnedLoanAppIds.contains(testLoanApp2.Id));
	}
	
}