public with sharing class Collateral_PluginDataProvider implements Plugin.ICollateral_PluginDataProvider{

    public LLC_BI__Collateral__c getNcinoCollateralById(Id ncinoId){
        return [
            SELECT 
                Id
                ,Name
                ,Actual_Advance_Rate__c
                ,LLC_BI__Collateral_Name__c
                ,LLC_BI__Collateral_Type__r.Name
                ,LLC_BI__Collateral_Type__r.LLC_BI__Collateral_Code__c
                ,Modified_Collateral_Type__c
                ,Modified_Collateral_Type__r.LLC_BI__Collateral_Code__c
                ,Sync_Key__c
                ,LLC_BI__Street_Address__c
                ,LLC_BI__City__c
                ,LLC_BI__State__c
                ,LLC_BI__Zip_Code__c
                ,(
                    SELECT 
                        Id, LLC_BI__Primary_Owner__c, LLC_BI__Account__c
                    FROM LLC_BI__Account_Collateral__r
                )            
            FROM 
                LLC_BI__Collateral__c 
            WHERE 
                Id=:ncinoId 
            LIMIT 1
        ];
    }
       
    public List<EB_Collateral__c> getEbCollateralByNameOrKey(String name, String syncKey){
        return [
            SELECT 
                Id
                ,Name
                ,Collateral_Code__c
                ,Collateral_Owner__c
                ,Key__c 
            FROM 
                EB_Collateral__c
            WHERE 
                (
                    Name =: name 
                    AND Name !=''
                ) OR (
                    Key__c =: syncKey 
                    AND Key__c != ''
                )
            LIMIT 1
        ];  
    }
    
    public Collateral_Code__c getCollateralCode(String ncinoCollTypeCollCode){
        return [
            SELECT 
                Id
                ,Name
                ,Collateral_Code_ID__c 
            FROM 
                Collateral_Code__c 
            WHERE 
                Collateral_Code_ID__c =: ncinoCollTypeCollCode
        ];
    }

    public EB_Collateral__c save(EB_Collateral__c ebCollateral){
        if(ebCollateral.Id == null){
            insert ebCollateral;
        }else{
            update ebCollateral;
        }
        return ebCollateral;
    }
}