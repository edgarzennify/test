@isTest
private class AgreementEntityManagerDataProviderTests {

    private static testMethod void it_should_retrieve_Related_Entities_by_Agreement_Id() {
        Account testEntity = ObjectFactory.getValidEntity('Test Entity');
        testEntity.Annual_Statement_Quality__c = 'Prepared By CPA';
        testEntity.Pending_PFS_Frequency__c = 'Annually';
        update testEntity;
        Account testEntityNotOnAgmt = ObjectFactory.getValidEntity('Test Entity 2');
        Agreement__c testAgmt = ObjectFactory.getAgreement('Active', 'Test Entity', 'comments');
        Agreement_Client_Relationships__c agmtClientRel = ObjectFactory.getAgreementClientRelationships('Borrower', testAgmt, testEntity);

        AgreementEntityManagerDataProvider sut = new AgreementEntityManagerDataProvider();

        List<Account> returnResult = sut.getRelatedEntitiesByAgreementId(testAgmt.Id);

        System.assertEquals(1, returnResult.size());
        System.assertEquals('Prepared By CPA', returnResult[0].Annual_Statement_Quality__c);
        System.assertEquals('Annually', returnResult[0].Pending_PFS_Frequency__c);
    }

    private static testMethod void it_should_return_an_empty_list_if_no_Related_Entities_found() {
        Agreement__c testAgmt = ObjectFactory.getAgreement('Active', 'Test Entity', 'comments');
        AgreementEntityManagerDataProvider sut = new AgreementEntityManagerDataProvider();

        List<Account> returnResult = sut.getRelatedEntitiesByAgreementId(testAgmt.Id);

        System.assertEquals(0, returnResult.size());
    }


    private static testMethod void it_should_retrieve_expected_fields_in_SOQL_for_Related_Entities_by_Agreement_Id() {
        Account testEntity = ObjectFactory.getValidEntity('Test Entity');
        Agreement__c testAgmt = ObjectFactory.getAgreement('Active', 'Test Entity', 'comments');
        Agreement_Client_Relationships__c agmtClientRel = ObjectFactory.getAgreementClientRelationships('Borrower', testAgmt, testEntity);
        
        AgreementEntityManagerDataProvider sut = new AgreementEntityManagerDataProvider();

        List<Account> returnResult = sut.getRelatedEntitiesByAgreementId(testAgmt.Id);

        System.assertEquals(1, returnResult.size());
        Object wasFieldInSOQL;
        wasFieldInSOQL = returnResult[0].Personal_Financial_Statement__c;
        wasFieldInSOQL = returnResult[0].Pending_PFS__c;
        wasFieldInSOQL = returnResult[0].Personal_Financial_Statement_Frequency__c;
        wasFieldInSOQL = returnResult[0].Pending_PFS_Frequency__c;
        wasFieldInSOQL = returnResult[0].Annual_Financial_Statements__c;
        wasFieldInSOQL = returnResult[0].Pending_AFS__c;
        wasFieldInSOQL = returnResult[0].Annual_Statement_Quality__c;
        wasFieldInSOQL = returnResult[0].Pending_AFS_Quality__c;
        wasFieldInSOQL = returnResult[0].Annual_Stmt_Days_Due_After_Fiscal_Y_E__c;
        wasFieldInSOQL = returnResult[0].Pending_AFS_Days_Due_After_FYE__c;
        wasFieldInSOQL = returnResult[0].Annual_Financial_Statement_Period_Other__c;
        wasFieldInSOQL = returnResult[0].Pending_AFS_Period_Other__c;
        wasFieldInSOQL = returnResult[0].Fiscal_Year_End_Date__c;
        wasFieldInSOQL = returnResult[0].Pending_AFS_FYE__c;
        wasFieldInSOQL = returnResult[0].Entities_To_Combine__c;
        wasFieldInSOQL = returnResult[0].Pending_AFS_Entities_To_Combine__c;
        wasFieldInSOQL = returnResult[0].Other_Type__c;
        wasFieldInSOQL = returnResult[0].Pending_AFS_Other_Type__c;
        wasFieldInSOQL = returnResult[0].Interim_Statements__c;
        wasFieldInSOQL = returnResult[0].Pending_IntStmts__c;
        wasFieldInSOQL = returnResult[0].Interim_Stm_Prepared_By__c;
        wasFieldInSOQL = returnResult[0].Pending_IntStmts_Quality__c;
        wasFieldInSOQL = returnResult[0].Interim_Stmt_Days_Due_After_Period_End__c;
        wasFieldInSOQL = returnResult[0].Pending_IntStmts_Days_Due_After_PE__c;
        wasFieldInSOQL = returnResult[0].Interim_Statement_Period_Other__c;
        wasFieldInSOQL = returnResult[0].Pending_IntStmts_Period_Other__c;
        wasFieldInSOQL = returnResult[0].Tax_Returns__c;
        wasFieldInSOQL = returnResult[0].Pending_TaxReturns__c;
        wasFieldInSOQL = returnResult[0].Tax_Return_Days_Due_After_Filing__c;
        wasFieldInSOQL = returnResult[0].Pending_TaxReturns_Days_Due_After_Filing__c;
        wasFieldInSOQL = returnResult[0].Tax_Return_Period_Other__c;
        wasFieldInSOQL = returnResult[0].Pending_TaxReturns_Period_Other__c;
    }

