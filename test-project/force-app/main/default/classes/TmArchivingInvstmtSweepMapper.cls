public class TmArchivingInvstmtSweepMapper implements TmArchiving.IMapper {

	private final TmArchiving.IMapperHelper m_helper;
	private final TmArchiving.IConfiguration m_config;

	public TmArchivingInvstmtSweepMapper(TmArchiving.IMapperHelper helper, TmArchiving.IConfiguration config) {
		m_helper = helper;
		m_config = config;
	}

	public String handle() {
		return m_config.RECORDTYPE_INVESTMENT_SWEEP();
	}

    public Treasury_Management__c buildTmService(TmArchiving.MapperRequestContainer container) {
		Treasury_Management__c tms = m_helper.buildTMObject(container, m_config.RECORDTYPE_INVESTMENT_SWEEP());
		Tm_Service_Request__c request = container.Pm.requestPm;

		tms.Master_Account_EB_Number__c = m_helper.getFeeAccount(container.pm.serviceAccountPms);

		tms.Product_PL__c = getSweepType(request);

		Tm_Service_Request_Account__c ra = getSweepAccount(container);
		tms.Sweep_Number__c = ra == null? '': ra.Eb_Account__r.Name;
		tms.Target_Balance__c = ra == null? 0.0: ra.Target_Balance__c;
		tms.Service_Notes__c = request.Notes__c;
		
		tms.Implementation_Setup_Fee_Actual__c = getImplementationSetupFee(request, container);
		tms.Monthly_Maintenance_Fee_Actual__c = getMonthlyMaintenanceFee(request, container);
		tms.Monthly_Fee__c = tms.Monthly_Maintenance_Fee_Actual__c;
		tms.Annual_Fee__c = m_helper.annualFee(tms.Monthly_Maintenance_Fee_Actual__c);
		

		return tms;
	}

	private string getSweepType(Tm_Service_Request__c req) {
		if(string.isblank(req.Sweep_Type__c)) return m_config.RECORDTYPE_INVESTMENT_SWEEP();
		if(req.Sweep_Type__c == m_config.GOLDMAN_SACHS()) return m_config.SWEEP_GOLDMAN_SACHS();
		if(req.Sweep_Type__c == m_config.MONEY_MARKET()) return m_config.SWEEP_MONEY_MARKET();
		if(req.Sweep_Type__c == m_config.OPTIMA_PLUS()) return m_config.SWEEP_OPTIMA_PLUS();
		if(req.Sweep_Type__c == m_config.REPO()) return m_config.SWEEP_REPO();
		return '';
	}

	private decimal getMonthlyMaintenanceFee(Tm_Service_Request__c req, TmArchiving.MapperRequestContainer c) {
		if(m_helper.compare(req.Sweep_Type__c, m_config.MONEY_MARKET())) return req.TM_Fee__c == true? req.MM_Sweep_Monthly_Maintenance_Fee__c: req.Sweep_Monthly_Maintenance_Fee_Custom__c;
		if(m_helper.compare(req.Sweep_Type__c, m_config.OPTIMA_PLUS())) return req.Optima_Sweep_Monthly_Maintenance_Fee__c;
		return 0.0;
	}

	private decimal getImplementationSetupFee(Tm_Service_Request__c req, TmArchiving.MapperRequestContainer c) {
		if(m_helper.compare(req.Sweep_Type__c, m_config.MONEY_MARKET())) return req.TM_Fee__c == true? req.MM_Sweep_Implementation_Setup_Fee__c : req.Sweep_Implementation_Setup_Fee_Custom__c;
		if(m_helper.compare(req.Sweep_Type__c, m_config.OPTIMA_PLUS())) return req.Optima_Sweep_Implementation_Setup_Fee__c;
		return 0.0;
	}

	private Tm_Service_Request_Account__c getSweepAccount(TmArchiving.MapperRequestContainer c) {
		if(c.pm == null || c.pm.serviceAccountPms == null){return null;}
		for(Tm_Service_Request_Account__c a: c.pm.serviceAccountPms) {
			if(a.Sweep_Investment_Account_Number__c == true) return a;
		}
		return null;
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
        	,'Sweep_Type__c'
        	,'MM_Sweep_Monthly_Maintenance_Fee__c'
        	,'Optima_Sweep_Monthly_Maintenance_Fee__c'
        	,'MM_Sweep_Implementation_Setup_Fee__c'
        	,'Optima_Sweep_Implementation_Setup_Fee__c'
			,'Sweep_Monthly_Maintenance_Fee_Custom__c'
			,'Sweep_Implementation_Setup_Fee_Custom__c'
			,'Notes__c'
			,'Tm_Service_Request_Packet__r.Client_Type__c'
            ,'Tm_Service_Request_Packet__r.Bundle_Type__c'
        };

        q.contactFields = new List<String> {
        	'Id'
        	,'Name'
        	,'Contact__c'
        	,'Contact__r.Name'
            ,'Contact__r.Secondary_TM_Contact__c'
            ,'Contact__r.Primary_TM_Contact__c'
        	,'TM_Service_Request__c'
        	,'Contact__r.IT_Contact__c'
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
            ,'EB_Account__r.Fee_Master_Account__c'
        	,'TM_Service_Request__c'
        	,'Sweep_Investment_Account_Number__c'  
            ,'Daily_Deposit_Limit__c'
            ,'Target_Balance__c'
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
        	,'Fee_Master_Account__c'
        	,'Account_Line_1__c'
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
                    accountRel.Target_Balance__c = a.Target_Balance__c == null?0.00: a.Target_Balance__c;
                    accountRel.Product_Fee_Account__c = a.Product_Fee_Account__c;
                    accountRel.Master_Account__c = a.EB_Account__r.Fee_Master_Account__c;
					if(a.Product_Fee_Account__c == true || a.EB_Account__r.Fee_Master_Account__c == true) {                      
                        accountRel.Service_Charge__c = pm.requestPm.TM_Fee__c == true? pm.requestPm.MM_Sweep_Monthly_Maintenance_Fee__c : pm.requestPm.Sweep_Monthly_Maintenance_Fee_Custom__c;                      
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