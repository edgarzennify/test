@IsTest
private class CollateralTriggerHandlerTests {
	
	private static final TriggerHandlerTester tester;	
	private static final CollateralTriggerHandler sut;
	private static final Mock.ofIDataProvider mockDataProv;
	private static final MockOfILLCBI_CollateralAdapter mockAdapter;

	static {
		tester = new TriggerHandlerTester();
		mockDataProv = new Mock.ofIDataProvider();
		mockAdapter = new MockOfILLCBI_CollateralAdapter();
		sut = new CollateralTriggerHandler(mockDataProv, mockAdapter);
	}

	@IsTest
    static void it_should_call_the_default_constructor_without_error() {
		CollateralTriggerHandler sutDef = new CollateralTriggerHandler();
	}

	@IsTest
    static void it_should_get_llcbi_collaterals_from_the_adapter_by_the_given_ebcollateral_name() {
    	String name1 = 'testName';
      	Collateral_Code__c collCode = ObjectFactory.getCollateralCode('test', '9990' );
      	EB_Collateral__c testEbColl1 = ObjectFactory.getCollateral(name1, collCode, true);
    
      	tester.triggerNew.add(testEbColl1);
      	tester.afterTriggerUpdateSequence(sut);

      	mockAdapter.verify('getLLCBICollateralsByName', new List<Object>{new List<String>{name1}}, Times.Once);
    }

    @IsTest
    static void it_should_not_crash_when_the_adapter_returns_no_llcbi_collaterals_with_the_given_name() {
     	String name1 = 'testName';
     	Collateral_Code__c collCode = ObjectFactory.getCollateralCode('test', '9990' );
      	EB_Collateral__c testEbColl1 = ObjectFactory.getCollateral(name1, collCode, true);

      	mockAdapter.setup('getLLCBICollateralsByName', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(null);

      	tester.triggerNew.add(testEbColl1);
      	tester.afterTriggerUpdateSequence(sut);

      	System.assert(true);
    }

    @IsTest
    static void it_should_call_the_isdiff_function_of_the_adapter_by_the_given_collateral_name() {
      	String name1 = 'testName';
     	Collateral_Code__c collCode = ObjectFactory.getCollateralCode('test', '9990' );
      	EB_Collateral__c testEbColl1 = ObjectFactory.getCollateral(name1, collCode, true);

	    Id llcbiId = ObjectFactory.getFakeId(LLC_BI__Collateral__c.SObjectType, '1');
    	LLC_BI__Collateral__c llcbiColl = new LLC_BI__Collateral__c(Id = llcbiId, LLC_BI__Collateral_Name__c = name1, LLC_BI__Value__c = 100.00);

     	mockAdapter.setup('getLLCBICollateralsByName', new List<Object>{new List<String>{name1}}).returns(new List<LLC_BI__Collateral__c>{llcbiColl});
    	mockAdapter.setup('isDifferent', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(false);
    
      	tester.triggerNew.add(testEbColl1);
      	tester.afterTriggerUpdateSequence(sut);

      	mockAdapter.verify('isDifferent', new List<Object>{llcbiColl, testEbColl1}, Times.Once);
    }

    @IsTest
    static void it_should_call_the_update_coll_values_function_of_the_adapter() {
      	String name1 = 'testName';
     	Collateral_Code__c collCode = ObjectFactory.getCollateralCode('test', '9990' );
      	EB_Collateral__c testEbColl1 = ObjectFactory.getCollateral(name1, collCode, true);

	    Id llcbiId = ObjectFactory.getFakeId(LLC_BI__Collateral__c.SObjectType, '1');
    	LLC_BI__Collateral__c llcbiColl = new LLC_BI__Collateral__c(Id = llcbiId, LLC_BI__Collateral_Name__c = name1, LLC_BI__Value__c = 100.00);

	    mockAdapter.setup('getLLCBICollateralsByName', new List<Object>{new List<String>{name1}}).returns(new List<LLC_BI__Collateral__c>{llcbiColl});
    	mockAdapter.setup('isDifferent', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(true);
    
    	tester.triggerNew.add(testEbColl1);
     	tester.afterTriggerUpdateSequence(sut);

    	mockAdapter.verify('updateLLCBICollValues', new List<Object>{llcbiColl, testEbColl1}, Times.Once);
    }

    @IsTest
    static void it_should_call_the_dataprovider_to_save_updated_coll() {
      	String name1 = 'testName';
     	Collateral_Code__c collCode = ObjectFactory.getCollateralCode('test', '9990' );
      	EB_Collateral__c testEbColl1 = ObjectFactory.getCollateral(name1, collCode, true);

	    Id llcbiId = ObjectFactory.getFakeId(LLC_BI__Collateral__c.SObjectType, '1');
    	LLC_BI__Collateral__c llcbiColl = new LLC_BI__Collateral__c(Id = llcbiId, LLC_BI__Collateral_Name__c = name1, LLC_BI__Value__c = 100.00);

     	mockAdapter.setup('getLLCBICollateralsByName', new List<Object>{new List<String>{name1}}).returns(new List<LLC_BI__Collateral__c>{llcbiColl});
    	mockAdapter.setup('isDifferent', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(true);
        mockAdapter.setup('updateLLCBICollValues', new List<Object>{llcbiColl, testEbColl1}).returns(llcbiColl);
    
      	tester.triggerNew.add(testEbColl1);
      	tester.afterTriggerUpdateSequence(sut);

      	mockDataProv.verify('save',new List<Object>{new List<LLC_BI__Collateral__c>{llcbiColl}}, Times.Once);
    }

  	public class MockOfILLCBI_CollateralAdapter extends ApexMoq implements LLCBI_CollateralAdapter.ILLCBI_CollateralAdapter{
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