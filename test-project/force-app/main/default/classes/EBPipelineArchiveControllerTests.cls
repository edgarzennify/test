@isTest
private class EBPipelineArchiveControllerTests{

    private static testMethod void it_should_get_the_proper_unmatched_client_name_list(){
        RecordType clientRecordType = utility.RecordTypeObject('Account', 'Client');
        Account buffaloNonBankway = new Account(Name = 'test1', EB_Client_Name__c='Buffalo Bill Not BW', Import_Source__c = 'not bw', RecordTypeId = clientRecordType.Id);
        Account buffaloFromBankway = new Account(Name = 'test2', EB_Client_Name__c='Buffalo Bill From BW', Import_Source__c = 'Bankway Import');
        insert buffaloNonBankway;
        insert buffaloFromBankway;

        Opportunity pipeline = new Opportunity();
        RecordType tmRecType = Utility.RecordTypeObject('Opportunity', 'Consumer');
        pipeline.Name = 'test';
        pipeline.CloseDate = system.today();
        pipeline.StageName = 'test stage';
        pipeline.RecordTypeId = tmRecType.Id;
        pipeline.AccountId = buffaloNonBankway.Id;
        insert pipeline;

        PageReference pr = Page.EBPipelineArchive;
        test.setCurrentPage(pr);
        ApexPages.currentPage().getParameters().put('Id',pipeline.Id);
        ApexPages.StandardController sc = new Apexpages.Standardcontroller(pipeline);
        
        EBPipelineArchiveController sut = new EBPipelineArchiveController(sc);
        sut.searchParam = 'Buffalo Bill';

        List<SelectOption> result = sut.getClientNames();

        System.assertEquals(2, result.size());
    }

    private static testMethod void it_should_verfiy_that_convert_to_client_is_not_required_for_the_product_merchant_processing(){
        
        Id record_typeProspectId = Utility.RecordTypeObject('Account', 'Prospect').Id;
        
        Account Prospect = new Account(Name='TestProspectPtoC', 
                                 BillingStreet='Test Street',
                                 BillingCity='Test city',
                                 BillingPostalCode='UTEST1 1UT',
                                 RecordTypeId = record_typeProspectId
                                 );
        insert Prospect;
        
        
        Opportunity pipeline = new Opportunity();
        RecordType tmRecType = utility.RecordTypeObject('Opportunity', 'Merchant Processing');
        
        Datetime dT = System.now();
        Date d = date.newinstance(dT.year(), dT.month(), dT.day());
        Pipeline.CloseDate = d;
        pipeline.Name = 'test';
        pipeline.CloseDate = system.today();
        pipeline.StageName = 'test stage';
        pipeline.Potential_Fee_Income__c = 10;
        Pipeline.Potential_Deposits__c = 1000;         
        Pipeline.Amount = 50.00;
        Pipeline.Type__c = 'Test';
        Pipeline.Type = 'Test';
        Pipeline.StageName = 'Closed Won';
        Pipeline.AccountId = Prospect.Id;
        Pipeline.Products__c = 'Merchant Processing';
        pipeline.Product__c = '';
        pipeline.Product_Type__c = '';
        pipeline.RecordTypeId = tmRecType.Id;
        pipeline.Sales_Quarter__c = '1st';
        pipeline.Tax_Credit_Year__c = '2015';
        pipeline.In_Fund__c = 'Yes';
        pipeline.Average_Gain__c = '18 1/2 Cents';
        pipeline.Amount_of_Credits_Sold__c = 20000;
        pipeline.Price_Credit__c = 0.92;

        insert pipeline;
        PageReference pr = Page.EBPipelineArchive;
        test.setCurrentPage(pr);
        ApexPages.currentPage().getParameters().put('Id',pipeline.Id);
        ApexPages.StandardController sc = new Apexpages.Standardcontroller(pipeline);
        
        EBPipelineArchiveController testcontroller = new EBPipelineArchiveController(sc);
        
        
        
        //Act
        system.assertEquals(true,tmRecType != null);
        system.assertEquals(true, testcontroller.WonClientStatus);
        
    }

