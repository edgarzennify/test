@IsTest
private class LLCBI_CollateralTriggerHandlerTests {
    private static LLCBI_CollateralTriggerHandler sut;
    private static TriggerHandlerTester tester;
    private static Mock.ofIDataProvider mockDataProvider;
    private static MockOfILLCBI_CollateralAdapter mockAdapter;

    static {
        mockDataProvider = new Mock.ofIDataProvider();
        mockAdapter= new MockOfILLCBI_CollateralAdapter();
        sut = new LLCBI_CollateralTriggerHandler(mockDataProvider, mockAdapter);    
    }

    @IsTest
    static void it_should_get_eb_collaterals_from_the_adapter_by_the_given_collateral_name() {
        Id llcbiId = ObjectFactory.getFakeId(LLC_BI__Collateral__c.SObjectType, '1');
        String llcbiName = 'test1';
        LLC_BI__Collateral__c llcbi = new LLC_BI__Collateral__c(Id = llcbiId, LLC_BI__Collateral_Name__c = llcbiName);

        tester = new TriggerHandlerTester();
        tester.triggerNew.add(llcbi);
        tester.afterTriggerUpdateSequence(sut);

        mockAdapter.verify('getEBCollateralsByName', new List<Object>{new List<String>{llcbiName}}, Times.Once);
    }

    @IsTest
    static void it_should_not_crash_when_the_adapter_returns_no_eb_collaterals_with_the_given_name() {
        Id llcbiId = ObjectFactory.getFakeId(LLC_BI__Collateral__c.SObjectType, '1');
        String llcbiName = 'test1';
        LLC_BI__Collateral__c llcbi = new LLC_BI__Collateral__c(Id = llcbiId, LLC_BI__Collateral_Name__c = llcbiName);
        mockAdapter.setup('getEBCollateralsByName', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(null);

        tester = new TriggerHandlerTester();
        tester.triggerNew.add(llcbi);
        tester.afterTriggerUpdateSequence(sut);

        System.assert(true);
    }

    @IsTest
    static void it_should_call_the_isDifferent_function_of_the_adapter_by_the_given_collateral_name() {
        Id llcbiId = ObjectFactory.getFakeId(LLC_BI__Collateral__c.SObjectType, '1');
        String llcbiName = 'test1';
        LLC_BI__Collateral__c llcbi = new LLC_BI__Collateral__c(Id = llcbiId, LLC_BI__Collateral_Name__c = llcbiName, LLC_BI__Value__c = 100.00);

        Id ebId = ObjectFactory.getFakeId(EB_Collateral__c.SObjectType, '1');
        EB_Collateral__c testEbColl = new EB_Collateral__c(Id = ebId, Name = llcbiName ,Market_Value__c = 100.00 );

        mockAdapter.setup('getEBCollateralsByName', new List<Object>{new List<String>{llcbiName}}).returns(new List<EB_Collateral__c>{testEbColl});
        mockAdapter.setup('isDifferent', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(false);
        
        tester = new TriggerHandlerTester();
        tester.triggerNew.add(llcbi);
        tester.afterTriggerUpdateSequence(sut);

        mockAdapter.verify('isDifferent', new List<Object>{llcbi, testEbColl}, Times.Once);
    }

    @IsTest
    static void it_should_call_the_update_coll_values_function_of_the_adapter() {
        Id llcbiId = ObjectFactory.getFakeId(LLC_BI__Collateral__c.SObjectType, '1');
        String llcbiName = 'test1';
        LLC_BI__Collateral__c llcbi = new LLC_BI__Collateral__c(Id = llcbiId, LLC_BI__Collateral_Name__c = llcbiName, LLC_BI__Value__c = 100.00);

        Id ebId = ObjectFactory.getFakeId(EB_Collateral__c.SObjectType, '1');
        EB_Collateral__c testEbColl = new EB_Collateral__c(Id = ebId, Name = llcbiName ,Market_Value__c = 100.00 );

        mockAdapter.setup('getEBCollateralsByName', new List<Object>{new List<String>{llcbiName}}).returns(new List<EB_Collateral__c>{testEbColl});
        mockAdapter.setup('isDifferent', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(true);
        
        tester = new TriggerHandlerTester();
        tester.triggerNew.add(llcbi);
        tester.afterTriggerUpdateSequence(sut);

        mockAdapter.verify('updateEbCollValues', new List<Object>{testEbColl, llcbi}, Times.Once);
    }

    @IsTest
    static void it_should_call_the_dataprovider_to_save_updated_coll() {
        Id llcbiId = ObjectFactory.getFakeId(LLC_BI__Collateral__c.SObjectType, '1');
        String llcbiName = 'test1';
        LLC_BI__Collateral__c llcbi = new LLC_BI__Collateral__c(Id = llcbiId, LLC_BI__Collateral_Name__c = llcbiName, LLC_BI__Value__c = 100.00);

        Id ebId = ObjectFactory.getFakeId(EB_Collateral__c.SObjectType, '1');
        EB_Collateral__c testEbColl = new EB_Collateral__c(Id = ebId, Name = llcbiName ,Market_Value__c = 100.00 );

        mockAdapter.setup('getEBCollateralsByName', new List<Object>{new List<String>{llcbiName}}).returns(new List<EB_Collateral__c>{testEbColl});
        mockAdapter.setup('isDifferent', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(true);
        mockAdapter.setup('updateEbCollValues',  ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(testEbColl);
        
        tester = new TriggerHandlerTester();
        tester.triggerNew.add(llcbi);
        tester.afterTriggerUpdateSequence(sut);

        mockDataProvider.verify('save',new List<Object>{new List<EB_Collateral__c>{testEbColl}}, Times.Once);
    }

    public class MockOfILLCBI_CollateralAdapter extends ApexMoq implements LLCBI_CollateralAdapter.ILLCBI_CollateralAdapter {
        public Boolean isDifferent(LLC_BI__Collateral__c llcbiColl, EB_Collateral__c ebCollateral){
            return (Boolean) handleMethodInvocation('isDifferent', new List<Object>{llcbiColl,ebCollateral});
        }
        public EB_Collateral__c updateEbCollValues(EB_Collateral__c ebCollateral, LLC_BI__Collateral__c llcbiColl){
            return (EB_Collateral__c)handleMethodInvocation('updateEbCollValues', new List<Object>{ebCollateral,llcbiColl});
        }
        public LLC_BI__Collateral__c updateLLCBICollValues(LLC_BI__Collateral__c llcbiColl, EB_Collateral__c ebCollateral){
            return (LLC_BI__Collateral__c)handleMethodInvocation('updateLLCBICollValues', new List<Object>{llcbiColl,ebCollateral});
        }
        public List<EB_Collateral__c> getEBCollateralsByName(List<String> llcbiCollNames){
            return (List<EB_Collateral__c>)handleMethodInvocation('getEBCollateralsByName', new List<Object>{llcbiCollNames});
        }
        public List<LLC_BI__Collateral__c> getLLCBICollateralsByName(List<String> ebCollateralNames){
            return (List<LLC_BI__Collateral__c>)handleMethodInvocation('getLLCBICollateralsByName', new List<Object>{ebCollateralNames});
        }
    }
}