@IsTest
private class Loan_PluginDataProviderTests {

    private static Loan_PluginDataProvider sut;
    
    static{
        sut = new Loan_PluginDataProvider();
    }
    
    @IsTest
    static void it_should_get_the_existing_nCino_loan_by_id() {
		LLC_BI__Loan__c testParentLoan = new LLC_BI__Loan__c();
        testParentLoan.LLC_BI__lookupKey__c = 'Buffalo Bills Parent';
		insert testParentLoan;
        
        LLC_BI__Loan__c testNcinoLoan = new LLC_BI__Loan__c();
        testNcinoLoan.LLC_BI__lookupKey__c = 'Buffalo Bill';
        testNcinoLoan.LLC_BI__ParentLoan__c = testParentLoan.Id;
		insert testNcinoLoan;
        
        LLC_BI__Loan__c result = sut.getNcinoLoanById(testNcinoLoan.Id);
        
        System.assertEquals(testNcinoLoan.Id, result.Id);
        System.assertEquals('Buffalo Bill', result.LLC_BI__lookupKey__c);
        System.assertEquals('Buffalo Bills Parent', result.LLC_BI__ParentLoan__r.LLC_BI__lookupKey__c );
    }
    
    @IsTest
    static void it_should_get_an_pm_eb_account_by_key() {
        List<EB_Account__c> testEbAccts = new List<EB_Account__c>();
        EB_Account__c testEbAcct = new EB_Account__c();
        testEbAcct.Name = 'TestName';
        testEbAcct.Key__c = 'TestKey';
        testEbAcct.Application__c = 11;
        testEbAccts.add(testEbAcct);
        insert testEbAcct;

        Agreement_EB_Account_Relationship__c rel = new Agreement_EB_Account_Relationship__c();
        rel.Loan_Account__c = testEbAcct.Id;
        rel.Loan_Account__r = testEbAcct;
        insert rel;
               
        List<PM_EB_Account_c> result = sut.getEbAccountByKey('TestKey');
        
        System.assertEquals('TestName', result[0].Name);
        System.assertEquals('TestKey', result[0].Key_c);
        System.assertEquals(1, result[0].Agreement_EB_Account_Relationship_r.size());
        System.assertEquals(rel.Id, result[0].Agreement_EB_Account_Relationship_r[0].Id);
        EB_Account__c originalObject = (EB_Account__c)result[0].OriginalSObject;
        System.assertEquals(testEbAcct.Id, originalObject.Id);
        System.assertEquals(testEbAcct.Name, originalObject.Name);
        System.assertEquals(testEbAcct.Key__c, originalObject.Key__c);
    }

    @IsTest
    static void it_should_get_the_loan_to_loan_relationship_with_its_parent_loan_when_there_is_a_parent_loan() {
        LLC_BI__Loan__c loan1 = new LLC_BI__Loan__c();
        LLC_BI__Loan__c loan2 = new LLC_BI__Loan__c();
        insert new List<LLC_BI__Loan__c>{loan1, loan2};

        LLC_BI__LoanRenewal__c rel = new LLC_BI__LoanRenewal__c();
        rel.LLC_BI__ParentLoanId__c = loan1.Id;
        rel.LLC_BI__RenewalLoanId__c = loan2.Id;
        rel.LLC_BI__PreviousVersionStage__c = 'Test Prev Version Stage';
        rel.LLC_BI__PreviousVersionStatus__c = 'Test Prev Version Status';
        insert rel;

        List<LLC_BI__LoanRenewal__c> result = sut.getParentLoanRelationship(loan2.Id);

        Object wasFieldInSoql;
        wasFieldInSoql = result[0].Id;
        wasFieldInSoql = result[0].LLC_BI__ParentLoanId__c;
        wasFieldInSoql = result[0].LLC_BI__ParentLoanId__r.LLC_BI__lookupKey__c;
        wasFieldInSoql = result[0].LLC_BI__RenewalLoanId__c;
        System.assertEquals(1, result.size());
        System.assertEquals(loan1.Id, result[0].LLC_BI__ParentLoanId__c);
        System.assertEquals(loan2.Id, result[0].LLC_BI__RenewalLoanId__c);
    }

    @IsTest
    static void it_should_return_an_empty_list_for_the_loan_to_loan_relationship_with_its_parent_loan_when_there_is_no_parent_loan() {
        LLC_BI__Loan__c loan1 = new LLC_BI__Loan__c();
        insert loan1;

        List<LLC_BI__LoanRenewal__c> result = sut.getParentLoanRelationship(loan1.Id);

        System.assertEquals(0, result.size());
    }

    @IsTest
    static void it_should_return_an_empty_list_for_the_loan_to_loan_relationship_with_its_parent_loan_when_there_is_no_parent_loan_and_the_loan_has_renewal_loan_children() {
        LLC_BI__Loan__c loan1 = new LLC_BI__Loan__c();
        LLC_BI__Loan__c loan2 = new LLC_BI__Loan__c();
        insert new List<LLC_BI__Loan__c>{loan1, loan2};
        
        LLC_BI__LoanRenewal__c rel = new LLC_BI__LoanRenewal__c();
        rel.LLC_BI__ParentLoanId__c = loan1.Id;
        rel.LLC_BI__RenewalLoanId__c = loan2.Id;
        rel.LLC_BI__PreviousVersionStage__c = 'Test Prev Version Stage';
        rel.LLC_BI__PreviousVersionStatus__c = 'Test Prev Version Status';
        insert rel;

        List<LLC_BI__LoanRenewal__c> result = sut.getParentLoanRelationship(loan1.Id);

        System.assertEquals(0, result.size());
    }
}