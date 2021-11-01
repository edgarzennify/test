public with sharing class ModReqUnitRMControllerDataProv implements ModReqUnitRMControllerDataProv.IModReqUnitRMControllerDataProv {

	public interface IModReqUnitRMControllerDataProv {
		Account getEntity(Id entityId);
	}

	public Account getEntity(Id entityId){
		return [SELECT Id, Name 
						,OwnerId, Owner.Name
						,EB_UnitID__c, EB_UnitID__r.Name, EB_UnitID__r.Relationship_Oversight__c
					FROM Account
					WHERE Id =: entityId];
	}

}