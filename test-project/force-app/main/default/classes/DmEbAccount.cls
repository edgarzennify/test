public class DmEbAccount 
{
	public String id {get;set;}
	public Integer application {get;set;}
	public String accountNumber {get;set;}
	public String accountType {get;set;}
	public String name {get;set;}
	public String accountLine1 {get;set;}
	public Decimal averageBalance {get;set;}
	public Decimal ytdBalance {get;set;}
	public Decimal currentBalance {get;set;}
	public Decimal employeeCurrentBalance {get;set;}
	public String employeeAccountFlag {get;set;}
	public Decimal coreCurrentBalance {get;set;}
	public Decimal currentCommitment {get;set;}
	public Decimal unadvancedLoanAmount {get;set;}
	public Decimal accountFees {get;set;}
	public String status {get;set;}
	public DmEntity primaryOwner {get;set;}
	public Decimal contributionMargin {get;set;}
	public Decimal ytdContributionMargin {get;set;}
	public String riskRating {get;set;}
	public String key {get;set;}
}