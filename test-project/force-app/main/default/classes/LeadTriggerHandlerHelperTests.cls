@IsTest
private class LeadTriggerHandlerHelperTests {
    
    private static final Mock.ofISObject mockSobject;
    private static final LeadTriggerHandlerHelper sut;

    static {
        mockSObject = new Mock.OfISObject();
        sut = new LeadTriggerHandlerHelper(mockSObject);
    }

    @IsTest
    static void it_should_update_the_country_field_when_its_empty_or_null() {
        Lead testLead = new Lead(
            FirstName = 'test first name',
            LastName = 'test last name'
        );

        sut.validateCountryField(testLead);

        System.assertEquals('US', testLead.Country);    
    }

    @IsTest
    static void it_should_not_update_the_country_field_when_it_contains_a_value() {
        Lead testLead = new Lead(
            FirstName = 'test first name',
            LastName = 'test last name',
            Country = 'test country'
        );

        sut.validateCountryField(testLead);

        System.assertEquals('test country', testLead.Country);    
    }

    @IsTest
    static void when_company_field_is_blank_and_type_is_personal_it_should_update_the_company_field_using_first_and_last_names() {
        Lead testLead = new Lead(
            FirstName = 'first',
            LastName = 'last',
            Type__c = 'Personal'
        );

        sut.validateCompanyField(testLead);

        System.assertEquals('first last', testLead.Company);
    }

    @IsTest
    static void when_company_and_first_name_fields_are_blank_and_type_is_personal_it_should_update_the_company_field_using_last_name() {
        Id branchId = ObjectFactory.getFakeId(EB_Unit__c.SObjectType, '1');
        
        Lead testLead = new Lead(
            LastName = 'last',
            Type__c = 'Personal'
        );

        sut.validateCompanyField(testLead);

        System.assertEquals('last', testLead.Company);
    }

    @IsTest
    static void when_company_field_is_not_blank_and_type_is_personal_it_should_not_update_the_company_field() {
        Lead testLead = new Lead(Company = 'some company');

        sut.validateCompanyField(testLead);
        
        System.assertEquals('some company', testLead.Company);
    }

    @IsTest
    static void it_should_throw_a_validation_error_when_the_lead_type_is_business_and_the_company_field_is_blank() {
        Lead testLead = new Lead(Type__c = 'Business');
        String errorMessage = 'Company name is required for a Business lead.';

        sut.validateCompanyField(testLead);

        mockSObject.verify('addError', new List<Object>{testLead, errorMessage}, Times.Once);
    }

    @IsTest
    static void it_should_not_throw_a_validation_error_when_the_lead_type_is_business_and_the_company_field_is_not_blank() {
        Lead testLead = new Lead(
            Type__c = 'Business',
            Company = 'some company'
        );
        String errorMessage = 'Company name is required for a Business lead.';

        sut.validateCompanyField(testLead);

        mockSObject.verify('addError', new List<Object>{testLead, errorMessage}, Times.Never);
    }

    @IsTest
    static void it_should_return_a_map() {
        RecordType rt1 = new RecordType(Name = 'rt1');
        RecordType rt2 = new RecordType(Name = 'rt2');
        List<RecordType> recordTypes = new List<RecordType>{rt1, rt2};

        Map<String, RecordType> results = sut.mapRecordTypes(recordTypes);

        System.assertEquals(true, results.containsKey('rt1'));
        System.assertEquals(rt1, results.get('rt1'));
        System.assertEquals(true, results.containsKey('rt2'));
        System.assertEquals(rt2, results.get('rt2'));
    }

    @IsTest
    static void it_should_set_the_referring_user_fields_when_ld_is_a_valid_handoff() {
        PM_UserRole testRole = new PM_UserRole();
        testRole.Name = 'some role';
        PM_User oldOwner = new PM_User();
        oldOwner.Id = ObjectFactory.getFakeId(User.SObjectType, '100');
        oldOwner.EmailAddress = 'old@email.address';
        oldOwner.Division = 'old some division';
        oldOwner.Department = 'old some department';
        oldOwner.Title = 'old some title';
        oldOwner.UserRole = testRole;
        PM_User newOwner = new PM_User();
        newOwner.Id = ObjectFactory.getFakeId(User.SObjectType, '101');
        newOwner.EmailAddress = 'some@email.address';
        newOwner.Division = 'some division';
        newOwner.Department = 'some department';
        newOwner.Title = 'some title';
        newOwner.UserRole = testRole;
        Map<Id, PM_User> owners = new Map<Id, PM_User>();
        owners.put(oldOwner.Id, oldOwner);
        owners.put(newOwner.Id, newOwner);

        Lead oldLd = new Lead(
            Lead_Handoff__c = true,
            OwnerId = oldOwner.Id,
            Referring_User__c = null
        );
        Lead newLd = new Lead(
            Lead_Handoff__c = true,
            OwnerId = newOwner.Id
        );

        sut.handleLeadHandoff(oldLd, newLd, owners);
        System.assertEquals(oldOwner.Id, newLd.Referring_User__c);
        System.assertEquals('old@email.address', newLd.Referrer_Email__c);
        System.assertEquals('old some division', newLd.Referrer_Branch_L_Original__c);
        System.assertEquals('old some department', newLd.Referrer_Department_Original__c);
        System.assertEquals('some role', newLd.Referrer_Role_Original__c);
        System.assertEquals('old some title', newLd.Referrer_Title_Original__c);
    }

