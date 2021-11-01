@isTest
public class AgreementStatusManagerDataProviderTests {

	private static testMethod void it_should_return_the_Agreement_for_given_ID() {
        Agreement__c testAgmt = ObjectFactory.getAgreement('Active', 'Test Entity1', 'comments');
        Agreement__c testAgmt2 = ObjectFactory.getAgreement('Active', 'Test Entity2', 'comments');
        testAgmt2.Source_Agreement__c = testAgmt.Id;
        update testAgmt2;
        Agreement__c testAgmt3 = ObjectFactory.getAgreement('Active', 'Test Entity3', 'comments');

		AgreementStatusManagerDataProvider sut = new AgreementStatusManagerDataProvider();

		Agreement__c returnResult = sut.getAgreementById(testAgmt2.Id);

		System.assertEquals(testAgmt.Id, returnResult.Source_Agreement__c);
	}

	private static testMethod void it_should_return_the_expected_fields_from_SOQL_for_Agreement() {
        Agreement__c testAgmt = ObjectFactory.getAgreement('Active', 'Test Entity', 'comments');
		AgreementStatusManagerDataProvider sut = new AgreementStatusManagerDataProvider();

		Agreement__c returnResult = sut.getAgreementById(testAgmt.Id);

		Object wasFieldInSOQL;
		wasFieldInSOQL = returnResult.Id;
		wasFieldInSOQL = returnResult.Name;
		wasFieldInSOQL = returnResult.RecordTypeId;
		wasFieldInSOQL = returnResult.Source_Agreement__c;
		wasFieldInSOQL = returnResult.Stage__c;
	}

	private static testMethod void it_should_return_the_Agmt_Loan_App_Rel_for_given_Agmt_Id() {
		TestUtilities.createLoanAppStages();
		Agreement__c testAgmt = ObjectFactory.getAgreement('Active', 'Prim Borr', 'Comments');
		Account testEntity = ObjectFactory.getValidEntity('testEntity');  
		Eb_Account__c newEBAccount = ObjectFactory.getEBAccount('test Account','1234', testEntity);	  
		EB_Loan_Packet__c newPacket = ObjectFactory.getLoanPacket(testEntity);
		EB_Loan_Application__c ebLoanApp = ObjectFactory.getLoanApplication(newPacket, newEBAccount, '123445');
		Agreement_Loan_Application_Relationship__c agmtLoanAppRel = ObjectFactory.getAgreementLoanApplicationRelationship(testAgmt, ebLoanApp);
		AgreementStatusManagerDataProvider sut = new AgreementStatusManagerDataProvider();

		List<Agreement_Loan_Application_Relationship__c> returnResult = sut.getAgreementLoanAppRelationshipsByAgreementId(testAgmt.Id);

		System.assertEquals(1, returnResult.size());
		System.assertEquals(ebLoanApp.Id, returnResult[0].Loan_Application__r.Id);
	}

	private static testMethod void it_should_return_an_empty_list_if_no_Related_Entities_found() {
        Agreement__c testAgmt = ObjectFactory.getAgreement('Active', 'Test Entity', 'comments');
		AgreementStatusManagerDataProvider sut = new AgreementStatusManagerDataProvider();

		List<Agreement_Loan_Application_Relationship__c> returnResult = sut.getAgreementLoanAppRelationshipsByAgreementId(testAgmt.Id);

		System.assertEquals(0, returnResult.size());
	}

