@isTest
private class LoanAppComplianceCalculatorDataProvTests {
	
	private static final LoanAppComplianceCalculatorDataProv sut = new LoanAppComplianceCalculatorDataProv();

	private static testMethod void it_should_get_the_loan_apps_for_given_ids() {
		TestUtilities.createLoanAppStages();
		EB_Loan_Application__c testApp1 = ObjectFactory.getLoanApplication('EntityName1', 'EBAccountName1', 'EBAccountNumber1', 'LoanAppName1');
		EB_Loan_Application__c testApp2 = ObjectFactory.getLoanApplication('EntityName2', 'EBAccountName2', 'EBAccountNumber2', 'LoanAppName2');
		Collateral_Code__c testCollCode1 = ObjectFactory.getCollateralCode('Home Equity Line', '70');
		Collateral_Code__c testCollCode2 = ObjectFactory.getCollateralCode('Single Family Residential', '50');
		Collateral_Code__c testCollCode3 = ObjectFactory.getCollateralCode('Other', '99');
		EB_Collateral__c testCollateral1 = ObjectFactory.getCollateral('Test Coll 1',testCollCode1,false);
		EB_Collateral__c testCollateral2 = ObjectFactory.getCollateral('Test Coll 2',testCollCode2,false);
		EB_Collateral__c testCollateral3 = ObjectFactory.getCollateral('Test Coll 3',testCollCode3,false);
		Id recordTypeId = Utility.recordTypeObject('EB_Loan_App_Collateral_Relationship__c', 'All').Id;
		ObjectFactory.relateCollateralToLoanApp(testCollateral1, testApp1, recordTypeId);
		ObjectFactory.relateCollateralToLoanApp(testCollateral2, testApp1, recordTypeId);
		ObjectFactory.relateCollateralToLoanApp(testCollateral1, testApp2, recordTypeId);
		ObjectFactory.relateCollateralToLoanApp(testCollateral3, testApp2, recordTypeId);
		Id boughtRecordTypeId = Utility.recordTypeObject('EB_Loan_Participation__c', 'Bought').Id;
		EB_Loan_Participation__c partic1 = new EB_Loan_Participation__c(Loan_Application_ID__c = testApp1.Id, RecordTypeId = boughtRecordTypeId, Participating_Institution__c = 'inst', Participated_Amount__c = 1);
		EB_Loan_Participation__c partic2a = new EB_Loan_Participation__c(Loan_Application_ID__c = testApp2.Id, RecordTypeId = boughtRecordTypeId, Participating_Institution__c = 'inst', Participated_Amount__c = 1);
		EB_Loan_Participation__c partic2b = new EB_Loan_Participation__c(Loan_Application_ID__c = testApp2.Id, RecordTypeId = boughtRecordTypeId, Participating_Institution__c = 'inst', Participated_Amount__c = 1);
		List<SObject> participationObjs = new List<SObject>();
		participationObjs.add(partic1);
		participationObjs.add(partic2a);
		participationObjs.add(partic2b);
		insert participationObjs;
		//insert partic1;
		//insert partic2a;
		//insert partic2b;
		Set<Id> loanAppIds = new Set<Id>{testApp1.Id, testApp2.Id};

		List<EB_Loan_Application__c> returnedLoanApps = sut.getLoanApplicationsByIds(loanAppIds);

		System.assertEquals(2, returnedLoanApps.size());
		EB_Loan_Application__c testApp1FromQuery;
        EB_Loan_Application__c testApp2FromQuery;
        for(EB_Loan_Application__c loanapp : returnedLoanApps){
        	if(loanapp.Id == testApp1.Id){
        		testApp1FromQuery = loanapp;
        	}
        	if(loanapp.Id == testApp2.Id){
        		testApp2FromQuery = loanapp;
        	}
        }
        System.assertEquals(2, testApp1FromQuery.EB_Loan_App_Collateral_Relationships__r.size());
        System.assertEquals(2, testApp2FromQuery.EB_Loan_App_Collateral_Relationships__r.size());
        System.assertEquals(1, testApp1FromQuery.EB_Loan_Participations__r.size());
        System.assertEquals(2, testApp2FromQuery.EB_Loan_Participations__r.size());
	}


