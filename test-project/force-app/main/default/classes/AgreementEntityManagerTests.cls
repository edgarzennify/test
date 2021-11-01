@isTest
public class AgreementEntityManagerTests{

    private static testMethod void it_should_copy_the_pending_financial_requirements_to_the_active_ones(){
        Account testEntity = new Account();
        testEntity.Pending_PFS__c = 'A';
        testEntity.Pending_PFS_Frequency__c = 'B';
        testEntity.Pending_AFS__c = 'C';
        testEntity.Pending_AFS_Quality__c = 'D';
        testEntity.Pending_AFS_Days_Due_After_FYE__c = 1;
        testEntity.Pending_AFS_Period_Other__c = 2;
        testEntity.Pending_AFS_FYE__c = 'E';
        testEntity.Pending_AFS_Entities_To_Combine__c = 'F';
        testEntity.Pending_AFS_Other_Type__c = 'G';
        testEntity.Pending_IntStmts__c = 'H';
        testEntity.Pending_IntStmts_Quality__c = 'I';
        testEntity.Pending_IntStmts_Days_Due_After_PE__c = 3;
        testEntity.Pending_IntStmts_Period_Other__c = 4;
        testEntity.Pending_TaxReturns__c = 'J';
        testEntity.Pending_TaxReturns_Days_Due_After_Filing__c = 5;
        testEntity.Pending_TaxReturns_Period_Other__c = 6;

        Agreement__c testAgreement = new Agreement__c(Id='a28f00000008zGI');

        MockOfIAgreementEntityManagerDataProvider mockDataProvider = new MockOfIAgreementEntityManagerDataProvider();
        AgreementEntityManager sut = new AgreementEntityManager(mockDataProvider);
        mockDataProvider.getRelatedEntitiesByAgreementId_return = new List<Account> {testEntity};

        sut.copyPendingFinancialReportingRequirementsToActive(testAgreement.Id);

        System.assertEquals(testEntity.Pending_PFS__c, testEntity.Personal_Financial_Statement__c);
        System.assertEquals(testEntity.Pending_PFS_Frequency__c, testEntity.Personal_Financial_Statement_Frequency__c);

        System.assertEquals(testEntity.Pending_AFS__c, testEntity.Annual_Financial_Statements__c);
        System.assertEquals(testEntity.Pending_AFS_Quality__c, testEntity.Annual_Statement_Quality__c);
        System.assertEquals(testEntity.Pending_AFS_Days_Due_After_FYE__c, testEntity.Annual_Stmt_Days_Due_After_Fiscal_Y_E__c);
        System.assertEquals(testEntity.Pending_AFS_Period_Other__c, testEntity.Annual_Financial_Statement_Period_Other__c);
        System.assertEquals(testEntity.Pending_AFS_FYE__c, testEntity.Fiscal_Year_End_Date__c);
        System.assertEquals(testEntity.Pending_AFS_Entities_To_Combine__c, testEntity.Entities_To_Combine__c);
        System.assertEquals(testEntity.Pending_AFS_Other_Type__c, testEntity.Other_Type__c);

        System.assertEquals(testEntity.Pending_IntStmts__c, testEntity.Interim_Statements__c);
        System.assertEquals(testEntity.Pending_IntStmts_Quality__c, testEntity.Interim_Stm_Prepared_By__c);
        System.assertEquals(testEntity.Pending_IntStmts_Days_Due_After_PE__c, testEntity.Interim_Stmt_Days_Due_After_Period_End__c);
        System.assertEquals(testEntity.Pending_IntStmts_Period_Other__c, testEntity.Interim_Statement_Period_Other__c);

        System.assertEquals(testEntity.Pending_TaxReturns__c, testEntity.Tax_Returns__c);
        System.assertEquals(testEntity.Pending_TaxReturns_Days_Due_After_Filing__c, testEntity.Tax_Return_Days_Due_After_Filing__c);
        System.assertEquals(testEntity.Pending_TaxReturns_Period_Other__c, testEntity.Tax_Return_Period_Other__c);
    }

