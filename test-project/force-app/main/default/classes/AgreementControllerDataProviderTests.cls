@IsTest
private class AgreementControllerDataProviderTests{
    
    private static final AgreementControllerDataProvider sut;

    static {
        sut = new AgreementControllerDataProvider();
    }
    
    @IsTest
    static void it_should_retrieve_an_Agreement_by_Id() {
        Agreement__c testAgmt = new Agreement__c();
        testAgmt.RecordType = Utility.recordTypeObject('Agreement__c','Active');
        insert testAgmt;        

        Agreement__c returnResult = sut.getAgreementByID(testAgmt.Id);

        System.assertEquals('Active', returnResult.RecordType.Name);
        System.assertEquals('Active', returnResult.RecordTypeDescription__c);
        System.assertEquals(testAgmt.RecordType.Id, returnResult.RecordTypeId);
        Object wasFieldInSOQL;
        wasFieldInSOQL = returnResult.Id;
        wasFieldInSOQL = returnResult.Name;
        wasFieldInSOQL = returnResult.Borrower_Name__c;
        wasFieldInSOQL = returnResult.Loan_App_Summary__c;
        wasFieldInSOQL = returnResult.Included_Loan_Apps__c;
        wasFieldInSOQL = returnResult.Loan_Coordinator__c;
        wasFieldInSOQL = returnResult.File_Review_Rep__c;
        wasFieldInSOQL = returnResult.Approver_One__c;
        wasFieldInSOQL = returnResult.Business_Loan_Agreement_Documents__c;
        wasFieldInSOQL = returnResult.Loan_Documents_Prepared_By__c;
        wasFieldInSOQL = returnResult.CreatedDate;
        wasFieldInSOQL = returnResult.Borrower_Name__r.Entity_Name__c;
        wasFieldInSOQL = returnResult.RecordTypeId;
        wasFieldInSOQL = returnResult.Last_Amendment_Date__c;
        wasFieldInSOQL = returnResult.Credit_Analyst__c;
        wasFieldInSOQL = returnResult.Image_Prep_Rep__c;
        wasFieldInSOQL = returnResult.Approver_Two__c;
        wasFieldInSOQL = returnResult.Guarantee_Agreement_Documents__c;
        wasFieldInSOQL = returnResult.Documentation_Path_Fx__c;
        wasFieldInSOQL = returnResult.CreatedBy.Name;
        wasFieldInSOQL = returnResult.Borrower_Summary__c;
        wasFieldInSOQL = returnResult.ErrorMessages__c;
        wasFieldInSOQL = returnResult.Comments__c;
        wasFieldInSOQL = returnResult.DocumentationRep__c;
        wasFieldInSOQL = returnResult.Shred_File_Rep__c;
        wasFieldInSOQL = returnResult.Approver_Three__c;
        wasFieldInSOQL = returnResult.Subordination_Intercreditor_Documents__c;
        wasFieldInSOQL = returnResult.RecordType.Name;
        wasFieldInSOQL = returnResult.LastModifiedDate;
        wasFieldInSOQL = returnResult.Loan_Summary__c;
        wasFieldInSOQL = returnResult.WarningMessages__c;
        wasFieldInSOQL = returnResult.RecordTypeDescription__c;
        wasFieldInSOQL = returnResult.Booking_Rep__c;
        wasFieldInSOQL = returnResult.Stage__c;
        wasFieldInSOQL = returnResult.Source_Agreement__c;
        wasFieldInSOQL = returnResult.LastModifiedBy.Name;
        wasFieldInSOQL = returnResult.Related_Borrower__c;
        wasFieldInSOQL = returnResult.Agreement_Date__c;
        wasFieldInSOQL = returnResult.Checkback_Rep__c;
        wasFieldInSOQL = returnResult.Stage__r.Name;
        wasFieldInSOQL = returnResult.Replaced_By_Agreement__c;
        wasFieldInSOQL = returnResult.Included_Loans__c;
        wasFieldInSOQL = returnResult.Actual_Approval_Process__c;
        wasFieldInSOQL = returnResult.Stage__r.Loan_App_Stage_Action_Controller__r.Name;
    }

