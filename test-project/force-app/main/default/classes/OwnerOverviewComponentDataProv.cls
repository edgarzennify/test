public with sharing class OwnerOverviewComponentDataProv implements OwnerOverviewComponentDataProv.IOwnerOverviewComponentDataProv {

    public interface IOwnerOverviewComponentDataProv{
        User getUser(Id userId);
        List<User> getRelationshipManagers();
        List<Account> getEntitiesForOwner(Id userId);
        void updateEntities(List<Account> entities);
        List<EB_Account__c> getEBAccountsForOwner(Id userId);
        void updateEBAccts(List<EB_Account__c> accts);
    }

    public User getUser(Id userId){
        return [SELECT Id, Name FROM User WHERE Id =: userId];
    }

    public List<User> getRelationshipManagers(){
    	List<User> relationshipMgrs = [SELECT Id, Name 
    									FROM User 
    									WHERE Primary_RM__c = true AND IsActive = true
    									ORDER BY Name];
    	return (relationshipMgrs != null) ? relationshipMgrs : new List<User>();
    }


    public List<Account> getEntitiesForOwner(Id userId){
    	List<Account> entitiesForOwner = [SELECT Id, OwnerId, Relationship_Change_Ignore_Validation__c
    										FROM Account
    										WHERE OwnerId =: userId];
    	return (entitiesForOwner != null) ? entitiesForOwner : new List<Account>();
    }

    public void updateEntities(List<Account> entities){
        update entities;
    }

    public List<EB_Account__c> getEBAccountsForOwner(Id userId){
        List<EB_Account__c> entitiesForOwner = [SELECT Id, OwnerId
                                            FROM EB_Account__c
                                            WHERE OwnerId =: userId];
        return (entitiesForOwner != null) ? entitiesForOwner : new List<EB_Account__c>();
    }

    public void updateEBAccts(List<EB_Account__c> accts){
        update accts;
    }

}