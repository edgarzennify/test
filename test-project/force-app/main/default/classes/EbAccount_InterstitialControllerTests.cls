@IsTest
private class EbAccount_InterstitialControllerTests {

    private static final InterstitialMock.ofIObjectForwardManager mockForwardManager;
    private static final InterstitialMock.ofIForwardingInfo mockForwardingInfo;
    private static SObject record;
    private static final Mock.ofIStandardController mockStandardController;
    private static final InterstitialMock.ofIEbAccount_InterstitialDataProvider mockDataProvider;
    private static EbAccount_InterstitialController sut;   
    
    static {       
        mockStandardController = new Mock.ofIStandardController();
        mockDataProvider = new InterstitialMock.ofIEbAccount_InterstitialDataProvider();
        mockForwardManager = new InterstitialMock.ofIObjectForwardManager(); 
        mockForwardingInfo = null;
        
        List<EB_Account__c> testEbAccts = new List<EB_Account__c>();
        Eb_Account__c testEbAcct = new Eb_Account__c();
        testEbAcct.Id = 'a02000000000000';    
        testEbAcct.Key__c = '616-15-1234';
        testEbAcct.RecordType = Utility.recordTypeObject('EB_Account__c', 'Loan');
        testEbAccts.add(testEbAcct);        
        mockDataProvider.setup('getEbAccountById',ApexMoq.Arguments.HAVE_ANY_VALUE).returns(testEbAccts);   
        
        mockStandardController.Setup('getRecord').Returns(testEbAcct);

        sut = new EbAccount_InterstitialController(mockForwardingInfo, mockForwardManager, mockDataProvider, mockStandardController);       
    }     
 
    @IsTest
    static void it_should_call_the_data_provider_to_getEbAccountById_when_initializing() {
        mockDataProvider.verify('getEbAccountById', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once); 
    }
    
    @IsTest
    static void it_should_call_the_forward_manager_to_getForwardingInfo_when_m_forwardingInfo_is_null() {
        ObjectForward.IForwardingInfo fwdgInfo = sut.forwardingInfo;
        
        mockForwardManager.verify('getForwardingInfo', new List<Object>{'EB_Account__c','Loan','a02000000000000AAA'}, Times.Once); 
    }
        
    @IsTest
    static void it_should_call_the_forward_manager_when_redirecting() {
        String testEbAcctId = String.valueOf(sut.ebAccount.Id);
        ObjectForward.ForwardingInfo f = new ObjectForward.ForwardingInfo();
        mockForwardManager.setup('getForwardingInfo', new List<Object>{'EB_Account__c','Loan','a02000000000000AAA'}).returns(f);
         
        PageReference result = sut.redirect();
        
        String expectedOrigUrl = '/' + testEbAcctId + '?nooverride=1';
        mockForwardManager.verify('redirect', new List<Object>{f, expectedOrigUrl}, Times.Once);
    }
    
    @IsTest
    static void it_should_return_the_correct_string_when_originalUrl_is_called() {
        String testEbAcctId = String.valueOf(sut.ebAccount.Id);
        
        String result = sut.originalUrl;
        
        String expected = '/' + testEbAcctId + '?nooverride=1';
        System.assertEquals(expected, result);
    }

    @IsTest
    static void code_coverage() {
        ApexPages.StandardController controller = new ApexPages.StandardController(new EB_Account__c());
        sut = new EbAccount_InterstitialController(controller);
    }
}