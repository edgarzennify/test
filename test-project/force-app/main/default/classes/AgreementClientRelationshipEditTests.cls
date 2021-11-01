@isTest
private class AgreementClientRelationshipEditTests {

    static testMethod void code_coverage_Active() {
        Id rectype = objectfactory.getRecordTypeIdByNameAndObject('Client', 'Account');
        EB_Team_Member__c temMember = objectfactory.getTeamMember('officer');
        Account entity = objectfactory.getEntity('Hammer & Steel Inc.', rectype, temMember);
        
        Agreement__c agmt= objectfactory.getAgreement('Prospective', 'Hammer & Steel Inc.', 'Test');
        
        Agreement_Client_Relationships__c agmtClientrel = ObjectFactory.getAgreementClientRelationships('Hammer & Steel Inc.', agmt, entity);
        Agreement_Financial_Documents__c agmtDoc = new Agreement_Financial_Documents__c();
        agmtDoc.Agreement__c = agmt.Id;
        agmtDoc.Agreement_Client_Relationship__c = agmtClientrel.Id;
        insert agmtDoc;
        
        String url = Utility.getserverurl() + '/apex/AgreementClientRelationshipEdit?id=';        
        PageReference pr = Utility.testhelper(url + agmtClientrel.id);
        test.setCurrentPage(pr);
        
        AgreementClientRelationshipEdit testcontroller = new AgreementClientRelationshipEdit();
        
        PageReference a = testcontroller.SaveClicked();
        
        PageReference b = testcontroller.CancelClicked();
        
        PageReference c = testcontroller.SaveClicked(); 
        
        testController.agmtClientRel.Id = null;
        PageReference g = testcontroller.SaveClicked();
        
        testController.agmt.Id = null;
        PageReference h = testcontroller.CancelClicked(); 
        
        Object bogus = testcontroller.annualFinancialStatementPeriodOptions;
        bogus = testcontroller.interimStatementPeriodOptions;
        bogus = testcontroller.taxReturnPeriodOptions;
        bogus = testcontroller.showAnnualStatementPeriodOther;
        bogus = testcontroller.showInterimStatementPeriodOther;
        bogus = testcontroller.showTaxReturnPeriodOther;
        bogus = testcontroller.showEntitiesToCombine;
    }

    static testMethod void code_coverage_Pending() {
        Id rectype = objectfactory.getRecordTypeIdByNameAndObject('Client', 'Account');
        EB_Team_Member__c temMember = objectfactory.getTeamMember('officer');
        Account entity = objectfactory.getEntity('Hammer & Steel Inc.', rectype, temMember);
        
        Agreement__c agmt= objectfactory.getAgreement('Prospective', 'Hammer & Steel Inc.', 'Test');
        agmt.RecordTypeId = Utility.recordTypeObject('Agreement__c', 'Pending').Id;
        update agmt;
        
        Agreement_Client_Relationships__c agmtClientrel = ObjectFactory.getAgreementClientRelationships('Hammer & Steel Inc.', agmt, entity);
        Agreement_Financial_Documents__c agmtDoc = new Agreement_Financial_Documents__c();
        agmtDoc.Agreement__c = agmt.Id;
        agmtDoc.Agreement_Client_Relationship__c = agmtClientrel.Id;
        insert agmtDoc;
        
        String url = Utility.getServerUrl() + '/apex/AgreementClientRelationshipEdit?id=';        
        PageReference pr = Utility.testhelper(url + agmtClientrel.id);
        test.setCurrentPage(pr);
        
        AgreementClientRelationshipEdit testcontroller = new AgreementClientRelationshipEdit();
        
        for(AgreementClientRelationshipEdit.RecordTypePicklistObject rtObj : testcontroller.rtPickObjs){
            rtObj.pckValue = '<RecordTypeName><PListName><PListOption><PListOptions><NextRecord><NextRecord><PListName><RecordTypeName><PListOption><PListOptions>--None--<NextRecord>dfsds<NextRecord>page:j_id39:j_id40:AgmtReqsB:WrapperB:0:R1B:R2B:j_id143:j_id145';
        }
        testcontroller.setLoadOnceFlag();
        for(AgreementClientRelationshipEdit.RecordTypePicklistObject rtObj : testcontroller.rtPickObjs){
            rtObj.pickValue = 'one:two:three';
            rtObj.setNewValue();
            rtObj.showOtherField();
            Boolean ssd = rtObj.showStartDate;
        }
        
        PageReference a = testcontroller.SaveClicked();        
        PageReference b = testcontroller.CancelClicked();        
        PageReference c = testcontroller.SaveClicked();         

        String s = testcontroller.dropdownSelectedDocTypeIncludeId;
        
        testController.agmtClientRel.Id = null;
        PageReference g = testcontroller.SaveClicked();
        
        testController.agmt.Id = null;
        PageReference h = testcontroller.CancelClicked();
        
        Object selectOptions = testcontroller.personalFinancialStatementOptions;
        selectOptions = testcontroller.annualFinancialStatementOptions;
        selectOptions = testcontroller.otherTypeOptions;
        selectOptions = testcontroller.interimStatementOptions;
        selectOptions = testcontroller.taxReturnsOptions;
        selectOptions = testcontroller.annualFinancialStatementPeriodOptions;
        selectOptions = testcontroller.interimStatementPeriodOptions;
        selectOptions = testcontroller.taxReturnPeriodOptions;
    }

    static testMethod void it_should_return_the_ACTIVE_finreq_fields_for_an_ACTIVE_agreement_when_all_values_are_no() {
        Account testEntity = new Account();
        testEntity.Personal_Financial_Statement__c = 'No';
        testEntity.Annual_Financial_Statements__c = 'No';
        testEntity.Interim_Statements__c = 'No';
        testEntity.Tax_Returns__c = 'No';

        Agreement__c testAgmt = new Agreement__c(Id='a28f00000008zGI');
        testAgmt.RecordType = Utility.recordTypeObject('Agreement__c','Active');

        Agreement_Client_Relationships__c agmtClientRel = new Agreement_Client_Relationships__c();
        agmtClientRel.Entity__r = testEntity;
        agmtClientRel.Agreement__c = testAgmt.Id;

        MockOfIAgreementStatusManager mockStatusManager = new MockOfIAgreementStatusManager();
        MockOfIAgreementClientRelationshipEditDataProvider mockDataProvider = new MockOfIAgreementClientRelationshipEditDataProvider();
        MockOfIAgreementValidator mockValidator = new MockOfIAgreementValidator();
        mockDataProvider.getAgreementClientRelationshipById_Return = agmtClientRel;
        mockDataProvider.getAgreementFinancialDocuments_Return = new List<Agreement_Financial_Documents__c>();
        mockDataProvider.getAgreementById_Return = testAgmt;
        mockDataProvider.getAgreementFinancialDocumentsFilteredByRecordType_Return = new List<Agreement_Financial_Documents__c>();
        AgreementClientRelationshipEdit sut = new AgreementClientRelationshipEdit(mockStatusManager, mockDataProvider, mockValidator);

        AgreementClientRelationshipEdit.FinancialReportingRequirements finRptReqs = sut.finRptReqs;

        System.assertEquals('No', finRptReqs.Personal_Financial_Statement);
        System.assertEquals(null, finRptReqs.Personal_Financial_Statement_Frequency);
        System.assertEquals('No', finRptReqs.Annual_Financial_Statements);
        System.assertEquals(null, finRptReqs.Annual_Statement_Quality);
        System.assertEquals(null, finRptReqs.AFS_Fiscal_Year_End);
        System.assertEquals(null, finRptReqs.Annual_Stmt_Days_Due_After_Fiscal_Y_E);
        System.assertEquals(null, finRptReqs.Annual_Financial_Statement_Period_Other);
        System.assertEquals('', finRptReqs.Other_Type);
        System.assertEquals(null, finRptReqs.AFS_Entities_To_Combine);
        System.assertEquals('No', finRptReqs.Interim_Statements);
        System.assertEquals(null, finRptReqs.Interim_Stm_Prepared_By);
        System.assertEquals(null, finRptReqs.Interim_Stmt_Days_Due_After_Period_End);
        System.assertEquals(null, finRptReqs.Interim_Stmt_Days_Due_After_Period_End_Other);
        System.assertEquals('No', finRptReqs.Tax_Returns);
        System.assertEquals(null, finRptReqs.Tax_Return_Days_Due_After_Filing);
        System.assertEquals(null, finRptReqs.Tax_Return_Days_Due_After_Filing_Other);
    }

