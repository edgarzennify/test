@IsTest
public class AgreementLoanAppRepositoryTests {

    private final static AgreementLoanAppRepository sut;
    private final static AgreementMock.ofIAgreementControllerDataProvider mockDataProvider;
    private final static AgreementMock.ofIDmLoanAppBuilder mockDmBuilder;
    private static final AgreementMock.ofILoanAppRepositoryHelper mockHelper;

    static {
        mockDataProvider = new AgreementMock.ofIAgreementControllerDataProvider();
        mockDmBuilder = new AgreementMock.ofIDmLoanAppBuilder();
        mockHelper = new AgreementMock.ofILoanAppRepositoryHelper();
        sut = new AgreementLoanAppRepository(mockDataProvider, mockDmBuilder, mockHelper);
    }

    @IsTest
    static void it_should_call_the_data_provider_to_get_agmt_loan_app_rels_when_getting_included_loan_apps(){
        Id agreementId = ObjectFactory.getFakeId(Agreement__c.SObjectType, '1');
        mockDmBuilder.setup('build', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE)
            .returns(new List<DmLoanApp>());

        List<DmLoanApp> result = sut.getIncludedLoanApps(agreementId);

        mockDataProvider.verify('getIncludedLoanAppRelationshipsByAgreementId', new List<Object>{agreementId}, Times.Once);
    }

    @IsTest
    static void it_should_call_the_dm_builder_with_the_agmt_loan_app_rels_the_data_provider_returns(){
        Id agreementId = ObjectFactory.getFakeId(Agreement__c.SObjectType, '1');
        Agreement_Loan_Application_Relationship__c agmtLoanAppRel1 = new Agreement_Loan_Application_Relationship__c();  
        agmtLoanAppRel1.Id = ObjectFactory.getFakeId(Agreement_Loan_Application_Relationship__c.SObjectType, '1'); 
        List<Agreement_Loan_Application_Relationship__c> agmtLoanAppRels = new List<Agreement_Loan_Application_Relationship__c>{agmtLoanAppRel1};
        mockDataProvider.setup('getIncludedLoanAppRelationshipsByAgreementId', new List<Object>{agreementId})
            .returns(agmtLoanAppRels);
        mockDmBuilder.setup('build', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE)
            .returns(new List<DmLoanApp>());

        List<DmLoanApp> result = sut.getIncludedLoanApps(agreementId);

        mockDmBuilder.verify('build', new List<Object>{agmtLoanAppRels}, Times.Once);
    }

