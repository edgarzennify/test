@isTest
public class EntityActionDataProviderTests {
    private static final EntityActionDataProvider sut;
    static {
        sut = new EntityActionDataProvider();
    }
    
    private static testMethod void it_should_call_the_save_method_successfully(){
        Account acct = new Account();
        acct.Name = 'test Account';
        insert acct;
        Entity_Action__c eAction = new Entity_Action__c();
        eAction.Entity__c = acct.Id;
        List<SObject> objs = new List<SObject>{eAction};
        sut.save(objs);
    }

}