    @IsTest
    static void it_should_retrieve_Agreement_Client_Relationships_by_AgreementId() {
        Agreement__c testAgmt = new Agreement__c();
        insert testAgmt;
        Eb_Unit__c newUnit = ObjectFactory.getUnit( 'Test Unit', 20001);
        EB_Team_Member__c newMember = ObjectFactory.getTeamMember('Test Member');
        Id newClinetRecordTypeId = ObjectFactory.getRecordTypeIdByNameAndObject('Client', 'Account');       
        Account testEntity = ObjectFactory.getEntity('testEntity',newClinetRecordTypeId, newMember);
        Agreement_Client_Relationships__c agmtEntityRel = new Agreement_Client_Relationships__c(Agreement__c = testAgmt.Id,Entity__c = testEntity.Id);
        insert agmtEntityRel;
        Agreement_Client_Relationships__c agmtEntityRel2 = new Agreement_Client_Relationships__c(Agreement__c = testAgmt.Id,Entity__c = testEntity.Id);
        insert agmtEntityRel2;

        List<Agreement_Client_Relationships__c> returnResult = sut.getAgreementClientRelationshipsByAgreementId(testAgmt.Id);

        System.assertEquals(2, returnResult.size());        
        Object wasFieldInSOQL;
        wasFieldInSOQL = returnResult[0].Id;
        wasFieldInSOQL = returnResult[0].Entity__c;
        wasFieldInSOQL = returnResult[0].Entity__r.Annual_Stmt_Days_Due_After_Fiscal_Y_E__c;
        wasFieldInSOQL = returnResult[0].Entity__r.Tax_Return_Days_Due_After_Filing__c;
        wasFieldInSOQL = returnResult[0].Entity__r.Interim_Stm_Prepared_By__c;
        wasFieldInSOQL = returnResult[0].Entity__r.Personal_Financial_Statement__c;
        wasFieldInSOQL = returnResult[0].Entity__r.Annual_Financial_Statement_Period_Other__c;
        wasFieldInSOQL = returnResult[0].Entity__r.Pending_PFS__c;
        wasFieldInSOQL = returnResult[0].Entity__r.Pending_AFS_FYE__c;
        wasFieldInSOQL = returnResult[0].Entity__r.Pending_AFS_Entities_To_Combine__c;
        wasFieldInSOQL = returnResult[0].Entity__r.Pending_IntStmts_Period_Other__c;
        wasFieldInSOQL = returnResult[0].Relationship__c;
        wasFieldInSOQL = returnResult[0].Borrower_Name__c;
        wasFieldInSOQL = returnResult[0].Annual_Statement_Quality__c;
        wasFieldInSOQL = returnResult[0].Personal_Financial_Statement_Frequency__c;
        wasFieldInSOQL = returnResult[0].Interim_Stmt_Days_Due_After_Period_End__c;
        wasFieldInSOQL = returnResult[0].Name;
        wasFieldInSOQL = returnResult[0].Entity__r.Name;
        wasFieldInSOQL = returnResult[0].Entity__r.Other_Type__c;
        wasFieldInSOQL = returnResult[0].Entity__r.Interim_Statements__c;
        wasFieldInSOQL = returnResult[0].Entity__r.Interim_Stmt_Days_Due_After_Period_End__c;
        wasFieldInSOQL = returnResult[0].Entity__r.Personal_Financial_Statement_Frequency__c;
        wasFieldInSOQL = returnResult[0].Entity__r.Interim_Statement_Period_Other__c;
        wasFieldInSOQL = returnResult[0].Entity__r.Pending_PFS_Frequency__c;
        wasFieldInSOQL = returnResult[0].Entity__r.Pending_AFS_Days_Due_After_FYE__c;
        wasFieldInSOQL = returnResult[0].Entity__r.Pending_IntStmts__c;
        wasFieldInSOQL = returnResult[0].Entity__r.Pending_TaxReturns__c;
        wasFieldInSOQL = returnResult[0].Agreement__c;
        wasFieldInSOQL = returnResult[0].Tax_Returns__c;
        wasFieldInSOQL = returnResult[0].Annual_Stmt_Days_Due_After_Fiscal_Y_E__c;
        wasFieldInSOQL = returnResult[0].Interim_Statements__c;
        wasFieldInSOQL = returnResult[0].Annual_Financial_Statement_Period_Other__c;
        wasFieldInSOQL = returnResult[0].Entity__r.Entity_Name__c;
        wasFieldInSOQL = returnResult[0].Entity__r.Entities_To_Combine__c;
        wasFieldInSOQL = returnResult[0].Entity__r.Tax_Return_Period_Other__c;
        wasFieldInSOQL = returnResult[0].Entity__r.Pending_AFS__c;
        wasFieldInSOQL = returnResult[0].Entity__r.Pending_AFS_Period_Other__c;
        wasFieldInSOQL = returnResult[0].Entity__r.Pending_IntStmts_Quality__c;
        wasFieldInSOQL = returnResult[0].Entity__r.Pending_TaxReturns_Days_Due_After_Filing__c;
        wasFieldInSOQL = returnResult[0].Agreement__r.Name;
        wasFieldInSOQL = returnResult[0].Tax_Return_Days_Due_After_Filing__c;
        wasFieldInSOQL = returnResult[0].Other_Type__c;
        wasFieldInSOQL = returnResult[0].Interim_Stm_Prepared_By__c;
        wasFieldInSOQL = returnResult[0].Interim_Statement_Period_Other__c;
        wasFieldInSOQL = returnResult[0].Entity__r.Annual_Financial_Statements__c;
        wasFieldInSOQL = returnResult[0].Entity__r.Tax_Returns__c;
        wasFieldInSOQL = returnResult[0].Entity__r.Pending_AFS_Quality__c;
        wasFieldInSOQL = returnResult[0].Entity__r.Pending_AFS_Other_Type__c;
        wasFieldInSOQL = returnResult[0].Entity__r.Pending_IntStmts_Days_Due_After_PE__c;
        wasFieldInSOQL = returnResult[0].Entity__r.Pending_TaxReturns_Period_Other__c;
        wasFieldInSOQL = returnResult[0].Agreement__r.RecordTypeId;
        wasFieldInSOQL = returnResult[0].Annual_Financial_Statements__c;
        wasFieldInSOQL = returnResult[0].Entities_To_Combine__c;
        wasFieldInSOQL = returnResult[0].Tax_Return_Period_Other__c;
        wasFieldInSOQL = returnResult[0].Entity__r.Annual_Statement_Quality__c;
        wasFieldInSOQL = returnResult[0].Personal_Financial_Statement__c;
    }

    @IsTest
    static void it_should_retrieve_Agreement_Financial_Docs_by_AgreementId() {
        Account testEntity = new Account();
        testEntity.Name = 'Test Entity';
        testEntity.Type = 'Business';
        testEntity.BillingCountry = 'test country';
        insert testEntity;
        Agreement__c testAgmt = new Agreement__c();
        RecordType activeRecordType = Utility.recordTypeObject('Agreement__c','Active');
        testAgmt.RecordType = activeRecordType;
        insert testAgmt;
        Agreement_Client_Relationships__c agmtClientRel = new Agreement_Client_Relationships__c();
        agmtClientRel.Entity__c = testEntity.Id;
        agmtClientRel.Agreement__c = testAgmt.Id;
        insert agmtClientRel;
        RecordType taxReturnRecordType = Utility.recordTypeObject('Agreement_Financial_Documents__c','Tax Return');
        Set<ID> recordTypeIDSet = new Set<ID>();
        recordTypeIDSet.Add(taxReturnRecordType.Id);
        Agreement_Financial_Documents__c financialDoc = new Agreement_Financial_Documents__c();
        financialDoc.Agreement_Client_Relationship__c = agmtClientRel.Id;
        financialDoc.Agreement__c = testAgmt.Id;
        insert financialDoc;
        Agreement_Financial_Documents__c financialDoc2 = new Agreement_Financial_Documents__c();
        financialDoc2.Agreement_Client_Relationship__c = agmtClientRel.Id;
        financialDoc2.Agreement__c = testAgmt.Id;
        insert financialDoc2;

        List<Agreement_Financial_Documents__c> returnResult = sut.getAgreementFinancialDocumentsByAgreementId(testAgmt.Id);

        System.assertEquals(2, returnResult.size());
        Object wasFieldInSOQL;
        wasFieldInSOQL = returnResult[0].Id;
        wasFieldInSOQL = returnResult[0].Period_Due__c;
        wasFieldInSOQL = returnResult[0].Agreement_Client_Relationship__r.Entity__r.Entity_Name__c;
        wasFieldInSOQL = returnResult[0].Name;
        wasFieldInSOQL = returnResult[0].Period_Due_Label__c;
        wasFieldInSOQL = returnResult[0].Agreement_Client_Relationship__c;
        wasFieldInSOQL = returnResult[0].Period_Due_Override__c;
        wasFieldInSOQL = returnResult[0].Frequency__c;
        wasFieldInSOQL = returnResult[0].Start_Date__c;
        wasFieldInSOQL = returnResult[0].Include_In_Agreement__c;
        wasFieldInSOQL = returnResult[0].RecordTypeDescription__c;
        wasFieldInSOQL = returnResult[0].Other_Type__c;
        wasFieldInSOQL = returnResult[0].Agreement_Client_Relationship__r.Entity__c;
        wasFieldInSOQL = returnResult[0].Requirement_Summary__c;
    }

