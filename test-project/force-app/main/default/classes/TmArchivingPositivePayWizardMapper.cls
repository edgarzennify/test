public class TmArchivingPositivePayWizardMapper implements TmArchiving.IMapper{
     private final TmArchiving.IMapperHelper m_helper;
	private final TmArchiving.IConfiguration m_config;

	public TmArchivingPositivePayWizardMapper(TmArchiving.IMapperHelper helper, TmArchiving.IConfiguration config) {
		m_helper = helper;
		m_config = config;
	}

	public String handle() {
		return m_config.RECORDTYPE_POSITIVE_PAY();
	}

    public Treasury_Management__c buildTmService(TmArchiving.MapperRequestContainer container) {
		Treasury_Management__c tms = m_Helper.buildTMObject(container, m_config.RECORDTYPE_POSITIVE_PAY());
		
		Tm_Service_Request__c request = container.Pm.requestPm;
        if(request.File_Automation_Wizard_Set_Up__c != true){
            return null;
        }

		tms.Product_PL__c = m_config.SVC_PRODUCT_POSITIVE_PAY_FILE_WIZARD();

		if(tms.Account__r != null){
			tms.Account__r.Accounting_Package__c = getAccountingPackage(request);
		}
				
		tms.Live_Date__c = request.Live_Date__c;
		tms.PosPay_Default_Instructions__c = request.Default_Instructions__c;
		tms.Service_Notes__c = request.Notes__c;
		tms.Master_Account_EB_Number__c = m_helper.getFeeAccount(container.pm.serviceAccountPms);
		tms.Exception_Items_Actual__c = getExceptionFeePerItem(request);
		tms.Per_Item_Fee_Actual__c = getPerItemFeeActual(request);
		tms.Positive_Pay_Actual__c = getPositivePayActual(request);
		if(request.TM_Fee__c = true){
			tms.File_Creation_Wizard_Actual__c =  request.PP_File_Creation_Wizard_Fee__c; 
			tms.Implementation_Setup_Fee_Actual__c = request.PP_Implementation_Setup_Fee__c;
		}
		if(request.Custom_Fee__c = true){
			tms.File_Creation_Wizard_Actual__c =  request.PP_File_Creation_Wizard_Fee_Custom__c; 
			tms.Implementation_Setup_Fee_Actual__c = request.PP_Implementation_Setup_Fee_Custom__c;
		}

		tms.Monthly_Fee__c = tms.Positive_Pay_Actual__c;
        tms.Annual_Fee__c = m_helper.annualFee(tms.Positive_Pay_Actual__c); 
		return tms;
	}


	private string getAccountingPackage(Tm_Service_Request__c request) {
		if (m_helper.compare(request.Accounting_Software_Type__c.toLowerCase() , m_config.OTHER().toLowerCase())) {
			return request.Other_Software__c;
		}else {
			return request.Accounting_Software_Type__c;
		}
	}

	private decimal getPositivePayActual(Tm_Service_Request__c req) {
		return req.TM_Fee__c == true? req.Conventional_Positive_Pay_Fee__c:req.Conventional_Positive_Pay_Fee_Custom__c;
	}

	private decimal getPerItemFeeActual(Tm_Service_Request__c req) {
		return req.TM_Fee__c == true? req.Conventional_PP_Per_Items_Fee__c: req.Conventional_PP_Per_Items_Fee_Custom__c;
	}

	private decimal getExceptionFeePerItem(Tm_Service_Request__c req) {
		return req.TM_Fee__c == true? req.Conventional_PP_Exception_Items_Fee__c: req.Conventional_PP_Exception_Items_Custom__c;
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
        	,'PP_Issue_File_Delivery_Automation_Fee__c'
        	,'PP_File_Creation_Wizard_Fee__c'
        	,'PP_Implementation_Setup_Fee__c'
        	,'PP_Automation_Setup_Fee__c'
        	,'Positive_Pay_Type__c'
        	,'Conventional_Positive_Pay_Fee__c'
        	,'Payee_Positive_Pay_Fee__c'
        	,'Reverse_Positive_Pay_fee__c'
        	,'Conventional_PP_Per_Items_Fee__c'
        	,'Payee_PP_Per_Items_Fee__c'
        	,'Reverse_PP_Per_Item_Fee__c'
        	,'Conventional_PP_Exception_Items_Fee__c'
        	,'Payee_PP_Exception_Items_Fee__c'
        	,'Reverse_PP_Exception_Items_Fee__c'
            ,'Accounting_Software_Type__c'
			,'Other_Software__c'
			,'Live_Date__c'
            ,'File_Automation_Wizard_Set_Up__c'
			,'Conventional_Positive_Pay_Fee_Custom__c'
			,'Conventional_PP_Per_Items_Fee_Custom__c'
			,'Conventional_PP_Exception_Items_Custom__c'
			,'PP_File_Creation_Wizard_Fee_Custom__c'
			,'PP_Implementation_Setup_Fee_Custom__c'
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
        	,'User_Role__c'
        	,'OLB_Supervisor__c'
        	,'Access_Level__c'
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

    public List<TM_Service_Contact__c> buildContacts(TmBoarding.RequestPm pm, Treasury_Management__c tm) {
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
                        	accountRel.Service_Charge__c = getPositivePayActual(pm.requestPm);
						}else{
							accountRel.Service_Charge__c = 0.0;
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