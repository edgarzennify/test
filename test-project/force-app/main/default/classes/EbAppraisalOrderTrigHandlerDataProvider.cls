public class EbAppraisalOrderTrigHandlerDataProvider implements EbAppraisalOrderTriggerHandler.IEbAppraisalOrderTrigHandlerDataProv {  
   
    public List<EB_Collateral__c> getRelatedEbCollateralsByIds(List<Id> apprOrderRelCollIds){
        return [SELECT Id, Name, Key__c FROM EB_Collateral__c WHERE Id in: apprOrderRelCollIds];
    }
      
    public List<LLC_BI__Collateral__c> getNcinoCollateralsByNameOrKey(List<String> relEbCollNames, List<String> relEbCollKeys){        
        return [
            SELECT 
                Id
                ,Name
                ,Sync_Key__c
                ,USPAP_Compliant__c
                ,FDIC_Valuation_Type__c
                ,Valuation_Date__c
                ,As_Completed_Value__c
                ,As_Is_Value__c
                ,As_Liquidated_Value__c
                ,As_Stabilized_Value__c
                ,Appraisal_Company_Used__c
                ,Oasis_Order_Number__c
                ,Appraised_Value_reviewed__c               
            FROM
                LLC_BI__Collateral__c  
            WHERE
                (Name IN: relEbCollNames AND Name != null AND Name != '')
                OR (Sync_Key__c IN: relEbCollKeys AND Sync_Key__c != null AND Sync_Key__c != '')                
        ];
    }    
    
    public void updateNcinoCollateralsAppraisalFields(List<LLC_BI__Collateral__c> nCinoColls){
        update nCinoColls;
    }   
}