    @IsTest
    static void it_should_retrieve_RelatedEntities_With_Client_Relationships_by_AgreementId() {
        Account testEntity = new Account();
        testEntity.Name = 'Test Entity';
        testEntity.Type = 'Business';
        testEntity.BillingCountry = 'test country';
        insert testEntity;
        Agreement__c testAgmt = new Agreement__c();
        RecordType activeRecordType = Utility.recordTypeObject('Agreement__c','Active');
        testAgmt.RecordType = activeRecordType;
        insert testAgmt;
        Agreement_Client_Relationships__c agmtClientRel = new Agreement_Client_Relationships__c();
        agmtClientRel.Entity__c = testEntity.Id;
        agmtClientRel.Agreement__c = testAgmt.Id;
        insert agmtClientRel;
        RecordType taxReturnRecordType = Utility.recordTypeObject('Agreement_Financial_Documents__c','Tax Return');
        Set<ID> recordTypeIDSet = new Set<ID>();
        recordTypeIDSet.Add(taxReturnRecordType.Id);
        Agreement_Financial_Documents__c financialDoc = new Agreement_Financial_Documents__c();
        financialDoc.Agreement_Client_Relationship__c = agmtClientRel.Id;
        financialDoc.Agreement__c = testAgmt.Id;
        insert financialDoc;
        Agreement_Financial_Documents__c financialDoc2 = new Agreement_Financial_Documents__c();
        financialDoc2.Agreement_Client_Relationship__c = agmtClientRel.Id;
        financialDoc2.Agreement__c = testAgmt.Id;
        insert financialDoc2;

        List<Account> returnResult = sut.getRelatedEntitiesWithClientRelationshipsByAgreementId(testAgmt.Id);
        Agreement_Client_Relationships__c returnResultAgreementToLoanRelationshipRecord = returnResult[0].Agreement_To_Loan_Relations__r;

        System.assertNotEquals(null, returnResult[0].Id);
        System.assertEquals('Test Entity', returnResult[0].Name);
        System.assertEquals('Test Entity', returnResult[0].Entity_Name__c);
        System.assertEquals('Active', returnResultAgreementToLoanRelationshipRecord.Agreement__r.RecordTypeDescription__c);
        System.assertEquals(1, returnResult.size());
        Object wasFieldInSOQL;
        wasFieldInSOQL = returnResult[0].Id;
        wasFieldInSOQL = returnResult[0].Name;
        wasFieldInSOQL = returnResult[0].Entity_Name__c;
    }

    @IsTest
    static void it_should_retrieve_EB_Account_Relationships() {
        Account testEntityIncluded = ObjectFactory.getValidEntity('testEntity');
        Account testEntityNotIncluded = ObjectFactory.getValidEntity('testEntity2');
        EB_Account__c  ebAccount = ObjectFactory.getEBAccount('Test Account Title', '12345-15', testEntityNotIncluded);
        EB_Account_Relationship__c ebAcctRel = ObjectFactory.relateEntityToEBAccountObj(testEntityNotIncluded, ebAccount);
        List<EB_Account__c> ebAccountsIncludedOnAgreement = new List<EB_Account__c>{ebAccount};
        Set<Id> entitiesIncludedOnAgreement = new Set<Id>{testEntityIncluded.Id};

        List<EB_Account_Relationship__c> returnResult = sut.getEbAccountRelationships(ebAccountsIncludedOnAgreement, entitiesIncludedOnAgreement);

        System.assertEquals(1, returnResult.size());
        Object wasFieldInSOQL;
        wasFieldInSOQL = returnResult[0].Client_Id__c;
        wasFieldInSOQL = returnResult[0].Name;
        wasFieldInSOQL = returnResult[0].EB_Account_Id__r.Id;
        wasFieldInSOQL = returnResult[0].EB_Account_Id__r.Name;
        wasFieldInSOQL = returnResult[0].EB_Account_Id__r.Account_Status__c;
        wasFieldInSOQL = returnResult[0].Client_Id__r.Id;
        wasFieldInSOQL = returnResult[0].Client_Id__r.Name;
        wasFieldInSOQL = returnResult[0].Client_Id__r.Entity_Name__c;
        wasFieldInSOQL = returnResult[0].Client_Id__r.BillingStreet;
        wasFieldInSOQL = returnResult[0].Client_Id__r.BillingCity;
        wasFieldInSOQL = returnResult[0].Client_Id__r.BillingState;
        wasFieldInSOQL = returnResult[0].Client_Id__r.BillingPostalCode;
        wasFieldInSOQL = returnResult[0].Client_Id__r.Record_Type_Description__c;
    }

    @IsTest
    static void it_should_retrieve_Loan_Application_Relationships() {
        EB_Loan_App_Stage__c appStage = TestUtilities.createLoanAppStage('New','',1.1);
        insert appStage;

        Account testEntityIncluded = ObjectFactory.getValidEntity('testEntity');
        Account testEntityNotIncluded = ObjectFactory.getValidEntity('testEntity2');
        Set<Id> entitiesIncludedOnAgreement = new Set<Id>{testEntityIncluded.Id};
        Eb_Account__c newEBAccount = ObjectFactory.getEBAccount('test Account','1234', testEntityNotIncluded);    
        EB_Loan_Packet__c newPacket = ObjectFactory.getLoanPacket(testEntityNotIncluded);
        EB_Loan_Application__c ebLoanApp = ObjectFactory.getLoanApplication(newPacket, newEBAccount, '123445', true);
        List<EB_Loan_Application__c> loanAppsIncludedOnAgreement = new List<EB_Loan_Application__c>{ebLoanApp};
        EB_Loan_App_Entity_Relationship__c ebLoanAppEntityRel = ObjectFactory.getLoanAppEntityRelationship(testEntityNotIncluded,ebLoanApp);

        List<EB_Loan_App_Entity_Relationship__c> returnResult = sut.getLoanApplicationRelationships(loanAppsIncludedOnAgreement, entitiesIncludedOnAgreement);

        System.assertEquals(1, returnResult.size());
        Object wasFieldInSOQL;
        wasFieldInSOQL = returnResult[0].Id;
        wasFieldInSOQL = returnResult[0].Name;
        wasFieldInSOQL = returnResult[0].Entity_Name__c;
        wasFieldInSOQL = returnResult[0].Loan_Application_ID__r.Name;
        wasFieldInSOQL = returnResult[0].Entity_Name__r.Id;
        wasFieldInSOQL = returnResult[0].Entity_Name__r.Name;
        wasFieldInSOQL = returnResult[0].Entity_Name__r.Entity_Name__c;
        wasFieldInSOQL = returnResult[0].Entity_Name__r.BillingStreet;
        wasFieldInSOQL = returnResult[0].Entity_Name__r.BillingCity;
        wasFieldInSOQL = returnResult[0].Entity_Name__r.BillingState;
        wasFieldInSOQL = returnResult[0].Entity_Name__r.BillingPostalCode;
        wasFieldInSOQL = returnResult[0].Entity_Name__r.Record_Type_Description__c;
    }

    @IsTest
    static void it_should_retrieve_Included_EbAccount_Relationships_by_AgreementId() {
        Account testEntity = ObjectFactory.getValidEntity('testEntity');
        EB_Account__c  ebAccount = ObjectFactory.getEBAccount('Test Account Title', '12345-15', testEntity);
        Agreement__c testAgmt = ObjectFactory.getAgreement('Active', 'Test Borr', 'New Test Agmt');
        Agreement_EB_Account_Relationship__c ebrel = ObjectFactory.getAgreementEBAccountRelationship(testAgmt, ebAccount);

        List<Agreement_EB_Account_Relationship__c> returnResult = sut.getIncludedEbAccountRelationshipsByAgreementId(testAgmt.Id);

        System.assertEquals(1, returnResult.size());
        Object wasFieldInSOQL;
        wasFieldInSOQL = returnResult[0].Loan_Account__r.Id;
        wasFieldInSOQL = returnResult[0].Loan_Account__r.Name;
        wasFieldInSOQL = returnResult[0].Loan_Account__r.Account_status__c;
        wasFieldInSOQL = returnResult[0].Loan_Account__r.Account_Line_1__c;
        wasFieldInSOQL = returnResult[0].Loan_Account__r.Core_Current_Balance__c;
    }

