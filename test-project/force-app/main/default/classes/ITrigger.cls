public interface ITrigger 
{
	void initialize();
	void bulkBeforeDelete(List<SObject> sos);
	void bulkBeforeInsert(List<SObject> sos);
	void bulkBeforeUpdate(List<SObject> oldSos, Map<Id, SObject> newSosMap);
	void bulkAfterDelete(List<SObject> sos);
	void bulkAfterInsert(List<SObject> sos);
	void bulkAfterUpdate(List<SObject> oldSos, Map<Id, SObject> newSosMap);
	void finalize();
}