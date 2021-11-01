@isTest
public class EbAppraisalOrderTrigHandlerDataProvTests {

    private static EbAppraisalOrderTrigHandlerDataProvider sut;
    
    static{
        sut = new EbAppraisalOrderTrigHandlerDataProvider();
    }
    
    private static testMethod void it_should_getNcinoCollateralsByNameOrKey(){
        LLC_BI__Collateral_Type__c testNcinoCollCode = ObjectFactory.getNcinoCollateralCode('CIA-Owner Occupied', '1234');
        
        LLC_BI__Collateral__c testNcinoColl = new LLC_BI__Collateral__c();
        testNcinoColl.LLC_BI__Collateral_Type__c = testNcinoCollCode.Id;
        testNcinoColl.Sync_Key__c = '616-20-12345';
        testNcinoColl.USPAP_Compliant__c = 'Yes';
        testNcinoColl.FDIC_Valuation_Type__c = 'AVM';
        testNcinoColl.Valuation_Date__c = date.newinstance(2016,3,22);
        testNcinoColl.As_Completed_Value__c = 111.11;
        testNcinoColl.As_Is_Value__c = 2.22;
        testNcinoColl.As_Liquidated_Value__c = 3.33;
        testNcinoColl.As_Stabilized_Value__c = 4.44;
        testNcinoColl.Appraisal_Company_Used__c = 'ABC Co.';
        testNcinoColl.Oasis_Order_Number__c  = '123456789';
        testNcinoColl.Appraised_Value_reviewed__c = 100.00;
        insert testNcinoColl;
        
        List<String> relEbCollNames = new List<String>();
        List<String> relEbCollKeys = new List<String>();
        relEbCollKeys.add('616-20-12345');
            
        List<LLC_BI__Collateral__c> results = sut.getNcinoCollateralsByNameOrKey(relEbCollNames, relEbCollKeys);
        
        List<LLC_BI__Collateral__c> insertedNcinoColl = [SELECT Id, Name FROM LLC_BI__Collateral__c WHERE Id=:testNcinoColl.Id LIMIT 1]; 
        System.assertEquals(1, results.size());
        System.assertEquals(insertedNcinoColl[0].Name, results[0].Name);
        System.assertEquals('616-20-12345', results[0].Sync_Key__c);
        System.assertEquals('Yes', results[0].USPAP_Compliant__c);
        System.assertEquals('AVM', results[0].FDIC_Valuation_Type__c);
        System.assertEquals(date.newinstance(2016,3,22), results[0].Valuation_Date__c);
        System.assertEquals(111.11, results[0].As_Completed_Value__c);
        System.assertEquals(2.22, results[0].As_Is_Value__c);
        System.assertEquals(3.33, results[0].As_Liquidated_Value__c);
        System.assertEquals(4.44, results[0].As_Stabilized_Value__c);
        System.assertEquals('ABC Co.', results[0].Appraisal_Company_Used__c);
        System.assertEquals('123456789', results[0].Oasis_Order_Number__c);
        System.assertEquals(100.00, results[0].Appraised_Value_reviewed__c);        
    }

    private static testMethod void it_should_update_NcinoCollaterals_appraisal_value_fields(){
        LLC_BI__Collateral_Type__c testNcinoCollCode = ObjectFactory.getNcinoCollateralCode('CIA-Owner Occupied', '1234');
        
        List<LLC_BI__Collateral__c> testNcinoColls = new List<LLC_BI__Collateral__c>();
        LLC_BI__Collateral__c testNcinoColl = new LLC_BI__Collateral__c();
        testNcinoColl.LLC_BI__Collateral_Type__c = testNcinoCollCode.Id;
        testNcinoColl.Sync_Key__c = '616-20-12345';
        testNcinoColl.USPAP_Compliant__c = 'Yes';
        testNcinoColl.FDIC_Valuation_Type__c = 'AVM';
        testNcinoColl.As_Is_Value__c = 90.00;
        testNcinoColls.add(testNcinoColl);
        insert testNcinoColls;
        testNcinoColl.As_Is_Value__c = 100.00;
            
        sut.updateNcinoCollateralsAppraisalFields(testNcinoColls);
         
        List<LLC_BI__Collateral__c> updatedNcinoColls = [SELECT Id, Name, As_Is_Value__c FROM LLC_BI__Collateral__c WHERE Id=:testNcinoColl.Id LIMIT 1]; 
        
        System.assertEquals(1, updatedNcinoColls.size());
        System.assertEquals(100.00, updatedNcinoColls[0].As_Is_Value__c);        
    }
   
    private static testMethod void it_should_getRelatedEbCollateralsByIds(){
        List<Id> relEbCollIds = new List<Id>();
        
        EB_Collateral__c relEbColl = new EB_Collateral__c();
        Collateral_Code__c testCollCode = ObjectFactory.getCollateralCode('test', '9990');
        relEbColl.Collateral_Code__c = testCollCode.Id;
        relEbColl.Key__c = '616-20-12345';
        insert relEbColl;
        
        relEbCollIds.add(relEbColl.Id);
        
        List<EB_Collateral__c> results = sut.getRelatedEbCollateralsByIds(relEbCollIds);
        
        System.assertEquals(relEbColl.Id, results[0].Id);
        System.assertEquals('616-20-12345', results[0].Key__c);
    }
     
}