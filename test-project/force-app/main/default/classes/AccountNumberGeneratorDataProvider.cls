public class AccountNumberGeneratorDataProvider implements AccountNumberGenerator.IDataProvider {
    public Card_Information__c getCardInformationById(Id objectId){
        return [
            SELECT 
                Id
                ,Card_Type__c
                ,url__c
                ,Account_Type__c 
            FROM 
                Card_Information__c 
            WHERE 
                Id =: objectId
        ];
    }
    
    public List<Card_Information__c> getActiveCardInformationsByType(String accountType){
        return [
            SELECT 
                Id
                ,Card_Type__c 
                ,url__c
                ,Account_Type__c 
            FROM 
                Card_Information__c 
            WHERE 
                Account_Type__c =: accountType 
                AND Active__c = true 
            ORDER BY
                Card_Type__c
        ];
    }

    public List<Card_Information__c> getAllActiveCardInformations(){
        return [
            SELECT 
                Id
                ,Card_Type__c 
                ,url__c
                ,Account_Type__c 
                ,From_Tm_Request__c
            FROM 
                Card_Information__c 
            WHERE 
                Active__c = true 
            ORDER BY
                Card_Type__c
        ];
    }
    
    public void save(SObject so){
        update so;
    }
}