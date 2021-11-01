public with sharing class ParentRelTreeBuilder implements ParentRelationships.IParentRelTreeBuilder{

	private ParentRelTreeBuilderDataProv.IParentRelTreeBuilderDataProv m_dataProvider;
	private ParentRelationshipSvc.IParentRelationshipSvc m_ParentRelSvc;

	public ParentRelTreeBuilder(){
		ParentRelTreeBuilderDataProv dataProvider = new ParentRelTreeBuilderDataProv();	
		ParentRelationshipSvc parentRelSvc = new ParentRelationshipSvc();
		initialize(dataProvider, parentRelSvc);
	}
  
	public ParentRelTreeBuilder(ParentRelTreeBuilderDataProv.IParentRelTreeBuilderDataProv dataProvider, ParentRelationshipSvc.IParentRelationshipSvc parentRelSvc){
		initialize(dataProvider, parentRelSvc);
	}

	private void initialize(ParentRelTreeBuilderDataProv.IParentRelTreeBuilderDataProv dataProvider, ParentRelationshipSvc.IParentRelationshipSvc parentRelSvc){
		m_dataProvider = dataProvider;
		m_ParentRelSvc = parentRelSvc;
	}

	public List<Map<Id, Account>> getRelationshipTreesForOwners(Set<Id> ownerIds){
		Map<Id, Account> parents = m_dataProvider.getTopLevelAccountsForOwners(ownerIds);
		List<Map<Id, Account>> returnTree = new List<Map<Id, Account>>{parents};
		addChildrenToRelationshipTree(returnTree, parents.keySet(), null);
		return returnTree;
	}

	public List<Map<Id, Account>> getRelationshipTreeForEntity(Id entityId, Boolean ignoreLookupForParent, Id excludeChildId){
		Account topParent; 
		if(ignoreLookupForParent){
			topParent = m_dataProvider.getEntity(entityId);
		}else{
			topParent = m_ParentRelSvc.getTopLevelParent(entityId);
		}

		Map<Id, Account> parents = new Map<Id, Account>{topParent.Id => topParent};
		List<Map<Id, Account>> returnTree = new List<Map<Id, Account>>{parents};

		addChildrenToRelationshipTree(returnTree, parents.keySet(), excludeChildId);
		return returnTree;
	}

	public List<Map<Id, Account>> addChildToRelationshipTreeOfParent(Id parentIDofNewChild, Id childID, String relationshipToParent){
		List<Map<Id, Account>> relationshipTreeOfParent = getRelationshipTreeForEntity(parentIDofNewChild, false, childID);
		Integer levelToAddTo = locateEntityInRelationshipTree(relationshipTreeOfParent, parentIDofNewChild) + 1;
		List<Map<Id, Account>> childrenToAdd = getRelationshipTreeForEntity(childID, true, null);
		for(Map<Id, Account> children : childrenToAdd){
			while (relationshipTreeOfParent.size() <= levelToAddTo){
				relationshipTreeOfParent.add(new Map<Id, Account>());
			}
			for(Account child : children.values()){
				if (child.Id == childID){
					child.Relationship_To_Parent__c = relationshipToParent;
					child.ParentId = parentIDofNewChild;
				}
				relationshipTreeOfParent.get(levelToAddTo).put(child.Id, child);
			}
			levelToAddTo += 1;
		}
		return relationshipTreeOfParent;
	}

	public List<ParentRelationships.RelatedEntity> getRelationshipTreeListForDisplay(List<Map<Id, Account>> relTree, Id currentId){
		Map<Id, List<ParentRelationships.RelatedEntity>> parentToChildrenMap = convertRelationshipTreeToParentToChildrenMap(relTree, currentId);
		List<ParentRelationships.RelatedEntity> returnList = new List<ParentRelationships.RelatedEntity>();
		
		List<ParentRelationships.RelatedEntity> parentAccts = new List<ParentRelationships.RelatedEntity>();
		for(Account topLevelAcct : relTree[0].Values()){
			parentAccts.add(new ParentRelationships.RelatedEntity(topLevelAcct,topLevelAcct.EB_Account_Relationships__r, 0, topLevelAcct.Id == currentId));
		}
		parentAccts.sort();

		for(ParentRelationships.RelatedEntity topLevelRelatedEntity : parentAccts){
			returnList.add(new ParentRelationships.RelatedEntity(topLevelRelatedEntity.entity,topLevelRelatedEntity.entity.EB_Account_Relationships__r, 0, topLevelRelatedEntity.entity.Id == currentId));
			returnList.addAll(getSortedChildrenInList(parentToChildrenMap, topLevelRelatedEntity.entity.Id, new Set<Id>()));
		}
		return returnList;
	}

	private void addChildrenToRelationshipTree(List<Map<Id, Account>> relTree, Set<Id> parentIds, Id excludeChildId){
		Map<Id, Account> children = m_dataProvider.getChildrenForEntities(parentIds);
		while(children.size() > 0)
		{
			if(excludeChildId != null)
			{
				children.remove(excludeChildId);
			}
			relTree.add(children);
			children = m_dataProvider.getChildrenForEntities(children.keyset());
		}
	}

	private Integer locateEntityInRelationshipTree(List<Map<Id, Account>> relTree, Id entityID){
		for(Integer index = 0; index < relTree.size(); index++){
			if(relTree.get(index).containsKey(entityId)){
				return index;
			}
		}
		return relTree.size() + 1;
	}

	private Map<Id, List<ParentRelationships.RelatedEntity>> convertRelationshipTreeToParentToChildrenMap(List<Map<Id, Account>> relTree, Id currentId){
		Map<Id, List<ParentRelationships.RelatedEntity>> parentToChildrenMap = new Map<Id, List<ParentRelationships.RelatedEntity>>();
		for(Integer index = 0; index < relTree.size(); index++){
			for(Account entityInLevel : relTree[index].values()){
				if(entityInLevel.ParentId != null){
					ParentRelationships.RelatedEntity childItem = new ParentRelationships.RelatedEntity(entityInLevel,entityInLevel.EB_Account_Relationships__r, index, entityInLevel.Id == currentId);
					if(parentToChildrenMap.containsKey(entityInLevel.ParentId)){
						parentToChildrenMap.get(entityInLevel.ParentId).add(childItem);
					}else{
						List<ParentRelationships.RelatedEntity> newChildList = new List<ParentRelationships.RelatedEntity>();
						newChildList.add(childItem);
						parentToChildrenMap.put(entityInLevel.ParentId, newChildList);						
					}
				}
			}
		}
		for(List<ParentRelationships.RelatedEntity> listOfChildren : parentToChildrenMap.Values()){
			listOfChildren.sort();
		}
		return parentToChildrenMap;
	}

	private List<ParentRelationships.RelatedEntity> getSortedChildrenInList(Map<Id, List<ParentRelationships.RelatedEntity>> parentToChildrenMap, Id parentId, Set<Id> alreadyProcessedIds){
		List<ParentRelationships.RelatedEntity> returnList = new List<ParentRelationships.RelatedEntity>();
		if (alreadyProcessedIds.contains(parentId)) return returnList;
		if (parentToChildrenMap.containsKey(parentId)){
			alreadyProcessedIds.add(parentId);
			for(ParentRelationships.RelatedEntity childItem : parentToChildrenMap.get(parentId)){
				returnList.add(childitem);
				returnList.addAll(getSortedChildrenInList(parentToChildrenMap, childItem.entity.Id, alreadyProcessedIds));
			}
		}
		return returnList;
	}

  
}