public with sharing class PrimaryRelationshipBatchUpdDataProv implements PrimaryRelationshipBatchUpdDataProv.IPrimaryRelationshipBatchUpdDataProv{

	public interface IPrimaryRelationshipBatchUpdDataProv {
		void updateAccounts(List<Account> accts);
		void updateContacts(List<Contact> contacts);
	}

	public void updateAccounts(List<Account> accts){
		update accts;
	}
	
	public void updateContacts(List<Contact> contacts){
		update contacts;
	}


}