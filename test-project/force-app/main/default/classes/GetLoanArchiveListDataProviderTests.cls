@IsTest
private class GetLoanArchiveListDataProviderTests
{

     private static testMethod void Code_Coverage_test()
    {
        GetLoanArchiveListDataProvider.updateManualKPIDetails(1);  //Wierd class name but this call got added later.
        GetLoanArchiveListDataProvider.fixWorkflowValidationIssueForEntityandCollateral(1);
        GetLoanArchiveListDataProvider.PurgeOrphanCollateralClientRelationships(1);
        GetLoanArchiveListDataProvider.WithdrawOldApprovedApps(1);
        GetLoanArchiveListDataProvider.WithdrawOldDocumentationApps(1);
    }
    
    //private static final GetLoanArchiveListDataProvider sut;
    
    //static{
    //    TestUtilities.createLoanAppStages();
    //    sut = new GetLoanArchiveListDataProvider();
    //}
    
    //private static testMethod void it_should_delete_an_archived_app()
    //{
    //    EB_Loan_Application__c loan = Objectfactory.getLoanApplication('EntityName' , 'EBAccountName', 'EBAccountNumber' ,'LoanAppName');
    //    loan.Delete_Flag__c = true;
    //    loan.Delete_Flag_IsSnapshotComplete__c = true;
    //    update loan;

    //    sut.deleteArchivedApps();

    //    List<EB_Loan_Application__c> loans = [SELECT id FROM EB_Loan_Application__c];
    //    system.assertEquals(0,loans.size());
    //}

    //private static testMethod void it_should_update_detail_kpi_based_on_lookup_to_manual_kpi()
    //{
    //    Manual_KPIs__c parent = new Manual_KPIs__c();
    //    parent.name = 'test';
    //    insert parent;

    //    Manual_KPI_Detail__c detail = new  Manual_KPI_Detail__c();
    //    detail.KPI_Description_for_Trigger__c = parent.name;
    //    insert detail;

    //    sut.updateManualKPIDetails();

    //    Manual_KPI_Detail__c result = [SELECT Manual_KPI__c FROM Manual_KPI_Detail__c WHERE Manual_KPI__c =: parent.Id];
    //    system.assertEquals(parent.Id, result.Manual_KPI__c);

    //}

    //private static testMethod void it_should_fix_stage_validation_rules_for_Loan_app1()
    //{
    //    Account testAccount = new Account();
    //    testAccount.Name = 'testAccount';
    //    testAccount.OFAC_Verified__c = 'Yes';
    //    testAccount.Sub_Type__c ='Personal';
    //    testAccount.Net_Worth__c = 10.00;
    //    testAccount.Liquid_Assets__c = 10.00;
    //    testAccount.Last_Financial_Statement__c = System.Today();

    //    testAccount.SSN_TIN_Has_Value__c=true;
    //    testAccount.SSNTIN_Encrypted__c = 'testSSn';
    //    testAccount.BillingStreet='t';
    //    testAccount.BillingCity='t';
    //    testAccount.BillingState='t';
    //    testAccount.BillingPostalCode='t';
    //    testAccount.Reg_O_Qualifications__c = 't';
    //    testAccount.Reg_O_Foreign_Insitution__c='t'; 
    //    testAccount.Reg_O_Foreign_Insitution_Title__c='t'; 
    //    testAccount.Phone='555-5555';       
    //    insert testAccount;

    //    Eb_Loan_Application__c testLoan  = ObjectFactory.getLoanApplication('testAccount' , 'testEbAccount', 'ebAccountNumber','testLoanApp');
    //    EB_Loan_App_Entity_Relationship__c testEntityRel = new EB_Loan_App_Entity_Relationship__c();
    //    testEntityRel.Entity_Name__c = testAccount.Id;
    //    testEntityRel.Relationship_Type__c = 'Primary Borrower';
    //    testEntityRel.Has_Missing_required_Fields__c = 1;
    //    testEntityRel.Loan_Application_ID__c= testLoan.Id;
    //    insert testEntityRel;