	private static testMethod void it_should_return_expected_fields_in_SOQL_for_getLoanApplicationsByIds() {
		TestUtilities.createLoanAppStages();
		EB_Loan_Application__c testApp1 = ObjectFactory.getLoanApplication('EntityName', 'EBAccountName', 'EBAccountNumber', 'LoanAppName');
		Collateral_Code__c testCollCode1 = ObjectFactory.getCollateralCode('Home Equity Line', '70');
		EB_Collateral__c testCollateral1 = ObjectFactory.getCollateral('Test Coll 1',testCollCode1,false);
		Id recordTypeId = Utility.recordTypeObject('EB_Loan_App_Collateral_Relationship__c', 'All').Id;
		ObjectFactory.relateCollateralToLoanApp(testCollateral1, testApp1, recordTypeId);
		Id boughtRecordTypeId = Utility.recordTypeObject('EB_Loan_Participation__c', 'Bought').Id;
		EB_Loan_Participation__c partic1 = new EB_Loan_Participation__c(Loan_Application_ID__c = testApp1.Id, RecordTypeId = boughtRecordTypeId, Participating_Institution__c = 'inst', Participated_Amount__c = 1);
		insert partic1;
		Set<Id> loanAppIds = new Set<Id>{testApp1.Id};

		List<EB_Loan_Application__c> returnResult = sut.getLoanApplicationsByIds(loanAppIds);
		Object wasFieldInSOQL;
		wasFieldInSOQL = returnResult[0].Id;
		wasFieldInSOQL = returnResult[0].IsHMDAAsDeterminedByTrigger__c;
		wasFieldInSOQL = returnResult[0].IsHOEPAAsDeterminedByTrigger__c;
		wasFieldInSOQL = returnResult[0].IsCRAAsDeterminedByTrigger__c;
		wasFieldInSOQL = returnResult[0].Bank_Owned_Loan_Amount__c;
		wasFieldInSOQL = returnResult[0].Business_Purpose__c;
		wasFieldInSOQL = returnResult[0].HOEPA_Finance_Purchase_Or_Construction__c;
		wasFieldInSOQL = returnResult[0].Loan_Type__c;
		wasFieldInSOQL = returnResult[0].Refinance_Type__c;
		wasFieldInSOQL = returnResult[0].Use_of_Funds__c;
		wasFieldInSOQL = returnResult[0].EB_Loan_App_Collateral_Relationships__r[0].Id;
		wasFieldInSOQL = returnResult[0].EB_Loan_App_Collateral_Relationships__r[0].EB_Collateral_ID__c;
		wasFieldInSOQL = returnResult[0].EB_Loan_App_Collateral_Relationships__r[0].EB_Loan_Application_ID__c;
		wasFieldInSOQL = returnResult[0].EB_Loan_App_Collateral_Relationships__r[0].EB_Collateral_ID__r.Collateral_Code__r.CRA_Real_Estate_Details__c;
		wasFieldInSOQL = returnResult[0].EB_Loan_App_Collateral_Relationships__r[0].EB_Collateral_ID__r.Collateral_Code__r.Category__c;
		wasFieldInSOQL = returnResult[0].EB_Loan_App_Collateral_Relationships__r[0].EB_Collateral_ID__r.Collateral_Code__r.IsHMDADwelling__c;
		wasFieldInSOQL = returnResult[0].EB_Loan_Participations__r[0].Id;
		wasFieldInSOQL = returnResult[0].EB_Loan_Participations__r[0].RecordType.Name;
		wasFieldInSOQL = returnResult[0].EB_Loan_Participations__r[0].Participated_Amount__c;
	}

	private static testMethod void it_should_return_an_empty_list_if_no_loan_apps_are_found() {
		Set<Id> fakeLoanAppId = new Set<Id>{ObjectFactory.getFakeId(EB_Loan_Application__c.SObjectType, '1')};

		List<EB_Loan_Application__c> returnResult = sut.getLoanApplicationsByIds(fakeLoanAppId);
	
		system.assertEquals(0, returnResult.size());
	}

	private static testMethod void it_should_update_the_provided_loan_apps() {
		TestUtilities.createLoanAppStages();
		EB_Loan_Application__c testApp1 = ObjectFactory.getLoanApplication('EntityName', 'EBAccountName', 'EBAccountNumber', 'LoanAppName');
		EB_Loan_Application__c testApp2 = ObjectFactory.getLoanApplication('EntityName', 'EBAccountName', 'EBAccountNumber', 'LoanAppName');
		EB_Loan_Application__c testApp3 = ObjectFactory.getLoanApplication('EntityName', 'EBAccountName', 'EBAccountNumber', 'LoanAppName');
		testApp1.Annual_Income__c = 123;
		testApp2.Annual_Income__c = 123;
		testApp3.Annual_Income__c = 123;
		update testApp1;
		update testApp2;
		update testApp3;
		EB_Loan_Application__c testApp1PreChange = [SELECT Annual_Income__c FROM EB_Loan_Application__c WHERE id =: testApp1.Id];
		EB_Loan_Application__c testApp2PreChange = [SELECT Annual_Income__c FROM EB_Loan_Application__c WHERE id =: testApp2.Id];
		EB_Loan_Application__c testApp3PreChange = [SELECT Annual_Income__c FROM EB_Loan_Application__c WHERE id =: testApp3.Id];
		testApp1.Annual_Income__c = 111111;
		testApp2.Annual_Income__c = 222222;
		testApp3.Annual_Income__c = 333333;
		List<EB_Loan_Application__c> loanappsToUpdate = new List<EB_Loan_Application__c>{testApp1, testApp2, testApp3};

		sut.updateLoanApplications(loanappsToUpdate);

		EB_Loan_Application__c testApp1PostChange = [SELECT Annual_Income__c FROM EB_Loan_Application__c WHERE id =: testApp1.Id];
		EB_Loan_Application__c testApp2PostChange = [SELECT Annual_Income__c FROM EB_Loan_Application__c WHERE id =: testApp2.Id];
		EB_Loan_Application__c testApp3PostChange = [SELECT Annual_Income__c FROM EB_Loan_Application__c WHERE id =: testApp3.Id];
		System.assertEquals(123, testApp1PreChange.Annual_Income__c);
		System.assertEquals(123, testApp2PreChange.Annual_Income__c);
		System.assertEquals(123, testApp3PreChange.Annual_Income__c);
		System.assertEquals(111111, testApp1PostChange.Annual_Income__c);
		System.assertEquals(222222, testApp2PostChange.Annual_Income__c);
		System.assertEquals(333333, testApp3PostChange.Annual_Income__c);
	}

	
}