    private static testMethod void it_should_copy_the_active_financial_requirements_to_the_archive_ones(){
        Account testEntity = new Account();
        testEntity.Personal_Financial_Statement__c = 'A';
        testEntity.Personal_Financial_Statement_Frequency__c = 'B';
        testEntity.Annual_Financial_Statements__c = 'C';
        testEntity.Annual_Statement_Quality__c = 'D';
        testEntity.Annual_Stmt_Days_Due_After_Fiscal_Y_E__c = 1;
        testEntity.Annual_Financial_Statement_Period_Other__c = 2;
        testEntity.Fiscal_Year_End_Date__c = 'E';
        testEntity.Entities_To_Combine__c = 'F';
        testEntity.Other_Type__c = 'G';
        testEntity.Interim_Statements__c = 'H';
        testEntity.Interim_Stm_Prepared_By__c = 'I';
        testEntity.Interim_Stmt_Days_Due_After_Period_End__c = 3;
        testEntity.Interim_Statement_Period_Other__c = 4;
        testEntity.Tax_Returns__c = 'J';
        testEntity.Tax_Return_Days_Due_After_Filing__c = 5;
        testEntity.Tax_Return_Period_Other__c = 6;

        Agreement__c testAgreement = new Agreement__c(Id='a28f00000008zGI');

        Agreement_Client_Relationships__c testAgmtEntity = new Agreement_Client_Relationships__c();
        testAgmtEntity.Entity__r = testEntity;
        testAgmtEntity.Agreement__r = testAgreement;

        MockOfIAgreementEntityManagerDataProvider mockDataProvider = new MockOfIAgreementEntityManagerDataProvider();
        AgreementEntityManager sut = new AgreementEntityManager(mockDataProvider);
        mockDataProvider.getAgreementClientRelationshipsByAgreementId_return = new List<Agreement_Client_Relationships__c> {testAgmtEntity};

        sut.copyActiveFinancialReportingRequirementsToArchive(testAgreement.Id);

        System.assertEquals(testAgmtEntity.Entity__r.Personal_Financial_Statement__c, testAgmtEntity.Personal_Financial_Statement__c);
        System.assertEquals(testAgmtEntity.Entity__r.Personal_Financial_Statement_Frequency__c, testAgmtEntity.Personal_Financial_Statement_Frequency__c);

        System.assertEquals(testAgmtEntity.Entity__r.Annual_Financial_Statements__c, testAgmtEntity.Annual_Financial_Statements__c);
        System.assertEquals(testAgmtEntity.Entity__r.Annual_Statement_Quality__c, testAgmtEntity.Annual_Statement_Quality__c);
        System.assertEquals(testAgmtEntity.Entity__r.Annual_Stmt_Days_Due_After_Fiscal_Y_E__c, testAgmtEntity.Annual_Stmt_Days_Due_After_Fiscal_Y_E__c);
        System.assertEquals(testAgmtEntity.Entity__r.Annual_Financial_Statement_Period_Other__c, testAgmtEntity.Annual_Financial_Statement_Period_Other__c);
        System.assertEquals(testAgmtEntity.Entity__r.Fiscal_Year_End_Date__c, testAgmtEntity.Fiscal_Year_End_Date__c);
        System.assertEquals(testAgmtEntity.Entity__r.Entities_To_Combine__c, testAgmtEntity.Entities_To_Combine__c);
        System.assertEquals(testAgmtEntity.Entity__r.Other_Type__c, testAgmtEntity.Other_Type__c);

        System.assertEquals(testAgmtEntity.Entity__r.Interim_Statements__c, testAgmtEntity.Interim_Statements__c);
        System.assertEquals(testAgmtEntity.Entity__r.Interim_Stm_Prepared_By__c, testAgmtEntity.Interim_Stm_Prepared_By__c);
        System.assertEquals(testAgmtEntity.Entity__r.Interim_Stmt_Days_Due_After_Period_End__c, testAgmtEntity.Interim_Stmt_Days_Due_After_Period_End__c);
        System.assertEquals(testAgmtEntity.Entity__r.Interim_Statement_Period_Other__c, testAgmtEntity.Interim_Statement_Period_Other__c);

        System.assertEquals(testAgmtEntity.Entity__r.Tax_Returns__c, testAgmtEntity.Tax_Returns__c);
        System.assertEquals(testAgmtEntity.Entity__r.Tax_Return_Days_Due_After_Filing__c, testAgmtEntity.Tax_Return_Days_Due_After_Filing__c);
        System.assertEquals(testAgmtEntity.Entity__r.Tax_Return_Period_Other__c, testAgmtEntity.Tax_Return_Period_Other__c);
    }

    private static testMethod void it_should_save_the_related_entities_after_copying_financial_requirements_from_pending_to_active(){
        Agreement__c testAgreement = new Agreement__c(Id='a28f00000008zGI');

        MockOfIAgreementEntityManagerDataProvider mockDataProvider = new MockOfIAgreementEntityManagerDataProvider();
        AgreementEntityManager sut = new AgreementEntityManager(mockDataProvider);
        mockDataProvider.getRelatedEntitiesByAgreementId_return = new List<Account>();

        sut.copyPendingFinancialReportingRequirementsToActive(testAgreement.Id);

        System.assertEquals(1,mockDataProvider.updateEntities_timesCalled);
        System.assertEquals(mockDataProvider.getRelatedEntitiesByAgreementId_return, mockDataProvider.updateEntities_entities[0]);
    }

