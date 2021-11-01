@IsTest
private class PricingWkstDataProvTests {
	
	private static final PricingWkstDataProv sut = new PricingWkstDataProv();

	@IsTest
    static void it_should_retreive_EB_Accounts_when_giving_Entity_IDs_to_getEBAccountsForEntities(){
		Account testAcct = ObjectFactory.getValidEntity('name');
		Account testAcct2 = ObjectFactory.getValidEntity('name');
		EB_Account__c testEBAccount1 = ObjectFactory.getEBAccount('Test Account1','12345',testAcct);
		testEBAccount1.Primary_Owner_Id__c = testAcct.Id;
		update testEBAccount1;
		EB_Account__c testEBAccount2 = ObjectFactory.getEBAccount('Test Account2','22345',testAcct);
		testEBAccount2.Primary_Owner_Id__c = testAcct2.Id;
		update testEBAccount2;
		EB_Account__c testEBAccount3 = ObjectFactory.getEBAccount('Test Account3','32345',testAcct);
		testEBAccount3.Primary_Owner_Id__c = testAcct.Id;
		update testEBAccount3;
		Set<Id> testEBAccountSet = new Set<Id>{testAcct.Id, testAcct2.Id};
		Set<Integer> applicationCodes = new Set<Integer>{2,4,6,11,13,15};

		List<EB_Account__c> returnResult = sut.getEBAccountsForEntities(testEBAccountSet, applicationCodes);
		
		Boolean foundEBacct1 = false;
		Boolean foundEBacct2 = false;
		Boolean foundEBacct3 = false;
		for(EB_Account__c ebacct : returnResult){
			if(ebacct.Id == testEBAccount1.Id){
				foundEBacct1 = true;
			}
			if(ebacct.Id == testEBAccount2.Id){
				foundEBacct2 = true;
			}
			if(ebacct.Id == testEBAccount3.Id){
				foundEBacct3 = true;
			}
		}

		system.assertEquals(3, returnResult.size());
		system.assertEquals(true, foundEBacct1);
		system.assertEquals(true, foundEBacct2);
		system.assertEquals(true, foundEBacct3);
	}

	@IsTest
    static void it_should_add_the_pricing_worksheet() {
		Account testAcct = ObjectFactory.getValidEntity('name');
		Pricing_Worksheet__c wkst = new Pricing_Worksheet__c(Entity__c=testAcct.Id);
		List<Pricing_Worksheet__c> wkstPreSub = [SELECT Id FROM Pricing_Worksheet__c WHERE Entity__c=:testAcct.Id];

		sut.addPricingWorksheet(wkst);

		List<Pricing_Worksheet__c> wkstPostSub = [SELECT Id FROM Pricing_Worksheet__c WHERE Entity__c=:testAcct.Id];
		System.assertEquals(0, wkstPreSub.size());
		System.assertEquals(1, wkstPostSub.size());
	}

	@IsTest
    static void it_should_get_the_pricing_worksheet() {
		Account testAcct = ObjectFactory.getValidEntity('name');
		Pricing_Worksheet__c wkst = new Pricing_Worksheet__c(Entity__c=testAcct.Id);
		insert wkst;
		List<Pricing_Worksheet__c> wkstFromDB = [SELECT Id FROM Pricing_Worksheet__c WHERE Entity__c=:testAcct.Id];		

		Pricing_Worksheet__c wkstReturned = sut.getPricingWorksheet(wkstFromDB[0].Id);

		System.assertEquals(wkstFromDB[0].Id, wkstReturned.Id);
	}

	@IsTest
    static void it_should_upate_the_pricing_worksheet() {
		Account testAcct = ObjectFactory.getValidEntity('name');
		Pricing_Worksheet__c wkst = new Pricing_Worksheet__c(Entity__c=testAcct.Id, Comments__c = 'prechange');
		insert wkst;
		List<Pricing_Worksheet__c> wkstPreSub = [SELECT Id, Comments__c FROM Pricing_Worksheet__c WHERE Entity__c=:testAcct.Id];
		wkst.Comments__c = 'postchange';

		sut.updatePricingWorksheet(wkst);

		List<Pricing_Worksheet__c> wkstPostSub = [SELECT Id, Comments__c FROM Pricing_Worksheet__c WHERE Entity__c=:testAcct.Id];
		System.assertEquals('prechange', wkstPreSub[0].Comments__c);
		System.assertEquals('postchange', wkstPostSub[0].Comments__c);
	}

	@IsTest
    static void it_should_get_loan_packets_for_the_entities() {
		Account testAcct = ObjectFactory.getValidEntity('name');
		EB_Loan_Packet__c loanpckt1 = ObjectFactory.getLoanPacket(testAcct);
		loanpckt1.Name = 'pckt1';
		update loanpckt1;
		Account testAcct2 = ObjectFactory.getValidEntity('name2');
		EB_Loan_Packet__c loanpckt2 = ObjectFactory.getLoanPacket(testAcct2);
		loanpckt2.Name = 'pckt2';
		update loanpckt2;
		Account testAcct3 = ObjectFactory.getValidEntity('name3');
		EB_Loan_Packet__c loanpckt3NotIncluded = ObjectFactory.getLoanPacket(testAcct3);
		loanpckt3NotIncluded.Name = 'pckt3';
		update loanpckt3NotIncluded;
		Set<Id> entityIDs = new Set<Id>{testAcct.Id, testAcct2.Id};

		List<EB_Loan_Packet__c> returnResult = sut.getLoanPacketsForEntities(entityIDs);

		System.assertEquals(2, returnResult.size());	
		Boolean found1 = false;
		Boolean found2 = false;
		Boolean found3 = false;
		for(EB_Loan_Packet__c pckt : returnResult){
			if(pckt.Name == loanpckt1.Name){
				found1 = true;
			}
			if(pckt.Name == loanpckt2.Name){
				found2 = true;
			}
			if(pckt.Name == loanpckt3NotIncluded.Name){
				found3 = true;
			}
		}
		system.assertEquals(true, found1);
		system.assertEquals(true, found2);
		system.assertEquals(false, found3);
	}

