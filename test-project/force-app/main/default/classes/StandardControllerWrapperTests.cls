@IsTest
private class StandardControllerWrapperTests {
    
    private final static StandardControllerWrapper sut;
    private static Account testAccount;

    static {
        testAccount = new Account(Name='test name');
        insert testAccount;
        ApexPages.StandardController controller = new ApexPages.StandardController(testAccount);
        sut = new StandardControllerWrapper(controller);
    }

    private static testMethod void it_should_get_the_controller_sobject() {

        SObject result = sut.getRecord();

        System.assertEquals(Account.SObjectType, result.getSObjectType());
    }

    private static testMethod void it_should_get_the_id_from_the_controller() {

        Id sobjectId = sut.getId();

        System.assertEquals(testAccount.Id, sobjectId);
    }
}