    static testMethod void it_should_return_the_ACTIVE_finreq_fields_for_an_ACTIVE_agreement_when_all_values_are_yes() {
        Account testEntity = new Account();
        testEntity.Personal_Financial_Statement__c = 'Yes';
        testEntity.Personal_Financial_Statement_Frequency__c = 'Annually';
        testEntity.Annual_Financial_Statements__c = 'Yes';
        testEntity.Annual_Statement_Quality__c = 'Self Prepared';
        testEntity.Fiscal_Year_End_Date__c = '01/02';
        testEntity.Annual_Stmt_Days_Due_After_Fiscal_Y_E__c = -1;
        testEntity.Annual_Financial_Statement_Period_Other__c = 50;
        testEntity.Other_Type__c = 'Combined';
        testEntity.Entities_To_Combine__c = 'me and you';
        testEntity.Interim_Statements__c = 'Monthly';
        testEntity.Interim_Stm_Prepared_By__c = 'Self Prepared';
        testEntity.Interim_Stmt_Days_Due_After_Period_End__c = -1;
        testEntity.Interim_Statement_Period_Other__c = 60;
        testEntity.Tax_Returns__c = 'Yes';
        testEntity.Tax_Return_Days_Due_After_Filing__c = -1;
        testEntity.Tax_Return_Period_Other__c = 70;

        Agreement__c testAgmt = new Agreement__c(Id='a28f00000008zGI');
        testAgmt.RecordType = Utility.recordTypeObject('Agreement__c','Active');

        Agreement_Client_Relationships__c agmtClientRel = new Agreement_Client_Relationships__c();
        agmtClientRel.Entity__r = testEntity;
        agmtClientRel.Agreement__c = testAgmt.Id;

        MockOfIAgreementStatusManager mockStatusManager = new MockOfIAgreementStatusManager();
        MockOfIAgreementClientRelationshipEditDataProvider mockDataProvider = new MockOfIAgreementClientRelationshipEditDataProvider();
        MockOfIAgreementValidator mockValidator = new MockOfIAgreementValidator();
        mockDataProvider.getAgreementClientRelationshipById_Return = agmtClientRel;
        mockDataProvider.getAgreementFinancialDocuments_Return = new List<Agreement_Financial_Documents__c>();
        mockDataProvider.getAgreementById_Return = testAgmt;
        mockDataProvider.getAgreementFinancialDocumentsFilteredByRecordType_Return = new List<Agreement_Financial_Documents__c>();
        AgreementClientRelationshipEdit sut = new AgreementClientRelationshipEdit(mockStatusManager, mockDataProvider, mockValidator);

        AgreementClientRelationshipEdit.FinancialReportingRequirements finRptReqs = sut.finRptReqs;

        System.assertEquals('Yes', finRptReqs.Personal_Financial_Statement);
        System.assertEquals('Annually', finRptReqs.Personal_Financial_Statement_Frequency);
        System.assertEquals('Yes', finRptReqs.Annual_Financial_Statements);
        System.assertEquals('Self Prepared', finRptReqs.Annual_Statement_Quality);
        System.assertEquals('01/02', finRptReqs.AFS_Fiscal_Year_End);
        System.assertEquals('Other (50)', finRptReqs.Annual_Stmt_Days_Due_After_Fiscal_Y_E);
        System.assertEquals('50', finRptReqs.Annual_Financial_Statement_Period_Other);
        System.assertEquals('Combined (me and you)', finRptReqs.Other_Type);
        System.assertEquals('me and you', finRptReqs.AFS_Entities_To_Combine);
        System.assertEquals('Monthly', finRptReqs.Interim_Statements);
        System.assertEquals('Self Prepared', finRptReqs.Interim_Stm_Prepared_By);
        System.assertEquals('Other (60)', finRptReqs.Interim_Stmt_Days_Due_After_Period_End);
        System.assertEquals('60', finRptReqs.Interim_Stmt_Days_Due_After_Period_End_Other);
        System.assertEquals('Yes', finRptReqs.Tax_Returns);
        System.assertEquals('Other (70)', finRptReqs.Tax_Return_Days_Due_After_Filing);
        System.assertEquals('70', finRptReqs.Tax_Return_Days_Due_After_Filing_Other);
    }