    private static testMethod void it_should_retrieve_the_related_entities_from_data_provider_by_given_AgreementID(){
        Agreement__c testAgreement = new Agreement__c(Id='a28f00000008zGI');
        MockOfIAgreementEntityManagerDataProvider mockDataProvider = new MockOfIAgreementEntityManagerDataProvider();
        AgreementEntityManager sut = new AgreementEntityManager(mockDataProvider);
        mockDataProvider.getRelatedEntitiesByAgreementId_return = new List<Account>();

        sut.copyPendingFinancialReportingRequirementsToActive(testAgreement.Id);

        System.assertEquals(1,mockDataProvider.getRelatedEntitiesByAgreementId_timesCalled);
        System.assertEquals(testAgreement.Id,mockDataProvider.getRelatedEntitiesByAgreementId_agreementId[0]);
    }

    private static testMethod void it_should_save_the_agreement_entity_relationships_after_copying_financial_requirements_from_active_to_archive(){
        Agreement__c testAgreement = new Agreement__c(Id='a28f00000008zGI');

        MockOfIAgreementEntityManagerDataProvider mockDataProvider = new MockOfIAgreementEntityManagerDataProvider();
        AgreementEntityManager sut = new AgreementEntityManager(mockDataProvider);
        mockDataProvider.getAgreementClientRelationshipsByAgreementId_return = new List<Agreement_Client_Relationships__c>();

        sut.copyActiveFinancialReportingRequirementsToArchive(testAgreement.Id);

        System.assertEquals(1,mockDataProvider.updateAgreementClientRelationships_timesCalled);
        System.assertEquals(mockDataProvider.getAgreementClientRelationshipsByAgreementId_return, mockDataProvider.updateAgreementClientRelationships_agreementClients[0]);
    }

    private static testMethod void it_should_retrieve_the_agreement_client_relationships_from_data_provider_by_given_AgreementID(){
        Agreement__c testAgreement = new Agreement__c(Id='a28f00000008zGI');

        MockOfIAgreementEntityManagerDataProvider mockDataProvider = new MockOfIAgreementEntityManagerDataProvider();
        AgreementEntityManager sut = new AgreementEntityManager(mockDataProvider);
        mockDataProvider.getAgreementClientRelationshipsByAgreementId_return = new List<Agreement_Client_Relationships__c>();

        sut.copyActiveFinancialReportingRequirementsToArchive(testAgreement.Id);

        System.assertEquals(1,mockDataProvider.getAgreementClientRelationshipsByAgreementId_timesCalled);
        System.assertEquals(testAgreement.Id, mockDataProvider.getAgreementClientRelationshipsByAgreementId_agreementId[0]);
    }

    ///////////////////////////////////////////////////////////////////////////////////////////
    // Dependency Mocks
    private class MockOfIAgreementEntityManagerDataProvider Implements Agreements.IAgreementEntityManagerDataProvider{

        public Integer getRelatedEntitiesByAgreementId_TimesCalled = 0;
        public List<Account> getRelatedEntitiesByAgreementId_return;
        public List<Id> getRelatedEntitiesByAgreementId_agreementId = new List<Id>();

        public Integer getAgreementClientRelationshipsByAgreementId_TimesCalled = 0;
        public List<Agreement_Client_Relationships__c> getAgreementClientRelationshipsByAgreementId_return;
        public List<Id> getAgreementClientRelationshipsByAgreementId_agreementId = new List<Id>();

        public Integer updateEntities_TimesCalled = 0;
        public List<List<Account>> updateEntities_entities = new List<List<Account>>();

        public Integer updateAgreementClientRelationships_TimesCalled = 0;
        public List<List<Agreement_Client_Relationships__c>> updateAgreementClientRelationships_agreementClients = new List<List<Agreement_Client_Relationships__c>>();

        public List<Account> getRelatedEntitiesByAgreementId(Id agreementId){
            getRelatedEntitiesByAgreementId_TimesCalled += 1;
            getRelatedEntitiesByAgreementId_agreementId.add(agreementId);
            return getRelatedEntitiesByAgreementId_return;
        }

        public List<Agreement_Client_Relationships__c> getAgreementClientRelationshipsByAgreementId(Id agreementId){
            getAgreementClientRelationshipsByAgreementId_TimesCalled += 1;
            getAgreementClientRelationshipsByAgreementId_agreementId.add(agreementId);
            return getAgreementClientRelationshipsByAgreementId_return;
        }

        public void updateEntities(List<Account> entities){
            updateEntities_TimesCalled += 1;
            updateEntities_entities.add(entities);
        }

        public void updateAgreementClientRelationships(List<Agreement_Client_Relationships__c> agreementClients){
            updateAgreementClientRelationships_TimesCalled += 1;
            updateAgreementClientRelationships_agreementClients.add(agreementClients);
        }

    }

}