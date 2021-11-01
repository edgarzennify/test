public class DmOpportunity
{
	public String id {get;set;}
	public String name {get;set;}
	public String type {get;set;} 
	public Decimal committedAmount {get;set;}
	public Decimal potentialDeposits {get;set;}
	public Decimal potentialFeeIncome {get;set;}
	public String stageName {get;set;} 
	public String forecastCategoryName {get;set;}
	public Decimal probability {get;set;}
	public DmRecordType recordType {get;set;}
	public String products {get;set;}
	public DmEntity entity{get;set;}
	public List<String> BankProducts{get;set;}
}