    static testMethod void it_should_return_the_PENDING_finreq_EDIT_fields_for_a_PENDING_agreement_when_all_values_are_no() {
        Account testEntity = new Account();
        testEntity.Pending_PFS__c = 'No';
        testEntity.Pending_AFS__c = 'No';
        testEntity.Pending_IntStmts__c = 'No';
        testEntity.Pending_TaxReturns__c = 'No';
        
        Agreement__c testAgmt = new Agreement__c(Id='a28f00000008zGI');
        testAgmt.RecordType = Utility.recordTypeObject('Agreement__c','Pending');

        Agreement_Client_Relationships__c agmtClientRel = new Agreement_Client_Relationships__c();
        agmtClientRel.Entity__r = testEntity;
        agmtClientRel.Agreement__c = testAgmt.Id;

        MockOfIAgreementStatusManager mockStatusManager = new MockOfIAgreementStatusManager();
        MockOfIAgreementClientRelationshipEditDataProvider mockDataProvider = new MockOfIAgreementClientRelationshipEditDataProvider();
        MockOfIAgreementValidator mockValidator = new MockOfIAgreementValidator();
        mockDataProvider.getAgreementClientRelationshipById_Return = agmtClientRel;
        mockDataProvider.getAgreementFinancialDocuments_Return = new List<Agreement_Financial_Documents__c>();
        mockDataProvider.getAgreementById_Return = testAgmt;
        mockDataProvider.getAgreementFinancialDocumentsFilteredByRecordType_Return = new List<Agreement_Financial_Documents__c>();
       
        AgreementClientRelationshipEdit sut = new AgreementClientRelationshipEdit(mockStatusManager, mockDataProvider, mockValidator);

        System.assertEquals('No', sut.personalFinancialStatementId);
        System.assertEquals(null, sut.agmtClientRel.Entity__r.Pending_PFS_Frequency__c);
        System.assertEquals('No', sut.annualFinancialStatementId);
        System.assertEquals(null, sut.agmtClientRel.Entity__r.Pending_AFS_Quality__c);
        System.assertEquals(null, sut.agmtClientRel.Entity__r.Pending_AFS_FYE__c);
        System.assertEquals(null, sut.annualFinancialStatementPeriodId);
        System.assertEquals(false, sut.showAnnualStatementPeriodOther);
        System.assertEquals(null, sut.agmtClientRel.Entity__r.Pending_AFS_Period_Other__c);
        System.assertEquals(null, sut.annualFinancialStatementOtherTypeId);
        System.assertEquals(null, sut.agmtClientRel.Entity__r.Pending_AFS_Entities_To_Combine__c);
        System.assertEquals('No', sut.interimStatementId);
        System.assertEquals(null, sut.agmtClientRel.Entity__r.Pending_IntStmts_Quality__c);
        System.assertEquals(null, sut.interimStatementPeriodId);
        System.assertEquals(null, sut.agmtClientRel.Entity__r.Pending_IntStmts_Period_Other__c);
        System.assertEquals('No', sut.taxReturnsId);
        System.assertEquals(null, sut.taxReturnsPeriodId);
        System.assertEquals(null, sut.agmtClientRel.Entity__r.Pending_TaxReturns_Period_Other__c);
    }

    static testMethod void it_should_return_the_PENDING_finreq_EDIT_fields_for_a_PENDING_agreement_when_all_values_are_yes() {
        Account testEntity = new Account();
        testEntity.Pending_PFS__c = 'Yes';
        testEntity.Pending_PFS_Frequency__c = 'Annually';
        testEntity.Pending_AFS__c = 'Yes';
        testEntity.Pending_AFS_Quality__c = 'Self Prepared';
        testEntity.Pending_AFS_FYE__c = '01/02';
        testEntity.Pending_AFS_Days_Due_After_FYE__c = -1;
        testEntity.Pending_AFS_Period_Other__c = 50;
        testEntity.Pending_AFS_Other_Type__c = 'Combined';
        testEntity.Pending_AFS_Entities_To_Combine__c = 'me and you';
        testEntity.Pending_IntStmts__c = 'Monthly';
        testEntity.Pending_IntStmts_Quality__c = 'Self Prepared';
        testEntity.Pending_IntStmts_Days_Due_After_PE__c = -1;
        testEntity.Pending_IntStmts_Period_Other__c = 60;
        testEntity.Pending_TaxReturns__c = 'Yes';
        testEntity.Pending_TaxReturns_Days_Due_After_Filing__c = -1;
        testEntity.Pending_TaxReturns_Period_Other__c = 70;
        
        Agreement__c testAgmt = new Agreement__c(Id='a28f00000008zGI');
        testAgmt.RecordType = Utility.recordTypeObject('Agreement__c','Pending');

        Agreement_Client_Relationships__c agmtClientRel = new Agreement_Client_Relationships__c();
        agmtClientRel.Entity__r = testEntity;
        agmtClientRel.Agreement__c = testAgmt.Id;

        MockOfIAgreementStatusManager mockStatusManager = new MockOfIAgreementStatusManager();
        MockOfIAgreementClientRelationshipEditDataProvider mockDataProvider = new MockOfIAgreementClientRelationshipEditDataProvider();
        MockOfIAgreementValidator mockValidator = new MockOfIAgreementValidator();
        mockDataProvider.getAgreementClientRelationshipById_Return = agmtClientRel;
        mockDataProvider.getAgreementFinancialDocuments_Return = new List<Agreement_Financial_Documents__c>();
        mockDataProvider.getAgreementById_Return = testAgmt;
        mockDataProvider.getAgreementFinancialDocumentsFilteredByRecordType_Return = new List<Agreement_Financial_Documents__c>();
        AgreementClientRelationshipEdit sut = new AgreementClientRelationshipEdit(mockStatusManager, mockDataProvider, mockValidator);

        AgreementClientRelationshipEdit.FinancialReportingRequirements finRptReqs = sut.finRptReqs;

        System.assertEquals('Yes', sut.personalFinancialStatementId);               
        System.assertEquals('Annually', sut.agmtClientRel.Entity__r.Pending_PFS_Frequency__c);          
        System.assertEquals('Yes', sut.annualFinancialStatementId);             
        System.assertEquals('Self Prepared', sut.agmtClientRel.Entity__r.Pending_AFS_Quality__c);       
        System.assertEquals('01/02', sut.agmtClientRel.Entity__r.Pending_AFS_FYE__c);               
        System.assertEquals('-1', sut.annualFinancialStatementPeriodId);        
        System.assertEquals(true, sut.showAnnualStatementPeriodOther);              
        System.assertEquals(50, sut.agmtClientRel.Entity__r.Pending_AFS_Period_Other__c);             
        System.assertEquals('Combined', sut.annualFinancialStatementOtherTypeId);
        System.assertEquals('me and you', sut.agmtClientRel.Entity__r.Pending_AFS_Entities_To_Combine__c);          
        System.assertEquals('Monthly', sut.interimStatementId);             
        System.assertEquals('Self Prepared', sut.agmtClientRel.Entity__r.Pending_IntStmts_Quality__c);      
        System.assertEquals('-1', sut.interimStatementPeriodId);        
        System.assertEquals(60, sut.agmtClientRel.Entity__r.Pending_IntStmts_Period_Other__c);                
        System.assertEquals('Yes', sut.taxReturnsId);                   
        System.assertEquals('-1', sut.taxReturnsPeriodId);          
        System.assertEquals(70, sut.agmtClientRel.Entity__r.Pending_TaxReturns_Period_Other__c);
    }

