@isTest
private class ModReqOfficerControllerDataProvTests {

	private static testMethod void it_should_return_the_eb_account() {
		Account testAcct = ObjectFactory.getValidEntity('name');
		EB_Account__c testEBAccount = ObjectFactory.getEBAccount('Test Account','12345',testAcct);
		ModReqOfficerControllerDataProv sut = new ModReqOfficerControllerDataProv();

		EB_Account__c returnResult = sut.getEBAccount(testEBAccount.Id);

		System.assertEquals(testEBAccount.Id, returnResult.Id);
	}
	
	private static testMethod void it_should_return_expected_fields_in_SOQL_for_getEBAccount() {
		Account testAcct = ObjectFactory.getValidEntity('name');
		EB_Account__c testEBAccount = ObjectFactory.getEBAccount('Test Account','12345',testAcct);
		ModReqOfficerControllerDataProv sut = new ModReqOfficerControllerDataProv();

		EB_Account__c returnResult = sut.getEBAccount(testEBAccount.Id);
		Object wasFieldInSOQL;
		wasFieldInSOQL = returnResult.Id;
		wasFieldInSOQL = returnResult.Name;
		wasFieldInSOQL = returnResult.EB_Unit__c;
		wasFieldInSOQL = returnResult.EB_Unit__r.Name;
		wasFieldInSOQL = returnResult.EB_Unit__r.Relationship_Oversight__c;
		wasFieldInSOQL = returnResult.EB_Team_Member__r.Name;
		wasFieldInSOQL = returnResult.EB_Team_Member__r.User__c;
	}


	
}