    private static testMethod void it_should_verfiy_that_convert_to_client_is_not_required_for_the_recordtype_draw(){
        
        Id record_typeProspectId = Utility.RecordTypeObject('Account', 'Prospect').Id;
        
        Account Prospect = new Account(Name='TestProspectPtoC', 
                                 BillingStreet='Test Street',
                                 BillingCity='Test city',
                                 BillingPostalCode='UTEST1 1UT',
                                 RecordTypeId = record_typeProspectId
                                 );
        insert Prospect;
        
        
        Opportunity pipeline =  new Opportunity();
        RecordType tmRecType = utility.RecordTypeObject('Opportunity', 'Draw');
        
        Datetime dT = System.now();
        Date d = date.newinstance(dT.year(), dT.month(), dT.day());
        pipeline.Name = 'test';
        Pipeline.CloseDate = d;
        Pipeline.Potential_Deposits__c = 1000;         
        Pipeline.Amount = 50.00;
        Pipeline.Type__c = 'Test';
        Pipeline.Type = 'Test';
        Pipeline.Committed_Amount__c = 1000.00;
        Pipeline.StageName = 'Draw';
        Pipeline.AccountId = Prospect.Id;
        Pipeline.Products__c = 'Merchant Processing';
        pipeline.RecordTypeId = tmRecType.Id;
        pipeline.Sales_Quarter__c = '1st';
        pipeline.Tax_Credit_Year__c = '2015';
        pipeline.In_Fund__c = 'Yes';
        pipeline.Average_Gain__c = '18 1/2 Cents';
        pipeline.Amount_of_Credits_Sold__c = 20000;
        pipeline.Price_Credit__c = 0.92;        
        insert pipeline;
        PageReference pr = Page.EBPipelineArchive;
        test.setCurrentPage(pr);
        ApexPages.currentPage().getParameters().put('Id',pipeline.Id);
        ApexPages.StandardController sc = new Apexpages.Standardcontroller(pipeline);
        
        EBPipelineArchiveController testcontroller = new EBPipelineArchiveController(sc);
        
        
        
        //Act
        system.assertEquals(true,tmRecType != null);
        system.assertEquals(true, testcontroller.WonClientStatus);
        
    }
    
    private static testMethod void it_should_verfiy_that_convert_to_client_is_not_required_for_the_product_creditcard(){
        
        Id record_typeProspectId = Utility.RecordTypeObject('Account', 'Prospect').Id;
        
        Account Prospect = new Account(Name='TestProspectPtoC', 
                                 BillingStreet='Test Street',
                                 BillingCity='Test city',
                                 BillingPostalCode='UTEST1 1UT',
                                 RecordTypeId = record_typeProspectId
                                 );
        insert Prospect;
        
        
        Opportunity pipeline =  new Opportunity();
        RecordType consumerRecType = utility.RecordTypeObject('Opportunity', 'Consumer');
        
        Datetime dT = System.now();
        Date d = date.newinstance(dT.year(), dT.month(), dT.day());
        pipeline.Name = 'test name';
        Pipeline.CloseDate = d;
        Pipeline.Amount = 50.00;
        Pipeline.Type__c = 'Test';
        Pipeline.Type = 'Test';
        Pipeline.StageName = 'Closed Won';
        Pipeline.AccountId = Prospect.Id;
        Pipeline.Products__c = 'Credit Card';
        pipeline.RecordTypeId = consumerRecType.Id;
        pipeline.Sales_Quarter__c = '1st';
        pipeline.Tax_Credit_Year__c = '2015';
        pipeline.In_Fund__c = 'Yes';
        pipeline.Average_Gain__c = '18 1/2 Cents';
        pipeline.Amount_of_Credits_Sold__c = 20000;
        pipeline.Price_Credit__c = 0.92;
        insert pipeline;
        PageReference pr = Page.EBPipelineArchive;
        test.setCurrentPage(pr);
        ApexPages.currentPage().getParameters().put('Id',pipeline.Id);
        ApexPages.StandardController sc = new Apexpages.Standardcontroller(pipeline);
        
        EBPipelineArchiveController testcontroller = new EBPipelineArchiveController(sc);
        
        //Act
        system.assertEquals(true,consumerRecType != null);
        system.assertEquals(true, testcontroller.WonClientStatus);
    } 
    
