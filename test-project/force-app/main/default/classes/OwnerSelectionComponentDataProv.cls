public with sharing class OwnerSelectionComponentDataProv implements OwnerSelectionComponent.IOwnerSelectionComponentDataProv{

	public List<User> getOwners(){
		return [SELECT Id, Name, IsActive FROM User WHERE Id In (SELECT OwnerId FROM Account) ORDER BY Name LIMIT 1000];
	}

}