    static testMethod void it_should_return_the_PENDING_finreq_READONLY_fields_for_a_PENDING_agreement_when_all_values_are_no() {
        Account testEntity = new Account();
        testEntity.Pending_PFS__c = 'No';
        testEntity.Pending_AFS__c = 'No';
        testEntity.Pending_IntStmts__c = 'No';
        testEntity.Pending_TaxReturns__c = 'No';
        
        Agreement__c testAgmt = new Agreement__c(Id='a28f00000008zGI');
        testAgmt.RecordType = Utility.recordTypeObject('Agreement__c','Pending');

        Agreement_Client_Relationships__c agmtClientRel = new Agreement_Client_Relationships__c();
        agmtClientRel.Entity__r = testEntity;
        agmtClientRel.Agreement__c = testAgmt.Id;

        MockOfIAgreementStatusManager mockStatusManager = new MockOfIAgreementStatusManager();
        MockOfIAgreementClientRelationshipEditDataProvider mockDataProvider = new MockOfIAgreementClientRelationshipEditDataProvider();
        MockOfIAgreementValidator mockValidator = new MockOfIAgreementValidator();
        mockDataProvider.getAgreementClientRelationshipById_Return = agmtClientRel;
        mockDataProvider.getAgreementFinancialDocuments_Return = new List<Agreement_Financial_Documents__c>();
        mockDataProvider.getAgreementById_Return = testAgmt;
        mockDataProvider.getAgreementFinancialDocumentsFilteredByRecordType_Return = new List<Agreement_Financial_Documents__c>();
        AgreementClientRelationshipEdit sut = new AgreementClientRelationshipEdit(mockStatusManager, mockDataProvider, mockValidator);

        AgreementClientRelationshipEdit.FinancialReportingRequirements finRptReqs = sut.finRptReqs;

        System.assertEquals('No', finRptReqs.Personal_Financial_Statement);
        System.assertEquals(null, finRptReqs.Personal_Financial_Statement_Frequency);
        System.assertEquals('No', finRptReqs.Annual_Financial_Statements);
        System.assertEquals(null, finRptReqs.Annual_Statement_Quality);
        System.assertEquals(null, finRptReqs.AFS_Fiscal_Year_End);
        System.assertEquals(null, finRptReqs.Annual_Stmt_Days_Due_After_Fiscal_Y_E);
        System.assertEquals(null, finRptReqs.Annual_Financial_Statement_Period_Other);
        System.assertEquals('', finRptReqs.Other_Type);
        System.assertEquals(null, finRptReqs.AFS_Entities_To_Combine);
        System.assertEquals('No', finRptReqs.Interim_Statements);
        System.assertEquals(null, finRptReqs.Interim_Stm_Prepared_By);
        System.assertEquals(null, finRptReqs.Interim_Stmt_Days_Due_After_Period_End);
        System.assertEquals(null, finRptReqs.Interim_Stmt_Days_Due_After_Period_End_Other);
        System.assertEquals('No', finRptReqs.Tax_Returns);
        System.assertEquals(null, finRptReqs.Tax_Return_Days_Due_After_Filing);
        System.assertEquals(null, finRptReqs.Tax_Return_Days_Due_After_Filing_Other);
    }

    static testMethod void it_should_return_the_PENDING_finreq_READONLY_fields_for_a_PENDING_agreement_when_all_values_are_yes() {
        Account testEntity = new Account();
        testEntity.Pending_PFS__c = 'Yes';
        testEntity.Pending_PFS_Frequency__c = 'Annually';
        testEntity.Pending_AFS__c = 'Yes';
        testEntity.Pending_AFS_Quality__c = 'Self Prepared';
        testEntity.Pending_AFS_FYE__c = '01/02';
        testEntity.Pending_AFS_Days_Due_After_FYE__c = -1;
        testEntity.Pending_AFS_Period_Other__c = 50;
        testEntity.Pending_AFS_Other_Type__c = 'Combined';
        testEntity.Pending_AFS_Entities_To_Combine__c = 'me and you';
        testEntity.Pending_IntStmts__c = 'Monthly';
        testEntity.Pending_IntStmts_Quality__c = 'Self Prepared';
        testEntity.Pending_IntStmts_Days_Due_After_PE__c = -1;
        testEntity.Pending_IntStmts_Period_Other__c = 60;
        testEntity.Pending_TaxReturns__c = 'Yes';
        testEntity.Pending_TaxReturns_Days_Due_After_Filing__c = -1;
        testEntity.Pending_TaxReturns_Period_Other__c = 70;
        
        Agreement__c testAgmt = new Agreement__c(Id='a28f00000008zGI');
        testAgmt.RecordType = Utility.recordTypeObject('Agreement__c','Pending');

        Agreement_Client_Relationships__c agmtClientRel = new Agreement_Client_Relationships__c();
        agmtClientRel.Entity__r = testEntity;
        agmtClientRel.Agreement__c = testAgmt.Id;

        MockOfIAgreementStatusManager mockStatusManager = new MockOfIAgreementStatusManager();
        MockOfIAgreementClientRelationshipEditDataProvider mockDataProvider = new MockOfIAgreementClientRelationshipEditDataProvider();
        MockOfIAgreementValidator mockValidator = new MockOfIAgreementValidator();
        mockDataProvider.getAgreementClientRelationshipById_Return = agmtClientRel;
        mockDataProvider.getAgreementFinancialDocuments_Return = new List<Agreement_Financial_Documents__c>();
        mockDataProvider.getAgreementById_Return = testAgmt;
        mockDataProvider.getAgreementFinancialDocumentsFilteredByRecordType_Return = new List<Agreement_Financial_Documents__c>();
        AgreementClientRelationshipEdit sut = new AgreementClientRelationshipEdit(mockStatusManager, mockDataProvider, mockValidator);

        AgreementClientRelationshipEdit.FinancialReportingRequirements finRptReqs = sut.finRptReqs;

        System.assertEquals('Yes', finRptReqs.Personal_Financial_Statement);
        System.assertEquals('Annually', finRptReqs.Personal_Financial_Statement_Frequency);
        System.assertEquals('Yes', finRptReqs.Annual_Financial_Statements);
        System.assertEquals('Self Prepared', finRptReqs.Annual_Statement_Quality);
        System.assertEquals('01/02', finRptReqs.AFS_Fiscal_Year_End);
        System.assertEquals('Other (50)', finRptReqs.Annual_Stmt_Days_Due_After_Fiscal_Y_E);
        System.assertEquals('50', finRptReqs.Annual_Financial_Statement_Period_Other);
        System.assertEquals('Combined (me and you)', finRptReqs.Other_Type);
        System.assertEquals('me and you', finRptReqs.AFS_Entities_To_Combine);
        System.assertEquals('Monthly', finRptReqs.Interim_Statements);
        System.assertEquals('Self Prepared', finRptReqs.Interim_Stm_Prepared_By);
        System.assertEquals('Other (60)', finRptReqs.Interim_Stmt_Days_Due_After_Period_End);
        System.assertEquals('60', finRptReqs.Interim_Stmt_Days_Due_After_Period_End_Other);
        System.assertEquals('Yes', finRptReqs.Tax_Returns);
        System.assertEquals('Other (70)', finRptReqs.Tax_Return_Days_Due_After_Filing);
        System.assertEquals('70', finRptReqs.Tax_Return_Days_Due_After_Filing_Other);
    }

