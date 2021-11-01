global class TmConfiguration {  

    public interface IFieldBuilder {
        Placement handle();
        List<DmField> build(List<TM_Service_Configuration_Field__c> pms);
        List<DmField> build(DmBuildRequest request);
    }
    public interface ISectionBuilder {
        List<DmSection> build(List<DmField> fieldDms, Map<Id,TM_Service_Configuration_Section__c> lookup);
        List<DmSection> build(List<DmField> fieldDms, DmBuildRequest req);
    }
    public interface IDmBuilder {
        List<DmSection> buildSections(List<TM_Service_Configuration_Field__c> serviceOptionPms, Map<Id,TM_Service_Configuration_Section__c> sectionOptionPms, TmConfiguration.Placement placement);
        DmSection buildObjectFields(List<ISobjectField> fields, String objectName);
        List<DmSection> buildSections(DmBuildRequest request);
        TmConfiguration.ProductInfo buildProductInfo(Tm_Service_Request__c pm, TM_Service_Configuration__c cfg);
    }
    public interface IQueryBuilder {
        List<String> addRequiredRequestFields(List<String> fields);
        List<String> addRequiredContactFields(List<String> fields);
        List<String> addRequiredAccountFields(List<String> fields);
        List<String> addRequiredContactRequestFields(List<String> fields);
        List<String> addRequiredAccountRequestFields(List<String> fields);
        List<String> addRequiredContactAccountFields(List<String> fields);
    }

    public interface IRepository {
        List<DmSection> getDetailSections(String recordTypeName, TmConfiguration.Placement placement);
        List<DmSection> getDetailSections2(String recordTypeName, TmConfiguration.Placement placement);
        List<DmSection> getScheduleSections(String recordTypeName, TmConfiguration.Placement placement);
        List<DmSection> getScheduleSections2(String recordTypeName, TmConfiguration.Placement placement);
        List<DmSection> getContactSections(String recordTypeName, TmConfiguration.Placement placement);
        List<DmSection> getContactSections2(String recordTypeName, TmConfiguration.Placement placement);
        List<DmSection> getAccountSections(String recordTypeName, TmConfiguration.Placement placement);
        List<DmSection> getAccountSections2(String recordTypeId, TmConfiguration.Placement placement);
        List<DmSection> getContactAccountSections(String recordTypeName, TmConfiguration.Placement placement);
        List<DmSection> getContactAccountSections2(String recordTypeName, TmConfiguration.Placement placement);
        Map<String, DmSection> getAllObjectSections();
        List<DmField> getFields(List<DmSection> sections);
        TmBoarding.requestPm getRequest(Id requestId, List<string> requestFields, List<string> contactFields, List<string> accountFields, List<string> contactAccountFields, List<String> contactCoreFields, List<String> accountCoreFields);
        TmBoarding.ProductConfig getProduct(String recordTypeName);
        String getRecordTypeName(TM_Service_Request__c req);
        Blob getTemplateFromAttachment(String attachmentName, String productConfigId);
        Map<string , TmConfiguration.ProductInfo> getProductInfos(Id packetId);
        Map<string, TmConfiguration.ProductInfo> getProductInfosByRequestId(Id packetId);
        Map<Id, TmBoarding.requestPm> getAllRequests(List<Id> requestIds, List<string> requestFields, List<string> contactFields, List<string> accountFields, List<string> contactAccountFields, List<String> contactCoreFields, List<String> accountCoreFields);
    }
    public interface IStageRepository {
        DmTmRequestStage getStageDetail(String requestId);
        DmTmRequestStage getDefaultStage();
        List<DmTmRequestStage> getAllStages();
    }
    public interface IVmMetadataBuilder {
        List<FormSection> build(List<DmSection> sections);
        List<FormSection> buildDetails(String objectName , List<DmSection> detailSections, List<DmSection> scheduleSections);
        List<ObjectField> getObjectFields(String objectName, DmSection allFieldsSection);
    }
    public interface IVmBuilder {
        FormComponent build(String objectName, List<DmSection> sectionDms, List<DmSection> objectSections);
        FormComponent buildDetails(String objectName, List<DmSection> detailSections, List<DmSection> scheduleSections, List<DmSection> objectSections);
    }
    public interface IPresenter {
        FormVm build(String productName);
    }

    global class FormVm {
        public FormComponent Details {get;set;}
        public FormComponent Contacts {get;set;}
        public FormComponent Accounts {get;set;}
        public FormComponent ContactAccounts {get;set;}
    }

    public class FormComponent {
        public List<FormSection> Sections {get;set;}
        public List<ObjectField> AllFields {get;set;}
    }

    public class FormSection {
        public String Id {get;set;}
        public String Name {get;set;}
        public Integer Columns {get;set;}
        public Boolean Visible {get;set;}
        public Decimal SortOrder {get;set;}
        public List<ConfigurationField> Fields {get;set;} 
        public List<FormSection> DependentFields{get;set;}
    }

    public class ObjectField implements Comparable{
        public String Name {get;set;}
        public String ObjectName {get;set;}
        public String Label {get;set;}
        public String InputType {get;set;}
        public Boolean Updatable {get;set;}

        public Integer compareTo(Object compareTo) {
            ObjectField other = (ObjectField) compareTo;
            if (ObjectName == other.ObjectName) return compareToLevel2(compareTo);
            if (ObjectName > other.ObjectName) return 1;
            return -1;
        }

        public Integer compareToLevel2(Object compareTo) {
            ObjectField other = (ObjectField) compareTo;
            if (Name == other.Name) return 0;
            if (Name > other.Name) return 1;
            return -1;
        }
    }

    public class ConfigurationField {
        public String Name {get;set;}
        public String ObjectName {get;set;}
        public Boolean View {get;set;}
        public Boolean Edit {get;set;}
        public Boolean Report {get;set;}
        public Decimal ViewPlacement {get;set;}
        public Decimal EditPlacement {get;set;}
        public Decimal ReportPlacement {get;set;}
    }

    public class DmBuildRequest {
        public string Type{get;set;}
        public string Label{get;set;}
        public List<TM_Service_Configuration_Field__c> ServiceOptionPms{get;set;}
        public Map<Id,TM_Service_Configuration_Section__c> SectionOptionPms{get;set;}
        public Map<Id,Tm_Service_Configuration_Section_Group__c> SectionGroupOptions {get;set;}
        public TmConfiguration.Placement Placement {get;set;}
        public Map<string, ISObjectField> fieldMap {get;set;}
    }

    public class ProductInfo{
        public DmRecordType productType{get;set;}
        public string requestId{get;set;}
        public string configId{get;set;}
        public string templateFileName{get;set;}
        public string tmScreenTemplateFileName{get;set;}
        public string contactSummaryReportTemplateName{get;set;}
        public string userBoardingTemplateName{get;set;} 
        public string masterAgreementTemplateName{get;set;}
        public string footerTemplateId{get;set;}
        public String primarySignerCode{get;set;}
        public String secondarySignerCode{get;set;}
        public String tmoSignerCode{get;set;}
        public boolean requiresInitialSignature{get;set;}  
    }

    public class ObjectDmFields {
        public Tm_Service_Request__c core{get;set;}
        public List<DmField> requestFields {get;set;}
        public List<DmField> scheduleFields {get;set;}
        public List<DmField> contactFields {get;set;}
        public List<DmField> accountFields  {get;set;}
        public List<DmField> contactAccountFields  {get;set;}
    }

    public  Static Final String TM_REQUEST = 'TM_Service_Request__c';
    public  Static Final String TM_REQUEST_PACKET = 'TM_Service_Request_Packet__c';
    public  Static Final String CORE_CONTACT = 'Contact';
    public  Static Final String CORE_ACCOUNT = 'Eb_Account__c';
    public  Static Final String TM_REQUEST_CONTACT = 'TM_Service_Request_Contact__c';
    public  Static Final String TM_REQUEST_ACCOUNT = 'TM_Service_Request_Account__c';
    public  Static Final String TM_REQUEST_CONTACT_ACCOUNT = 'TM_Service_Request_Contact_Account__c';

    public  Static Final String TREASURY_MANAGEMENT = 'Treasury_Management__c';
    public  Static Final String TREASURY_MANAGEMENT_CONTACT = 'TM_Service_Contact__c';
    public  Static Final String TREASURY_MANAGEMENT_ACCOUNT = 'EB_Account_Service__c';

    public Enum Placement {All,Edit,Report,View}

}