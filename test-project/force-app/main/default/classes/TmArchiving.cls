global class TmArchiving
{
    public interface IDataProvider {
        EB_Industry_Code__c getIndustryIdFromCode(String industryCode);
        List<Tm_Service_Request_Archive__c> getArchives(string requestId);
    }

    public interface IRepository {
        DmIndustryCode getIndustryIdFromCode(String industryCode);
        List<DmTmArchive> getArchives(String tmRequestId);
    }

    public interface IManager {
        List<TmArchiving.ArchiveReturn> buildTM(Tm_service_Request__c request);
        List<TmArchiving.ArchiveLayout> getArchives(Tm_Service_Request__c request);
    }
 
    public interface IMapper
    {
        String handle();
        Treasury_Management__c buildTmService(MapperRequestContainer container);
        TmArchiving.QueryFields build(Id requestId);
        List<TM_Service_Contact__c> buildContacts(TmBoarding.RequestPm pm, Treasury_Management__c tm);
        List<EB_Account_Service__c> buildAccounts(Tmboarding.RequestPm pm, Treasury_Management__c tm);
        List<TmArchiving.TreasuryManagementSm> postProcess(List<TmArchiving.TreasuryManagementSm> sms, Tmboarding.RequestPm pm);
    }

    public interface IMapperHelper {
        Treasury_Management__c buildTMObject(MapperRequestContainer container, String recordName);
        boolean compare(string item, string compareTo);
        Id getFeeAccount(List<Tm_Service_Request_Account__c> relatedAccounts);
        Eb_Account__c getMasterAccount(List<Tm_Service_Request_Account__c> relatedAccounts);
        Tm_Service_Request_Account__c getSweepAccount(List<Tm_Service_Request_Account__c> relatedAccounts);
        Decimal getDailyLimit(TmBoarding.RequestPm request);
        Boolean getObjectValue_bool(TM_Service_Request_Contact__c c, String fieldName);
        String getObjectValue_string(TM_Service_Request_Contact__c c, String fieldName);
        Decimal annualFee (Decimal monthlyFee);
        Contact getPrimaryContact(List<Tm_Service_Request_Contact__c> contacts);
        Eb_Account__c getLoanAccount(TmBoarding.RequestPm r);
        string concatenate(string text, integer size);
    }

    public interface IZbaMapperHelper {
        List<TmArchiving.TreasuryManagementSm> splitAccountRelationshipsByMaster(TmArchiving.TreasuryManagementSm sm);
    }

    public interface IOnlineBankingMapperHelper {
        TmBoarding.RequestPm getAchRequestPm(MapperRequestContainer container);
        TmBoarding.RequestPm getWiresRequestPm(TmArchiving.MapperRequestContainer container);
    }

    public interface ISmManager {
        List<SObject> getTms(List<TreasuryManagementSm> sms);
        List<SObject> getContactsAndAccounts(List<TreasuryManagementSm> sms);
        List<SObject> getEntities(List<TmArchiving.TreasuryManagementSm> sms);
        List<SObject> getArchives(String requestId, List<Treasury_Management__c> tmObjs);
    }

    public interface IVmBuilder {
        List<TmArchiving.ArchiveLayout> build(List<DmTmArchive> dms);
    }

    global class ArchiveReturn {
        public String archiveId { get; set; }
    }

    public class TreasuryManagementSm {
        public Treasury_Management__c core{get;set;}
        public List<TM_Service_Contact__c> contacts{get;set;} 
        public List<EB_Account_Service__c> accounts{get;set;}
        public Account Entity {get;set;}
    }

    public class MapperRequestContainer {
        public TmBoarding.RequestPm Pm {get;set;}
        public List<RecordType> RecordTypes {get;set;}
    }

    public class QueryFields {
        public Id requestId{get;set;}
        public List<string> requestFields{get;set;}
        public List<string> contactFields{get;set;}
        public List<string> accountFields{get;set;}
        public List<string> contactAccountFields{get;set;}
        public List<String> contactCoreFields{get;set;}
        public List<String> accountCoreFields{get;set;}
    }

    global class ArchiveLayout{
        public LayoutComponent tmService{get;set;}
        public LayoutComponent tmRequest{get;set;}
        public LayoutComponent createdBy{get;set;}
        public DateTime createdDate{get;set;}
        public String description{get;set;}
    }

    global class LayoutComponent{
        public string label{get;set;}
        public string value{get;set;}
    }

    public interface IConfiguration {
        String GOLDMAN_SACHS();
        String SWEEP_GOLDMAN_SACHS();
        String MONEY_MARKET();
        String SWEEP_MONEY_MARKET();
        String OPTIMA_PLUS();
        String SWEEP_OPTIMA_PLUS();
        String REPO();
        String SWEEP_REPO();
        String CONVENTIONAL();
        String PAYEE();
        String REVERSE();
        String POSITIVE_PAY_CONVENTIONAL();
        String POSITIVE_PAY_REVERSE();
        String POSITIVE_PAY_PAYEE();
        String REMOTE_DEPOSIT_DESKTOP();
        String REMOTE_DEPOSIT_MOBILE();
        String NONE();
        String QUICKBOOKS_PEACHTREE();
        String DYNAMICS_NETSUITE_INTAACT();
        String SAP_ERP();
        String ACCESS_SUPERVISOR();
        String OLD_SUPERVISOR();
        String ACCESS_LEVEL();
        String OTHER();
        String RECORDTYPE_ACH();
        String RECORDTYPE_ACH_DEBIT_FILTER();
        String RECORDTYPE_ACH_POSITIVE_PAY();
        String RECORDTYPE_LOCKBOX();
        String RECORDTYPE_LOCKBOX_REMITTANCE_IMAGING();
        String RECORDTYPE_LOCKBOX_DATA_REMITTANCE_MODULE();
        String RECORDTYPE_LOCKBOX_DATA_ENTRY_MODULE();
        String RECORDTYPE_LOCKBOX_DATA_EXTRACT_MODULE();
        String RECORDTYPE_ONLINE_BANKING();
        String RECORDTYPE_CONTROLLED_DISBURSEMENT();
        String RECORDTYPE_EDI();
        String RECORDTYPE_EB_ROM();
        String RECORDTYPE_ENTERPRISE_AUTOMATED_PAYABLES();
        String RECORDTYPE_INVESTMENT_SWEEP();     
        String RECORDTYPE_LOAN_INVESTMENT_SWEEP();
        String RECORDTYPE_POSITIVE_PAY();
        String RECORDTYPE_REMIT_PLUS();
        String RECORDTYPE_REMOTE_DEPOSIT();
        String RECORDTYPE_ZBA();
        String RECORDTYPE_WIRES();
        String RECORDTYPE_SVC_COMMERCIAL_ONLINE_BANKING();
        String RECORDTYPE_OTHER_TM_PRODUCT();
        String RECORDTYPE_BUSINESS_BILL_PAY();
        String ONLINE_BANKING_ACH_MODULE();
        String SVC_PRODUCT_SAME_DAY_ACH();
        String SVC_PRODUCT_ACH_RETURN_TRANSMISSION();
        String SVC_PRODUCT_ACH_FTP();
        String SVC_PRODUCT_POSITIVE_PAY_AUTOMATION();
        String SVC_PRODUCT_POSITIVE_PAY_FILE_WIZARD();
        String SVC_PRODUCT_OTHER();
    }
}