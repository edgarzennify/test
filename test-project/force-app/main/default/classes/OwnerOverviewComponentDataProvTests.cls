@isTest
private class OwnerOverviewComponentDataProvTests {

	private static final OwnerOverviewComponentDataProv sut = new OwnerOverviewComponentDataProv();
    
	private static testMethod void it_should_return_the_user() {
		User testUser = ObjectFactory.getUser('John', 'Doe', 'johndoetest@enterprisebank.com.test', true);

		User returnResult = sut.getUser(testUser.Id);
		System.assertEquals(testUser.Id, returnResult.Id);
		System.assertEquals('John Doe', returnResult.Name);
	}

	private static testMethod void it_should_update_the_Entities() {
		Account testAcct = ObjectFactory.getValidEntity('acct1');
		Account testAcct2 = ObjectFactory.getValidEntity('acct2');
		User testRM1 = ObjectFactory.getUser('RM', '1', 'rm1test@enterprisebank.com.test', true);
		User testRM2 = ObjectFactory.getUser('RM', '2', 'rm2test@enterprisebank.com.test', true);
		Id testAcctRM1PreChange = [SELECT OwnerId FROM Account WHERE Id =: testAcct.Id].OwnerId;
		Id testAcctRM2PreChange = [SELECT OwnerId FROM Account WHERE Id =: testAcct2.Id].OwnerId;
		testAcct.OwnerId = testRM1.Id;
		testAcct2.OwnerId = testRM2.Id;
		List<Account> acctsToUpdate = new List<Account>{testAcct, testAcct2};

		sut.updateEntities(acctsToUpdate);

		Id testAcctRM1PostChange = [SELECT OwnerId FROM Account WHERE Id =: testAcct.Id].OwnerId;
		Id testAcctRM2PostChange = [SELECT OwnerId FROM Account WHERE Id =: testAcct2.Id].OwnerId;

		System.assertNotEquals(testAcctRM1PreChange, testAcctRM1PostChange);
		System.assertNotEquals(testAcctRM2PreChange, testAcctRM2PostChange);
		System.assertEquals(testRM1.Id, testAcctRM1PostChange);
		System.assertEquals(testRM2.Id, testAcctRM2PostChange);
	}

	private static testMethod void it_should_return_expected_fields_in_SOQL_for_getUser() {
		User testUser = ObjectFactory.getUser('John', 'Doe', 'johndoetest@enterprisebank.com.test', true);

		User returnResult = sut.getUser(testUser.Id);
		Object wasFieldInSOQL;
		wasFieldInSOQL = returnResult.Id;
		wasFieldInSOQL = returnResult.Name;
	}

	private static testMethod void it_should_get_all_users_flagged_as_a_primary_rm() {
		ObjectFactory.getUser('John', 'RM1', 'testRM1@enterprisebank.com.test', true);
		ObjectFactory.getUser('John', 'RM2', 'testRM2@enterprisebank.com.test', true);
		ObjectFactory.getUser('John', 'NotRM', 'testNotRM@enterprisebank.com.test', true);
		User testUserRM1 = [SELECT Id, Name, Primary_RM__c FROM User WHERE Username = 'testRM1@enterprisebank.com.test'];
		User testUserRM2 = [SELECT Id, Name, Primary_RM__c FROM User WHERE Username = 'testRM2@enterprisebank.com.test'];
		User testUserNotRM = [SELECT Id, Name, Primary_RM__c FROM User WHERE Username = 'testNotRM@enterprisebank.com.test'];
		testUserRM1.Primary_RM__c = true;
		testUserRM2.Primary_RM__c = true;
		testUserNotRM.Primary_RM__c = false;
		List<User> usersToUpdate = new List<User> {testUserRM1, testUserRM2, testUserNotRM};
		update usersToUpdate;

		List<User> returnedUsers = sut.getRelationshipManagers();

		Boolean foundUserRM1 = false;
		Boolean foundUserRM2 = false;
		Boolean foundUserNotRM = false;
		for(User usr : returnedUsers){
			if(usr.Id == testUserRM1.Id) foundUserRM1 = true;
			if(usr.Id == testUserRM2.Id) foundUserRM2 = true;
			if(usr.Id == testUserNotRM.Id) foundUserNotRM = true;
		}
		System.assertEquals(true, foundUserRM1);
		System.assertEquals(true, foundUserRM2);
		System.assertEquals(false, foundUserNotRM);
	}