    //    sut.fixWorkflowValidationIssueForEntityandCollateral();
    
    //    EB_Loan_App_Entity_Relationship__c reQueryLoanEntity = GetLoanEntitySOQL()[0];
    //    Account reQueryAccount = reQueryLoanEntity.Entity_Name__r;
    //    system.assertEquals(0, reQueryLoanEntity.Missing_Required_For_Approval_Fields__c);
    //    system.assertEquals(0, reQueryLoanEntity.Missing_Required_For_Doc_Fields__c);
    //    system.assertEquals(0, reQueryLoanEntity.Has_Missing_required_Fields__c);
    //}
    
    // private static testMethod void it_should_fix_stage_validation_rules_for_Loan_app2()
    //{
    //    Account testAccount = new Account();
    //    testAccount.Name = 'testAccount';
    //    testAccount.OFAC_Verified__c = 'Yes';
    //    testAccount.Sub_Type__c ='Personal';
    //    testAccount.Net_Worth__c = 10.00;
    //    testAccount.Liquid_Assets__c = 10.00;
    //    testAccount.Last_Financial_Statement__c = System.Today();

    //    testAccount.SSN_TIN_Has_Value__c=false;
    //    testAccount.BillingStreet='t';
    //    testAccount.BillingCity='t';
    //    testAccount.BillingState='t';
    //    testAccount.BillingPostalCode='t';
    //    testAccount.Reg_O_Qualifications__c = 't';
    //    testAccount.Reg_O_Foreign_Insitution__c='t'; 
    //    testAccount.Reg_O_Foreign_Insitution_Title__c='t'; 
    //    testAccount.Phone='555-5555';       
    //    insert testAccount;

    //    Eb_Loan_Application__c testLoan  = ObjectFactory.getLoanApplication('testAccount' , 'testEbAccount', 'ebAccountNumber','testLoanApp');
    //    EB_Loan_App_Entity_Relationship__c testEntityRel = new EB_Loan_App_Entity_Relationship__c();
    //    testEntityRel.Entity_Name__c = testAccount.Id;
    //    testEntityRel.Relationship_Type__c = 'Primary Borrower';
    //    testEntityRel.Has_Missing_required_Fields__c = 0;
    //    testEntityRel.Loan_Application_ID__c= testLoan.Id;
       
    //    insert testEntityRel;

    //    sut.fixWorkflowValidationIssueForEntityandCollateral();
    
    //    EB_Loan_App_Entity_Relationship__c reQueryLoanEntity = GetLoanEntitySOQL()[0];
    //    Account reQueryAccount = reQueryLoanEntity.Entity_Name__r;
    //    system.assertEquals(0, reQueryLoanEntity.Missing_Required_For_Approval_Fields__c);
    //    system.assertEquals(1, reQueryLoanEntity.Missing_Required_For_Doc_Fields__c);
    //    system.assertEquals(1, reQueryLoanEntity.Has_Missing_required_Fields__c);
    //}
    
    //private static testMethod void it_should_fix_stage_validation_rules_for_loanapp_collateral_withmissing_required_field_zero()
    //{
    //    Collateral_Code__c code = Objectfactory.getCollateralCode('testCode','7000');
    //    EB_Collateral__c coll = new EB_Collateral__c();
    //    coll.Can_land_be_used_as_farmland__c = 'No';
    //    coll.Is_prop_leased_by_borr_or_an_affiliate__c = 'No';
    //    coll.Is_stock_publicly_traded__c  = 'No';
    //    coll.Src_of_repymt_from_50_rental_income__c = 'No';
    //    coll.Collateral_Code__c = code.Id;
    //    insert coll;
        
    //    Eb_Loan_Application__c testLoan  = ObjectFactory.getLoanApplication('testAccount' , 'testEbAccount', 'ebAccountNumber','testLoanApp');
         