	@IsTest
    static void it_should_get_pricing_prop_loans_for_worksheet() {
		Account testAcct = ObjectFactory.getValidEntity('name');
		Pricing_Worksheet__c wkst = new Pricing_Worksheet__c(Entity__c=testAcct.Id, Comments__c = 'prechange');
		insert wkst;
		Pricing_Proposed_Loan__c propItem1 = new Pricing_Proposed_Loan__c(Pricing_Worksheet__c = wkst.Id);
		insert propItem1;
		Pricing_Proposed_Loan__c propItem2 = new Pricing_Proposed_Loan__c(Pricing_Worksheet__c = wkst.Id);
		insert propItem2;
		Pricing_Proposed_Loan__c propItem3 = new Pricing_Proposed_Loan__c(Pricing_Worksheet__c = wkst.Id);
		insert propItem3;
		Pricing_Worksheet__c wkstNotIncluded = new Pricing_Worksheet__c(Entity__c=testAcct.Id, Comments__c = 'prechange');
		insert wkstNotIncluded;
		Pricing_Proposed_Loan__c propItemNotIncluded = new Pricing_Proposed_Loan__c(Pricing_Worksheet__c = wkstNotIncluded.Id);
		insert propItemNotIncluded;

		Map<Id, Pricing_Proposed_Loan__c> propItemsReturned = sut.getPricingProposedLoansForWorksheet(wkst.Id);

		System.assertEquals(3, propItemsReturned.size());
		System.assertEquals(propItem1.Id, propItemsReturned.get(propItem1.Id).Id);
		System.assertEquals(propItem2.Id, propItemsReturned.get(propItem2.Id).Id);
		System.assertEquals(propItem3.Id, propItemsReturned.get(propItem3.Id).Id);
	}

	@IsTest
    static void it_should_get_pricing_prop_deposits_for_worksheet() {
		Account testAcct = ObjectFactory.getValidEntity('name');
		Pricing_Worksheet__c wkst = new Pricing_Worksheet__c(Entity__c=testAcct.Id, Comments__c = 'prechange');
		insert wkst;
		Pricing_Proposed_Deposit__c propItem1 = new Pricing_Proposed_Deposit__c(Pricing_Worksheet__c = wkst.Id);
		insert propItem1;
		Pricing_Proposed_Deposit__c propItem2 = new Pricing_Proposed_Deposit__c(Pricing_Worksheet__c = wkst.Id);
		insert propItem2;
		Pricing_Proposed_Deposit__c propItem3 = new Pricing_Proposed_Deposit__c(Pricing_Worksheet__c = wkst.Id);
		insert propItem3;
		Pricing_Worksheet__c wkstNotIncluded = new Pricing_Worksheet__c(Entity__c=testAcct.Id, Comments__c = 'prechange');
		insert wkstNotIncluded;
		Pricing_Proposed_Deposit__c propItemNotIncluded = new Pricing_Proposed_Deposit__c(Pricing_Worksheet__c = wkstNotIncluded.Id);
		insert propItemNotIncluded;

		Map<Id, Pricing_Proposed_Deposit__c> propItemsReturned = sut.getPricingProposedDepositsForWorksheet(wkst.Id);

		System.assertEquals(3, propItemsReturned.size());
		System.assertEquals(propItem1.Id, propItemsReturned.get(propItem1.Id).Id);
		System.assertEquals(propItem2.Id, propItemsReturned.get(propItem2.Id).Id);
		System.assertEquals(propItem3.Id, propItemsReturned.get(propItem3.Id).Id);
	}

	@IsTest
    static void it_should_get_pricing_prop_non_int_income_for_worksheet() {
		Account testAcct = ObjectFactory.getValidEntity('name');
		Pricing_Worksheet__c wkst = new Pricing_Worksheet__c(Entity__c=testAcct.Id, Comments__c = 'prechange');
		insert wkst;
		Pricing_Proposed_Non_Interest_Income__c propItem1 = new Pricing_Proposed_Non_Interest_Income__c(Pricing_Worksheet__c = wkst.Id);
		insert propItem1;
		Pricing_Proposed_Non_Interest_Income__c propItem2 = new Pricing_Proposed_Non_Interest_Income__c(Pricing_Worksheet__c = wkst.Id);
		insert propItem2;
		Pricing_Proposed_Non_Interest_Income__c propItem3 = new Pricing_Proposed_Non_Interest_Income__c(Pricing_Worksheet__c = wkst.Id);
		insert propItem3;
		Pricing_Worksheet__c wkstNotIncluded = new Pricing_Worksheet__c(Entity__c=testAcct.Id, Comments__c = 'prechange');
		insert wkstNotIncluded;
		Pricing_Proposed_Non_Interest_Income__c propItemNotIncluded = new Pricing_Proposed_Non_Interest_Income__c(Pricing_Worksheet__c = wkstNotIncluded.Id);
		insert propItemNotIncluded;

		Map<Id, Pricing_Proposed_Non_Interest_Income__c> propItemsReturned = sut.getPricingProposedNonIntIncomeForWorksheet(wkst.Id);

		System.assertEquals(3, propItemsReturned.size());
		System.assertEquals(propItem1.Id, propItemsReturned.get(propItem1.Id).Id);
		System.assertEquals(propItem2.Id, propItemsReturned.get(propItem2.Id).Id);
		System.assertEquals(propItem3.Id, propItemsReturned.get(propItem3.Id).Id);
	}

