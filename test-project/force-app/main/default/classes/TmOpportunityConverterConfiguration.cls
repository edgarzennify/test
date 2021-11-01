public class TmOpportunityConverterConfiguration implements TmOpportunityConverter.IConfiguration{
	public String RECORDTYPE_ACH_DEBIT_FILTER(){return 'ACH Debit Filter';}
    public String RECORDTYPE_LOCKBOX(){return 'Lockbox';}
    public String RECORDTYPE_ONLINE_BANKING(){return 'Online Banking';}
    public String RECORDTYPE_CONTROLLED_DISBURSEMENT(){return 'Controlled Disbursement';}
    public String RECORDTYPE_EDI(){return 'EDI';}
    public String RECORDTYPE_EB_ROM(){return 'EB-ROM';}
    public String RECORDTYPE_ENTERPRISE_AUTOMATED_PAYABLES(){return 'Enterprise Automated Payables';}
    public String RECORDTYPE_INVESTMENT_SWEEP(){return 'Investment Sweep';}
    public String RECORDTYPE_LOAN_SWEEP(){return 'Loan Sweep';}
    public String RECORDTYPE_POSITIVE_PAY(){return 'Positive Pay';}
    public String RECORDTYPE_REMIT_PLUS(){return 'Remit Plus';}
    public String RECORDTYPE_REMOTE_DEPOSIT(){return 'Remote Deposit';}
    public String RECORDTYPE_ZBA(){return 'ZBA';}

    public String SUBTYPE_LOCKBOX_DATA_REMITTANCE_MODULE(){return 'Lockbox - Data Remittance Module';}
    public String SUBTYPE_LOCKBOX_DATA_ENTRY_MODULE(){return 'Lockbox - Data Entry Module';}
    public String SUBTYPE_LOCKBOX_DATA_EXTRACT_MODULE(){return 'Lockbox - Data Extract Module';}
    public String SUBTYPE_ONLINE_BANKING_ACH_MODULE(){return 'Online Banking - ACH Module';}
    public String SUBTYPE_ONLINE_BANKING_WIRE_MODULE(){return 'Online Banking - Wire Module';}

    public String SUBTYPE_INVESTMENT_SWEEP_GOLDMAN_SACHS(){ return 'Sweep - Goldman Sachs';}
    public String SUBTYPE_INVESTMENT_SWEEP_MONEY_MARKET(){ return 'Sweep - Money Market';}
    public String SUBTYPE_INVESTMENT_SWEEP_OPTIMA_PLUS(){ return 'Sweep - Optima Plus';}
    public String SUBTYPE_INVESTMENT_SWEEP_REPO() { return 'Sweep - Repo';}

    public String OPP_RECORDTYPE_BUSINESS_BANKING() {return 'Business Banking';}
}