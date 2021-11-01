public class Interstitial {

	public interface IEbAccount_InterstitialDataProvider {
		List<EB_Account__c> getEbAccountById(Id recordId);
	}
	public interface IEbCollateral_InterstitialDataProvider {
		List<EB_Collateral__c> getEbCollateralById(Id recordId);
	}
}