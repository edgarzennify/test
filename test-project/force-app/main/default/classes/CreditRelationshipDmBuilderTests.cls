@IsTest
private class CreditRelationshipDmBuilderTests {
    
    private static final CreditRelationshipDmBuilder sut;

    static{
        sut = new CreditRelationshipDmBuilder();
    }

    private static testMethod void it_should_build_a_dm_credit_relationship_with_id_and_recordtype_filled_when_a_pm_is_provided()
    {
        Credit_relationship__c pm = new Credit_relationship__c();
        RecordType pmRecordType = Utility.recordTypeObject('Credit_Relationship__c', 'Credit Relationship');
        pm.RecordTypeId = pmRecordType.Id;
        insert pm;
        pm = SoqlResults(pm);

        DmCreditRelationship result = sut.buildDmCreditRelationship(pm);

        system.assertEquals(pm.Id , result.id);
        system.assertEquals(pm.RecordTypeId , result.recordType.id);
        system.assertEquals(pm.RecordType.Name , result.recordType.name);
    }

    private static testMethod void it_should_build_a_dm_credit_relationship_with_archived_reports_when_pm_is_provided()
    {
        Credit_Relationship__c pm = new Credit_Relationship__c();
        insert pm;
        Archived_Report__c pmArchivedReport = new Archived_Report__c();
        pmArchivedReport.Name = 'test';
        pmArchivedReport.url__c = 'http://test.com';
        pmArchivedReport.Credit_Relationship__c =  pm.Id;
        insert pmArchivedReport;
        pm = SoqlResults(pm);
        List<Archived_Report__c> reports = pm.Archived_Reports__r;

        DmCreditRelationship result = sut.buildDmCreditRelationship(pm);

        system.assertEquals(1, result.archivedReports.size());
        system.assertEquals(reports[0].Id, result.archivedReports[0].id);
        system.assertEquals(reports[0].Name, result.archivedReports[0].name);
        system.assertEquals(reports[0].Url__c, result.archivedReports[0].url);
        system.assertEquals(reports[0].OwnerId, result.archivedReports[0].createdBy.id);
        system.assertEquals(reports[0].CreatedBy.Name, result.archivedReports[0].createdBy.name);
        system.assertEquals(reports[0].CreatedDate, result.archivedReports[0].CreatedDate);
        system.assertEquals(reports[0].Credit_Relationship__c, result.archivedReports[0].creditrelationship.Id);
    }

    private static testMethod void it_should_build_a_dm_credit_relationship_with_relatedentities_when_creditrelationship_pm_is_provided()
    {
        Credit_Relationship__c pm = new Credit_Relationship__c();
        insert pm;
        Account entity = new Account(Name = 'test',billingCity = 'city',billingState = 'state',billingStreet = 'street',billingPostalCode = 'post' );
        insert entity;
        Credit_Relationship_Related_Client__c pmRelatedClient = new Credit_Relationship_Related_Client__c();
        pmRelatedClient.Related_Entity_del__c = entity.Id;
        pmRelatedClient.Credit_Relationship__c = pm.Id;
        insert pmRelatedClient;
        pm = SoqlResults(pm);
        List<Credit_Relationship_Related_Client__c> relatedEntities = pm.Credit_Relationship_Related_Clients__r;

        DmCreditRelationship result = sut.buildDmCreditRelationship(pm);

        System.assertEquals(relatedEntities[0].Id , result.relatedEntities[0].id);
        System.assertEquals(relatedEntities[0].Name , result.relatedEntities[0].name);
        System.assertEquals(relatedEntities[0].Credit_Relationship__c , result.relatedEntities[0].creditRelationship.id);
        System.assertEquals(relatedEntities[0].Related_Entity_del__c , result.relatedEntities[0].entity.id);
        System.assertEquals(relatedEntities[0].Related_Entity_del__r.Name , result.relatedEntities[0].entity.name);
        System.assertEquals(relatedEntities[0].Related_Entity_del__r.billingCity , result.relatedEntities[0].entity.billingCity);
        System.assertEquals(relatedEntities[0].Related_Entity_del__r.billingState , result.relatedEntities[0].entity.billingState);
        System.assertEquals(relatedEntities[0].Related_Entity_del__r.billingStreet , result.relatedEntities[0].entity.billingStreet);
        System.assertEquals(relatedEntities[0].Related_Entity_del__r.billingPostalCode , result.relatedEntities[0].entity.billingPostalCode);       
    }