    @IsTest
    static void it_should_retrieve_Excluded_EbAccounts() {
        Account testEntityIncluded = ObjectFactory.getValidEntity('testEntity');
        EB_Account__c  ebAccountIncluded = ObjectFactory.getEBAccount('Test Account Title', '12345-15', testEntityIncluded);
        ebAccountIncluded.Application__c = 11;
        Account testEntityNotIncluded = ObjectFactory.getValidEntity('testEntity2');
        EB_Account__c  ebAccountNotIncluded = ObjectFactory.getEBAccount('Test Account Title', '12345-15', testEntityNotIncluded);
        ebAccountNotIncluded.Application__c = 11;
        EB_Account_Relationship__c ebAcctRel = ObjectFactory.relateEntityToEBAccountObj(testEntityIncluded, ebAccountIncluded);
        List<EB_Account__c> ebAccountsIncludedOnAgreement = new List<EB_Account__c>{ebAccountNotIncluded};
        Set<Id> entitiesIncludedOnAgreement = new Set<Id>{testEntityIncluded.Id};

        List<EB_Account__c> returnResult = sut.getExcludedEbAccounts(entitiesIncludedOnAgreement, ebAccountsIncludedOnAgreement);

        System.assertEquals(1, returnResult.size());
        Object wasFieldInSOQL;
        wasFieldInSOQL = returnResult[0].Id;
        wasFieldInSOQL = returnResult[0].Name;
        wasFieldInSOQL = returnResult[0].Account_Line_1__c;
        wasFieldInSOQL = returnResult[0].Core_Current_Balance__c;
    }

    @IsTest
    static void it_should_retrieve_included_Loan_App_Relationships_by_AgreementId() {
        EB_Loan_App_Stage__c appStage = TestUtilities.createLoanAppStage('New','',1.1);
        insert appStage;

        Agreement__c testAgmt = ObjectFactory.getAgreement('Active', 'Prim Borr', 'Comments');
        Account testEntity = ObjectFactory.getValidEntity('testEntity');  
        Eb_Account__c newEBAccount = ObjectFactory.getEBAccount('test Account','1234', testEntity);   
        EB_Loan_Packet__c newPacket = ObjectFactory.getLoanPacket(testEntity);
        EB_Loan_Application__c ebLoanApp = ObjectFactory.getLoanApplication(newPacket, newEBAccount, '123445');
        Agreement_Loan_Application_Relationship__c agmtLoanAppRel = ObjectFactory.getAgreementLoanApplicationRelationship(testAgmt, ebLoanApp);   

        List<Agreement_Loan_Application_Relationship__c> returnResult = sut.getIncludedLoanAppRelationshipsByAgreementId(testAgmt.Id);

        System.assertEquals(1, returnResult.size());
        Object wasFieldInSOQL;
        wasFieldInSOQL = returnResult[0].Id;
        wasFieldInSOQL = returnResult[0].Loan_Application__c;
        wasFieldInSOQL = returnResult[0].Loan_Application__r.Name;
        wasFieldInSOQL = returnResult[0].Loan_Application__r.EB_Loan_Packet__r.Name;
        wasFieldInSOQL = returnResult[0].Loan_Application__r.EB_Loan_Packet__r.Lead_Entity__r.Name;
        wasFieldInSOQL = returnResult[0].Loan_Application__r.Total_Loan_Amount__c;
        wasFieldInSOQL = returnResult[0].Loan_Application__r.Application_Stage__r.Name;
    }

    @IsTest
    static void it_should_retrieve_Excluded_Loan_Apps() {
        EB_Loan_App_Stage__c appStage = TestUtilities.createLoanAppStage('New','',1.1);
        insert appStage;

        Account testEntity1 = ObjectFactory.getValidEntity('testEntity1');
        Account testEntity2 = ObjectFactory.getValidEntity('testEntity2');
        Set<Id> entitiesIncludedOnAgreement = new Set<Id>{testEntity1.Id};
        Eb_Account__c newEBAccount = ObjectFactory.getEBAccount('test Account','1234', testEntity2);      
        EB_Loan_Packet__c newPacket = ObjectFactory.getLoanPacket(testEntity2);
        EB_Loan_Application__c ebLoanAppIncluded = ObjectFactory.getLoanApplication(newPacket, newEBAccount, '123445');
        EB_Loan_Application__c ebLoanAppNotIncluded = ObjectFactory.getLoanApplication(newPacket, newEBAccount, '123445');
        EB_Loan_App_Entity_Relationship__c ebLoanAppEntityRelIncluded = ObjectFactory.getLoanAppEntityRelationship(testEntity1,ebLoanAppIncluded);
        EB_Loan_App_Entity_Relationship__c ebLoanAppEntityRelNotIncluded = ObjectFactory.getLoanAppEntityRelationship(testEntity1,ebLoanAppNotIncluded);
        List<EB_Loan_Application__c> loanAppsIncludedOnAgreement = new List<EB_Loan_Application__c>{ebLoanAppIncluded};

        List<EB_Loan_Application__c> returnResult = sut.getExcludedLoanApps(entitiesIncludedOnAgreement, loanAppsIncludedOnAgreement);

        System.assertEquals(1, returnResult.size());
        Object wasFieldInSOQL;
        wasFieldInSOQL = returnResult[0].Id;
        wasFieldInSOQL = returnResult[0].Name;
        wasFieldInSOQL = returnResult[0].EB_Loan_Packet__c;
        wasFieldInSOQL = returnResult[0].EB_Loan_Packet__r.Name;
        wasFieldInSOQL = returnResult[0].EB_Loan_Packet__r.Lead_Entity__c;
        wasFieldInSOQL = returnResult[0].Lead_Entity__c;
        wasFieldInSOQL = returnResult[0].Lead_Entity_With_Link__c;
        wasFieldInSOQL = returnResult[0].Total_Loan_Amount__c;
        wasFieldInSOQL = returnResult[0].Application_Stage__r.Name;
    }

    @IsTest
    static void it_should_insert_when_saving_a_new_object() {
        Agreement__c testAgmt = new Agreement__c();
        Integer totalAgmtPreCall = [SELECT Id FROM Agreement__c WHERE Id =: testAgmt.Id].size();

        sut.save(testAgmt);

        Integer totalAgmtPostCall = [SELECT Id FROM Agreement__c WHERE Id =: testAgmt.Id].size();
        System.assertEquals(0, totalAgmtPreCall);
        System.assertEquals(1, totalAgmtPostCall);
    }   