	@IsTest
    static void it_should_get_pricing_prop_acct_removals_for_worksheet() {
		Account testAcct = ObjectFactory.getValidEntity('name');
		Pricing_Worksheet__c wkst = new Pricing_Worksheet__c(Entity__c=testAcct.Id, Comments__c = 'prechange');
		insert wkst;
		Pricing_Proposed_Account_Removal__c propItem1 = new Pricing_Proposed_Account_Removal__c(Pricing_Worksheet__c = wkst.Id);
		insert propItem1;
		Pricing_Proposed_Account_Removal__c propItem2 = new Pricing_Proposed_Account_Removal__c(Pricing_Worksheet__c = wkst.Id);
		insert propItem2;
		Pricing_Proposed_Account_Removal__c propItem3 = new Pricing_Proposed_Account_Removal__c(Pricing_Worksheet__c = wkst.Id);
		insert propItem3;
		Pricing_Worksheet__c wkstNotIncluded = new Pricing_Worksheet__c(Entity__c=testAcct.Id, Comments__c = 'prechange');
		insert wkstNotIncluded;
		Pricing_Proposed_Account_Removal__c propItemNotIncluded = new Pricing_Proposed_Account_Removal__c(Pricing_Worksheet__c = wkstNotIncluded.Id);
		insert propItemNotIncluded;

		Map<Id, Pricing_Proposed_Account_Removal__c> propItemsReturned = sut.getPricingProposedAcctRemovalsForWorksheet(wkst.Id);

		System.assertEquals(3, propItemsReturned.size());
		System.assertEquals(propItem1.Id, propItemsReturned.get(propItem1.Id).Id);
		System.assertEquals(propItem2.Id, propItemsReturned.get(propItem2.Id).Id);
		System.assertEquals(propItem3.Id, propItemsReturned.get(propItem3.Id).Id);
	}

	@IsTest
    static void it_should_add_pricing_prop_loans() {
		Account testAcct = ObjectFactory.getValidEntity('name');
		Pricing_Worksheet__c wkst = new Pricing_Worksheet__c(Entity__c=testAcct.Id, Comments__c = 'prechange');
		insert wkst;
		Pricing_Proposed_Loan__c propItem1 = new Pricing_Proposed_Loan__c(Pricing_Worksheet__c = wkst.Id);
		Pricing_Proposed_Loan__c propItem2 = new Pricing_Proposed_Loan__c(Pricing_Worksheet__c = wkst.Id);
		Pricing_Proposed_Loan__c propItem3 = new Pricing_Proposed_Loan__c(Pricing_Worksheet__c = wkst.Id);
		List<Pricing_Proposed_Loan__c> propItems = new List<Pricing_Proposed_Loan__c> {propItem1, propItem2, propItem3};
		List<Pricing_Proposed_Loan__c> propItemsPreSub = [SELECT Id FROM Pricing_Proposed_Loan__c WHERE Pricing_Worksheet__c =: wkst.Id];

		sut.addPricingProposedLoans(propItems);

		List<Pricing_Proposed_Loan__c> propItemsPostSub = [SELECT Id FROM Pricing_Proposed_Loan__c WHERE Pricing_Worksheet__c =: wkst.Id];
		System.assertEquals(0, propItemsPreSub.size());
		System.assertEquals(3, propItemsPostSub.size());
	}

	@IsTest
    static void it_should_add_pricing_prop_deposits() {
		Account testAcct = ObjectFactory.getValidEntity('name');
		Pricing_Worksheet__c wkst = new Pricing_Worksheet__c(Entity__c=testAcct.Id, Comments__c = 'prechange');
		insert wkst;
		Pricing_Proposed_Deposit__c propItem1 = new Pricing_Proposed_Deposit__c(Pricing_Worksheet__c = wkst.Id);
		Pricing_Proposed_Deposit__c propItem2 = new Pricing_Proposed_Deposit__c(Pricing_Worksheet__c = wkst.Id);
		Pricing_Proposed_Deposit__c propItem3 = new Pricing_Proposed_Deposit__c(Pricing_Worksheet__c = wkst.Id);
		List<Pricing_Proposed_Deposit__c> propItems = new List<Pricing_Proposed_Deposit__c> {propItem1, propItem2, propItem3};
		List<Pricing_Proposed_Deposit__c> propItemsPreSub = [SELECT Id FROM Pricing_Proposed_Deposit__c WHERE Pricing_Worksheet__c =: wkst.Id];

		sut.addPricingProposedDeposits(propItems);

		List<Pricing_Proposed_Deposit__c> propItemsPostSub = [SELECT Id FROM Pricing_Proposed_Deposit__c WHERE Pricing_Worksheet__c =: wkst.Id];
		System.assertEquals(0, propItemsPreSub.size());
		System.assertEquals(3, propItemsPostSub.size());
	}

	@IsTest
    static void it_should_add_pricing_prop_non_int_incomes() {
		Account testAcct = ObjectFactory.getValidEntity('name');
		Pricing_Worksheet__c wkst = new Pricing_Worksheet__c(Entity__c=testAcct.Id, Comments__c = 'prechange');
		insert wkst;
		Pricing_Proposed_Non_Interest_Income__c propItem1 = new Pricing_Proposed_Non_Interest_Income__c(Pricing_Worksheet__c = wkst.Id);
		Pricing_Proposed_Non_Interest_Income__c propItem2 = new Pricing_Proposed_Non_Interest_Income__c(Pricing_Worksheet__c = wkst.Id);
		Pricing_Proposed_Non_Interest_Income__c propItem3 = new Pricing_Proposed_Non_Interest_Income__c(Pricing_Worksheet__c = wkst.Id);
		List<Pricing_Proposed_Non_Interest_Income__c> propItems = new List<Pricing_Proposed_Non_Interest_Income__c> {propItem1, propItem2, propItem3};
		List<Pricing_Proposed_Non_Interest_Income__c> propItemsPreSub = [SELECT Id FROM Pricing_Proposed_Non_Interest_Income__c WHERE Pricing_Worksheet__c =: wkst.Id];

		sut.addPricingProposedNonIntIncomes(propItems);

		List<Pricing_Proposed_Non_Interest_Income__c> propItemsPostSub = [SELECT Id FROM Pricing_Proposed_Non_Interest_Income__c WHERE Pricing_Worksheet__c =: wkst.Id];
		System.assertEquals(0, propItemsPreSub.size());
		System.assertEquals(3, propItemsPostSub.size());
	}

