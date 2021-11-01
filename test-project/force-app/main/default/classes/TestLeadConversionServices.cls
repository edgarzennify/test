@IsTest
private class TestLeadConversionServices 
{
    @IsTest
    static void testLinkedContacts() {
        EB_Unit__c unit = new EB_Unit__c();
        unit.Unit_Reporting_Label__c = 'Test Branch';
        unit.Phone_Number__c = '314-555-5555';
        insert unit;
        
        String accRecTypeId = ObjectFactory.getRecordTypeIdByNameAndObject('Prospect', 'Account');

        Account acc = new Account();
        acc.RecordTypeId = accRecTypeId;
        acc.Name = 'Test Acc';
        acc.BillingCountry  = 'test country';

        Account acc2 = new Account();
        acc2.RecordTypeId = accRecTypeId;
        acc2.Name = 'Test Acc2';        
        acc2.BillingCountry  = 'test country';        
        insert new List<Account>{acc, acc2};

        EB_Industry_Code__c industryCode = new EB_Industry_Code__c();
        insert industryCode;
    
        Lead lead = new Lead();
        lead.RecordTypeId = ObjectFactory.getRecordTypeIdByNameAndObject('MQL', 'Lead');
        lead.Company = 'Some Company';
        lead.LastName = 'Test';
        lead.Email = 'test@test.com';
        lead.Opportunity_Type__c = 'Consumer Banking';
        lead.Client_Preferred_Branch__c = 'St Louis - Clayton';
        lead.EB_Branch__c = unit.Id;
        lead.Country = 'test country';
        lead.NAICS_Code__c = industryCode.Id;
        insert lead;
        
        Contact cont = new Contact();
        cont.AccountId = acc.Id;
        cont.LastName = 'Acc';
        cont.Email = 'acc@asd.com';
        cont.Associated_With_Lead__c = lead.Id;
        cont.MailingCountry  = 'test country';
        
        Contact cont2 = new Contact();
        cont2.AccountId = acc.Id;
        cont2.LastName = 'Acc';
        cont2.Email = 'acc2@asd.com';
        cont2.Associated_With_Lead__c = lead.Id;
        cont2.MailingCountry  = 'test country';
        insert new List<Contact>{cont, cont2};
        
        User ADMIN_USER = ObjectFactory.getUser();
        
        System.runAs(ADMIN_USER)
        {
            Database.LeadConvert lc = new database.LeadConvert();
            lc.setLeadId(lead.Id);
            lc.setAccountId(acc2.Id);
            lc.setConvertedStatus('SQL');
            test.startTest();
            Database.LeadConvertResult lcr = Database.convertLead(lc);
            test.stopTest();
            System.assert(lcr.isSuccess());
        }
        
        List<Contact> conts = [SELECT Id, AccountId, Account.Name, Associated_With_Lead__c FROM Contact WHERE Id = :cont.Id];
        System.assertEquals(acc2.Name, conts[0].Account.Name);
    }

