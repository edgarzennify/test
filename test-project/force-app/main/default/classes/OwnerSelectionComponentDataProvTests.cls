@isTest
private class OwnerSelectionComponentDataProvTests {

	private static testMethod void it_should_return_the_owners_of_relationships() {
		User owner1 = ObjectFactory.getUser('owner1', 'lName1', 'owner1lName1@enterprisebank.com.test', true);
		User owner2 = ObjectFactory.getUser('owner2', 'lName2', 'owner2lName2@enterprisebank.com.test', true);
		Account testAcct1 = ObjectFactory.getValidEntity('name1');
		Account testAcct2 = ObjectFactory.getValidEntity('name2');
		Account testAcct3 = ObjectFactory.getValidEntity('name3');
		testAcct1.OwnerId = owner1.Id;
		testAcct2.OwnerId = owner1.Id;
		testAcct3.OwnerId = owner2.Id;
		update testAcct1;
		update testAcct2;
		update testAcct3;
		OwnerSelectionComponentDataProv sut = new OwnerSelectionComponentDataProv();

		List<User> returnList = sut.getOwners();

		System.assertEquals(2, returnList.size());
		System.assertEquals(owner1.Id, returnList[0].Id);
		System.assertEquals(owner2.Id, returnList[1].Id);
		System.assertEquals('owner1 lName1', returnList[0].Name);
		System.assertEquals('owner2 lName2', returnList[1].Name);
	}
	
}