    private static testMethod void it_should_verfiy_that_convert_to_client_is_not_required_for_the_recordtype_and_stage_payoff_paydown(){
        
        Id record_typeProspectId = Utility.RecordTypeObject('Account', 'Prospect').Id;
        
        Account Prospect = new Account(Name='TestProspectPtoC', 
                                 BillingStreet='Test Street',
                                 BillingCity='Test city',
                                 BillingPostalCode='UTEST1 1UT',
                                 RecordTypeId = record_typeProspectId
                                 );
        insert Prospect;
        
        
        Opportunity pipeline =  new Opportunity();
        RecordType consumerRecType = utility.RecordTypeObject('Opportunity', 'Paydown/Payoff');
       
        Datetime dT = System.now();
        Date d = date.newinstance(dT.year(), dT.month(), dT.day());
        pipeline.Name = 'test name';
        Pipeline.CloseDate = d;
        Pipeline.Amount = 50.00;
        Pipeline.Type__c = 'Test';
        Pipeline.Type = 'Test';
        Pipeline.Committed_Amount__c = 1000.00;
        Pipeline.StageName = 'Payoff';
        Pipeline.AccountId = Prospect.Id;
        Pipeline.Products__c = 'Credit Card';
        pipeline.Product__c = '';
        pipeline.Product_Type__c = '';
        Pipeline.December_Amount__c = 1000.00;
        Pipeline.Will_this_loan_fully_fund_at_Closing__c = 'No';
        pipeline.RecordTypeId = consumerRecType.Id;
        pipeline.Sales_Quarter__c = '1st';
        pipeline.Tax_Credit_Year__c = '2015';
        pipeline.In_Fund__c = 'Yes';
        pipeline.Average_Gain__c = '18 1/2 Cents';
        pipeline.Amount_of_Credits_Sold__c = 20000;
        pipeline.Price_Credit__c = 0.92;
        insert pipeline;
        PageReference pr = Page.EBPipelineArchive;
        test.setCurrentPage(pr);
        ApexPages.currentPage().getParameters().put('Id',pipeline.Id);
        ApexPages.StandardController sc = new Apexpages.Standardcontroller(pipeline);
        
        EBPipelineArchiveController testcontroller = new EBPipelineArchiveController(sc);
            
        //Act
        system.assertEquals(true,consumerRecType != null);
        system.assertEquals(true, testcontroller.WonClientStatus);    
    } 
    
    private static testMethod void it_should_verfiy_that_convert_to_client_is_not_required_for_the_recordtype_Tax_Credits(){
        
        Id record_typeProspectId = Utility.RecordTypeObject('Account', 'Prospect').Id;
        
        Account Prospect = new Account(Name='TestProspectPtoC', 
                                 BillingStreet='Test Street',
                                 BillingCity='Test city',
                                 BillingPostalCode='UTEST1 1UT',
                                 RecordTypeId = record_typeProspectId
                                 );
        insert Prospect;
        
        
        Opportunity pipeline = new Opportunity();
        RecordType taxCreditRecType = utility.RecordTypeObject('Opportunity', 'Tax Credits');
        
        Datetime dT = System.now();
        Date d = date.newinstance(dT.year(), dT.month(), dT.day());
        pipeline.name = 'test name';
        Pipeline.CloseDate = d;
        Pipeline.Amount = 50.00;
        Pipeline.Type__c = 'Test';
        Pipeline.Type = 'Test';
        Pipeline.Committed_Amount__c = 1000.00;
        Pipeline.StageName = 'Closed Won';
        Pipeline.AccountId = Prospect.Id;
        Pipeline.Products__c = 'Credit Card';
        pipeline.RecordTypeId = taxCreditRecType.Id;
        pipeline.Sales_Quarter__c = '1st';
        pipeline.Tax_Credit_Year__c = '2015';
        pipeline.In_Fund__c = 'Yes';
        pipeline.Average_Gain__c = '18 1/2 Cents';
        pipeline.Amount_of_Credits_Sold__c = 20000;
        pipeline.Price_Credit__c = 0.92;
        insert pipeline;
        PageReference pr = Page.EBPipelineArchive;
        test.setCurrentPage(pr);
        ApexPages.currentPage().getParameters().put('Id',pipeline.Id);
        ApexPages.StandardController sc = new Apexpages.Standardcontroller(pipeline);
        
        EBPipelineArchiveController testcontroller = new EBPipelineArchiveController(sc);
            
        //Act
        system.assertEquals(true,taxCreditRecType != null);
        system.assertEquals(true, testcontroller.WonClientStatus);    
    } 
    
    
    private static testMethod void verifyEBPipelineArchivePageReference(){      
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

        Datetime dT = System.now();
        Date d = date.newinstance(dT.year(), dT.month(), dT.day());
        opportunity plineWon = new opportunity();
        plineWon.Name = 'my opportunity';
        plineWon.CloseDate = d;
        plineWon.AccountId = acctClient.Id;
        plineWon.Amount = 50.00;
        plineWon.StageName = 'Closed Won';
        plineWon.Products__c = 'Commercial Checking';
        plineWon.Type__c = 'Dep - Deposits';
        plineWon.Potential_Deposits__c=25.0;
        system.debug('##Record ' + record_typepipelineId);
        plineWon.RecordTypeId = record_typepipelineId;
        insert plineWon;
        
        Treasury_Management__c newtmservice = new Treasury_Management__c();
        newtmservice.Account__c = acctClient.Id;
                newtmservice.TM_Conv_Master_Account_Number__c = '111';
                newtmservice.RecordTypeId = record_typetmId;             
                newtmservice.Start_Date__c = d;
                insert newtmservice;    

        test.startTest(); 
               
        if(acctClient == null || acctProspect == null){}
        else{
                String url = Utility.getServerUrl()+ '/apex/EBPipelineArchive?id=';
                PageReference pr = utility.testhelper(url + plineWon.Id);
                test.setCurrentPage(pr);
                ApexPages.StandardController sc = new Apexpages.Standardcontroller(plineWon);
                EBPipelineArchiveController testcontroller = new EBPipelineArchiveController(sc);
                testcontroller.prospect = null;
                testcontroller.recId = plineWon.Id;
                testcontroller.pipeline = plineWon;
                testcontroller.Prospect = acctProspect;
                testcontroller.dropdownClientId = acctClient.Id;
                PageReference psave = testcontroller.SaveClient();
                psave = testcontroller.SaveLost();
                psave = testcontroller.ArchiveClient();
                psave = testcontroller.SetSearch();
        }
            
        test.stopTest();
    }
        
