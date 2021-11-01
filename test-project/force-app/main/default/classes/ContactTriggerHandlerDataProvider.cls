public class ContactTriggerHandlerDataProvider implements IContactTriggerHandlerDataProvider {
    
    public interface IContactTriggerHandlerDataProvider {
        List<Account> getParentAccounts(Set<Id> parentAccountIds);
    }

    public List<Account> getParentAccounts(Set<Id> parentAccountIds) {
        return [    SELECT
                        Id
                        ,RecordType.Name
                        ,OwnerId
                    FROM
                        Account
                    WHERE
                        Id IN :parentAccountIds];
    }
}