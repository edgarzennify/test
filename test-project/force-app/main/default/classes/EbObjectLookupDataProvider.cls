public class EbObjectLookupDataProvider implements EbObjectLookup.IDataProvider {
    public Account getEntity(String key) {
        return [
            SELECT
            	Id
            	,Name
            FROM
            	Account
            WHERE
                EB_Customer_Number__c =: key
                OR
                WM_Key__c =: key
            LIMIT 1
        ];
    }
    public EB_Account__c getEbAccount(String key){
        return [
            SELECT
            	Id
            	,Name
            FROM
            	EB_Account__c
            WHERE
            	Key__c =:key
            LIMIT 1
        ];
    }
    public EB_Collateral__c getEbCollateral(String key) {
        return [
            SELECT
            	Id
            	,Name
            FROM
            	EB_Collateral__c
            WHERE
            	Key__c =: key
            LIMIT 1
        ];
    }
    public Account getEntity(Id objectId) {
        return [
            SELECT
                Id
                ,Name
                ,EB_Customer_Number__c
                ,WM_Key__c
            FROM
                Account
            WHERE
                Id =: objectId
            LIMIT 1
        ];
    }
    public EB_Account__c getEbAccount(Id  objectId) {
        return [
            SELECT
                Id
                ,Name
                ,Key__c
            FROM
                EB_Account__c
            WHERE
                Id =:objectId
            LIMIT 1
        ];
    }

    public EB_Collateral__c getEbCollateral(Id objectId) {
        return [
            SELECT
                Id
                ,Name
                ,Key__c
            FROM
                EB_Collateral__c
            WHERE
                Id =: objectId
            LIMIT 1
        ];
    }
    
}