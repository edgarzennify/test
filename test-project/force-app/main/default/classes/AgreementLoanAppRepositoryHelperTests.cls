@IsTest
private class AgreementLoanAppRepositoryHelperTests {
    
    private static final AgreementLoanAppRepositoryHelper sut;

    static {
        sut = new AgreementLoanAppRepositoryHelper();
    }

    @IsTest
    static void it_should_not_return_a_list_of_loans_when_given_appRels_whos_loans_are_in_the_included_loanAppIds() {
        Id invId1 = ObjectFactory.getFakeId(EB_Loan_App_Entity_Relationship__c.SObjectType, '1');
        Id invId2 = ObjectFactory.getFakeId(EB_Loan_App_Entity_Relationship__c.SObjectType, '2');
        Id loanId1 = ObjectFactory.getFakeId(EB_Loan_Application__c.SObjectType, '1');
        Id loanId2 = ObjectFactory.getFakeId(EB_Loan_Application__c.SObjectType, '2');
        
        EB_Loan_Application__c loan1 = new EB_Loan_Application__c();
        loan1.Id = loanId1;
        EB_Loan_Application__c loan2 = new EB_Loan_Application__c();
        loan2.Id = loanId2;
        
        EB_Loan_App_Entity_Relationship__c rel1 = new EB_Loan_App_Entity_Relationship__c(
            Id = invId1,
            Loan_Application_ID__c = loanId1,
            Loan_Application_ID__r = loan1
        );
        EB_Loan_App_Entity_Relationship__c rel2 = new EB_Loan_App_Entity_Relationship__c(
            Id = invId2,
            Loan_Application_ID__c = loanId2,
            Loan_Application_ID__r = loan2
        );

        List<EB_Loan_App_Entity_Relationship__c> entityAppRels = new List<EB_Loan_App_Entity_Relationship__c>{rel1, rel2};
        Set<Id> includedLoanAppIds = new Set<Id>{loanId1, loanId2};
        //act
        List<EB_Loan_Application__c> results = sut.getExcludedLoanApps(entityAppRels, includedLoanAppIds);
        //assert
        System.assertEquals(0,  results.size());
    }

    @IsTest
    static void it_should_return_a_list_of_loans_when_given_appRels_whos_loans_are_not_in_the_included_loanAppIds() {
        Id invId1 = ObjectFactory.getFakeId(EB_Loan_App_Entity_Relationship__c.SObjectType, '1');
        Id invId2 = ObjectFactory.getFakeId(EB_Loan_App_Entity_Relationship__c.SObjectType, '2');
        Id loanId1 = ObjectFactory.getFakeId(EB_Loan_Application__c.SObjectType, '1');
        Id loanId2 = ObjectFactory.getFakeId(EB_Loan_Application__c.SObjectType, '2');
        
        EB_Loan_Application__c loan1 = new EB_Loan_Application__c();
        loan1.Id = loanId1;
        EB_Loan_Application__c loan2 = new EB_Loan_Application__c();
        loan2.Id = loanId2;
        
        EB_Loan_App_Entity_Relationship__c rel1 = new EB_Loan_App_Entity_Relationship__c(
            Id = invId1,
            Loan_Application_ID__c = loanId1,
            Loan_Application_ID__r = loan1
        );
        EB_Loan_App_Entity_Relationship__c rel2 = new EB_Loan_App_Entity_Relationship__c(
            Id = invId2,
            Loan_Application_ID__c = loanId2,
            Loan_Application_ID__r = loan2
        );

        List<EB_Loan_App_Entity_Relationship__c> entityAppRels = new List<EB_Loan_App_Entity_Relationship__c>{rel1, rel2};
        Set<Id> includedLoanAppIds = new Set<Id>();
        //act
        List<EB_Loan_Application__c> results = sut.getExcludedLoanApps(entityAppRels, includedLoanAppIds);
        //assert
        System.assertEquals(2,  results.size());
        System.assertEquals(true,  results.contains(rel1.Loan_Application_ID__r));
        System.assertEquals(true,  results.contains(rel2.Loan_Application_ID__r));
    }