    //    EB_Loan_App_Collateral_Relationship__c appCollRel = new EB_Loan_App_Collateral_Relationship__c();
    //    appCollRel.EB_Loan_Application_ID__c = testLoan.Id;
    //    appCollRel.EB_Collateral_ID__c = coll.Id;
    //    appCollRel.IsRealEstate__c = 0;
    //    appCollRel.Has_Missing_required_Fields__c = 1;
    //    appCollRel.Purpose_of_Collateral__c = 'Primary';
    //    insert appCollRel;
        
    //    sut.fixWorkflowValidationIssueForEntityandCollateral();
        
    //    EB_Loan_App_Collateral_Relationship__c reQueryRel = GetLoanCollateralSOQL()[0];
    //    system.assertEquals(0, reQueryRel.Missing_Required_Fields_For_Approval__c);
    //    system.assertEquals(0, reQueryRel.Missing_Required_Fields_For_Doc__c);
    //    system.assertEquals(0, reQueryRel.Has_Missing_required_Fields__c);
    //}
    
    //private static testMethod void it_should_fix_stage_validation_rules_for_loanapp_collateral_withmissing_required_field_not_zero()
    //{

    //    Collateral_Code__c code = Objectfactory.getCollateralCode('testCode','7000');
    //    code.Category__c = 'Real Estate';
    //    update code;
    //    EB_Collateral__c coll = new EB_Collateral__c();
    //    coll.Can_land_be_used_as_farmland__c = 'No';
    //    coll.Is_prop_leased_by_borr_or_an_affiliate__c = 'No';
    //    coll.Is_stock_publicly_traded__c  = 'No';
    //    coll.Src_of_repymt_from_50_rental_income__c = 'No';
    //    coll.Collateral_Code__c = code.Id;
    //    coll.Future_Advance_Amount__c = 0.001;
    //    insert coll;
        
    //    Eb_Loan_Application__c testLoan  = ObjectFactory.getLoanApplication('testAccount' , 'testEbAccount', 'ebAccountNumber','testLoanApp');
         
    //    EB_Loan_App_Collateral_Relationship__c appCollRel = new EB_Loan_App_Collateral_Relationship__c();
    //    appCollRel.EB_Loan_Application_ID__c = testLoan.Id;
    //    appCollRel.EB_Collateral_ID__c = coll.Id;
    //    appCollRel.IsRealEstate__c = 1;
    //    appCollRel.Has_Missing_required_Fields__c = 0;
    //    appCollRel.Purpose_of_Collateral__c = 'Primary';
    //    insert appCollRel;
        
    //    sut.fixWorkflowValidationIssueForEntityandCollateral();
        
    //    EB_Loan_App_Collateral_Relationship__c reQueryRel = GetLoanCollateralSOQL()[0];
    //    EB_Collateral__c reQueryCol = reQueryRel.EB_Collateral_ID__r;
    //    system.assertEquals(0, reQueryRel.Missing_Required_Fields_For_Approval__c);
    //    system.assertEquals(1, reQueryRel.Missing_Required_Fields_For_Doc__c);
    //    system.assertEquals(1, reQueryRel.Has_Missing_required_Fields__c);
    //}
    
    ////TODO : Not testable since lastmodifieddate cannot be changed
    //private static testMethod void it_should_withdraw_old_documentation_apps()
    //{
    //      Eb_Loan_Application__c testLoan  = ObjectFactory.getLoanApplication('testAccount' , 'testEbAccount', 'ebAccountNumber','testLoanApp');
    //      //testLoan.LastModifiedDate = system.Today().addDays(-50);
    //      testLoan.Application_Stage__c = TestUtilities.getStageByName('Booking').Id;
    //      update testLoan;
          
    //      sut.WithdrawOldDocumentationApps();
          
    //      List<Eb_Loan_Application__c>  reQuery = [SELECT Id FROM EB_Loan_Application__c WHERE Id =:testLoan.Id ];
    //      system.assertEquals(1, requery.size());
    //}
    
    ////TODO : Not testable since lastmodifieddate cannot be changed
    //private static testMethod void it_should_withdraw_old_approved_apps()
    //{
    //      Eb_Loan_Application__c testLoan  = ObjectFactory.getLoanApplication('testAccount' , 'testEbAccount', 'ebAccountNumber','testLoanApp');
    //      //testLoan.LastModifiedDate = system.Today().addDays(-140);
    //      testLoan.Application_Stage__c = TestUtilities.getStageByName('Approved').Id;
    //      update testLoan;
          