    private static testMethod void it_should_build_a_dm_credit_relationship_with_relatednotes_when_creditrelationship_pm_is_provided()
    {
        RecordType noteRecordType = Utility.recordTypeObject('Credit_Relationship_Note__c', 'Analysis');
        Credit_Relationship__c pm = new Credit_Relationship__c();
        insert pm;
        Credit_Relationship_Note__c pmNote = new Credit_Relationship_Note__c(Credit_Relationship__c = pm.Id, Diary__c = 'test diary', Situation_Flag__c = false, RecordTypeId = noteRecordType.Id);
        insert pmNote;
        pm = SoqlResults(pm);
        List<Credit_Relationship_Note__c> notes = pm.Credit_Relationship_Notes__r;

        DmCreditRelationship result = sut.buildDmCreditRelationship(pm);

        System.assertEquals(notes[0].Id , result.notes[0].id);
        System.assertEquals(notes[0].Name , result.notes[0].name);
        System.assertEquals(notes[0].Diary__c , result.notes[0].Diary);
        System.assertEquals(notes[0].Situation_Flag__c , result.notes[0].SituationFlag);
        System.assertEquals(notes[0].RecordTypeId , result.notes[0].recordType.id);
    }

    private static testMethod void it_should_build_a_dm_credit_relationship_with_excludedaccounts_when_a_pm_creditrelationship_is_provided(){
        Credit_Relationship__c pm = new Credit_Relationship__c();
        insert pm;
        Credit_Relationship_Excluded_Account__c excludeAccount = buildTestExcludedAccount(pm.Id);
        insert excludeAccount;
        
        pm = SoqlResults(pm);
        List<Credit_Relationship_Excluded_Account__c> excluded = pm.Credit_Relationship_Excluded_Accounts__r;

        DmCreditRelationship result = sut.buildDmCreditRelationship(pm);

        System.assertEquals(excluded[0].Id , result.excludedAccounts[0].id);
        System.assertEquals(excluded[0].Name , result.excludedAccounts[0].name);
        System.assertEquals(excluded[0].Credit_Relationship_Id__c , result.excludedAccounts[0].creditRelationship.id);
        System.assertEquals(excluded[0].EB_Account_Id__c , result.excludedAccounts[0].ebAccount.id);
        System.assertEquals(excluded[0].EB_Account_Id__r.Name , result.excludedAccounts[0].ebAccount.name);
        System.assertEquals(excluded[0].EB_Account_Id__r.Application__c , result.excludedAccounts[0].ebAccount.application);
        System.assertEquals(excluded[0].EB_Account_Id__r.Account_Number__c , result.excludedAccounts[0].ebAccount.accountNumber);
        System.assertEquals(excluded[0].EB_Account_Id__r.Account_Line_1__c , result.excludedAccounts[0].ebAccount.accountLine1);
        System.assertEquals(excluded[0].EB_Account_Id__r.Account_Status__c , result.excludedAccounts[0].ebAccount.status);
        System.assertEquals(excluded[0].EB_Account_Id__r.User_Code_1__c , result.excludedAccounts[0].ebAccount.riskRating);
        System.assertEquals(excluded[0].EB_Account_Id__r.YTD_Contribution_Margin__c , result.excludedAccounts[0].ebAccount.contributionMargin);
        System.assertEquals(excluded[0].EB_Account_Id__r.Core_Current_Balance__c , result.excludedAccounts[0].ebAccount.coreCurrentBalance);
        System.assertEquals(excluded[0].EB_Account_Id__r.Current_Balance__c , result.excludedAccounts[0].ebAccount.currentBalance);
        System.assertEquals(excluded[0].EB_Account_Id__r.Current_Commitment__c , result.excludedAccounts[0].ebAccount.currentCommitment);
        System.assertEquals(excluded[0].EB_Account_Id__r.Unadvanced_Loan_Amount__c , result.excludedAccounts[0].ebAccount.unadvancedLoanAmount);
        System.assertEquals(excluded[0].EB_Account_Id__r.Primary_Owner_Id__r.Name , result.excludedAccounts[0].ebAccount.primaryOwner.name);
    }   

