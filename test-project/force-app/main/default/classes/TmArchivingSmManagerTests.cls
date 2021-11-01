@isTest
private class TmArchivingSmManagerTests {
	
	private static final TmArchivingSmManager sut;
	
	static {
		sut = new TmArchivingSmManager();
	}

	private static testMethod void it_should_get_tms() {
		Treasury_Management__c tmObj = new Treasury_Management__c();
		tmObj.Id = ObjectFactory.getFakeId(Treasury_Management__c.SObjectType, '1');
		TmArchiving.TreasuryManagementSm sm = new TmArchiving.TreasuryManagementSm();
		sm.core = tmObj;

		List<TmArchiving.TreasuryManagementSm> sms = new List<TmArchiving.TreasuryManagementSm>{sm};

		List<SObject> result = sut.getTms(sms);

		System.assertEquals(1, result.size());
		System.assertEquals(tmObj.Id, result[0].Id);
		System.assertEquals(Treasury_Management__c.SObjectType, result[0].getSObjectType());		
	}

	private static testMethod void it_should_get_contacts_and_accounts() {
		Treasury_Management__c tmObj = new Treasury_Management__c();
		tmObj.Id = ObjectFactory.getFakeId(Treasury_Management__c.SObjectType, '1');
		TM_Service_Contact__c contact = new TM_Service_Contact__c();
		EB_Account_Service__c account = new EB_Account_Service__c();
		List<TM_Service_Contact__c> contactObjs = new List<TM_Service_Contact__c>{contact};
		List<EB_Account_Service__c> accountObjs = new List<EB_Account_Service__c>{account};
		TmArchiving.TreasuryManagementSm sm = new TmArchiving.TreasuryManagementSm();

		sm.core = tmObj;
		sm.contacts = contactObjs;
		sm.accounts = accountObjs;

		List<TmArchiving.TreasuryManagementSm> sms = new List<TmArchiving.TreasuryManagementSm>{sm};

		List<SObject> result = sut.getContactsAndAccounts(sms);

		System.assertEquals(2, result.size());
		System.assertEquals(TM_Service_Contact__c.SObjectType, result[0].getSObjectType());		
		System.assertEquals(EB_Account_Service__c.SObjectType, result[1].getSObjectType());		
		System.assertEquals(tmObj.Id, ((TM_Service_Contact__c)result[0]).Treasury_Management_Service__c);
		System.assertEquals(tmObj.Id, ((EB_Account_Service__c)result[1]).TM_Service__c);
	}

	private static testMethod void it_should_get_entities() {
		TmArchiving.TreasuryManagementSm sm1 = new TmArchiving.TreasuryManagementSm();
		sm1.Entity = new Account(Name='account1');
		TmArchiving.TreasuryManagementSm sm2 = new TmArchiving.TreasuryManagementSm();
		sm2.Entity = new Account(Name='account2');
		List<TmArchiving.TreasuryManagementSm> sms = new List<TmArchiving.TreasuryManagementSm>{sm1, sm2};

		List<SObject> result = sut.getEntities(sms);

		System.assertEquals('account1' ,((Account)result[0]).Name);
		System.assertEquals('account2' ,((Account)result[1]).Name);
	}

	private static testMethod void it_should_build_archive_objs_for_insert_when_request_id_and_tm_objs(){

		Id requestId = ObjectFactory.getFakeId(Tm_Service_Request__c.SObjectType, '1');
		Id tmId = ObjectFactory.getFakeId(Treasury_Management__c.SObjectType, '1');
		Treasury_Management__c tm = new Treasury_Management__c(Id=tmId);
		List<Treasury_Management__c> tms = new List<Treasury_Management__c>();
		tms.add(tm);

		List<SOBject> result = sut.getArchives(requestId, tms);

		List<Tm_Service_Request_Archive__c> resultArchives = (List<Tm_Service_Request_Archive__c>) result;
		System.assertEquals(1, result.size());
		System.assertEquals(1, resultArchives.size());
		System.assertEquals(requestId, resultArchives[0].Tm_Service_Request__c);
		System.assertEquals(tmId, resultArchives[0].Treasury_Management_Service__c);
		System.assertEquals(null, resultArchives[0].Id);
	}
}