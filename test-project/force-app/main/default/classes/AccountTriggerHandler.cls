public with sharing class AccountTriggerHandler extends TriggerHandler {    

    public Interface IAccountTriggerHandlerDataProv {
        List<Account> getChildrenOfAccounts(Set<Id> accts);
        void updateAccounts(List<Account> accts);
        List<Eb_Team_Member__c> getTeamMembersByOwnerID(Set<Id> ownerIds);
        List<EB_Loan_App_Entity_Relationship__c> getLoanAppRelatedEntities(Set<Id> acctIds, Set<String> fieldsToRetrieve);
        void updateLoanAppRelatedEntities(List<EB_Loan_App_Entity_Relationship__c> relEntities);
        Set<EB_Loan_App_Stage_Validation_Rule__c> getLoanAppStageValidationRulesForObject(String objectName);
        List<EB_Team_Member__c> getTeamMembersById(List<Id> userIds);
    }

    private final IAccountTriggerHandlerDataProv m_dataProvider;
    private final ParentRelationshipSvc.IParentRelationshipSvc m_parentRelSvc;
    private Map<Id, Account> m_AccountsToSyncChildren = new Map<Id, Account>();

    public AccountTriggerHandler() {
        m_dataProvider = new AccountTriggerHandlerDataProv();
        m_parentRelSvc = new ParentRelationshipSvc();
    }

    public AccountTriggerHandler(IAccountTriggerHandlerDataProv dataProvider, ParentRelationshipSvc.IParentRelationshipSvc parentRelSvc) {
        m_dataProvider = dataProvider;
        m_parentRelSvc = parentRelSvc;
    }

    public override void bulkBeforeInsert(List<SObject> sos) {
        List<Id> ownerIds = getOwnerIdsFromEntities((List<Account>)sos);
        List<EB_Team_Member__c> teamMembers = m_dataProvider.getTeamMembersById(ownerIds);
        Map<Id, EB_Team_Member__c> teamMap = mapify(teamMembers);
        
        for (Account e : (List<Account>)sos) {
            updateTeamRM(e, teamMap);
            updateEbBranchTextField(e);
            updateRecordTypeDescription(e);
            updateTypeField(e);
            validateCountryFields(e);
        }
    }

    public override void bulkBeforeUpdate(List<SObject> oldSos, Map<Id, SObject> newSosMap) {
        List<Id> ownerIds = getOwnerIdsFromEntities((List<Account>)newSosMap.values());
        List<EB_Team_Member__c> teamMembers = m_dataProvider.getTeamMembersById(ownerIds);
        Map<Id, EB_Team_Member__c> teamMap = mapify(teamMembers);

        for (SObject oldSo : oldSos) {
            Account e = (Account)newSosMap.get(oldSo.Id);
            validateChangesForParentRelationship((Account)oldSo, e);
            updatePrimaryRelationshipField((Account)oldSo, e);
            updateTeamRM(e, teamMap);
            updateEbBranchTextField(e);
            updateRecordTypeDescription(e);
            updateTypeField(e);
            updateSSNTaxIdHasValueCheckbox(e);
        }
    }

    public override void bulkAfterUpdate(List<SObject> oldSos, Map<Id, SObject> newSosMap) {
        for(SObject oldSo : oldSos) {
            determineIfChangesNeedToBeSyncedToChildren((Account)oldSo, (Account)newSosMap.get(oldSo.Id));
        }
    }
    
    public override void finalize() {
        syncChangesToChildren();
    }
//////////////////////////////////////////////////////////////////////////
    private Map<Id, EB_Team_Member__c> mapify(List<EB_Team_Member__c> teamMembers) {
        Map<Id, EB_Team_Member__c> thisMap = new Map<Id, EB_Team_Member__c>();
        
        if (teamMembers != null) {
            for (EB_Team_Member__c t : teamMembers) {
                thisMap.put(t.User__c, t);              
            }
        }
        return thisMap;
    }

    private void validateChangesForParentRelationship(Account preChange, Account postChange) {
        if (postChange.Relationship_Change_Ignore_Validation__c != null && postChange.Relationship_Change_Ignore_Validation__c) {
            postChange.Relationship_Change_Ignore_Validation__c = false;
        } else {
            if (preChange.ParentId != null || postChange.ParentId != null) {
                if (preChange.ParentId != postChange.ParentId) {
                    postChange.ParentId.addError('Changes to the parent for an entity are only permitted through the relationship management screen.');
                }
                if (preChange.OwnerId != postChange.OwnerId) {
                    postChange.OwnerId.addError('Changes to the RM for an entity are only permitted on top level entities.');
                }
            }
        }
    }

    private void updatePrimaryRelationshipField(Account preChange, Account postChange) {
        if (preChange.ParentId != postChange.ParentId) {
            if (postChange.ParentId == null) {
                postChange.Primary_Relationship__c = null;
            } else {
                Account topLevelParent = m_parentRelSvc.getTopLevelParent(postChange.ParentId);
                postChange.Primary_Relationship__c = topLevelParent.Id;
            }
        }
    }

    private void determineIfChangesNeedToBeSyncedToChildren(Account preChange, Account postChange) {
        if (preChange.OwnerId != postChange.OwnerId || preChange.Primary_Relationship__c != postChange.Primary_Relationship__c) {
            m_AccountsToSyncChildren.put(postChange.Id, postChange);
        }
    }

    private void syncChangesToChildren() {
        if (m_AccountsToSyncChildren.size() > 0) {
            List<Account> childrenToSync = m_dataProvider.getChildrenOfAccounts(m_AccountsToSyncChildren.keySet());
            for (Account child : childrenToSync) {
                Account  parent =  m_AccountsToSyncChildren.get(child.ParentId);

                if (parent.Primary_Relationship__c == null) {
                    child.Primary_Relationship__c = parent.Id;
                } else {
                    child.Primary_Relationship__c = parent.Primary_Relationship__c;
                }

                if (child.OwnerId != parent.OwnerId) {
                    child.OwnerId = parent.OwnerId;
                }
                child.Relationship_Change_Ignore_Validation__c = true;
            }
            m_dataProvider.updateAccounts(childrenToSync);
        }
    }

    private void updateTeamRM(Account entity, Map<Id, EB_Team_Member__c> teamMap) {
        if (teamMap.containsKey(entity.OwnerId)) {
            EB_Team_Member__c teamMember = teamMap.get(entity.OwnerId);
            entity.Team_Relationship_Manager__c = teamMember.Id;
        }
    }

    private List<Id> getOwnerIdsFromEntities(List<Account> entities) {
        List<Id> ownerIds = new List<Id>();
        for (Account e : entities) {
            ownerIds.add(e.OwnerId);
        }
        return ownerIds;
    }

    private void updateEbBranchTextField(Account entity) {
        entity.EB_Branch_text__c = entity.EB_UnitID__c; 
    }

    private void updateRecordTypeDescription(Account entity) {
        entity.Record_Type_Description__c = entity.RecordType.Name;
    }

    private void updateTypeField(Account entity) {
        if (String.isNotBlank(entity.Sub_Type__c) && entity.Sub_Type__c.toLowerCase() == 'personal') {
            entity.Type = 'Individual';
        } else {
            entity.Type = 'Corporation';
        }
    }

    private void updateSSNTaxIdHasValueCheckbox(Account entity) {
        if(String.isBlank(entity.SSNTIN_Encrypted__c)) {
            entity.SSN_TIN_Has_Value__c = false;
        } else {
            entity.SSN_TIN_Has_Value__c = true;
        }
    }

    private void validateCountryFields(Account entity) {
        if (String.isBlank(entity.BillingCountry)) {
            entity.BillingCountry = 'US';
        }

        if (String.isBlank(entity.ShippingCountry)) {
            entity.ShippingCountry = 'US';
        }
    } 
}