    @IsTest
    static void it_should_update_when_saving_an_existing_object() {
        Agreement__c testAgmt = ObjectFactory.getAgreement('Active', 'Test Borr', 'New Test Agmt');
        Integer totalAgmtPreCall = [SELECT Id FROM Agreement__c WHERE Id =: testAgmt.Id].size();
        testAgmt.Borrower_Summary__c = 'abc';

        sut.save(testAgmt);

        List<Agreement__c> agmtsPostCall = [SELECT Id, Borrower_Summary__c FROM Agreement__c WHERE Id =: testAgmt.Id];
        Integer totalAgmtPostCall = agmtsPostCall.size();
        System.assertEquals(1, totalAgmtPreCall);
        System.assertEquals(1, totalAgmtPostCall);
        System.assertEquals('abc', agmtsPostCall[0].Borrower_Summary__c);
    }

    @IsTest
    static void it_should_findAgreementLoanApplicationRelationship() {
        Agreement__c agmt = new Agreement__c();
        insert agmt;
        
        EB_Loan_App_Stage__c appStage = TestUtilities.createLoanAppStage('New','',1.1);
        insert appStage;

        Account testEntity = ObjectFactory.getValidEntity('testEntity');
        Eb_Account__c newEBAccount = ObjectFactory.getEBAccount('test Account','1234', testEntity);    
        EB_Loan_Packet__c newPacket = ObjectFactory.getLoanPacket(testEntity);
        EB_Loan_Application__c loanApp = ObjectFactory.getLoanApplication(newPacket, newEBAccount, '123445');

        Agreement_Loan_Application_Relationship__c rel = new Agreement_Loan_Application_Relationship__c();
        rel.Agreement__c = agmt.Id; 
        rel.Loan_Application__c = loanApp.Id;        
        insert rel;

        Agreement_Loan_Application_Relationship__c result = sut.findAgreementLoanApplicationRelationship(agmt.Id, loanApp.Id);

        System.assertEquals(rel.Id, result.Id);
    }

    @IsTest
    static void it_should_findAgreementLlcBiLoanRelationship() {
        Agreement__c agmt = new Agreement__c();
        insert agmt;

        LLC_BI__Loan__c loanApp = new LLC_BI__Loan__c();
        insert loanApp;

        Agreement_LLC_BI_Loan_Relationship__c rel = new Agreement_LLC_BI_Loan_Relationship__c();
        rel.Agreement__c = agmt.Id; 
        rel.LLCBI_Loan__c = loanApp.Id;        
        insert rel;

        Agreement_LLC_BI_Loan_Relationship__c result = sut.findAgreementLlcBiLoanRelationship(agmt.Id, loanApp.Id);

        System.assertEquals(rel.Id, result.Id);
    }

    @IsTest
    static void it_should_remove_a_given_record_of_any_object_type() {
        Agreement__c testAgmt = ObjectFactory.getAgreement('Active', 'Test Borr', 'New Test Agmt');
        Integer totalAgmtPreCall = [SELECT Id FROM Agreement__c WHERE Id =: testAgmt.Id].size();

        sut.remove(testAgmt);

        Integer totalAgmtPostCall = [SELECT Id FROM Agreement__c WHERE Id =: testAgmt.Id].size();
        System.assertEquals(1, totalAgmtPreCall);
        System.assertEquals(0, totalAgmtPostCall);
    }

    @IsTest
    static void it_should_retrieve_included_Agmt_Llc_Bi_Loan_Credit_Request_Relationships_given_agreement_id(){
        Id agmtId = ObjectFactory.getAgreement('Active', 'Test Borr', 'New Test Agmt').Id;
        Account testEntity1 = ObjectFactory.getValidEntity('testEntity1');
        LLC_BI__Product_Package__c prodPackage = new LLC_BI__Product_Package__c();
        insert prodPackage;
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        loan.LLC_BI__Account__r = testEntity1;
        loan.LLC_BI__Product_Package__r = prodPackage;
        loan.LLC_BI__Amount__c = 123.45;
        loan.RecordTypeId = ObjectFactory.getRecordTypeIdByNameAndObject('nCino UI - Commercial', 'LLC_BI__Loan__c');
        insert loan;
        Agreement_LLC_BI_Loan_Relationship__c agmtLlcBiLoanRel = new Agreement_LLC_BI_Loan_Relationship__c(Agreement__c=agmtId,LLCBI_Loan__c=loan.Id);
        insert agmtLlcBiLoanRel;

        List<Agreement_LLC_BI_Loan_Relationship__c> returnResult = sut.getIncludedLlcBiLoanRelationshipsByAgreementId(agmtId);

        System.assertEquals(1, returnResult.size());
        Object wasFieldInSOQL;
        wasFieldInSOQL = returnResult[0].LLCBI_Loan__r.Id;
        wasFieldInSOQL = returnResult[0].LLCBI_Loan__r.Name;
        wasFieldInSOQL = returnResult[0].LLCBI_Loan__r.LLC_BI__Account__r.Id;
        wasFieldInSOQL = returnResult[0].LLCBI_Loan__r.LLC_BI__Account__r.Name;
        wasFieldInSOQL = returnResult[0].LLCBI_Loan__r.LLC_BI__Product_Package__r.Name;
        wasFieldInSOQL = returnResult[0].LLCBI_Loan__r.LLC_BI__Amount__c;
    }

