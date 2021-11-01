public class ProspectToClientManager implements ProspectToClient.IProspectToClientManager {
	private ProspectToClient.IProspectToClientDataProvider m_dataProvider;
	private ProspectToClient.IProspectToClientMerger m_prospectClientMerger;
	
	public ProspectToClientManager(ProspectToClient.IProspectToClientDataProvider dataProvider, ProspectToClient.IProspectToClientMerger prospectClientMerger){
		m_dataProvider = dataProvider;
		m_prospectClientMerger = prospectClientMerger;
	}
	
    public void promoteProspectsToClients(List<ProspectToClient.ProspectToClientMapping> mappings){
    	List<Id> entityIds = getIdsFromMappings(mappings);    	
    	Map<Id, Account> entities = m_dataProvider.getEntities(entityIds);    	
    	mergeMappedEntities(mappings,entities);
    }
    
    /*private Map<Id,Account> getEntitiesFromMappings(List<ProspectToClient.ProspectToClientMapping> mappings){
    	Map<Id, Account> entities = new Map<Id, Account>();
    	
    	for(ProspectToClient.ProspectToClientMapping m : mappings){
            entities.put(m.prospectId,new Account(Id = m.prospectId));
            entities.put(m.clientId,new Account(Id = m.clientId));
        }
    	
    	return entities;
    }*/
    
    private List<Id> getIdsFromMappings(List<ProspectToClient.ProspectToClientMapping> mappings){
    	List<Id> entityIds = new List<Id>();
        
        for(ProspectToClient.ProspectToClientMapping m : mappings){
            entityIds.add(m.prospectId);
            entityIds.add(m.clientId);
        }
        
        return entityIds;
    }
    
    private void mergeMappedEntities(List<ProspectToClient.ProspectToClientMapping> mappings, Map<Id, Account> entities){
    	if(entities != null){
            for(ProspectToClient.ProspectToClientMapping m : mappings){
                m_prospectClientMerger.mergeProspectAndClient(entities.get(m.prospectId), entities.get(m.clientId));
            }
        }
    }
}