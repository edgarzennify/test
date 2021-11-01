@isTest
private class OpportunityEditRedirectDataProvTests {
	
	private static testMethod void it_should_retrieve_the_opportunity_for_given_id() {
		Account testAcct = ObjectFactory.getValidEntity('name');
		Id oppTypeId = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Opportunity' AND isActive = true LIMIT 1].Id;
		Opportunity testOpportunity = new Opportunity();
		testOpportunity.AccountId = testAcct.Id;
		testOpportunity.Name = 'Test Opportunity';
		testOpportunity.RecordTypeId = oppTypeId;
		testOpportunity.CloseDate = Date.today().addDays(7);
		testOpportunity.StageName = 'Some Stage';
		insert testOpportunity;
		OpportunityEditRedirectDataProv sut = new OpportunityEditRedirectDataProv();

		Opportunity returnResult = sut.getOpportunityById(testOpportunity.Id);
		System.assertEquals(testOpportunity.Id, returnResult.Id);
		System.assertEquals(testAcct.Id, returnResult.AccountId);
	}
	
	private static testMethod void it_should_return_expected_fields_in_SOQL_for_getOpportunityById() {
		Account testAcct = ObjectFactory.getValidEntity('name');
		Id oppTypeId = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Opportunity' AND isActive = true LIMIT 1].Id;
		Opportunity testOpportunity = new Opportunity();
		testOpportunity.AccountId = testAcct.Id;
		testOpportunity.Name = 'Test Opportunity';
		testOpportunity.RecordTypeId = oppTypeId;
		testOpportunity.CloseDate = Date.today().addDays(7);
		testOpportunity.StageName = 'Some Stage';
		insert testOpportunity;
		OpportunityEditRedirectDataProv sut = new OpportunityEditRedirectDataProv();

		Opportunity returnResult = sut.getOpportunityById(testOpportunity.Id);
		Object wasFieldInSOQL;
		wasFieldInSOQL = returnResult.Id;
		wasFieldInSOQL = returnResult.AccountId;
		wasFieldInSOQL = returnResult.Entity_Relationship_Review_Required__c;
	}


}