	@IsTest
    static void it_should_add_pricing_prop_acct_removals() {
		Account testAcct = ObjectFactory.getValidEntity('name');
		Pricing_Worksheet__c wkst = new Pricing_Worksheet__c(Entity__c=testAcct.Id, Comments__c = 'prechange');
		insert wkst;
		Pricing_Proposed_Account_Removal__c propItem1 = new Pricing_Proposed_Account_Removal__c(Pricing_Worksheet__c = wkst.Id);
		Pricing_Proposed_Account_Removal__c propItem2 = new Pricing_Proposed_Account_Removal__c(Pricing_Worksheet__c = wkst.Id);
		Pricing_Proposed_Account_Removal__c propItem3 = new Pricing_Proposed_Account_Removal__c(Pricing_Worksheet__c = wkst.Id);
		List<Pricing_Proposed_Account_Removal__c> propItems = new List<Pricing_Proposed_Account_Removal__c>{propItem1, propItem2, propItem3};
		List<Pricing_Proposed_Account_Removal__c> propItemsPreSub = [SELECT Id FROM Pricing_Proposed_Account_Removal__c WHERE Pricing_Worksheet__c =: wkst.Id];

		sut.addPricingProposedAcctRemovals(propItems);

		List<Pricing_Proposed_Account_Removal__c> propItemsPostSub = [SELECT Id FROM Pricing_Proposed_Account_Removal__c WHERE Pricing_Worksheet__c =: wkst.Id];
		System.assertEquals(0, propItemsPreSub.size());
		System.assertEquals(3, propItemsPostSub.size());
	}

	@IsTest
    static void it_should_get_the_worksheet_id_for_the_entity() {
		Account testAcct = ObjectFactory.getValidEntity('name');
		Pricing_Worksheet__c wkst = new Pricing_Worksheet__c(Entity__c=testAcct.Id, Comments__c = 'prechange');
		insert wkst;
		Pricing_Worksheet__c wkstReturned = [SELECT Id FROM Pricing_Worksheet__c WHERE Entity__c =: testAcct.Id];
		String expectedId = wkstReturned.Id;

		String actualId = sut.getWorksheetIdForEntity(testAcct.Id);	

		System.assertEquals(expectedId, actualId);
	}

	@IsTest
    static void it_should_update_the_pricing_prop_loans() {	
		Account testAcct = ObjectFactory.getValidEntity('name');
		Pricing_Worksheet__c wkst1 = new Pricing_Worksheet__c(Entity__c=testAcct.Id, Comments__c = 'prechange');
		insert wkst1;
		Pricing_Proposed_Loan__c item1 = new Pricing_Proposed_Loan__c(Pricing_Worksheet__c = wkst1.Id, Amount__c = 1);
		insert item1;
		Pricing_Proposed_Loan__c item1PreChange = [SELECT Amount__c FROM Pricing_Proposed_Loan__c WHERE Pricing_Worksheet__c =: wkst1.Id];
		item1.Amount__c = 2;
		List<Pricing_Proposed_Loan__c> items = new List<Pricing_Proposed_Loan__c>{item1};

		sut.updatePricingProposedLoans(items);

		Pricing_Proposed_Loan__c item1PostChange = [SELECT Amount__c FROM Pricing_Proposed_Loan__c WHERE Pricing_Worksheet__c =: wkst1.Id];
		System.assertEquals(1, item1PreChange.Amount__c);
		System.assertEquals(2, item1PostChange.Amount__c);
	}

	@IsTest
    static void it_should_update_the_pricing_prop_deposits() {	
		Account testAcct = ObjectFactory.getValidEntity('name');
		Pricing_Worksheet__c wkst1 = new Pricing_Worksheet__c(Entity__c=testAcct.Id, Comments__c = 'prechange');
		insert wkst1;
		Pricing_Proposed_Deposit__c item1 = new Pricing_Proposed_Deposit__c(Pricing_Worksheet__c = wkst1.Id, Average_Balance__c = 1);
		insert item1;
		Pricing_Proposed_Deposit__c item1PreChange = [SELECT Average_Balance__c FROM Pricing_Proposed_Deposit__c WHERE Pricing_Worksheet__c =: wkst1.Id];
		item1.Average_Balance__c = 2;
		List<Pricing_Proposed_Deposit__c> items = new List<Pricing_Proposed_Deposit__c>{item1};

		sut.updatePricingProposedDeposits(items);

		Pricing_Proposed_Deposit__c item1PostChange = [SELECT Average_Balance__c FROM Pricing_Proposed_Deposit__c WHERE Pricing_Worksheet__c =: wkst1.Id];
		System.assertEquals(1, item1PreChange.Average_Balance__c);
		System.assertEquals(2, item1PostChange.Average_Balance__c);
	}

	@IsTest
    static void it_should_update_the_pricing_prop_non_int_incomes() {	
		Account testAcct = ObjectFactory.getValidEntity('name');
		Pricing_Worksheet__c wkst1 = new Pricing_Worksheet__c(Entity__c=testAcct.Id, Comments__c = 'prechange');
		insert wkst1;
		Pricing_Proposed_Non_Interest_Income__c item1 = new Pricing_Proposed_Non_Interest_Income__c(Pricing_Worksheet__c = wkst1.Id, Fee_Type__c = 'prechange');
		insert item1;
		Pricing_Proposed_Non_Interest_Income__c item1PreChange = [SELECT Fee_Type__c FROM Pricing_Proposed_Non_Interest_Income__c WHERE Pricing_Worksheet__c =: wkst1.Id];
		item1.Fee_Type__c = 'postchange';
		List<Pricing_Proposed_Non_Interest_Income__c> items = new List<Pricing_Proposed_Non_Interest_Income__c>{item1};

		sut.updatePricingProposedNonIntIncomes(items);

		Pricing_Proposed_Non_Interest_Income__c item1PostChange = [SELECT Fee_Type__c FROM Pricing_Proposed_Non_Interest_Income__c WHERE Pricing_Worksheet__c =: wkst1.Id];
		System.assertEquals('prechange', item1PreChange.Fee_Type__c);
		System.assertEquals('postchange', item1PostChange.Fee_Type__c);
	}

