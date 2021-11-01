public with sharing class CreditRelationshipData extends DataProvider implements CreditRelationship.ICreditRelationshipData {
    private string MINUTE = 'minute';
    private string SITUATION_ANALYSIS = 'Analysis';  
    private final CreditRelationship.IDataModelBuilder m_dmBuilder;
    private final Utility.IUtility m_utility;

    public CreditRelationshipData(CreditRelationship.IDataModelBuilder dmBuilder, Utility.IUtility util){
        m_dmBuilder = dmBuilder;
        m_utility = util;
    }

    public DmCreditRelationship getCreditRelationshipById(String creditRelationshipId){
        Credit_Relationship__c creditRelationship = 
          [SELECT
              Id ,
              Name,
              RecordType.Name,
              RecordTypeID
             ,(SELECT
                  Id,
                  Name, 
                  Url__c, 
                  OwnerId, 
                  Credit_Relationship__c, 
                  CreatedDate, 
                  CreatedBy.Name 
              FROM Archived_Reports__r)
              ,(SELECT 
                  Id ,
                  Name, 
                  Credit_Relationship__c, 
                  Related_Entity_del__c, 
                  Related_Entity_del__r.Id,
                  Related_Entity_del__r.Name,
                  Related_Entity_del__r.BillingCity,
                  Related_Entity_del__r.BillingState,
                  Related_Entity_del__r.BillingStreet, 
                  Related_Entity_del__r.BillingPostalCode
              FROM Credit_Relationship_Related_Clients__r)
            ,(SELECT
                  Id,
                  Name,
                  Credit_Relationship_Id__c,
                  EB_Account_Id__c,
                  EB_Account_Id__r.Name,
                  EB_Account_Id__r.Application__c ,
                  EB_Account_Id__r.Account_Number__c,
                  EB_Account_Id__r.Account_Line_1__c,
                  EB_Account_Id__r.Account_Status__c,
                  EB_Account_Id__r.User_Code_1__c , 
                  EB_Account_Id__r.YTD_Contribution_Margin__c, 
                  EB_Account_Id__r.Core_Current_Balance__c , 
                  EB_Account_Id__r.Current_Balance__c, 
                  EB_Account_Id__r.Current_Commitment__c, 
                  EB_Account_Id__r.Unadvanced_Loan_Amount__c, 
                  EB_Account_Id__r.Primary_Owner_Id__r.Name 
            FROM Credit_Relationship_Excluded_Accounts__r)
            ,(SELECT  
                  Id,
                  Name,
                  Credit_Relationship__c,
                  Diary__c, Situation_Flag__c, 
                  CreatedDate, CreatedBy.Name, 
                  OwnerId, 
                  RecordType.Id, 
                  RecordType.Name, 
                  RecordTypeId 
            FROM Credit_Relationship_Notes__r
            ORDER BY CreatedDate DESC)
        FROM Credit_Relationship__c
        WHERE Id =: creditRelationshipId];

        return m_dmBuilder.buildDmCreditRelationship(creditRelationship);
    }

    public List<DmEbAccount> getRelatedAccounts(List<DmCreditRelationshipRelatedEntity> relatedEntities){

        Set<id> relatedEntityIds = getRelatedEntityIds(relatedEntities);
         
        Map<Id,EB_Account__c> related = new Map<Id,EB_Account__c>();
        for(Account entity : [
            SELECT 
                (
                    SELECT 
                        EB_Account_Id__c,
                        EB_Account_Id__r.Id,
                        EB_Account_Id__r.Name,
                        EB_Account_Id__r.Primary_Owner_Id__r.Name,
                        EB_Account_Id__r.Account_Line_1__c,
                        EB_Account_Id__r.Current_Balance__c, 
                        EB_Account_Id__r.Current_Commitment__c, 
                        EB_Account_Id__r.Unadvanced_Loan_Amount__c,
                        EB_Account_Id__r.Core_Current_Balance__c,
                        EB_Account_Id__r.Application__c,
                        EB_Account_Id__r.Account_Number__c,
                        EB_Account_Id__r.Account_Status__c, 
                        EB_Account_Id__r.YTD_Contribution_Margin__c, 
                        EB_Account_Id__r.User_Code_1__c 
                    FROM 
                        EB_Account_Relationships__r
                ) 
            FROM 
                Account a
            WHERE 
                a.Id IN: relatedEntityIds
        ]){
        for(EB_Account_Relationship__c rel : entity.EB_Account_Relationships__r){
           if(rel.EB_Account_Id__c != null && !related.containsKey(rel.EB_Account_Id__c)){
                related.put(rel.EB_Account_Id__c, rel.EB_Account_Id__r); 
            }  
        }                 
        }
        return m_dmBuilder.buildDmEbAccounts(related.values());
  }
  public List<DmEntity> getPossibleRelatedEntities(List<DmEbAccount> relatedAccounts, List<DmCreditRelationshipRelatedEntity> relatedEntities){
        Set<Id> relatedAccountIds = new Set<Id>();
        for(DmEbAccount a : relatedAccounts){
            relatedAccountIds.add(a.id);
        }
        
        Set<Id> accountRelatedEntities = new Set<Id>();
        for(EB_Account_Relationship__c rel : [SELECT  Client_Id__c, Client_Id__r.Name 
                                              FROM EB_Account_Relationship__c 
                                              WHERE EB_Account_Id__c IN: relatedAccountIds]){
            accountRelatedEntities.add(rel.Client_Id__c);
        }

        Set<Id> alreadyRelatedEntities = new Set<Id>();
        for(DmCreditRelationshipRelatedEntity e : relatedEntities){
            if(e.entity != null) alreadyRelatedEntities.add(e.entity.id);
        }
        
        List<Account> entities = 
            [
                SELECT 
                    Id, 
                    Name, 
                    BillingStreet, 
                    BillingCity, 
                    BillingState, 
                    BillingPostalCode, 
                    Record_Type_Description__c
                FROM 
                    Account
                WHERE  
                    Id IN: accountRelatedEntities
                    AND Id NOT IN: alreadyRelatedEntities
                ORDER BY 
                    Name
            ];
        return m_dmBuilder.buildDmEntities(entities);
    }
  
  public void lockNotesById(List<String> ids){
        List<Credit_Relationship_Note__c> notes = new List<Credit_Relationship_Note__c>();
    for(String noteId : ids)
        {
            notes.add(new Credit_Relationship_Note__c(Id = noteId, Situation_Flag__c = true));
        }
        save(notes);
  }
    
    public String addArchivedReport(CreditRelationship.ArchivedReportSm sm)
    {
        Archived_Report__c pm = new Archived_Report__c(Name = sm.Name, Credit_Relationship__c = sm.creditRelationshipId);
        save(pm);
        return pm.Id;
    }
    
    public void addRelatedEntity(CreditRelationship.RelatedEntitySm sm)
    {
        Credit_Relationship_Related_Client__c pm = new Credit_Relationship_Related_Client__c(Related_Entity_del__c = sm.entityId, Credit_Relationship__c = sm.creditRelationshipId);
        save(pm);
    }
    
    public void addExcludedAccount(CreditRelationship.ExcludedAccountSm sm)
    {
        Credit_Relationship_Excluded_Account__c pm = new Credit_Relationship_Excluded_Account__c(EB_Account_Id__c = sm.accountId, Credit_Relationship_Id__c = sm.creditRelationshipId);
        save(pm);
    }
    
    public void addNote(CreditRelationship.NoteSm sm)
    {
        String noteRecordTypeName = (sm.type == CreditRelationship.NoteType.minute ? MINUTE : SITUATION_ANALYSIS);      
        RecordType noteRecordType = m_utility.recordTypeObject('Credit_Relationship_Note__c', noteRecordTypeName);
        Credit_Relationship_Note__c pm = new Credit_Relationship_Note__c(Credit_Relationship__c = sm.creditRelationshipId, Diary__c = sm.diary,RecordTypeId = noteRecordType.Id);
        save(pm);
    }
    
  public void deleteRelatedEntity(String recordId){
    remove(new Credit_Relationship_Related_Client__c(Id = recordId));
  }
  public void deleteExcludedEbAccount(String recordId){
    remove(new Credit_Relationship_Excluded_Account__c(Id = recordId));
  }
  public void deleteNote(String recordId){
    remove(new Credit_Relationship_Note__c(Id = recordId));
  }

  private Set<Id> getRelatedEntityIds(List<DmCreditRelationshipRelatedEntity> relatedEntities)
    {
        Set<Id> relatedEntityIds = new Set<Id>();
        for(DmCreditRelationshipRelatedEntity rel : relatedEntities){
            
            if(rel.entity != null)relatedEntityIds.add(rel.entity.id);
        }
        return relatedEntityIds;
    }

}