    //      sut.WithdrawOldDocumentationApps();
          
    //      List<Eb_Loan_Application__c>  reQuery = [SELECT Id FROM EB_Loan_Application__c WHERE Id =:testLoan.Id ];
    //      system.assertEquals(1, requery.size());
    //}
    
    //private static testMethod void it_should_purge_invalid_collateral_client_realtionships()
    //{
    //      EB_Collateral_Client_Relationship__c testRel = new EB_Collateral_Client_Relationship__c();
    //      insert testRel;
          
    //      sut.PurgeOrphanCollateralClientRelationships();
          
    //      List<EB_Collateral_Client_Relationship__c> reQuery = [SELECT ID FROM EB_Collateral_Client_Relationship__c WHERE Id =: testRel.Id ];
    //      system.assertEquals(0, reQuery.size());
    //}
    
    //private static testMethod void it_should_delete_an_expired_ws_cache()
    //{
    //      wscache__c cache = new wscache__c();
    //      insert cache;
    //      cache.Override_Lifespan_Minutes__c = -1000000;
    //      update cache;
        
    //      sut.DeleteExpiredWSCache();
        
    //      List<wscache__c> reQueryCaches = [SELECT id FROM wscache__c WHERE IsExpired__c=1];
    //      system.assertEquals(0,reQueryCaches.size());
    //}


    //private static List<EB_Loan_App_Entity_Relationship__c> GetLoanEntitySOQL()
    //{
    //    Return  [SELECT 
    //                    Entity_Name__r.Name,
    //                    Entity_Name__r.OFAC_Verified__c,
    //                    Entity_Name__r.Sub_Type__c ,
    //                    Entity_Name__r.Net_Worth__c ,
    //                    Entity_Name__r.Liquid_Assets__c,
    //                    Entity_Name__r.Last_Financial_Statement__c ,
    //                    Entity_Name__r.SSN_TIN_Has_Value__c ,
    //                    Entity_Name__r.SSNTIN_Encrypted__c,
    //                    Entity_Name__r.BillingStreet ,
    //                    Entity_Name__r.BillingCity ,
    //                    Entity_Name__r.BillingState ,
    //                    Entity_Name__r.BillingPostalCode ,
    //                    Entity_Name__r.Reg_O_Qualifications__c,
    //                    Entity_Name__r.Reg_O_Foreign_Insitution__c,
    //                    Entity_Name__r.Reg_O_Foreign_Insitution_Title__c,
    //                    Entity_Name__r.Phone,
    //                    Relationship_Type__c,
    //                    Has_Missing_required_Fields__c,
    //                    Missing_Required_For_Approval_Fields__c,
    //                    Missing_Required_For_Doc_Fields__c
    //            FROM 
    //                    EB_Loan_App_Entity_Relationship__c];
    //}
    
    
    //private static List<EB_Loan_App_Collateral_Relationship__c> GetLoanCollateralSOQL()
    //{
    //     Return [SELECT  
    //                    EB_Collateral_ID__r.Is_prop_leased_by_borr_or_an_affiliate__c,
    //                    EB_Collateral_ID__r.Can_land_be_used_as_farmland__c,
    //                    EB_Collateral_ID__r.Is_stock_publicly_traded__c,
    //                    EB_Collateral_ID__r.Src_of_repymt_from_50_rental_income__c,
    //                    EB_Collateral_ID__r.Street__c,
    //                    EB_Collateral_ID__r.Future_Advance_Amount__c,
    //                    Purpose_of_Collateral__c,
    //                    IsRealEstate__c,
    //                    Has_Missing_required_Fields__c,
    //                    Missing_Required_Fields_For_Approval__c,
    //                    Missing_Required_Fields_For_Doc__c
                        
    //             FROM
    //                    EB_Loan_App_Collateral_Relationship__c]; 
    //}
}