    static testMethod void it_should_return_the_ARCHIVE_finreq_fields_for_an_ARCHIVE_agreement_when_all_values_are_no() {
        Account testEntity = new Account();
        
        Agreement__c testAgmt = new Agreement__c(Id='a28f00000008zGI');
        testAgmt.RecordType = Utility.recordTypeObject('Agreement__c','Archive');

        Agreement_Client_Relationships__c agmtClientRel = new Agreement_Client_Relationships__c();
        agmtClientRel.Entity__r = testEntity;
        agmtClientRel.Agreement__c = testAgmt.Id;
        agmtClientRel.Personal_Financial_Statement__c = 'No';
        agmtClientRel.Annual_Financial_Statements__c = 'No';
        agmtClientRel.Interim_Statements__c = 'No';
        agmtClientRel.Tax_Returns__c = 'No';

        MockOfIAgreementStatusManager mockStatusManager = new MockOfIAgreementStatusManager();
        MockOfIAgreementClientRelationshipEditDataProvider mockDataProvider = new MockOfIAgreementClientRelationshipEditDataProvider();
        MockOfIAgreementValidator mockValidator = new MockOfIAgreementValidator();
        mockDataProvider.getAgreementClientRelationshipById_Return = agmtClientRel;
        mockDataProvider.getAgreementFinancialDocuments_Return = new List<Agreement_Financial_Documents__c>();
        mockDataProvider.getAgreementById_Return = testAgmt;
        mockDataProvider.getAgreementFinancialDocumentsFilteredByRecordType_Return = new List<Agreement_Financial_Documents__c>();
        AgreementClientRelationshipEdit sut = new AgreementClientRelationshipEdit(mockStatusManager, mockDataProvider, mockValidator);

        AgreementClientRelationshipEdit.FinancialReportingRequirements finRptReqs = sut.finRptReqs;

        System.assertEquals('No', finRptReqs.Personal_Financial_Statement);
        System.assertEquals(null, finRptReqs.Personal_Financial_Statement_Frequency);
        System.assertEquals('No', finRptReqs.Annual_Financial_Statements);
        System.assertEquals(null, finRptReqs.Annual_Statement_Quality);
        System.assertEquals(null, finRptReqs.AFS_Fiscal_Year_End);
        System.assertEquals(null, finRptReqs.Annual_Stmt_Days_Due_After_Fiscal_Y_E);
        System.assertEquals(null, finRptReqs.Annual_Financial_Statement_Period_Other);
        System.assertEquals('', finRptReqs.Other_Type);
        System.assertEquals(null, finRptReqs.AFS_Entities_To_Combine);
        System.assertEquals('No', finRptReqs.Interim_Statements);
        System.assertEquals(null, finRptReqs.Interim_Stm_Prepared_By);
        System.assertEquals(null, finRptReqs.Interim_Stmt_Days_Due_After_Period_End);
        System.assertEquals(null, finRptReqs.Interim_Stmt_Days_Due_After_Period_End_Other);
        System.assertEquals('No', finRptReqs.Tax_Returns);
        System.assertEquals(null, finRptReqs.Tax_Return_Days_Due_After_Filing);
        System.assertEquals(null, finRptReqs.Tax_Return_Days_Due_After_Filing_Other);
    }

    static testMethod void it_should_return_the_ARCHIVE_finreq_fields_for_an_ARCHIVE_agreement_when_all_values_are_yes() {
        Account testEntity = new Account();

        Agreement__c testAgmt = new Agreement__c(Id='a28f00000008zGI');
        testAgmt.RecordType = Utility.recordTypeObject('Agreement__c','Archive');

        Agreement_Client_Relationships__c agmtClientRel = new Agreement_Client_Relationships__c();
        agmtClientRel.Entity__r = testEntity;
        agmtClientRel.Agreement__c = testAgmt.Id;
        agmtClientRel.Personal_Financial_Statement__c = 'Yes';
        agmtClientRel.Personal_Financial_Statement_Frequency__c = 'Annually';
        agmtClientRel.Annual_Financial_Statements__c = 'Yes';
        agmtClientRel.Annual_Statement_Quality__c = 'Self Prepared';
        agmtClientRel.Fiscal_Year_End_Date__c = '01/02';
        agmtClientRel.Annual_Stmt_Days_Due_After_Fiscal_Y_E__c = -1;
        agmtClientRel.Annual_Financial_Statement_Period_Other__c = 50;
        agmtClientRel.Other_Type__c = 'Combined';
        agmtClientRel.Entities_To_Combine__c = 'me and you';
        agmtClientRel.Interim_Statements__c = 'Monthly';
        agmtClientRel.Interim_Stm_Prepared_By__c = 'Self Prepared';
        agmtClientRel.Interim_Stmt_Days_Due_After_Period_End__c = -1;
        agmtClientRel.Interim_Statement_Period_Other__c = 60;
        agmtClientRel.Tax_Returns__c = 'Yes';
        agmtClientRel.Tax_Return_Days_Due_After_Filing__c = -1;
        agmtClientRel.Tax_Return_Period_Other__c = 70;

        MockOfIAgreementStatusManager mockStatusManager = new MockOfIAgreementStatusManager();
        MockOfIAgreementClientRelationshipEditDataProvider mockDataProvider = new MockOfIAgreementClientRelationshipEditDataProvider();
        MockOfIAgreementValidator mockValidator = new MockOfIAgreementValidator();
        mockDataProvider.getAgreementClientRelationshipById_Return = agmtClientRel;
        mockDataProvider.getAgreementFinancialDocuments_Return = new List<Agreement_Financial_Documents__c>();
        mockDataProvider.getAgreementById_Return = testAgmt;
        mockDataProvider.getAgreementFinancialDocumentsFilteredByRecordType_Return = new List<Agreement_Financial_Documents__c>();
        AgreementClientRelationshipEdit sut = new AgreementClientRelationshipEdit(mockStatusManager, mockDataProvider, mockValidator);

        AgreementClientRelationshipEdit.FinancialReportingRequirements finRptReqs = sut.finRptReqs;

        System.assertEquals('Yes', finRptReqs.Personal_Financial_Statement);
        System.assertEquals('Annually', finRptReqs.Personal_Financial_Statement_Frequency);
        System.assertEquals('Yes', finRptReqs.Annual_Financial_Statements);
        System.assertEquals('Self Prepared', finRptReqs.Annual_Statement_Quality);
        System.assertEquals('01/02', finRptReqs.AFS_Fiscal_Year_End);
        System.assertEquals('Other (50)', finRptReqs.Annual_Stmt_Days_Due_After_Fiscal_Y_E);
        System.assertEquals('50', finRptReqs.Annual_Financial_Statement_Period_Other);
        System.assertEquals('Combined (me and you)', finRptReqs.Other_Type);
        System.assertEquals('me and you', finRptReqs.AFS_Entities_To_Combine);
        System.assertEquals('Monthly', finRptReqs.Interim_Statements);
        System.assertEquals('Self Prepared', finRptReqs.Interim_Stm_Prepared_By);
        System.assertEquals('Other (60)', finRptReqs.Interim_Stmt_Days_Due_After_Period_End);
        System.assertEquals('60', finRptReqs.Interim_Stmt_Days_Due_After_Period_End_Other);
        System.assertEquals('Yes', finRptReqs.Tax_Returns);
        System.assertEquals('Other (70)', finRptReqs.Tax_Return_Days_Due_After_Filing);
        System.assertEquals('70', finRptReqs.Tax_Return_Days_Due_After_Filing_Other);
    }

