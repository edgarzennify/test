@isTest
private class LoanAppWrapperHelperTests {
	
	private static final EB_Loan_Application__c testLoanApp;
	private static final EB_Collateral__c testCollateral1;
	private static final EB_Collateral__c testCollateral2;
	private static final EB_Loan_App_Collateral_Relationship__c testLoanAppCollatRel1;
	private static final EB_Loan_App_Collateral_Relationship__c testLoanAppCollatRel2;
	private static final LoanAppWrapperHelper sut;

	static{
		TestUtilities.createLoanAppStages();
		Collateral_Code__c testCollateralCode = ObjectFactory.getCollateralCode('testcollat', '123');
		testCollateral1 = ObjectFactory.getCollateral('collat Desc', testCollateralCode, false);
		testCollateral2 = ObjectFactory.getCollateral('collat Desc2', testCollateralCode, false);
		testLoanApp = ObjectFactory.getLoanApplication('EntityName', 'EBAccountName', 'EBAccountNumber', 'LoanAppName');
		Id relationshipTypeRecordId = ObjectFactory.getRecordTypeIdByNameAndObject('All', 'EB_Loan_App_Collateral_Relationship__c');
		testLoanAppCollatRel1 = ObjectFactory.relateCollateralToLoanAppObj(testCollateral1, testLoanApp, relationshipTypeRecordId);
		testLoanAppCollatRel2 = ObjectFactory.relateCollateralToLoanAppObj(testCollateral2, testLoanApp, relationshipTypeRecordId);
		sut = new LoanAppWrapperHelper();
	}

	private static testMethod void it_should_return_all_collateral_relationships() {
		EB_Loan_Application__c	loanAppFromSOQL = [SELECT Id, (SELECT Id FROM EB_Loan_App_Collateral_Relationships__r) 
														FROM EB_Loan_Application__c WHERE Id = : testLoanApp.Id];

		List<EB_Loan_App_Collateral_Relationship__c> collRelationships = sut.getLoanAppToCollateralRelationships(loanAppFromSOQL);

		Boolean wasCollatRel1Found = false;
		Boolean wasCollatRel2Found = false;
		for(EB_Loan_App_Collateral_Relationship__c collRel : collRelationships){
			if(collRel.Id == testLoanAppCollatRel1.Id){
				wasCollatRel1Found = true;
			}
			if(collRel.Id == testLoanAppCollatRel2.Id){
				wasCollatRel2Found = true;
			}
		}
		System.assertEquals(true, wasCollatRel1Found);
		System.assertEquals(true, wasCollatRel2Found);
	}

	private static testMethod void it_should_return_all_related_collateral() {
		EB_Loan_Application__c	loanAppFromSOQL = [SELECT Id, (SELECT Id, EB_Collateral_ID__c, EB_Collateral_ID__r.Collateral_Code__c FROM EB_Loan_App_Collateral_Relationships__r) 
													FROM EB_Loan_Application__c WHERE Id = : testLoanApp.Id];

		List<EB_Collateral__c> collateralFromDB = sut.getRelatedCollateralsForLoanApp(loanAppFromSOQL);
	
		Boolean wasCollat1Found = false;
		Boolean wasCollat2Found = false;
		for(EB_Collateral__c coll : collateralFromDB){
			if(coll.Id == testCollateral1.Id){
				wasCollat1Found = true;
			}
			if(coll.Id == testCollateral2.Id){
				wasCollat2Found = true;
			}
		}
		System.assertEquals(true, wasCollat1Found);
		System.assertEquals(true, wasCollat2Found);
	}

	private static testMethod void it_should_return_all_related_loan_participations() {
		Id boughtRecordTypeId = Utility.recordTypeObject('EB_Loan_Participation__c', 'Bought').Id;
		EB_Loan_Participation__c partic1 = new EB_Loan_Participation__c(Loan_Application_ID__c = testLoanApp.Id, RecordTypeId = boughtRecordTypeId, Participating_Institution__c = 'inst', Participated_Amount__c = 1);
		EB_Loan_Participation__c partic2 = new EB_Loan_Participation__c(Loan_Application_ID__c = testLoanApp.Id, RecordTypeId = boughtRecordTypeId, Participating_Institution__c = 'inst', Participated_Amount__c = 1);
		insert partic1;
		insert partic2;
		EB_Loan_Application__c	loanAppFromSOQL = [SELECT Id, (SELECT Id FROM EB_Loan_Participations__r) 
													FROM EB_Loan_Application__c WHERE Id = : testLoanApp.Id];

		List<EB_Loan_Participation__c> loanParticipations = sut.getRelatedLoanParticipationsForLoanApp(loanAppFromSOQL);
	
		Boolean wasLoanPartic1Found = false;
		Boolean wasLoanPartic2Found = false;
		for(EB_Loan_Participation__c collRel : loanParticipations){
			if(collRel.Id == partic1.Id){
				wasLoanPartic1Found = true;
			}
			if(collRel.Id == partic2.Id){
				wasLoanPartic2Found = true;
			}
		}
		System.assertEquals(true, wasLoanPartic1Found);
		System.assertEquals(true, wasLoanPartic2Found);
	}

	private static testMethod void it_should_not_add_collateral_from_relationships_that_have_no_collateral() {
	
		testLoanAppCollatRel2.EB_Collateral_ID__c = null;
		update testLoanAppCollatRel2;
		EB_Loan_Application__c	loanAppFromSOQL = [SELECT Id, (SELECT Id, EB_Collateral_ID__c, EB_Collateral_ID__r.Collateral_Code__c FROM EB_Loan_App_Collateral_Relationships__r) 
													FROM EB_Loan_Application__c WHERE Id = : testLoanApp.Id];

		List<EB_Collateral__c> collateralFromDB = sut.getRelatedCollateralsForLoanApp(loanAppFromSOQL);
	
		System.assertEquals(1, collateralFromDB.size());
		Boolean wasCollat1Found = false;
		Boolean wasCollat2Found = false;
		for(EB_Collateral__c coll : collateralFromDB){
			if(coll.Id == testCollateral1.Id){
				wasCollat1Found = true;
			}
			if(coll.Id == testCollateral2.Id){
				wasCollat2Found = true;
			}
		}
		System.assertEquals(true, wasCollat1Found);
		System.assertEquals(false, wasCollat2Found);
	}
	
}