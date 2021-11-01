@isTest
private class ParentRelationshipsTests {
	
	private static testMethod void  it_should_return_the_total_owned_accounts_when_getting_totalActiveAccounts()
	{
		Account entity = new Account();
		EB_Account_Relationship__c ownedAccount1 = new EB_Account_Relationship__c(Relationship__c = 'Primary Owner');
		EB_Account_Relationship__c ownedAccount2 = new EB_Account_Relationship__c(Relationship__c = 'Primary Owner');
		EB_Account_Relationship__c notOwnedAccount1 = new EB_Account_Relationship__c(Relationship__c = 'other');
		List<EB_Account_Relationship__c> relatedAccounts = new List<EB_Account_Relationship__c>{ownedAccount1,ownedAccount2, notOwnedAccount1};

		ParentRelationships.RelatedEntity sut = new ParentRelationships.RelatedEntity(entity,relatedAccounts, 0, true);

		System.assertEquals('Primary Owner' , relatedAccounts[0].Relationship__c);
		System.assertEquals(2, sut.totalActiveAccounts);
	}

	private static testMethod void  it_should_return_zero_when_related_accounts_are_null_when_getting_totalActiveAccounts()
	{
		Account entity = new Account();

		ParentRelationships.RelatedEntity sut = new ParentRelationships.RelatedEntity(entity, null, 0, true);

		System.assertEquals(0, sut.totalActiveAccounts);
	}

}