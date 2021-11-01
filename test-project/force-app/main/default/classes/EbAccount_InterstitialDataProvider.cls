public class EbAccount_InterstitialDataProvider implements Interstitial.IEbAccount_InterstitialDataProvider {

    public EbAccount_InterstitialDataProvider(){        
    }
    
    public List<EB_Account__c> getEbAccountById(Id recordId){
        return [SELECT Id, Name, RecordType.Name, Key__c FROM EB_Account__c WHERE Id =: recordId LIMIT 1];
    }
    
}