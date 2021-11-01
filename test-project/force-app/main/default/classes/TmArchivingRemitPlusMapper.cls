public class TmArchivingRemitPlusMapper implements TmArchiving.IMapper {

	private final TmArchiving.IMapperHelper m_helper;
	private final TmArchiving.IConfiguration m_config;
	private final TmArchiving.IRepository m_repository;

	public TmArchivingRemitPlusMapper(TmArchiving.IMapperHelper helper, TmArchiving.IConfiguration config, TmArchiving.IRepository repository) {
		m_helper = helper;
		m_config = config;
		m_repository = repository;
	}
	
	public String handle() {
		return m_config.RECORDTYPE_REMIT_PLUS();
	}

	public Treasury_Management__c buildTmService(TmArchiving.MapperRequestContainer container) {
		Tm_Service_Request__c request = container.Pm.requestPm;
		Treasury_Management__c tms = m_Helper.buildTMObject(container, m_config.RECORDTYPE_REMIT_PLUS());

		tms.Installation_Issues__c = request.Installation_Issues__c;

		tms.Master_Account_EB_Number__c = m_helper.getFeeAccount(container.pm.serviceAccountPms);
		
		DmIndustryCode industryCode = request.NAICS_Industry__c == null ?null: getIndustryIdFromCode(request.NAICS_Industry__c);
		
		tms.NAICS_Industry__c = industryCode == null? null: industryCode.id;

		tms.NAICS_Sector__c = request.NAICS_Sector__c != null && request.NAICS_Sector__c.isNumeric()? Decimal.valueOf(request.NAICS_Sector__c):null;
		tms.Number_of_Scanners__c = request.Number_of_Scanners__c;
		Decimal dailyLimit = m_helper.getDailyLimit(container.pm);
		tms.Remit_Plus_Daily_Deposit_Limit__c = dailyLimit;

		tms.Scanner_Model__c = request.Scanner_Model__c;
		tms.Scanner_Warranty__c = request.Scanner_Warranty__c;
		tms.Service_Notes__c = request.Notes__c;
		
		if(request.TM_Fee__c == true){					
			tms.Items_Processed_Scanned_Actual__c = request.RemitPlus_Items_Processed_Scanned_fee__c;
			tms.Monthly_Fee__c = request.RemitPlus_Maintenance_Fee__c;
			tms.Hardware_Installation_Fee_Actual__c = request.RemitPlus_Hardware_Installation_Fee__c;
			tms.Setup_Fee_Actual__c = request.RemitPlus_Setup_Fee__c;
			tms.Remit_Plus_Maintenance_Fee_Actual__c = request.RemitPlus_Maintenance_Fee__c;
			tms.Annual_Fee__c = m_helper.annualFee(request.RemitPlus_Maintenance_Fee__c); 
		}

		if(request.Custom_Fee__c == true){
			tms.Hardware_Installation_Fee_Actual__c = request.RemitPlus_Hardware_Installation_Custom__c;
			tms.Installation_Hardware_Cost__c = request.RemitPlus_Hardware_Installation_Custom__c;
			tms.Items_Processed_Scanned_Actual__c = request.RemitPlus_Items_Processed_Scanned_Custom__c;
			tms.Remit_Plus_Maintenance_Fee_Actual__c = request.RemitPlus_Maintenance_Fee_Custom__c;
			tms.Setup_Fee_Actual__c = request.RemitPlus_Setup_Fee_Custom__c;
			tms.Monthly_Fee__c = request.RemitPlus_Maintenance_Fee_Custom__c;
			tms.Annual_Fee__c = m_helper.annualFee(request.RemitPlus_Maintenance_Fee_Custom__c); 
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
                	,'Scanner_Model__c'
                	,'Total_Amount_Due_Remit_Plus__c'
                	,'Number_of_Scanners__c'
                	,'Scanner_Warranty__c'
                	,'Installation_Issues__c'
                	,'RemitPlus_Items_Processed_Scanned_fee__c'
                	,'RemitPlus_Maintenance_Fee__c'
                	,'RemitPlus_Hardware_Installation_Fee__c'
                	,'RemitPlus_Setup_Fee__c'
					,'NAICS_Industry__c'
					,'NAICS_Sector__c'
					,'RemitPlus_Hardware_Installation_Custom__c'
					,'RemitPlus_Setup_Fee_Custom__c'
					,'RemitPlus_Items_Processed_Scanned_Custom__c'
					,'RemitPlus_Maintenance_Fee_Custom__c'
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
                    accountRel.Daily_Deposit_Limit__c = a.Daily_Deposit_Limit__c;
                    accountRel.Product_Fee_Account__c = a.Product_Fee_Account__c;
                    accountRel.Master_Account__c = a.EB_Account__r.Fee_Master_Account__c;
					if(a.Product_Fee_Account__c == true || a.EB_Account__r.Fee_Master_Account__c == true) {
                        accountRel.Service_Charge__c = pm.requestPm.TM_Fee__c == true? pm.requestPm.RemitPlus_Maintenance_Fee__c : pm.requestPm.RemitPlus_Maintenance_Fee_Custom__c ;
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

	private DmIndustryCode getIndustryIdFromCode(String industryCode){					
		return m_repository.getIndustryIdFromCode(industryCode);
	}
}