@isTest
private class OpportunityTriggerHandlerDataProvTests {
    private static final OpportunityTriggerHandler.IOpportunityTriggerHandlerDataProv sut;
    static{
        sut = new OpportunityTriggerHandlerDataProv();
    }
    

	private static testMethod void it_should_retrieve_the_accounts() {
		Account testAcct = ObjectFactory.getValidEntity('Test Account');
		testAcct.Relationship_Review_Last_Modified_Date__c = Date.today();
		update testAcct;
		Account testAcct2 = ObjectFactory.getValidEntity('Test Account2');
		testAcct2.Relationship_Review_Last_Modified_Date__c = Date.today();
		update testAcct2;
		Set<Id> acctIds = new Set<Id>();
		acctIds.Add(testAcct.Id);
		acctIds.Add(testAcct2.Id);


		List<Account> returnedAccts = sut.getAccounts(acctIds);

		Boolean testAcct1Found = false;
		Boolean testAcct2Found = false;
		for(Account acct : returnedAccts){
			if (acct.Id == testAcct.Id){
				testAcct1Found = true;
			} else if (acct.Id == testAcct2.Id){
				testAcct2Found = true;
			}
		}

		System.assertEquals(2, returnedAccts.size());
		System.assertEquals(Date.today(), returnedAccts[0].Relationship_Review_Last_Modified_Date__c);
		System.assertEquals(true, testAcct1Found);
		System.assertEquals(true, testAcct2Found);
	}

	private static testMethod void it_should_update_the_accounts() {
		Account testAcct = ObjectFactory.getValidEntity('Test Account');
		Account testAcctPreChange = [SELECT Id, Relationship_Review_Required_Date__c FROM Account WHERE Id =: testAcct.Id LIMIT 1];
		Account testAcct2 = ObjectFactory.getValidEntity('Test Account2');
		Account testAcct2PreChange = [SELECT Id, Relationship_Review_Required_Date__c FROM Account WHERE Id =: testAcct2.Id LIMIT 1];

		testAcct.Relationship_Review_Required_Date__c = Date.today();
		testAcct2.Relationship_Review_Required_Date__c = Date.today();
		List<Account> acctsToUpdate = new List<Account>{testAcct, testAcct2};
		sut.updateAccounts(acctsToUpdate);

		Account testAcctPostChange = [SELECT Id, Relationship_Review_Required_Date__c FROM Account WHERE Id =: testAcct.Id LIMIT 1];
		Account testAcct2PostChange = [SELECT Id, Relationship_Review_Required_Date__c FROM Account WHERE Id =: testAcct2.Id LIMIT 1];

		System.assertEquals(null, testAcctPreChange.Relationship_Review_Required_Date__c);
		System.assertEquals(Date.today(), testAcctPostChange.Relationship_Review_Required_Date__c);
		System.assertEquals(null, testAcct2PreChange.Relationship_Review_Required_Date__c);
		System.assertEquals(Date.today(), testAcct2PostChange.Relationship_Review_Required_Date__c);
	}	

	private static testMethod void it_should_return_expected_fields_in_SOQL_for_getAccounts() {
		Account testAcct = ObjectFactory.getValidEntity('Test Account');
		Set<Id> acctIds = new Set<Id>();
		acctIds.Add(testAcct.Id);

		List<Account> returnResult = sut.getAccounts(acctIds);
		Object wasFieldInSOQL;
		wasFieldInSOQL = returnResult[0].Id;
		wasFieldInSOQL = returnResult[0].Relationship_Review_Last_Modified_Date__c;
		wasFieldInSOQL = returnResult[0].Relationship_Review_Required_Date__c;
	}
    private static testMethod void it_should_return_a_list_of_loans_when_getRelatedLoans_is_called_with_a_set_of_loan_ids(){
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        loan.LLC_BI__Amount__c = 1234;
        insert loan;
        Set<Id> loanIds = new Set<Id>{loan.Id};
        
        List<LLC_BI__Loan__c> results = sut.getRelatedLoans(loanIds);
        system.assertEquals(loan.Id, results[0].Id);
        system.assertEquals(loan.LLC_BI__Amount__c, results[0].LLC_BI__Amount__c);
    }



}