	private static testMethod void it_should_return_the_expected_fields_from_SOQL_for_Agmt_Loan_App_Rel_by_AgmtId() {
		TestUtilities.createLoanAppStages();
		Agreement__c testAgmt = ObjectFactory.getAgreement('Active', 'Prim Borr', 'Comments');
		Account testEntity = ObjectFactory.getValidEntity('testEntity');  
		Eb_Account__c newEBAccount = ObjectFactory.getEBAccount('test Account','1234', testEntity);	  
		EB_Loan_Packet__c newPacket = ObjectFactory.getLoanPacket(testEntity);
		EB_Loan_Application__c ebLoanApp = ObjectFactory.getLoanApplication(newPacket, newEBAccount, '123445');
		Agreement_Loan_Application_Relationship__c agmtLoanAppRel = ObjectFactory.getAgreementLoanApplicationRelationship(testAgmt, ebLoanApp);	  
		AgreementStatusManagerDataProvider sut = new AgreementStatusManagerDataProvider();

		List<Agreement_Loan_Application_Relationship__c> returnResult = sut.getAgreementLoanAppRelationshipsByAgreementId(testAgmt.Id);

		System.assertEquals(1, returnResult.size());
		Object wasFieldInSOQL;
		wasFieldInSOQL = returnResult[0].Id;
		wasFieldInSOQL = returnResult[0].Name;
		wasFieldInSOQL = returnResult[0].Loan_Application__c;
		wasFieldInSOQL = returnResult[0].Total_Amount__c;
		wasFieldInSOQL = returnResult[0].EB_Loan_Application__c;
		wasFieldInSOQL = returnResult[0].Borrower__c;
		wasFieldInSOQL = returnResult[0].Record_Type__c;
		wasFieldInSOQL = returnResult[0].Loan_Packet__c;
		wasFieldInSOQL = returnResult[0].Loan_Application__r.Id;
		wasFieldInSOQL = returnResult[0].Loan_Application__r.Name;
		wasFieldInSOQL = returnResult[0].Loan_Application__r.EB_Loan_Packet__c;
		wasFieldInSOQL = returnResult[0].Loan_Application__r.EB_Loan_Packet__r.Id;
		wasFieldInSOQL = returnResult[0].Loan_Application__r.EB_Loan_Packet__r.Name;
		wasFieldInSOQL = returnResult[0].Loan_Application__r.Lead_Entity_With_Link__c;
		wasFieldInSOQL = returnResult[0].Loan_Application__r.Total_Loan_Amount__c;
		wasFieldInSOQL = returnResult[0].Loan_Application__r.Application_Stage__r.Loan_App_Stage_Action_Controller__r.Name;
	}

	private static testMethod void it_should_return_the_Agmt_Loan_App_Rel_for_given_App_Id() {
		TestUtilities.createLoanAppStages();
		Agreement__c testAgmt = ObjectFactory.getAgreement('Active', 'Prim Borr', 'Comments');
		Account testEntity = ObjectFactory.getValidEntity('testEntity');  
		Eb_Account__c newEBAccount = ObjectFactory.getEBAccount('test Account','1234', testEntity);	  
		EB_Loan_Packet__c newPacket = ObjectFactory.getLoanPacket(testEntity);
		EB_Loan_Application__c ebLoanApp = ObjectFactory.getLoanApplication(newPacket, newEBAccount, '123445');
		Agreement_Loan_Application_Relationship__c agmtLoanAppRel = ObjectFactory.getAgreementLoanApplicationRelationship(testAgmt, ebLoanApp);

		Agreement__c testAgmt2 = ObjectFactory.getAgreement('Active', 'Prim Borr2', 'Comments');
		EB_Loan_Application__c ebLoanApp2 = ObjectFactory.getLoanApplication(newPacket, newEBAccount, '1234452');
		Agreement_Loan_Application_Relationship__c agmtLoanAppRelExtra = ObjectFactory.getAgreementLoanApplicationRelationship(testAgmt2, ebLoanApp2);

		AgreementStatusManagerDataProvider sut = new AgreementStatusManagerDataProvider();

		List<Agreement_Loan_Application_Relationship__c> returnResult = sut.getAgreementLoanApplicationRelationshipsByAppId(ebLoanApp.Id);

		System.assertEquals(1, returnResult.size());
		System.assertEquals(testAgmt.Id, returnResult[0].Agreement__c);
	}

	private static testMethod void it_should_return_an_empty_list_if_no_Agmt_Loan_App_Rel_found_for_AppId() {
		TestUtilities.createLoanAppStages();
		Agreement__c testAgmt = ObjectFactory.getAgreement('Active', 'Prim Borr', 'Comments');
		Account testEntity = ObjectFactory.getValidEntity('testEntity');  
		Eb_Account__c newEBAccount = ObjectFactory.getEBAccount('test Account','1234', testEntity);	  
		EB_Loan_Packet__c newPacket = ObjectFactory.getLoanPacket(testEntity);
		EB_Loan_Application__c ebLoanApp = ObjectFactory.getLoanApplication(newPacket, newEBAccount, '123445');
		AgreementStatusManagerDataProvider sut = new AgreementStatusManagerDataProvider();

		List<Agreement_Loan_Application_Relationship__c> returnResult = sut.getAgreementLoanApplicationRelationshipsByAppId(testAgmt.Id);

		System.assertEquals(0, returnResult.size());
	}

