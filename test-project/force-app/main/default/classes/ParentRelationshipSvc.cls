public with sharing class ParentRelationshipSvc implements ParentRelationshipSvc.IParentRelationshipSvc{

    public interface IParentRelationshipSvc{
        Account getTopLevelParent(Id entityId);
        Map<Id, Account> getAllRelatedEntitiesForParent(Id topLevelEntityId);
        void setTopLevelParentForEntity(Account entity);
        void flattenRelatedChildrenForEntity(Account entity);
    }

	private ParentRelTreeBuilderDataProv.IParentRelTreeBuilderDataProv m_dataProvider;

	public ParentRelationshipSvc() 
	{
		m_dataProvider = new ParentRelTreeBuilderDataProv();	
	}
  
	public ParentRelationshipSvc(ParentRelTreeBuilderDataProv.IParentRelTreeBuilderDataProv dataProvider)
	{
		m_dataProvider = dataProvider;	
	}

	public Account getTopLevelParent(Id entityId)
	{
		Account entityRetrieved = m_dataProvider.getEntity(entityId);
		while(entityRetrieved.ParentId != null)
		{
			if(entityRetrieved.Parent.ParentId == null){
				return m_dataProvider.getEntity(entityRetrieved.ParentId);
			}
			if(entityRetrieved.Parent.Parent.ParentId == null){
				return m_dataProvider.getEntity(entityRetrieved.Parent.ParentId);
			}
			if(entityRetrieved.Parent.Parent.Parent.ParentId == null){
				return m_dataProvider.getEntity(entityRetrieved.Parent.Parent.ParentId);
			}
			if(entityRetrieved.Parent.Parent.Parent.Parent.ParentId == null){
				return m_dataProvider.getEntity(entityRetrieved.Parent.Parent.Parent.ParentId);
			}
			if(entityRetrieved.Parent.Parent.Parent.Parent.Parent.ParentId == null){
				return m_dataProvider.getEntity(entityRetrieved.Parent.Parent.Parent.Parent.ParentId);
			}
			entityRetrieved = m_dataProvider.getEntity(entityRetrieved.Parent.Parent.Parent.Parent.Parent.ParentId);
		}
		return entityRetrieved;
	}

	public Map<Id, Account> getAllRelatedEntitiesForParent(Id topLevelEntityId)
	{
		Map<Id, Account> relatedAccounts = new Map<Id, Account>{topLevelEntityId => m_dataProvider.getEntity(topLevelEntityId)};
		Map<Id, Account> relatedAccountsForLevel = m_dataProvider.getChildrenForEntities(new Set<Id>{topLevelEntityId});
		while(relatedAccountsForLevel.size() > 0)
		{
			relatedAccounts.putAll(relatedAccountsForLevel);
			relatedAccountsForLevel = m_dataProvider.getChildrenForEntities(relatedAccountsForLevel.keySet());
		}
		return relatedAccounts;
	}

	public void setTopLevelParentForEntity(Account entity)
	{
		Account topLevelParent = getTopLevelParent(entity.Id);
		if(entity.Id == topLevelParent.Id){
			entity.Primary_Relationship__c = null;	
		} else {
			entity.Primary_Relationship__c = topLevelParent.Id;
			entity.OwnerId = topLevelParent.OwnerId;
		}
		setContactOwnerToEntityOwner(entity);
	}

	public void flattenRelatedChildrenForEntity(Account entity)
	{
		Map<Id, Account> children = getAllRelatedEntitiesForParent(entity.Id);
		List<Account> childrenToUpdate = new List<Account>();
		children.remove(entity.Id);
		for(Account child : children.values()){			
			if(child.ParentId != entity.Id){
				child.ParentId = entity.Id;
				child.Relationship_Change_Ignore_Validation__c = true;
				childrenToUpdate.add(child);
			}
		}
		if(childrenToUpdate.size() > 0){
			m_dataProvider.updateEntities(childrenToUpdate);
		}
	}

	private void setContactOwnerToEntityOwner(Account entity){
		for(Contact c : entity.Contacts){
			c.OwnerId = entity.OwnerId;
		}	
	}

}