    @IsTest
    static void it_should_return_excluded_dmLoanApps_when_given_included_entities_ncino_loans_and_ebAccounts() {
        Id includedEntityId = ObjectFactory.getFakeId(Account.SObjectType, '1');
        Id includedEbAccountId = ObjectFactory.getFakeId(EB_Account__c.SObjectType, '1');
        Id includedLoanAppId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        Id excludedLoanAppId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '2');
        Id filteredExcludedLoanAppId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '3');
        
        DmLoanApp DmIncludedLoanApp = new DmLoanApp();
        DmIncludedLoanApp.Id = includedLoanAppId;
        DmLoanApp DmExcludedLoanApp = new DmLoanApp();
        DmExcludedLoanApp.Id = excludedLoanAppId;

        LLC_BI__Loan__c includedLoan = new LLC_BI__Loan__c();
        includedLoan.Id =  includedLoanAppId;
        LLC_BI__Loan__c excludedLoan = new LLC_BI__Loan__c();
        excludedLoan.Id =  excludedLoanAppId;
        LLC_BI__Loan__c filteredExcludedLoan = new LLC_BI__Loan__c();
        filteredExcludedLoan.Id =  filteredExcludedLoanAppId;

        EB_Account__c includedEbAccount = new EB_Account__c();
        includedEbAccount.Id = includedEbAccountId;

        LLC_BI__Legal_Entities__c includedInvolvement = new LLC_BI__Legal_Entities__c();
        includedInvolvement.LLC_BI__Loan__c = includedLoanAppId; //filtered out because of included dmloanapp
        LLC_BI__Legal_Entities__c excludedInvolvement = new LLC_BI__Legal_Entities__c();
        excludedInvolvement.LLC_BI__Loan__c = excludedLoanAppId; //the loan attached to this involvement will be used to build the dm that is returned
        LLC_BI__Legal_Entities__c filteredExcludedInvolvement = new LLC_BI__Legal_Entities__c();
        filteredExcludedInvolvement.LLC_BI__Loan__c = filteredExcludedLoanAppId; //filtered out because of included ebAccount

        Set<Id> includedEntitiesSet = new Set<Id>{includedEntityId};
        List<DmLoanApp> includedLoanApps = new List<DmLoanApp>{DmIncludedLoanApp};
        List<EB_Account__c> includedEbAccounts = new List<EB_Account__c>{includedEbAccount};
        List<LLC_BI__Legal_Entities__c> returnedInvolvements = new List<LLC_BI__Legal_Entities__c>{includedInvolvement, excludedInvolvement, filteredExcludedInvolvement};
        Set<Id> loanIds = Utility.convertToIdSet(returnedInvolvements, 'LLC_BI__Loan__c');
        List<LLC_BI__Loan__c> unfilteredExcludedLoans = new List<LLC_BI__Loan__c>{includedLoan, excludedLoan, filteredExcludedLoan};
        List<LLC_BI__Loan__c> filteredExcludedLoans = new List<LLC_BI__Loan__c>{excludedLoan};
        Set<Id> includedAppIds = new Set<Id>{includedLoanAppId};

        mockDataProvider.setup('getEntityLoanAppRelationshipsByEntityIds', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE)
            .returns(new List<EB_Loan_App_Entity_Relationship__c>()); //loanforce setup
        mockDataProvider.setup('getLlcBiEntityInvolvementsByEntityIds', new List<Object>{includedEntitiesSet})
            .returns(returnedInvolvements);
        mockHelper.setup('getExcludedLoanApps', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE)
            .returns(new List<EB_Loan_Application__c>()); //loanforce setup
        mockHelper.setup('filterExcludedLoanApps', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE)
            .returns(new List<EB_Loan_Application__c>()); //loanforce setup
        mockHelper.setup('getExcludedLlcBiLoans', new List<Object>{returnedInvolvements, includedAppIds})
            .returns(unfilteredExcludedLoans);
        mockHelper.setup('filterExcludedLlcBiLoans', new List<Object>{unfilteredExcludedLoans, includedEbAccounts})
            .returns(filteredExcludedLoans);
        mockDmBuilder.setup('build', new List<Object>{new List<EB_Loan_Application__c>()})
            .returns(new List<DmLoanApp>()); //loanforce setup
        mockDmBuilder.setup('build', new List<Object>{filteredExcludedLoans})
            .returns(new List<DmLoanApp>{DmExcludedLoanApp});
        //act
        List<DmLoanApp> results = sut.getExcludedLoanApps(includedEntitiesSet, includedLoanApps, includedEbAccounts);
        //assert
        System.assertEquals(1, results.size());
        System.assertEquals(DmExcludedLoanApp.Id, results[0].Id);
    }

    @IsTest
    static void it_should_return_excluded_dmLoanApps_when_given_included_entities_loanforce_loans_and_ebAccounts() {
        Id includedEntityId = ObjectFactory.getFakeId(Account.SObjectType, '1');
        Id includedEbAccountId = ObjectFactory.getFakeId(EB_Account__c.SObjectType, '1');
        Id includedLoanAppId = ObjectFactory.getFakeId(EB_Loan_Application__c.SObjectType, '1');
        Id excludedLoanAppId = ObjectFactory.getFakeId(EB_Loan_Application__c.SObjectType, '2');
        Id filteredExcludedLoanAppId = ObjectFactory.getFakeId(EB_Loan_Application__c.SObjectType, '3');
        
        DmLoanApp DmIncludedLoanApp = new DmLoanApp();
        DmIncludedLoanApp.Id = includedLoanAppId;
        DmLoanApp DmExcludedLoanApp = new DmLoanApp();
        DmExcludedLoanApp.Id = excludedLoanAppId;

        EB_Loan_Application__c includedLoan = new EB_Loan_Application__c();
        includedLoan.Id =  includedLoanAppId;
        EB_Loan_Application__c excludedLoan = new EB_Loan_Application__c();
        excludedLoan.Id =  excludedLoanAppId;
        EB_Loan_Application__c filteredExcludedLoan = new EB_Loan_Application__c();
        filteredExcludedLoan.Id =  filteredExcludedLoanAppId;

        EB_Account__c includedEbAccount = new EB_Account__c();
        includedEbAccount.Id = includedEbAccountId;

        EB_Loan_App_Entity_Relationship__c includedInvolvement = new EB_Loan_App_Entity_Relationship__c();
        includedInvolvement.Loan_Application_ID__c = includedLoanAppId; //filtered out because of included dmloanapp
        EB_Loan_App_Entity_Relationship__c excludedInvolvement = new EB_Loan_App_Entity_Relationship__c();
        excludedInvolvement.Loan_Application_ID__c = excludedLoanAppId; //the loan attached to this involvement will be used to build the dm that is returned
        EB_Loan_App_Entity_Relationship__c filteredExcludedInvolvement = new EB_Loan_App_Entity_Relationship__c();
        filteredExcludedInvolvement.Loan_Application_ID__c = filteredExcludedLoanAppId; //filtered out because of included ebAccount

        Set<Id> includedEntitiesSet = new Set<Id>{includedEntityId};
        List<DmLoanApp> includedLoanApps = new List<DmLoanApp>{DmIncludedLoanApp};
        List<EB_Account__c> includedEbAccounts = new List<EB_Account__c>{includedEbAccount};
        List<EB_Loan_App_Entity_Relationship__c> returnedAppRels = new List<EB_Loan_App_Entity_Relationship__c>{includedInvolvement, excludedInvolvement, filteredExcludedInvolvement};
        List<EB_Loan_Application__c> unfilteredExcludedLoans = new List<EB_Loan_Application__c>{includedLoan, excludedLoan, filteredExcludedLoan};
        List<EB_Loan_Application__c> filteredExcludedLoans = new List<EB_Loan_Application__c>{excludedLoan};
        Set<Id> includedAppIds = new Set<Id>{includedLoanAppId};

        mockDataProvider.setup('getEntityLoanAppRelationshipsByEntityIds', new List<Object>{includedEntitiesSet})
            .returns(returnedAppRels);
        mockDataProvider.setup('getLlcBiEntityInvolvementsByEntityIds', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE)
            .returns(new List<LLC_BI__Legal_Entities__c>()); //ncino setup
        mockHelper.setup('getExcludedLoanApps', new List<Object>{returnedAppRels, includedAppIds})
            .returns(unfilteredExcludedLoans);
        mockHelper.setup('filterExcludedLoanApps', new List<Object>{unfilteredExcludedLoans, includedEbAccounts})
            .returns(filteredExcludedLoans);
        mockHelper.setup('getExcludedLlcBiLoans', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE)
            .returns(new List<LLC_BI__Loan__c>()); //ncino setup
        mockHelper.setup('filterExcludedLlcBiLoans', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE)
            .returns(new List<LLC_BI__Loan__c>()); //ncino setup
        mockDmBuilder.setup('build', new List<Object>{unfilteredExcludedLoans})
            .returns(new List<DmLoanApp>{DmExcludedLoanApp});
        mockDmBuilder.setup('build', new List<Object>{new List<LLC_BI__Loan__c>()})
            .returns(new List<DmLoanApp>()); //ncino setup
        //act
        List<DmLoanApp> results = sut.getExcludedLoanApps(includedEntitiesSet, includedLoanApps, includedEbAccounts);
        //assert
        System.assertEquals(1, results.size());
        System.assertEquals(DmExcludedLoanApp.Id, results[0].Id);
    }

    @IsTest
    static void it_should_call_the_data_provider_with_a_set_of_ids_containing_the_given_dm_ids_when_getting_the_loan_app_relationships(){
        DmLoanApp app1 = new DmLoanApp();
        app1.id = ObjectFactory.getFakeId(EB_Loan_Application__c.SObjectType, '1');
        List<DmLoanApp> allLoanApps = new List<DmLoanApp>{app1};
        Set<Id> includedEntitiesSet;

        sut.getExcludedLoanApplicationRelationships(allLoanApps, includedEntitiesSet);

        mockDataProvider.verify('getEntityLoanAppRelationshipsByAppIds', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
        List<Object> args = mockDataProvider.getArgumentsFromCall('getEntityLoanAppRelationshipsByAppIds');
        Set<Id> argAppIds = (Set<Id>)args[0];
        System.assertEquals(1, argAppIds.size());
        System.assert(argAppIds.contains(app1.id));
    }

    @IsTest
    static void it_should_call_the_data_provider_to_get_entity_involvements_with_a_set_of_ids_containing_the_given_dm_ids_when_getting_the_loan_app_relationships(){
        DmLoanApp app1 = new DmLoanApp();
        app1.id = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        List<DmLoanApp> allLoanApps = new List<DmLoanApp>{app1};
        Set<Id> includedEntitiesSet;

        sut.getExcludedLoanApplicationRelationships(allLoanApps, includedEntitiesSet);

        mockDataProvider.verify('getLlcBiEntityInvolvementsByAppIds', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
        List<Object> args = mockDataProvider.getArgumentsFromCall('getLlcBiEntityInvolvementsByAppIds');
        Set<Id> argAppIds = (Set<Id>)args[0];
        System.assertEquals(1, argAppIds.size());
        System.assert(argAppIds.contains(app1.id));
    }

    @IsTest
    static void it_should_determine_the_excluded_entities_and_build_relationship_objects_for_excluded_eb_relationships_when_getting_the_loan_app_relationships(){
        DmLoanApp app1 = new DmLoanApp();
        app1.id = ObjectFactory.getFakeId(EB_Loan_Application__c.SObjectType, '1');
        List<DmLoanApp> allLoanApps = new List<DmLoanApp>{app1};
        Account entity1 = new Account();
        entity1.Id = ObjectFactory.getFakeId(Account.SObjectType, '1');
        Account entity2 = new Account();
        entity2.Id = ObjectFactory.getFakeId(Account.SObjectType, '2');
        Set<Id> includedEntitiesSet = new Set<Id>{entity1.Id};
        EB_Loan_App_Entity_Relationship__c appRel1 = new EB_Loan_App_Entity_Relationship__c();
        appRel1.Entity_Name__r = entity1;
        appRel1.Loan_Application_ID__c = app1.id;
        EB_Loan_App_Entity_Relationship__c appRel2 = new EB_Loan_App_Entity_Relationship__c();
        appRel2.Entity_Name__r = entity2;
        appRel2.Loan_Application_ID__c = app1.id;
        mockDataProvider.setup('getEntityLoanAppRelationshipsByAppIds', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE)
            .returns(new List<EB_Loan_App_Entity_Relationship__c>{appRel1, appRel2});

        sut.getExcludedLoanApplicationRelationships(allLoanApps, includedEntitiesSet);

        mockDmBuilder.verify('build', new List<Object>{app1,entity2}, Times.Once);       
    }

    @IsTest
    static void it_should_determine_the_excluded_entities_and_build_relationship_objects_for_excluded_entity_involvements_when_getting_the_loan_app_relationships(){
        DmLoanApp app1 = new DmLoanApp();
        app1.id = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        List<DmLoanApp> allLoanApps = new List<DmLoanApp>{app1};
        Account entity1 = new Account();
        entity1.Id = ObjectFactory.getFakeId(Account.SObjectType, '1');
        Account entity2 = new Account();
        entity2.Id = ObjectFactory.getFakeId(Account.SObjectType, '2');
        Set<Id> includedEntitiesSet = new Set<Id>{entity1.Id};
        LLC_BI__Legal_Entities__c involvement1 = new LLC_BI__Legal_Entities__c();
        involvement1.LLC_BI__Account__r = entity1;
        involvement1.LLC_BI__Loan__c = app1.id;
        LLC_BI__Legal_Entities__c involvement2 = new LLC_BI__Legal_Entities__c();
        involvement2.LLC_BI__Account__r = entity2;
        involvement2.LLC_BI__Loan__c = app1.id;
        mockDataProvider.setup('getLlcBiEntityInvolvementsByAppIds', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE)
            .returns(new List<LLC_BI__Legal_Entities__c>{involvement1, involvement2});

        sut.getExcludedLoanApplicationRelationships(allLoanApps, includedEntitiesSet);

        mockDmBuilder.verify('build', new List<Object>{app1,entity2}, Times.Once);       
    }

    @IsTest
    static void it_should_return_the_dms_when_getting_loan_app_entity_relationships(){
        DmLoanApp app1 = new DmLoanApp();
        app1.id = ObjectFactory.getFakeId(EB_Loan_Application__c.SObjectType, '1');
        DmLoanApp app2 = new DmLoanApp();
        app2.id = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        List<DmLoanApp> allLoanApps = new List<DmLoanApp>{app1, app2};

        Account entity1 = new Account();
        entity1.Id = ObjectFactory.getFakeId(Account.SObjectType, '1');
        Account entity2 = new Account();
        entity2.Id = ObjectFactory.getFakeId(Account.SObjectType, '2');
        Set<Id> includedEntitiesSet = new Set<Id>{entity1.Id};

        EB_Loan_App_Entity_Relationship__c appRel1 = new EB_Loan_App_Entity_Relationship__c();
        appRel1.Entity_Name__r = entity1;
        appRel1.Loan_Application_ID__c = app1.id;
        EB_Loan_App_Entity_Relationship__c appRel2 = new EB_Loan_App_Entity_Relationship__c();
        appRel2.Entity_Name__r = entity2;
        appRel2.Loan_Application_ID__c = app1.id;
        mockDataProvider.setup('getEntityLoanAppRelationshipsByAppIds', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE)
            .returns(new List<EB_Loan_App_Entity_Relationship__c>{appRel1, appRel2});

        LLC_BI__Legal_Entities__c involvement1 = new LLC_BI__Legal_Entities__c();
        involvement1.LLC_BI__Account__r = entity1;
        involvement1.LLC_BI__Loan__c = app2.id;
        LLC_BI__Legal_Entities__c involvement2 = new LLC_BI__Legal_Entities__c();
        involvement2.LLC_BI__Account__r = entity2;
        involvement2.LLC_BI__Loan__c = app2.id;
        mockDataProvider.setup('getLlcBiEntityInvolvementsByAppIds', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE)
            .returns(new List<LLC_BI__Legal_Entities__c>{involvement1, involvement2});
        
        List<Agreements.LoanAppEntityRelationship> result = sut.getExcludedLoanApplicationRelationships(allLoanApps, includedEntitiesSet);

        System.assertEquals(2,result.size());
    }

    @IsTest
    static void it_should_call_the_data_provider_when_excluding_an_eb_loan_app(){
      Id agreementId = ObjectFactory.getFakeId(Agreement__c.SObjectType, '1');
      Id loanAppId = ObjectFactory.getFakeId(EB_Loan_Application__c.SObjectType, '1');

      Agreement_Loan_Application_Relationship__c relToRemove = new Agreement_Loan_Application_Relationship__c();
      mockDataProvider.setup('findAgreementLoanApplicationRelationship', new List<Object>{agreementId, loanAppId})
        .returns(relToRemove);

      sut.excludeLoanApp(agreementId, loanAppId);

      mockDataProvider.verify('findAgreementLoanApplicationRelationship', new List<Object>{agreementId, loanAppId}, Times.Once);
      mockDataProvider.verify('remove', new List<Object>{relToRemove}, Times.Once);
    }

    @IsTest
    static void it_should_call_the_data_provider_when_excluding_a_llc_bi_loan_app(){
      Id agreementId = ObjectFactory.getFakeId(Agreement__c.SObjectType, '1');
      Id loanAppId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');

      Agreement_LLC_BI_Loan_Relationship__c relToRemove = new Agreement_LLC_BI_Loan_Relationship__c();
      mockDataProvider.setup('findAgreementLlcBiLoanRelationship', new List<Object>{agreementId, loanAppId})
        .returns(relToRemove);

      sut.excludeLoanApp(agreementId, loanAppId);

      mockDataProvider.verify('findAgreementLlcBiLoanRelationship', new List<Object>{agreementId, loanAppId}, Times.Once);
      mockDataProvider.verify('remove', new List<Object>{relToRemove}, Times.Once);
    }

    @IsTest
    static void it_should_call_the_data_provider_when_including_an_eb_loan_app(){
      Id agreementId = ObjectFactory.getFakeId(Agreement__c.SObjectType, '1');
      Id loanAppId = ObjectFactory.getFakeId(EB_Loan_Application__c.SObjectType, '1');

      sut.includeLoanApp(agreementId, loanAppId);

      Agreement_Loan_Application_Relationship__c objectToInsert = new Agreement_Loan_Application_Relationship__c(Agreement__c = agreementId, Loan_Application__c = loanAppId);
      mockDataProvider.verify('save', new List<Object>{objectToInsert}, Times.Once);
    }

    @IsTest
    static void it_should_call_the_data_provider_when_including_a_llc_bi_loan_app(){
      Id agreementId = ObjectFactory.getFakeId(Agreement__c.SObjectType, '1');
      Id loanAppId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');

      sut.includeLoanApp(agreementId, loanAppId);

      Agreement_LLC_BI_Loan_Relationship__c objectToInsert = new Agreement_LLC_BI_Loan_Relationship__c(Agreement__c = agreementId, LLCBI_Loan__c = loanAppId);
      mockDataProvider.verify('save', new List<Object>{objectToInsert}, Times.Once);
    }
}