@IsTest
private class AgreementTestWorkflowDataProviderTests {
	
	@IsTest
    static void it_should_retrieve_the_relevant_fields_from_agreement_test() {
		Agreement__c testAgmt = new Agreement__c();
        RecordType activeRecordType = Utility.recordTypeObject('Agreement__c','Active');
        testAgmt.RecordType = activeRecordType;
        insert testAgmt;

		Agreement_Test__c agreementTest = new Agreement_Test__c();
		agreementTest.Agreement__c = testAgmt.Id;
		insert agreementTest;

		AgreementTestWorkflowDataProvider sut = new AgreementTestWorkflowDataProvider();
		Agreement_Test__c results = sut.getAgreementTestById(agreementTest.Id);

		System.assertEquals(agreementTest.Id, results.Id);
        Object wasFieldInSOQL;
        wasFieldInSOQL = results.Id;
        wasFieldInSOQL = results.Agreement__c;
        wasFieldInSOQL = results.Agreement__r.Name;
        wasFieldInSOQL = results.Agreement__r.Borrower_Name__c;
        wasFieldInSOQL = results.Test_Type__c;
        wasFieldInSOQL = results.Test_Date__c;
        wasFieldInSOQL = results.Approval_Process__c;
        wasFieldInSOQL = results.Approver_One__c;
        wasFieldInSOQL = results.Approver_Two__c;
        wasFieldInSOQL = results.Approver_Three__c;
        wasFieldInSOQL = results.Needs_Approval__c;
        wasFieldInSOQL = results.Action_Ready__c;
	}

	@IsTest
    static void it_should_save_the_Agreement_Test() {
		User appr1 = ObjectFactory.getUser('Approver','One','approverOne@enterprisebank.com.unit.test',true);
		User appr2 = ObjectFactory.getUser('Approver','Two','approverTwo@enterprisebank.com.unit.test',true);
		User appr3 = ObjectFactory.getUser('Approver','Three','approverThree@enterprisebank.com.unit.test',true);

		Agreement__c testAgmt = new Agreement__c();
        RecordType activeRecordType = Utility.recordTypeObject('Agreement__c','Active');
        testAgmt.RecordType = activeRecordType;
        insert testAgmt;

		Agreement_Test__c agreementTest = new Agreement_Test__c();
		agreementTest.Agreement__c = testAgmt.Id;
		insert agreementTest;

		agreementTest.Approval_Process__c = 'Three Signatures';
		agreementTest.Approver_One__c = appr1.Id;
		agreementTest.Approver_Two__c = appr2.Id;
		agreementTest.Approver_Three__c = appr3.Id;

		AgreementTestWorkflowDataProvider sut = new AgreementTestWorkflowDataProvider();
		sut.saveAgreementTest(agreementTest);

		Agreement_Test__c requery = [SELECT Approval_Process__c, Approver_One__c, Approver_Two__c, Approver_Three__c FROM Agreement_Test__c WHERE Id=: agreementTest.Id];

		System.assertEquals('Three Signatures',requery.Approval_Process__c);
		System.assertEquals(appr1.Id,requery.Approver_One__c);
		System.assertEquals(appr2.Id,requery.Approver_Two__c);
		System.assertEquals(appr3.Id,requery.Approver_Three__c);
	}

	@IsTest
    static void it_should_get_the_value_of_the_Needs_Approval_field() {
		Agreement__c testAgmt = new Agreement__c();
        RecordType activeRecordType = Utility.recordTypeObject('Agreement__c','Active');
        testAgmt.RecordType = activeRecordType;
        insert testAgmt;

        Agreement_Test__c agreementTest = new Agreement_Test__c();
		agreementTest.Agreement__c = testAgmt.Id;
		agreementTest.Compliant__c = 'Yes';
		insert agreementTest;

		AgreementTestWorkflowDataProvider sut = new AgreementTestWorkflowDataProvider();
        Boolean needsApproval = sut.isApprovalRequired(agreementTest);

		System.assertEquals(false,needsApproval);
	}

	@IsTest
    static void it_should_get_the_value_of_the_Action_Ready_field() {
		Agreement__c testAgmt = new Agreement__c();
        RecordType activeRecordType = Utility.recordTypeObject('Agreement__c','Active');
        testAgmt.RecordType = activeRecordType;
        insert testAgmt;

        Agreement_Test__c agreementTest = new Agreement_Test__c();
		agreementTest.Agreement__c = testAgmt.Id;
		agreementTest.Compliant__c = 'No';
		insert agreementTest;

		AgreementTestWorkflowDataProvider sut = new AgreementTestWorkflowDataProvider();
        Boolean isActionReady = sut.isActionReady(agreementTest);

		System.assertEquals(false,isActionReady);
	}
}