    private static testMethod void it_should_create_a_dm_eb_accounts_when_a_pm_eb_accounts_are_provided_by_inserting_test_records()
    {
        RecordType pmRecordType = Utility.recordTypeObject('Credit_Relationship__c', 'Credit Relationship');
        Account client = new Account(Name='test');
        insert client;
        EB_Account__c pmEbAccount = new EB_Account__c(Name = 'test', Primary_Owner_Id__c = client.Id);
        insert pmEbAccount;
        List<Eb_Account__c> testEbAccountPms = new List<Eb_Account__c>{pmEbAccount};

        List<DmEbAccount> results = sut.buildDmEbAccounts(testEbAccountPms);

        System.assertEquals(1, results.size());
        System.assertEquals(pmEbAccount.Id, results[0].id);
        System.assertEquals(pmEbAccount.name, results[0].name);
        System.assertEquals(Integer.valueOf(pmEbAccount.Application__c), results[0].application);
        System.assertEquals(pmEbAccount.Account_Number__c, results[0].accountNumber);
        System.assertEquals(pmEbAccount.Account_Line_1__c, results[0].accountLine1);
        System.assertEquals(pmEbAccount.Account_Status__c, results[0].status);
        System.assertEquals(pmEbAccount.User_Code_1__c, results[0].riskRating);
        System.assertEquals(pmEbAccount.YTD_Contribution_Margin__c, results[0].contributionMargin);
        System.assertEquals(pmEbAccount.Core_Current_Balance__c, results[0].coreCurrentBalance);
        System.assertEquals(pmEbAccount.Current_Commitment__c, results[0].currentCommitment);
        System.assertEquals(pmEbAccount.Unadvanced_Loan_Amount__c, results[0].unadvancedLoanAmount);
        System.assertEquals(pmEbAccount.Primary_Owner_Id__r.Name, results[0].primaryOwner.name);
    }

