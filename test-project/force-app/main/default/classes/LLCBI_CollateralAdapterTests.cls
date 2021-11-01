@isTest
public class LLCBI_CollateralAdapterTests {
 private static LLCBI_CollateralAdapter sut;
    
    static {
        sut = new LLCBI_CollateralAdapter();
    }
    
    private static testMethod void it_should_return_ebcollateral_by_name(){
        String name1 = '';
        String name2 = 'testName';
        Collateral_Code__c collCode = ObjectFactory.getCollateralCode('test', '9990' );
        EB_Collateral__c testEbColl1 = ObjectFactory.getCollateral(name1, collCode, true);
        EB_Collateral__c testEbColl2 = ObjectFactory.getCollateral(name2, collCode, true);
                
        List<EB_Collateral__c> results = sut.getEBCollateralsByName(new List<String>{name1, name2});
            
        System.assertEquals(1, results.size());  
        System.assertEquals(testEbColl2.Id, results[0].Id); 
    }
    
    private static testMethod void it_should_return_false_when_fields_are_equal(){
        datetime dT = system.now();
        Date d = date.newinstance(dT.year(), dT.month(), dT.day());

        EB_Collateral__c testEbColl = new EB_Collateral__c();
        Collateral_Code__c CollateralCode = ObjectFactory.getCollateralCode('test', '9990' );
        testEbColl = ObjectFactory.getCollateral('TestCollName', CollateralCode, true);
        testEbColl.Market_Value__c = 100.00;
        testEbColl.Comments__c = '';
        testEbColl.Advance_Rate__c = 25;
        testEbColl.Non_RE_Valuation_Date__c = d;
        testEbColl.Existing_Debt__c = 100.00;

        LLC_BI__Collateral__c testLLCBIColl = new LLC_BI__Collateral__c();
        testLLCBIColl.LLC_BI__Value__c=100.00;
        testLLCBIColl.Comments__c = '';
        testLLCBIColl.Actual_Advance_Rate__c = 25;
        testLLCBIColl.Non_RE_Valuation_Date__c =d;
        testLLCBIColl.Existing_Debt__c = 100.00;

        Boolean result = sut.isDifferent(testLLCBIColl,testEbColl);

        System.assertEquals(false, result);
     }
    private static testMethod void it_should_return_true_when_at_least_one_field_is_not_equal(){
        datetime dT = system.now();
        Date d = date.newinstance(dT.year(), dT.month(), dT.day());

        EB_Collateral__c testEbColl = new EB_Collateral__c();
        Collateral_Code__c CollateralCode = ObjectFactory.getCollateralCode('test', '9990' );
        testEbColl = ObjectFactory.getCollateral('TestCollName', CollateralCode, true);
        testEbColl.Market_Value__c = 50.00;
        testEbColl.Comments__c = '';
        testEbColl.Advance_Rate__c = 25;
        testEbColl.Non_RE_Valuation_Date__c = d;
        testEbColl.Existing_Debt__c = 100.00;

        LLC_BI__Collateral__c testLLCBIColl = new LLC_BI__Collateral__c();
        testLLCBIColl.LLC_BI__Value__c=100.00;
        testLLCBIColl.Comments__c = '';
        testLLCBIColl.Actual_Advance_Rate__c = 25;
        testLLCBIColl.Non_RE_Valuation_Date__c =d;
        testLLCBIColl.Existing_Debt__c = 100.00;

        Boolean result = sut.isDifferent(testLLCBIColl,testEbColl);

        System.assertEquals(true, result);
     }

    private static testMethod void it_should_return_eb_collateral_updated_when_function_is_called(){
        datetime dT = system.now();
        Date d = date.newinstance(dT.year(), dT.month(), dT.day());

        EB_Collateral__c testEbColl = new EB_Collateral__c();
        testEbColl.Market_Value__c = 50.00;
        testEbColl.Comments__c = '';
        testEbColl.Advance_Rate__c = 25;
        testEbColl.Non_RE_Valuation_Date__c = d;
        testEbColl.Existing_Debt__c = 100.00;

        LLC_BI__Collateral__c testLLCBIColl = new LLC_BI__Collateral__c();
        testLLCBIColl.LLC_BI__Value__c=100.00;
        testLLCBIColl.Comments__c = '';
        testLLCBIColl.Actual_Advance_Rate__c = 25;
        testLLCBIColl.Non_RE_Valuation_Date__c =d;
        testLLCBIColl.Existing_Debt__c = 100.00;

        EB_Collateral__c result = sut.updateEbCollValues(testEbColl, testLLCBIColl);

        System.assertEquals(100.00, result.Market_Value__c);
     }

