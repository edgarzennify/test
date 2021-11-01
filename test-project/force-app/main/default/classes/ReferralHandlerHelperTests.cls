@IsTest
private class ReferralHandlerHelperTests {

    private static final Mock.OfISObject mockSObject;
    private static final ReferralHandlerHelper sut;

    static {
        mockSObject = new Mock.ofISObject();
        sut = new ReferralHandlerHelper(mockSObject);
    }

    @IsTest
    static void it_should_set_lead_owner_fields_to_values_from_the_currentUser() {
        PM_UserRole testRole = new PM_UserRole();
        testRole.Name = 'test role name';
        PM_User owner = new PM_User();
        owner.Id = ObjectFactory.getFakeId(User.SObjectType, '1');
        owner.Department = 'some department';
        owner.Division = 'some division';
        owner.Title = 'some title';
        owner.UserRole = testRole;
        Lead testLead = new Lead();

        sut.setLeadOwnerFields(testLead, owner);

        System.assertEquals(owner.Id, testLead.OwnerId);
        System.assertEquals('some division', testLead.Branch_L_Original__c);
        System.assertEquals('some division', testLead.Owner_Branch_L_Original__c);
        System.assertEquals('some department', testLead.Owner_Department_Original__c);
        System.assertEquals('test role name', testLead.Lead_Owner_Role_Original__c);
        System.assertEquals('some title', testLead.Owner_Title_Original__c);
    }

    @IsTest
    static void it_should_return_the_distribution_channel() {
        Lead testLead = new Lead(Opportunity_Type__c = 'test distribution channel');

        String results = sut.getDistributionChannel(testLead);

        System.assertEquals('test distribution channel', results);
    }

    @IsTest
    static void it_should_return_the_leads_client_preferred_branch_as_the_routing_team_when_type_is_consumer() {
        PM_User currentUser = new PM_User();
        Lead testLead = new Lead(
            Opportunity_Type__c = 'Consumer Deposits, Construction, and Non-Real Estate Loans',
            Client_Preferred_Branch__c = 'test client branch'
        );

        String results = sut.getRoutingTeam(testLead, currentUser);

        System.assertEquals('test client branch', results);
    }

    @IsTest
    static void it_should_return_the_leads_client_preferred_branch_as_the_routing_team_when_type_is_private_banking() {
        PM_User currentUser = new PM_User();
        Lead testLead = new Lead(
            Opportunity_Type__c = 'Private Banking',
            Client_Preferred_Branch__c = 'test client branch'
        );

        String results = sut.getRoutingTeam(testLead, currentUser);

        System.assertEquals('test client branch', results);
    }

    @IsTest
    static void it_should_return_the_leads_client_preferred_branch_as_the_routing_team_when_type_is_mortgage() {
        PM_User currentUser = new PM_User();
        Lead testLead = new Lead(
            Opportunity_Type__c = 'Mortgage and Other Real Estate',
            Client_Preferred_Branch__c = 'test client branch'
        );

        String results = sut.getRoutingTeam(testLead, currentUser);

        System.assertEquals('test client branch', results);
    }

    @IsTest
    static void it_should_return_the_users_my_referral_team_as_the_routing_team_when_type_is_not_considered_consumer() {
        PM_User currentUser = new PM_User();
        currentUser.My_Referral_Team_c = 'test referral team';
        Lead testLead = new Lead(Opportunity_Type__c = 'not a consumer type');

        String results = sut.getRoutingTeam(testLead, currentUser);

        System.assertEquals('test referral team', results);
    }
    
    @IsTest
    static void it_should_set_the_referring_user() {
        PM_UserRole testRole = new PM_UserRole();
        testRole.Name = 'test role name';
        PM_User currentUser = new PM_User();
        currentUser.Id = ObjectFactory.getFakeId(User.SObjectType, '1');
        currentUser.Department = 'some department';
        currentUser.Division = 'some division';
        currentUser.EmailAddress = 'testEmail@ebtTest.com.invalid';
        currentUser.Title = 'some title';
        currentUser.UserRole = testRole;
        Lead testLead = new Lead(CreatedById = currentUser.Id);

        sut.setReferringUser(testLead, currentUser);

        System.assertEquals(currentUser.Id, testLead.Referring_User__c);
        System.assertEquals('testEmail@ebtTest.com.invalid', testLead.Referrer_Email__c);
        System.assertEquals('some division', testLead.Referrer_Branch_L_Original__c);
        System.assertEquals('some department', testLead.Referrer_Department_Original__c);
        System.assertEquals('some title', testLead.Referrer_Title_Original__c);
        System.assertEquals('test role name', testLead.Referrer_Role_Original__c);
    }