    private static testMethod void it_should_build_a_list_of_dm_excluded_accounts_when_a_list_of_pm_excluded_accounts_is_provided()
    {
        Credit_Relationship__c pmCreditRelationship = new Credit_Relationship__c();
        insert pmCreditRelationship;
        Credit_Relationship_Excluded_Account__c pm = buildTestExcludedAccount(pmCreditRelationship.Id);
        insert pm;
        pmCreditRelationship = SoqlResults(pmCreditRelationship);
        List<Credit_Relationship_Excluded_Account__c> pms = pmCreditRelationship.Credit_Relationship_Excluded_Accounts__r;

        List<DmCreditRelationshipExcludedAccount> results = sut.buildDmCreditRelationshipExcludedAccounts(pms);

        System.assertEquals(pms[0].Id , results[0].id);
        System.assertEquals(pms[0].Name , results[0].name);
        System.assertEquals(pms[0].Credit_Relationship_Id__c , results[0].creditRelationship.id);
        System.assertEquals(pms[0].EB_Account_Id__c , results[0].ebAccount.id);
        System.assertEquals(pms[0].EB_Account_Id__r.Name , results[0].ebAccount.name);
        System.assertEquals(pms[0].EB_Account_Id__r.Application__c , results[0].ebAccount.application);
        System.assertEquals(pms[0].EB_Account_Id__r.Account_Number__c , results[0].ebAccount.accountNumber);
        System.assertEquals(pms[0].EB_Account_Id__r.Account_Line_1__c , results[0].ebAccount.accountLine1);
        System.assertEquals(pms[0].EB_Account_Id__r.Account_Status__c , results[0].ebAccount.status);
        System.assertEquals(pms[0].EB_Account_Id__r.User_Code_1__c , results[0].ebAccount.riskRating);
        System.assertEquals(pms[0].EB_Account_Id__r.YTD_Contribution_Margin__c , results[0].ebAccount.contributionMargin);
        System.assertEquals(pms[0].EB_Account_Id__r.Core_Current_Balance__c , results[0].ebAccount.coreCurrentBalance);
        System.assertEquals(pms[0].EB_Account_Id__r.Current_Balance__c , results[0].ebAccount.currentBalance);
        System.assertEquals(pms[0].EB_Account_Id__r.Current_Commitment__c , results[0].ebAccount.currentCommitment);
        System.assertEquals(pms[0].EB_Account_Id__r.Unadvanced_Loan_Amount__c , results[0].ebAccount.unadvancedLoanAmount);
        System.assertEquals(pms[0].EB_Account_Id__r.Primary_Owner_Id__r.Name , results[0].ebAccount.primaryOwner.name);
    }

    
    private static testMethod void it_should_create_a_dm_archived_reports_when_pm_archived_reports_are_provided_by_inserting_test_records()
    {
        RecordType pmRecordType = Utility.recordTypeObject('Credit_Relationship__c', 'Credit Relationship');
        Credit_Relationship__c pmCreditRelationship = new Credit_Relationship__c(RecordTypeId = pmRecordType.Id);
        insert pmCreditRelationship;
        Archived_Report__c pmReport = new Archived_Report__c( Name = 'test', Credit_Relationship__c = pmCreditRelationship.Id, Url__c = 'testurl');
        insert pmReport;
        pmReport = [SELECT Id , Name , Url__c, OwnerId, Credit_Relationship__c, CreatedDate, CreatedBy.Name  FROM Archived_Report__c WHERE Id =: pmReport.Id ];

        List<DmArchivedReport> results = sut.buildDmArchivedReports(new List<Archived_Report__c>{pmReport});

        System.assertEquals(1, results.size());
        System.assertEquals(pmCreditRelationship.Id, results[0].creditRelationship.id);
        System.assertEquals(pmReport.Id, results[0].id);
        System.assertEquals(pmReport.Name, results[0].name);
        System.assertEquals(pmReport.url__c, results[0].url);
        System.assertEquals(pmReport.CreatedDate, results[0].CreatedDate);
        System.assertEquals(pmReport.OwnerId, results[0].createdBy.Id);
        System.assertEquals(pmReport.CreatedBy.Name, results[0].CreatedBy.Name);
    }

    private static testMethod void it_should_create_a_dm_related_entities_when_pm_related_entities_are_provided_by_inserting_test_records()
    {
        Account client = new Account(Name='test');
        insert client;
        client = [SELECT Id , Name FROM Account WHERE Id =:client.Id];
        RecordType pmRecordType = Utility.recordTypeObject('Credit_Relationship__c', 'Credit Relationship');
        Credit_Relationship__c pmCreditRelationship = new Credit_Relationship__c(RecordTypeId = pmRecordType.Id);
        insert pmCreditRelationship;
        Credit_Relationship_Related_Client__c pmCreditRelationshipClient = new Credit_Relationship_Related_Client__c(Related_Entity_del__c = client.Id, Credit_Relationship__c = pmCreditRelationship.Id );
        insert pmCreditRelationshipClient;
        pmCreditRelationshipClient = [SELECT Id, Name, Related_Entity_del__c,Credit_Relationship__c, Related_Entity_del__r.Id,Related_Entity_del__r.Name,
                                        Related_Entity_del__r.billingCity, Related_Entity_del__r.billingState, Related_Entity_del__r.billingStreet, 
                                        Related_Entity_del__r.billingPostalCode
                                        FROM Credit_Relationship_Related_Client__c WHERE Id=: pmCreditRelationshipClient.Id];

        List<DmCreditRelationshipRelatedEntity> results = sut.buildDmCreditRelationshipRelatedEntities(new List<Credit_Relationship_Related_Client__c>{pmCreditRelationshipClient});

        System.assertEquals(1, results.size());
        System.assertEquals(pmCreditRelationshipClient.Id, results[0].id);
        System.assertEquals(pmCreditRelationshipClient.Name, results[0].name);
        System.assertEquals(pmCreditRelationship.Id, results[0].creditRelationship.id);
        System.assertEquals(client.Id, results[0].entity.id);
    }

