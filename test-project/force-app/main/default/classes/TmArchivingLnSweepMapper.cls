public class TmArchivingLnSweepMapper implements TmArchiving.IMapper{

    private final String SVC_LOAN_SWEEP = 'Loan Sweep';
    
	private final TmArchiving.IMapperHelper m_helper;
	private final TmArchiving.IConfiguration m_config;


	public TmArchivingLnSweepMapper(TmArchiving.IMapperHelper helper, TmArchiving.IConfiguration config) {
		m_helper = helper;
		m_config = config;
	}

	public string handle() {
		return m_config.RECORDTYPE_LOAN_INVESTMENT_SWEEP();
	}

    public Treasury_Management__c buildTmService(TmArchiving.MapperRequestContainer container) {
		
		Treasury_Management__c tms = m_helper.buildTMObject(container, m_config.RECORDTYPE_LOAN_INVESTMENT_SWEEP());
		RecordType recType = new RecordType();
        Tm_Service_Request__c request = container.Pm.requestPm;

        if(request.Loan_Sweep__c != true){
            return null;
        }
		

		for(RecordType r : container.RecordTypes){
			if(r.Name == SVC_LOAN_SWEEP){
				recType = r;
			}
		}
		tms.RecordTypeId = recType.Id;
		tms.Product_PL__c = recType.Name;

        EB_Account__c loan = m_helper.getLoanAccount(container.pm);
        if(loan != null){
            tms.LOC_Number__c = loan.Account_Number__c ;
            tms.LOC_Maturity_Date__c = loan.Maturity_Date__c;
        }
        Tm_Service_Request_Account__c sweepAccount = m_helper.getSweepAccount(container.pm.serviceAccountPms);
		if(sweepAccount != null){
            tms.Target_Balance__c = sweepAccount.Target_Balance__c;
            tms.Sweep_Number__c = sweepAccount.EB_Account__r.Name;
        } else {
            tms.Target_Balance__c = 0.0;
        }

        tms.Master_Account_EB_Number__c = m_helper.getFeeAccount(container.pm.serviceAccountPms);
		tms.Monthly_Maintenance_Fee_Actual__c = request.TM_Fee__c == true? request.Loan_Sweep_Monthly_Maintenance_Fee__c : request.LoanSweep_Monthly_Maintenance_Fee_Custom__c; 
		tms.Implementation_Setup_Fee_Actual__c = request.TM_Fee__c == true? request.Loan_Invest_Swp_Implementation_Setup_Fee__c : request.LoanSweep_Imp_Setup_Fee_Custom__c;	
		
		String product = getProduct(request, sweepAccount);
		tms.Product_PL__c =  String.IsBlank(product) ? tms.Product_PL__c : product;
		tms.Service_Notes__c = request.Notes__c;
		
        tms.Monthly_Fee__c = tms.Monthly_Maintenance_Fee_Actual__c;
        tms.Annual_Fee__c = m_helper.annualFee(tms.Monthly_Maintenance_Fee_Actual__c);

		return tms;
	}

    
	private string getProduct(Tm_Service_Request__c r, Tm_Service_Request_Account__c a) {
		if(a != null) {
			if(a.EB_Account__r != null && a.EB_Account__r.Name.StartsWith('800') == true) {
				return r.RecordType.Name;
			}
		}
		return '';
	}

	public TmArchiving.QueryFields build(Id requestId) {

		TmArchiving.QueryFields q = new TmArchiving.QueryFields();

        q.requestId = requestId;
        q.requestFields = new List<string> {
        	'Id'
        	,'Name'
        	,'RecordTypeId'
        	,'RecordType.Name'
            ,'TM_Fee__c'
            ,'Custom_Fee__c'
        	,'Loan_Invest_Swp_Implementation_Setup_Fee__c'
        	,'LoanInvestment_Sweep__c'
            ,'Loan_Sweep__c'
            ,'Loan_Sweep_Monthly_Maintenance_Fee__c'
            ,'Loan_Investment_Monthly_Maintenance_Fee__c'
            ,'Notes__c'
            ,'Tm_Service_Request_Packet__r.Client_Type__c'
            ,'Tm_Service_Request_Packet__r.Bundle_Type__c'
            ,'LoanSweep_Monthly_Maintenance_Fee_Custom__c'
            ,'LoanSweep_Imp_Setup_Fee_Custom__c'
        };

        q.contactFields = new List<String> {
        	'Id'
        	,'Name'
        	,'Contact__c'
        	,'Contact__r.Name'
        	,'TM_Service_Request__c'
        	,'Contact__r.IT_Contact__c'
            ,'Contact__r.Secondary_TM_Contact__c'
            ,'Contact__r.Primary_TM_Contact__c'
        	,'File_Total_Verification_User__c'
        	,'Authorized_to_Receive_Return_Files__c'
            ,'Primary_Product_Contact__c'
            ,'Secondary_Product_Contact__c'
        };

        q.accountFields = new List<string> {
        	'Id'
        	,'Name'
        	,'IsLoan__c'
        	,'EB_Account__c'
        	,'EB_Account__r.Name'
            ,'EB_Account__r.Application__c'
            ,'EB_Account__r.Account_Number__c'
            ,'EB_Account__r.Maturity_Date__c'
            ,'EB_Account__r.Fee_Master_Account__c'
        	,'TM_Service_Request__c'
        	,'Account_Number_Title__c'
        	,'ACH_Originator_ID__c'
        	,'Sweep_Investment_Account_Number__c'       
        	,'Daily_Deposit_Limit__c'
        	,'Target_Balance__c'
            ,'Line_of_Credit_Account_Number__c'
            ,'Line_of_Credit_Maturity_Date__c'
            ,'Product_Fee_Account__c'
        };

        q.contactAccountFields = new List<string> {

        };

        q.contactCoreFields = new List<string> {
        	'FirstName'
        	,'LastName'
        	,'Name'
        	,'Fax'
        	,'Phone'
        	,'MobilePhone'
        	,'Email'
        	,'IT_Contact__c'
            ,'Secondary_TM_Contact__c'
            ,'Primary_TM_Contact__c'
        };

        q.accountCoreFields = new List<string> {
        	'Id'
        	,'Name'
        	,'ApplicationDescription__c'
        	,'Account_Line_1__c'
            ,'Application__c'
            ,'Account_Number__c'
            ,'Maturity_Date__c'
            ,'Fee_Master_Account__c'
        };

        return q;
	}
    public List<TM_Service_Contact__c> buildContacts(TmBoarding.RequestPm pm, Treasury_Management__c tm) 
    {
        List<Tm_Service_Contact__c> contacts = new List<Tm_Service_Contact__c>();
        Set<Id> contactSet = new Set<Id>();
        for (TM_Service_Request_Contact__c c: pm.serviceContactPms) {
            try{
                if(!contactSet.contains(c.Contact__c)) {
                    Tm_Service_Contact__c contactRel = new Tm_Service_Contact__c();
                    contactRel.Contact__c = c.Contact__c;
                    contactRel.Treasury_Management_Service__c = tm.Id;
                    contactRel.Primary_Product_Contact__c = c.Primary_Product_Contact__c;
                    contactRel.Secondary_Product_Contact__c = c.Secondary_Product_Contact__c;
                    contacts.add(contactRel);
                    contactSet.add(c.Contact__c);
                }
            }catch(exception ex){

            }
        }
        
        return contacts;
    }

    public List<EB_Account_Service__c> buildAccounts(Tmboarding.RequestPm pm, Treasury_Management__c tm)
    {
        List<EB_Account_Service__c> accounts = new List<EB_Account_Service__c>();
        Set<Id> ebAccountSet = new Set<Id>();
        for (TM_Service_Request_Account__c a: pm.serviceAccountPms) {
            try{
                if(!ebAccountSet.contains(a.EB_Account__c)) {
                    EB_Account_Service__c accountRel = new EB_Account_Service__c();
                    accountRel.TM_Service__c = tm.Id;
                    accountRel.Account__c = a.EB_Account__c;
                    accountRel.Daily_Deposit_Limit__c = a.Daily_Deposit_Limit__c;
                    accountRel.Line_of_Credit_Account__c = a.Line_of_Credit_Account_Number__c;
                    accountRel.Line_of_Credit_Maturity_Date__c = a.Line_of_Credit_Maturity_Date__c;
                    accountRel.Product_Fee_Account__c = a.Product_Fee_Account__c;
                    accountRel.Master_Account__c = a.EB_Account__r.Fee_Master_Account__c;
                    accountRel.Sweep_Investment_Account__c = a.Sweep_Investment_Account_Number__c;
                    accountRel.Target_Balance__c = a.Target_Balance__c == null?0.00: a.Target_Balance__c;
                    accountRel.Product_Fee_Account__c = a.Product_Fee_Account__c;
                    if(a.Product_Fee_Account__c == true || a.EB_Account__r.Fee_Master_Account__c == true) {                      
                        accountRel.Service_Charge__c = pm.requestPm.TM_Fee__c == true? pm.requestPm.Loan_Sweep_Monthly_Maintenance_Fee__c : pm.requestPm.LoanSweep_Monthly_Maintenance_Fee_Custom__c;                      
                    }
                    accounts.add(accountRel);
                    ebAccountSet.add(a.EB_Account__c);
                }
            }catch(exception ex){
                
            }
        }
        return accounts;
    }

    public List<TmArchiving.TreasuryManagementSm> postProcess(List<TmArchiving.TreasuryManagementSm> sms, Tmboarding.RequestPm pm){
        return sms;
    }
}