     private static testMethod void it_should_return_llcbi_collateral_updated_when_function_is_called(){
        datetime dT = system.now();
        Date d = date.newinstance(dT.year(), dT.month(), dT.day());

        LLC_BI__Collateral__c testLLCBIColl = new LLC_BI__Collateral__c();
        testLLCBIColl.LLC_BI__Value__c=100.00;
        testLLCBIColl.Comments__c = '';
        testLLCBIColl.Actual_Advance_Rate__c = 25;
        testLLCBIColl.Non_RE_Valuation_Date__c =d;
        testLLCBIColl.Existing_Debt__c = 100.00;

        EB_Collateral__c testEbColl = new EB_Collateral__c();
        testEbColl.Market_Value__c = 50.00;
        testEbColl.Comments__c = '';
        testEbColl.Advance_Rate__c = 25;
        testEbColl.Non_RE_Valuation_Date__c = d;
        testEbColl.Existing_Debt__c = 100.00;

        LLC_BI__Collateral__c result = sut.updateLLCBICollValues(testLLCBIColl,testEbColl);
        
        System.assertEquals(50.00, result.LLC_BI__Value__c);
     }

     private static testMethod void it_should_return_llcbi_collateral_by_name(){
        String name1 = '';
        String name2 = 'testName';
        LLC_BI__Collateral_Type__c collType = new LLC_BI__Collateral_Type__c();
        insert collType;
        LLC_BI__Collateral__c llcbiColl1 = new LLC_BI__Collateral__c(LLC_BI__Collateral_Name__c = name1,LLC_BI__Collateral_Type__c = collType.Id );
        LLC_BI__Collateral__c llcbiColl2 = new LLC_BI__Collateral__c(LLC_BI__Collateral_Name__c = name2,LLC_BI__Collateral_Type__c = collType.Id );
        insert new List<LLC_BI__Collateral__c>{llcbiColl1,llcbiColl2};
              
        List<LLC_BI__Collateral__c> results = sut.getLLCBICollateralsByName(new List<String>{name1, name2});
            
        System.assertEquals(1, results.size());  
        System.assertEquals(llcbiColl2.Id, results[0].Id); 
    }

    private static testMethod void it_should_return_all_ebcollateral_fields(){
        String name1 = 'testName';
        Collateral_Code__c collCode = ObjectFactory.getCollateralCode('test', '9990' );
        EB_Collateral__c testEbColl1 = ObjectFactory.getCollateral(name1, collCode, true);
                       
        List<EB_Collateral__c> results = sut.getEBCollateralsByName(new List<String>{name1});

        Object fieldObject;
        fieldObject = results[0].Id;
        fieldObject = results[0].Name;
        fieldObject = results[0].Comments__c;
        fieldObject = results[0].Advance_Rate__c;
        fieldObject = results[0].Market_Value__c;
        fieldObject = results[0].Non_RE_Valuation_Date__c;
        fieldObject = results[0].Existing_Debt__c;  
    }

    private static testMethod void it_should_return_all_llcbi_collateral_fields(){
        String name1 = 'testName';
        LLC_BI__Collateral_Type__c collType = new LLC_BI__Collateral_Type__c();
        insert collType;
        LLC_BI__Collateral__c llcbiColl1 = new LLC_BI__Collateral__c(LLC_BI__Collateral_Name__c = name1,LLC_BI__Collateral_Type__c = collType.Id );
        insert new List<LLC_BI__Collateral__c>{llcbiColl1};
              
        List<LLC_BI__Collateral__c> results = sut.getLLCBICollateralsByName(new List<String>{name1});

        Object fieldObject;
        fieldObject = results[0].Id;
        fieldObject = results[0].LLC_BI__Collateral_Name__c;
        fieldObject = results[0].Comments__c;
        fieldObject = results[0].Actual_Advance_Rate__c;
        fieldObject = results[0].LLC_BI__Value__c;
        fieldObject = results[0].Non_RE_Valuation_Date__c;
        fieldObject = results[0].Existing_Debt__c;  
    }
}