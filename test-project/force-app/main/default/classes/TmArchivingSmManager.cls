public class TmArchivingSmManager implements TmArchiving.ISmManager {

	public List<SObject> getTms(List<TmArchiving.TreasuryManagementSm> sms) {	
			List<Treasury_Management__c> objs = new List<Treasury_Management__c>();
			for(TmArchiving.TreasuryManagementSm sm: sms) {
				if(sm != null){objs.add(sm.core);}
			}
			return (List<SObject>)objs;
	}

  public List<SObject> getContactsAndAccounts(List<TmArchiving.TreasuryManagementSm> sms) {
			List<TM_Service_Contact__c> contactObjs = new List<TM_Service_Contact__c>();
			List<TM_Service_Contact__c> contactObjsFinal = new List<TM_Service_Contact__c>();
			List<EB_Account_Service__c> accountObjs = new List<EB_Account_Service__c>();
			List<EB_Account_Service__c> accountObjsFinal = new List<EB_Account_Service__c>();
			integer accountCounter = 1;
			integer contactCounter = 1;

			for(TmArchiving.TreasuryManagementSm sm: sms) {
				if(sm.contacts != null){
					for(TM_Service_Contact__c c: sm.contacts) {
						TM_Service_Contact__c curr = c.clone();
						curr.Treasury_Management_Service__c = sm.core.id;
						curr.Counter_System_Use__c = contactCounter;
						contactCounter = contactCounter + 1;
						contactObjs.add(curr);
					}
					
				}
				if(sm.accounts != null){
					for(EB_Account_Service__c a: sm.accounts) {
						EB_Account_Service__c curr = a.clone();
						curr.TM_Service__c = sm.core.id;
						curr.Counter_System_Use__c = accountCounter;
						accountCounter = accountCounter + 1;
						accountObjs.add(curr);	
					}
				}		
			}
			List<SObject> returnObjs = new List<SObject>();
			returnObjs.addAll((List<SObject>)contactObjs);
			returnObjs.addAll((List<SObject>)accountObjs);

			return returnObjs;
	}

	public List<SObject> getEntities(List<TmArchiving.TreasuryManagementSm> sms) {
			List<SObject> entities = new List<SObject>();
			for(TmArchiving.TreasuryManagementSm sm: sms) {
				if(sm.Entity != null){entities.add(sm.Entity);}
			}
			return entities;
	}

	public List<SObject> getArchives(String requestId, List<Treasury_Management__c> tmObjs){		
			List<TM_Service_Request_Archive__c> inserts = new List<TM_Service_Request_Archive__c>();
			if(tmObjs == null){return inserts;}

			for(Treasury_Management__c tmObj : tmObjs){
					if(tmObj != null && tmObj.Id != null){
						TM_Service_Request_Archive__c a = new TM_Service_Request_Archive__c();
						a.Treasury_Management_Service__c = tmObj.Id;
						a.Tm_Service_Request__c = requestId;
						inserts.add(a);
					}
			}
			return inserts; 
	}
}