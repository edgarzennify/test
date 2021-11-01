public class DmLoanRateStream {
    public Decimal Index {get;set;}
    public Datetime EffectiveDate {get;set;}
    public Decimal Duration {get;set;}
    public String Frequency {get;set;}
    public Decimal PercentageOfLoan {get;set;}
    public String RateType {get;set;}
    public Decimal InterestRate {get;set;}
    public List<DmLoanPerformanceRule> PerformanceRules {get;set;}
}