    static testMethod void it_should_save_the_PENDING_finreq_EDIT_fields_to_the_entity_PENDING_fields_when_values_are_changed() {

        Account testEntity = new Account(Id='001f000000GsU5c');
        testEntity.Pending_PFS__c = 'No';
        testEntity.Pending_AFS__c = 'No';
        testEntity.Pending_IntStmts__c = 'No';
        testEntity.Pending_TaxReturns__c = 'No';
        
        Agreement__c testAgmt = new Agreement__c(Id='a28f00000008zGI');
        testAgmt.RecordType = Utility.recordTypeObject('Agreement__c','Pending');

        Agreement_Client_Relationships__c agmtClientRel = new Agreement_Client_Relationships__c();
        agmtClientRel.Entity__r = testEntity;
        agmtClientRel.Agreement__c = testAgmt.Id;

        MockOfIAgreementStatusManager mockStatusManager = new MockOfIAgreementStatusManager();
        MockOfIAgreementClientRelationshipEditDataProvider mockDataProvider = new MockOfIAgreementClientRelationshipEditDataProvider();
        MockOfIAgreementValidator mockValidator = new MockOfIAgreementValidator();
        mockDataProvider.getAgreementClientRelationshipById_Return = agmtClientRel;
        mockDataProvider.getAgreementFinancialDocuments_Return = new List<Agreement_Financial_Documents__c>();
        mockDataProvider.getAgreementById_Return = testAgmt;
        mockDataProvider.getAgreementFinancialDocumentsFilteredByRecordType_Return = new List<Agreement_Financial_Documents__c>();
        AgreementClientRelationshipEdit sut = new AgreementClientRelationshipEdit(mockStatusManager, mockDataProvider, mockValidator);

        sut.personalFinancialStatementId = 'Yes';
        sut.agmtClientRel.Entity__r.Pending_PFS_Frequency__c = 'Annually';
        sut.annualFinancialStatementId = 'Yes';
        sut.agmtClientRel.Entity__r.Pending_AFS_Quality__c = 'Self Prepared';
        sut.agmtClientRel.Entity__r.Pending_AFS_FYE__c = '01/02';
        sut.annualFinancialStatementPeriodId = '-1';
        sut.agmtClientRel.Entity__r.Pending_AFS_Period_Other__c = 50;
        sut.annualFinancialStatementOtherTypeId = 'Combined';
        sut.agmtClientRel.Entity__r.Pending_AFS_Entities_To_Combine__c = 'me and you';
        sut.interimStatementId = 'Monthly';
        sut.agmtClientRel.Entity__r.Pending_IntStmts_Quality__c = 'Self Prepared';
        sut.interimStatementPeriodId = '-1';
        sut.agmtClientRel.Entity__r.Pending_IntStmts_Period_Other__c = 60;
        sut.taxReturnsId = 'Yes';
        sut.taxReturnsPeriodId = '-1';
        sut.agmtClientRel.Entity__r.Pending_TaxReturns_Period_Other__c = 70;

        sut.SaveClicked();

        system.assertEquals(1, mockDataProvider.updateAccount_TimesCalled);
        system.assertEquals('Yes', mockDataProvider.updateAccount_account[0].Pending_PFS__c);
        system.assertEquals('Annually', mockDataProvider.updateAccount_account[0].Pending_PFS_Frequency__c);
        system.assertEquals('Yes', mockDataProvider.updateAccount_account[0].Pending_AFS__c);
        system.assertEquals('Self Prepared', mockDataProvider.updateAccount_account[0].Pending_AFS_Quality__c);
        system.assertEquals('01/02', mockDataProvider.updateAccount_account[0].Pending_AFS_FYE__c);
        system.assertEquals(-1, mockDataProvider.updateAccount_account[0].Pending_AFS_Days_Due_After_FYE__c);
        system.assertEquals(50, mockDataProvider.updateAccount_account[0].Pending_AFS_Period_Other__c);
        system.assertEquals('Combined', mockDataProvider.updateAccount_account[0].Pending_AFS_Other_Type__c);
        system.assertEquals('me and you', mockDataProvider.updateAccount_account[0].Pending_AFS_Entities_To_Combine__c);
        system.assertEquals('Monthly', mockDataProvider.updateAccount_account[0].Pending_IntStmts__c);
        system.assertEquals('Self Prepared', mockDataProvider.updateAccount_account[0].Pending_IntStmts_Quality__c);
        system.assertEquals(-1, mockDataProvider.updateAccount_account[0].Pending_IntStmts_Days_Due_After_PE__c);
        system.assertEquals(60, mockDataProvider.updateAccount_account[0].Pending_IntStmts_Period_Other__c);
        system.assertEquals('Yes', mockDataProvider.updateAccount_account[0].Pending_TaxReturns__c);
        system.assertEquals(-1, mockDataProvider.updateAccount_account[0].Pending_TaxReturns_Days_Due_After_Filing__c);
        system.assertEquals(70, mockDataProvider.updateAccount_account[0].Pending_TaxReturns_Period_Other__c);
    }

    static testMethod void it_should_call_save_and_delete_agreement_reporting_requirements_on_the_data_provider_when_save_is_clicked() {

        Account testEntity = new Account(Id='001f000000GsU5c');
        testEntity.Pending_PFS__c = 'No';
        testEntity.Pending_AFS__c = 'No';
        testEntity.Pending_AFS_Days_Due_After_FYE__c = 0;
        testEntity.Pending_IntStmts__c = 'Not Required';
        testEntity.Pending_IntStmts_Days_Due_After_PE__c = 0;
        testEntity.Pending_TaxReturns__c = 'No';
        testEntity.Pending_TaxReturns_Days_Due_After_Filing__c = 0;
        
        Agreement__c testAgmt = new Agreement__c(Id='a28f00000008zGI');
        testAgmt.RecordType = Utility.recordTypeObject('Agreement__c','Pending');

        Agreement_Client_Relationships__c agmtClientRel = new Agreement_Client_Relationships__c();
        agmtClientRel.Entity__r = testEntity;
        agmtClientRel.Agreement__c = testAgmt.Id;

        MockOfIAgreementStatusManager mockStatusManager = new MockOfIAgreementStatusManager();
        MockOfIAgreementClientRelationshipEditDataProvider mockDataProvider = new MockOfIAgreementClientRelationshipEditDataProvider();
        MockOfIAgreementValidator mockValidator = new MockOfIAgreementValidator();
        mockDataProvider.getAgreementClientRelationshipById_Return = agmtClientRel;
        mockDataProvider.getAgreementFinancialDocuments_Return = new List<Agreement_Financial_Documents__c>();
        mockDataProvider.getAgreementById_Return = testAgmt;
        mockDataProvider.getAgreementFinancialDocumentsFilteredByRecordType_Return = new List<Agreement_Financial_Documents__c>();
        AgreementClientRelationshipEdit sut = new AgreementClientRelationshipEdit(mockStatusManager, mockDataProvider, mockValidator);

        sut.SaveClicked();

        System.assertEquals(1, mockDataProvider.saveAgreementFinancialDocuments_TimesCalled);
        System.assertEquals(1, mockDataProvider.deleteAgreementFinancialDocuments_TimesCalled);
    }

