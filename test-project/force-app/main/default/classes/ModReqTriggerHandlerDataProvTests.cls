@isTest
private class ModReqTriggerHandlerDataProvTests {
	
	private static testMethod void it_should_update_accounts() {
		Account testAcct = ObjectFactory.getValidEntity('name');
		testAcct.Do_Not_Call__c = true;
		update testAcct;
		Account testAcct2 = ObjectFactory.getValidEntity('name');
		testAcct2.Do_Not_Call__c = false;
		update testAcct2;
		Account testAcctFromDBPreChange = [SELECT Do_Not_Call__c FROM Account WHERE Id =: testAcct.Id];
		Account testAcct2FromDBPreChange = [SELECT Do_Not_Call__c FROM Account WHERE Id =: testAcct2.Id];
		testAcct.Do_Not_Call__c = false;
		testAcct2.Do_Not_Call__c = true;
		List<Account> acctsToUpdate = new List<Account>{testAcct, testAcct2};
		ModReqTriggerHandlerDataProv sut = new ModReqTriggerHandlerDataProv();

		sut.saveAccounts(acctsToUpdate);

		Account testAcctFromDBPostChange = [SELECT Do_Not_Call__c FROM Account WHERE Id =: testAcct.Id];
		Account testAcct2FromDBPostChange = [SELECT Do_Not_Call__c FROM Account WHERE Id =: testAcct2.Id];

		System.assertEquals(true, testAcctFromDBPreChange.Do_Not_Call__c);
		System.assertEquals(false, testAcct2FromDBPreChange.Do_Not_Call__c);
		System.assertEquals(false, testAcctFromDBPostChange.Do_Not_Call__c);
		System.assertEquals(true, testAcct2FromDBPostChange.Do_Not_Call__c);
	}
	
}