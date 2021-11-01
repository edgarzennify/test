@isTest
public class Collateral_PluginDataProviderTests {

    private static Collateral_PluginDataProvider sut;
    
    static{
        sut = new Collateral_PluginDataProvider();
    }
    
    private static testMethod void it_should_retrieve_the_existing_nCino_collateral_by_id() {
        LLC_BI__Collateral_Type__c testNcinoCollType = new LLC_BI__Collateral_Type__c();
        insert testNcinoCollType;
        
		LLC_BI__Collateral__c testNcinoColl = new LLC_BI__Collateral__c();
        testNcinoColl.LLC_BI__Collateral_Type__c = testNcinoCollType.Id;
        testNcinoColl.Actual_Advance_Rate__c = 88;
		insert testNcinoColl;
        
        Account testEntity = ObjectFactory.getValidEntity('testEntity');
        testEntity.EB_Client_Name__c='testOwner';
        update testEntity;
        
        List<LLC_BI__Account_Collateral__c> testAcctColls = new List<LLC_BI__Account_Collateral__c>();
        LLC_BI__Account_Collateral__c testAcctColl1 = new LLC_BI__Account_Collateral__c();
        testAcctColl1.LLC_BI__Primary_Owner__c = true;
        testAcctColl1.LLC_BI__Collateral__c = testNcinoColl.Id;
        testAcctColl1.LLC_BI__Account__c = testEntity.Id;
        testAcctColls.add(testAcctColl1);
        insert testAcctColls;        
        
        LLC_BI__Collateral__c result = sut.getNcinoCollateralById(testNcinoColl.Id);
        
        System.assertEquals(88, result.Actual_Advance_Rate__c);
        System.assertEquals(true, result.LLC_BI__Account_Collateral__r[0].LLC_BI__Primary_Owner__c);
        System.assertEquals(testNcinoColl.Id, result.Id);
    }
    
    private static testMethod void it_should_retrieve_any_matching_eb_collateral_by_name() {
		EB_Collateral__c testEbColl = new EB_Collateral__c();
        testEbColl.Name = 'TestName';
        Collateral_Code__c CollateralCode = ObjectFactory.getCollateralCode('test', '9990' );
        testEbColl.Collateral_Code__c = CollateralCode.Id;
        insert testEbColl;
                
        List<EB_Collateral__c> result = sut.getEbCollateralByNameOrKey(testEbColl.Name, testEbColl.Key__c);
        
        System.assertEquals('TestName', result[0].Name);
    }
    
    private static testMethod void it_should_retrieve_any_matching_eb_collateral_by_key() {
        String testName = 'TestName';
		EB_Collateral__c testEbColl = new EB_Collateral__c();
        testEbColl.Key__c = 'TestKey';
        Collateral_Code__c CollateralCode = ObjectFactory.getCollateralCode('test', '9990' );
        testEbColl.Collateral_Code__c = CollateralCode.Id;
        insert testEbColl;
                
        List<EB_Collateral__c> result = sut.getEbCollateralByNameOrKey(testName, testEbColl.Key__c);
        
        System.assertEquals('TestKey', result[0].Key__c);
    }
    
    private static testMethod void it_should_insert_and_return_an_eb_collateral_given_an_ebCollateral() {            
        EB_Collateral__c testEbColl = new EB_Collateral__c();
        testEbColl.Name = 'COL-00001';
        testEbColl.Collateral_Number__c = 'COL-00001';
        testEbColl.Key__c = 'TestKey';
        Collateral_Code__c CollateralCode = ObjectFactory.getCollateralCode('test', '9990' );
        testEbColl.Collateral_Code__c = CollateralCode.Id;

        EB_Collateral__c result = sut.save(testEbColl);
        
        List<EB_Collateral__c> reQuery = [SELECT Name, Collateral_Number__c, Key__c FROM EB_Collateral__c WHERE Name =: testEbColl.Name LIMIT 1];
		System.assertEquals('TestKey', reQuery[0].Key__c);
        System.assertEquals(testEbColl.Name, result.Name);
        System.assertEquals(testEbColl.Collateral_Number__c, result.Collateral_Number__c);
        System.assertEquals(testEbColl.Key__c, result.Key__c);
        System.assertEquals(testEbColl.Collateral_Code__c, result.Collateral_Code__c);
        
    }

    private static testMethod void it_should_update_and_return_an_eb_collateral_given_an_ebCollateral() {              
        EB_Collateral__c testEbColl = new EB_Collateral__c();
        testEbColl.Name = 'COL-00001';
        testEbColl.Collateral_Number__c = 'COL-00001';
        testEbColl.Key__c = 'TestKey';
        Collateral_Code__c CollateralCode = ObjectFactory.getCollateralCode('test', '9990' );
        testEbColl.Collateral_Code__c = CollateralCode.Id;
        insert testEbColl;

        EB_Collateral__c result = sut.save(testEbColl);
        
        List<EB_Collateral__c> reQuery = [SELECT Name, Collateral_Number__c, Key__c FROM EB_Collateral__c WHERE Id =: testEbColl.Id LIMIT 1];
        System.assertEquals('TestKey', reQuery[0].Key__c);
        System.assertEquals(testEbColl.Name, result.Name);
        System.assertEquals(testEbColl.Collateral_Number__c, result.Collateral_Number__c);
        System.assertEquals(testEbColl.Key__c, result.Key__c);
        System.assertEquals(testEbColl.Collateral_Code__c, result.Collateral_Code__c);        
    }
    
     private static testMethod void it_should_retrieve_any_matching_eb_collateral_code_by_code_id() {       
         Collateral_Code__c CollateralCode = ObjectFactory.getCollateralCode('test', '9990' );
         String ncinoCollCode = '9990';  
         
         Collateral_Code__c result = sut.getCollateralCode(ncinoCollCode);
         
         System.assertEquals('test', result.Name);
    }
    
    
}