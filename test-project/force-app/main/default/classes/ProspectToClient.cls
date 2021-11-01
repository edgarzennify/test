public class ProspectToClient {
	public interface IProspectToClientManager {
		void promoteProspectsToClients(List<ProspectToClient.ProspectToClientMapping> mappings);
	}
	
	public interface IProspectToClientDataProvider {
		Map<Id, Account> getEntities(List<Id> entityIds);
		void mergeEntities(Account masterRecord, Account slaveRecord);
		//void saveEntity(Account entity);
	}
	
	public interface IProspectToClientMerger {
		Account mergeProspectAndClient(Account prospect, Account client);
	}

    public class ProspectToClientMapping {
    	public Id prospectId {get;set;}
    	public Id clientId {get;set;}
    }
}