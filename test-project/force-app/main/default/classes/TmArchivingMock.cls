public class TmArchivingMock {
    public class ofIDataProvider extends ApexMoq implements TmArchiving.IDataProvider{ 
        public EB_Industry_Code__c getIndustryIdFromCode(string industryCode){
            return (EB_Industry_Code__c) handleMethodInvocation('getIndustryIdFromCode',  new List<Object>{industryCode});
        }
        public List<Tm_Service_Request_Archive__c> getArchives(string requestId) {
            return (List<Tm_Service_Request_Archive__c>)handleMethodInvocation('getArchives', new List<Object>{requestId});
        }
    }
    public class ofIRepository extends ApexMoq implements TmArchiving.IREpository {
        public DmIndustryCode getIndustryIdFromCode(String industryCode){
            return (DmIndustryCode)handleMethodInvocation('getIndustryIdFromCode', new List<OBject>{industryCode});
        }
        public List<DmTmArchive> getArchives(String tmRequestId) {
            return (List<DmTmArchive>)handleMethodInvocation('getArchives', new List<Object>{tmRequestId});
        }
    }
	public class ofIMapper extends ApexMoq implements TmArchiving.IMapper {
		public String handle() {
			return (String)handleMethodInvocation('handle');
		}
        public Treasury_Management__c buildTmService(TmArchiving.MapperRequestContainer container){
            return (Treasury_Management__c)handleMethodInvocation('buildTmService', new List<Object>{container});
        }
        public TmArchiving.QueryFields build(Id requestId) {
            return (TmArchiving.QueryFields)handleMethodInvocation('build', new List<Object>{requestId});
        }
        public List<TM_Service_Contact__c> buildContacts(TmBoarding.RequestPm pm, Treasury_Management__c tm) {
            return (List<TM_Service_Contact__c>)handleMethodInvocation('buildContacts', new List<Object>{pm, tm});
        }
        public List<EB_Account_Service__c> buildAccounts(Tmboarding.RequestPm pm, Treasury_Management__c tm) {
            return (List<EB_Account_Service__c>)handleMethodInvocation('buildAccounts', new List<Object>{pm, tm});
        }
        public List<TmArchiving.TreasuryManagementSm> postProcess(List<TmArchiving.TreasuryManagementSm> sms, Tmboarding.RequestPm pm){
            return (List<TmArchiving.TreasuryManagementSm>)handleMethodInvocation('postProcess', new List<Object>{sms, pm});
        }
	}

	public class ofIMapperHelper extends ApexMoq implements TmArchiving.IMapperHelper {
        public Treasury_Management__c buildTMObject(TmArchiving.MapperRequestContainer container, String recordName) {
        	return (Treasury_Management__c)handleMethodInvocation('buildTMObject', new List<Object>{container, recordName});
        }
        public Boolean compare(string item, string compareTo) {
            return (Boolean)handleMethodInvocation('compare', new List<Object>{item, compareTo});
        }
        public Id getFeeAccount(List<Tm_Service_Request_Account__c> relatedAccounts) {
            return (Id)handleMethodInvocation('getFeeAccount', new List<Object>{relatedAccounts});
        }
        public Eb_Account__c getMasterAccount(List<Tm_Service_Request_Account__c> relatedAccounts){
            return (Eb_Account__c)handleMethodInvocation('getMasterAccount', new List<OBject>{relatedAccounts});
        }
        public Tm_Service_Request_Account__c getSweepAccount(List<Tm_Service_Request_Account__c> relatedAccounts) {
            return (Tm_Service_Request_Account__c)handleMethodInvocation('getSweepAccount', new List<Object>{relatedAccounts});
        }
        public Decimal getDailyLimit(TmBoarding.RequestPm request) {
            return (Decimal)handleMethodInvocation('getDailyLimit', new List<Object>{request});
        }
        public Boolean getObjectValue_bool(TM_Service_Request_Contact__c c, String fieldName) {
            return (Boolean)handleMethodInvocation('getObjectValue_bool', new List<OBject>{c, fieldName});
        }
        public String getObjectValue_string(TM_Service_Request_Contact__c c, String fieldName) {
            return (String)handleMethodInvocation('getObjectValue_string', new List<Object>{c, fieldName});
        }
        public Decimal annualFee(Decimal monthlyFee) {
            return (Decimal)handleMethodInvocation('annualFee', new List<OBject>{monthlyFee});
        }
        public Contact getPrimaryContact(List<Tm_Service_Request_Contact__c> contacts) {
            return (Contact)handleMethodInvocation('getPrimaryContact', new List<Object>{contacts});
        }
        public Eb_Account__c getLoanAccount(TmBoarding.RequestPm r) {
            return (Eb_Account__c)handleMethodInvocation('getLoanAccount', new List<OBject>{r});
        }
        public string concatenate(string text, integer size){
            return (string)handleMethodInvocation('concatenate', new List<Object>{text, size});
        }
	}

    public class ofIVmBuilder extends ApexMoq implements TmArchiving.IVmBuilder{
        public List<TmArchiving.ArchiveLayout> build(List<DmTmArchive> dms){
            return (List<TmArchiving.ArchiveLayout>)handleMethodInvocation('build', dms);
        }
    }

    public class ofIZbaMapperHelper extends ApexMoq implements TmArchiving.IZbaMapperHelper {
        public List<TmArchiving.TreasuryManagementSm> splitAccountRelationshipsByMaster(TmArchiving.TreasuryManagementSm sm){
            return (List<TmArchiving.TreasuryManagementSm>)handleMethodInvocation('splitAccountRelationshipsByMaster', new List<Object>{sm});
        }
    }

    public class ofIOnlineBankingMapperHelper extends ApexMoq implements TmArchiving.IOnlineBankingMapperHelper {
        public TmBoarding.RequestPm getAchRequestPm(TmArchiving.MapperRequestContainer container){
            return (TmBoarding.RequestPm)handleMethodInvocation('getAchRequestPm', new List<Object>{container});
        }
        public TmBoarding.RequestPm getWiresRequestPm(TmArchiving.MapperRequestContainer container){
            return (TmBoarding.RequestPm)handleMethodInvocation('getWiresRequestPm', new List<Object>{container});
        }
    }

	public class ofISmManager extends ApexMoq implements TmArchiving.ISmManager {
		public List<SObject> getTms(List<TmArchiving.TreasuryManagementSm> sms) {
			return (List<SObject>)handleMethodInvocation('getTms', new List<Object>{sms});
		}

    	public List<SObject> getContactsAndAccounts(List<TmArchiving.TreasuryManagementSm> sms) {
			return (List<SObject>)handleMethodInvocation('getContactsAndAccounts', new List<Object>{sms});
		}

		public List<SObject> getEntities(List<TmArchiving.TreasuryManagementSm> sms) {
			return (List<sObject>)handleMethodInvocation('getEntities', new List<Object>{sms});
		}

        public List<SObject> getArchives(String requestId, List<Treasury_Management__c> tmObjs){
            return (List<SObject>)handleMethodInvocation(requestId, tmObjs);
        }
	}

	public class ofIConfiguration extends ApexMoq implements TmArchiving.IConfiguration {
        public String GOLDMAN_SACHS(){
        	return (String)handleMethodInvocation('GOLDMAN_SACHS');
        }
        public String SWEEP_GOLDMAN_SACHS(){
        	return (String)handleMethodInvocation('SWEEP_GOLDMAN_SACHS');
        }
        public String MONEY_MARKET(){
        	return (String)handleMethodInvocation('MONEY_MARKET');
        }
        public String SWEEP_MONEY_MARKET(){
        	return (String)handleMethodInvocation('SWEEP_MONEY_MARKET');
        }
        public String OPTIMA_PLUS(){
        	return (String)handleMethodInvocation('OPTIMA_PLUS');
        }
        public String SWEEP_OPTIMA_PLUS(){
        	return (String)handleMethodInvocation('SWEEP_OPTIMA_PLUS');
        }
        public String REPO(){
        	return (String)handleMethodInvocation('REPO');
        }
        public String SWEEP_REPO(){
        	return (String)handleMethodInvocation('SWEEP_REPO');
        }
        public String CONVENTIONAL(){
        	return (String)handleMethodInvocation('CONVENTIONAL');
        }
        public String PAYEE(){
        	return (String)handleMethodInvocation('PAYEE');
        }
        public String REVERSE(){
        	return (String)handleMethodInvocation('REVERSE');
        }
        public String POSITIVE_PAY_CONVENTIONAL(){
        	return (String)handleMethodInvocation('POSITIVE_PAY_CONVENTIONAL');
        }
        public String POSITIVE_PAY_REVERSE(){
        	return (String)handleMethodInvocation('POSITIVE_PAY_REVERSE');
        }
        public String POSITIVE_PAY_PAYEE(){
        	return (String)handleMethodInvocation('POSITIVE_PAY_PAYEE');
        }
        public String REMOTE_DEPOSIT_DESKTOP(){
        	return (String)handleMethodInvocation('REMOTE_DEPOSIT_DESKTOP');
        }
        public String REMOTE_DEPOSIT_MOBILE(){
        	return (String)handleMethodInvocation('REMOTE_DEPOSIT_MOBILE');
        }
        public String NONE(){
        	return (String)handleMethodInvocation('NONE');
        }
        public String QUICKBOOKS_PEACHTREE(){
        	return (String)handleMethodInvocation('QUICKBOOKS_PEACHTREE');
        }
        public String DYNAMICS_NETSUITE_INTAACT(){
        	return (String)handleMethodInvocation('DYNAMICS_NETSUITE_INTAACT');
        }
        public String SAP_ERP(){
        	return (String)handleMethodInvocation('SAP_ERP');
        }
        public String ACCESS_SUPERVISOR(){
        	return (String)handleMethodInvocation('ACCESS_SUPERVISOR');
        }
        public String OLD_SUPERVISOR(){
        	return (String)handleMethodInvocation('OLD_SUPERVISOR');
        }
        public String ACCESS_LEVEL(){
        	return (String)handleMethodInvocation('ACCESS_LEVEL');
        }
        public String OTHER(){
            return (String)handleMethodInvocation('OTHER');
        }
        public String RECORDTYPE_ACH_DEBIT_FILTER(){
        	return (String)handleMethodInvocation('RECORDTYPE_ACH_DEBIT_FILTER');
        }
        public String RECORDTYPE_ACH_POSITIVE_PAY(){
            return (String)handleMethodInvocation('RECORDTYPE_ACH_POSITIVE_PAY');
        }
        public String RECORDTYPE_LOCKBOX(){
        	return (String)handleMethodInvocation('RECORDTYPE_LOCKBOX');
        }
        public String RECORDTYPE_LOCKBOX_REMITTANCE_IMAGING(){
            return (String)handleMethodInvocation('RECORDTYPE_LOCKBOX_REMITTANCE_IMAGING');
        }
        public String RECORDTYPE_LOCKBOX_DATA_REMITTANCE_MODULE(){
        	return (String)handleMethodInvocation('RECORDTYPE_LOCKBOX_DATA_REMITTANCE_MODULE');
        }
        public String RECORDTYPE_LOCKBOX_DATA_ENTRY_MODULE(){
        	return (String)handleMethodInvocation('RECORDTYPE_LOCKBOX_DATA_ENTRY_MODULE');
        }
        public String RECORDTYPE_LOCKBOX_DATA_EXTRACT_MODULE(){
        	return (String)handleMethodInvocation('RECORDTYPE_LOCKBOX_DATA_EXTRACT_MODULE');
        }
        public String RECORDTYPE_ONLINE_BANKING(){
        	return (String)handleMethodInvocation('RECORDTYPE_ONLINE_BANKING');
        }
        public String RECORDTYPE_ACH(){
        	return (String)handleMethodInvocation('RECORDTYPE_ACH');
        }
        public String RECORDTYPE_WIRES(){
        	return (String)handleMethodInvocation('RECORDTYPE_WIRES');
        }
        public String RECORDTYPE_CONTROLLED_DISBURSEMENT(){
        	return (String)handleMethodInvocation('RECORDTYPE_CONTROLLED_DISBURSEMENT');
        }
        public String RECORDTYPE_EDI(){
        	return (String)handleMethodInvocation('RECORDTYPE_EDI');
        }
        public String RECORDTYPE_EB_ROM(){
        	return (String)handleMethodInvocation('RECORDTYPE_EB_ROM');
        }
        public String RECORDTYPE_ENTERPRISE_AUTOMATED_PAYABLES(){
        	return (String)handleMethodInvocation('RECORDTYPE_ENTERPRISE_AUTOMATED_PAYABLES');
        }
        public String RECORDTYPE_INVESTMENT_SWEEP(){
        	return (String)handleMethodInvocation('RECORDTYPE_INVESTMENT_SWEEP');
        }
        public String RECORDTYPE_LOAN_INVESTMENT_SWEEP(){
        	return (String)handleMethodInvocation('RECORDTYPE_LOAN_INVESTMENT_SWEEP');
        }
        public String RECORDTYPE_POSITIVE_PAY(){
        	return (String)handleMethodInvocation('RECORDTYPE_POSITIVE_PAY');
        }
        public String RECORDTYPE_REMIT_PLUS(){
        	return (String)handleMethodInvocation('RECORDTYPE_REMIT_PLUS');
        }
        public String RECORDTYPE_REMOTE_DEPOSIT(){
        	return (String)handleMethodInvocation('RECORDTYPE_REMOTE_DEPOSIT');
        }
        public String RECORDTYPE_ZBA(){
        	return (String)handleMethodInvocation('RECORDTYPE_ZBA');
        }
        public String RECORDTYPE_SVC_COMMERCIAL_ONLINE_BANKING(){
            return (String)handleMethodInvocation('RECORDTYPE_SVC_COMMERCIAL_ONLINE_BANKING');
        }
        public String RECORDTYPE_OTHER_TM_PRODUCT(){
            return (String)handleMethodInvocation('RECORDTYPE_OTHER_TM_PRODUCT');
        }
        public String RECORDTYPE_BUSINESS_BILL_PAY() {
            return (String)handleMethodInvocation('RECORDTYPE_BUSINESS_BILL_PAY');
        }
        public String ONLINE_BANKING_ACH_MODULE() {
            return (String)handleMethodInvocation('ONLINE_BANKING_ACH_MODULE');
        }
        public String SVC_PRODUCT_SAME_DAY_ACH() {
            return (String)handleMethodInvocation('SVC_PRODUCT_SAME_DAY_ACH');
        }
        public String SVC_PRODUCT_ACH_RETURN_TRANSMISSION() {
            return (String)handleMethodInvocation('SVC_PRODUCT_ACH_RETURN_TRANSMISSION');
        }
        public String SVC_PRODUCT_ACH_FTP(){
            return (String)handleMethodInvocation('SVC_PRODUCT_ACH_FTP');
        }
        public String SVC_PRODUCT_POSITIVE_PAY_FILE_WIZARD() {
            return (String)handleMethodInvocation('SVC_PRODUCT_POSITIVE_PAY_FILE_WIZARD');
        }
        public String SVC_PRODUCT_POSITIVE_PAY_AUTOMATION() {
            return (String)handleMethodInvocation('SVC_PRODUCT_POSITIVE_PAY_AUTOMATION');
        }
        public String SVC_PRODUCT_OTHER() {
            return (String)handleMethodInvocation('SVC_PRODUCT_OTHER');
        }
    }

    public static List<string> getErrorsOnRunningSoql(TmArchiving.IMapper mapper){
        Id requestId = ObjectFactory.getFakeId(Tm_Service_Request__c.SObjectType, '1');
		List<string> errors = new List<string>();
		TmArchiving.QueryFields qrSvc = mapper.build(requestId);
		List<sObject> results = new List<sObject>();
		string serviceQuery = '';
		string contactQuery = '';
		string accountQuery = '';
		string tmcontactQuery = '';
		string tmaccountQuery = '';
		try{
			serviceQuery = 'SELECT ';
			serviceQuery         += String.Join(qrSvc.requestFields, ',');
			serviceQuery        += ' FROM TM_Service_Request__c LIMIT 1';
			results = Database.query(serviceQuery);
		}catch(exception ex){
			errors.add(ex.getMessage());
		}
		try{
			contactQuery = 'SELECT ';
			contactQuery += String.Join(qrSvc.contactCoreFields, ',');
			contactQuery += ' FROM Contact LIMIT 1';
			results = Database.query(contactQuery);
		}catch(exception ex){
			errors.add(ex.getMessage());
		}
		try{
			accountQuery = 'SELECT ';
			accountQuery += String.Join(qrSvc.accountCoreFields, ',');
			accountQuery += ' FROM EB_Account__c LIMIT 1';
			results = Database.query(accountQuery);
		}catch(exception ex){
			errors.add(ex.getMessage());
		}
		try{
			tmcontactQuery = 'SELECT ';
			tmcontactQuery += String.Join(qrSvc.contactFields, ',');
			tmcontactQuery += ' FROM Tm_Service_Request_Contact__c LIMIT 1';
			results = Database.query(tmcontactQuery);
		}catch(exception ex){
			errors.add(ex.getMessage());
		}
		try{
			tmaccountQuery = 'SELECT ';
			tmaccountQuery += String.Join(qrSvc.accountFields, ',');
			tmaccountQuery += ' FROM Tm_Service_Request_Account__c LIMIT 1';
			results = Database.query(tmaccountQuery);
		}catch(exception ex){
			errors.add(ex.getMessage());
		}
        return errors;
    }
}