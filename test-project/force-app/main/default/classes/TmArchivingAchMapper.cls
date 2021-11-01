public class TmArchivingAchMapper implements TmArchiving.IMapper {
	private final TmArchiving.IMapperHelper m_helper;
	private final TmArchiving.IConfiguration m_config;

	public TmArchivingAchMapper(TmArchiving.IMapperHelper helper, TmArchiving.IConfiguration config) {
		m_helper = helper;
		m_config = config;
	}

	public string handle() {
		return m_config.RECORDTYPE_ACH();
	}

    public Treasury_Management__c buildTmService(TmArchiving.MapperRequestContainer container) {
		
		Tm_Service_Request__c request = container.Pm.requestPm;

		if((request.ACH_Credits__c == null || request.ACH_Credits__c == false) && 
			(request.ACH_Debits__c == null || request.ACH_Debits__c == false)){return null;}

		Treasury_Management__c tms = m_helper.buildTmObject(container, m_config.RECORDTYPE_ACH());

		tms.ACH_Credit_Limit__c = request.ACH_Credits_Daily_Limit__c;
		tms.ACH_Credit_Purpose__c = m_helper.concatenate(request.ACH_Credits_Origination_Purpose__c,99);
		tms.ACH_Credits__c = request.ACH_Credits__c;
		tms.ACH_Debit_Limit__c = request.ACH_Debits_Daily_Limit__c;
		tms.ACH_Debits__c = request.ACH_Debits__c;
		tms.ACH_Files_Transmitted_Actual__c = request.ACH_Files_Transmitted_Fee__c;
		tms.ACH_Items_Originated_Actual__c = request.ACH_Items_Originated_Fees__c;
		tms.ACH_Module_Maintenance_Fee_Actual__c = request.ACH_Module_Maintenance_Fee__c;
		tms.ACH_Monthly_Credit_Limit__c = request.ACH_Credits_Monthly_Limit__c;
		tms.ACH_Monthly_Debit_Limit__c = request.ACH_Debits_Monthly_Limit__c;
		tms.ACH_Purpose__c = m_helper.concatenate(request.ACH_Debits_Origination_Purpose__c,99);
		tms.ACH_Review_Date__c = request.ACH_Review_Date__c;
		tms.ACH_Review_Expiration__c = request.ACH_Review_Expiration__c;
		tms.Dual_Authorization__c = request.ACH_Dual_Authorization__c;
		tms.Implementation_Setup_Fee_Actual__c = request.ACH_Implementation_Setup_Fee__c;
		tms.Lending_Relationship_picklist__c = request.Lending_Relationship__c;
		tms.Master_Account_EB_Number__c = m_helper.getFeeAccount(container.pm.serviceAccountPms);
		tms.Notification_of_Change_Unauthorized_Act__c = request.Notification_of_Change_Unauthorized_Fee__c;
		
		if(request.TM_Fee__c){
			tms.Return_Fee_Actual__c = request.Return_Fee__c;
			tms.Return_Items_Reversals_NSF_etc_Act__c = request.Return_Items_Reversals_NSF_etc_Fee__c;			
        	tms.Monthly_Fee__c = request.ACH_Module_Maintenance_Fee__c;
        	tms.Annual_Fee__c = m_helper.annualFee(request.ACH_Module_Maintenance_Fee__c);
		}
		if(request.Custom_Fee__c){
			tms.Return_Fee_Actual__c = request.Return_Fee_Custom__c;
			tms.Return_Items_Reversals_NSF_etc_Act__c = request.Return_Items_Custom__c;			
        	tms.Monthly_Fee__c = request.ACH_Module_Maintenance_Fee_Custom__c;
        	tms.Annual_Fee__c = m_helper.annualFee(request.ACH_Module_Maintenance_Fee_Custom__c);
		}

		tms.Tier__c = request.Tier__c;
		tms.Total_ACH_Exposure__c = request.Total_ACH_Exposure__c;
        tms.Product_PL__c = m_config.ONLINE_BANKING_ACH_MODULE();
		tms.Type_of_Business__c = request.Type_of_Business__c;
        tms.Service_Notes__c = request.Notes__c;



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
        	,'Default_Instructions__c'
        	,'ACH_Fees__c'
        	,'ACH_Credits__c'
        	,'Bundle_Types__c'
        	,'ACH_Credits_Daily_Limit__c'
        	,'ACH_Credits_Monthly_Limit__c'
        	,'ACH_Debits__c'
        	,'ACH_Debits_Daily_Limit__c'
        	,'ACH_Debits_Monthly_Limit__c'
        	,'ACH_Dual_Authorization__c'
        	,'ACH_Review_Date__c'
        	,'Tier__c'
        	,'ACH_Review_Expiration__c'
        	,'Total_ACH_Exposure__c'
        	,'Lending_Relationship__c'
        	,'ACH_Credits_Origination_Purpose__c'
        	,'ACH_Debits_Origination_Purpose__c'
        	,'ACH_Module_Maintenance_Fee__c'
        	,'ACH_Items_Originated_Fees__c'
        	,'ACH_Files_Transmitted_Fee__c'
        	,'Return_Items_Reversals_NSF_etc_Fee__c'
        	,'Notification_of_Change_Unauthorized_Fee__c'
        	,'Return_Fee__c'
        	,'ACH_Implementation_Setup_Fee__c'
			,'Return_Fee_Custom__c'
			,'Return_Items_Custom__c'
			,'ACH_Module_Maintenance_Fee_Custom__c'
			,'ACH_Pass_Thru__c'
			,'Type_of_Business__c'
			,'ACH_Payment__c'
			,'ACH_Single_Receipts__c'
			,'ACH_Single_Payment__c'
			,'ACH_Collections__c'
			,'Payroll__c'
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
            ,'Contact__r.Primary_TM_Contact__c'
            ,'Contact__r.Secondary_TM_Contact__c'
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
					contactRel.Authorized_to_Receive_ACH_Return_Files__c = c.Authorized_to_Receive_Return_Files__c;
					contactRel.File_Total_Verification_User__c = c.File_Total_Verification_User__c;
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
                        accountRel.Service_Charge__c = pm.requestPm.ACH_Module_Maintenance_Fee__c;
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

	public string concatenate(string text, integer size){
		return String.isBlank(text)?text:text.substring(0,size-1);
	}
}