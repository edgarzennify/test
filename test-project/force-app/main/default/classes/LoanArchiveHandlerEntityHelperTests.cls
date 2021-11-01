@IsTest
private class LoanArchiveHandlerEntityHelperTests {

    private final static Id m_prospectEntityId;
    private final static Id m_coreEntityId;
    private final static LoanArchiveHandlerEntityHelper sut;

    static{
        m_prospectEntityId = ObjectFactory.getFakeId(Account.SObjectType, '1');
        m_coreEntityId = ObjectFactory.getFakeId(Account.SObjectType, '2');
        sut = new LoanArchiveHandlerEntityHelper();
    }

    private static testMethod void it_should_reparent_entity_involvements_when_a_core_involvement_exists_without_a_prospect_counterpart() {
        Id lnid1 = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        Id lnid2 = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '2');

        LLC_BI__Legal_Entities__c prospect1 = new LLC_BI__Legal_Entities__c();
        prospect1.LLC_BI__Loan__c = lnid1;
        prospect1.LLC_BI__Account__c = m_prospectEntityId;
        List<LLC_BI__Legal_Entities__c> prospects = new List<LLC_BI__Legal_Entities__c>{prospect1};

        LLC_BI__Legal_Entities__c core1 = new LLC_BI__Legal_Entities__c();
        core1.LLC_BI__Loan__c = lnid1;
        core1.LLC_BI__Account__c = m_coreEntityId;
        LLC_BI__Legal_Entities__c core2 = new LLC_BI__Legal_Entities__c();
        core2.LLC_BI__Loan__c = lnid2;
        core2.LLC_BI__Account__c = m_coreEntityId;
        List<LLC_BI__Legal_Entities__c> cores = new List<LLC_BI__Legal_Entities__c>{core1, core2};

        List<LLC_BI__Legal_Entities__c> result = sut.reparentEntityInvolvements(prospects, cores);