    private static testMethod void it_should_build_dm_credit_relationship_notes()
    {
        Account client = new Account(Name='test');
        insert client;
        client = [SELECT Id , Name FROM Account WHERE Id =:client.Id];
        RecordType pmRecordType = Utility.recordTypeObject('Credit_Relationship__c', 'Credit Relationship');
        Credit_Relationship__c pmCreditRelationship = new Credit_Relationship__c(RecordTypeId = pmRecordType.Id);
        insert pmCreditRelationship;
        Credit_Relationship_Note__c pmCreditRelationshipNote = new Credit_Relationship_Note__c(Credit_Relationship__c = pmCreditRelationship.Id );
        insert pmCreditRelationshipNote;
        pmCreditRelationshipNote = [SELECT Id, Name, RecordType.Id, RecordType.Name, RecordTypeId, Credit_Relationship__c, Diary__c, Situation_Flag__c, OwnerId,
                                        CreatedBy.Name, CreatedDate
                                        FROM Credit_Relationship_Note__c WHERE Id=: pmCreditRelationshipNote.Id];

        List<DmCreditRelationshipNote> results = sut.buildDmCreditRelationshipNotes(new List<Credit_Relationship_Note__c>{pmCreditRelationshipNote});

        System.assertEquals(1, results.size());
        System.assertEquals(pmCreditRelationshipNote.Id, results[0].id);
        System.assertEquals(pmCreditRelationshipNote.Name, results[0].name);
        System.assertEquals(pmCreditRelationshipNote.RecordType.Id, results[0].recordType.id);
        System.assertEquals(pmCreditRelationshipNote.RecordType.Name, results[0].recordType.name);
        System.assertEquals(pmCreditRelationshipNote.Credit_Relationship__c, results[0].creditRelationship.Id);
        System.assertEquals(pmCreditRelationshipNote.Diary__c, results[0].diary);
        System.assertEquals(pmCreditRelationshipNote.Situation_Flag__c, results[0].SituationFlag);
        System.assertEquals(pmCreditRelationshipNote.OwnerId, results[0].createdBy.Id);
        System.assertEquals(pmCreditRelationshipNote.CreatedBy.Name, results[0].createdBy.Name);
        System.assertEquals(pmCreditRelationshipNote.CreatedDate, results[0].CreatedDate);
    }

    private static testMethod void it_should_build_dm_entities()
    {
        Credit_Relationship__c pm = new Credit_Relationship__c();
        insert pm;
        Account entity = new Account(Name = 'test',billingCity = 'city',billingState = 'state',billingStreet = 'street',billingPostalCode = 'post' );
        insert entity;
        Credit_Relationship_Related_Client__c pmRelatedClient = new Credit_Relationship_Related_Client__c();
        pmRelatedClient.Related_Entity_del__c = entity.Id;
        pmRelatedClient.Credit_Relationship__c = pm.Id;
        insert pmRelatedClient;
        pm = SoqlResults(pm);

        List<DmEntity> results = sut.buildDmEntities(new List<Account>{entity});

        DmEntity dm = results[0];    
        System.assertEquals(1, results.size());
        System.assertEquals(entity.Id, dm.id);
        System.assertEquals(entity.Name, dm.name);
        System.assertEquals(entity.billingStreet, dm.billingStreet);
        System.assertEquals(entity.billingCity, dm.billingCity);
        System.assertEquals(entity.billingState, dm.billingState);
        System.assertEquals(entity.billingPostalCode, dm.billingPostalCode);
    }

