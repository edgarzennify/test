public with sharing class ParentRelManagerControllerDataProvider implements ParentRelationships.IParentRelManagerControllerDataProvider{

    public Account getEntity(Id entityId){
        return [SELECT Id, name, Relationship_Review_Required_Date__c
                       , Relationship_To_Parent__c, Type, OwnerId, EB_UnitID__c
                       , Relationship_Change_Ignore_Validation__c, Parent.Id
                       , Parent.Name, Parent.Relationship_To_Parent__c
                       , ParentId
                       
                FROM Account WHERE Id =: entityId];
    }
    
    public void saveEntity(Account entity){
        if(entity != null){
            if(entity.id == null){
                insert entity;
            }else{
                update entity;
            }
        }
    }

    public Map<Id, Account> getChildrenForEntities(Set<Id> entityIds){
        return new Map<Id, Account>([SELECT Id, OwnerId, EB_UnitID__c FROM Account WHERE ParentId IN: entityIds LIMIT 5000]);
    }

}