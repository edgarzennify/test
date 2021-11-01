public with sharing class ContactTriggerHandler extends TriggerHandler {

    private final ContactTriggerHandlerDataProvider.IContactTriggerHandlerDataProvider m_dataProvider;
    private final String REFERRAL_SOURCE = 'Referral Source';

    public ContactTriggerHandler() {
        m_dataProvider = new ContactTriggerHandlerDataProvider();
    }

    public ContactTriggerHandler(ContactTriggerHandlerDataProvider.IContactTriggerHandlerDataProvider dataProvider) {
        m_dataProvider = dataProvider;
    }
    
    public override void bulkBeforeInsert(List<SObject> SObjects) {
        Set<Id> parentAccountIds = getParentAccountIds((List<Contact>)SObjects);
        List<Account> ParentAccounts = m_dataProvider.getParentAccounts(parentAccountIds);
        Map<Id, SObject> accountMap = Utility.convertToMap(ParentAccounts);

        for (Contact c : (List<Contact>)SObjects) {
            validateCountryFields(c);
            syncContactOwnerWithAccountOwner(c, accountMap);
        }
    }
    
	private void validateCountryFields(Contact c) {
        if (String.isBlank(c.MailingCountry)) {
            c.MailingCountry = 'US';
        }
    
        if (String.isBlank(c.OtherCountry)) {
            c.OtherCountry = 'US';
        }
    } 

	private Set<Id> getParentAccountIds(List<Contact> contacts) {
        Set<Id> output = new Set<Id>();
        for (Contact c : contacts) {
            if (c.AccountId != null) {
                output.add(c.AccountId);
            }
        }
        return output;
	} 

	private void syncContactOwnerWithAccountOwner(Contact c, Map<Id, SObject > accountMap) {
        if (accountMap.containsKey(c.AccountId)) {
            Account a = (Account)accountMap.get(c.AccountId);
            if (a.RecordType.Name != REFERRAL_SOURCE) {
                c.OwnerId = a.OwnerId;
            }
        }
	} 
}