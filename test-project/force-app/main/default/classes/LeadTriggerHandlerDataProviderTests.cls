@IsTest
private class LeadTriggerHandlerDataProviderTests {
    
    private static final LeadTriggerHandlerDataProvider sut;

    static {
        sut = new LeadTriggerHandlerDataProvider();
    }

    @IsTest
    static void it_should_return_the_current_user() {
        UserRole testRole = new UserRole(Name = 'some role');
        insert testRole;

        User included = ObjectFactory.getUser('joe', 'joker', 'email1@email.com.invalid', false);
        included.Department = 'some department';
        included.Division = 'some division';
        included.Title = 'some title';
        included.UserRoleId = testRole.Id;
        included.My_Referral_Team__c = 'test referral team';

        User excluded = ObjectFactory.getUser('freddie', 'face', 'email3@email.com.invalid', false);
        insert new List<User>{included, excluded};

        PM_User results = sut.getCurrentUser(included.Id);

        System.assertEquals(included.Id, results.Id);
        System.assertEquals('some department', results.Department);
        System.assertEquals('some division', results.Division);
        System.assertEquals('email1@email.com.invalid', results.EmailAddress);
        System.assertEquals('some title', results.Title);
        System.assertEquals('test referral team', results.My_Referral_Team_c);
        System.assertEquals('some role', results.UserRole.Name);
    }

    @IsTest
    static void it_should_return_pm_users_in_the_given_id_set() {
        UserRole testRole = new UserRole(Name = 'some role');
        insert testRole;

        User included = ObjectFactory.getUser('joe', 'joker', 'email1@email.com.invalid', false);
        included.Department = 'dept 1';
        included.Distribution_Channel__c = 'distribution channel 1';
        included.Division = 'division 1';
        included.Referral_Routing_Team__c = 'referral routing 1';
        included.Title = 'title 1';
        included.UserRoleId = testRole.Id;
        included.IsActive = true;
        included.My_Referral_Team__c = 'test referral team';

        User excluded = ObjectFactory.getUser('freddie', 'face', 'email3@email.com.invalid', false);
        insert new List<User>{included, excluded};

        Set<Id> ownerIds = new Set<Id>{included.Id};

        List<PM_User> results = sut.getOriginalLeadOwners(ownerIds);

        System.assertEquals(included.Department, results[0].Department);
        System.assertEquals(included.Distribution_Channel__c, results[0].Distribution_Channel_c);
        System.assertEquals(included.Division, results[0].Division);
        System.assertEquals(included.Email, results[0].EmailAddress);
        System.assertEquals(included.My_Referral_Team__c, results[0].My_Referral_Team_c);
        System.assertEquals(included.Referral_Routing_Team__c, results[0].Referral_Routing_Team_c);
        System.assertEquals(included.Title, results[0].Title);
        System.assertEquals(testRole.Name, results[0].UserRole.Name);
    }

    @IsTest
    static void it_should_return_a_list_of_referral_matrix_owners_as_pm_users() {
        UserRole testRole = new UserRole(Name = 'some role');
        insert testRole;
        User included = ObjectFactory.getUser('joe', 'joker', 'email1@email.com.invalid', false);
        included.Department = 'dept 1';
        included.Distribution_Channel__c = 'distribution channel 1';
        included.Division = 'division 1';
        included.Referral_Routing_Team__c = 'referral routing 1';
        included.Title = 'title 1';
        included.UserRoleId = testRole.Id;
        included.IsActive = true;
        User excluded = ObjectFactory.getUser('freddie', 'face', 'fredFace@email.com.invalid', false);
        insert new List<User>{included, excluded};
        
        List<PM_User> results = sut.getReferralMatrixOwners();

        //User object is not isolated from test methods and can be accessed via tests.  This requires the loop for verification.  JELLISON
        for (PM_User pm : results) {
            if (excluded.Id == pm.Id) {
                System.assert(false, 'Excluded User should not be returned.');
            } else if (included.Id == pm.Id) {
                System.assertEquals(included.Department, pm.Department);
                System.assertEquals(included.Distribution_Channel__c, pm.Distribution_Channel_c);
                System.assertEquals(included.Division, pm.Division);
                System.assertEquals(included.Email, pm.EmailAddress);
                System.assertEquals(included.Referral_Routing_Team__c, pm.Referral_Routing_Team_c);
                System.assertEquals(included.Title, pm.Title);
                System.assertEquals(testRole.Name, pm.UserRole.Name);
                break;
            }
        }
    }

    @IsTest
    static void it_should_return_a_list_of_referring_users() {
        UserRole testRole = new UserRole(Name = 'some role');
        insert testRole;
        User included = ObjectFactory.getUser('joe', 'joker', 'email1@email.com.invalid', false);
        included.Department = 'dept 1';
        included.Division = 'division 1';
        included.Title = 'title 1';
        included.UserRoleId = testRole.Id;
        included.UserRoleId = testRole.Id;
        User excluded = ObjectFactory.getUser('freddie', 'face', 'email3@email.com.invalid', false);
        insert new List<User>{included, excluded};

        Set<Id> referrersIds = new Set<Id>{included.Id};
        
        List<PM_User> results = sut.getNewReferrers(referrersIds);

        System.assertEquals(1, results.size());
        System.assertEquals(included.Id, results[0].Id);
        System.assertEquals('dept 1', results[0].Department);
        System.assertEquals('division 1', results[0].Division);
        System.assertEquals('email1@email.com.invalid', results[0].EmailAddress);
        System.assertEquals('title 1', results[0].Title);
        System.assertEquals('some role', results[0].UserRole.Name);
    }

    @IsTest
    static void it_should_return_a_list_of_recordTypes_when_given_a_list_of_strings() {
        RecordType sql = ObjectFactory.getRecordTypeObjByNameAndObject('SQL', 'Lead');
        RecordType mql = ObjectFactory.getRecordTypeObjByNameAndObject('MQL', 'Lead');
        RecordType internalReferral = ObjectFactory.getRecordTypeObjByNameAndObject('Internal Referral', 'Lead');

        List<RecordType> results = sut.getRecordTypes();

        System.assertEquals(true, results.contains(sql));
        System.assertEquals(true, results.contains(mql));
        System.assertEquals(true, results.contains(internalReferral));
    }

    @IsTest
    static void it_should_return_a_list_of_new_owners_as_pm_users() {
        UserRole testRole = new UserRole(Name = 'some role');
        insert testRole;
        User included = ObjectFactory.getUser('joe', 'joker', 'email1@email.com.invalid', false);
        included.Department = 'dept 1';
        included.Distribution_Channel__c = 'distribution channel 1';
        included.Division = 'division 1';
        included.Referral_Routing_Team__c = 'referral routing 1';
        included.Title = 'title 1';
        included.UserRoleId = testRole.Id;
        included.IsActive = true;
        User excluded = ObjectFactory.getUser('freddie', 'face', 'fredFace@email.com.invalid', false);
        insert new List<User>{included, excluded};

        List<PM_User> results = sut.getOwners(new Set<Id>{included.Id});

        System.assertEquals(1, results.size());
        System.assertEquals(included.Department, results[0].Department);
        System.assertEquals(included.Distribution_Channel__c, results[0].Distribution_Channel_c);
        System.assertEquals(included.Division, results[0].Division);
        System.assertEquals(included.Email, results[0].EmailAddress);
        System.assertEquals(included.Referral_Routing_Team__c, results[0].Referral_Routing_Team_c);
        System.assertEquals(included.Title, results[0].Title);
        System.assertEquals(testRole.Name, results[0].UserRole.Name);
    }
}