global class PrimaryRelationshipBatchUpdate implements Database.Batchable<sObject> {
	
	String query = 'SELECT Id, Primary_Relationship__c,OwnerId, (SELECT Id, OwnerId FROM Contacts) FROM Account';

	private PrimaryRelationshipBatchUpdDataProv.IPrimaryRelationshipBatchUpdDataProv m_dataProv;
	private ParentRelationshipSvc.IParentRelationshipSvc m_parentRelationshipSvc;

	global PrimaryRelationshipBatchUpdate() {
		ParentRelationshipSvc parentRelSvc = new ParentRelationshipSvc();
		PrimaryRelationshipBatchUpdDataProv dataProv = new PrimaryRelationshipBatchUpdDataProv();
		initialize(dataProv, parentRelSvc);
	}
	
	public PrimaryRelationshipBatchUpdate(PrimaryRelationshipBatchUpdDataProv.IPrimaryRelationshipBatchUpdDataProv dataProv, ParentRelationshipSvc.IParentRelationshipSvc parentRelSvc) {
		initialize(dataProv, parentRelSvc);
	}

	private void initialize(PrimaryRelationshipBatchUpdDataProv.IPrimaryRelationshipBatchUpdDataProv dataProv, ParentRelationshipSvc.IParentRelationshipSvc parentRelSvc){
		m_parentRelationshipSvc = parentRelSvc;
		m_dataProv = dataProv;
	}

	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<Account> scope) {
		List<Contact> contactsToUpdate = new List<Contact>();
		for(Account acct : scope){
			acct.Relationship_Change_Ignore_Validation__c = true;
			m_parentRelationshipSvc.setTopLevelParentForEntity(acct);
			contactsToUpdate.addAll(acct.Contacts);
		}
		m_dataProv.updateAccounts(scope);
		if(contactsToUpdate.size() > 0){
			m_dataProv.updateContacts(contactsToUpdate);
		}
	}
	
	global void finish(Database.BatchableContext BC) {
		
	}
}