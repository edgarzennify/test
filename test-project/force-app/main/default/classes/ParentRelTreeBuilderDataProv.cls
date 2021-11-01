public class ParentRelTreeBuilderDataProv implements ParentRelTreeBuilderDataProv.IParentRelTreeBuilderDataProv{

    public interface IParentRelTreeBuilderDataProv{
        Account getEntity(Id acctId);
        Map<Id, Account> getChildrenForEntities(Set<Id> acctIds);
        Map<Id, Account> getTopLevelAccountsForOwners(Set<Id> ownerIds);
        void updateEntities(List<Account> entities);
    }

	public Account getEntity(Id acctId){
		return [SELECT Id, Name, Relationship_To_Parent__c, BillingCity, BillingState, IsPersonAccount
						,OwnerId, Owner.Name, EB_UnitID__r.Name 
						,ParentId, Parent.ParentId, Parent.Parent.ParentId, Parent.Parent.Parent.ParentId, Parent.Parent.Parent.Parent.ParentId, Parent.Parent.Parent.Parent.Parent.ParentId
						,(SELECT Id, EB_Account_Id__r.Account_Type__c, Relationship__c FROM EB_Account_Relationships__r WHERE EB_Account_Id__r.Account_Status__c = 'A') 
						,(SELECT Id, OwnerId From Contacts)
				FROM Account WHERE Id =: acctId LIMIT 1];
	}

	public Map<Id, Account> getChildrenForEntities(Set<Id> acctIds){
		return new Map<Id, Account>([SELECT Id, Name, ParentId, Relationship_To_Parent__c, BillingCity, BillingState, IsPersonAccount
											, OwnerId, Owner.Name, EB_UnitID__r.Name
											,(SELECT Id, EB_Account_Id__r.Account_Status__c, Relationship__c FROM EB_Account_Relationships__r WHERE EB_Account_Id__r.Account_Status__c = 'A') 
											,(SELECT Id, OwnerId From Contacts)
									FROM Account WHERE ParentId IN: acctIds LIMIT 2000]);
	}

	public Map<Id, Account> getTopLevelAccountsForOwners(Set<Id> ownerIds){
		return new Map<Id, Account>([SELECT Id, Name, ParentId, Relationship_To_Parent__c, BillingCity, BillingState, IsPersonAccount
											, OwnerId, Owner.Name, EB_UnitID__r.Name 
											,(SELECT Id, EB_Account_Id__r.Account_Type__c, Relationship__c FROM EB_Account_Relationships__r WHERE EB_Account_Id__r.Account_Status__c = 'A') 
											,(SELECT Id, OwnerId From Contacts)
									FROM Account WHERE ParentId = null AND OwnerId IN: ownerIds LIMIT 2000]);
	}

	public void updateEntities(List<Account> entities){
		update entities;
	}
}