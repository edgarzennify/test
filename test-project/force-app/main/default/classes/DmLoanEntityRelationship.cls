public class DmLoanEntityRelationship {
	public String Id {get;set;}
	public String Name {get;set;}
	public String RelationshipType {get;set;}
	public Decimal Liabilities{get;set;}
    public String ContingentType {get;set;}
    public Decimal ContingentPercentage {get;set;}
    public String Limitations {get;set;}
	public DmLoan Loan {get;set;}
	public DmEntity Entity {get;set;}
}