    @IsTest
    static void it_should_set_lead_owner_fields_to_values_from_the_currentUser_when_the_currentUser_is_not_the_pardot_user() {
        Lead testLead = new Lead();
        PM_UserRole testRole = new PM_UserRole();
        testRole.Name = 'test role name';
        PM_User currentUser = new PM_User();
        currentUser.Id = ObjectFactory.getFakeId(User.SObjectType, '1');
        currentUser.Division = 'some division';
        currentUser.Department = 'some department';
        currentUser.Title = 'some title';
        currentUser.UserRole = testRole;

        Id pardotUserId = ObjectFactory.getFakeId(User.SObjectType, '2');
        Map<Id, PM_User> potentialOwnersMap = new Map<Id, PM_User>();

        sut.initializeLeadOwner(testLead, currentUser, pardotUserId, potentialOwnersMap);

        System.assertEquals(currentUser.Id, testLead.OwnerId);
        System.assertEquals('some division', testLead.Branch_L_Original__c);
        System.assertEquals('some division', testLead.Owner_Branch_L_Original__c);
        System.assertEquals('some department', testLead.Owner_Department_Original__c);
        System.assertEquals('test role name', testLead.Lead_Owner_Role_Original__c);
        System.assertEquals('some title', testLead.Owner_Title_Original__c);
    }

    @IsTest
    static void it_should_set_lead_owner_fields_to_values_from_the_existing_lead_owner_when_the_currentUser_is_the_pardot_user() {
        PM_UserRole givenRole = new PM_UserRole();
        givenRole.Name = 'given role name';
        PM_User givenOwner = new PM_User();
        givenOwner.Id = ObjectFactory.getFakeId(User.SObjectType, '1');
        givenOwner.Division = 'given division';
        givenOwner.Department = 'given department';
        givenOwner.Title = 'given title';
        givenOwner.UserRole = givenRole;
        Lead testLead = new Lead(OwnerId = givenOwner.Id);

        PM_UserRole testRole = new PM_UserRole();
        testRole.Name = 'test role name';
        PM_User currentUser = new PM_User();
        currentUser.Id = ObjectFactory.getFakeId(User.SObjectType, '1');
        currentUser.Division = 'some division';
        currentUser.Department = 'some department';
        currentUser.Title = 'some title';
        currentUser.UserRole = testRole;

        Id pardotUserId = ObjectFactory.getFakeId(User.SObjectType, '1');
        Map<Id, PM_User> potentialOwnersMap = new Map<Id, PM_User>();
        
        Map<Id, PM_User> potentialOwners = new Map<Id, PM_User>();
        potentialOwners.put(givenOwner.Id, givenOwner);

        sut.initializeLeadOwner(testLead, currentUser, pardotUserId, potentialOwners);

        System.assertEquals(givenOwner.Id, testLead.OwnerId);
        System.assertEquals('given division', testLead.Branch_L_Original__c);
        System.assertEquals('given division', testLead.Owner_Branch_L_Original__c);
        System.assertEquals('given department', testLead.Owner_Department_Original__c);
        System.assertEquals('given role name', testLead.Lead_Owner_Role_Original__c);
        System.assertEquals('given title', testLead.Owner_Title_Original__c);
    }

    @IsTest
    static void it_should_update_the_owner_fields_when_the_lead_owner_changes() {
        Lead oldLd = new Lead(
            OwnerId = ObjectFactory.getFakeId(User.SObjectType, '1'),
            Branch_L_Original__c = 'should not change'
        );
        Lead newLd = new Lead(
            OwnerId = ObjectFactory.getFakeId(User.SObjectType, '2'),
            Branch_L_Original__c = 'should not change'
        );
        PM_UserRole testRole = new PM_UserRole();
        testRole.Name = 'test role name';
        PM_User newOwner = new PM_User();
        newOwner.Id = ObjectFactory.getFakeId(User.SObjectType, '2');
        newOwner.Division = 'some division';
        newOwner.Department = 'some department';
        newOwner.Title = 'some title';
        newOwner.UserRole = testRole;
        Map<Id, PM_User> potentialOwnersMap = new Map<Id, PM_User>{newOwner.Id => newOwner};

        sut.handleOwnerUpdates(oldLd, newLd, potentialOwnersMap);

        System.assertEquals(newOwner.Id, newLd.OwnerId);
        System.assertEquals('should not change', newLd.Branch_L_Original__c);
        System.assertEquals('some division', newLd.Owner_Branch_L_Original__c);
        System.assertEquals('some department', newLd.Owner_Department_Original__c);
        System.assertEquals('test role name', newLd.Lead_Owner_Role_Original__c);
        System.assertEquals('some title', newLd.Owner_Title_Original__c);
    }

    @IsTest
    static void it_should_bootstrap_successfully() {
        Object results = LeadTriggerHandlerHelper.bootstrap();

        System.assertNotEquals(null, results);
    }
}