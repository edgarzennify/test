@IsTest
private class CreditRelationshipDataTests {

	private static final CreditRelationshipData sut;
	private static final MockIDataModelBuilder m_mockBuilder;
    private static final Mock.ofIUtility m_mockUtility;
   
    static {
    	m_mockBuilder = new MockIDataModelBuilder();
        m_mockUtility = new Mock.ofIUtility();
    	sut = new CreditRelationshipData(m_mockBuilder, m_mockUtility);
    }

	@IsTest
    static void it_should_get_credit_relationship_by_id() {
		RecordType pmRecordType = Utility.recordTypeObject('Credit_Relationship__c', 'Credit Relationship');
     	Account client = new Account(Name='test');
     	insert client;
     	EB_Account__c pmEbAccount = new EB_Account__c(Name = 'test', Primary_Owner_Id__c = client.Id);
     	insert pmEbAccount;
     	Credit_Relationship__c pmCreditRelationship = new Credit_Relationship__c(RecordTypeId = pmRecordType.Id);
     	insert pmCreditRelationship;
     	Archived_Report__c pmReport = new Archived_Report__c( Name = 'test', Credit_Relationship__c = pmCreditRelationship.Id, Url__c = 'testurl');
     	insert pmReport;
     	pmReport = [SELECT Id , Name , Url__c, OwnerId, CreatedBy.Name FROM Archived_Report__c WHERE Id =: pmReport.Id ];
     	Credit_Relationship_Related_Client__c pmCreditRelationshipClient = new Credit_Relationship_Related_Client__c(Related_Entity_del__c = client.Id, Credit_Relationship__c = pmCreditRelationship.Id );
     	insert pmCreditRelationshipClient;
     	pmCreditRelationshipClient = [SELECT Id, Name, Related_Entity_del__c,Credit_Relationship__c, Related_Entity_del__r.Id,Related_Entity_del__r.Name,
                                        Related_Entity_del__r.billingCity, Related_Entity_del__r.billingState, Related_Entity_del__r.billingStreet, 
                                        Related_Entity_del__r.billingPostalCode FROM Credit_Relationship_Related_Client__c WHERE Id=: pmCreditRelationshipClient.Id];
	    Credit_Relationship_Excluded_Account__c pmCreditRelationshipExcluded = new Credit_Relationship_Excluded_Account__c(EB_Account_Id__c = pmEbAccount.Id, Credit_Relationship_Id__c = pmCreditRelationship.Id);
	    insert pmCreditRelationshipExcluded;
	    pmCreditRelationshipExcluded = [SELECT Id, Name, EB_Account_Id__c, Credit_Relationship_Id__c FROM Credit_Relationship_Excluded_Account__c WHERE Id=: pmCreditRelationshipExcluded.Id];
        Credit_Relationship_Note__c pmNote = new Credit_Relationship_Note__c(Credit_Relationship__c = pmCreditRelationship.Id, Diary__c = 'test');
        insert pmNote;

        DmCreditRelationship dm = new DmCreditRelationship();
        dm.Id = pmCreditRelationship.Id;
        dm.RecordType = new DmRecordType();
        dm.RecordType.Id = pmCreditRelationship.recordType.Id;

        m_mockBuilder.setup('buildDmCreditRelationship', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(dm);

        pmNote = [SELECT Id, Name, Credit_Relationship__c, Diary__c FROM Credit_Relationship_Note__c WHERE Id =:pmNote.Id];

     	pmCreditRelationship = [SELECT 
	                                   Id , Name, RecordType.Name, RecordTypeID
	                                   ,(SELECT Id, Name, Url__c, OwnerId, Credit_Relationship__c, CreatedDate, CreatedBy.name FROM Archived_Reports__r)
	                                   ,(SELECT Id , Name, Credit_Relationship__c, Related_Entity_del__c, Related_Entity_del__r.Id,Related_Entity_del__r.Name,
                                        Related_Entity_del__r.billingCity, Related_Entity_del__r.billingState, Related_Entity_del__r.billingStreet, 
                                        Related_Entity_del__r.billingPostalCode FROM Credit_Relationship_Related_Clients__r)
	                                   ,(SELECT Id,Name, Credit_Relationship_Id__c, EB_Account_Id__c,EB_Account_Id__r.Name FROM Credit_Relationship_Excluded_Accounts__r)
	                                   ,(SELECT Id,Name,Credit_Relationship__c, Diary__c, Situation_Flag__c, CreatedDate, OwnerId, RecordType.Id, RecordType.Name, RecordTypeId FROM Credit_Relationship_Notes__r)
	                              FROM Credit_Relationship__c
	                              WHERE Id =: pmCreditRelationship.Id];

		DmCreditRelationship result = sut.getCreditRelationshipById(pmCreditRelationship.Id);

		m_mockBuilder.verify('buildDmCreditRelationship', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
		System.assertEquals(dm.Id,result.Id);
		System.assertEquals(dm.RecordType.Id,result.RecordType.Id);
	}

	@IsTest
    static void it_should_get_relationship_data() {
		RecordType pmRecordType = Utility.recordTypeObject('Credit_Relationship__c', 'Credit Relationship');
		List<DmCreditRelationshipRelatedEntity> relatedEntities = new List<DmCreditRelationshipRelatedEntity>();
		Account pmEntity = new Account(Name='test');
     	insert pmEntity;

     	EB_Account__c pmEbAccount = new EB_Account__c(Name = 'test', Primary_Owner_Id__c = pmEntity.Id);
     	insert pmEbAccount;
     	Credit_Relationship__c pmCreditRelationship = new Credit_Relationship__c(RecordTypeId = pmRecordType.Id);
     	insert pmCreditRelationship;
     	Credit_Relationship_Related_Client__c pmCreditRelationshipClient = new Credit_Relationship_Related_Client__c(Related_Entity_del__c = pmEntity.Id, Credit_Relationship__c = pmCreditRelationship.Id );
     	insert pmCreditRelationshipClient;
     	EB_Account_Relationship__c accountRelPm = new EB_Account_Relationship__c(Client_Id__c = pmEntity.Id,EB_Account_Id__c = pmEbAccount.Id);
     	insert accountRelPm;
     	pmEntity = [SELECT Id, Name
     	                   ,(SELECT EB_Account_Id__c,
		                        EB_Account_Id__r.Id,
		                        EB_Account_Id__r.Name,
		                        EB_Account_Id__r.Primary_Owner_Id__r.Name
	                        FROM EB_Account_Relationships__r)
     	            FROM Account
     	            WHERE Id =: pmEntity.Id
     	            ];
		DmCreditRelationshipRelatedEntity dm = new DmCreditRelationshipRelatedEntity();
		dm.id = pmCreditRelationshipClient.Id;
		dm.entity = new DmEntity();
		dm.entity.Id = pmEntity.Id;
		dm.entity.name = pmEntity.Name;
		relatedEntities.add(dm);
		List<DmEbAccount> ebaccountDms = new List<DmEbAccount>();
		DmEbAccount dmEbAccount = new DmEbAccount();
		dmEbAccount.Id = pmEbAccount.Id;
		dmEbAccount.name = pmEbAccount.name;
		ebaccountDms.add(dmEbAccount);
		List<Eb_Account__c> ebAccountPms = new List<Eb_Account__c>();
		pmEbAccount = [SELECT Name, Current_Commitment__c, Primary_Owner_Id__c, Id FROM EB_Account__c WHERE Id =:pmEbAccount.Id];
     	ebAccountPms.add(pmEbAccount);
		m_mockBuilder.setup('buildDmEbAccounts', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(ebaccountDms);

		List<DmEbAccount> results = sut.getRelatedAccounts(relatedEntities);

		m_mockBuilder.verify('buildDmEbAccounts', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
		system.assertEquals(1, results.size());
		system.assertEquals(pmEbAccount.Id, results[0].Id);
        //Needs callback test
	}

	@IsTest
    static void it_should_get_possible_related_entities() {
		RecordType pmRecordType = Utility.recordTypeObject('Credit_Relationship__c', 'Credit Relationship');
		List<DmCreditRelationshipRelatedEntity> relatedEntities = new List<DmCreditRelationshipRelatedEntity>();
		Account pmEntity = new Account(Name='test Entity 1');
     	insert pmEntity;
     	Account pmEntityNoRelationship = new Account(Name='Test Entity 2');
     	insert pmEntityNoRelationship;
     	EB_Account__c pmEbAccount = new EB_Account__c(Name = '1000-2', Primary_Owner_Id__c = pmEntity.Id);
     	insert pmEbAccount;
     	Credit_Relationship__c pmCreditRelationship = new Credit_Relationship__c(RecordTypeId = pmRecordType.Id);
     	insert pmCreditRelationship;
     	Credit_Relationship_Related_Client__c pmCreditRelationshipClient = new Credit_Relationship_Related_Client__c(Related_Entity_del__c = pmEntity.Id, Credit_Relationship__c = pmCreditRelationship.Id );
     	insert pmCreditRelationshipClient;
     	EB_Account_Relationship__c accountRelPm = new EB_Account_Relationship__c(Client_Id__c = pmEntity.Id,EB_Account_Id__c = pmEbAccount.Id);
     	insert accountRelPm;
     	pmEntity = [SELECT Id, 
		                    Name, 
		                    BillingStreet, 
		                    BillingCity, 
		                    BillingState, 
		                    BillingPostalCode, 
		                    Record_Type_Description__c
     	                   ,(SELECT Client_Id__c, Client_Id__r.Name 
	                        FROM EB_Account_Relationships__r)
     	            FROM Account
     	            WHERE Id =: pmEntity.Id
     	            ];
     	pmEntityNoRelationship = [SELECT Id, 
		                    Name, 
		                    BillingStreet, 
		                    BillingCity, 
		                    BillingState, 
		                    BillingPostalCode, 
		                    Record_Type_Description__c
     	                   ,(SELECT Client_Id__c, Client_Id__r.Name 
	                        FROM EB_Account_Relationships__r)
     	            FROM Account
     	            WHERE Id =: pmEntityNoRelationship.Id
     	            ];
		DmCreditRelationshipRelatedEntity dmrelated1 = new DmCreditRelationshipRelatedEntity();
		dmrelated1.id = pmCreditRelationshipClient.Id;
		dmrelated1.entity = new DmEntity();
		dmrelated1.entity.Id = pmEntityNoRelationship.Id;
		dmrelated1.entity.name = pmEntityNoRelationship.Name;
		relatedEntities.add(dmrelated1);

		List<DmEbAccount> relatedAccounts = new List<DmEbAccount>();
		DmEbAccount dmEbAccount = new DmEbAccount();
		dmEbAccount.Id = pmEbAccount.Id;
		dmEbAccount.name = pmEbAccount.name;
		relatedAccounts.add(dmEbAccount);

		List<DmEntity> dmEntities = new List<DmEntity>();
		DmEntity entity = new DmEntity();
		dmEntities.add(entity);

     	List<Account> entityPms = new List<Account>();
     	entityPms.add(pmEntity);
     	m_mockBuilder.setup('buildDmEntities', new List<Object>{entityPms}).returns(dmEntities);

		List<DmEntity> results = sut.getPossibleRelatedEntities(relatedAccounts, relatedEntities);

		m_mockBuilder.verify('buildDmEntities', new List<Object>{entityPms}, Times.Once);
    }

    @IsTest
    static void it_should_delete_note_when_id_is_provided() {
    	RecordType pmRecordType = Utility.recordTypeObject('Credit_Relationship__c', 'Credit Relationship');
     	Account client = new Account(Name='test');
     	insert client;
     	EB_Account__c pmEbAccount = new EB_Account__c(Name = 'test', Primary_Owner_Id__c = client.Id);
     	insert pmEbAccount;
     	Credit_Relationship__c pmCreditRelationship = new Credit_Relationship__c(RecordTypeId = pmRecordType.Id);
     	insert pmCreditRelationship;
     	Archived_Report__c pmReport = new Archived_Report__c( Name = 'test', Credit_Relationship__c = pmCreditRelationship.Id, Url__c = 'testurl');
     	insert pmReport;
     	pmReport = [SELECT Id , Name , Url__c, OwnerId, CreatedBy.Name FROM Archived_Report__c WHERE Id =: pmReport.Id ];
     	Credit_Relationship_Related_Client__c pmCreditRelationshipClient = new Credit_Relationship_Related_Client__c(Related_Entity_del__c = client.Id, Credit_Relationship__c = pmCreditRelationship.Id );
     	insert pmCreditRelationshipClient;
     	pmCreditRelationshipClient = [SELECT Id, Name, Related_Entity_del__c,Credit_Relationship__c, Related_Entity_del__r.Id,Related_Entity_del__r.Name,
                                        Related_Entity_del__r.billingCity, Related_Entity_del__r.billingState, Related_Entity_del__r.billingStreet, 
                                        Related_Entity_del__r.billingPostalCode FROM Credit_Relationship_Related_Client__c WHERE Id=: pmCreditRelationshipClient.Id];
	    Credit_Relationship_Excluded_Account__c pmCreditRelationshipExcluded = new Credit_Relationship_Excluded_Account__c(EB_Account_Id__c = pmEbAccount.Id, Credit_Relationship_Id__c = pmCreditRelationship.Id);
	    insert pmCreditRelationshipExcluded;
	    pmCreditRelationshipExcluded = [SELECT Id, Name, EB_Account_Id__c, Credit_Relationship_Id__c FROM Credit_Relationship_Excluded_Account__c WHERE Id=: pmCreditRelationshipExcluded.Id];
        Credit_Relationship_Note__c pmNote = new Credit_Relationship_Note__c(Credit_Relationship__c = pmCreditRelationship.Id, Diary__c = 'test');
        insert pmNote;
        
        sut.deleteNote(pmNote.Id);
        
        List<Credit_Relationship_Note__c> resultQuery = [SELECT Id FROM Credit_Relationship_Note__c WHERE Id =:pmNote.Id];
        system.assertEquals(0, resultQuery.size());
    }

    @IsTest
    static void it_should_delete_related_entity_when_id_is_provided() {
    	RecordType pmRecordType = Utility.recordTypeObject('Credit_Relationship__c', 'Credit Relationship');
     	Account client = new Account(Name='test');
     	insert client;
     	EB_Account__c pmEbAccount = new EB_Account__c(Name = 'test', Primary_Owner_Id__c = client.Id);
     	insert pmEbAccount;
     	Credit_Relationship__c pmCreditRelationship = new Credit_Relationship__c(RecordTypeId = pmRecordType.Id);
     	insert pmCreditRelationship;
     	Credit_Relationship_Related_Client__c pmCreditRelationshipClient = new Credit_Relationship_Related_Client__c(Related_Entity_del__c = client.Id, Credit_Relationship__c = pmCreditRelationship.Id );
     	insert pmCreditRelationshipClient;
     	pmCreditRelationshipClient = [SELECT Id, Name, Related_Entity_del__c,Credit_Relationship__c, Related_Entity_del__r.Id,Related_Entity_del__r.Name,
                                        Related_Entity_del__r.billingCity, Related_Entity_del__r.billingState, Related_Entity_del__r.billingStreet, 
                                        Related_Entity_del__r.billingPostalCode FROM Credit_Relationship_Related_Client__c WHERE Id=: pmCreditRelationshipClient.Id];
	    
        sut.deleteRelatedEntity(pmCreditRelationshipClient.Id);
        
        List<Credit_Relationship_Related_Client__c> resultQuery = [SELECT Id FROM Credit_Relationship_Related_Client__c WHERE Id =: pmCreditRelationshipClient.Id];
        system.assertEquals(0, resultQuery.size());
    }
    
    @IsTest
    static void it_should_delete_excluded_ebaccount_when_id_is_provided() {
    	RecordType pmRecordType = Utility.recordTypeObject('Credit_Relationship__c', 'Credit Relationship');
     	Account client = new Account(Name='test');
     	insert client;
     	EB_Account__c pmEbAccount = new EB_Account__c(Name = 'test', Primary_Owner_Id__c = client.Id);
     	insert pmEbAccount;
     	Credit_Relationship__c pmCreditRelationship = new Credit_Relationship__c(RecordTypeId = pmRecordType.Id);
     	insert pmCreditRelationship;
     	Credit_Relationship_Related_Client__c pmCreditRelationshipClient = new Credit_Relationship_Related_Client__c(Related_Entity_del__c = client.Id, Credit_Relationship__c = pmCreditRelationship.Id );
     	insert pmCreditRelationshipClient;
     	pmCreditRelationshipClient = [SELECT Id, Name, Related_Entity_del__c,Credit_Relationship__c, Related_Entity_del__r.Id,Related_Entity_del__r.Name,
                                        Related_Entity_del__r.billingCity, Related_Entity_del__r.billingState, Related_Entity_del__r.billingStreet, 
                                        Related_Entity_del__r.billingPostalCode FROM Credit_Relationship_Related_Client__c WHERE Id=: pmCreditRelationshipClient.Id];
	    
	    Credit_Relationship_Excluded_Account__c pmCreditRelationshipExcluded = new Credit_Relationship_Excluded_Account__c(EB_Account_Id__c = pmEbAccount.Id, Credit_Relationship_Id__c = pmCreditRelationship.Id);
	    insert pmCreditRelationshipExcluded;
	    pmCreditRelationshipExcluded = [SELECT Id, Name, EB_Account_Id__c, Credit_Relationship_Id__c FROM Credit_Relationship_Excluded_Account__c WHERE Id=: pmCreditRelationshipExcluded.Id];
        
        sut.deleteExcludedEbAccount(pmCreditRelationshipExcluded.Id);
        
        List<Credit_Relationship_Excluded_Account__c> resultQuery = [SELECT Id FROM Credit_Relationship_Excluded_Account__c WHERE Id =:pmCreditRelationshipExcluded.Id];
        
        system.assertEquals(0, resultQuery.size());
    }
    
    @IsTest
    static void it_should_set_the_situation_flag_to_true_for_all_the_notes_that_match_the_given_ids() {
        RecordType pmRecordType = Utility.recordTypeObject('Credit_Relationship__c', 'Credit Relationship');
        Credit_Relationship__c pmCreditRelationship = new Credit_Relationship__c(RecordTypeId = pmRecordType.Id);
        insert pmCreditRelationship;
        Credit_Relationship_Note__c pmNote1 = new Credit_Relationship_Note__c(Credit_Relationship__c = pmCreditRelationship.Id, Diary__c = 'test1');
        insert pmNote1;
        Credit_Relationship_Note__c pmNote2 = new Credit_Relationship_Note__c(Credit_Relationship__c = pmCreditRelationship.Id, Diary__c = 'test2');
        insert pmNote2;
        List<Id> pmNoteIds = new List<Id>{pmNote1.Id, pmNote2.Id};
              
        sut.lockNotesById(pmNoteIds);
        
        List<Credit_Relationship_Note__c> resultQuery = [SELECT Situation_Flag__c FROM Credit_Relationship_Note__c WHERE Id in:pmNoteIds];
        System.assertEquals(true, resultQuery[0].Situation_Flag__c);
        System.assertEquals(true, resultQuery[1].Situation_Flag__c);
    }
    
    @IsTest
    static void it_should_accept_a_archivedreport_sm_and_save_the_corresponding_pm_and_return_the_pm_id() {
        RecordType pmRecordType = Utility.recordTypeObject('Credit_Relationship__c', 'Credit Relationship');
        Credit_Relationship__c pmCreditRelationship = new Credit_Relationship__c(RecordTypeId = pmRecordType.Id);
        insert pmCreditRelationship;
        CreditRelationship.ArchivedReportSm sm = new CreditRelationship.ArchivedReportSm();
        sm.creditRelationshipId = pmCreditRelationship.Id;
        sm.Name = 'test';
        
        Id result = sut.addArchivedReport(sm);
        
        Archived_Report__c resultQuery = [SELECT Id, Name, Credit_Relationship__c FROM Archived_Report__c WHERE Id =:result];
        system.assertEquals(sm.Name, resultQuery.Name);
        system.assertEquals(sm.creditRelationshipId, resultQuery.Credit_Relationship__c);
    }
    
    @IsTest
    static void it_should_add_a_related_entity_pm_when_a_related_entity_sm_is_provided() {
        Account entity = new Account(Name='test');
     	insert entity;
        RecordType pmRecordType = Utility.recordTypeObject('Credit_Relationship__c', 'Credit Relationship');
        Credit_Relationship__c pmCreditRelationship = new Credit_Relationship__c(RecordTypeId = pmRecordType.Id);
        insert pmCreditRelationship;
        CreditRelationship.RelatedEntitySm sm = new CreditRelationship.RelatedEntitySm();
        sm.entityId = entity.Id;
        sm.creditRelationshipId = pmCreditRelationship.Id;
        
        sut.addRelatedEntity(sm);
        
        Credit_Relationship_Related_Client__c resultQuery = [SELECT Related_Entity_del__c , Credit_Relationship__c  FROM Credit_Relationship_Related_Client__c WHERE Related_Entity_del__c =:sm.entityId and Credit_Relationship__c =:sm.creditRelationshipId ];
        system.assertEquals(sm.entityId, resultQuery.Related_Entity_del__c);
        system.assertEquals(sm.creditRelationshipId, resultQuery.Credit_Relationship__c);
    }
    
    @IsTest
    static void it_should_add_a_excluded_entity_pm_when_a_excluded_entity_sm_is_provided() {
        RecordType pmRecordType = Utility.recordTypeObject('Credit_Relationship__c', 'Credit Relationship');
     	Account client = new Account(Name='test');
     	insert client;
     	EB_Account__c pmEbAccount = new EB_Account__c(Name = 'test', Primary_Owner_Id__c = client.Id);
     	insert pmEbAccount;
     	Credit_Relationship__c pmCreditRelationship = new Credit_Relationship__c(RecordTypeId = pmRecordType.Id);
     	insert pmCreditRelationship;
        CreditRelationship.ExcludedAccountSm sm = new CreditRelationship.ExcludedAccountSm();
        sm.creditRelationshipId = pmCreditRelationship.Id;
        sm.accountId = pmEbAccount.Id;
                
        sut.addExcludedAccount(sm);
		
        Credit_Relationship_Excluded_Account__c resultQuery = [SELECT EB_Account_Id__c, Credit_Relationship_Id__c FROM Credit_Relationship_Excluded_Account__c WHERE EB_Account_Id__c =: sm.accountId and Credit_Relationship_Id__c =: sm.creditRelationshipId];
   	    system.assertEquals(sm.accountId, resultQuery.EB_Account_Id__c);
        system.assertEquals(sm.creditRelationshipId, resultQuery.Credit_Relationship_Id__c);
    }
    
    @IsTest
    static void it_should_add_a_note_pm_when_a_note_sm_is_provided() {
        RecordType pmRecordType = Utility.recordTypeObject('Credit_Relationship__c', 'Credit Relationship');
     	Credit_Relationship__c pmCreditRelationship = new Credit_Relationship__c(RecordTypeId = pmRecordType.Id);
     	insert pmCreditRelationship;
        CreditRelationship.NoteSm sm = new CreditRelationship.NoteSm();
		sm.type = CreditRelationship.NoteType.minute;        
        sm.creditRelationshipId = pmCreditRelationship.Id; 
        sm.diary = 'test';
        RecordType analysisRecordType = Utility.recordTypeObject('Credit_Relationship_Note__c', 'Analysis');
        m_mockUtility.setup('recordTypeObject', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(analysisRecordType);
              
        sut.addNote(sm);
		
        m_mockUtility.verify('recordTypeObject', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
        Credit_Relationship_Note__c resultQuery = [SELECT  Credit_Relationship__c, Diary__c FROM Credit_Relationship_Note__c WHERE Credit_Relationship__c =: sm.creditRelationshipId];
   	    system.assertEquals(sm.diary, resultQuery.Diary__c);
        system.assertEquals(sm.creditRelationshipId, resultQuery.Credit_Relationship__c);
    }
    
	public class MockIDataModelBuilder extends ApexMoq implements CreditRelationship.IDataModelBuilder{
		public DmCreditRelationship buildDmCreditRelationship(Credit_Relationship__c pm){
			return (DmCreditRelationship)handleMethodInvocation('buildDmCreditRelationship', new List<Object>{pm});
		}
		public List<DmEbAccount> buildDmEbAccounts(List<EB_Account__c> pms){
			return (List<DmEbAccount>)handleMethodInvocation('buildDmEbAccounts', new List<Object>{pms});
		}
		public List<DmCreditRelationshipExcludedAccount> buildDmCreditRelationshipExcludedAccounts(List<Credit_Relationship_Excluded_Account__c> pms){
			return (List<DmCreditRelationshipExcludedAccount>)handleMethodInvocation('buildDmCreditRelationshipExcludedAccounts', new List<Object>{pms});
		}
		public List<DmArchivedReport> buildDmArchivedReports(List<Archived_Report__c> pms){
			return (List<DmArchivedReport>)handleMethodInvocation('buildDmArchivedReports', new List<Object>{pms});
		}
		public List<DmCreditRelationshipRelatedEntity> buildDmCreditRelationshipRelatedEntities(List<Credit_Relationship_Related_Client__c> pms){
			return (List<DmCreditRelationshipRelatedEntity>)handleMethodInvocation('buildDmCreditRelationshipRelatedEntities', new List<Object>{pms});
		}
		public List<DmCreditRelationshipNote> buildDmCreditRelationshipNotes(List<Credit_Relationship_Note__c> pms){
			return (List<DmCreditRelationshipNote>)handleMethodInvocation('buildDmCreditRelationshipNotes', new List<Object>{pms});
		}
		public List<DmEntity> buildDmEntities(List<Account> pms){
			return (List<DmEntity>)handleMethodInvocation('buildDmEntities', new List<Object>{pms});
		}
	}
}