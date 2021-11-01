public class DmLoanCollateralRelationship {
	public String Id {get;set;}
	public String Name {get;set;}
	public String LienPosition {get;set;}
	public Decimal LendableValue {get;set;}
	public Boolean IsPrimary {get;set;}	
	public Boolean AbundanceOfCaution {get;set;}
	public Boolean IsOwnedByPrimaryBorrower {get;set;}
	public DmLoan Loan {get;set;}
	public DmCollateral Collateral {get;set;}
}