    private static testMethod void verifyEBPipelineArchiveFunctions(){
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
        Datetime dT = System.now();
        Date d = date.newinstance(dT.year(), dT.month(), dT.day());
        opportunity plineWon = new opportunity();
        plineWon.Name = 'my opportunity';
        plineWon.CloseDate = d;
        plineWon.AccountId = acctClient.Id;
        plineWon.Amount = 50.00;
        plineWon.StageName = 'Closed Won';
        plineWon.Products__c = 'Commercial Checking';
        plineWon.Type__c = 'Dep - Deposits';
        plineWon.Potential_Deposits__c=25.0;
        system.debug('##Record ' + record_typepipelineId);
        plineWon.RecordTypeId = record_typepipelineId;
        insert plineWon;       
        Treasury_Management__c newtmservice = new Treasury_Management__c();
        newtmservice.Account__c = acctClient.Id;
        newtmservice.TM_Conv_Master_Account_Number__c = '111';
        newtmservice.RecordTypeId = record_typetmId;             
        newtmservice.Start_Date__c = d;
        insert newtmservice;    
                        
        if(acctClient == null || acctProspect == null){}
        else{

                string serverurl = Utility.getServerUrl();
                String url = serverurl+'/apex/EBPipelineArchive?id=';
                PageReference pr = utility.testhelper(url + plineWon.Id);
                test.setCurrentPage(pr);
                ApexPages.StandardController sc = new Apexpages.Standardcontroller(plineWon);
                EBPipelineArchiveController testcontroller = new EBPipelineArchiveController(sc);
                testcontroller.prospect = null;
                String sp = testcontroller.getProspectSelected();
                System.assertEquals(sp, '');
                testcontroller.dropdownClientId = null;
                String s = testcontroller.getClientSelected();
                System.assertEquals(s, '');
                testcontroller.recId = plineWon.Id;
                testcontroller.pipeline = plineWon;
                testcontroller.Prospect = acctProspect;
                testcontroller.dropdownClientId = acctClient.Id;
                testcontroller.HandleWonClientCase();
                List<SelectOption> options = testcontroller.getClientNames();
                System.assertNotEquals(options, null);
                testcontroller.loststatus = true;
                testcontroller.HandleIfLostReasonExists();
                testcontroller.HandleWonClientWMCase();
                Opportunity o = testcontroller.lostDate;
                s = testcontroller.getClientSelected();
                System.assertNotEquals(s, null);
                sp = testcontroller.getProspectSelected();
                System.assertNotEquals(sp, null);
                String am = testcontroller.getAmount();
                System.assertNotEquals(am, null);
                String aprod = testcontroller.getProduct();
                System.assertNotEquals(aprod,null);
                String anm = testcontroller.getName();
                System.assertNotEquals(anm,null);
                testcontroller.ErrorMessage = 'test';
                String smsg = testcontroller.getMessage();
                System.assertEquals(smsg, 'test');      

                testcontroller.updateEBPipelineArchiveStatus(plineWon);                                        
        }
                            
                test.stopTest();
    }
}