public class TmArchivingOnlineBankingMapper implements TmArchiving.IMapper {
  	
    private string USER = 'User';
    private string SUPERVISOR = 'Supervisor';
    private string COMMERCIAL_BANKING = 'Commercial Banking';
    private string CORPORATE_OLB = 'Corporate OLB';
    private string BUSINESS_BANKING = 'Business Banking';

  	private final TmArchiving.IMapperHelper m_helper;
	private final TmArchiving.IConfiguration m_config;
    private final TmArchiving.IOnlineBankingMapperHelper m_olbHelper;

    public TmArchivingOnlineBankingMapper(){
        
    }
	public TmArchivingOnlineBankingMapper(TmArchiving.IMapperHelper helper, TmArchiving.IConfiguration config,
        TmArchiving.IOnlineBankingMapperHelper olbHelper) {
		m_helper = helper;
		m_config = config;
        m_olbHelper = olbHelper;
	}

	public string handle() {
		return m_config.RECORDTYPE_ONLINE_BANKING();
	}

	public Treasury_Management__c buildTmService(TmArchiving.MapperRequestContainer container) {
		Tm_Service_Request__c olbRequest = container.Pm.requestPm;
        TmBoarding.RequestPm achRequestPm = m_olbHelper.getAchRequestPm(container);
        TM_Service_Request__c achRequest = achRequestPm == null ? null : achRequestPm.requestPm;
        TmBoarding.RequestPm wiresRequestPm = m_olbHelper.getWiresRequestPm(container);
        TM_Service_Request__c wiresRequest = wiresRequestPm == null ? null : wiresRequestPm.requestPm;

		Treasury_Management__c tms = m_helper.buildTmObject(container, m_config.RECORDTYPE_SVC_COMMERCIAL_ONLINE_BANKING());

        String ClientType = olbRequest.TM_Service_Request_Packet__r.Client_Type__c;
        if(ClientType == COMMERCIAL_BANKING || ClientType == CORPORATE_OLB){
            tms.Commercial_Bill_Pay__c = olbRequest.Commercial_Bill_Pay__c;
            tms.Tax_Payments__c = olbRequest.Tax_Payments__c;
            tms.Pricing_Packages__c = olbRequest.TM_Service_Request_Packet__r.Bundle_Type__c;
        }

        if(ClientType == BUSINESS_BANKING){
            tms.Commercial_Bill_Pay__c = olbRequest.Commercial_Bill_Pay_BB__c;
            tms.Tax_Payments__c = olbRequest.Tax_Payments_BB__c;
        }

        Decimal olbFee = olbRequest.TM_Fee__c == true? olbRequest.Corporate_Online_Banking_Platform_Fee__c : olbRequest.Corporate_Online_Banking_Platform_Custom__c;
        if(ClientType == CORPORATE_OLB){
            tms.Monthly_Fee__c = olbFee;
            tms.Corp_Online_Banking_Platform_Actual__c = olbFee;          
        }else{
            tms.Commercial_Bill_Pay_Module_Actual__c = olbFee;
        }
        tms.Annual_Fee__c = m_helper.annualFee(olbFee);

       
        tms.Master_Account_EB_Number__c = m_helper.getFeeAccount(container.pm.serviceAccountPms);
        tms.Payroll__c = olbRequest.Payroll__c;
        tms.Previous_Current_Day_Module_Actual__c = olbRequest.TM_Fee__c == true? olbRequest.OLB_Previous_Current_Day_Module_Fee__c : olbRequest.OLB_Previous_Current_Day_Module_Custom__c;
		tms.Product_PL__c = m_config.RECORDTYPE_ONLINE_BANKING();
        tms.Security_Token_Monthly_Fee_per_User_A__c = olbRequest.TM_Fee__c == true? olbRequest.Secure_Token_Monthly_Fee_Per_User_Fee__c : olbRequest.Secure_Token_Monthly_Fee_Per_User_Custom__c;
        tms.Bundle_Fee__c = olbRequest.TM_Fee__c == true?olbRequest.Bundle_Fee__c : olbRequest.Bundle_Fee_Custom__c;
        tms.Dual_Authorization__c = olbRequest.OLB_Dual_Authorization__c;
		tms.Service_Notes__c = olbRequest.Notes__c;
        tms.Rights_to_Add_Delete_OLB_users__c = olbRequest.Rights_to_Add_Delete_OLB_users__c;

        boolean achDualAuth = false;
        boolean wiresDualAuth = false;
        if (achRequest != null) {
            tms.ACH_Pass_Thru__c = achRequest.ACH_Pass_Thru__c;
            tms.ACH_Payments__c = achRequest.ACH_Payment__c;
            tms.ACH_Receipts__c = achRequest.ACH_Single_Receipts__c;
            tms.ACH_Single_Payments__c = achRequest.ACH_Single_Payment__c;
            tms.Collections__c = achRequest.ACH_Collections__c;
            tms.Payroll__c = achRequest.Payroll__c;
            achDualAuth = achRequest.ACH_Dual_Authorization__c;
        }

        if(wiresRequest != null){
            tms.Domestic_Wires__c = wiresRequest.Domestic_Wires__c;
            tms.International_Wires__c = wiresRequest.International_Wires__c;
            wiresDualAuth = wiresRequest.Wires_Dual_Authorization__c;
        }

        if(achDualAuth == true && wiresDualAuth == true){
            tms.Dual_Control__c = true;
        }


        return tms;
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
            ,'Bundle_Fee__c'
            ,'Bundle_Fee_Custom__c'
            ,'OLB_Previous_Current_Day_Module_Fee__c'
            ,'Commercial_Banking__c'
            ,'Commercial_Bill_Pay__c'
            ,'Business_Banking__c'
            ,'Tax_Payments__c'
            ,'Bundle_Types__c'
            ,'Commercial_Bill_Pay_Module_Fee__c'
            ,'Corporate_Online_Banking_Platform_Fee__c'
            ,'Secure_Token_Monthly_Fee_Per_User_Fee__c'
            ,'Corporate_Online_Banking_Platform_Custom__c'
            ,'Secure_Token_Monthly_Fee_Per_User_Custom__c'
            ,'OLB_Previous_Current_Day_Module_Custom__c'
            ,'Commercial_Bill_Pay_Module_Fee_Custom__c'
            ,'Payroll__c'
            ,'Corporate_OLB__c'
            ,'Commercial_Bill_Pay_BB__c'
            ,'Tax_Payments_BB__c'
            ,'OLB_Dual_Authorization__c'
            ,'Notes__c'
            ,'Tm_Service_Request_Packet__r.Client_Type__c'
            ,'Tm_Service_Request_Packet__r.Bundle_Type__c'
            ,'Rights_to_Add_Delete_OLB_users__c'
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
        	,'EB_Account__c'
        	,'EB_Account__r.Name'
            ,'EB_Account__r.Fee_Master_Account__c'
        	,'TM_Service_Request__c'
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
                    if(a.Product_Fee_Account__c == true || a.EB_Account__r.Fee_Master_Account__c == true) {
                        accountRel.Service_Charge__c = pm.requestPm.TM_Fee__c == true? pm.requestPm.Corporate_Online_Banking_Platform_Fee__c : pm.requestPm.Corporate_Online_Banking_Platform_Custom__c;
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