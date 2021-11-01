@IsTest
private class Collateral_PluginControllerTests {

    private static SObject record;
    private static final Mock.ofIStandardController mockStandardController;
    private static Collateral_PluginController sut;
    private final static PluginMock.ofICollateral_PluginDataProvider mockDataProvider;
    
    static {
        mockStandardController = new Mock.ofIStandardController();
        record = (SObject) new LLC_BI__Collateral__c();
        mockStandardController.setup('getRecord').returns(record);
        mockDataProvider = new PluginMock.ofICollateral_PluginDataProvider();
        sut = new Collateral_PluginController(mockDataProvider, mockStandardController);             
    }
     
    @IsTest
    static void it_should_call_the_getEbCollateralByNameOrKey_function_of_data_provider_to_get_eb_collateral() {
        LLC_BI__Collateral__c testNcinoCollateral = new LLC_BI__Collateral__c();
        testNcinoCollateral.Sync_Key__c='key';
        mockDataProvider.setup('getNcinoCollateralById', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(testNcinoCollateral);
        
        List<EB_Collateral__c> retEbColls = new List<EB_Collateral__c>();
        EB_Collateral__c ebColl= ObjectFactory.getCollateral('12345-20', true);
        retEbColls.add(ebColl);
        
        mockDataProvider.setup('getEbCollateralByNameOrKey', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(retEbColls);
        
        EB_Collateral__c result = sut.ebCollateral;
        
        mockDataProvider.verify('getEbCollateralByNameOrKey', new List<Object>{testNcinoCollateral.Name, testNcinoCollateral.Sync_Key__c}, Times.Once);
    }
    
    @IsTest
    static void it_should_assign_the_matching_ebCollateral_returned_from_the_data_provider_to_the_ebCollateral_property() {
        LLC_BI__Collateral__c testLlcBiCollateral = new LLC_BI__Collateral__c();
        testLlcBiCollateral.LLC_BI__Collateral_Name__c = 'TestName';
        testLlcBiCollateral.LLC_BI__Collateral_Type__c = 'a3N180000001Op9';
        mockDataProvider.setup('getNcinoCollateralById', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(testLlcBiCollateral);
        List<EB_Collateral__c> retEbColls = new List<EB_Collateral__c>();
        EB_Collateral__c retEbColl = new EB_Collateral__c();
        retEbColl.Name = 'TestName';
        retEbColls.add(retEbColl);
        mockDataProvider.setup('getEbCollateralByNameOrKey', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(retEbColls);
        
        EB_Collateral__c result = sut.ebCollateral;
        
        System.assertEquals('TestName', result.Name);
    }
    
    @IsTest
    static void code_coverage_test_framework_constructor() {
        Collateral_PluginController s = new Collateral_PluginController(null);      
    }    
}