	@IsTest
    static void it_should_update_the_pricing_prop_acct_removals() {	
		Account testAcct = ObjectFactory.getValidEntity('name');
		Account testAcct2 = ObjectFactory.getValidEntity('name');
		EB_Account__c testEBAccount1 = ObjectFactory.getEBAccount('Test Account1','12345',testAcct);
		EB_Account__c testEBAccount2 = ObjectFactory.getEBAccount('Test Account2','12345',testAcct);
		Pricing_Worksheet__c wkst1 = new Pricing_Worksheet__c(Entity__c=testAcct.Id, Comments__c = 'prechange');
		insert wkst1;
		Pricing_Proposed_Account_Removal__c item1 = new Pricing_Proposed_Account_Removal__c(Pricing_Worksheet__c = wkst1.Id, EB_Account__c = testEBAccount1.Id);
		insert item1;
		Pricing_Proposed_Account_Removal__c item1PreChange = [SELECT EB_Account__c FROM Pricing_Proposed_Account_Removal__c WHERE Pricing_Worksheet__c =: wkst1.Id];
		item1.EB_Account__c = testEBAccount2.Id;
		List<Pricing_Proposed_Account_Removal__c> items = new List<Pricing_Proposed_Account_Removal__c>{item1};

		sut.updatePricingProposedAcctRemovals(items);

		Pricing_Proposed_Account_Removal__c item1PostChange = [SELECT EB_Account__c FROM Pricing_Proposed_Account_Removal__c WHERE Pricing_Worksheet__c =: wkst1.Id];
		System.assertEquals(testEBAccount1.Id, item1PreChange.EB_Account__c);
		System.assertEquals(testEBAccount2.Id, item1PostChange.EB_Account__c);
	}

	@IsTest
    static void it_should_delete_the_pricing_prop_loans() {	
		Account testAcct = ObjectFactory.getValidEntity('name');
		Pricing_Worksheet__c wkst = new Pricing_Worksheet__c(Entity__c=testAcct.Id, Comments__c = 'prechange');
		insert wkst;
		Pricing_Proposed_Loan__c propItem1 = new Pricing_Proposed_Loan__c(Pricing_Worksheet__c = wkst.Id);
		Pricing_Proposed_Loan__c propItem2 = new Pricing_Proposed_Loan__c(Pricing_Worksheet__c = wkst.Id);
		Pricing_Proposed_Loan__c propItem3 = new Pricing_Proposed_Loan__c(Pricing_Worksheet__c = wkst.Id);
		insert propItem1;
		insert propItem2;
		insert propItem3;
		List<Pricing_Proposed_Loan__c> propItems = new List<Pricing_Proposed_Loan__c> {propItem1, propItem2, propItem3};
		List<Pricing_Proposed_Loan__c> propItemsPreSub = [SELECT Id FROM Pricing_Proposed_Loan__c WHERE Pricing_Worksheet__c =: wkst.Id];

		sut.deletePricingProposedLoans(propItems);

		List<Pricing_Proposed_Loan__c> propItemsPostSub = [SELECT Id FROM Pricing_Proposed_Loan__c WHERE Pricing_Worksheet__c =: wkst.Id];
		System.assertEquals(3, propItemsPreSub.size());
		System.assertEquals(0, propItemsPostSub.size());
	}

	@IsTest
    static void it_should_delete_the_pricing_prop_deposits() {	
		Account testAcct = ObjectFactory.getValidEntity('name');
		Pricing_Worksheet__c wkst = new Pricing_Worksheet__c(Entity__c=testAcct.Id, Comments__c = 'prechange');
		insert wkst;
		Pricing_Proposed_Deposit__c propItem1 = new Pricing_Proposed_Deposit__c(Pricing_Worksheet__c = wkst.Id);
		Pricing_Proposed_Deposit__c propItem2 = new Pricing_Proposed_Deposit__c(Pricing_Worksheet__c = wkst.Id);
		Pricing_Proposed_Deposit__c propItem3 = new Pricing_Proposed_Deposit__c(Pricing_Worksheet__c = wkst.Id);
		insert propItem1;
		insert propItem2;
		insert propItem3;
		List<Pricing_Proposed_Deposit__c> propItems = new List<Pricing_Proposed_Deposit__c> {propItem1, propItem2, propItem3};
		List<Pricing_Proposed_Deposit__c> propItemsPreSub = [SELECT Id FROM Pricing_Proposed_Deposit__c WHERE Pricing_Worksheet__c =: wkst.Id];

		sut.deletePricingProposedDeposits(propItems);

		List<Pricing_Proposed_Deposit__c> propItemsPostSub = [SELECT Id FROM Pricing_Proposed_Deposit__c WHERE Pricing_Worksheet__c =: wkst.Id];
		System.assertEquals(3, propItemsPreSub.size());
		System.assertEquals(0, propItemsPostSub.size());
	}

