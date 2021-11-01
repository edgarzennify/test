@IsTest
private class Entity360DmBuilderTests
{
    private static Entity360DmBuilder sut;

    static {
        sut = new Entity360DmBuilder();
    }
    
    @IsTest
    static void it_should_build_an_entity_dm_with_top_level_stuff() {
        Account a = new Account();
        a.Id = ObjectFactory.getFakeId(Account.SObjectType, '1');
        a.Name = 'Test Testerson';
        a.ParentId = ObjectFactory.getFakeId(Account.SobjectType, '2');
        a.ROE__c = 18;
        List<Account> accounts = new List<Account> {a};
        
        List<DmEntity> result = sut.buildDmEntities(accounts);

        DmEntity e = result[0];
        System.assertEquals(a.Id, e.id);
        System.assertEquals(a.Name, e.name);
        System.assertEquals(a.ParentId, e.parent.id);
        System.assertEquals(a.ROE__c / 100, e.roe);
    }
    
    @IsTest
    static void it_should_build_a_primary_relationship_in_dm_when_primary_relationship_in_pm_is_not_null() {
        Account a = new Account();
        a.Name = 'Test Testerson';
        insert a;
        
        Account primaryRel = new Account();
        primaryRel.Name = 'Test Name For Primary Relationship';     
        insert primaryRel;
        
        a.Primary_Relationship__r = primaryRel;
        a.Primary_Relationship__c = primaryRel.Id;
        
        update a;
        
        List<Account> accounts = new List<Account> {a};
        
        List<DmEntity> result = sut.buildDmEntities(accounts);

        DmEntity e = result[0];
        System.assertEquals(a.Id, e.id);
        System.assertEquals( a.Primary_Relationship__c, e.primaryRelationship.id);
        System.assertEquals( a.Primary_Relationship__r.Entity_Name__c, e.primaryRelationship.name);
    }
    
    @IsTest
    static void it_should_build_a_primary_relationship_in_dm_when_primary_relationship_in_pm_is_null() {
        Account a = new Account();
        a.Name = 'Test Testerson';
        insert a;
       
        List<Account> accounts = new List<Account> {a};
        
        List<DmEntity> result = sut.buildDmEntities(accounts);

        DmEntity e = result[0];
        System.assertEquals(a.Id, e.id);
        System.assertEquals( a.Id, e.primaryRelationship.id);
        System.assertEquals( a.Entity_Name__c, e.primaryRelationship.name);
    }
    

    @IsTest
    static void it_should_build_an_entity_dm_with_opportunity_stuff() {
        Account a = ObjectFactory.getValidEntity('Test Testerson');
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opportunity';
        opp.CloseDate = Date.today();
        opp.AccountId = a.Id;
        opp.Type = 'oppType';
        opp.Committed_Amount__c = 123.45;
        opp.Potential_Deposits__c = 234.56;
        opp.Potential_Fee_Income__c = 777.77;
        opp.StageName = 'oppStage';
        opp.ForecastCategoryName = 'Pipeline';
        opp.Probability = 50;
        opp.RecordTypeId = ObjectFactory.GetRecordTypeIdByNameAndObject('Consumer', 'Opportunity');

        insert opp;
        List<Account> accounts = SoqlResults(a.Id);
        
        List<DmEntity> result = sut.buildDmEntities(accounts);

        DmOpportunity o = result[0].opportunities[0];
        System.assertEquals(opp.Id, o.id);
        System.assertEquals(opp.Type, o.type);
        System.assertEquals(opp.Committed_Amount__c, o.committedAmount);
        System.assertEquals(opp.Potential_Deposits__c, o.potentialDeposits);
        System.assertEquals(opp.Potential_Fee_Income__c, o.potentialFeeIncome);
        System.assertEquals(opp.StageName, o.stageName);
        System.assertEquals(opp.ForecastCategoryName, o.forecastCategoryName);
        System.assertEquals(opp.Probability / 100, o.probability);
    }

