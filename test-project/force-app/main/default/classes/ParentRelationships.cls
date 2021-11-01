public with sharing class ParentRelationships {

    public interface IParentRelManagerControllerDataProvider{
        Account getEntity(Id entityId);
        void saveEntity(Account entity);
        Map<Id, Account> getChildrenForEntities(Set<Id> entityIds);
    }
    public interface IParentRelTreeBuilder{
        List<Map<Id, Account>> getRelationshipTreesForOwners(Set<Id> ownerIds);
        List<Map<Id, Account>> getRelationshipTreeForEntity(Id entityId, Boolean ignoreLookupForParent, Id excludeChildId);
        List<Map<Id, Account>> addChildToRelationshipTreeOfParent(Id parentIDofNewChild, Id childID, String relationshipToParent);
        List<RelatedEntity> getRelationshipTreeListForDisplay(List<Map<Id, Account>> relTree, Id currentId);
    }



    public class RelatedEntity implements Comparable {

        public Account entity{get;set;}
        public Integer nodeLevel{get;set;}
        public Integer totalActiveAccounts{get;set;}
        public Boolean isCurrentNode{get;set;}
        public Boolean isTopLevel{
            get{
                return entity.ParentId == null;
            }
            set;
        }

        public RelatedEntity(Account acct, List<EB_Account_Relationship__c> relatedAccounts, Integer acctLevelInTree, Boolean currentNode){
            entity = acct;
            nodeLevel = acctLevelInTree;
            isCurrentNode = currentNode;
            totalActiveAccounts = 0; 
            if(relatedAccounts != null){         
                for(EB_Account_Relationship__c rel : relatedAccounts)
                {
                    if(rel.Relationship__c == 'Primary Owner') {totalActiveAccounts +=1 ;}
                }
            }
        }

        public Integer compareTo(Object compareTo){
            RelatedEntity compareToRelatedItem = (RelatedEntity)compareTo;
            if (entity.Name < compareToRelatedItem.entity.Name) return -1;
            if (entity.Name == compareToRelatedItem.entity.Name) return 0;
            return 1;
        }
    }

}