    private static testMethod void it_should_retrieve_Agreement_Client_Relationships_by_Agreement_Id() {
        Account testEntity = ObjectFactory.getValidEntity('Test Entity');
        testEntity.Annual_Statement_Quality__c = 'Prepared By CPA';
        update testEntity;
        Account testEntityNotOnAgmt = ObjectFactory.getValidEntity('Test Entity 2');
        Agreement__c testAgmt = ObjectFactory.getAgreement('Active', 'Test Entity', 'comments');
        Agreement_Client_Relationships__c agmtClientRel = ObjectFactory.getAgreementClientRelationships('Borrower', testAgmt, testEntity);
        agmtClientRel.Personal_Financial_Statement__c = 'Yes';
        update agmtClientRel;
        
        AgreementEntityManagerDataProvider sut = new AgreementEntityManagerDataProvider();

        List<Agreement_Client_Relationships__c> returnResult = sut.getAgreementClientRelationshipsByAgreementId(testAgmt.Id);

        System.assertEquals(1, returnResult.size());
        System.assertEquals('Yes', returnResult[0].Personal_Financial_Statement__c);
        System.assertEquals('Prepared By CPA', returnResult[0].Entity__r.Annual_Statement_Quality__c);

    }

    private static testMethod void it_should_return_an_empty_list_if_no_Agmt_Client_Rel_found() {
        Agreement__c testAgmt = ObjectFactory.getAgreement('Active', 'Test Entity', 'comments');
        AgreementEntityManagerDataProvider sut = new AgreementEntityManagerDataProvider();

        List<Agreement_Client_Relationships__c> returnResult = sut.getAgreementClientRelationshipsByAgreementId(testAgmt.Id);

        System.assertEquals(0, returnResult.size());
    }

    private static testMethod void it_should_retrieve_expected_fields_in_SOQL_for_Agreement_Client_Rel_by_Agreement_Id() {
        Account testEntity = ObjectFactory.getValidEntity('Test Entity');
        Agreement__c testAgmt = ObjectFactory.getAgreement('Active', 'Test Entity', 'comments');
        Agreement_Client_Relationships__c agmtClientRel = ObjectFactory.getAgreementClientRelationships('Borrower', testAgmt, testEntity);

        AgreementEntityManagerDataProvider sut = new AgreementEntityManagerDataProvider();

        List<Agreement_Client_Relationships__c> returnResult = sut.getAgreementClientRelationshipsByAgreementId(testAgmt.Id);

        System.assertEquals(1, returnResult.size());
        Object wasFieldInSOQL;
        wasFieldInSOQL = returnResult[0].Annual_Financial_Statement_Period_Other__c;
        wasFieldInSOQL = returnResult[0].Annual_Financial_Statements__c;
        wasFieldInSOQL = returnResult[0].Annual_Statement_Quality__c;
        wasFieldInSOQL = returnResult[0].Annual_Stmt_Days_Due_After_Fiscal_Y_E__c;
        wasFieldInSOQL = returnResult[0].Entities_To_Combine__c;
        wasFieldInSOQL = returnResult[0].Entity__r.Annual_Financial_Statement_Period_Other__c;
        wasFieldInSOQL = returnResult[0].Entity__r.Annual_Financial_Statements__c;
        wasFieldInSOQL = returnResult[0].Entity__r.Annual_Statement_Quality__c;
        wasFieldInSOQL = returnResult[0].Entity__r.Annual_Stmt_Days_Due_After_Fiscal_Y_E__c;
        wasFieldInSOQL = returnResult[0].Entity__r.Entities_To_Combine__c;
        wasFieldInSOQL = returnResult[0].Entity__r.Fiscal_Year_End_Date__c;
        wasFieldInSOQL = returnResult[0].Entity__r.Interim_Statement_Period_Other__c;
        wasFieldInSOQL = returnResult[0].Entity__r.Interim_Statements__c;
        wasFieldInSOQL = returnResult[0].Entity__r.Interim_Stm_Prepared_By__c;
        wasFieldInSOQL = returnResult[0].Entity__r.Interim_Stmt_Days_Due_After_Period_End__c;
        wasFieldInSOQL = returnResult[0].Entity__r.Other_Type__c;
        wasFieldInSOQL = returnResult[0].Entity__r.Personal_Financial_Statement__c;
        wasFieldInSOQL = returnResult[0].Entity__r.Personal_Financial_Statement_Frequency__c;
        wasFieldInSOQL = returnResult[0].Entity__r.Tax_Return_Days_Due_After_Filing__c;
        wasFieldInSOQL = returnResult[0].Entity__r.Tax_Return_Period_Other__c;
        wasFieldInSOQL = returnResult[0].Entity__r.Tax_Returns__c;
        wasFieldInSOQL = returnResult[0].Fiscal_Year_End_Date__c;
        wasFieldInSOQL = returnResult[0].Interim_Statement_Period_Other__c;
        wasFieldInSOQL = returnResult[0].Interim_Statements__c;
        wasFieldInSOQL = returnResult[0].Interim_Stm_Prepared_By__c;
        wasFieldInSOQL = returnResult[0].Interim_Stmt_Days_Due_After_Period_End__c;
        wasFieldInSOQL = returnResult[0].Other_Type__c;
        wasFieldInSOQL = returnResult[0].Personal_Financial_Statement__c;
        wasFieldInSOQL = returnResult[0].Personal_Financial_Statement_Frequency__c;
        wasFieldInSOQL = returnResult[0].Tax_Return_Days_Due_After_Filing__c;
        wasFieldInSOQL = returnResult[0].Tax_Return_Period_Other__c;
        wasFieldInSOQL = returnResult[0].Tax_Returns__c;
    }