    @IsTest
    static void it_should_not_return_loan_relationships_when_their_loans_are_booked(){
        Id agmtId = ObjectFactory.getAgreement('Active', 'Test Borr', 'New Test Agmt').Id;
        List<LLC_BI__Loan__c> testLoans = new List<LLC_BI__Loan__c>();
        List<Agreement_LLC_BI_Loan_Relationship__c> testAgmtLoanRels = new List<Agreement_LLC_BI_Loan_Relationship__c>();

        LLC_BI__Loan__c loan1 = new LLC_BI__Loan__c();
        loan1.RecordTypeId = ObjectFactory.getRecordTypeIdByNameAndObject('nCino UI - Commercial', 'LLC_BI__Loan__c');
        loan1.name = 'test1';
        testLoans.add(loan1);
        LLC_BI__Loan__c loan3 = new LLC_BI__Loan__c();
        loan3.RecordTypeId = ObjectFactory.getRecordTypeIdByNameAndObject('nCino UI - Commercial', 'LLC_BI__Loan__c');
        loan3.name = 'test3';
        loan3.LLC_BI__Product_Line__c = 'Commercial/Business';
        // 'commercial-booked-ui.dashboard-commercial-booked-ui-loan' applied to default app by loan trigger
        testLoans.add(loan3);
        LLC_BI__Loan__c loan4 = new LLC_BI__Loan__c();
        loan4.RecordTypeId = ObjectFactory.getRecordTypeIdByNameAndObject('nCino UI - Commercial', 'LLC_BI__Loan__c');
        loan4.name = 'test4';
        loan4.LLC_BI__Product_Line__c = 'Mortgage';
        // 'consumer-booked-ui.dashboard-consumer-booked-ui-loan' applied to default app by loan trigger
        testLoans.add(loan4);
        LLC_BI__Loan__c loan5 = new LLC_BI__Loan__c();
        loan5.RecordTypeId = ObjectFactory.getRecordTypeIdByNameAndObject('nCino UI - Commercial', 'LLC_BI__Loan__c');
        loan5.name = 'test5';
        loan5.LLC_BI__Product__c = 'Credit Card';
        // 'credit-booked-ui.dashboard-credit-booked-ui-loan' applied to default app by loan trigger
        testLoans.add(loan5);
        
        insert testLoans;

        loan3.LLC_BI__Stage__c = 'Booked';
        loan4.LLC_BI__Stage__c = 'Booked';
        loan5.LLC_BI__Stage__c = 'Booked';
        update testLoans;

        Agreement_LLC_BI_Loan_Relationship__c agmtLoanRel1 = new Agreement_LLC_BI_Loan_Relationship__c();
        agmtLoanRel1.Agreement__c = agmtId;
        agmtLoanRel1.LLCBI_Loan__c = loan1.Id;
        testAgmtLoanRels.add(agmtLoanRel1);
        Agreement_LLC_BI_Loan_Relationship__c agmtLoanRel3 = new Agreement_LLC_BI_Loan_Relationship__c();
        agmtLoanRel3.Agreement__c = agmtId;
        agmtLoanRel3.LLCBI_Loan__c = loan3.Id;
        testAgmtLoanRels.add(agmtLoanRel3);
        Agreement_LLC_BI_Loan_Relationship__c agmtLoanRel4 = new Agreement_LLC_BI_Loan_Relationship__c();
        agmtLoanRel4.Agreement__c = agmtId;
        agmtLoanRel4.LLCBI_Loan__c = loan4.Id;
        testAgmtLoanRels.add(agmtLoanRel4);
        Agreement_LLC_BI_Loan_Relationship__c agmtLoanRel5 = new Agreement_LLC_BI_Loan_Relationship__c();
        agmtLoanRel5.Agreement__c = agmtId;
        agmtLoanRel5.LLCBI_Loan__c = loan5.Id;
        testAgmtLoanRels.add(agmtLoanRel5);
        
        insert testAgmtLoanRels;

        List<Agreement_LLC_BI_Loan_Relationship__c> result = sut.getIncludedLlcBiLoanRelationshipsByAgreementId(agmtId);
        
        System.assertEquals(1, result.size());
        System.assertEquals(loan1.Id, result[0].LLCBI_Loan__r.Id);
    }

    @IsTest
    static void it_should_retrieve_loan_app_entity_rels_given_entity_ids(){
        Set<Id> entityIds = new Set<Id>();

        Account testEntity = ObjectFactory.getValidEntity('TestEntityName');
        entityIds.add(testEntity.Id);

        EB_Loan_App_Stage__c appStage = TestUtilities.createLoanAppStage('New','',1.1);
        insert appStage;

        Eb_Account__c newEBAccount = ObjectFactory.getEBAccount('test Account','1234', testEntity);    
        EB_Loan_Packet__c newPacket = ObjectFactory.getLoanPacket(testEntity);
        EB_Loan_Application__c loanApp = ObjectFactory.getLoanApplication(newPacket, newEBAccount, '123445');

        EB_Loan_App_Entity_Relationship__c rel = new EB_Loan_App_Entity_Relationship__c();
        rel.Entity_Name__c = testEntity.Id;
        rel.Loan_Application_ID__c = loanApp.Id;
        rel.Relationship_Type__c = 'Guarantor';
        insert rel;

        List<EB_Loan_App_Entity_Relationship__c> result = sut.getEntityLoanAppRelationshipsByEntityIds(entityIds);

        System.assertEquals(1, result.size());
        Object wasFieldInSOQL;
        wasFieldInSOQL = result[0].Loan_Application_ID__c;
        wasFieldInSOQL = result[0].Loan_Application_ID__r.Name;
        wasFieldInSOQL = result[0].Loan_Application_ID__r.EB_Loan_Packet__r.Name;
        wasFieldInSOQL = result[0].Loan_Application_ID__r.EB_Loan_Packet__r.Lead_Entity__r.Name;
        wasFieldInSOQL = result[0].Loan_Application_ID__r.Total_Loan_Amount__c;
        wasFieldInSOQL = result[0].Loan_Application_ID__r.Application_Stage__r.Name;
        wasFieldInSOQL = result[0].Entity_Name__r.Id;
    }

    @IsTest
    static void it_should_retrieve_loan_app_entity_rels_given_app_ids(){
        Set<Id> appIds = new Set<Id>();

        Account testEntity = ObjectFactory.getValidEntity('TestEntityName');

        EB_Loan_App_Stage__c appStage = TestUtilities.createLoanAppStage('New','',1.1);
        insert appStage;

        Eb_Account__c newEBAccount = ObjectFactory.getEBAccount('test Account','1234', testEntity);    
        EB_Loan_Packet__c newPacket = ObjectFactory.getLoanPacket(testEntity);
        EB_Loan_Application__c loanApp = ObjectFactory.getLoanApplication(newPacket, newEBAccount, '123445');
        appIds.add(loanApp.Id);

        EB_Loan_App_Entity_Relationship__c rel = new EB_Loan_App_Entity_Relationship__c();
        rel.Entity_Name__c = testEntity.Id;
        rel.Loan_Application_ID__c = loanApp.Id;
        rel.Relationship_Type__c = 'Guarantor';
        insert rel;

        List<EB_Loan_App_Entity_Relationship__c> result = sut.getEntityLoanAppRelationshipsByAppIds(appIds);

        System.assertEquals(1, result.size());
        Object wasFieldInSOQL;
        wasFieldInSOQL = result[0].Loan_Application_ID__c;
        wasFieldInSOQL = result[0].Loan_Application_ID__r.Name;
        wasFieldInSOQL = result[0].Loan_Application_ID__r.EB_Loan_Packet__r.Name;
        wasFieldInSOQL = result[0].Loan_Application_ID__r.EB_Loan_Packet__r.Lead_Entity__r.Name;
        wasFieldInSOQL = result[0].Loan_Application_ID__r.Total_Loan_Amount__c;
        wasFieldInSOQL = result[0].Loan_Application_ID__r.Application_Stage__r.Name;
        wasFieldInSOQL = result[0].Entity_Name__r.Id;
        wasFieldInSOQL = result[0].Entity_Name__r.Entity_Name__c;
        wasFieldInSOQL = result[0].Entity_Name__r.Record_Type_Description__c;
        wasFieldInSOQL = result[0].Entity_Name__r.BillingStreet; 
        wasFieldInSOQL = result[0].Entity_Name__r.BillingCity; 
        wasFieldInSOQL = result[0].Entity_Name__r.BillingState; 
        wasFieldInSOQL = result[0].Entity_Name__r.BillingPostalCode;
    }

