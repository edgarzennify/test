@IsTest
private class TmArchivingConfigurationTests {
	private static final TmArchivingConfiguration sut;
    
    static {
        sut = new TmArchivingConfiguration();
    }
    
    public static testMethod void it_should_check_configuration_values() {
              
        String GOLDMAN_SACHS = sut.GOLDMAN_SACHS();//{return 'Goldman Sachs';}
        String SWEEP_GOLDMAN_SACHS = sut.SWEEP_GOLDMAN_SACHS(); //{return 'Sweep - Goldman Sachs';}
		String MONEY_MARKET = sut.MONEY_MARKET(); //{return 'Money Market';}
		String SWEEP_MONEY_MARKET = sut.SWEEP_MONEY_MARKET();//{return 'Sweep - Money Market';}
		String OPTIMA_PLUS = sut.OPTIMA_PLUS(); //{return 'Optima Plus';}
        String SWEEP_OPTIMA_PLUS = sut.SWEEP_OPTIMA_PLUS();//{return 'Sweep - Optima Plus';}
        String REPO = sut.REPO(); //(){return 'Repo';}
		String SWEEP_REPO = sut.SWEEP_REPO(); //{return 'Sweep - Repo';}
        String CONVENTIONAL = sut.CONVENTIONAL();//{return 'Conventional';}
        String PAYEE = sut.PAYEE(); //{return 'Payee';}
		String REVERSE = sut.REVERSE();//{return 'Reverse';}
        String POSITIVE_PAY_CONVENTIONAL = sut.POSITIVE_PAY_CONVENTIONAL(); //{return 'Positive Pay - Conventional';}
		String POSITIVE_PAY_REVERSE = sut.POSITIVE_PAY_REVERSE(); //{return 'Positive Pay - Reverse';}
        String POSITIVE_PAY_PAYEE = sut.POSITIVE_PAY_PAYEE();//{return 'Positive Pay - Payee';}
        String REMOTE_DEPOSIT_DESKTOP = sut.REMOTE_DEPOSIT_DESKTOP(); //{return 'Remote Deposit - Desktop';}
        String REMOTE_DEPOSIT_MOBILE = sut.REMOTE_DEPOSIT_MOBILE(); //{return 'Remote Deposit - Mobile';}
        String NONE = sut.NONE(); //{return 'None';}
        String QUICKBOOKS_PEACHTREE = sut.QUICKBOOKS_PEACHTREE(); //{return 'Quickbooks/Peachtree';}
        String DYNAMICS_NETSUITE_INTAACT = sut.DYNAMICS_NETSUITE_INTAACT(); //{return 'Dynamics/NetSuite/Intaact';}
        String SAP_ERP = sut.SAP_ERP(); //{return 'SAP/ERP';}

        String ACCESS_SUPERVISOR = sut.ACCESS_SUPERVISOR(); //{ return 'Supervisor';}
        String OLD_SUPERVISOR = sut.OLD_SUPERVISOR(); //{ return 'OLB_Supervisor__c';}
        String ACCESS_LEVEL = sut.ACCESS_LEVEL(); //{ return 'Access_Level__c';}

        String RECORDTYPE_ACH_DEBIT_FILTER = sut.RECORDTYPE_ACH_DEBIT_FILTER(); //{return 'ACH Debit Filter';}
        String RECORDTYPE_ACH = sut.RECORDTYPE_ACH(); //{return 'ACH';}
		String RECORDTYPE_LOCKBOX = sut.RECORDTYPE_LOCKBOX(); //{return 'Lockbox';}
        String RECORDTYPE_LOCKBOX_DATA_REMITTANCE_MODULE = sut.RECORDTYPE_LOCKBOX_DATA_REMITTANCE_MODULE(); //{return 'Lockbox - Data Remittance Module';}
        String RECORDTYPE_LOCKBOX_DATA_ENTRY_MODULE = sut.RECORDTYPE_LOCKBOX_DATA_ENTRY_MODULE(); //{return 'Lockbox - Data Entry Module';}
		String RECORDTYPE_LOCKBOX_DATA_EXTRACT_MODULE = sut.RECORDTYPE_LOCKBOX_DATA_EXTRACT_MODULE(); //{return 'Lockbox - Data Extract Module';}
		String RECORDTYPE_ONLINE_BANKING = sut.RECORDTYPE_ONLINE_BANKING(); //{return 'Online Banking';}
		String RECORDTYPE_CONTROLLED_DISBURSEMENT = sut.RECORDTYPE_CONTROLLED_DISBURSEMENT(); //{return 'Controlled Disbursement';}
        String RECORDTYPE_EDI = sut.RECORDTYPE_EDI(); //{return 'EDI';}
        String RECORDTYPE_EB_ROM = sut.RECORDTYPE_EB_ROM(); //{return 'EB-ROM';}
        String RECORDTYPE_ENTERPRISE_AUTOMATED_PAYABLES = sut.RECORDTYPE_ENTERPRISE_AUTOMATED_PAYABLES(); //{return 'Enterprise Automated Payables';}
        String RECORDTYPE_INVESTMENT_SWEEP = sut.RECORDTYPE_INVESTMENT_SWEEP(); //{return 'Investment Sweep';}
        String RECORDTYPE_LOAN_INVESTMENT_SWEEP = sut.RECORDTYPE_LOAN_INVESTMENT_SWEEP();//{return 'Loan, Loan/Investment Sweep';}
		String RECORDTYPE_POSITIVE_PAY = sut.RECORDTYPE_POSITIVE_PAY(); //{return 'Positive Pay';}
		String RECORDTYPE_REMIT_PLUS = sut.RECORDTYPE_REMIT_PLUS(); //{return 'Remit Plus';}
		String RECORDTYPE_REMOTE_DEPOSIT = sut.RECORDTYPE_REMOTE_DEPOSIT(); //{return 'Remote Deposit';}
		String RECORDTYPE_WIRES = sut.RECORDTYPE_WIRES();//{return 'Wires';}
		String RECORDTYPE_ZBA = sut.RECORDTYPE_ZBA(); //{return 'ZBA';}
        String RECORDTYPE_SVC_COMMERCIAL_ONLINE_BANKING = sut.RECORDTYPE_SVC_COMMERCIAL_ONLINE_BANKING(); //{return 'Commercial Online Banking';}
		String RECORDTYPE_OTHER_TM_PRODUCT = sut.RECORDTYPE_OTHER_TM_PRODUCT();//{return 'Other TM Product';}
		String RECORDTYPE_BUSINESS_BILL_PAY = sut.RECORDTYPE_BUSINESS_BILL_PAY(); //{return 'Business Bill Pay';}
        
        System.assertEquals('Goldman Sachs', GOLDMAN_SACHS);
        System.assertEquals('Sweep - Goldman Sachs', SWEEP_GOLDMAN_SACHS);
        System.assertEquals('Money Market', MONEY_MARKET);
        System.assertEquals('Sweep - Money Market', SWEEP_MONEY_MARKET);
        System.assertEquals('Optima Plus', OPTIMA_PLUS);
        System.assertEquals('Sweep - Optima Plus', SWEEP_OPTIMA_PLUS);
        System.assertEquals('Repo', REPO);
        System.assertEquals('Sweep - Repo', SWEEP_REPO);
        System.assertEquals('Conventional', CONVENTIONAL);
        System.assertEquals('Payee', PAYEE);
        System.assertEquals('Reverse', REVERSE);
        System.assertEquals('Positive Pay - Conventional', POSITIVE_PAY_CONVENTIONAL);
        System.assertEquals('Positive Pay - Reverse', POSITIVE_PAY_REVERSE);
        System.assertEquals('Positive Pay - Payee', POSITIVE_PAY_PAYEE);
        System.assertEquals('Remote Deposit - Desktop', REMOTE_DEPOSIT_DESKTOP);
        System.assertEquals('Remote Deposit - Mobile', REMOTE_DEPOSIT_MOBILE);
        System.assertEquals('None', NONE);
        System.assertEquals('Quickbooks/Peachtree', QUICKBOOKS_PEACHTREE);
        System.assertEquals('Dynamics/NetSuite/Intaact', DYNAMICS_NETSUITE_INTAACT);
        System.assertEquals('SAP/ERP', SAP_ERP);
        System.assertEquals('Supervisor', ACCESS_SUPERVISOR);
        System.assertEquals('ACH Debit Filter', RECORDTYPE_ACH_DEBIT_FILTER);
        System.assertEquals('ACH', RECORDTYPE_ACH);
        System.assertEquals('Lockbox', RECORDTYPE_LOCKBOX);
        System.assertEquals('Lockbox - Data Remittance Module', RECORDTYPE_LOCKBOX_DATA_REMITTANCE_MODULE);
        System.assertEquals('Lockbox - Data Entry Module', RECORDTYPE_LOCKBOX_DATA_ENTRY_MODULE);
        System.assertEquals('Lockbox - Data Extract Module', RECORDTYPE_LOCKBOX_DATA_EXTRACT_MODULE);
        System.assertEquals('Online Banking', RECORDTYPE_ONLINE_BANKING);
        System.assertEquals('Controlled Disbursement', RECORDTYPE_CONTROLLED_DISBURSEMENT);
        System.assertEquals('EDI', RECORDTYPE_EDI);
        System.assertEquals('EB-ROM', RECORDTYPE_EB_ROM);
        System.assertEquals('Enterprise Automated Payables', RECORDTYPE_ENTERPRISE_AUTOMATED_PAYABLES);
        System.assertEquals('Loan, Loan/Investment Sweep', RECORDTYPE_LOAN_INVESTMENT_SWEEP );
        System.assertEquals('Investment Sweep', RECORDTYPE_INVESTMENT_SWEEP);
        System.assertEquals('Positive Pay', RECORDTYPE_POSITIVE_PAY);
        System.assertEquals('Remit Plus', RECORDTYPE_REMIT_PLUS);
        System.assertEquals('Remote Deposit', RECORDTYPE_REMOTE_DEPOSIT);
        System.assertEquals('Wires', RECORDTYPE_WIRES);
        System.assertEquals('ZBA', RECORDTYPE_ZBA);
        System.assertEquals('Commercial Online Banking', RECORDTYPE_SVC_COMMERCIAL_ONLINE_BANKING);
        System.assertEquals('Other TM Product', RECORDTYPE_OTHER_TM_PRODUCT);
        System.assertEquals('Business Bill Pay', RECORDTYPE_BUSINESS_BILL_PAY);
        
    }	
}