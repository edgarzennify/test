public with sharing class Entity360DataProvider implements Entity360.IEntity360DataProvider {
  
  private final Entity360.IEntity360DmBuilder m_builder;
  private final ParentRelationships.IParentRelTreeBuilder m_parentRelTreeBuilder;

  public Entity360DataProvider(Entity360.IEntity360DmBuilder builder, ParentRelationships.IParentRelTreeBuilder parentRelTreeBuilder){
    m_builder = builder;
    m_parentRelTreeBuilder = parentRelTreeBuilder;
  }

  public List<DmEntity> getAllRelationshipEntitiesBySingleEntityId(String entityId){
    List<Map<Id, Account>> tree = m_parentRelTreeBuilder.getRelationshipTreeForEntity((Id)entityId, false, null);
    List<ParentRelationships.RelatedEntity> relEntities = m_parentRelTreeBuilder.getRelationshipTreeListForDisplay(tree, (Id)entityId);
    List<String> ids = new List<String>();
    if(relEntities != null){
      for(ParentRelationships.RelatedEntity relEntity : relEntities){
        ids.add(String.valueOf(relEntity.entity.Id));
      }
    }  
    return GetDmEntities(ids);
  }

 public List<DmEntity> GetDmEntities(List<String> entityIds)
  {
          List<Account> filledEntities = [SELECT
                                              Id, 
                                              Name, 
                                              ParentId, 
                                              Primary_Relationship__c, 
                                              Entity_Name__c, 
                                              Primary_Relationship__r.Entity_Name__c, 
                                              ROE__c
                                              ,(SELECT 
                                                  Id,  
                                                  Type, 
                                                  Committed_Amount__c, 
                                                  Potential_Deposits__c, 
                                                  StageName, 
                                                  ForecastCategoryName, 
                                                  Probability, 
                                                  AccountID ,
                                                  RecordType.Description, 
                                                  Potential_Fee_Income__c, 
                                                  Products__c
                                                FROM 
                                                  Opportunities
                                                WHERE   
                                                  ForecastCategoryName IN ('Pipeline', 'Omitted')
                                                  AND stageName IN ('Monitor', 'Discovery','Proposal/Solution', 'Negotiation', 'Approval/Acceptance', 'Documentation') 
                                                )
                                              ,(SELECT 
                                                  Id, 
                                                  Client_Id__c, 
                                                  EB_Account_Id__r.Current_Balance__c,
                                                  EB_Account_Id__r.Employee_Current_Balance__c, 
                                                  EB_Account_Id__r.Core_Current_Balance__c,
                                                  EB_Account_Id__r.Average_Balance__c, 
                                                  EB_Account_Id__r.YTD_Balance__c,  
                                                  EB_Account_Id__r.Application__c,
                                                  EB_Account_Id__r.Account_Type__c,
                                                  Relationship__c,
                                                  EB_Account_Id__r.Account_Fees__c, 
                                                  EB_Account_Id__r.Employee_Account_Flag__c,  
                                                  EB_Account_Id__r.Contribution_Margin__c,
                                                  EB_Account_Id__r.YTD_Contribution_Margin__c,
                                                  EB_Account_Id__r.Account_Status__c,
                                                  EB_Account_Id__r.Account_Fees_Fx__c
                                                FROM 
                                                  EB_Account_Relationships__r 
                                                WHERE 
                                                  EB_Account_Id__r.Account_Status__c NOT IN ('C','R','P')
                                                ) 
                                              ,(SELECT 
                                                  Id, 
                                                  Name
                                                FROM 
                                                  Treasury_Management_Details__r
                                                WHERE 
                                                  Archive__c = false
                                                )  
                                          FROM Account
                                          WHERE Id IN: entityIds ];
          List<Account> ordered = new List<Account>();
          for(String id : entityIds){
            Account entity = findEntityById((Id)id, filledEntities);
            ordered.add(entity);
          }                         
          return m_builder.buildDmEntities(ordered);
    }  

    private Account findEntityById(Id entityId, List<Account> entities){
      for(Account e : entities){
        if(e.Id == entityId){
          return e;
        }
      }
      return null;
    }
}