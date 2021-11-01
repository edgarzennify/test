@IsTest
private class TmOpportunityConverterConfigurationTests {
	private static TmOpportunityConverterConfiguration sut;
    static{
        sut = new TmOpportunityConverterConfiguration();
    }
    
    private static testMethod void it_should_call_the_configurations() {
        String RECORDTYPE_ACH_DEBIT_FILTER =  sut.RECORDTYPE_ACH_DEBIT_FILTER();
        String RECORDTYPE_LOCKBOX = sut.RECORDTYPE_LOCKBOX();
        String RECORDTYPE_ONLINE_BANKING = sut.RECORDTYPE_ONLINE_BANKING();
        String RECORDTYPE_CONTROLLED_DISBURSEMENT = sut.RECORDTYPE_CONTROLLED_DISBURSEMENT();
        String RECORDTYPE_EDI = sut.RECORDTYPE_EDI();
        String RECORDTYPE_EB_ROM = sut.RECORDTYPE_EB_ROM();
        String RECORDTYPE_ENTERPRISE_AUTOMATED_PAYABLES = sut.RECORDTYPE_ENTERPRISE_AUTOMATED_PAYABLES();
        String RECORDTYPE_INVESTMENT_SWEEP = sut.RECORDTYPE_INVESTMENT_SWEEP();
        String RECORDTYPE_LOAN_SWEEP = sut.RECORDTYPE_LOAN_SWEEP();
        String RECORDTYPE_POSITIVE_PAY = sut.RECORDTYPE_POSITIVE_PAY();
        String RECORDTYPE_REMIT_PLUS = sut.RECORDTYPE_REMIT_PLUS();
        String RECORDTYPE_REMOTE_DEPOSIT = sut.RECORDTYPE_REMOTE_DEPOSIT();
        String RECORDTYPE_ZBA = sut.RECORDTYPE_ZBA();

       String SUBTYPE_LOCKBOX_DATA_REMITTANCE_MODULE = sut.SUBTYPE_LOCKBOX_DATA_REMITTANCE_MODULE();
       String SUBTYPE_LOCKBOX_DATA_ENTRY_MODULE = sut.SUBTYPE_LOCKBOX_DATA_ENTRY_MODULE();
       String SUBTYPE_LOCKBOX_DATA_EXTRACT_MODULE = sut.SUBTYPE_LOCKBOX_DATA_EXTRACT_MODULE();
       String SUBTYPE_ONLINE_BANKING_ACH_MODULE = sut.SUBTYPE_ONLINE_BANKING_ACH_MODULE();
       String SUBTYPE_ONLINE_BANKING_WIRE_MODULE = sut.SUBTYPE_ONLINE_BANKING_WIRE_MODULE();

       String SUBTYPE_INVESTMENT_SWEEP_GOLDMAN_SACHS = sut.SUBTYPE_INVESTMENT_SWEEP_GOLDMAN_SACHS();
       String SUBTYPE_INVESTMENT_SWEEP_MONEY_MARKET = sut.SUBTYPE_INVESTMENT_SWEEP_MONEY_MARKET();
       String SUBTYPE_INVESTMENT_SWEEP_OPTIMA_PLUS = sut.SUBTYPE_INVESTMENT_SWEEP_OPTIMA_PLUS();
       String SUBTYPE_INVESTMENT_SWEEP_REPO = sut.SUBTYPE_INVESTMENT_SWEEP_REPO();
        
        
       System.assertEquals('ACH Debit Filter', RECORDTYPE_ACH_DEBIT_FILTER);
       System.assertEquals('Lockbox', RECORDTYPE_LOCKBOX);
       System.assertEquals('Online Banking', RECORDTYPE_ONLINE_BANKING);
       System.assertEquals('Controlled Disbursement', RECORDTYPE_CONTROLLED_DISBURSEMENT);
       System.assertEquals('EDI', RECORDTYPE_EDI);
       System.assertEquals('EB-ROM', RECORDTYPE_EB_ROM);
       System.assertEquals('Enterprise Automated Payables', RECORDTYPE_ENTERPRISE_AUTOMATED_PAYABLES);
       System.assertEquals('Investment Sweep', RECORDTYPE_INVESTMENT_SWEEP);
       System.assertEquals('Loan Sweep', RECORDTYPE_LOAN_SWEEP);
       System.assertEquals('Positive Pay', RECORDTYPE_POSITIVE_PAY);
       System.assertEquals('Remit Plus', RECORDTYPE_REMIT_PLUS);
       System.assertEquals('Remote Deposit', RECORDTYPE_REMOTE_DEPOSIT);
       System.assertEquals('ZBA', RECORDTYPE_ZBA);
       System.assertEquals('Lockbox - Data Remittance Module', SUBTYPE_LOCKBOX_DATA_REMITTANCE_MODULE);
       System.assertEquals('Lockbox - Data Entry Module', SUBTYPE_LOCKBOX_DATA_ENTRY_MODULE);
       System.assertEquals('Lockbox - Data Extract Module', SUBTYPE_LOCKBOX_DATA_EXTRACT_MODULE);
       System.assertEquals('Online Banking - ACH Module', SUBTYPE_ONLINE_BANKING_ACH_MODULE);
       System.assertEquals('Online Banking - Wire Module', SUBTYPE_ONLINE_BANKING_WIRE_MODULE);
       System.assertEquals('Sweep - Goldman Sachs', SUBTYPE_INVESTMENT_SWEEP_GOLDMAN_SACHS);
       System.assertEquals('Sweep - Money Market', SUBTYPE_INVESTMENT_SWEEP_MONEY_MARKET);
       System.assertEquals('Sweep - Optima Plus', SUBTYPE_INVESTMENT_SWEEP_OPTIMA_PLUS);
       System.assertEquals('Sweep - Repo', SUBTYPE_INVESTMENT_SWEEP_REPO);
    }
}