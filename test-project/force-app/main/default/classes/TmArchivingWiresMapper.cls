public class TmArchivingWiresMapper implements TmArchiving.IMapper {

	private final TmArchiving.IMapperHelper m_helper;
	private final TmArchiving.IConfiguration m_config;

	public TmArchivingWiresMapper(TmArchiving.IMapperHelper helper, TmArchiving.IConfiguration config) {
		m_helper = helper;
		m_config = config;
	}

	public String handle() {
		return m_config.RECORDTYPE_WIRES();
	}

    public Treasury_Management__c buildTmService(TmArchiving.MapperRequestContainer container) {
		
		Tm_Service_Request__c request = container.Pm.requestPm;

		if ((request.Domestic_Wires__c == null ||request.Domestic_Wires__c == false) && (request.International_Wires__c == null && request.International_Wires__c == false)) {
			return null;
		}
		Treasury_Management__c tms = m_Helper.buildTMObject(container, m_config.RECORDTYPE_WIRES());
		tms.Domestic_Wire_Limit__c = request.Domestic_Daily_Limit__c;
		tms.Domestic_Wires__c = request.Domestic_Wires__c;
		tms.Dual_Authorization__c = request.Wires_Dual_Authorization__c;
		tms.International_Wire_Limit__c = request.Int_l_Daily_Limit__c;
		tms.International_Wires__c = request.International_Wires__c;
		tms.Service_Notes__c = request.Notes__c;
		tms.Master_Account_EB_Number__c = m_helper.getFeeAccount(container.pm.serviceAccountPms);

		if(request.TM_Fee__c == true){
			tms.Outgoing_Domestic_Wires_Actual__c = request.Outgoing_Domestic_Wires_Fees__c;
			tms.Outgoing_International_Wires_Actual__c = request.Outgoing_International_Wires_Fees__c;
			tms.Wire_Transfer_Module_Actual__c = request.Wire_Transfer_Module_Fees__c;
			tms.Monthly_Fee__c = request.Wire_Transfer_Module_Fees__c;
			tms.Annual_Fee__c = m_helper.annualFee(request.Wire_Transfer_Module_Fees__c); 
		}
		if(request.Custom_Fee__c == true){
			tms.Outgoing_Domestic_Wires_Actual__c = request.Outgoing_Domestic_Wires_Fees_Custom__c;
			tms.Outgoing_International_Wires_Actual__c = request.Outgoing_International_Wires_Fees_Custom__c;
			tms.Wire_Transfer_Module_Actual__c = request.Wire_Transfer_Module_Fees_Custom__c;
			tms.Monthly_Fee__c = request.Wire_Transfer_Module_Fees_Custom__c;
			tms.Annual_Fee__c = m_helper.annualFee(request.Wire_Transfer_Module_Fees_Custom__c); 
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
        	,'Domestic_Wires__c'
    		,'Bundle_Types__c'
    		,'International_Wires__c'
    		,'Wires_Dual_Authorization__c'
    		,'Domestic_Daily_Limit__c'
    		,'Int_l_Daily_Limit__c'
    		,'Wire_Transfer_Fee__c'
    		,'Wire_Transfer_Module_Fees__c'
    		,'Outgoing_Domestic_Wires_Fees__c'
    		,'Outgoing_International_Wires_Fees__c'
			,'Wire_Transfer_Module_Fees_Custom__c'
			,'Outgoing_Domestic_Wires_Fees_Custom__c'
			,'Outgoing_International_Wires_Fees_Custom__c'
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
        	,'Sweep_Investment_Account_Number__c'       
        	,'Daily_Deposit_Limit__c'
        	,'Daily_Dollar_Limit__c'
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
                    accountRel.Product_Fee_Account__c = a.Product_Fee_Account__c;
                    accountRel.Master_Account__c = a.EB_Account__r.Fee_Master_Account__c;
					if(a.Product_Fee_Account__c == true || a.EB_Account__r.Fee_Master_Account__c == true) {
                        accountRel.Service_Charge__c = pm.requestPm.TM_Fee__c == true ? pm.requestPm.Wire_Transfer_Module_Fees__c : pm.requestPm.Wire_Transfer_Module_Fees_Custom__c ;
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