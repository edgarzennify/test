public with sharing virtual class TriggerHandler implements ITrigger {

	public virtual void initialize(){}
	public virtual void bulkBeforeDelete(List<SObject> sos){}
	public virtual void bulkBeforeInsert(List<SObject> sos){}
	public virtual void bulkBeforeUpdate(List<SObject> oldSos, Map<Id, SObject> newSosMap){}
	public virtual void bulkAfterDelete(List<SObject> sos){}
	public virtual void bulkAfterInsert(List<SObject> sos){}
	public virtual void bulkAfterUpdate(List<SObject> oldSos, Map<Id, SObject> newSosMap){}
	public virtual void finalize(){}

}