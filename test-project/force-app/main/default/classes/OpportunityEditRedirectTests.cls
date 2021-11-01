@IsTest
private class OpportunityEditRedirectTests {
    
    private static final MockofIOpportunityEditRedirectDataProv mockDataProvider = new MockofIOpportunityEditRedirectDataProv();

    @IsTest
    static void it_should_call_the_default_constructor_without_error() {
        Account testAcct = new Account(Id='001f000000GsU5a');
        Id oppTypeId = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Opportunity' AND isActive = true LIMIT 1].Id;
        Opportunity testOpportunity = new Opportunity(Id='006f0000005BGCh');
        testOpportunity.AccountId = testAcct.Id;
        testOpportunity.Name = 'Test Opportunity';
        testOpportunity.RecordTypeId = oppTypeId;
        testOpportunity.CloseDate = Date.today().addDays(7);
        testOpportunity.StageName = 'Some Stage';
        ApexPages.StandardController sc = new ApexPages.StandardController(testOpportunity);

        OpportunityEditRedirect sut = new OpportunityEditRedirect(sc);
    }

    @IsTest
    static void it_should_return_a_page_reference_to_modify_parent_relationships_if_review_required() {
        Account testAcct = ObjectFactory.getValidEntity('name');
        Id oppTypeId = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Opportunity' AND isActive = true LIMIT 1].Id;
        Opportunity testOpportunity = new Opportunity();
        testOpportunity.AccountId = testAcct.Id;
        testOpportunity.Name = 'Test Opportunity';
        testOpportunity.RecordTypeId = oppTypeId;
        testOpportunity.CloseDate = Date.today().addDays(7);
        testOpportunity.StageName = 'Some Stage';
        insert testOpportunity;
        testAcct.Relationship_Review_Required_Date__c = System.now();
        update testAcct;
        testOpportunity = [SELECT Id, Entity_Relationship_Review_Required__c, AccountId FROM Opportunity WHERE Id =: testOpportunity.Id LIMIT 1];
        mockDataProvider.setup('getOpportunityById', new List<Object>{testOpportunity.Id}).returns(testOpportunity);
        OpportunityEditRedirect sut = new OpportunityEditRedirect(mockDataProvider, testOpportunity);

        PageReference returnVal = sut.determineDestination();

        System.assertEquals(true, returnVal.getUrl().contains('/apex/ParentRelationshipManagerView?id=' + testOpportunity.AccountId));
        mockDataProvider.verify('getOpportunityById', new List<Object>{testOpportunity.Id}, Times.Once);
    }

    @IsTest
    static void it_should_return_a_page_reference_to_modify_opportunity_if_no_relationship_review_required() {
        Account testAcct = ObjectFactory.getValidEntity('name');
        Id oppTypeId = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Opportunity' AND isActive = true LIMIT 1].Id;
        Opportunity testOpportunity = new Opportunity();
        testOpportunity.AccountId = testAcct.Id;
        testOpportunity.Name = 'Test Opportunity';
        testOpportunity.RecordTypeId = oppTypeId;
        testOpportunity.CloseDate = Date.today().addDays(7);
        testOpportunity.StageName = 'Some Stage';
        insert testOpportunity;
        testAcct.Relationship_Review_Required_Date__c = null;
        update testAcct;
        testOpportunity = [SELECT Id, Entity_Relationship_Review_Required__c, AccountId FROM Opportunity WHERE Id =: testOpportunity.Id LIMIT 1];
        mockDataProvider.setup('getOpportunityById', new List<Object>{testOpportunity.Id}).returns(testOpportunity);
        OpportunityEditRedirect sut = new OpportunityEditRedirect(mockDataProvider, testOpportunity);

        PageReference returnVal = sut.determineDestination();

        System.assertEquals(true, returnVal.getUrl().contains('/' + testOpportunity.Id + '/e'));
        mockDataProvider.verify('getOpportunityById', new List<Object>{testOpportunity.Id}, Times.Once);
    }

    private class MockofIOpportunityEditRedirectDataProv extends ApexMoq implements OpportunityEditRedirect.IOpportunityEditRedirectDataProv {
        public Opportunity getOpportunityById(Id oppId){
            return (Opportunity)handleMethodInvocation('getOpportunityById', new List<Object>{oppId});
        }
    }
}