	private static testMethod void it_should_get_all_Entities_for_given_user() {
		ObjectFactory.getUser('John', 'RM1', 'testRM1@enterprisebank.com.test', true);
		User testUserRM1 = [SELECT Id, Name, Primary_RM__c FROM User WHERE Username = 'testRM1@enterprisebank.com.test'];
		Account testAcctInc1 = ObjectFactory.getValidEntity('acct1');
		Account testAcctInc2 = ObjectFactory.getValidEntity('acct2');
		Account testAcctNotIncluded = ObjectFactory.getValidEntity('acct2');
		testAcctInc1.OwnerId = testUserRM1.Id;
		testAcctInc2.OwnerId = testUserRM1.Id;
		List<Account> acctsToUpdate = new List<Account> {testAcctInc1, testAcctInc2};
		update acctsToUpdate;		

		List<Account> returnedEntities = sut.getEntitiesForOwner(testUserRM1.Id);

		Boolean foundAcct1 = false;
		Boolean foundAcct2 = false;
		Boolean foundAcctNotInc = false;
		for(Account acct : returnedEntities){
			if(acct.Id == testAcctInc1.Id) foundAcct1 = true;
			if(acct.Id == testAcctInc2.Id) foundAcct2 = true;
			if(acct.Id == testAcctNotIncluded.Id) foundAcctNotInc = true;
		}
		System.assertEquals(true, foundAcct1);
		System.assertEquals(true, foundAcct2);
		System.assertEquals(false, foundAcctNotInc);
	}

	//private static testMethod void it_should_get_all_Ebaccts_for_given_user() {
	//	ObjectFactory.TestUser systemAdminUserGen = new ObjectFactory.TestUser('test1', 'sysuser','test1sysuser@enterprisebankstl.sfdc.test','Application Development','System Administrator',null);
 //		User systemAdminUser = systemAdminUserGen.CreateUser();
 //		Account testAcct = ObjectFactory.getValidEntity('name');
	//	testAcct.OwnerId = systemAdminUser.Id;
	//	update testAcct;
	//	EB_Account__c testEBAccount1 = ObjectFactory.getEBAccount('Test Account1','12345',testAcct);
	//	EB_Account__c testEBAccount2 = ObjectFactory.getEBAccount('Test Account2','12346',testAcct);
	//	EB_Account__c testEBAccountNot = ObjectFactory.getEBAccount('Test Account3','12347',testAcct);
	//	testEBAccount1.OwnerId = systemAdminUser.Id;
	//	testEBAccount2.OwnerId = systemAdminUser.Id;
	//	List<EB_Account__c> acctsToUpdate = new List<EB_Account__c> {testEBAccount1, testEBAccount2};
	//	update acctsToUpdate;		

	//	List<EB_Account__c> returnedAccts = sut.getEBAccountsForOwner(systemAdminUser.Id);

	//	Boolean foundAcct1 = false;
	//	Boolean foundAcct2 = false;
	//	Boolean foundAcctNotInc = false;
	//	for(EB_Account__c acct : returnedAccts){
	//		if(acct.Id == testEBAccount1.Id) foundAcct1 = true;
	//		if(acct.Id == testEBAccount2.Id) foundAcct2 = true;
	//		if(acct.Id == testEBAccountNot.Id) foundAcctNotInc = true;
	//	}
	//	System.assertEquals(true, foundAcct1);
	//	System.assertEquals(true, foundAcct2);
	//	System.assertEquals(false, foundAcctNotInc);
	//}
 
	//private static testMethod void it_should_update_the_EB_accts() {
	//	ObjectFactory.TestUser systemAdminUserGen = new ObjectFactory.TestUser('test1', 'sysuser','test1sysuser@enterprisebankstl.sfdc.test','Application Development','System Administrator',null);
 //		User systemAdminUser = systemAdminUserGen.CreateUser();
	//	Account testAcct = ObjectFactory.getValidEntity('name');
	//	testAcct.OwnerId = systemAdminUser.Id;
	//	update testAcct;
	//	EB_Account__c testEBAccount1 = ObjectFactory.getEBAccount('Test Account1','12345',testAcct);
	//	EB_Account__c testEBAccount2 = ObjectFactory.getEBAccount('Test Account2','12346',testAcct);
	//	testEBAccount1.OwnerId = systemAdminUser.Id;
	//	testEBAccount2.OwnerId = systemAdminUser.Id;
	//	List<EB_Account__c> acctsToUpdate = new List<EB_Account__c> {testEBAccount1, testEBAccount2};
	//	EB_Account__c testEBAccount1PreChange = [SELECT Id, OwnerId FROM EB_Account__c WHERE Id =: testEBAccount1.Id];
	//	EB_Account__c testEBAccount2PreChange = [SELECT Id, OwnerId FROM EB_Account__c WHERE Id =: testEBAccount2.Id];

	//	sut.updateEBAccts(acctsToUpdate);

	//	EB_Account__c testEBAccount1PostChange = [SELECT Id, OwnerId FROM EB_Account__c WHERE Id =: testEBAccount1.Id];
	//	EB_Account__c testEBAccount2PostChange = [SELECT Id, OwnerId FROM EB_Account__c WHERE Id =: testEBAccount2.Id];

	//	System.assertNotEquals(testEBAccount1PreChange.OwnerId, testEBAccount1PostChange.OwnerId);
	//	System.assertNotEquals(testEBAccount2PreChange.OwnerId, testEBAccount2PostChange.OwnerId);
	//	System.assertEquals(systemAdminUser.Id, testEBAccount1PostChange.OwnerId);
	//	System.assertEquals(systemAdminUser.Id, testEBAccount2PostChange.OwnerId);
	//}


}