    static testMethod void it_should_not_allow_editing_when_agreement_status_manager_returns_false_for_editability(){
        Agreement__c testAgmt = new Agreement__c(Id='a28f00000008zGI');
        testAgmt.RecordType = Utility.recordTypeObject('Agreement__c','Pending');
        Agreement_Client_Relationships__c testAgmtClient = new Agreement_Client_Relationships__c();
        testAgmtClient.Entity__r = new Account();
        testAgmtClient.Agreement__c = testAgmt.Id;

        MockOfIAgreementStatusManager mockStatusManager = new MockOfIAgreementStatusManager();
        MockOfIAgreementClientRelationshipEditDataProvider mockDataProvider = new MockOfIAgreementClientRelationshipEditDataProvider();
        MockOfIAgreementValidator mockValidator = new MockOfIAgreementValidator();
        mockDataProvider.getAgreementClientRelationshipById_Return = testAgmtClient;
        mockDataProvider.getAgreementFinancialDocuments_Return = new List<Agreement_Financial_Documents__c>();
        mockDataProvider.getAgreementById_Return = testAgmt;
        mockStatusManager.isAgreementEditable_return = false;
        AgreementClientRelationshipEdit sut = new AgreementClientRelationshipEdit(mockStatusManager, mockDataProvider, mockValidator);

        Boolean canEdit = sut.canEditAgreement;

        System.assertEquals(1, mockStatusManager.isAgreementEditable_TimesCalled);
        System.assertEquals(false, canEdit);
    }

    static testMethod void it_should_allow_editing_when_agreement_status_manager_returns_true_for_editability(){
        Agreement__c testAgmt = new Agreement__c(Id='a28f00000008zGI');
        testAgmt.RecordType = Utility.recordTypeObject('Agreement__c','Pending');
        Agreement_Client_Relationships__c testAgmtClient = new Agreement_Client_Relationships__c();
        testAgmtClient.Entity__r = new Account();
        testAgmtClient.Agreement__c = testAgmt.Id;

        MockOfIAgreementStatusManager mockStatusManager = new MockOfIAgreementStatusManager();
        MockOfIAgreementClientRelationshipEditDataProvider mockDataProvider = new MockOfIAgreementClientRelationshipEditDataProvider();
        MockOfIAgreementValidator mockValidator = new MockOfIAgreementValidator();
        mockDataProvider.getAgreementClientRelationshipById_Return = testAgmtClient;
        mockDataProvider.getAgreementFinancialDocuments_Return = new List<Agreement_Financial_Documents__c>();
        mockDataProvider.getAgreementById_Return = testAgmt;
        mockStatusManager.isAgreementEditable_return = true;
        AgreementClientRelationshipEdit sut = new AgreementClientRelationshipEdit(mockStatusManager, mockDataProvider, mockValidator);

        Boolean canEdit = sut.canEditAgreement;

        System.assertEquals(1, mockStatusManager.isAgreementEditable_TimesCalled);
        System.assertEquals(true, canEdit);
    }

    static testMethod void it_should_only_call_the_status_manager_for_editability_once_when_accessing_canEdit_twice(){
        Agreement__c testAgmt = new Agreement__c(Id='a28f00000008zGI');
        testAgmt.RecordType = Utility.recordTypeObject('Agreement__c','Pending');
        Agreement_Client_Relationships__c testAgmtClient = new Agreement_Client_Relationships__c();
        testAgmtClient.Entity__r = new Account();
        testAgmtClient.Agreement__c = testAgmt.Id;

        MockOfIAgreementStatusManager mockStatusManager = new MockOfIAgreementStatusManager();
        MockOfIAgreementClientRelationshipEditDataProvider mockDataProvider = new MockOfIAgreementClientRelationshipEditDataProvider();
        MockOfIAgreementValidator mockValidator = new MockOfIAgreementValidator();
        mockDataProvider.getAgreementClientRelationshipById_Return = testAgmtClient;
        mockDataProvider.getAgreementFinancialDocuments_Return = new List<Agreement_Financial_Documents__c>();
        mockDataProvider.getAgreementById_Return = testAgmt;
        mockStatusManager.isAgreementEditable_return = true;
        AgreementClientRelationshipEdit sut = new AgreementClientRelationshipEdit(mockStatusManager, mockDataProvider, mockValidator);

        Boolean firstCall = sut.canEditAgreement;
        Boolean secondCall = sut.canEditAgreement;

        System.assertEquals(1, mockStatusManager.isAgreementEditable_TimesCalled);
        System.assertEquals(true, firstCall);
        System.assertEquals(true, secondCall);
    }

    /////////////////////////////////////////////////////////////////////////////////
    // Dependency Mocks
    class MockOfIAgreementStatusManager implements Agreements.IAgreementStatusManager{

        public integer  MakeActiveAdminBackdoor_TimesCalled=0;
        public List<Id> MakeActiveAdminBackdoor_agmtId = new List<Id>();
        public integer  MakePendingAdminBackdoor_TimesCalled=0;
        public List<Id> MakePendingAdminBackdoor_agmtId = new List<Id>();
        public integer  MakeArchiveAdminBackdoor_TimesCalled=0;
        public List<Id> MakeArchiveAdminBackdoor_agmtId = new List<Id>();
        public integer  MakeNewAdminBackdoor_TimesCalled=0;
        public List<Id> MakeNewAdminBackdoor_agmtId = new List<Id>();
        public integer  MakeActive_TimesCalled=0;
        public List<Id> MakeActive_agmtId = new List<Id>();
        public integer  attachLoanAppAgreementsToAccount_TimesCalled=0;
        public List<Id> attachLoanAppAgreementsToAccount_appId = new List<Id>();
        public List<Id> attachLoanAppAgreementsToAccount_acctId = new List<Id>();
        public integer  MakeArchive_TimesCalled=0;
        public List<Id> MakeArchive_agmtId = new List<Id>();
        public integer  enterBackOfficeModification_TimesCalled=0;
        public List<Agreement__c> enterBackOfficeModification_agreement = new List<Agreement__c>();
        public integer  exitBackOfficeModification_TimesCalled=0;
        public List<Agreement__c> exitBackOfficeModification_agreement = new List<Agreement__c>();
        public integer  isAgreementEditable_TimesCalled=0;
        public List<Agreement__c> isAgreementEditable_agreement = new List<Agreement__c>();
        public List<Id> isAgreementEditable_userId = new List<Id>();
        public Boolean isAgreementEditable_return = null;
        public integer  hasLoanApps_TimesCalled=0;
        public List<Agreement__c> hasLoanApps_agreement = new List<Agreement__c>();
        public integer  getRecordType_TimesCalled=0;
        public List<Agreement__c> getRecordType_agreement = new List<Agreement__c>();

        public void MakeActiveAdminBackdoor(Id agmtId){
             MakeActiveAdminBackdoor_TimesCalled += 1;
             MakeActiveAdminBackdoor_agmtId.add(agmtId);
        }

        public void MakePendingAdminBackdoor(Id agmtId){
             MakePendingAdminBackdoor_TimesCalled += 1;
             MakePendingAdminBackdoor_agmtId.add(agmtId);
        }

        public void MakeArchiveAdminBackdoor(Id agmtId){
             MakeArchiveAdminBackdoor_TimesCalled += 1;
             MakeArchiveAdminBackdoor_agmtId.add(agmtId);
        }

