public class Plugin {

	public interface ILoan_PluginDataProvider {
		LLC_BI__Loan__c getNcinoLoanById(Id recordId);
	    List<PM_EB_Account_c> getEbAccountByKey(String key);
	    List<LLC_BI__LoanRenewal__c> getParentLoanRelationship(Id loanId);
	}

	public interface ICollateral_PluginDataProvider {
	    LLC_BI__Collateral__c getNcinoCollateralById(Id ncinoId);
	    List<EB_Collateral__c> getEbCollateralByNameOrKey(String name, String syncKey);
	    Collateral_Code__c getCollateralCode(String collCodeName);
	    EB_Collateral__c save(EB_Collateral__c ebCollateral);
	}
}