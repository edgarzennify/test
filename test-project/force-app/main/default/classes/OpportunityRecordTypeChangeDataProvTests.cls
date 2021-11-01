@isTest
private class OpportunityRecordTypeChangeDataProvTests {
	
	private static final OpportunityRecordTypeChangeDataProv sut;

	static{
		sut = new OpportunityRecordTypeChangeDataProv();
	}

	private static testMethod void it_should_get_all_active_record_types_for_opportunity() {
		List<RecordType> recordTypesFound = sut.getRecordTypesForOpportunityObject();
		List<RecordType> recordTypesInSystem = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Opportunity' AND isActive = true ORDER BY Name LIMIT 500];

		System.assertEquals(recordTypesInSystem, recordTypesFound);
	}

	private static testMethod void it_should_update_the_opportunity() {
		Id oppTypeId = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Opportunity' AND isActive = true LIMIT 1].Id;
		Account testAcct = ObjectFactory.getValidEntity('name');
		Opportunity testOpportunity = new Opportunity();
		testOpportunity.AccountId = testAcct.Id;
		testOpportunity.Name = 'Old Name For Opportunity';
		testOpportunity.RecordTypeId = oppTypeId;
		testOpportunity.CloseDate = Date.today().addDays(7);
		testOpportunity.StageName = 'Monitor';
		insert testOpportunity;		
		Opportunity preChangeOpp = [SELECT Name FROM Opportunity WHERE Id =: testOpportunity.Id];
		testOpportunity.Name = 'New Name For Opportunity';

		sut.updateOpportunity(testOpportunity);

		Opportunity postChangeOpp = [SELECT Name FROM Opportunity WHERE Id =: testOpportunity.Id];

		System.assertEquals('Old Name For Opportunity', preChangeOpp.Name);
		System.assertEquals('New Name For Opportunity', postChangeOpp.Name);
	}

}