    @IsTest
    static void it_should_retrieve_llc_bi_entity_involvements_given_entity_ids(){
        Set<Id> entityIds = new Set<Id>();

        Account testEntity = ObjectFactory.getValidEntity('Test Name');
        entityIds.add(testEntity.Id);

        LLC_BI__Loan__c loanApp = new LLC_BI__Loan__c();
        loanApp.RecordTypeId = ObjectFactory.getRecordTypeIdByNameAndObject('nCino UI - Commercial', 'LLC_BI__Loan__c');
        insert loanApp;

        LLC_BI__Legal_Entities__c rel = new LLC_BI__Legal_Entities__c();
        rel.LLC_BI__Account__c = testEntity.Id;
        rel.LLC_BI__Loan__c = loanApp.Id;
        insert rel;

        List<LLC_BI__Legal_Entities__c> result = sut.getLlcBiEntityInvolvementsByEntityIds(entityIds);

        System.assertEquals(1, result.size());
        Object wasFieldInSOQL;
        wasFieldInSOQL = result[0].LLC_BI__Loan__c;
        wasFieldInSOQL = result[0].LLC_BI__Loan__r.Name;
        wasFieldInSOQL = result[0].LLC_BI__Loan__r.LLC_BI__Account__r.Id;
        wasFieldInSOQL = result[0].LLC_BI__Loan__r.LLC_BI__Account__r.Name;
        wasFieldInSOQL = result[0].LLC_BI__Loan__r.LLC_BI__Product_Package__r.Name;
        wasFieldInSOQL = result[0].LLC_BI__Loan__r.LLC_BI__Amount__c;
        wasFieldInSOQL = result[0].LLC_BI__Account__r.Id;
    }

    @IsTest
    static void it_should_not_return_llc_bi_entity_involvements_when_their_loans_are_booked() {
        Set<Id> entityIds = new Set<Id>();
        List<LLC_BI__Loan__c> testLoans = new List<LLC_BI__Loan__c>();
        List<LLC_BI__Legal_Entities__c> testRels = new List<LLC_BI__Legal_Entities__c>();

        Account testEntity = ObjectFactory.getValidEntity('Test Name');
        entityIds.add(testEntity.Id);

        LLC_BI__Loan__c loan1 = new LLC_BI__Loan__c();
        loan1.RecordTypeId = ObjectFactory.getRecordTypeIdByNameAndObject('nCino UI - Commercial', 'LLC_BI__Loan__c');
        testLoans.add(loan1);
        LLC_BI__Loan__c loan3 = new LLC_BI__Loan__c();
        loan3.RecordTypeId = ObjectFactory.getRecordTypeIdByNameAndObject('nCino UI - Commercial', 'LLC_BI__Loan__c');
        loan3.LLC_BI__Product_Line__c = 'Commercial/Business';
        // 'commercial-booked-ui.dashboard-commercial-booked-ui-loan' applied to default app by loan trigger
        testLoans.add(loan3);
        LLC_BI__Loan__c loan4 = new LLC_BI__Loan__c();
        loan4.RecordTypeId = ObjectFactory.getRecordTypeIdByNameAndObject('nCino UI - Commercial', 'LLC_BI__Loan__c');
        loan4.LLC_BI__Product_Line__c = 'Mortgage';
        // 'consumer-booked-ui.dashboard-consumer-booked-ui-loan' applied to default app by loan trigger
        testLoans.add(loan4);
        LLC_BI__Loan__c loan5 = new LLC_BI__Loan__c();
        loan5.RecordTypeId = ObjectFactory.getRecordTypeIdByNameAndObject('nCino UI - Commercial', 'LLC_BI__Loan__c');
        loan5.LLC_BI__Product__c = 'Credit Card';
        // 'credit-booked-ui.dashboard-credit-booked-ui-loan' applied to default app by loan trigger
        testLoans.add(loan5);
        insert testLoans;
        
        loan3.LLC_BI__Stage__c = 'Booked';
        loan4.LLC_BI__Stage__c = 'Booked';
        loan5.LLC_BI__Stage__c = 'Booked';
        update testLoans;

        LLC_BI__Legal_Entities__c rel1 = new LLC_BI__Legal_Entities__c();
        rel1.LLC_BI__Account__c = testEntity.Id;
        rel1.LLC_BI__Loan__c = loan1.Id;
        testRels.add(rel1);
        LLC_BI__Legal_Entities__c rel3 = new LLC_BI__Legal_Entities__c();
        rel3.LLC_BI__Account__c = testEntity.Id;
        rel3.LLC_BI__Loan__c = loan3.Id;
        testRels.add(rel3);
        LLC_BI__Legal_Entities__c rel4 = new LLC_BI__Legal_Entities__c();
        rel4.LLC_BI__Account__c = testEntity.Id;
        rel4.LLC_BI__Loan__c = loan4.Id;
        testRels.add(rel4);
        LLC_BI__Legal_Entities__c rel5 = new LLC_BI__Legal_Entities__c();
        rel5.LLC_BI__Account__c = testEntity.Id;
        rel5.LLC_BI__Loan__c = loan4.Id;
        testRels.add(rel5);
        insert testRels;

        List<LLC_BI__Legal_Entities__c> result = sut.getLlcBiEntityInvolvementsByEntityIds(entityIds);

        System.assertEquals(1, result.size());
        System.assertEquals(loan1.Id, result[0].LLC_BI__Loan__r.Id);
    }

    @IsTest
    static void it_should_retrieve_llc_bi_entity_involvements_given_app_ids(){
        Set<Id> appIds = new Set<Id>();

        Account testEntity = ObjectFactory.getValidEntity('Test Name');

        LLC_BI__Loan__c loanApp = new LLC_BI__Loan__c();
        loanApp.RecordTypeId = ObjectFactory.getRecordTypeIdByNameAndObject('nCino UI - Commercial', 'LLC_BI__Loan__c');
        insert loanApp;
        appIds.add(loanApp.Id);

        LLC_BI__Legal_Entities__c rel = new LLC_BI__Legal_Entities__c();
        rel.LLC_BI__Account__c = testEntity.Id;
        rel.LLC_BI__Loan__c = loanApp.Id;
        insert rel;

        List<LLC_BI__Legal_Entities__c> result = sut.getLlcBiEntityInvolvementsByAppIds(appIds);

        System.assertEquals(1, result.size());
        Object wasFieldInSOQL;
        wasFieldInSOQL = result[0].LLC_BI__Loan__c;
        wasFieldInSOQL = result[0].LLC_BI__Loan__r.Name;
        wasFieldInSOQL = result[0].LLC_BI__Loan__r.LLC_BI__Account__r.Id;
        wasFieldInSOQL = result[0].LLC_BI__Loan__r.LLC_BI__Account__r.Name;
        wasFieldInSOQL = result[0].LLC_BI__Loan__r.LLC_BI__Product_Package__r.Name;
        wasFieldInSOQL = result[0].LLC_BI__Loan__r.LLC_BI__Amount__c;
        wasFieldInSOQL = result[0].LLC_BI__Account__r.Id;
        wasFieldInSOQL = result[0].LLC_BI__Account__r.Entity_Name__c;
        wasFieldInSOQL = result[0].LLC_BI__Account__r.Record_Type_Description__c;
        wasFieldInSOQL = result[0].LLC_BI__Account__r.BillingStreet; 
        wasFieldInSOQL = result[0].LLC_BI__Account__r.BillingCity; 
        wasFieldInSOQL = result[0].LLC_BI__Account__r.BillingState; 
        wasFieldInSOQL = result[0].LLC_BI__Account__r.BillingPostalCode;
    }