	@IsTest
    static void it_should_delete_the_pricing_prop_non_int_incomes() {	
		Account testAcct = ObjectFactory.getValidEntity('name');
		Pricing_Worksheet__c wkst = new Pricing_Worksheet__c(Entity__c=testAcct.Id, Comments__c = 'prechange');
		insert wkst;
		Pricing_Proposed_Non_Interest_Income__c propItem1 = new Pricing_Proposed_Non_Interest_Income__c(Pricing_Worksheet__c = wkst.Id);
		Pricing_Proposed_Non_Interest_Income__c propItem2 = new Pricing_Proposed_Non_Interest_Income__c(Pricing_Worksheet__c = wkst.Id);
		Pricing_Proposed_Non_Interest_Income__c propItem3 = new Pricing_Proposed_Non_Interest_Income__c(Pricing_Worksheet__c = wkst.Id);
		insert propItem1;
		insert propItem2;
		insert propItem3;
		List<Pricing_Proposed_Non_Interest_Income__c> propItems = new List<Pricing_Proposed_Non_Interest_Income__c> {propItem1, propItem2, propItem3};
		List<Pricing_Proposed_Non_Interest_Income__c> propItemsPreSub = [SELECT Id FROM Pricing_Proposed_Non_Interest_Income__c WHERE Pricing_Worksheet__c =: wkst.Id];

		sut.deletePricingProposedNonIntIncomes(propItems);

		List<Pricing_Proposed_Non_Interest_Income__c> propItemsPostSub = [SELECT Id FROM Pricing_Proposed_Non_Interest_Income__c WHERE Pricing_Worksheet__c =: wkst.Id];
		System.assertEquals(3, propItemsPreSub.size());
		System.assertEquals(0, propItemsPostSub.size());
	}

	@IsTest
    static void it_should_delete_the_pricing_prop_acct_removals() {
		Account testAcct = ObjectFactory.getValidEntity('name');
		Pricing_Worksheet__c wkst = new Pricing_Worksheet__c(Entity__c=testAcct.Id, Comments__c = 'prechange');
		insert wkst;
		Pricing_Proposed_Account_Removal__c propItem1 = new Pricing_Proposed_Account_Removal__c(Pricing_Worksheet__c = wkst.Id);
		Pricing_Proposed_Account_Removal__c propItem2 = new Pricing_Proposed_Account_Removal__c(Pricing_Worksheet__c = wkst.Id);
		Pricing_Proposed_Account_Removal__c propItem3 = new Pricing_Proposed_Account_Removal__c(Pricing_Worksheet__c = wkst.Id);
		insert propItem1;
		insert propItem2;
		insert propItem3;
		List<Pricing_Proposed_Account_Removal__c> propItems = new List<Pricing_Proposed_Account_Removal__c>{propItem1, propItem2, propItem3};
		List<Pricing_Proposed_Account_Removal__c> propItemsPreSub = [SELECT Id FROM Pricing_Proposed_Account_Removal__c WHERE Pricing_Worksheet__c =: wkst.Id];

		sut.deletePricingProposedAcctRemovals(propItems);

		List<Pricing_Proposed_Account_Removal__c> propItemsPostSub = [SELECT Id FROM Pricing_Proposed_Account_Removal__c WHERE Pricing_Worksheet__c =: wkst.Id];
		System.assertEquals(3, propItemsPreSub.size());
		System.assertEquals(0, propItemsPostSub.size());
	}


	@IsTest
    static void it_should_return_expected_fields_in_SOQL_for_getEBAccountsForEntities() {
		Account testAcct = ObjectFactory.getValidEntity('name');
		EB_Account__c testEBAccount1 = ObjectFactory.getEBAccount('Test Account1','12345',testAcct);
		testEBAccount1.Primary_Owner_Id__c = testAcct.Id;
		update testEBAccount1;

		Set<Id> testEBAccountSet = new Set<Id>{	testAcct.Id };
		Set<Integer> applicationCodes = new Set<Integer>{2,4,6,11,13,15};

		List<EB_Account__c> returnResult = sut.getEBAccountsForEntities(testEBAccountSet, applicationCodes);
		Object wasFieldInSOQL;
		wasFieldInSOQL = returnResult[0].Id;
		wasFieldInSOQL = returnResult[0].Name;
		wasFieldInSOQL = returnResult[0].Account_Number__c;
		wasFieldInSOQL = returnResult[0].Application__c;
		wasFieldInSOQL = returnResult[0].EB_Bank__r.Bank_Name__c;
		wasFieldInSOQL = returnResult[0].EB_Account_Type__c;
		wasFieldInSOQL = returnResult[0].ApplicationDescription__c;
		wasFieldInSOQL = returnResult[0].Core_Current_Balance__c;
	}

	@IsTest
    static void it_should_return_expected_fields_in_SOQL_for_getPricingWorksheet() {
		Account testAcct = ObjectFactory.getValidEntity('name');
		Pricing_Worksheet__c wkst = new Pricing_Worksheet__c(Entity__c=testAcct.Id, Comments__c = 'prechange');
		insert wkst;
		Pricing_Worksheet__c wkstReturned = [SELECT Id FROM Pricing_Worksheet__c LIMIT 1];

		Pricing_Worksheet__c returnResult = sut.getPricingWorksheet(wkstReturned.Id);
		Object wasFieldInSOQL;
		wasFieldInSOQL = returnResult.Id;
		wasFieldInSOQL = returnResult.Entity__c;
		wasFieldInSOQL = returnResult.Entity__r.Name;
		wasFieldInSOQL = returnResult.Comments__c;
		wasFieldInSOQL = returnResult.Name;
	}

	@IsTest
    static void it_should_return_expected_fields_in_SOQL_for_getLoanPacketsForEntities() {
		Account testAcct = ObjectFactory.getValidEntity('name');
		EB_Loan_Packet__c loanpckt1 = ObjectFactory.getLoanPacket(testAcct);
		Set<Id> entityIDs = new Set<Id>{testAcct.Id};

		List<EB_Loan_Packet__c> returnResult = sut.getLoanPacketsForEntities(entityIDs);
		Object wasFieldInSOQL;
		wasFieldInSOQL = returnResult[0].Id;
		wasFieldInSOQL = returnResult[0].Name;
	}

