@IsTest
private class EbAppraisalOrderTriggerHandlerTests {

    private static EbAppraisalOrderTriggerHandler sut;
    private static TriggerHandlerTester tester;
    private static final MockOfIEbAppraisalOrderTrigHandlerDataProv mockDataProvider;
    private static final List<EB_Collateral__c> ebColls;
    private static final List<String> ebCollNames;
    private static final List<String> ebCollKeys;
    
    static {
        tester = new TriggerHandlerTester();
        mockDataProvider = new MockOfIEbAppraisalOrderTrigHandlerDataProv();
        sut = new EbAppraisalOrderTriggerHandler(mockDataProvider);  
        
        ebColls = new List<EB_Collateral__c>();
        EB_Collateral__c ebColl = new EB_Collateral__c();
        ebColl.Name = '12345-20';
        ebColl.Key__c = '616-20-12345';
        ebColls.add(ebColl);
        mockDataProvider.setup('getRelatedEbCollateralsByIds', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(ebColls);
    
        ebCollNames = new List<String>();
        ebCollNames.add(ebColl.Name);
        ebCollKeys = new List<String>();
        ebCollKeys.add(ebColl.Key__c);
        
        List<LLC_BI__Collateral__c> returnedNcinoColls = new List<LLC_BI__Collateral__c>();
        mockDataProvider.Setup('getNcinoCollateralsByNameOrKey', ApexMoq.Arguments.HAVE_ANY_VALUE).Returns(returnedNcinoColls);
    }
    
    @IsTest
    static void it_should_call_the_data_provider_to_getRelatedEbCollateralsByIds_after_update() {
        EB_Appraisal_Order__c apprOrdr = new EB_Appraisal_Order__c();
        apprOrdr.Related_Collateral__r = ebColls[0];
        tester.triggerOld.add(apprOrdr);
        tester.triggerNew.add(apprOrdr);        
        
        tester.afterTriggerUpdateSequence(sut);

        mockDataProvider.verify('getRelatedEbCollateralsByIds', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
    }
    
    @IsTest
    static void it_should_call_the_data_provider_to_getNcinoCollateralsByNameOrKey_after_update_matching_ncino_by_key() {
        EB_Appraisal_Order__c apprOrdr = new EB_Appraisal_Order__c();
        apprOrdr.Related_Collateral__r = ebColls[0];
        tester.triggerOld.add(apprOrdr);
        tester.triggerNew.add(apprOrdr);
              
        tester.afterTriggerUpdateSequence(sut);
        
        mockDataProvider.verify('getNcinoCollateralsByNameOrKey', new List<Object>{ebCollNames, ebCollKeys}, Times.Once);        
    }
    
    @IsTest
    static void it_should_fill_the_ncinoColl_Appraisal_value_fields_after_update() {
        EB_Appraisal_Order__c preApprOrdr = new EB_Appraisal_Order__c();
        preApprOrdr.Related_Collateral__r = ebColls[0];
        
        preApprOrdr.USPAP_Compliant__c = 'Yes';
        preApprOrdr.FDIC_Valuation_Type__c = 'AVM';
        preApprOrdr.Valuation_Date__c = date.newinstance(2016,3,22);
        preApprOrdr.As_Completed_Value__c = 0.00;
        preApprOrdr.As_Is_Value__c = 0.00;
        preApprOrdr.As_Liquidated_Value__c = 0.00;
        preApprOrdr.As_Stabilized_Value__c = 0.00;
        preApprOrdr.Appraisal_Company_Used__c = 'ABC Co.';
        preApprOrdr.Oasis_Order_Number__c  = '123456789';
        preApprOrdr.Appraised_Value_reviewed__c = 0.00;
        
        EB_Appraisal_Order__c postApprOrdr = new EB_Appraisal_Order__c();
        postApprOrdr.Related_Collateral__r = ebColls[0];
        postApprOrdr.USPAP_Compliant__c = 'Yes';
        postApprOrdr.FDIC_Valuation_Type__c = 'AVM';
        postApprOrdr.Valuation_Date__c = date.newinstance(2016,3,22);
        postApprOrdr.As_Completed_Value__c = 111.11;
        postApprOrdr.As_Is_Value__c = 2.22;
        postApprOrdr.As_Liquidated_Value__c = 3.33;
        postApprOrdr.As_Stabilized_Value__c = 4.44;
        postApprOrdr.Appraisal_Company_Used__c = 'ABC Co.';
        postApprOrdr.Oasis_Order_Number__c  = '123456789';
        postApprOrdr.Appraised_Value_reviewed__c = 100.00;
               
        tester.triggerOld.add(preApprOrdr);
        tester.triggerNew.add(postApprOrdr);
        
        List<LLC_BI__Collateral__c> testNcinoColls = new List<LLC_BI__Collateral__c>();
        LLC_BI__Collateral__c testNcinoColl = new LLC_BI__Collateral__c();
        testNcinoColl.Sync_Key__c = '616-20-12345';
        testNcinoColls.add(testNcinoColl);
        mockDataProvider.setup('getNcinoCollateralsByNameOrKey', new List<Object>{ebCollNames, ebCollKeys}).returns(testNcinoColls);
        
        tester.afterTriggerUpdateSequence(sut);       
        
        List<Object> arguments = (List<Object>)mockDataProvider.getArgumentsFromCall('updateNcinoCollateralsAppraisalFields');
        List<LLC_BI__Collateral__c> toUpdateNcinoCollaterals = (List<LLC_BI__Collateral__c>)arguments[0];
        System.assertEquals('Yes', toUpdateNcinoCollaterals[0].USPAP_Compliant__c);
        System.assertEquals('AVM', toUpdateNcinoCollaterals[0].FDIC_Valuation_Type__c);
        System.assertEquals(date.newinstance(2016,3,22), toUpdateNcinoCollaterals[0].Valuation_Date__c);
        System.assertEquals(111.11, toUpdateNcinoCollaterals[0].As_Completed_Value__c);
        System.assertEquals(2.22, toUpdateNcinoCollaterals[0].As_Is_Value__c);
        System.assertEquals(3.33, toUpdateNcinoCollaterals[0].As_Liquidated_Value__c);
        System.assertEquals(4.44, toUpdateNcinoCollaterals[0].As_Stabilized_Value__c);
        System.assertEquals('ABC Co.', toUpdateNcinoCollaterals[0].Appraisal_Company_Used__c);
        System.assertEquals('123456789', toUpdateNcinoCollaterals[0].Oasis_Order_Number__c);
        System.assertEquals(100.00, toUpdateNcinoCollaterals[0].Appraised_Value_reviewed__c); 
    }
    
    @IsTest
    static void it_should_call_default_constructor_without_error() {
        EbAppraisalOrderTriggerHandler sutDef = new EbAppraisalOrderTriggerHandler();
    }

    @IsTest
    static void it_should_not_error_on_integration() {
        EB_Appraisal_Order__c apprOrdr = new EB_Appraisal_Order__c();
        insert apprOrdr;
    }

    @IsTest
    static void it_should_not_error_on_typical_sequence() {
        EB_Appraisal_Order__c apprOrdr = new EB_Appraisal_Order__c();
        tester.triggerOld.add(apprOrdr);
        tester.triggerNew.add(apprOrdr);
        tester.beforeTriggerInsertSequence(sut);
        tester.beforeTriggerUpdateSequence(sut);
        tester.beforeTriggerDeleteSequence(sut);
        tester.afterTriggerInsertSequence(sut);
        tester.afterTriggerDeleteSequence(sut);
    }
    
    public class MockOfIEbAppraisalOrderTrigHandlerDataProv extends ApexMoq implements EbAppraisalOrderTriggerHandler.IEbAppraisalOrderTrigHandlerDataProv {
        public List<EB_Collateral__c> getRelatedEbCollateralsByIds(List<Id> relEbCollIds){
            return (List<EB_Collateral__c>)handleMethodInvocation('getRelatedEbCollateralsByIds', new List<Object>{relEbCollIds});
        }        
        public List<LLC_BI__Collateral__c> getNcinoCollateralsByNameOrKey(List<String> relEbCollNames, List<String> relEbCollKeys){
            return (List<LLC_BI__Collateral__c>)handleMethodInvocation('getNcinoCollateralsByNameOrKey', new List<Object>{relEbCollNames, relEbCollKeys});
        }                
        public void updateNcinoCollateralsAppraisalFields(List<LLC_BI__Collateral__c> nCinoColls){
            handleMethodInvocation('updateNcinoCollateralsAppraisalFields', new List<Object>{nCinoColls});
        }               
    } 
}