    @IsTest
    static void it_should_not_error_when_an_appRels_loan_value_is_null() {
        Id invId1 = ObjectFactory.getFakeId(EB_Loan_App_Entity_Relationship__c.SObjectType, '1');
        Id invId2 = ObjectFactory.getFakeId(EB_Loan_App_Entity_Relationship__c.SObjectType, '2');
        Id loanId1 = ObjectFactory.getFakeId(EB_Loan_Application__c.SObjectType, '1');
        
        EB_Loan_Application__c loan1 = new EB_Loan_Application__c();
        loan1.Id = loanId1;
        
        EB_Loan_App_Entity_Relationship__c rel1 = new EB_Loan_App_Entity_Relationship__c(
            Id = invId1,
            Loan_Application_ID__c = loanId1,
            Loan_Application_ID__r = loan1
        );
        EB_Loan_App_Entity_Relationship__c rel2 = new EB_Loan_App_Entity_Relationship__c(
            Id = invId2
        );

        List<EB_Loan_App_Entity_Relationship__c> entityAppRels = new List<EB_Loan_App_Entity_Relationship__c>{rel1, rel2};
        Set<Id> includedLoanAppIds = new Set<Id>();
        //act
        List<EB_Loan_Application__c> results = sut.getExcludedLoanApps(entityAppRels, includedLoanAppIds);
        //assert
        System.assertEquals(1,  results.size());
        System.assertEquals(true,  results.contains(rel1.Loan_Application_ID__r));
    }
    
    @IsTest
    static void it_should_not_return_a_list_of_loans_when_given_legal_entities_whos_loans_are_in_the_included_loanAppIds() {
        Id invId1 = ObjectFactory.getFakeId(LLC_BI__Legal_Entities__c.SObjectType, '1');
        Id invId2 = ObjectFactory.getFakeId(LLC_BI__Legal_Entities__c.SObjectType, '2');
        Id loanId1 = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        Id loanId2 = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '2');
        
        LLC_BI__Loan__c loan1 = new LLC_BI__Loan__c();
        loan1.Id = loanId1;
        LLC_BI__Loan__c loan2 = new LLC_BI__Loan__c();
        loan2.Id = loanId2;
        
        LLC_BI__Legal_Entities__c inv1 = new LLC_BI__Legal_Entities__c();
        inv1.Id = invId1;
        inv1.LLC_BI__Loan__c = loanId1;
        inv1.LLC_BI__Loan__r = loan1;
        LLC_BI__Legal_Entities__c inv2 = new LLC_BI__Legal_Entities__c();
        inv2.Id = invId2;
        inv2.LLC_BI__Loan__c = loanId2;
        inv2.LLC_BI__Loan__r = loan2;