	@IsTest
    static void it_should_return_expected_fields_in_SOQL_for_getPricingProposedLoansForWorksheet() {
		Account testAcct = ObjectFactory.getValidEntity('name');
		Pricing_Worksheet__c wkst = new Pricing_Worksheet__c(Entity__c=testAcct.Id, Comments__c = 'prechange');
		insert wkst;
		Pricing_Worksheet__c wkstReturned = [SELECT Id FROM Pricing_Worksheet__c LIMIT 1];
		Id worksheetId = wkstReturned.Id;
		Pricing_Proposed_Loan__c propItem1 = new Pricing_Proposed_Loan__c(Pricing_Worksheet__c = worksheetId);
		insert propItem1;

		Map<Id, Pricing_Proposed_Loan__c> returnResult = sut.getPricingProposedLoansForWorksheet(worksheetId);
		Object wasFieldInSOQL;
		wasFieldInSOQL = returnResult.values()[0].Id;
		wasFieldInSOQL = returnResult.values()[0].Amount__c;
		wasFieldInSOQL = returnResult.values()[0].Collateral__c;
		wasFieldInSOQL = returnResult.values()[0].Expected_Usage__c;
		wasFieldInSOQL = returnResult.values()[0].Fee__c;
		wasFieldInSOQL = returnResult.values()[0].Fully_Amortized__c;
		wasFieldInSOQL = returnResult.values()[0].Loan_Type__c;
		wasFieldInSOQL = returnResult.values()[0].Pricing_Worksheet__c;
		wasFieldInSOQL = returnResult.values()[0].Rate__c;
		wasFieldInSOQL = returnResult.values()[0].Rate_Type__c;
		wasFieldInSOQL = returnResult.values()[0].Renewal__c;
		wasFieldInSOQL = returnResult.values()[0].Risk__c;
		wasFieldInSOQL = returnResult.values()[0].Term__c;
	}

	@IsTest
    static void it_should_return_expected_fields_in_SOQL_for_getPricingProposedDepositsForWorksheet() {
		Account testAcct = ObjectFactory.getValidEntity('name');
		Pricing_Worksheet__c wkst = new Pricing_Worksheet__c(Entity__c=testAcct.Id, Comments__c = 'prechange');
		insert wkst;
		Pricing_Worksheet__c wkstReturned = [SELECT Id FROM Pricing_Worksheet__c LIMIT 1];
		Id worksheetId = wkstReturned.Id;
		Pricing_Proposed_Deposit__c propItem1 = new Pricing_Proposed_Deposit__c(Pricing_Worksheet__c = worksheetId);
		insert propItem1;

		Map<Id,Pricing_Proposed_Deposit__c> returnResult = sut.getPricingProposedDepositsForWorksheet(worksheetId);
		Object wasFieldInSOQL;
		wasFieldInSOQL = returnResult.values()[0].Id;
		wasFieldInSOQL = returnResult.values()[0].Average_Balance__c;
		wasFieldInSOQL = returnResult.values()[0].CD_Term__c;
		wasFieldInSOQL = returnResult.values()[0].Deposit_Type__c;
		wasFieldInSOQL = returnResult.values()[0].Gross_Monthly_Service_Charge__c;
		wasFieldInSOQL = returnResult.values()[0].Interest_Rate__c;
		wasFieldInSOQL = returnResult.values()[0].Pricing_Worksheet__c;
		wasFieldInSOQL = returnResult.values()[0].Waived__c;
	}

	@IsTest
    static void it_should_return_expected_fields_in_SOQL_for_getPricingProposedNonIntIncomeForWorksheet() {
		Account testAcct = ObjectFactory.getValidEntity('name');
		Pricing_Worksheet__c wkst = new Pricing_Worksheet__c(Entity__c=testAcct.Id, Comments__c = 'prechange');
		insert wkst;
		Pricing_Worksheet__c wkstReturned = [SELECT Id FROM Pricing_Worksheet__c LIMIT 1];
		Id worksheetId = wkstReturned.Id;
		Pricing_Proposed_Non_Interest_Income__c propItem1 = new Pricing_Proposed_Non_Interest_Income__c(Pricing_Worksheet__c = worksheetId);
		insert propItem1;

		Map<Id,Pricing_Proposed_Non_Interest_Income__c> returnResult = sut.getPricingProposedNonIntIncomeForWorksheet(worksheetId);
		Object wasFieldInSOQL;
		wasFieldInSOQL = returnResult.values()[0].Id;
		wasFieldInSOQL = returnResult.values()[0].Annual_Gross_Fees__c;
		wasFieldInSOQL = returnResult.values()[0].Fee_Type__c;
	}

	@IsTest
    static void it_should_return_expected_fields_in_SOQL_for_getPricingProposedAcctRemovalsForWorksheet() {
		Account testAcct = ObjectFactory.getValidEntity('name');
		Pricing_Worksheet__c wkst = new Pricing_Worksheet__c(Entity__c=testAcct.Id, Comments__c = 'prechange');
		insert wkst;
		Pricing_Worksheet__c wkstReturned = [SELECT Id FROM Pricing_Worksheet__c LIMIT 1];
		Id worksheetId = wkstReturned.Id;
		Pricing_Proposed_Account_Removal__c propItem1 = new Pricing_Proposed_Account_Removal__c(Pricing_Worksheet__c = worksheetId);
		insert propItem1;

		Map<Id,Pricing_Proposed_Account_Removal__c> returnResult = sut.getPricingProposedAcctRemovalsForWorksheet(worksheetId);
		Object wasFieldInSOQL;
		wasFieldInSOQL = returnResult.values()[0].Id;
		wasFieldInSOQL = returnResult.values()[0].EB_Account__c;
		wasFieldInSOQL = returnResult.values()[0].EB_Account__r.Account_Number__c;
		wasFieldInSOQL = returnResult.values()[0].EB_Account__r.EB_Account_Type__c;
		wasFieldInSOQL = returnResult.values()[0].EB_Account__r.Name;
		wasFieldInSOQL = returnResult.values()[0].EB_Account__r.Application__c;
		wasFieldInSOQL = returnResult.values()[0].EB_Account__r.ApplicationDescription__c;
		wasFieldInSOQL = returnResult.values()[0].EB_Account__r.Core_Current_Balance__c;
		wasFieldInSOQL = returnResult.values()[0].EB_Account__r.EB_Bank__r.Bank_Name__c;
	}

