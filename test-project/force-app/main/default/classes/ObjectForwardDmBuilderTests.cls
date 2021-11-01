@isTest
public class ObjectForwardDmBuilderTests {

    private static ObjectForwardDmBuilder sut;
    
    static{
        sut = new ObjectForwardDmBuilder();
    }
    
    private static testMethod void it_should_build_a_dmForward_given_a_live_Object_Forward_mdt(){
        String origObjName = 'EB_Account__c';
        String origObjRecordTypeName = 'Loan';
        
        List<Object_Forward__mdt> objForwards = 
                [SELECT  OriginalObjectRecordTypeName__c
                        ,OriginalObjectName__c
                        ,OriginalObjectLookupField__c
                        ,ForwardObjectName__c
                        ,ForwardObjectLookupField__c
                        ,Active__c
                        ,Show_Interstitial__c 
                  FROM  Object_Forward__mdt 
                  WHERE OriginalObjectName__c =: origObjName
                        AND OriginalObjectRecordTypeName__c =: origObjRecordTypeName
                        AND Active__c = true
                  LIMIT 1
               ];        
        
        List<ObjectForward.DmForward> result = sut.buildDmForwards(objForwards);
        
        System.assertEquals(1, result.size());        
        System.assertEquals('LLC_BI__lookupKey__c', result[0].lookupField);
        System.assertEquals(false, result[0].showInterstitial);
        System.assertEquals('LLC_BI__Loan__c', result[0].objectName);
        System.assertEquals('Loan', result[0].objectLabel);
        System.assertEquals('LLC_BI__Loan__c', result[0].sObjectType.getDescribe().getName());
    }    
}