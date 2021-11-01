public class EbCollateral_InterstitialDataProvider implements Interstitial.IEbCollateral_InterstitialDataProvider {
    
    public EbCollateral_InterstitialDataProvider(){
    }
    
    public List<EB_Collateral__c> getEbCollateralById(Id recordId){
        return [SELECT Id, Name FROM EB_Collateral__c WHERE Id=:recordId LIMIT 1];
    }
}