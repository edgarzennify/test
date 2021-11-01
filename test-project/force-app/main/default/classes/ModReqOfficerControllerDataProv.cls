public with sharing class ModReqOfficerControllerDataProv implements ModReqOfficerControllerDataProv.IModReqOfficerControllerDataProv {
	public interface IModReqOfficerControllerDataProv {		
		EB_Account__c getEBAccount(Id ebAccountId);
	}

	public EB_Account__c getEBAccount(Id ebAccountId){
		return [SELECT Id, Name
					,EB_Unit__c, EB_Unit__r.Name, EB_Unit__r.Relationship_Oversight__c
					,EB_Team_Member__r.Name, EB_Team_Member__r.User__c
				FROM EB_Account__c
				WHERE Id =: ebAccountId];
	}
}