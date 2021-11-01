@isTest
public class TriggerHandlerTester {
    
    public List<SObject> triggerOld = new List<SObject>();
	public List<SObject> triggerNew = new List<SObject>();
    private Map<Id, SObject> triggerNewMap {
        get{
            return mapify(triggerNew);
        }
    }
    
	public void beforeTriggerInsertSequence(ITrigger sut) {
    	sut.initialize();
        sut.bulkBeforeInsert(triggerOld);
        sut.finalize();
    }

    public void beforeTriggerUpdateSequence(ITrigger sut) {
    	sut.initialize();
        sut.bulkBeforeUpdate(triggerOld, triggerNewMap);
        sut.finalize();
    }

    public void beforeTriggerDeleteSequence(ITrigger sut) {
    	sut.initialize();
        sut.bulkBeforeDelete(triggerOld);
        sut.finalize();
    }

    public void afterTriggerInsertSequence(ITrigger sut) {
    	sut.initialize();
        sut.bulkAfterInsert(triggerNew);
        sut.finalize();
    }

    public void afterTriggerUpdateSequence(ITrigger sut) {
    	sut.initialize();
        sut.bulkAfterUpdate(triggerOld, triggerNewMap);
        sut.finalize();
    }

    public void afterTriggerDeleteSequence(ITrigger sut) {
    	sut.initialize();
        sut.bulkAfterDelete(triggerNew);
        sut.finalize();
    }

    private static Map<Id, SObject> mapify(List<SObject> sobjects){
        Map<Id, SObject> sobjectMap = new Map<Id, SObject>();
        for(SObject so : sobjects){
            sobjectMap.put(so.Id, so);
        }
        return sobjectMap;
    }
}