	private static testMethod void it_should_return_the_expected_fields_from_SOQL_for_Agmt_Loan_App_Rel_by_AppId() {
		TestUtilities.createLoanAppStages();
		Agreement__c testAgmt = ObjectFactory.getAgreement('Active', 'Prim Borr', 'Comments');
		Account testEntity = ObjectFactory.getValidEntity('testEntity');  
		Eb_Account__c newEBAccount = ObjectFactory.getEBAccount('test Account','1234', testEntity);	  
		EB_Loan_Packet__c newPacket = ObjectFactory.getLoanPacket(testEntity);
		EB_Loan_Application__c ebLoanApp = ObjectFactory.getLoanApplication(newPacket, newEBAccount, '123445');
		Agreement_Loan_Application_Relationship__c agmtLoanAppRel = ObjectFactory.getAgreementLoanApplicationRelationship(testAgmt, ebLoanApp);
		AgreementStatusManagerDataProvider sut = new AgreementStatusManagerDataProvider();

		List<Agreement_Loan_Application_Relationship__c> returnResult = sut.getAgreementLoanApplicationRelationshipsByAppId(ebLoanApp.Id);

		System.assertEquals(1, returnResult.size());
		Object wasFieldInSOQL;
		wasFieldInSOQL = returnResult[0].Agreement__c;
		wasFieldInSOQL = returnResult[0].Loan_Application__c;
	}

	private static testMethod void it_should_return_the_Loan_App_Stage_for_given_stage_name() {
		TestUtilities.createLoanAppStages();
		AgreementStatusManagerDataProvider sut = new AgreementStatusManagerDataProvider();

		EB_Loan_App_Stage__c returnResult = sut.getLoanAppStageByName('Approved');

		System.assertEquals('Approved', returnResult.Name);
	}

	private static testMethod void it_should_return_the_expected_fields_from_SOQL_for_Loan_App_Stage() {
		TestUtilities.createLoanAppStages();
		AgreementStatusManagerDataProvider sut = new AgreementStatusManagerDataProvider();

		EB_Loan_App_Stage__c returnResult = sut.getLoanAppStageByName('Approved');

		Object wasFieldInSOQL;
		wasFieldInSOQL = returnResult.Id;
		wasFieldInSOQL = returnResult.Name;
	}

	private static testMethod void it_should_return_Agmt_EB_Acct_Rel_for_given_Acct_Id() {
		Account testEntity = ObjectFactory.getValidEntity('testEntity');
	   	EB_Account__c  ebAccount = ObjectFactory.getEBAccount('Test Account Title', '12345-15', testEntity);
	   	Agreement__c testAgmt = ObjectFactory.getAgreement('Active', 'Test Borr', 'New Test Agmt');
	   	Agreement_EB_Account_Relationship__c ebrel = ObjectFactory.getAgreementEBAccountRelationship(testAgmt, ebAccount);
		AgreementStatusManagerDataProvider sut = new AgreementStatusManagerDataProvider();

		List<Agreement_EB_Account_Relationship__c> returnResult = sut.getAgreementAccountRelationshipsByAccountId(ebAccount.Id);

		System.assertEquals(1, returnResult.size());
		System.assertEquals(ebAccount.Id, returnResult[0].Loan_Account__c);
	}

	private static testMethod void it_should_return_an_empty_list_if_no_Agmt_EB_Acct_Rel_found_for_Acct() {
		Account testEntity = ObjectFactory.getValidEntity('testEntity');
	   	EB_Account__c  ebAccount = ObjectFactory.getEBAccount('Test Account Title', '12345-15', testEntity);
		AgreementStatusManagerDataProvider sut = new AgreementStatusManagerDataProvider();

		List<Agreement_EB_Account_Relationship__c> returnResult = sut.getAgreementAccountRelationshipsByAccountId(ebAccount.Id);

		System.assertEquals(0, returnResult.size());
	}

	private static testMethod void it_should_return_the_expected_fields_from_SOQL_for_Agmt_EB_Acct_Rel() {
		Account testEntity = ObjectFactory.getValidEntity('testEntity');
	   	EB_Account__c  ebAccount = ObjectFactory.getEBAccount('Test Account Title', '12345-15', testEntity);
	   	Agreement__c testAgmt = ObjectFactory.getAgreement('Active', 'Test Borr', 'New Test Agmt');
	   	Agreement_EB_Account_Relationship__c ebrel = ObjectFactory.getAgreementEBAccountRelationship(testAgmt, ebAccount);
		AgreementStatusManagerDataProvider sut = new AgreementStatusManagerDataProvider();

		List<Agreement_EB_Account_Relationship__c> returnResult = sut.getAgreementAccountRelationshipsByAccountId(ebAccount.Id);

		System.assertEquals(1, returnResult.size());
		Object wasFieldInSOQL;
		wasFieldInSOQL = returnResult[0].Id;
		wasFieldInSOQL = returnResult[0].Name;
		wasFieldInSOQL = returnResult[0].Loan_Account__c;
		wasFieldInSOQL = returnResult[0].Agreement__c;
	}

