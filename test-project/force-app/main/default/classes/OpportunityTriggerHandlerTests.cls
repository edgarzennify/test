@IsTest
private class OpportunityTriggerHandlerTests { 

    private static final TriggerHandlerTester tester;
    private static final MockofIOpportunityTriggerHandlerDataProv mockDataProv = new MockofIOpportunityTriggerHandlerDataProv();
    private static final Mock.OfIConfigurations mockConfigs = new Mock.OfIConfigurations();
    private static final OpportunityTriggerHandler sut = new OpportunityTriggerHandler(mockDataProv, mockConfigs);

    static {
        tester = new TriggerHandlerTester();
        mockConfigs.setup('getRelationshipReviewRequiredGracePeriod').returns(7);
        mockDataProv.setup('getAccounts', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(new List<Account>());   
    }

    @IsTest
    static void it_should_call_default_constructor_without_error() {
        OpportunityTriggerHandler sutDef = new OpportunityTriggerHandler();
    }
    
    @IsTest
    static void it_should_set_relationship_review_reminder_date_on_acct_when_new_opportunity_is_created_if_date_is_not_already_set_and_it_is_outside_grace_period_or_is_null() {
        DateTime expectedDateTime = DateTime.newInstance(Date.Today(), Time.newInstance(8,0,0,0));
        Account testAcct = new Account(Id='001f000000GsU5a');
        testAcct.Relationship_Review_Last_Modified_Date__c = Date.today().addDays(-30);
        Account testAcct2 = new Account(Id='001f000000GsU5a');
        Id oppTypeId = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Opportunity' AND isActive = true LIMIT 1].Id;
        Opportunity testOpportunity = new Opportunity(AccountId = testAcct.Id,Name = 'Test Opportunity',RecordTypeId = oppTypeId,StageName = 'Some Stage');
        testOpportunity.Anticipated_Close_Date__c = Date.today().addDays(7);
        Opportunity testOpportunity2 = new Opportunity(AccountId = testAcct.Id,Name = 'Test Opportunity',RecordTypeId = oppTypeId,StageName = 'Some Stage');
        testOpportunity2.Anticipated_Close_Date__c = Date.today().addDays(7);
        Set<Id> acctIds = new Set<Id>{testAcct.Id, testAcct2.Id};
        List<Account> acctsList = new List<Account>{testAcct, testAcct2};
        mockDataProv.setup('getAccounts', new List<Object>{acctIds}).returns(acctsList);
        tester.triggerOld.add(testOpportunity);
        tester.triggerOld.add(testOpportunity2);
        tester.triggerNew.add(testOpportunity);
        tester.triggerNew.add(testOpportunity2);

        tester.afterTriggerInsertSequence(sut);

        mockDataProv.verify('getAccounts', new List<Object>{acctIds}, Times.Once);
        mockConfigs.verify('getRelationshipReviewRequiredGracePeriod', Times.Once);
        mockDataProv.verify('updateAccounts', new List<Object>{acctsList}, Times.Once);
        system.assertEquals(expectedDateTime, testAcct.Relationship_Review_Required_Date__c);
        system.assertEquals(expectedDateTime, testAcct2.Relationship_Review_Required_Date__c);
    }

    @IsTest
    static void it_should_not_change_relationship_review_reminder_date_on_acct_when_new_opportunity_is_created_if_date_is_already_set() {
        DateTime expectedDateTime = DateTime.newInstance(Date.Today().addDays(-1), Time.newInstance(8,0,0,0));
        Account testAcct = new Account(Id='001f000000GsU5a');
        testAcct.Relationship_Review_Required_Date__c = expectedDateTime;
        Id oppTypeId = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Opportunity' AND isActive = true LIMIT 1].Id;
        Opportunity testOpportunity = new Opportunity(AccountId = testAcct.Id,Name = 'Test Opportunity',RecordTypeId = oppTypeId,StageName = 'Some Stage');
        testOpportunity.Anticipated_Close_Date__c = Date.today().addDays(7);
        Set<Id> acctIds = new Set<Id>{testAcct.Id};
        List<Account> acctsList = new List<Account>{testAcct};
        mockDataProv.setup('getAccounts', new List<Object>{acctIds}).returns(acctsList);
        tester.triggerOld.add(testOpportunity);
        tester.triggerNew.add(testOpportunity);

        tester.afterTriggerInsertSequence(sut);
        
        mockDataProv.verify('getAccounts', new List<Object>{acctIds}, Times.Once);
        mockConfigs.verify('getRelationshipReviewRequiredGracePeriod', Times.Once);
        mockDataProv.verify('updateAccount', new List<Object>{acctsList}, Times.Never);
        system.assertEquals(expectedDateTime, testAcct.Relationship_Review_Required_Date__c);
    }

    @IsTest
    static void it_should_not_set_relationship_review_reminder_date_on_acct_when_new_opportunity_is_created_if_it_is_within_grace_period() {
        Account testAcct = new Account(Id='001f000000GsU5a');
        testAcct.Relationship_Review_Last_Modified_Date__c = Date.today().addDays(-3);
        Account testAcct2 = new Account(Id='001f000000GsU5a');
        Id oppTypeId = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Opportunity' AND isActive = true LIMIT 1].Id;
        Opportunity testOpportunity = new Opportunity(AccountId = testAcct.Id,Name = 'Test Opportunity',RecordTypeId = oppTypeId,StageName = 'Some Stage');
        testOpportunity.Anticipated_Close_Date__c = Date.today().addDays(7);
        Set<Id> acctIds = new Set<Id>{testAcct.Id};
        List<Account> acctsList = new List<Account>{testAcct};
        mockDataProv.setup('getAccounts', new List<Object>{acctIds}).returns(acctsList);
        tester.triggerOld.add(testOpportunity);
        tester.triggerNew.add(testOpportunity);

        tester.afterTriggerInsertSequence(sut);
        
        mockDataProv.verify('getAccounts', new List<Object>{acctIds}, Times.Once);
        mockConfigs.verify('getRelationshipReviewRequiredGracePeriod', Times.Once);
        mockDataProv.verify('updateAccounts', new List<Object>{acctsList}, Times.Never);
        system.assertEquals(null, testAcct.Relationship_Review_Required_Date__c);
    }
    private static testMethod void it_should_set_the_PPP_amount_when_a_PPP_original_loan_is_specified_at_create(){
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        loan.LLC_BI__Amount__c = 12345;
        loan.Id = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        Opportunity opp = new Opportunity();
        opp.Original_PPP_Loan_Number2__c = loan.Id;
        opp.Original_PPP_Loan_Number2__r = loan;
        List<SObject> sos = new List<SObject>{opp};
        Set<Id> loanIds = new Set<Id>{loan.Id};
        List<LLC_BI__Loan__c> loans = new List<LLC_BI__Loan__c>{loan};
        
        mockDataProv.setup('getRelatedLoans', new List<Object>{loanIds}).returns(loans);
        sut.bulkBeforeInsert(sos);
        mockDataProv.verify('getRelatedLoans', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
        system.assertEquals(opp.Original_PPP_Loan_Amount__c, loan.LLC_BI__Amount__c);
    }
    private static testMethod void it_should_set_the_PPP_amount_when_a_PPP_original_loan_is_modified(){
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        Id oppId = ObjectFactory.getFakeId(Opportunity.SObjectType, '1');
        loan.LLC_BI__Amount__c = 12345;
        loan.Id = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        Opportunity oldOpp = new Opportunity();
        oldOpp.Original_PPP_Loan_Number2__c = null;
        oldOpp.Id = oppId;
        Opportunity newOpp = new Opportunity();
        newOpp.Original_PPP_Loan_Number2__c = loan.Id;
        newOpp.Original_PPP_Loan_Number2__r = loan;
        newOpp.Id = oppId;
        List<SObject> sos = new List<SObject>{oldOpp};
        Set<Id> loanIds = new Set<Id>{loan.Id};
        List<LLC_BI__Loan__c> loans = new List<LLC_BI__Loan__c>{loan};
        Map<Id, SObject> newSosMap = new Map<Id, SObject>();
        newSosMap.put(newOpp.Id, newOpp);
        
        mockDataProv.setup('getRelatedLoans', new List<Object>{loanIds}).returns(loans);
        sut.bulkBeforeUpdate(sos, newSosMap);
        mockDataProv.verify('getRelatedLoans', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
        system.assertEquals(loan.LLC_BI__Amount__c, newOpp.Original_PPP_Loan_Amount__c);
    }

    private class MockofIOpportunityTriggerHandlerDataProv extends ApexMoq implements OpportunityTriggerHandler.IOpportunityTriggerHandlerDataProv {
        public List<Account> getAccounts(Set<Id> acctIds) {
            return (List<Account>)handleMethodInvocation('getAccounts', new List<Object>{acctIds});
        }
        public void updateAccounts(List<Account> accts) {
            handleMethodInvocation('updateAccounts', new List<Object>{accts});
        }
        public List<LLC_BI__Loan__c> getRelatedLoans(Set<Id> loanIds) {
            return (List<LLC_BI__Loan__c>)handleMethodInvocation('getRelatedLoans', new List<Object>{loanIds});
        }
    }
}