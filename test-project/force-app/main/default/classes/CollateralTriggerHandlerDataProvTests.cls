@isTest
private class CollateralTriggerHandlerDataProvTests {
	
	private static final CollateralTriggerHandlerDataProv sut;

	static{
		sut = new CollateralTriggerHandlerDataProv();
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
		EB_Loan_Application__c testLoanApp3 = ObjectFactory.getLoanApplication('EntityName', 'EBAccountName', 'EBAccountNumber', 'LoanAppName');
		EB_Loan_App_Collateral_Relationship__c testLoanAppCollatRel4 = ObjectFactory.relateCollateralToLoanAppObj(testCollateral3, testLoanApp3, relationshipTypeRecordId);
		EB_Collateral__c testCollateral4 = ObjectFactory.getCollateral('collat Desc4', testCollateralCode, false);
		EB_Loan_Application__c testLoanApp4NotIncluded = ObjectFactory.getLoanApplication('EntityName', 'EBAccountName', 'EBAccountNumber', 'LoanAppName');
		EB_Loan_App_Collateral_Relationship__c testLoanAppCollatRel5NotIncluded = ObjectFactory.relateCollateralToLoanAppObj(testCollateral4, testLoanApp4NotIncluded, relationshipTypeRecordId);
		Set<Id> loanAppCollIds = new Set<Id> {testCollateral.Id, testCollateral2.Id, testCollateral3.Id};

		Set<Id> returnedLoanAppIds = sut.getRelatedLoanAppIds(loanAppCollIds);

		System.assertEquals(3, returnedLoanAppIds.size());
		System.assert(returnedLoanAppIds.contains(testLoanApp.Id));
		System.assert(returnedLoanAppIds.contains(testLoanApp2.Id));
		System.assert(returnedLoanAppIds.contains(testLoanApp3.Id));
	}
	
}