	private static testMethod void it_should_insert_the_Agreement() {
        Agreement__c testAgmt = new Agreement__c();
        RecordType activeRecordType = Utility.recordTypeObject('Agreement__c','Active');
        testAgmt.RecordType = activeRecordType;
        testAgmt.Law_Firm__c = 'Test and Test';
        Integer totlRecordsPreInsert = [SELECT COUNT() FROM Agreement__c WHERE Law_Firm__c = 'Test and Test'];
		AgreementStatusManagerDataProvider sut = new AgreementStatusManagerDataProvider();

		sut.saveAgreement(testAgmt);

        Integer totlRecordsPostInsert = [SELECT COUNT() FROM Agreement__c WHERE Law_Firm__c = 'Test and Test'];
        System.assertEquals(1, totlRecordsPostInsert - totlRecordsPreInsert);
	}

	private static testMethod void it_should_save_changes_to_the_Agreement() {
        Agreement__c testAgmt = ObjectFactory.getAgreement('Active', 'Test Entity1', 'comments');
        testAgmt.Loan_Documents_Prepared_By__c = 'Attorney Prepared';
        update testAgmt;
        Agreement__c soqlResultPreChange = [SELECT Loan_Documents_Prepared_By__c From Agreement__c WHERE Id =: testAgmt.Id LIMIT 1];
		AgreementStatusManagerDataProvider sut = new AgreementStatusManagerDataProvider();

        testAgmt.Loan_Documents_Prepared_By__c = 'Internal';
		sut.saveAgreement(testAgmt);

        Agreement__c soqlResultPostChange = [SELECT Loan_Documents_Prepared_By__c From Agreement__c WHERE Id =: testAgmt.Id LIMIT 1];
		System.assertNotEquals(soqlResultPreChange.Loan_Documents_Prepared_By__c, soqlResultPostChange.Loan_Documents_Prepared_By__c);
		System.assertEquals('Internal', soqlResultPostChange.Loan_Documents_Prepared_By__c);
	}

	private static testMethod void it_should_insert_the_Account_Relationship() {
		Account testEntity = ObjectFactory.getValidEntity('testEntity');
	   	EB_Account__c  ebAccount = ObjectFactory.getEBAccount('Test Account Title', '12345-15', testEntity);
	   	Agreement__c testAgmt = ObjectFactory.getAgreement('Active', 'Test Borr', 'New Test Agmt');
	   	Agreement_EB_Account_Relationship__c ebrel = new Agreement_EB_Account_Relationship__c();
	   	ebrel.Agreement__c = testAgmt.Id;
	   	ebrel.Loan_Account__c = ebAccount.Id;
        Integer totlRecordsPreInsert = [SELECT COUNT() FROM Agreement_EB_Account_Relationship__c WHERE Agreement__c =: testAgmt.Id];
		AgreementStatusManagerDataProvider sut = new AgreementStatusManagerDataProvider();

		sut.saveAccountRelationships(new List<Agreement_EB_Account_Relationship__c>{ebrel});

        Integer totlRecordsPostInsert = [SELECT COUNT() FROM Agreement_EB_Account_Relationship__c WHERE Agreement__c =: testAgmt.Id];
        System.assertEquals(1, totlRecordsPostInsert - totlRecordsPreInsert);
	}

	private static testMethod void it_should_save_changes_to_the_Account_Relationship() {
		Account testEntity = ObjectFactory.getValidEntity('testEntity');
	   	EB_Account__c  ebAccount = ObjectFactory.getEBAccount('Test Account Title', '12345-15', testEntity);
	   	Agreement__c testAgmt = ObjectFactory.getAgreement('Active', 'Test Borr', 'New Test Agmt');
	   	Agreement_EB_Account_Relationship__c ebrel = ObjectFactory.getAgreementEBAccountRelationship(testAgmt, ebAccount);
        Agreement_EB_Account_Relationship__c soqlResultPreChange = [SELECT Agreement__c From Agreement_EB_Account_Relationship__c WHERE Id =: ebrel.Id LIMIT 1];
	   	Agreement__c testAgmtNew = ObjectFactory.getAgreement('Active', 'Test Borr', 'New Test Agmt');
	   	ebrel.Agreement__c = testAgmtNew.Id;
		AgreementStatusManagerDataProvider sut = new AgreementStatusManagerDataProvider();

		sut.saveAccountRelationships(new List<Agreement_EB_Account_Relationship__c>{ebrel});

        Agreement_EB_Account_Relationship__c soqlResultPostChange = [SELECT Agreement__c From Agreement_EB_Account_Relationship__c WHERE Id =: ebrel.Id LIMIT 1];
		System.assertNotEquals(soqlResultPreChange.Agreement__c, soqlResultPostChange.Agreement__c);
		System.assertEquals(testAgmtNew.Id, soqlResultPostChange.Agreement__c);
	}
}