@IsTest
private class PrimaryRelationshipBatchUpdateTests {

	private static final MockOfIPrimaryRelationshipBatchUpdDataProv mockDataProv;
	private static final Mock.ofIParentRelationshipSvc mockParentRelSvc;
	private static final PrimaryRelationshipBatchUpdate sut;

	static {
		mockDataProv = new MockOfIPrimaryRelationshipBatchUpdDataProv();
		mockParentRelSvc = new Mock.ofIParentRelationshipSvc();
		sut = new PrimaryRelationshipBatchUpdate(mockDataProv, mockParentRelSvc);
	}
	
	@IsTest
    static void integration_it_should_update_the_top_level_parent_for_given_entity() {
		Account testAcctTopLevelParent = ObjectFactory.getValidEntity('TestAcctTopLevel');
		User user1 = ObjectFactory.getUser('first1', 'last1','standarduser1@testorg.com.ebt', true);
        testAcctTopLevelParent.OwnerId = user1.Id;
        update testAcctTopLevelParent;
		Account testAcct = ObjectFactory.getValidEntity('TestAcct');
		User user2 = ObjectFactory.getUser('first2', 'last2','standarduser2@testorg.com.ebt', true);
        testAcct.OwnerId = user2.Id;
        testAcct.Relationship_Change_Ignore_Validation__c = true;
		testAcct.ParentId = testAcctTopLevelParent.Id;
		update testAcct;
		testAcct.Primary_Relationship__c = null;
		update testAcct;
        Contact contact = new Contact(FirstName = 'ContactFirst', LastName ='ContactLast', AccountId = testAcct.Id, OwnerId = user2.Id );
        insert contact;
		Test.startTest();
		PrimaryRelationshipBatchUpdate sutInt = new PrimaryRelationshipBatchUpdate();

		Database.executeBatch(sutInt);

		Test.stopTest();
		Account testAcctFromDB = [SELECT Primary_Relationship__c, Id, OwnerId, ( Select Id, OwnerId From Contacts) FROM Account WHERE Id =: testAcct.Id ];
		System.assertEquals(testAcctTopLevelParent.Id, testAcctFromDB.Primary_Relationship__c);
		System.assertEquals(testAcctFromDB.OwnerId, testAcctFromDB.Contacts[0].OwnerId); 
	}

	@IsTest
    static void it_should_call_the_provider_and_the_service() {
		Account testAcctTopLevelParent = ObjectFactory.getValidEntity('TestAcctTopLevel');
		Account testAcct = ObjectFactory.getValidEntity('TestAcct');
		testAcct.Relationship_Change_Ignore_Validation__c = true;
		testAcct.ParentId = testAcctTopLevelParent.Id;
		update testAcct;
		testAcct.Primary_Relationship__c = null;
		update testAcct;
       
		Database.BatchableContext context ;
		List<Account> scope = new List<Account>{testAcct};
		Test.startTest();
		sut.execute(context, scope);
		Test.stopTest();
		mockParentRelSvc.Verify('setTopLevelParentForEntity',new List<Object>{testAcct}, Times.Once);
		mockDataProv.Verify('updateAccounts',new List<Object>{scope}, Times.Once);
	}

	@IsTest
    static void it_should_set_the_top_level_entity_for_all_accounts_returned_from_query_Locator() {
		Account testAcct1 = ObjectFactory.getValidEntity('TestAcct1');
		Account testAcct2 = ObjectFactory.getValidEntity('TestAcct2');
		Account testAcct3 = ObjectFactory.getValidEntity('TestAcct3');
		List<Account> testAccts = new List<Account>{testAcct1, testAcct2, testAcct3};

		sut.execute(null, testAccts);

		List<Object> firstRequest = mockParentRelSvc.getArgumentsFromCall('setTopLevelParentForEntity', 1);
		List<Object> secondRequest = mockParentRelSvc.getArgumentsFromCall('setTopLevelParentForEntity', 2);
		List<Object> thirdRequest = mockParentRelSvc.getArgumentsFromCall('setTopLevelParentForEntity', 3);
		List<Account> acctsSentToParentRelSvc = new List<Account>{(Account) (firstRequest.get(0)), 
																  (Account) (secondRequest.get(0)),
																  (Account) (thirdRequest.get(0))};
		Boolean testAcct1Sent = false;
		Boolean testAcct2Sent = false;
		Boolean testAcct3Sent = false;
		for (Account acct : acctsSentToParentRelSvc) {
			if (acct.Id == testAcct1.Id) {testAcct1Sent = true;}
			if (acct.Id == testAcct2.Id) {testAcct2Sent = true;}
			if (acct.Id == testAcct3.Id) {testAcct3Sent = true;}
		}
		System.assertEquals(true, testAcct1Sent);
		System.assertEquals(true, testAcct2Sent);
		System.assertEquals(true, testAcct3Sent);
		System.assertEquals(true, testAcct1.Relationship_Change_Ignore_Validation__c);
		System.assertEquals(true, testAcct2.Relationship_Change_Ignore_Validation__c);
		System.assertEquals(true, testAcct3.Relationship_Change_Ignore_Validation__c);
	}

	@IsTest
    static void it_should_send_the_complete_list_of_accounts_to_data_prov_for_update() {
		Account testAcct1 = ObjectFactory.getValidEntity('TestAcct1');
		Account testAcct2 = ObjectFactory.getValidEntity('TestAcct2');
		Account testAcct3 = ObjectFactory.getValidEntity('TestAcct3');
		List<Account> testAccts = new List<Account>{testAcct1, testAcct2, testAcct3};

		sut.execute(null, testAccts);
		
		List<Object> arguments = mockDataProv.getArgumentsFromCall('updateAccounts');
		List<Account> acctsSentForUpdate = (List<Account>) arguments.get(0);
		Boolean testAcct1SentForUpdate = false;
		Boolean testAcct2SentForUpdate = false;
		Boolean testAcct3SentForUpdate = false;
		for (Account acct : acctsSentForUpdate) {
			if (acct.Id == testAcct1.Id) {testAcct1SentForUpdate = true;}
			if (acct.Id == testAcct2.Id) {testAcct2SentForUpdate = true;}
			if (acct.Id == testAcct2.Id) {testAcct3SentForUpdate = true;}
		}
		System.assertEquals(true, testAcct1SentForUpdate);
		System.assertEquals(true, testAcct2SentForUpdate);
		System.assertEquals(true, testAcct3SentForUpdate);
	}

	private class MockOfIPrimaryRelationshipBatchUpdDataProv extends ApexMoq implements PrimaryRelationshipBatchUpdDataProv.IPrimaryRelationshipBatchUpdDataProv {
		public void updateAccounts(List<Account> accts){
			handleMethodInvocation('updateAccounts', new List<Object>{accts});
		}
		public void updateContacts(List<Contact> contacts){
			handleMethodInvocation('updateContacts', new List<Object>{contacts});
		}
	}
}