public class TmArchivingEapMapper implements TmArchiving.IMapper {

	private final String ACCOUNT_SETUP_SINGLE = 'Single File';

	private final TmArchiving.IMapperHelper m_helper;
	private final TmArchiving.IConfiguration m_config;

	public TmArchivingEapMapper(TmArchiving.IMapperHelper helper, TmArchiving.IConfiguration config) {
		m_helper = helper;
		m_config = config;
	}

	public String handle() {
		return m_config.RECORDTYPE_ENTERPRISE_AUTOMATED_PAYABLES();
	}

    public Treasury_Management__c buildTmService(TmArchiving.MapperRequestContainer container) {
		Treasury_Management__c tms = m_helper.buildTMObject(container, m_config.RECORDTYPE_ENTERPRISE_AUTOMATED_PAYABLES());
		Tm_Service_Request__c request = container.Pm.requestPm;
		tms.Accounting_System__c  = getAccountSystem(request);
		tms.ACH_EAP_Payment_Method__c = request.ACH_EAP_Payment_Method__c;
		tms.Check_EAP_Payment_Method__c = request.Check_EAP_Payment_Method__c;
		tms.Credit_P_Card_EAP_Payment_Method__c = request.Credit_P_Card_EAP_Payment_Method__c;
 
		tms.Dual_Approval_for_Payments__c = request.Dual_Approval_for_Payments__c;
		tms.EAP_Daily_Limit_ACH__c = request.EAP_Daily_Limit_ACH__c;
		tms.EAP_Daily_Limit_Check__c = request.EAP_Daily_Limit_Check__c;
		tms.EAP_Daily_Limit_Credit_P_Card__c = request.EAP_Daily_Limit_Credit_P_Card__c;
		tms.EAP_Ach_Credit_Card_Per_Item_Fee__c = request.TM_Fee__c == true? request.ACH_Credit_Card_Payment_Per_Item_Fee__c: request.ACH_Credit_Card_Payment_Per_Item_Custom__c;
		tms.EAP_Check_Payment_Per_Item_Fee__c = request.TM_Fee__c == true? request.Check_Payment_Per_Item_Fee__c: request.Check_Payment_Per_Item_Fee_Custom__c;
		tms.Invoice_Payment_Per_Item__c = request.TM_Fee__c == true? request.Invoice_Payment_Per_Item__c : request.Invoice_Payment_Per_Item_Custom__c ;
		tms.Hosted_or_Individual_PCs__c = request.Network_Setup__c;
		tms.IT_Support_Required_to_Install_Programs__c = request.IT_Support_Required_to_Install_Programs__c;
		tms.Master_Account_EB_Number__c = m_helper.getFeeAccount(container.pm.serviceAccountPms);
		tms.Account_Setup__c = request.Account_Setup__c;

		tms.Positive_Pay_Client__c = request.Positive_Pay_Client__c;
		tms.Software_Version__c = request.Software_Version__c;
		tms.Total_Number_of_Open_Bills_in_QB__c = request.Total_Number_of_Open_Bills_in_QB__c;
		tms.Total_Number_of_Vendors_in_QB__c = request.Total_Number_of_Vendors_in_QB__c;
		tms.Two_Signatures_Required__c = request.Two_Signatures_Required__c;
		tms.Service_Notes__c = request.Notes__c;

		tms.EAP_Monthly_Fee_Actual__c = getMonthlyFee(request);
		tms.EAP_Setup_Fee_Actual__c = getSetupFee(request);
		tms.Monthly_Fee__c = tms.EAP_Monthly_Fee_Actual__c;
		tms.Annual_Fee__c = m_helper.annualFee(tms.EAP_Monthly_Fee_Actual__c);

        return tms;
	}

	private string getAccountSystem(Tm_Service_Request__c req) {
		if(req.None__c == true) return m_config.NONE();
		if(req.Quickbooks_Peachtree__c == true) return m_config.QUICKBOOKS_PEACHTREE();
		if(req.Dynamics_NetSuite_Intaact__c == true) return m_config.DYNAMICS_NETSUITE_INTAACT();
		if(req.SAP_ERP__c == true) return m_config.SAP_ERP();
		return '';
	}

