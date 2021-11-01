@IsTest
private class EbCollateral_InterstitialControllerTests {

    private static final InterstitialMock.ofIObjectForwardManager mockForwardManager;
    private static InterstitialMock.ofIForwardingInfo mockForwardingInfo;
    private static SObject record;
    private static final Mock.ofIStandardController mockStandardController;
    private static final InterstitialMock.ofIEbCollateral_InterstitialDataProvider mockDataProvider;
    private static EbCollateral_InterstitialController sut;
         
    static {
        mockStandardController = new Mock.ofIStandardController();
        mockForwardManager = new InterstitialMock.ofIObjectForwardManager();
        mockDataProvider = new InterstitialMock.ofIEbCollateral_InterstitialDataProvider();
        mockForwardingInfo = null;
        
        List<EB_Collateral__c> testEbColls = new List<EB_Collateral__c>();
        EB_Collateral__c testEbColl = new EB_Collateral__c();
        testEbColl.Id = 'a0a000000000000';
        testEbColl.Name = 'Test Coll Name';
        testEbColls.add(testEbColl);                
        mockDataProvider.setup('getEbCollateralById',ApexMoq.Arguments.HAVE_ANY_VALUE).returns(testEbColls);
        
        mockStandardController.setup('getRecord').returns(testEbColl);            
        
        sut = new EbCollateral_InterstitialController(mockForwardManager, mockForwardingInfo, mockDataProvider, mockStandardController);
    }
    
    @IsTest
    static void it_should_call_the_data_provider_to_getEbCollateralById_when_initializing() {
        mockDataProvider.verify('getEbCollateralById',ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
    }
    
    @IsTest
    static void it_should_call_the_forward_manager_to_getForwardingInfo_when_m_forwardingInfo_is_null() {
        ObjectForward.IForwardingInfo fwdgInfo = sut.forwardingInfo;
        
        mockForwardManager.verify('getForwardingInfo', new List<Object>{'EB_Collateral__c', '*', 'a0a000000000000AAA'}, Times.Once); 
    } 
    
    @IsTest
    static void it_should_call_the_forward_manager_when_redirecting() {
        String testCollId = String.valueOf(sut.ebCollateral.Id);
        ObjectForward.ForwardingInfo f = new ObjectForward.ForwardingInfo();
        mockForwardManager.setup('getForwardingInfo', new List<Object>{'EB_Collateral__c', '*', 'a0a000000000000AAA'}).returns(f);
        
        PageReference result = sut.redirect();
        
        String expectedOrigUrl = '/' + testCollId + '?nooverride=1';
        mockForwardManager.verify('redirect', new List<Object>{f, expectedOrigUrl}, Times.Once);
    }
    
    @IsTest
    static void it_should_return_the_correct_string_when_originalUrl_is_called() {
        String testCollId = String.valueOf(sut.ebCollateral.Id);
        
        String result = sut.originalUrl;
        
        String expected = '/' + testCollId + '?nooverride=1';
        System.assertEquals(expected, result);
    }

    @IsTest
    static void code_coverage() {
        ApexPages.StandardController controller = new ApexPages.StandardController(new EB_Collateral__c());  
        sut = new EbCollateral_InterstitialController(controller);
    }    
}