@IsTest
private class ContactTriggerHandlerTests {
    
    private static final TriggerHandlerTester tester;
    private static final ContactTriggerHandler sut;
    private static final MockOfIContactTriggerDataProvider mockDataProvider;

    static {
        tester = new TriggerHandlerTester();
        mockDataProvider = new MockOfIContactTriggerDataProvider();
        sut = new ContactTriggerHandler(mockDataProvider);
    }

    @IsTest
	static void it_should_update_the_mailing_country_field_if_it_is_empty_or_null_when_bulkBeforeInsert(){
		Contact testContact = new Contact(MailingCountry = null);
        tester.triggerOld.add(testContact);
        
        mockDataProvider
            .setup('getParentAccounts', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE)
            .returns(new List<Account>());

		tester.beforeTriggerInsertSequence(sut);

		System.assertEquals('US', testContact.MailingCountry);
	}

	@IsTest
	static void it_should_not_update_the_mailing_country_field_if_it_contains_a_value_when_bulkBeforeInsert(){
		Contact testContact = new Contact(MailingCountry = 'some country');
        tester.triggerOld.add(testContact);
        
        mockDataProvider
            .setup('getParentAccounts', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE)
            .returns(new List<Account>());

		tester.beforeTriggerInsertSequence(sut);

		System.assertEquals('some country', testContact.MailingCountry);
	}

	@IsTest
	static void it_should_update_the_other_country_field_if_it_is_empty_or_null_when_bulkBeforeInsert(){
		Contact testContact = new Contact(OtherCountry = null);
        tester.triggerOld.add(testContact);
        
        mockDataProvider
            .setup('getParentAccounts', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE)
            .returns(new List<Account>());

		tester.beforeTriggerInsertSequence(sut);

		System.assertEquals('US', testContact.OtherCountry);
	}

	@IsTest
	static void it_should_not_update_the_other_country_field_if_it_contains_a_value_when_bulkBeforeInsert(){
		Contact testContact = new Contact(OtherCountry = 'some country');
        tester.triggerOld.add(testContact);
        
        mockDataProvider
            .setup('getParentAccounts', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE)
            .returns(new List<Account>());

		tester.beforeTriggerInsertSequence(sut);

		System.assertEquals('some country', testContact.OtherCountry);
	}

	@IsTest
	static void it_should_only_update_the_empty_country_field_when_one_has_a_value_and_one_does_not_during_bulkBeforeInsert() {
		Contact testContact = new Contact(
            OtherCountry = 'some country',
            MailingCountry = null
        );
        tester.triggerOld.add(testContact);
        
        mockDataProvider
            .setup('getParentAccounts', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE)
            .returns(new List<Account>());

		tester.beforeTriggerInsertSequence(sut);

		System.assertEquals('some country', testContact.OtherCountry);
		System.assertEquals('US', testContact.MailingCountry);
    }

    @IsTest
    static void it_should_set_the_contact_owner_to_the_owner_of_the_contacts_account_bulkBeforeInsert() {
        Id accountId = ObjectFactory.getFakeId(Account.SObjectType, '1');
        Set<Id> parentAccountIds = new Set<Id>{accountId};
        
        Contact testContact = new Contact(AccountId = accountId);
        tester.triggerOld.add(testContact);
        
        Account acc1 = new Account(
            Id = accountId,
            OwnerId = ObjectFactory.getFakeId(User.SObjectType, '1')
        );
        List<Account> parentAccounts = new List<Account>{acc1};
        
        mockDataProvider
            .setup('getParentAccounts', new List<Object>{parentAccountIds})
            .returns(parentAccounts);

        tester.beforeTriggerInsertSequence(sut);

        System.assertEquals(acc1.OwnerId, testContact.OwnerId);    
    }

    @IsTest
    static void it_should_not_set_the_contact_owner_to_the_owner_of_the_contacts_account_when_account_recordType_is_referral_source_bulkBeforeInsert() {
        Id accountId = ObjectFactory.getFakeId(Account.SObjectType, '1');
        Id contactOwnerId = ObjectFactory.getFakeId(User.SObjectType, '1');
        Set<Id> parentAccountIds = new Set<Id>{accountId};
        
        Contact testContact = new Contact(
            AccountId = accountId,
            OwnerId = contactOwnerId
        );
        tester.triggerOld.add(testContact);
        
        RecordType accRecordType = ObjectFactory.getRecordTypeObjByNameAndObject('Referral Source', 'Account');
        
        Account acc1 = new Account(
            Id = accountId,
            RecordType = accRecordType,
            OwnerId = ObjectFactory.getFakeId(User.SObjectType, '2')
        );
        List<Account> parentAccounts = new List<Account>{acc1};
        
        mockDataProvider
            .setup('getParentAccounts', new List<Object>{parentAccountIds})
            .returns(parentAccounts);

        tester.beforeTriggerInsertSequence(sut);

        System.assertNotEquals(acc1.OwnerId, testContact.OwnerId);
        System.assertEquals(contactOwnerId, testContact.OwnerId);
    }

    @IsTest
    static void it_should_not_update_the_contact_ownerId_field_when_there_is_not_related_account_bulkBeforeInsert() {
        Id contactOwnerId = ObjectFactory.getFakeId(User.SObjectType, '1');
        Set<Id> parentAccountIds = new Set<Id>();
        
        Contact testContact = new Contact(OwnerId = contactOwnerId);
        tester.triggerOld.add(testContact);

        List<Account> parentAccounts = new List<Account>{};
        
        mockDataProvider
            .setup('getParentAccounts', new List<Object>{parentAccountIds})
            .returns(parentAccounts);

        tester.beforeTriggerInsertSequence(sut);

        System.assertEquals(contactOwnerId, testContact.OwnerId);
    }

    //@IsTest
    //Uncomment the decorator above to run this test - JELLISON
    static void INTEGRATION_it_should_update_the_contact_ownerId_field_when_the_contact_creator_is_not_the_owner_of_the_contacts_account_bulkBeforeInsert() {
        User newOwner = ObjectFactory.getUser('firstName', 'lastName', 'email@enterprisebank.com.invalid', true);
        Account testAccount = new Account(
            Name = 'Test Name',
            Owner = newOwner
        );
        insert testAccount;

        Contact testContact = new Contact(
            Account = testAccount,
            AccountId = testAccount.Id,
            LastName = 'foo'
        );
        insert testContact;

        System.assertEquals(testAccount.OwnerId, testContact.OwnerId);
    }
///////////////////////////////////////////////////////////////////////////////
    private class MockOfIContactTriggerDataProvider extends ApexMoq implements ContactTriggerHandlerDataProvider.IContactTriggerHandlerDataProvider {
        public List<Account> getParentAccounts(Set<Id> parentAccountIds){
            return (List<Account>)handleMethodInvocation('getParentAccounts', new List<Object>{parentAccountIds});
        }
    }
}