    private static Credit_Relationship_Excluded_Account__c buildTestExcludedAccount(String creditRelationshipId){
        Account entity = new Account(Name = 'test',billingCity = 'city',billingState = 'state',billingStreet = 'street',billingPostalCode = 'post' );
        insert entity;
        Eb_Account__c ebaccount = new Eb_Account__c();
        ebaccount.Application__c = 2.0;
        ebaccount.Account_Number__c = '1234';
        ebaccount.Account_Line_1__c = 'test account';
        ebaccount.Account_Status__c = 'A';
        ebaccount.User_Code_1__c = '04';
        ebaccount.YTD_Contribution_Margin__c = 1200.00;
        ebAccount.Core_Current_Balance__c = 1200.00;
        ebaccount.Current_Balance__c = 1300.00;
        ebAccount.Unadvanced_Loan_Amount__c = 100.00;
        ebAccount.Primary_Owner_Id__c = entity.Id;
        insert ebAccount;
        Credit_Relationship_Excluded_Account__c excludeAccount = new Credit_Relationship_Excluded_Account__c();
        excludeAccount.Credit_Relationship_Id__c = creditRelationshipId;
        excludeAccount.EB_Account_Id__c = ebAccount.Id;
        return excludeAccount;
    }

    private static Credit_Relationship__c SoqlResults(Credit_Relationship__c pm){
        Credit_Relationship__c result = 
            [
                SELECT 
                    Id,
                    Name,
                    RecordTypeId,
                    RecordType.Name,
                    (SELECT
                        Id,
                        Name,
                        Url__c,
                        OwnerId,
                        Credit_Relationship__c,
                        CreatedDate,
                        CreatedBy.name
                    FROM
                        Archived_Reports__r
                    ),
                    (SELECT
                        Id,
                        Name,
                        Credit_Relationship__c,
                        Related_Entity_del__c,
                        Related_Entity_del__r.Id,
                        Related_Entity_del__r.Name,
                        Related_Entity_del__r.billingCity,
                        Related_Entity_del__r.billingState,
                        Related_Entity_del__r.billingStreet, 
                        Related_Entity_del__r.billingPostalCode
                    FROM 
                        Credit_Relationship_Related_Clients__r
                    ),
                    (SELECT
                        Id,
                        Name,
                        Credit_Relationship__c,
                        Diary__c,
                        Situation_Flag__c,
                        CreatedDate,
                        OwnerId,
                        RecordType.Id,
                        RecordType.Name,
                        RecordTypeId,
                        CreatedBy.Name
                    FROM Credit_Relationship_Notes__r
                    ),
                    (SELECT
                        Id,
                        Name,
                        Credit_Relationship_Id__c,
                        EB_Account_Id__c,
                        EB_Account_Id__r.Name,
                        EB_Account_Id__r.Application__c ,
                        EB_Account_Id__r.Account_Number__c,
                        EB_Account_Id__r.Account_Line_1__c,
                        EB_Account_Id__r.Account_Status__c,
                        EB_Account_Id__r.User_Code_1__c , 
                        EB_Account_Id__r.YTD_Contribution_Margin__c, 
                        EB_Account_Id__r.Core_Current_Balance__c , 
                        EB_Account_Id__r.Current_Balance__c, 
                        EB_Account_Id__r.Current_Commitment__c, 
                        EB_Account_Id__r.Unadvanced_Loan_Amount__c, 
                        EB_Account_Id__r.Primary_Owner_Id__r.Name 
                    FROM Credit_Relationship_Excluded_Accounts__r
                    )
                FROM
                    Credit_Relationship__c
                WHERE
                    Id =: pm.Id
            ];
        return result;
    }
}