        public void MakeNewAdminBackdoor(Id agmtId){
             MakeNewAdminBackdoor_TimesCalled += 1;
             MakeNewAdminBackdoor_agmtId.add(agmtId);
        }

        public void MakeActive(Id agmtId){
             MakeActive_TimesCalled += 1;
             MakeActive_agmtId.add(agmtId);
        }

        public void attachLoanAppAgreementsToAccount(Id appId, Id acctId){
             attachLoanAppAgreementsToAccount_TimesCalled += 1;
             attachLoanAppAgreementsToAccount_appId.add(appId);
             attachLoanAppAgreementsToAccount_acctId.add(acctId);
        }

        public void MakeArchive(Id agmtId){
             MakeArchive_TimesCalled += 1;
             MakeArchive_agmtId.add(agmtId);
        }

        public void enterBackOfficeModification(Agreement__c agreement){
             enterBackOfficeModification_TimesCalled += 1;
             enterBackOfficeModification_agreement.add(agreement);
        }

        public void exitBackOfficeModification(Agreement__c agreement){
             exitBackOfficeModification_TimesCalled += 1;
             exitBackOfficeModification_agreement.add(agreement);
        }

        public Boolean isAgreementEditable(Agreement__c agreement, Id userId){
             isAgreementEditable_TimesCalled += 1;
             isAgreementEditable_agreement.add(agreement);
             isAgreementEditable_userId.add(userId);
             return isAgreementEditable_return;
        }

        public Boolean hasLoanApps(Agreement__c agreement){
             hasLoanApps_TimesCalled += 1;
             hasLoanApps_agreement.add(agreement);
             return null;
        }

        public RecordType getRecordType(Agreement__c agreement){
             getRecordType_TimesCalled += 1;
             getRecordType_agreement.add(agreement);
             return null;
        }
    }

    class MockOfIAgreementClientRelationshipEditDataProvider implements Agreements.IAgreementClientRelationshipEditDataProvider{

        public integer  getAgreementClientRelationshipById_TimesCalled=0;
        public List<Id> getAgreementClientRelationshipById_agreementClientRelationshipId = new List<Id>();
        public Agreement_Client_Relationships__c getAgreementClientRelationshipById_Return = null;

        public integer  getAgreementById_TimesCalled=0;
        public List<Id> getAgreementById_agreementId = new List<Id>();
        public Agreement__c getAgreementById_Return;

        public integer  getAgreementFinancialDocumentsFilteredByRecordType_TimesCalled=0;
        public List<id> getAgreementFinancialDocumentsFilteredByRecordType_agreementclientrelationshipid = new List<id>();
        public List<set<id>> getAgreementFinancialDocumentsFilteredByRecordType_recordtypeidset = new List<set<id>>();
        public List<Agreement_Financial_Documents__c> getAgreementFinancialDocumentsFilteredByRecordType_Return;

        public integer  getAgreementFinancialDocuments_TimesCalled=0;
        public List<id> getAgreementFinancialDocuments_agreementclientrelationshipid = new List<id>();
        public List<Agreement_Financial_Documents__c> getAgreementFinancialDocuments_Return;

        public integer  updateAccount_TimesCalled=0;
        public List<Account> updateAccount_account = new List<Account>();
        public Account updateAccount_Return;

        public integer  updateAgreementClientRelationships_TimesCalled=0;
        public List<Agreement_Client_Relationships__c> updateAgreementClientRelationships_agmtClientRel = new List<Agreement_Client_Relationships__c>();
        public Agreement_Client_Relationships__c updateAgreementClientRelationships_Return;

        public integer  saveAgreementFinancialDocuments_TimesCalled=0;
        public List<List<Agreement_Financial_Documents__c>> saveAgreementFinancialDocuments_agmtFinancialDocs = new List<List<Agreement_Financial_Documents__c>>();
        public List<Agreement_Financial_Documents__c> saveAgreementFinancialDocuments_Return;

        public integer  deleteAgreementFinancialDocuments_TimesCalled=0;
        public List<List<Agreement_Financial_Documents__c>> deleteAgreementFinancialDocuments_agmtFinancialDocs = new List<List<Agreement_Financial_Documents__c>>();


        public Agreement_Client_Relationships__c getAgreementClientRelationshipById(Id agreementClientRelationshipId){
             getAgreementClientRelationshipById_TimesCalled += 1;
             getAgreementClientRelationshipById_agreementClientRelationshipId.add(agreementClientRelationshipId);
             return getAgreementClientRelationshipById_Return;
        }

        public Agreement__c getAgreementById(Id agreementId){
             getAgreementById_TimesCalled += 1;
             getAgreementById_agreementId.add(agreementId);
             return getAgreementById_Return;
        }

        public List<Agreement_Financial_Documents__c> getAgreementFinancialDocumentsFilteredByRecordType(id agreementclientrelationshipid, set<id> recordtypeidset){
             getAgreementFinancialDocumentsFilteredByRecordType_TimesCalled += 1;
             getAgreementFinancialDocumentsFilteredByRecordType_agreementclientrelationshipid.add(agreementclientrelationshipid);
             getAgreementFinancialDocumentsFilteredByRecordType_recordtypeidset.add(recordtypeidset);
             return getAgreementFinancialDocumentsFilteredByRecordType_Return;
        }

        public List<Agreement_Financial_Documents__c> getAgreementFinancialDocuments(id agreementclientrelationshipid){
             getAgreementFinancialDocuments_TimesCalled += 1;
             getAgreementFinancialDocuments_agreementclientrelationshipid.add(agreementclientrelationshipid);
             return getAgreementFinancialDocuments_Return;
        }

        public Account updateAccount(Account account){
             updateAccount_TimesCalled += 1;
             updateAccount_account.add(account);
             return updateAccount_Return;
        }

        public Agreement_Client_Relationships__c updateAgreementClientRelationships(Agreement_Client_Relationships__c agmtClientRel){
             updateAgreementClientRelationships_TimesCalled += 1;
             updateAgreementClientRelationships_agmtClientRel.add(agmtClientRel);
             return updateAgreementClientRelationships_Return;
        }

        public List<Agreement_Financial_Documents__c> saveAgreementFinancialDocuments(List<Agreement_Financial_Documents__c> agmtFinancialDocs){
             saveAgreementFinancialDocuments_TimesCalled += 1;
             saveAgreementFinancialDocuments_agmtFinancialDocs.add(agmtFinancialDocs);
             return saveAgreementFinancialDocuments_Return;
        }

        public void deleteAgreementFinancialDocuments(List<Agreement_Financial_Documents__c> agmtFinancialDocs){
             deleteAgreementFinancialDocuments_TimesCalled += 1;
             deleteAgreementFinancialDocuments_agmtFinancialDocs.add(agmtFinancialDocs);
        }
    }

    class MockOfIAgreementValidator implements Agreements.IAgreementValidator{
        public void Validate(Agreement__c agreement){}
        public void ValidateAndSave(Agreement__c agreement){}
        public void ValidateAndSaveFromTrigger(Agreement__c agreement){}
        public void DisableValidateFromTrigger(Boolean disable){}
    }
}