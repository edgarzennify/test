@IsTest
private class EbtDocManagerPluginManagerTests {
	private final static EbtDocManagerMock.ofIPlugin mockPluginLoan;
    private final static EbtDocManagerMock.ofIPlugin mockPluginDeposit;
    private final static EbtDocManagerPluginManager sut;
    
    static {
        mockPluginDeposit = new EbtDocManagerMock.ofIPlugin();
        mockPluginLoan = new EbtDocManagerMock.ofIPlugin();
        List<EbtDocManager.IPlugin> mockPlugins = new List<EbtDocManager.IPlugin>{
            mockPluginDeposit,
        	mockPluginLoan
        };
        sut = new EbtDocManagerPluginManager(mockPlugins);
    }
    
    @IsTest
    static void it_should_get_the_plugin_loan_when_objectId_is_of_type_loan() {
        Id objectId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType,'2');
        mockPluginDeposit.setup('getSObjectTypeHandled').returns(Account.SObjectType);
        mockPluginLoan.setup('getSObjectTypeHandled').returns(LLC_BI__Loan__c.SObjectType);
        
        sut.getPluginByObjectId(objectId);
        
        mockPluginLoan.verify('getSObjectTypeHandled', Times.Once);
    }
    
    @IsTest
    static void it_should_throw_an_exception_when_no_plugin_matches_the_objectId() {
        Id objectId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType,'2');
        mockPluginDeposit.setup('getSObjectTypeHandled').returns(Account.SObjectType);
        mockPluginLoan.setup('getSObjectTypeHandled').returns(Account.SObjectType);
        
        try {
        	sut.getPluginByObjectId(objectId);
            System.assert(false);
        } catch (EbtDocManagerPluginManager.PluginNotFoundException ex1) {
            System.Assert(true);
        } catch (Exception ex2) {
            System.assert(false);
        }
        
        mockPluginDeposit.verify('getSObjectTypeHandled', Times.Once);
        mockPluginLoan.verify('getSObjectTypeHandled', Times.Once);
    }
}