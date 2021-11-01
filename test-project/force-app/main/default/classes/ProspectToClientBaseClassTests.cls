@isTest
private class ProspectToClientBaseClassTests {

    public static testMethod void verifyProspectToClientControllerFunctions(){ 

        Id record_typeProspectId;
        Id record_typeClientId;
        Id record_typetmId;
        Id record_typepipelineId;
        List<RecordType> rects = [SELECT  Name, Id FROM RecordType where SObjectType =:'Account' or SObjectType =: 'Treasury_Management__c' or SObjectType =: 'opportunity'];
        for (RecordType r : rects){
            if(r.Name == 'Prospect') record_typeProspectId = r.Id;
            if(r.Name == 'Client') record_typeClientId = r.Id;
            if(r.Name == 'ACH') record_typetmId = r.Id;
            if(r.Name == 'Consumer') record_typepipelineId = r.Id;
        }

        Account acctProspect = new Account(Name='TestProspectPtoC', 
            BillingStreet='Test Street',
            BillingCity='Test city',
            BillingPostalCode='UTEST1 1UT',
            RecordTypeId = record_typeProspectId
        );
        insert acctProspect;

        Account acctClient = new Account(Name='TestClientPtoC', 
            BillingStreet='Test Street',
            BillingCity='Test city',
            BillingPostalCode='UTEST1 1UT',
            Phone = '0000',
            RecordTypeId = record_typeClientId,
            EB_Client_Name__c = 'P Lawson',
            EB_Customer_Number__c = '616-0000',
            Import_Source__c = 'Bankway Import'
        );
        insert acctClient;

        EB_Account__c ebacct = new EB_Account__c();
        ebacct.Primary_Owner_Id__c = acctClient.Id;
        ebacct.Account_Line_1__c = 'Test account Line 1';
        ebacct.Account_Number__c = '123';
        ebacct.Application__c = 2;
        ebacct.Current_Balance__c = 1000;
        ebacct.Key__c = '616-2-1000';
        insert ebacct;

        Task t = new Task(WhatId = acctClient.Id,
            Activity__c = 'Follow-up',
            Status = 'Not Started',
            Subject = 'Activity',
            Type = 'In Person'
        );
        insert t;

        Treasury_Management__c newtmservice = new Treasury_Management__c();
        newtmservice.Account__c = acctClient.Id;
        newtmservice.TM_Conv_Master_Account_Number__c = '111';
        newtmservice.RecordTypeId = record_typetmId;
        Datetime dT = System.now();
        Date d = date.newinstance(dT.year(), dT.month(), dT.day()); 
        newtmservice.Start_Date__c = d;
        insert newtmservice;

        EB_Related_Account_Owner__c rowner = new EB_Related_Account_Owner__c(Account_ID__c = acctClient.Id,
        Customer_Name__c = 'Test NamePtoC',
        Customer_Number__c = '616-0000',
        Tax_ID__c = '1111111111');
        insert rowner;

        opportunity pipeline = new opportunity();
        pipeline.Name = 'my opportunity';
        pipeline.CloseDate = d;
        pipeline.AccountId = acctClient.Id;
        pipeline.Amount = 50.00;
        pipeline.StageName = 'Closed Won';
        pipeline.Products__c = 'Commercial Checking';
        pipeline.Type__c = 'Dep - Deposits';
        pipeline.Potential_Deposits__c=25.0;
        pipeline.Product_Line__c = '';
        system.debug('##Record ' + record_typepipelineId);
        pipeline.RecordTypeId = record_typepipelineId;
        insert pipeline;                                                

        EB_Collateral__c ProspectiveCollateral = testObjectClass.getTestCollateralObj('??');
        EB_Collateral__c ExistingCollateral = testObjectClass.getTestCollateralObj('%%');

        test.startTest();
        
            ProspectToClientBaseClass testClass = new ProspectToClientBaseClass();

            testClass.recId = acctProspect.Id;

            List<SelectOption> options = testClass.getUnmatchedClientNameList('a');
            Id prospectid = testclass.getRecordTypeIdForName('Account','Prospect').Id;
            Account acc = testclass.getAccountObjectForId(acctProspect.Id);
            testClass.updateClientInfoToProspect(acctProspect,acctClient);
            testClass.updateEB_AccountPrimaryOwner(acctProspect,acctClient);
            testClass.updateEB_Account_RelationshipAccountId(acctProspect,acctClient);
            testClass.updateTMAccountId(acctProspect,acctClient);
            testClass.updateEBRelatedAccountOwners(acctProspect, acctClient);          
            testClass.updateTasks(acctProspect,acctClient);
            testClass.updateEBPipeline(acctProspect,acctClient);
            testClass.updateAppraisalOrder(prospectiveCollateral, existingCollateral);
            testClass.updateProspectiveCollateralWithExistingData(prospectiveCollateral, existingCollateral);
            testClass.updateRelatedCollaterals(prospectiveCollateral, existingCollateral, ebacct.Id);
            testClass.updateRelatedEntityCollaterals(prospectiveCollateral,existingCollateral,acctProspect.Id);
            testClass.updateRelatedEntities(acctProspect, acctClient, ebacct.Id);
            testClass.updatePackets(acctProspect,acctClient);
            testClass.updateRelatedEntitiesOnLoanApp(acctProspect, acctClient);
            testClass.updateAttachments(acctProspect.Id, acctClient.Id);
            testClass.updateNotes(acctProspect.Id, acctClient.Id);

            List<EB_Account__c> ebaccounts = new List<EB_Account__c>();
            ebaccounts.add(ebacct);
            testClass.updateEB_AccountPrimaryOwner(ebaccounts, acctProspect.Id);

            EB_Account_Relationship__c acctrel = new EB_Account_Relationship__c();
            acctrel.Client_Id__c = acctProspect.id;
            acctrel.EB_Account_Id__c = ebacct.id;
            insert acctrel;
            List<EB_Account_Relationship__c> acctrels = new List<EB_Account_Relationship__c>();
            acctrels.add(acctrel);
            testClass.updateRelatedEntities( acctrels , acctProspect.Id);

            List<EB_Related_Account_Owner__c> rowners = new List<EB_Related_Account_Owner__c>();
            rowners.add(rowner) ;
            testClass.updateEBRelatedAccountOwners( rowners , acctProspect.Id);

            List<Task> tasks = new List<Task>();
            tasks.add(t);
            testClass.updateTasks( tasks, acctProspect.Id);

            List<opportunity> pipelines = new List<opportunity>();
            pipelines.add(pipeline);
            testClass.updateEBPipeline( Pipelines , acctProspect.Id);
        
        test.stopTest();        
    }
}