@IsTest
private class ContactTriggerHandlerDataProviderTests {
    
    private static final ContactTriggerHandlerDataProvider sut;

    static {
        sut = new ContactTriggerHandlerDataProvider();
    }

    @IsTest
    static void it_should_retrieve_parent_accounts_when_given_a_set_of_ids() {
        RecordType accRecordType = ObjectFactory.getRecordTypeObjByNameAndObject('Prospect', 'Account');
        User ownerUser = ObjectFactory.getUser('firstName', 'lastName', 'asdfghjkl@enterprisebank.com.invalid', true);
        
        Account acc1 = new Account(
            RecordType = accRecordType,
            Owner = ownerUser,
            Name = 'acc1 name'
        );
        Account acc2 = new Account(
            RecordType = accRecordType,
            Owner = ownerUser,
            Name = 'acc2 name'
        );
        insert new List<Account>{acc1, acc2};
        
        Set<Id> parentAccountIds = new Set<Id>{acc1.Id, acc2.Id};

        List<Account> results = sut.getParentAccounts(parentAccountIds);

        System.assertEquals(2, results.size());
        Account returnedAcc = results[0];
        Object fieldInResult = returnedAcc.Id;
        fieldInResult = returnedAcc.RecordType.Name;
        fieldInResult = returnedAcc.OwnerId;   
    }
}