    @IsTest
    static void it_should_not_retrieve_llc_bi_entity_involvements_when_their_loans_are_booked(){
        Account testEntity = ObjectFactory.getValidEntity('Test Name');
        List<LLC_BI__Loan__c> testLoans = new List<LLC_BI__Loan__c>();
        List<LLC_BI__Legal_Entities__c> testRels = new List<LLC_BI__Legal_Entities__c>();
        
        LLC_BI__Loan__c loan1 = new LLC_BI__Loan__c();
        loan1.RecordTypeId = ObjectFactory.getRecordTypeIdByNameAndObject('nCino UI - Commercial', 'LLC_BI__Loan__c');
        loan1.LLC_BI__Default_App__c = 'this is the loan that should be returned';
        testLoans.add(loan1);
        LLC_BI__Loan__c loan3 = new LLC_BI__Loan__c();
        loan3.RecordTypeId = ObjectFactory.getRecordTypeIdByNameAndObject('nCino UI - Commercial', 'LLC_BI__Loan__c');
        loan3.LLC_BI__Product_Line__c = 'Commercial/Business';
        // 'commercial-booked-ui.dashboard-commercial-booked-ui-loan' applied to default app by loan trigger
        testLoans.add(loan3);
        LLC_BI__Loan__c loan4 = new LLC_BI__Loan__c();
        loan4.RecordTypeId = ObjectFactory.getRecordTypeIdByNameAndObject('nCino UI - Commercial', 'LLC_BI__Loan__c');
        loan4.LLC_BI__Product_Line__c = 'Mortgage';
        // 'consumer-booked-ui.dashboard-consumer-booked-ui-loan' applied to default app by loan trigger
        testLoans.add(loan4);
        LLC_BI__Loan__c loan5 = new LLC_BI__Loan__c();
        loan5.RecordTypeId = ObjectFactory.getRecordTypeIdByNameAndObject('nCino UI - Commercial', 'LLC_BI__Loan__c');
        loan5.LLC_BI__Product__c = 'Credit Card';
        // 'credit-booked-ui.dashboard-credit-booked-ui-loan' applied to default app by loan trigger
        testLoans.add(loan5);
        insert testLoans;

        loan3.LLC_BI__Stage__c = 'Booked';
        loan4.LLC_BI__Stage__c = 'Booked';
        loan5.LLC_BI__Stage__c = 'Booked';
        update testLoans;
        
        Set<Id> appIds = new Set<Id>{loan1.Id, loan3.Id, loan4.Id, loan5.Id};

        LLC_BI__Legal_Entities__c rel1 = new LLC_BI__Legal_Entities__c();
        rel1.LLC_BI__Account__c = testEntity.Id;
        rel1.LLC_BI__Loan__c = loan1.Id;
        testRels.add(rel1);
        LLC_BI__Legal_Entities__c rel3 = new LLC_BI__Legal_Entities__c();
        rel3.LLC_BI__Account__c = testEntity.Id;
        rel3.LLC_BI__Loan__c = loan3.Id;
        testRels.add(rel3);
        LLC_BI__Legal_Entities__c rel4 = new LLC_BI__Legal_Entities__c();
        rel4.LLC_BI__Account__c = testEntity.Id;
        rel4.LLC_BI__Loan__c = loan4.Id;
        testRels.add(rel4);
        LLC_BI__Legal_Entities__c rel5 = new LLC_BI__Legal_Entities__c();
        rel5.LLC_BI__Account__c = testEntity.Id;
        rel5.LLC_BI__Loan__c = loan5.Id;
        testRels.add(rel5);

        insert testRels;

        List<LLC_BI__Legal_Entities__c> result = sut.getLlcBiEntityInvolvementsByAppIds(appIds);

        System.assertEquals(1, result.size());
        System.assertEquals(loan1.Id, result[0].LLC_BI__Loan__r.Id);
    }

    @IsTest
    static void it_should_retrieve_RenewalModParentLoanRelationships_given_loan_ids(){
        List<LLC_BI__Loan__c> loans = new List<LLC_BI__Loan__c>();
        LLC_BI__Loan__c loan1 = new LLC_BI__Loan__c();
        LLC_BI__Loan__c loan2 = new LLC_BI__Loan__c();
        LLC_BI__Loan__c loan3 = new LLC_BI__Loan__c();
        LLC_BI__Loan__c loan4 = new LLC_BI__Loan__c();
        loans.add(loan1);
        loans.add(loan2);
        loans.add(loan3);
        loans.add(loan4);
        insert loans;
        
        List<LLC_BI__LoanRenewal__c> renewals = new List<LLC_BI__LoanRenewal__c>();
        LLC_BI__LoanRenewal__c renewalModParentLoanRel1 = new LLC_BI__LoanRenewal__c();
        renewalModParentLoanRel1.LLC_BI__RenewalLoanId__c = loan1.Id;
        renewalModParentLoanRel1.LLC_BI__ParentLoanId__c = loan2.Id;
        renewalModParentLoanRel1.LLC_BI__PreviousVersionStage__c = 'Booked';
        renewalModParentLoanRel1.LLC_BI__PreviousVersionStatus__c = 'Open';
        LLC_BI__LoanRenewal__c renewalModParentLoanRel2 = new LLC_BI__LoanRenewal__c();
        renewalModParentLoanRel2.LLC_BI__RenewalLoanId__c = loan2.Id;
        renewalModParentLoanRel2.LLC_BI__ParentLoanId__c = loan3.Id;
        renewalModParentLoanRel2.LLC_BI__PreviousVersionStage__c = 'Booked';
        renewalModParentLoanRel2.LLC_BI__PreviousVersionStatus__c = 'Open';
        LLC_BI__LoanRenewal__c renewalModParentLoanRel3 = new LLC_BI__LoanRenewal__c();
        renewalModParentLoanRel3.LLC_BI__RenewalLoanId__c = loan3.Id;
        renewalModParentLoanRel3.LLC_BI__ParentLoanId__c = loan4.Id;
        renewalModParentLoanRel3.LLC_BI__PreviousVersionStage__c = 'Booked';
        renewalModParentLoanRel3.LLC_BI__PreviousVersionStatus__c = 'Open';        
        renewals.add(renewalModParentLoanRel1);
        renewals.add(renewalModParentLoanRel2);
        renewals.add(renewalModParentLoanRel3);
        insert renewals;        

        Set<Id> loanIds = new Set<Id>{loan1.Id, loan2.Id};

        List<LLC_BI__LoanRenewal__c> result = sut.getRenewalModParentLoanRelationships(loanIds);

        System.assertEquals(2, result.size());
        Object wasFieldInSOQL;
        wasFieldInSOQL = result[0].Id;
        wasFieldInSOQL = result[0].LLC_BI__RenewalLoanId__c;
        wasFieldInSOQL = result[0].LLC_BI__ParentLoanId__c;
        System.assertEquals(loan1.Id, result[0].LLC_BI__RenewalLoanId__c);
        System.assertEquals(loan2.Id, result[0].LLC_BI__ParentLoanId__c);
        System.assertEquals(loan2.Id, result[1].LLC_BI__RenewalLoanId__c);
        System.assertEquals(loan3.Id, result[1].LLC_BI__ParentLoanId__c);
    }
}