    @IsTest
    static void it_should_build_an_entity_dm_with_ebaccount_stuff() {
        Account a = ObjectFactory.getValidEntity('Test Testerson');
        Eb_Account__c acct = new Eb_Account__c();
        acct.Current_Balance__c = 1;
        acct.Core_Current_Balance__c = 3;
        acct.Average_Balance__c = 123.45;
        acct.YTD_Balance__c = 345.67;
        acct.Account_Fees__c = 999.99;
        acct.Application__c = 4;
        acct.Account_Type__c = '11 - Test Account Type';
        acct.YTD_Contribution_Margin__c = 5;
        insert acct;
        EB_Account_Relationship__c rel = new EB_Account_Relationship__c();
        rel.Client_Id__c = a.Id;
        rel.EB_Account_Id__c = acct.Id;
        rel.Relationship__c = 'Primary Owner';
        insert rel;
        List<Account> accounts = SoqlResults(a.Id);
        
        List<DmEntity> result = sut.buildDmEntities(accounts);

        Eb_Account__c expected = accounts[0].EB_Account_Relationships__r[0].EB_Account_Id__r;
        DmEbAccount dmAcct = result[0].ownedAccounts[0];
        System.assertEquals(expected.Current_Balance__c, dmAcct.currentBalance);
        System.assertEquals(expected.Core_Current_Balance__c, dmAcct.coreCurrentBalance);
        System.assertEquals(expected.Average_Balance__c, dmAcct.averageBalance);
        System.assertEquals(expected.YTD_Balance__c, dmAcct.ytdBalance);
        System.assertEquals(expected.Account_Fees__c, dmAcct.accountFees);
        System.assertEquals(expected.Application__c, dmAcct.application);
        System.assertEquals('11', dmAcct.accountType);        
        System.assertEquals(expected.Employee_Current_Balance__c, dmAcct.employeeCurrentBalance);
        System.assertEquals(expected.Employee_Account_Flag__c, dmAcct.employeeAccountFlag);
        System.assertEquals(expected.YTD_Contribution_Margin__c, dmAcct.ytdContributionMargin);
    }

    @IsTest
    static void it_should_build_an_entity_dm_with_treasury_stuff() {
        Account a = ObjectFactory.getValidEntity('Test Testerson');
        Treasury_Management__c tm = new Treasury_Management__c();
        tm.Account__c = a.Id;
        insert tm;
        List<Account> accounts = SoqlResults(a.Id);
        
        List<DmEntity> result = sut.buildDmEntities(accounts);

        Treasury_Management__c expected = accounts[0].Treasury_Management_Details__r[0];
        DmTreasuryService r = result[0].treasuryServices[0];
        System.assertEquals(expected.Id, r.id);
        System.assertEquals(expected.Name, r.name);
    }

    private static List<Account> SoqlResults(Id accountId){
        return [SELECT Id,Name,ParentId,Primary_Relationship__c,Entity_Name__c,Primary_Relationship__r.Entity_Name__c,ROE__c,
                    (SELECT 
                        Id,  
                        Type, 
                        Committed_Amount__c, 
                        RecordType.Description,
                        Potential_Deposits__c,
                        Potential_Fee_Income__c,  
                        StageName, 
                        ForecastCategoryName, 
                        Probability, 
                        Products__c
                    FROM Opportunities),
                    (SELECT 
                        Id, 
                        Client_Id__c,
                        Relationship__c,
                        EB_Account_Id__r.Current_Balance__c,
                        EB_Account_Id__r.Core_Current_Balance__c, 
                        EB_Account_Id__r.Average_Balance__c, 
                        EB_Account_Id__r.YTD_Balance__c, 
                        EB_Account_Id__r.Application__c,
                        EB_Account_Id__r.Account_Fees__c,
                        EB_Account_Id__r.Account_Type__c,
                        EB_Account_Id__r.Employee_Current_Balance__c,
                        EB_Account_Id__r.Employee_Account_Flag__c,  
                        EB_Account_Id__r.Contribution_Margin__c,
                        EB_Account_Id__r.YTD_Contribution_Margin__c
                    FROM EB_Account_Relationships__r),
                    (SELECT 
                        Id, 
                        Name  
                    FROM Treasury_Management_Details__r)
                FROM Account WHERE Id =: accountId];
    }
}