    @IsTest
    static void it_should_set_the_recordType() {
        RecordType internalReferral = ObjectFactory.getRecordTypeObjByNameAndObject('Internal Referral', 'Lead');
        RecordType mql = ObjectFactory.getRecordTypeObjByNameAndObject('MQL', 'Lead');
        Map<String, RecordType> rtMap = new Map<String, RecordType>();
        rtMap.put('Internal Referral', internalReferral);
        rtMap.put('MQL', mql);
        Lead testLead = new Lead(
            RecordTypeId = internalReferral.Id
        );

        sut.setRecordType(testLead, rtMap);

        System.assertEquals(mql.Id, testLead.RecordTypeId);
    }

    @IsTest
    static void it_should_return_a_user_pm_when_one_owner_matches_criteria() {
        String distributionChannel = 'Tax Credit';
        String routingTeam = 'Test Branch';

        PM_User validOwner = new PM_User();
        validOwner.Id = ObjectFactory.getFakeId(User.SObjectType, '1');
        validOwner.Distribution_Channel_c = 'Tax Credit';
        validOwner.Referral_Routing_Team_c = 'Test Branch';
        PM_User invalidOwner = new PM_User();
        invalidOwner.Id = ObjectFactory.getFakeId(User.SObjectType, '2');
        invalidOwner.Distribution_Channel_c = null;
        invalidOwner.Referral_Routing_Team_c = null;
        Map<Id, PM_User> potentialOwnersMap = new Map<Id, PM_User>();
        potentialOwnersMap.put(validOwner.Id, validOwner);
        potentialOwnersMap.put(invalidOwner.Id, invalidOwner);
        
        Lead testLead = new Lead(
            OwnerId = ObjectFactory.getFakeId(User.SObjectType, '3'),
            Opportunity_Type__c = 'Tax Credit',
            Client_Preferred_Branch__c = 'Test Branch'
        ); 

        PM_User results = sut.getOwner(testLead, potentialOwnersMap, distributionChannel, routingTeam);

        System.assertEquals(validOwner.Id, results.Id);
    }

    @IsTest
    static void it_should_throw_an_error_if_no_owner_matches_criteria() {
        String distributionChannel = 'Tax Credit';
        String routingTeam = 'Test Branch';

        PM_User invalidOwner = new PM_User();
        invalidOwner.Id = ObjectFactory.getFakeId(User.SObjectType, '1');
        invalidOwner.Distribution_Channel_c = 'not valid owner';
        invalidOwner.Referral_Routing_Team_c = 'not valid owner';
        Map<Id, PM_User> potentialOwnersMap = new Map<Id, PM_User>();
        potentialOwnersMap.put(invalidOwner.Id, invalidOwner);
        
        Lead testLead = new Lead(
            OwnerId = ObjectFactory.getFakeId(User.SObjectType, '2'),
            Opportunity_Type__c = 'Tax Credit',
            Client_Preferred_Branch__c = 'Test Branch'
        );
        String errorMessage =   'No user has been found with a Distribution Channel of Tax Credit ' + 
                                'and a Referral Routing Team of Test Branch. '                       + 
                                'Therefore this lead has NOT been handed off to someone for initial processing.'; 

        PM_User results = sut.getOwner(testLead, potentialOwnersMap, distributionChannel, routingTeam);

        mockSObject.verify('addError', new List<Object>{testLead, errorMessage}, Times.Once);
    }
    