    private static testMethod void it_should_update_the_Entities() {
        Account testEntity1 = ObjectFactory.getValidEntity('Old Name1');
        Account testEntity2 = ObjectFactory.getValidEntity('Old Name2');
        Account testEntityName1PreChange = [SELECT Name FROM Account WHERE Id =: testEntity1.Id Limit 1];
        Account testEntityName2PreChange = [SELECT Name FROM Account WHERE Id =: testEntity2.Id Limit 1];

        AgreementEntityManagerDataProvider sut = new AgreementEntityManagerDataProvider();

        testEntity1.Name = 'New Name1';
        testEntity2.Name = 'New Name2';
        List<Account> testEntities = new List<Account>{testEntity1, testEntity2};
        sut.updateEntities(testEntities);
        
        Account testEntityName1PostChange = [SELECT Name FROM Account WHERE Id =: testEntity1.Id Limit 1];
        Account testEntityName2PostChange = [SELECT Name FROM Account WHERE Id =: testEntity2.Id Limit 1];

        System.assertNotEquals(testEntityName1PreChange.Name, testEntityName1PostChange.Name);
        System.assertNotEquals(testEntityName2PreChange.Name, testEntityName2PostChange.Name);
        System.assertEquals('New Name1', testEntityName1PostChange.Name);
        System.assertEquals('New Name2', testEntityName2PostChange.Name);
    }

    private static testMethod void it_should_update_the_Agreement_Client_Relationships() {
        Account testEntity = ObjectFactory.getValidEntity('Test Entity');
        Account testEntity2 = ObjectFactory.getValidEntity('Test Entity2');
        Agreement__c testAgmt = ObjectFactory.getAgreement('Active', 'Test Entity', 'comments');
        Agreement_Client_Relationships__c agmtClientRel = ObjectFactory.getAgreementClientRelationships('Borrower', testAgmt, testEntity);
        Agreement_Client_Relationships__c agmtClientRel2 = ObjectFactory.getAgreementClientRelationships('Borrower', testAgmt, testEntity2);
        Agreement_Client_Relationships__c testACRRelPreChange = [SELECT Relationship__c FROM Agreement_Client_Relationships__c WHERE Id =: agmtClientRel.Id Limit 1];
        Agreement_Client_Relationships__c testACR2RelPreChange = [SELECT Relationship__c FROM Agreement_Client_Relationships__c WHERE Id =: agmtClientRel2.Id Limit 1];

        AgreementEntityManagerDataProvider sut = new AgreementEntityManagerDataProvider();

        agmtClientRel.Relationship__c = 'Co-Borrower';
        agmtClientRel2.Relationship__c = 'Co-Borrower';
        List<Agreement_Client_Relationships__c> testACRs = new List<Agreement_Client_Relationships__c>{agmtClientRel, agmtClientRel2};
        sut.updateAgreementClientRelationships(testACRs);
        
        Agreement_Client_Relationships__c testACRRelPostChange = [SELECT Relationship__c FROM Agreement_Client_Relationships__c WHERE Id =: agmtClientRel.Id Limit 1];
        Agreement_Client_Relationships__c testACR2RelPostChange = [SELECT Relationship__c FROM Agreement_Client_Relationships__c WHERE Id =: agmtClientRel2.Id Limit 1];

        System.assertNotEquals(testACRRelPreChange.Relationship__c, testACRRelPostChange.Relationship__c);
        System.assertNotEquals(testACR2RelPreChange.Relationship__c, testACR2RelPostChange.Relationship__c);
        System.assertEquals('Co-Borrower', testACRRelPostChange.Relationship__c);
        System.assertEquals('Co-Borrower', testACR2RelPostChange.Relationship__c);
    }



}