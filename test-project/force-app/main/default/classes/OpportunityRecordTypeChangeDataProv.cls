public with sharing class OpportunityRecordTypeChangeDataProv implements OpportunityRecordTypeChange.IOpportunityRecordTypeChangeDataProv {

	public List<RecordType> getRecordTypesForOpportunityObject(){
		List<RecordType> recordTypes = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Opportunity' AND isActive = true ORDER BY Name LIMIT 500];
		return (recordTypes != null) ? recordTypes : new List<RecordType>();
	}

	public void updateOpportunity(Opportunity opp){
		update opp;
	}

}