    @IsTest
    static void it_should_throw_an_error_if_more_than_one_owner_matches_criteria() {
        String distributionChannel = 'Tax Credit';
        String routingTeam = 'Test Branch';
        
        PM_User matchingOwner1 = new PM_User();
        matchingOwner1.Id = ObjectFactory.getFakeId(User.SObjectType, '1');
        matchingOwner1.Distribution_Channel_c = 'Tax Credit';
        matchingOwner1.Referral_Routing_Team_c = 'Test Branch';
        PM_User matchingOwner2 = new PM_User();
        matchingOwner2.Id = ObjectFactory.getFakeId(User.SObjectType, '2');
        matchingOwner2.Distribution_Channel_c = 'Tax Credit';
        matchingOwner2.Referral_Routing_Team_c = 'Test Branch';
        
        Map<Id, PM_User> potentialOwnersMap = new Map<Id, PM_User>();
        potentialOwnersMap.put(matchingOwner1.Id, matchingOwner1);
        potentialOwnersMap.put(matchingOwner2.Id, matchingOwner2);
        Lead testLead = new Lead(
            OwnerId = ObjectFactory.getFakeId(User.SObjectType, '3'),
            Opportunity_Type__c = 'Tax Credit',
            Client_Preferred_Branch__c = 'Test Branch'
        );
        String errorMessage =   'Multiple users have been found with a Distribution Channel of Tax Credit ' + 
                                'and a Referral Routing Team of Test Branch. '                               + 
                                'Therefore this lead has NOT been handed off to someone for initial processing.';

        PM_User results = sut.getOwner(testLead, potentialOwnersMap, distributionChannel, routingTeam);

        mockSObject.verify('addError', new List<Object>{testLead, errorMessage}, Times.Once);
    }

    @IsTest
    static void it_should_set_the_isInternalReferral_field_to_true() {
        Lead testLead = new Lead(Is_Internal_Referral__c = false);

        sut.setInternalReferralField(testLead);

        System.assertEquals(true, testLead.Is_Internal_Referral__c);
    }

    @IsTest
    static void it_should_set_the_lead_status_field_to_new_referral() {
        Lead testLead = new Lead(Status = 'some status');

        sut.setLeadStatus(testLead);

        System.assertEquals('New Referral', testLead.Status);
    }

    @IsTest
    static void it_should_return_the_referring_user_object_from_the_given_lead() {
        PM_User referrer = new PM_User();
        referrer.Id = ObjectFactory.getFakeId(User.SObjectType, '1');
        PM_User notReferrer = new PM_User();
        notReferrer.Id = ObjectFactory.getFakeId(User.SObjectType, '2');
        
        Map<Id, PM_User> referrersMap = new Map<Id, PM_User>();
        referrersMap.put(notReferrer.Id, notReferrer);
        referrersMap.put(referrer.Id, referrer);

        Lead testLead = new Lead(
            Status = 'some status',
            Referring_User__c = referrer.Id
        );

        PM_User results = sut.getReferrer(testLead, referrersMap);

        System.assertEquals(referrer.Id, results.Id);
    }

    @IsTest
    static void it_should_update_the_referring_user_fields() {
        PM_UserRole testRole = new PM_UserRole();
        testRole.Name = 'test role name';
        PM_User referrer = new PM_User();
        referrer.Id = ObjectFactory.getFakeId(User.SObjectType, '1');
        referrer.Department = 'some department';
        referrer.Division = 'some division';
        referrer.EmailAddress = 'testEmail@ebtTest.com.invalid';
        referrer.Title = 'some title';
        referrer.UserRole = testRole;

        Lead testLead = new Lead(
            Referrer_Email__c = 'theOldEmail@ebt.com.invalid',
            CreatedById = referrer.Id
        );

        sut.updateReferrerFields(testLead, referrer);

        System.assertEquals('testEmail@ebtTest.com.invalid', testLead.Referrer_Email__c);
        System.assertEquals('some division', testLead.Referrer_Branch_L_Original__c);
        System.assertEquals('some department', testLead.Referrer_Department_Original__c);
        System.assertEquals('some title', testLead.Referrer_Title_Original__c);
        System.assertEquals('test role name', testLead.Referrer_Role_Original__c);
    }

    @IsTest
    static void it_should_bootstrap_successfully() {
        Object results = ReferralHandlerHelper.bootstrap();

        System.assertNotEquals(null, results);
    }
}