        List<LLC_BI__Legal_Entities__c> entityInvolvements = new List<LLC_BI__Legal_Entities__c>{inv1, inv2};
        Set<Id> includedLoanAppIds = new Set<Id>{loanId1, loanId2};
        //act
        List<LLC_BI__Loan__c> results = sut.getExcludedLlcBiLoans(entityInvolvements, includedLoanAppIds);
        //assert
        System.assertEquals(0,  results.size());
    }

    @IsTest
    static void it_should_return_a_list_of_loans_when_given_legal_entities_whos_loans_are_not_in_the_included_loanAppIds() {
        Id invId1 = ObjectFactory.getFakeId(LLC_BI__Legal_Entities__c.SObjectType, '1');
        Id invId2 = ObjectFactory.getFakeId(LLC_BI__Legal_Entities__c.SObjectType, '2');
        Id loanId1 = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        Id loanId2 = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '2');
        
        LLC_BI__Loan__c loan1 = new LLC_BI__Loan__c();
        loan1.Id = loanId1;
        LLC_BI__Loan__c loan2 = new LLC_BI__Loan__c();
        loan2.Id = loanId2;
        
        LLC_BI__Legal_Entities__c inv1 = new LLC_BI__Legal_Entities__c();
        inv1.Id = invId1;
        inv1.LLC_BI__Loan__c = loanId1;
        inv1.LLC_BI__Loan__r = loan1;
        LLC_BI__Legal_Entities__c inv2 = new LLC_BI__Legal_Entities__c();
        inv2.Id = invId2;
        inv2.LLC_BI__Loan__c = loanId2;
        inv2.LLC_BI__Loan__r = loan2;

        List<LLC_BI__Legal_Entities__c> entityInvolvements = new List<LLC_BI__Legal_Entities__c>{inv1, inv2};
        Set<Id> includedLoanAppIds = new Set<Id>();
        //act
        List<LLC_BI__Loan__c> results = sut.getExcludedLlcBiLoans(entityInvolvements, includedLoanAppIds);
        //assert
        System.assertEquals(2,  results.size());
        System.assertEquals(true,  results.contains(inv1.LLC_BI__Loan__r));
        System.assertEquals(true,  results.contains(inv2.LLC_BI__Loan__r));
    }

    @IsTest
    static void it_should_not_error_when_an_involvements_loan_value_is_null() {
        Id invId1 = ObjectFactory.getFakeId(LLC_BI__Legal_Entities__c.SObjectType, '1');
        Id invId2 = ObjectFactory.getFakeId(LLC_BI__Legal_Entities__c.SObjectType, '2');
        Id loanId1 = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        
        LLC_BI__Loan__c loan1 = new LLC_BI__Loan__c();
        loan1.Id = loanId1;
        
        LLC_BI__Legal_Entities__c inv1 = new LLC_BI__Legal_Entities__c();
        inv1.Id = invId1;
        inv1.LLC_BI__Loan__c = loanId1;
        inv1.LLC_BI__Loan__r = loan1;
        LLC_BI__Legal_Entities__c inv2 = new LLC_BI__Legal_Entities__c();
        inv2.Id = invId2;

        List<LLC_BI__Legal_Entities__c> entityInvolvements = new List<LLC_BI__Legal_Entities__c>{inv1, inv2};
        Set<Id> includedLoanAppIds = new Set<Id>();
        //act
        List<LLC_BI__Loan__c> results = sut.getExcludedLlcBiLoans(entityInvolvements, includedLoanAppIds);
        //assert
        System.assertEquals(1,  results.size());
        System.assertEquals(true,  results.contains(inv1.LLC_BI__Loan__r));
    }
    
    @IsTest
    static void it_should_filter_out_loans_when_ebAccount_and_loan_names_are_equal() {
        LLC_BI__Loan__c loan1 = new LLC_BI__Loan__c();
        loan1.Name = '1111';
        LLC_BI__Loan__c loan2 = new LLC_BI__Loan__c();
        loan2.Name = '2222';

        EB_Account__c acc1 = new EB_Account__c();
        acc1.Name = '1111';
        EB_Account__c acc2 = new EB_Account__c();
        acc2.Name = '2222';

        List<LLC_BI__Loan__c> unfilteredExcludedLoans = new List<LLC_BI__Loan__c>{loan1, loan2};
        List<EB_Account__c> IncludedEbAccounts = new List<EB_Account__c>{acc1, acc2};
        //act
        List<LLC_BI__Loan__c> results = sut.filterExcludedLlcBiLoans(unfilteredExcludedLoans, IncludedEbAccounts);
        //assert
        System.assertEquals(0, results.size());
    }

    @IsTest
    static void it_should_not_filter_out_loans_when_ebAccount_and_loan_names_are_not_equal() {
        LLC_BI__Loan__c loan1 = new LLC_BI__Loan__c();
        loan1.Name = '1';
        LLC_BI__Loan__c loan2 = new LLC_BI__Loan__c();
        loan2.Name = '2';

        EB_Account__c acc1 = new EB_Account__c();
        acc1.Name = '1111';
        EB_Account__c acc2 = new EB_Account__c();
        acc2.Name = '2222';

        List<LLC_BI__Loan__c> unfilteredExcludedLoans = new List<LLC_BI__Loan__c>{loan1, loan2};
        List<EB_Account__c> IncludedEbAccounts = new List<EB_Account__c>{acc1, acc2};
        //act
        List<LLC_BI__Loan__c> results = sut.filterExcludedLlcBiLoans(unfilteredExcludedLoans, IncludedEbAccounts);
        //assert
        System.assertEquals(2, results.size());
    }
}