	@IsTest
    static void it_should_return_expected_fields_in_SOQL_for_getPricingProposedLoan() {
		Account testAcct = ObjectFactory.getValidEntity('name');
		Pricing_Worksheet__c wkst = new Pricing_Worksheet__c(Entity__c=testAcct.Id, Comments__c = 'prechange');
		insert wkst;
		Pricing_Proposed_Loan__c propItem1 = new Pricing_Proposed_Loan__c(Pricing_Worksheet__c = wkst.Id);
		insert propItem1;

		Pricing_Proposed_Loan__c returnResult = sut.getPricingProposedLoan(propItem1.Id);
		Object wasFieldInSOQL;
		wasFieldInSOQL = returnResult.Id;
		wasFieldInSOQL = returnResult.Amount__c;
		wasFieldInSOQL = returnResult.Collateral__c;
		wasFieldInSOQL = returnResult.Expected_Usage__c;
		wasFieldInSOQL = returnResult.Fee__c;
		wasFieldInSOQL = returnResult.Fully_Amortized__c;
		wasFieldInSOQL = returnResult.Loan_Type__c;
		wasFieldInSOQL = returnResult.Pricing_Worksheet__c;
		wasFieldInSOQL = returnResult.Rate__c;
		wasFieldInSOQL = returnResult.Rate_Type__c;
		wasFieldInSOQL = returnResult.Renewal__c;
		wasFieldInSOQL = returnResult.Risk__c;
		wasFieldInSOQL = returnResult.Term__c;
	}

	@IsTest
    static void it_should_return_expected_fields_in_SOQL_for_getPricingProposedDeposit() {
		Account testAcct = ObjectFactory.getValidEntity('name');
		Pricing_Worksheet__c wkst = new Pricing_Worksheet__c(Entity__c=testAcct.Id, Comments__c = 'prechange');
		insert wkst;
		Pricing_Proposed_Deposit__c propItem1 = new Pricing_Proposed_Deposit__c(Pricing_Worksheet__c = wkst.Id);
		insert propItem1;
		Pricing_Proposed_Deposit__c propDeposit = [SELECT Id FROM Pricing_Proposed_Deposit__c LIMIT 1];

		Pricing_Proposed_Deposit__c returnResult = sut.getPricingProposedDeposit(propDeposit.Id);
		Object wasFieldInSOQL;
		wasFieldInSOQL = returnResult.Id;
		wasFieldInSOQL = returnResult.Average_Balance__c;
		wasFieldInSOQL = returnResult.CD_Term__c;
		wasFieldInSOQL = returnResult.Deposit_Type__c;
		wasFieldInSOQL = returnResult.Gross_Monthly_Service_Charge__c;
		wasFieldInSOQL = returnResult.Interest_Rate__c;
		wasFieldInSOQL = returnResult.Pricing_Worksheet__c;
		wasFieldInSOQL = returnResult.Waived__c;
	}

	@IsTest
    static void it_should_return_expected_fields_in_SOQL_for_getPricingProposedNonIntIncome() {
		Account testAcct = ObjectFactory.getValidEntity('name');
		Pricing_Worksheet__c wkst = new Pricing_Worksheet__c(Entity__c=testAcct.Id, Comments__c = 'prechange');
		insert wkst;
		Pricing_Proposed_Non_Interest_Income__c propItem1 = new Pricing_Proposed_Non_Interest_Income__c(Pricing_Worksheet__c = wkst.Id);
		insert propItem1;
		Pricing_Proposed_Non_Interest_Income__c propNonIntIncome = [SELECT Id FROM Pricing_Proposed_Non_Interest_Income__c LIMIT 1];

		Pricing_Proposed_Non_Interest_Income__c returnResult = sut.getPricingProposedNonIntIncome(propNonIntIncome.Id);
		Object wasFieldInSOQL;
		wasFieldInSOQL = returnResult.Id;
		wasFieldInSOQL = returnResult.Annual_Gross_Fees__c;
		wasFieldInSOQL = returnResult.Fee_Type__c;
	}

	@IsTest
    static void it_should_return_expected_fields_in_SOQL_for_getPricingProposedAcctRemoval() {
		Account testAcct = ObjectFactory.getValidEntity('name');
		Pricing_Worksheet__c wkst = new Pricing_Worksheet__c(Entity__c=testAcct.Id, Comments__c = 'prechange');
		insert wkst;
		Pricing_Proposed_Account_Removal__c propItem1 = new Pricing_Proposed_Account_Removal__c(Pricing_Worksheet__c = wkst.Id);
		insert propItem1;
		Pricing_Proposed_Account_Removal__c propAcctRemoval = [SELECT Id FROM Pricing_Proposed_Account_Removal__c LIMIT 1];

		Pricing_Proposed_Account_Removal__c returnResult = sut.getPricingProposedAcctRemoval(propAcctRemoval.Id);
		Object wasFieldInSOQL;
		wasFieldInSOQL = returnResult.Id;
		wasFieldInSOQL = returnResult.EB_Account__c;
		wasFieldInSOQL = returnResult.EB_Account__r.Account_Number__c;
		wasFieldInSOQL = returnResult.EB_Account__r.EB_Account_Type__c;
		wasFieldInSOQL = returnResult.EB_Account__r.Name;
	}




}