        System.assertEquals(1, result.size());
        System.assertEquals(core2 ,result[0]);
    }
    
    private static testMethod void it_should_not_reparent_entity_involvements_when_the_core_involvements_have_a_prospect_counterparts() {
        Id lnid1 = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        Id lnid2 = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '2');

        LLC_BI__Legal_Entities__c prospect1 = new LLC_BI__Legal_Entities__c();
        prospect1.LLC_BI__Loan__c = lnid1;
        prospect1.LLC_BI__Account__c = m_prospectEntityId;
        LLC_BI__Legal_Entities__c prospect2 = new LLC_BI__Legal_Entities__c();
        prospect2.LLC_BI__Loan__c = lnid2;
        prospect2.LLC_BI__Account__c = m_prospectEntityId;
        List<LLC_BI__Legal_Entities__c> prospects = new List<LLC_BI__Legal_Entities__c>{prospect1, prospect2};

        LLC_BI__Legal_Entities__c core1 = new LLC_BI__Legal_Entities__c();
        core1.LLC_BI__Loan__c = lnid1;
        core1.LLC_BI__Account__c = m_coreEntityId;
        LLC_BI__Legal_Entities__c core2 = new LLC_BI__Legal_Entities__c();
        core2.LLC_BI__Loan__c = lnid2;
        core2.LLC_BI__Account__c = m_coreEntityId;
        List<LLC_BI__Legal_Entities__c> cores = new List<LLC_BI__Legal_Entities__c>{core1, core2};

        List<LLC_BI__Legal_Entities__c> result = sut.reparentEntityInvolvements(prospects, cores);

        System.assertEquals(0, result.size());
    }

       
    private static testMethod void it_should_get_back_an_empty_save_list_when_the_prospect_is_empty() {
        Id lnid1 = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        Id lnid2 = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '2');
        List<LLC_BI__Legal_Entities__c> prospects = new List<LLC_BI__Legal_Entities__c>();

        LLC_BI__Legal_Entities__c core1 = new LLC_BI__Legal_Entities__c();
        core1.LLC_BI__Loan__c = lnid1;
        core1.LLC_BI__Account__c = m_coreEntityId;
        LLC_BI__Legal_Entities__c core2 = new LLC_BI__Legal_Entities__c();
        core2.LLC_BI__Loan__c = lnid2;
        core2.LLC_BI__Account__c = m_coreEntityId;
        List<LLC_BI__Legal_Entities__c> cores = new List<LLC_BI__Legal_Entities__c>{core1, core2};

        List<LLC_BI__Legal_Entities__c> result = sut.reparentEntityInvolvements(prospects, cores);

        System.assertEquals(0, result.size());
    }
    
    private static testMethod void it_should_get_an_empty_save_list_when_the_core_is_empty() {
        Id lnid1 = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        Id lnid2 = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '2');

        LLC_BI__Legal_Entities__c prospect1 = new LLC_BI__Legal_Entities__c();
        prospect1.LLC_BI__Loan__c = lnid1;
        prospect1.LLC_BI__Account__c = m_prospectEntityId;
        List<LLC_BI__Legal_Entities__c> prospects = new List<LLC_BI__Legal_Entities__c>{prospect1};
        List<LLC_BI__Legal_Entities__c> cores = new List<LLC_BI__Legal_Entities__c>();

        List<LLC_BI__Legal_Entities__c> result = sut.reparentEntityInvolvements(prospects, cores);

        System.assertEquals(0, result.size());
    }

    private static testMethod void it_should_reparent_entity_documents_when_the_core_has_documents() {
        LLC_BI__AccountDocument__c doc1 = new LLC_BI__AccountDocument__c();
        doc1.LLC_BI__Account__c = m_coreEntityId;
        LLC_BI__AccountDocument__c doc2 = new LLC_BI__AccountDocument__c();
        doc2.LLC_BI__Account__c = m_coreEntityId;
        List<LLC_BI__AccountDocument__c> coreDocs = new List<LLC_BI__AccountDocument__c>{doc1, doc2};

        List<LLC_BI__AccountDocument__c> result = sut.reparentEntityDocuments(m_prospectEntityId, coreDocs);

        System.assertEquals(2, result.size());
        System.assertEquals(m_prospectEntityId, result[0].LLC_BI__Account__c);
        System.assertEquals(m_prospectEntityId, result[1].LLC_BI__Account__c);
    }

    private static testMethod void it_should_not_reparent_entity_documents_when_the_core_has_no_documents() {
        List<LLC_BI__AccountDocument__c> coreDocs = new List<LLC_BI__AccountDocument__c>();

        List<LLC_BI__AccountDocument__c> result = sut.reparentEntityDocuments(m_prospectEntityId, coreDocs);

        System.assertEquals(0, result.size());
    }

    private static testMethod void it_should_not_reparent_entity_documents_when_the_prospect_does_not_exists() {
         LLC_BI__AccountDocument__c doc1 = new LLC_BI__AccountDocument__c();
        doc1.LLC_BI__Account__c = m_coreEntityId;
        LLC_BI__AccountDocument__c doc2 = new LLC_BI__AccountDocument__c();
        doc2.LLC_BI__Account__c = m_coreEntityId;
        List<LLC_BI__AccountDocument__c> coreDocs = new List<LLC_BI__AccountDocument__c>{doc1, doc2};

        List<LLC_BI__AccountDocument__c> result = sut.reparentEntityDocuments(null, coreDocs);

        System.assertEquals(0, result.size());
    }

    private static testMethod void it_should_reparent_collateral_ownerships_when_a_core_ownership_exists_without_a_prospect_counterpart() {
        Id id1 = ObjectFactory.getFakeId(LLC_BI__Collateral__c.SObjectType, '1');
        Id id2 = ObjectFactory.getFakeId(LLC_BI__Collateral__c.SObjectType, '2');

        LLC_BI__Account_Collateral__c prospect1 = new LLC_BI__Account_Collateral__c();
        prospect1.LLC_BI__Collateral__c  = id1;
        prospect1.LLC_BI__Account__c = m_prospectEntityId;
        List<LLC_BI__Account_Collateral__c> prospectOwnerships = new List<LLC_BI__Account_Collateral__c>{prospect1};

        LLC_BI__Account_Collateral__c core1 = new LLC_BI__Account_Collateral__c();
        core1.LLC_BI__Collateral__c = id1;
        core1.LLC_BI__Account__c = m_coreEntityId;
        LLC_BI__Account_Collateral__c core2 = new LLC_BI__Account_Collateral__c();
        core2.LLC_BI__Collateral__c = id2;
        core2.LLC_BI__Account__c = m_coreEntityId;
        List<LLC_BI__Account_Collateral__c> coreOwnerships = new List<LLC_BI__Account_Collateral__c>{core1, core2};

        List<LLC_BI__Account_Collateral__c> result =  sut.reparentCollateralOwnerships(prospectOwnerships,  coreOwnerships);

        System.assertEquals(1, result.size());
        System.assertEquals(core2 ,result[0]);
    }

    private static testMethod void it_should_not_reparent_collateral_ownerships_when_the_core_ownerships_have_a_prospect_counterpart() {
        Id id1 = ObjectFactory.getFakeId(LLC_BI__Collateral__c.SObjectType, '1');
        Id id2 = ObjectFactory.getFakeId(LLC_BI__Collateral__c.SObjectType, '2');

        LLC_BI__Account_Collateral__c prospect1 = new LLC_BI__Account_Collateral__c();
        prospect1.LLC_BI__Collateral__c  = id1;
        prospect1.LLC_BI__Account__c = m_prospectEntityId;
        LLC_BI__Account_Collateral__c prospect2 = new LLC_BI__Account_Collateral__c();
        prospect2.LLC_BI__Collateral__c  = id2;
        prospect2.LLC_BI__Account__c = m_prospectEntityId;
        List<LLC_BI__Account_Collateral__c> prospectOwnerships = new List<LLC_BI__Account_Collateral__c>{prospect1, prospect2};

        LLC_BI__Account_Collateral__c core1 = new LLC_BI__Account_Collateral__c();
        core1.LLC_BI__Collateral__c = id1;
        core1.LLC_BI__Account__c = m_coreEntityId;
        LLC_BI__Account_Collateral__c core2 = new LLC_BI__Account_Collateral__c();
        core2.LLC_BI__Collateral__c = id2;
        core2.LLC_BI__Account__c = m_coreEntityId;
        List<LLC_BI__Account_Collateral__c> coreOwnerships = new List<LLC_BI__Account_Collateral__c>{core1, core2};

        List<LLC_BI__Account_Collateral__c> result =  sut.reparentCollateralOwnerships(prospectOwnerships,  coreOwnerships);

        System.assertEquals(0, result.size());
    }

    private static testMethod void it_should_reparent_loans_when_prospect_and_core_loans_are_provided() {
        Id loan1 = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        Id loan2 = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '2');
        Id loan3 = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '3');
        Id loan4 = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '4');
        LLC_BI__Loan__c coreLoan1 = new LLC_BI__Loan__c(Id = loan3, LLC_BI__Account__c = m_coreEntityId);
        LLC_BI__Loan__c coreLoan2 = new LLC_BI__Loan__c(Id = loan4, LLC_BI__Account__c = m_coreEntityId);
        List<LLC_BI__Loan__c> coreLoans = new List<LLC_BI__Loan__c>{coreLoan1, coreLoan2};

        List<LLC_BI__Loan__c> result = sut.reparentLoans(m_prospectEntityId, coreLoans);

        System.assertEquals(2, result.size());
        System.assertEquals(m_prospectEntityId, result[0].LLC_BI__Account__c);
        System.assertEquals(m_prospectEntityId, result[1].LLC_BI__Account__c);
    }

    private static testMethod void it_should_reparent_eb_account_relationships_when_prospect_and_core_relationships_are_provided() {
        Eb_Account_Relationship__c coreRel1 = new Eb_Account_Relationship__c();
        coreRel1.Client_Id__c = m_coreEntityId;
        coreRel1.EB_Account_Id__c = ObjectFactory.getFakeId(EB_Account__c.SObjectType, '3');
        Eb_Account_Relationship__c coreRel2 = new Eb_Account_Relationship__c();
        coreRel1.Client_Id__c = m_coreEntityId;
        coreRel1.EB_Account_Id__c = ObjectFactory.getFakeId(EB_Account__c.SObjectType, '4');
        List<Eb_Account_Relationship__c> coreRels = new List<Eb_Account_Relationship__c>{coreRel1, coreRel2};

        List<Eb_Account_Relationship__c> result = sut.reparentEbAccountRelationships(m_prospectEntityId, coreRels);

        System.assertEquals(2, result.size());
        System.assertEquals(m_prospectEntityId, result[0].Client_Id__c);
        System.assertEquals(m_prospectEntityId, result[1].Client_Id__c);
    }

    private static testMethod void it_should_reparent_collateral_relationships_when_prospect_and_core_relationships_are_provided() {
        EB_Collateral_Client_Relationship__c coreRel1 = new EB_Collateral_Client_Relationship__c();
        coreRel1.Client_ID__c = m_coreEntityId;
        coreRel1.EB_Collateral_ID__c = ObjectFactory.getFakeId(EB_Collateral_Client_Relationship__c.SObjectType, '3');
        EB_Collateral_Client_Relationship__c coreRel2 = new EB_Collateral_Client_Relationship__c();
        coreRel2.Client_ID__c = m_coreEntityId;
        coreRel2.EB_Collateral_ID__c = ObjectFactory.getFakeId(EB_Collateral_Client_Relationship__c.SObjectType, '4');
        List<EB_Collateral_Client_Relationship__c> cores = new List<EB_Collateral_Client_Relationship__c>{coreRel1, coreRel2};

        List<EB_Collateral_Client_Relationship__c> result = sut.reparentEbCollateralRelationships(m_prospectEntityId, cores);

        System.assertEquals(2, result.size());
        System.assertEquals(m_prospectEntityId, result[0].Client_ID__c);
        System.assertEquals(m_prospectEntityId, result[1].Client_ID__c);
    }

    private static testMethod void it_should_reparent_eb_account_ownerships_when_prospect_and_client_ownerships_are_provided() {
        Eb_Account__c coreEbAccount1 = new EB_Account__c();
        coreEbAccount1.Primary_Owner_Id__c = m_coreEntityId;
        EB_Account__c coreEbAccount2 = new EB_Account__c();
        coreEbAccount1.Primary_Owner_Id__c = m_coreEntityId;
        List<Eb_Account__c> coreEbaccounts = new List<Eb_Account__c>{coreEbAccount1, coreEbAccount2};

        List<Eb_Account__c> result = sut.reparentEbAccountOwnerships(m_prospectEntityId, coreEbAccounts);

        System.assertEquals(2, result.size());
        System.assertEquals(m_prospectEntityId, result[0].Primary_Owner_Id__c);
        System.assertEquals(m_prospectEntityId, result[1].Primary_Owner_Id__c);
    }
    
    private static testMethod void it_should_reparent_the_eb_collaterals_when_prospective_and_core_collaterals_are_provided() {
        Id prospectEntityId1 = ObjectFactory.getFakeId(Account.SObjectType, '1');
        Id coreEntityId = ObjectFactory.getFakeId(Account.SObjectType, '2');
        Eb_Collateral__c core1 = new Eb_Collateral__c();
        List<Eb_Collateral__c> cores = new List<Eb_Collateral__c>{core1};

        List<Eb_Collateral__c> result = sut.reparentEbCollateralOwnerships(prospectEntityId1, cores);

        System.assertEquals(1, result.size());
        System.assertEquals(core1, result[0]);
        System.assertEquals(prospectEntityId1, result[0].Collateral_Owner__c);
    }

    private static testMethod void it_should_build_a_delete_list_for_involvements_that_have_loanid_in_prospect() {
        Id lnid1 = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        Id lnid2 = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '2');


        LLC_BI__Legal_Entities__c prospect1 = new LLC_BI__Legal_Entities__c();
        prospect1.LLC_BI__Loan__c = lnid1;
        prospect1.LLC_BI__Account__c = m_prospectEntityId;
        List<LLC_BI__Legal_Entities__c> prospects = new List<LLC_BI__Legal_Entities__c>{prospect1};

        LLC_BI__Legal_Entities__c core1 = new LLC_BI__Legal_Entities__c();
        core1.LLC_BI__Loan__c = lnid1;
        core1.LLC_BI__Account__c = m_coreEntityId;
        LLC_BI__Legal_Entities__c core2 = new LLC_BI__Legal_Entities__c();
        core2.LLC_BI__Loan__c = lnid2;
        core2.LLC_BI__Account__c = m_coreEntityId;
        List<LLC_BI__Legal_Entities__c> cores = new List<LLC_BI__Legal_Entities__c>{core1, core2};

        List<LLC_BI__Legal_Entities__c> result = sut.createDeletesForEntityInvolvements(prospects, cores);

        System.assertEquals(1, result.size());
        System.assertEquals(core1, result[0]);
    }

    private static testMethod void it_should_build_a_delete_list_for_ownerships_that_have_loanid_in_prospect() {
        Id prospectEntityId1 = ObjectFactory.getFakeId(Account.SObjectType, '1');
        Id coreEntityId = ObjectFactory.getFakeId(Account.SObjectType, '2');

        Id collateralId1 = ObjectFactory.getFakeId(LLC_BI__Collateral__c.SObjectType, '1');
        Id collateralId2 = ObjectFactory.getFakeId(LLC_BI__Collateral__c.SObjectType, '2');

        LLC_BI__Account_Collateral__c prospect1 = new LLC_BI__Account_Collateral__c();
        prospect1.LLC_BI__Collateral__c = collateralId1;
        List<LLC_BI__Account_Collateral__c> prospects = new List<LLC_BI__Account_Collateral__c>{prospect1};


        LLC_BI__Account_Collateral__c core1 = new LLC_BI__Account_Collateral__c();
        core1.LLC_BI__Collateral__c = collateralId1;
        LLC_BI__Account_Collateral__c core2 = new LLC_BI__Account_Collateral__c();
        core2.LLC_BI__Collateral__c = collateralId2;
        List<LLC_BI__Account_Collateral__c> cores = new List<LLC_BI__Account_Collateral__c>{core1, core2};

        List<LLC_BI__Account_Collateral__c> result = sut.createDeletesForCollateralOwnerships(prospects, cores);

        System.assertEquals(1, result.size());
        System.assertEquals(core1, result[0]);
    }


}