    @IsTest
    static void it_should_set_set_the_referrer_name_to_owner_when_lead_handoff_is_set_for_recordtype_lead_MQL() {
        ObjectFactory.TestUser systemAdminUser1 = new ObjectFactory.TestUser('testL1', 'sysuser','testL1sysuser@enterprisebankstl.sfdc.test','Application Development','System Administrator',null);
        ObjectFactory.TestUser systemAdminUser2 = new ObjectFactory.TestUser('testL2', 'sysuser','testL2sysuser@enterprisebankstl.sfdc.test','Application Development','System Administrator',null);
        User testUser1 = systemAdminUser1.CreateUser();
        User testUser2 = systemAdminUser2.CreateUser();
        
        List<PermissionSet> pSet = [SELECT Id, Label, Name FROM PermissionSet WHERE Label = 'Function - Lead Hand Off'];
        List<PermissionSetAssignment> pAssign = [SELECT AssigneeId FROM PermissionSetAssignment WHERE PermissionSetId =: pSet[0].Id LIMIT 1];
        PermissionSetAssignment aSSign1 = new PermissionSetAssignment();
        aSSign1.AssigneeId = testUser1.Id;
        aSSign1.PermissionSetId = pSet[0].Id;
		PermissionSetAssignment aSSign2 = new PermissionSetAssignment();
        aSSign2.AssigneeId = testUser2.Id;
        aSSign2.PermissionSetId = pSet[0].Id;
        insert new List<PermissionSetAssignment>{aSSign1, aSSign2};
        List<PermissionSetAssignment> oCheck = [SELECT Id, AssigneeId FROM PermissionSetAssignment WHERE AssigneeId =: testUser2.Id limit 1];

        System.runAs(testUser1) 
        {
            // String leadRecTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Lead' AND Name = 'MQL'].Id;
            String leadRecTypeId = ObjectFactory.getRecordTypeIdByNameAndObject('MQL', 'Lead');
            EB_Unit__c testUnit = new EB_Unit__c();
            testUnit.Unit_Reporting_Label__c = 'Test Branch';
            testUnit.Phone_Number__c = '314-555-5555';
            insert testUnit;

            Lead testlead = new Lead();
            testlead.RecordTypeId = leadRecTypeId;
            testlead.Company = 'Some Company';
            testlead.LastName = 'Test';
            testlead.Email = 'test@test.com';
            testlead.Opportunity_Type__c = 'Consumer Banking';
            testlead.Client_Preferred_Branch__c = 'St Louis - Clayton';
            testlead.EB_Branch__c = testUnit.Id;
            testlead.OwnerId = testUser1.Id;
            testlead.Country = 'test country';
            insert testlead;

            testlead.OwnerId = pAssign[0].AssigneeId;
            testlead.Lead_Handoff__c = true;
            update testlead;
			
            Lead queriedLead = [SELECT Id, Referrer_Name__c,Referring_User__r.Name,Referring_User__r.Email FROM Lead WHERE Id =:testlead.Id];
            System.assertEquals('testL1 sysuser',queriedLead.Referrer_Name__c);
        }
    }

    @IsTest
    static void it_should_set_set_the_referrer_name_to_owner_when_lead_handoff_is_set_for_recordtype_Lead_SQL() {
        ObjectFactory.TestUser systemAdminUser3 = new ObjectFactory.TestUser('testL3', 'sysuser','testL3sysuser@enterprisebankstl.sfdc.test','Application Development','System Administrator',null);
        ObjectFactory.TestUser systemAdminUser4 = new ObjectFactory.TestUser('testL4', 'sysuser','testL4sysuser@enterprisebankstl.sfdc.test','Application Development','System Administrator',null);
        User testUser3 = systemAdminUser3.CreateUser();
        User testUser4 = systemAdminUser4.CreateUser();

        System.runAs(testUser3) 
        {
            // String leadSuspectRecTypeId = [SELECT Id, Name FROM RecordType WHERE SObjectType = 'Lead' AND Name = 'SQL'].Id;
            String leadSuspectRecTypeId = ObjectFactory.getRecordTypeIdByNameAndObject('SQL', 'Lead');
            
            EB_Unit__c testUnit = new EB_Unit__c();
            testUnit.Unit_Reporting_Label__c = 'Test Branch';
            testUnit.Phone_Number__c = '314-555-5555';
            insert testUnit;

            Lead testlead = new Lead();
            testlead.RecordTypeId = leadSuspectRecTypeId;
            testlead.Company = 'Some Company';
            testlead.LastName = 'Test';
            testlead.Email = 'test@test.com';
            testlead.Opportunity_Type__c = 'Consumer Banking';
            testlead.Client_Preferred_Branch__c = 'St Louis - Clayton';
            testlead.EB_Branch__c = testUnit.Id;
            testlead.OwnerId = testUser3.Id;
            testlead.Country = 'test country';
            insert testlead;

            testlead.OwnerId = testUser4.Id;
            testlead.Lead_Handoff__c = true;
            update testlead;

            Lead queriedLead = [SELECT Id, Referrer_Name__c,Referring_User__r.Name,Referring_User__r.Email FROM Lead WHERE Id =:testlead.Id];
            System.assertEquals('testL3 sysuser',queriedLead.Referrer_Name__c);
        } 
    }
}