	private decimal getSetupFee(Tm_Service_Request__c req) {
		if(req.None__c == true) return req.None_Setup__c;
		if(req.Quickbooks_Peachtree__c == true) return req.TM_Fee__c == true?  req.Quickbooks_Peachtree_Setup__c:req.Quickbooks_Peachtree_Setup_Custom__c;
		if(req.Dynamics_NetSuite_Intaact__c == true) return req.Dynamics_NetSuite_Intaact_Setup__c;
		if(req.SAP_ERP__c == true) return req.SAP_ERP_Setup__c;
		return 0.0;
	}

	private decimal getMonthlyFee(Tm_Service_Request__c req) {
		if(req.None__c == true) return req.None_Monthly__c;
		if(req.Quickbooks_Peachtree__c == true) return req.TM_Fee__c == true? req.Quickbooks_Peachtree_Monthly__c : req.Quickbooks_Peachtree_Monthly_Custom__c;
		if(req.Dynamics_NetSuite_Intaact__c == true) return req.Dynamics_NetSuite_Intaact_Monthly__c;
		if(req.SAP_ERP__c == true) return req.SAP_ERP_Monthly__c;
		return 0.0;
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
        	,'Default_Instructions__c'
        	,'Positive_Pay_Client__c'
        	,'Two_Signatures_Required__c'
        	,'Dual_Approval_for_Payments__c'
        	,'Software_Version__c'
        	,'ACH_Credit_Card_Payment_Per_Item_Fee__c'
			,'ACH_Credit_Card_Payment_Per_Item_Custom__c'
			,'Check_Payment_Per_Item_Fee__c'
			,'Check_Payment_Per_Item_Fee_Custom__c'
			,'Invoice_Payment_Per_Item__c'
			,'Invoice_Payment_Per_Item_Custom__c'
			,'Network_Setup__c'
        	,'IT_Support_Required_to_Install_Programs__c'
        	,'Total_Number_of_Open_Bills_in_QB__c'
        	,'Total_Number_of_Vendors_in_QB__c'
			,'Account_Setup__c'
        	,'Check_EAP_Payment_Method__c'
        	,'ACH_EAP_Payment_Method__c'
        	,'Credit_P_Card_EAP_Payment_Method__c'
        	,'EAP_Daily_Limit_Check__c'
        	,'EAP_Daily_Limit_ACH__c'
        	,'EAP_Daily_Limit_Credit_P_Card__c'
        	,'Quickbooks_Peachtree_Setup__c'
        	,'Dynamics_NetSuite_Intaact_Setup__c'
        	,'SAP_ERP_Setup__c'
        	,'Quickbooks_Peachtree_Monthly__c'
        	,'Dynamics_NetSuite_Intaact_Monthly__c'
			,'Quickbooks_Peachtree_Setup_Custom__c'
			,'Quickbooks_Peachtree_Monthly_Custom__c'
        	,'SAP_ERP_Monthly__c'
            ,'None__c'
            ,'Quickbooks_Peachtree__c'
			,'Dynamics_NetSuite_Intaact__c'
			,'SAP_ERP__c'
			,'None_Monthly__c'
			,'None_Setup__c'
			,'Notes__c'
			,'Tm_Service_Request_Packet__r.Client_Type__c'
            ,'Tm_Service_Request_Packet__r.Bundle_Type__c'
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
            ,'EB_Account__r.Fee_Master_Account__c'
        	,'TM_Service_Request__c'
        	,'Account_Number_Title__c'
        	,'ACH_Originator_ID__c'
        	,'Controlled_Disbursment_Acct_Routing_Num__c'       
        	,'Daily_Deposit_Limit__c'
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
                        accountRel.Daily_Deposit_Limit__c = a.Daily_Deposit_Limit__c;
                        if(a.Product_Fee_Account__c == true || a.EB_Account__r.Fee_Master_Account__c == true) {
                            accountRel.Service_Charge__c = getMonthlyFee(pm.requestPm);
                        }
                        accountRel.Product_Fee_Account__c = a.Product_Fee_Account__c;
                        accountRel.Master_Account__c = a.EB_Account__r.Fee_Master_Account__c;
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