@isTest
private class ModReqUnitRMControllerDataProvTests {
	
	private static testMethod void it_should_return_the_entity() {
		Account testAcct = ObjectFactory.getValidEntity('name');
		ModReqUnitRMControllerDataProv sut = new ModReqUnitRMControllerDataProv();
		
		Account returnResult = sut.getEntity(testAcct.Id);

		System.assertEquals(testAcct.Name, returnResult.Name);
	}

	private static testMethod void it_should_return_expected_fields_in_SOQL_for_getEntity() {
		Account testAcct = ObjectFactory.getValidEntity('name');
		ModReqUnitRMControllerDataProv sut = new ModReqUnitRMControllerDataProv();

		Account returnResult = sut.getEntity(testAcct.Id);
		
		Object wasFieldInSOQL;
		wasFieldInSOQL = returnResult.Id;
		wasFieldInSOQL = returnResult.Name;
		wasFieldInSOQL = returnResult.OwnerId;
		wasFieldInSOQL = returnResult.Owner.Name;
		wasFieldInSOQL = returnResult.EB_UnitID__c;
		wasFieldInSOQL = returnResult.EB_UnitID__r.Name;
		wasFieldInSOQL = returnResult.EB_UnitID__r.Relationship_Oversight__c;
	}


	
}