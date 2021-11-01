public class TmBoardingSmVerifier implements TmBoarding.ISmVerifier {

	public TmBoarding.RelatedSm verifyRelatedSm(TmBoarding.RelatedSm sm, TmBoarding.RequestPm requestPm){
		Map<string, Tm_Service_Request_Contact__c> contactLookup = new Map<string, Tm_Service_Request_Contact__c>();
		Map<string, Tm_Service_Request_Account__c> accountLookup = new Map<string, Tm_Service_Request_Account__c>();

		List<Tm_Service_Request_Contact__c> smSvcContacts = getSmSvcContacts(sm);
		List<Tm_Service_Request_Account__c> smSvcAccounts = getSmSvcAccounts(sm);

		if(requestPm.serviceContactPms != null){
			for(Tm_Service_Request_Contact__c rc: requestPm.serviceContactPms){
				String key = String.Format('{0}|{1}', new List<String>{rc.Tm_Service_Request__c, rc.Contact__c});
				contactLookup.put(key, rc);
			}
		}

		if(requestPm.serviceAccountPms != null){
			for(Tm_Service_Request_Account__c ra: requestPm.serviceAccountPms){
				String key = String.Format('{0}|{1}', new List<String>{ ra.TM_Service_Request__c, ra.Eb_Account__c});
				accountLookup.put(key, ra);
			}
		}

		if(requestPm.serviceContactPms != null && smSvcContacts != null && smSvcContacts.size()>0){
			for(Tm_Service_Request_Contact__c rc: smSvcContacts){
				String key = String.Format('{0}|{1}', new List<String>{rc.Tm_Service_Request__c, rc.Contact__c});
				if(contactLookup.containsKey(key)){
					if(rc.id == null){
						rc.id = contactLookup.get(key).id;
					}
				}
			}
		}
		
		if(requestPm.serviceAccountPms != null && smSvcAccounts != null && smSvcAccounts.size()>0){
			for(Tm_Service_Request_Account__c ra: smSvcAccounts){
				String key = String.Format('{0}|{1}', new List<String>{ra.Tm_Service_Request__c, ra.Eb_Account__c});
				if(accountLookup.containsKey(key)){
					if(ra.id == null){
						ra.id = accountLookup.get(key).id;
					}
				}
			}
		}

		sm.contactRelationships = uniqueContacts(smSvcContacts);
		sm.accountRelationships = uniqueAccounts(smSvcAccounts);

		return sm;
	}

	private List<Tm_Service_Request_Contact__c> uniqueContacts(List<Tm_Service_Request_Contact__c> contacts){
		List<Tm_Service_Request_Contact__c> contactFiltered = new List<Tm_Service_Request_Contact__c>();
		if(contacts == null){return contactFiltered;}
		Map<string, Tm_Service_Request_Contact__c> filter = new Map<string, Tm_Service_Request_Contact__c>();
		for(Tm_Service_Request_Contact__c rel: contacts){
			String key = getKey(rel.Tm_Service_Request__c, rel.Contact__c);
			if(!filter.containsKey(key)){
				contactFiltered.add(rel);
				filter.put(key, rel);
			}
		}
		return contactFiltered;
	}

	private List<Tm_Service_Request_Account__c> uniqueAccounts(List<Tm_Service_Request_Account__c> accounts){
		List<Tm_Service_Request_Account__c> accountFiltered = new List<Tm_Service_Request_Account__c>();
		if(accounts == null){return accountFiltered;}
		Map<string, Tm_Service_Request_Account__c> filter = new Map<string, Tm_Service_Request_Account__c>();
		for(Tm_Service_Request_Account__c rel: accounts){
			String key = getKey(rel.Tm_Service_Request__c, rel.Eb_Account__c);
			if(!filter.containsKey(key)){
				accountFiltered.add(rel);
				filter.put(key, rel);
			}
		}
		return accountFiltered;
	}

	private List<Tm_Service_Request_Contact__c> getSmSvcContacts(TmBoarding.RelatedSm sm){
		Map<string, Tm_Service_Request_Contact__c> filtered = new Map<string, Tm_Service_Request_Contact__c>();
		if(sm.contactRelationships == null) return filtered.values();
		for(Tm_Service_Request_Contact__c c : sm.contactRelationships){
			String key =  String.Format('{0}|{1}', new List<String>{c.Tm_Service_Request__c, c.Contact__c});
			if(filtered.containsKey(key)){
				filtered.remove(key);
			}
			filtered.put(key,c);
		}
		return filtered.values();
	}

	private List<Tm_Service_Request_Account__c> getSmSvcAccounts(TmBoarding.RelatedSm sm){
		Map<string, Tm_Service_Request_Account__c> filtered = new Map<string, Tm_Service_Request_Account__c>();
		if(sm.accountRelationships == null) return filtered.values();
		for(Tm_Service_Request_Account__c c : sm.accountRelationships){
			String key =  String.Format('{0}|{1}', new List<String>{c.Tm_Service_Request__c, c.EB_Account__c});
			if(filtered.containsKey(key)){
				filtered.remove(key);
			}
			filtered.put(key,c);
		}
		return filtered.values();
	}
	
	private string getKey(string first, string second){
		return String.Format('{0}-{1}', new List<string>{first, second});
	}
}