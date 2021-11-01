@isTest
private class ProspectToClientControllerTests {

    public static testMethod void it_should_get_the_proper_unmatched_client_name_list(){
        ProspectToClientController sut = new ProspectToClientController(null);
        RecordType clientRecordType = utility.RecordTypeObject('Account', 'Client');
        Account buffaloNonBankway = new Account(Name = 'test1', EB_Client_Name__c='Buffalo Bill Not BW', Import_Source__c = 'not bw', RecordTypeId = clientRecordType.Id);
        Account buffaloFromBankway = new Account(Name = 'test2', EB_Client_Name__c='Buffalo Bill From BW', Import_Source__c = 'Bankway Import');
        insert buffaloNonBankway;
        insert buffaloFromBankway;

        sut.searchParam = 'Buffalo Bill';

        test.startTest();
            List<SelectOption> result = sut.getClientNames();
        test.stopTest();

        System.assertEquals(2, result.size());
        System.assertEquals('--None--', result[0].getLabel());
        System.assertEquals('Buffalo Bill Not BW', result[1].getLabel());
    }
    
    public static testMethod void verifyProspectToClientControllerFunctions(){      
            
        test.startTest();

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
            Type = 'In Person');
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
                Tax_ID__c = '1111111111'
            );
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
            system.debug('##Record ' + record_typepipelineId);
            pipeline.RecordTypeId = record_typepipelineId;
            pipeline.Product_Line__c = '';
            insert pipeline;                                                                                                
                        
                        
            if(acctClient == null || acctProspect == null){}
            else{
                String url = Utility.getserverurl() + '/apex/ProspectToClient?id=';
                PageReference pr = testhelper(url + acctProspect.Id);
                test.setCurrentPage(pr);
                ApexPages.StandardController sc = new Apexpages.Standardcontroller(acctProspect);
                ProspectToClientController testcontroller = new ProspectToClientController(sc);
                testcontroller.recId = acctProspect.Id;
                testcontroller.dropdownClientId = acctClient.Id;
                List<SelectOption> options = testcontroller.getClientNames();
                System.assertNotEquals(options, null);
                String s = testcontroller.getClientSelected();
                System.assertNotEquals(s, null);
                String sp = testcontroller.getProspectSelected();
                System.assertNotEquals(sp, null);
            }       

        test.stopTest();                
    }

    public static testMethod void verifyProspectToClientControllerPageReference(){  
            
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
        Type = 'In Person');
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
            Tax_ID__c = '1111111111'
        );
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
        system.debug('##Record ' + record_typepipelineId);
        pipeline.RecordTypeId = record_typepipelineId;
        pipeline.Product_Line__c = '';
        insert pipeline;
        
        if(acctClient == null || acctProspect == null){}
        else{
            
            String url = Utility.getserverurl() + '/apex/ProspectToClient?id=';
            PageReference pr = testhelper(url + acctProspect.Id);
            test.setCurrentPage(pr);
            ApexPages.StandardController sc = new Apexpages.Standardcontroller(acctProspect);
            ProspectToClientController testcontroller = new ProspectToClientController(sc);
            testcontroller.recId = acctProspect.Id;
            testcontroller.dropdownClientId = acctClient.Id;
            test.startTest();
            PageReference psearch = testcontroller.SetSearch();
            System.assertEquals(psearch, null);
            PageReference psave = testcontroller.SaveClient();
            test.stopTest();
        }       
    }
    
    public static PageReference testhelper(String url){
        PageReference newPage = new PageReference(url);
        newPage.setRedirect(true);
        return newPage;
    }   
    
}