@isTest
public class EbCollateral_InterstitialDataProvTests {

    private static EbCollateral_InterstitialDataProvider sut;
    
    static{
        sut = new EbCollateral_InterstitialDataProvider();
    }
    
    private static testMethod void it_should_getEbCollateralById(){

        EB_Collateral__c testEbColl = new EB_Collateral__c();
        Collateral_Code__c CollateralCode = ObjectFactory.getCollateralCode('test', '9990' );
        testEbColl = ObjectFactory.getCollateral('TestCollName', CollateralCode, true);

        List<EB_Collateral__c> result = sut.getEbCollateralById(testEbColl.Id);
            
        System.assertEquals(1, result.size());  
        System.assertEquals('TestCollName', result[0].Name); 
    }
}