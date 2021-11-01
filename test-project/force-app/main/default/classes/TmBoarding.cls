global class TmBoarding {

    public interface IDataProvider extends DataProvider.IDataProvider {
        RequestPm getRequest(Id requestId, List<string> requestFields, List<string> contactFields, List<string> accountFields, List<string> contactAccountFields, List<String> contactCoreFields, List<String> accountCoreFields);
        RequestPm getRequestWithRelatedEbAccounts(Id requestId, List<String> entityIds, List<string> requestFields, List<string> contactFields, List<string> accountFields, List<string> contactAccountFields, List<String> contactCoreFields, List<String> accountCoreFields);
        RequestPm getRequestFromPacket(TM_Service_Request__c request);
        List<Tm_Service_Request__c> getRequestsForPacket(Id packetId);
        RequestConfigPm getPageFieldConfigurationsByServiceType(string recordTypeName);
        List<Eb_Account__c> getEbAccount(Decimal app, String accountNumber);
        Eb_Account__c getEbAccount(String ebaccountId);
        Opportunity getOpportunity(String opportunityId);
        List<Tm_Service_Request_Packet__c> getPacketsFromEntity(String entityId);
        Tm_Service_Request_Stage__c getStageForRequest(String requestId);
        List<TM_Service_Request_Stage_Relationships__c> getValidStages(Tm_Service_Request_Stage__c parent);
        Tm_Service_Request_Stage__c getStageByName(String stageName);
        List<Tm_Service_Request_Stage__c> getAllStages();
        List<Eb_Account__c> getEbAccountSearchResults(String param);
        TM_Service_Request_Packet__c getPacket(TM_Service_Request__c request);
        TM_Service_Request__c getPacketFromRequest(TM_Service_Request__c request);
        Tm_Service_Request_Stage__c getDefaultStage();
        Map<Id, TM_Service_Configuration_Section__c> getConfigSections();
        Map<Id, Tm_Service_Configuration_Section_Group__c> getConfigSectionGroups();
        List<TM_Service_Configuration__c> getAllConfigurations();
        Map<string, RequestConfigPm> getAllPageFieldConfigurationsByServiceType();
        Map<Id, TmBoarding.requestPm> getAllRequests(List<Id> requestIds, List<string> requestFields, List<string> contactFields, List<string> accountFields, List<string> contactAccountFields, List<String> contactCoreFields, List<String> accountCoreFields);
        List<TmBoarding.RequestPm> getUserCentricAccountsForPacket(Id packetId);
    }

    public interface IEbAccountRelBuilder {
        Map<String, DmEntity> getRelatedEntitiesIncludingParent(Account parent);
    }

    public interface IRepository {
        RequestConfigPm getMetaData(TM_Service_Request__c record);
        RequestPm getData(TM_Service_Request__c record);
        List<DmRecordType> getRecordTypesForTmRequest();
        DmEbAccount getExistingAccountByNumber(Integer app, String accountNumber);
        DmEbAccount getExistingAccountById(String ebaccountId);
        DmTmRequestStage getStageDetail(String requestId);
        DmTmRequestStage getDefaultStage();
        List<DmTmRequestStage> getAllStages();
        List<TmBoarding.RequestPm> getRequestPmsForPacket(string packetId);
        RequestPm getRequestById(String requestId, List<string> fields);

        void save(TmBoarding.CoreSm sm);
        void save(TmBoarding.RelatedSm sm, Id requestId);
        void save(TmBoarding.RelatedRelatedSm sm);
        void save(SObject obj);
        void save(List<SObject> objs);
        void remove(TmBoarding.RelatedSm sm);
        void remove(TmBoarding.RelatedRelatedSm sm);
    }

    public interface IPresenter {
        FormVm getFormVm(TM_Service_Request__c record);
        EntityFormVm getEntityFormVm(TM_Service_Request__c record);
        FormModalVm buildAccountContacts(String contactId, List<String> relatedAccountIds, TM_Service_Request__c record);
        FormModalVm buildContactAccounts(String accountId, List<String> relatedContactIds, TM_Service_Request__c record);
        List<TmValidator.ValidationResult> getValidations(TmValidator.ValidationRequest req, TM_Service_Request__c pm);
        TmBoarding.ExistingDataValidationVm validateTmRequest(TM_Service_Request__c record, List<string> stageIds);
        List<TmValidator.ValidationResult> validateTmRequests(string packetId, List<string> tmRequests, List<string> stageIds);
        List<TmValidator.ValidationResult> validateTmRequestsByCurrentStage(string packetId, List<string> tmRequests);
        List<TmBoarding.LayoutComponentStage> getAllStages();
        List<TmBoarding.NameValue> getAllProducts();
        TmBoarding.AccountGeneratorResult generateNewAccountNumber(String apiResource);
        List<TmBoarding.AccountSearchResult> getAccountSearchResult(String param);
        List<string> getTmos();
        string getStageNotes(Tm_Service_Request__c req);
        List<string> saveRequest(List<SaveSm> sms, TM_Service_Request__c record);
        List<string> saveContact(List<SaveSm> sms, Boolean isNew, TM_Service_Request__c record);
        List<String> saveAccount(List<SaveSm> sms, Boolean isNew, TM_Service_Request__c record, NewAccountDetails newAccount);
        void updateStage(Tm_service_Request__c record, string stageId);
        void updateStage(List<string> tmRequests, string stageId);
        List<StageLog> getStageLogs(Tm_service_Request__c record);
        void updateOpsAssignee(String packetId, String assigneeName);
        void saveStageNotes(Tm_Service_Request__c req, String notes);
    }

    public interface IVmBuilder {
        FormComponent buildDetails(List<DmSection> allDetailDms, List<DmSection> allDependentDms, TmBoarding.DataComponent dataComponent);
        FormComponent buildContacts(List<DmSection> allContactDms, DataComponent dataComponent);
        FormComponent buildAccounts(List<DmSection> allAccountDms, DataComponent dataComponent);
        LayoutComponent2 getPacket(RequestPm pm, List<DmRecordType> products, Map<string, TmConfiguration.ProductInfo> productInfos, List<DmTmRequestStage> stageDms);
        LayoutComponent getEntity(RequestPm pm);
        LayoutComponentStage buildStages(TM_Service_Request__c record, DmTmRequestStage stageDm);
        List<TmBoarding.LayoutComponentStage> getAllStages(List<DmTmRequestStage> stageDms);
        LayoutComponentPermission getPermission(DmTmRequestStage stage);
        List<TmBoarding.LayoutPickList> getAccountTypes();
        TmBoarding.ExistingDataValidationVm build(List<DmTmRequestStage> stageDms , Map<string, List<TmValidator.ValidationResult>> validationResults);
    }

    public interface IValidationEngine {
        FormMetadata addValidation(string objectName, FormMetadata meta, Map<string, TmValidator.ValidationResults> validationLookup);
    }

    public interface IVmBuilderHelper {
        LayoutComponent2 getPacket(RequestPm pm, List<DmRecordType> products, Map<string, TmConfiguration.ProductInfo> productInfos, List<DmTmRequestStage> stageDms);
        LayoutComponent getEntity(RequestPm pm);
        LayoutComponentStage buildStages(TM_Service_Request__c record, DmTmRequestStage stageDm);
        LayoutComponentPermission getPermission(DmTmRequestStage stage);
    }

    public interface IInputTypeVmBuilder {
        String build(DescribeFieldResultWrapper.Type fieldType, String overrideInput);
    }

    public interface IVmFieldBuilder {
        Field build(DmField fld);
        Field build(DmField dm, Decimal sortOrder);
    }

    public interface IVmMetadataTypeBuilder {
        TmConfiguration.Placement getType();
        List<Field> build(List<DmField> fields, IVmFieldBuilder fieldBuilder);
    }

    public interface IDmBuilder {
        ServiceMetadata getConfigurationsByService(TmBoarding.RequestConfigPm configPm);
        List<DmRecordType> getRequestRecordTypes();
        DmEbAccount getEbAccount(Eb_Account__c acct);
    }

    public interface IDmBuilderHelper {
        List<Map<String, Object>> buildContactAccountData(RequestPm requestPm, RequestConfigPm config, RelationshipRequest req);
        List<Map<String, Object>> buildAccountContactData(RequestPm requestPm, RequestConfigPm config, RelationshipRequest req);
        List<Map<String, Object>> buildContactData(List<Contact> contactPms, List<TM_Service_Configuration_Field__c> contactOptionPms, List<TM_Service_Request_Contact__c> serviceContactPms);
        List<Map<String, Object>> buildAccountData(List<Eb_Account__c> accountPms, List<TM_Service_Configuration_Field__c> accountOptionPms, List<TM_Service_Request_Account__c> serviceAccountPms);
        void checkForAddNewAccount(RelationshipRequest req ,FormModalVm modalVm);
        List<Map<String, Object>> buildDetailOptions( List<TM_Service_Configuration_Field__c> schedulePms, List<TM_Service_Configuration_Field__c> serviceOptionPms, TM_Service_Request__c requestPm);
    }

    public interface ISmBuilderHelper {
        RelatedSm buildServiceContacts(RelatedSm relatedSm, coreSm coreSm, List<SaveSm> sms, RequestConfigPm metadata, RequestPm pm);
        List<TM_Service_Request_Contact__c> buildNewServiceRequestContact(relatedSm relatedSm, List<SaveSm> sms, RequestConfigPm metadata, RequestPm pm);
        List<TM_Service_Request_Account__c> buildNewServiceRequestAccount(relatedSm relatedSm, List<SaveSm> sms, RequestConfigPm metadata, RequestPm pm);
        RelatedSm buildServiceAccounts(RelatedSm relatedSm, coreSm coreSm, List<SaveSm> sms, RequestConfigPm metadata, RequestPm pm);
        List<TM_Service_Request_Contact_Account__c> buildNewContactAccount(RelatedSm relatedSm, List<SaveSm> sms, RequestConfigPm metadata, RequestPm pm);
    }

    public interface ISmBuilder {
        CoreSm coreSmBuilder(List<SaveSm> sms, RequestPm pm);
        CoreSm addCoreAccount(DmEbAccount dm, CoreSm coreSm);
        void updateCoreAccountId(DmEbAccount dm, CoreSm coreSm);
        SObject buildRelatedEbAccount(requestPm pm, DmEbAccount coreAccount);
        RelatedSm relatedSmBuilder(CoreSm coreSm, List<SaveSm> sms, RequestPm pm);
        RelatedSm buildEditServiceContact(RelatedSm relatedSm, List<SaveSm> sms, RequestPm pm);
        RelatedSm buildEditServiceAccount(RelatedSm relatedSm, List<SaveSm> sms, RequestPm pm);

        Tm_Service_Request_Contact__c buildNewRequestContactForNewContact(Contact newContact,  List<SaveSm> sms, RequestPm pm);
        TM_Service_Request_Account__c buildNewRequestAccountForProspectiveAccount(DmEbAccount newAccount, RequestPm pm);
        RelatedRelatedSm buildServiceContactAccount(RelatedSm relatedSm,List<SaveSm> sms, RequestPm pm);
        List<TM_Service_Request_Contact_Account__c> buildNewRequestAccountContact(TM_Service_Request_Account__c reqAccount, List<SaveSm> sms, RequestPm pm);
        List<TM_Service_Request_Contact_Account__c> buildNewRequestContactAccount(TM_Service_Request_Contact__c reqContact, List<SaveSm> sms, RequestPm pm);
    
        TM_Service_Request__c buildNewCoreRequest(List<SaveSm> sms, RequestPm pm);
        Contact buildNewCoreContact(List<SaveSm> sms, RequestPm pm);
        Eb_Account__c buildNewCoreAccount(List<SaveSm> sms, RequestPm pm);
        Set<String> getExcludedFieldsFromRequest(TmBoarding.RequestConfigPm config, Tm_service_Request__c request);
        Tm_service_Request__c removeValuesFromRequest(Set<String> fields, Tm_service_Request__c request);
        
        List<SObject> updateProductAssignee(List<RequestPm> requestPms, String assigneeName);
    }

    public interface ISmExtractor {
        Map<String, List<SaveSm>> getObjectsById(String objectName, List<SaveSm> sms);
        List<TmBoarding.SaveSm> getObjectsWithoutId(String objectName, List<TmBoarding.SaveSm> sms);
        Map<String, List<SaveSm>> getObjectsWithoutIdAndParentId(String objectName, List<SaveSm> sms);
        Map<String, List<SaveSm>> getNewObjectsByParentId(String objectName, List<SaveSm> sms);
        List<SaveSm> getNewObjectWithoutId(String objectName, List<SaveSm> sms);
        Map<String, List<SaveSm>> getObjectsByParentAndRelated(String objectName, List<SaveSm> sms);
        Map<String, Object> getObjectFields(String objectName, List<SaveSm> sms);
        Map<String, Object> getSelectedFields(String objectId ,List<SaveSm> sms);
        String getValidField(SaveSm sm);
    }

    public interface ISmVerifier {
        RelatedSm verifyRelatedSm(RelatedSm sm, RequestPm requestPm);
    }

    public interface IFieldMetadataBuilder {
        Field getFieldMetadata(TM_Service_Configuration_Field__c cfgField, Placement plc, Map<Id, TM_Service_Configuration_Section_Group__c> sectionGroups);
        FieldCategory getCategoryMetadata(List<TM_Service_Configuration_Field__c> fields, Map<Id, TM_Service_Configuration_Section_Group__c> sectionGroups);
        FieldCategory getCategoryMetadata(List<TM_Service_Configuration_Field__c> parent, List<TM_Service_Configuration_Field__c> related,  Map<Id, TM_Service_Configuration_Section_Group__c> sectionGroups);
    }

    public interface IFieldMapManager {
        Schema.SObjectField getField(string objectName, string fieldName);
        boolean IsFieldValid(string objectName, string fieldName);
        boolean IsFieldUpdatable(Schema.SObjectField field);
        boolean IsFieldAccessible(Schema.SObjectField field);
        String getFieldHelpText(Schema.SObjectField fld);
        String getFieldName(Schema.SObjectField fld);
        Schema.DisplayType getType(Schema.SObjectField fld);
        List<Schema.PicklistEntry> getPicklist(Schema.SObjectField fld); 
        object Convert(Schema.SObjectField field, Object fieldValue);
        object fillEmpty(Schema.SObjectField field);
    }

    public interface IDataMapBuilder {
        LayoutComponent2 buildPacket(RequestPm pm);
        DataComponent buildDetails(RequestPm pm, List<DmField> requestfields, List<DmField> scheduleFields);
        DataComponent buildContacts(RequestPm pm, List<DmField> contactOptions);
        DataComponent buildAccounts(RequestPm pm, List<DmField> accountOptions);
        DataComponent buildContactAccounts(RequestPm pm, List<DmField> contactAccountOptions);
        Map<String, Object> buildContact(Contact c, List<DmField> contactOptions, Map<Id, TM_Service_Request_Contact__c> serviceContactMap);
        Map<string, Object> buildAccount(Eb_Account__c a ,List<DmField> accountOptions ,Map<String, TM_Service_Request_Account__c> serviceAccountMap);
    }

    public interface IReportManager {
        TmBoarding.ReportDetails getReport(TM_Service_Request__c request);
        TmBoarding.ContactSummaryDetails getContactSummaryDetails(Id packetId);
        TmBoarding.ReportDetails getPacketReport(String packetId, Boolean isMasterSvcRequired);
        TmBoarding.ReportDetails getEmptyReports(List<string> products);
        TmBoarding.ReportDetails getTmOperationsReport(Tm_Service_Request__c record);
        TmBoarding.ProductConfig getTemplatesForProduct(string product);
        TmBoarding.UserBoardingDetails getBoardingUserInfo(string packetId);
        Blob getMasterServiceAgreement(string packetId);
    }

    public interface IReportHelper {
        ReportDataHolder buildBulkRequestPmData(Map<string, TmConfiguration.ProductInfo> allProductInfos, List<string> tmRequestIds);
        ReportDataHolder buildJsonDataBulk(Map<string, Tm_Service_Request__c> jsonRequest);
        BoardingData buildData(RequestPm pm, List<DmField> requestFields, List<DmField> scheduleFields, List<DmField> contactFields, List<DmField> accountFields, List<DmField> contactAccountFields);
        BoardingData buildJsonData(TM_Service_Request__c record, String productName);
        Blob getMasterServiceAgreement(string packetId);
        TmConfiguration.ProductInfo getProductWithMasterServiceAgreement(String packetId);
    }

    public interface ISignerManager{
        boolean sendForSignature(string packetId, List<TmBoarding.SignerInfo> signers, List<string> tmRequests, boolean includeMaster, integer applicationId); 
        boolean sendForSignature(string clientName, string entityId, List<TmBoarding.SignerInfo> signers, List<string> relatedIds, integer applicationId);
    }

    public interface IServiceRequestBuilder{
        List<TmBoardingServiceProxy.HtmlToSignatureRequest> build(string packetId, List<TmBoarding.SignerInfo> signers, List<string> products, boolean includeMaster, integer applicationId);
        List<TmBoardingServiceProxy.HtmlToSignatureRequest> buildTMSADataForEntity(string clientName, string entityId, List<TmBoarding.SignerInfo> signers, List<string> items , integer applicationId);
    }

    public interface IServiceClientInfoProvider{
        List<TmBoardingServiceProxy.ClientInfo> getClientInfo(Map<String, Contact> contacts, List<TmBoarding.SignerInfo> signers, String roleIdentifier);
    }

    public interface IAccountProvider {
        TmBoarding.AccountGeneratorResult generateNewTmAccountNumber();
        TmBoarding.AccountGeneratorResult generateNewAccountNumber(String apiResourceKey);
        List<TmBoarding.AccountSearchResult> searchAccount(String searchParam);
    }

    public interface IPermission {
        LayoutComponentPermission getPermissionByRequestStage(DmTmRequestStage stage);
    }

    public interface IApproval{
        ApprovalProcess.ApprovalProcessInformation getApprovalInfo(TM_Service_Request__c record);
        ApprovalProcess.ApprovalSubmitResponse submitApprovalOrRecall(Tm_Service_request__c record, String action);
    }

    global class ContactSummaryDetails {
        public List<ContactSummaryProduct> Products { get;set; }
        public List<ContactSummaryContact> Contacts {get;set;}
        public String data {get;set;}
    }

    global class ContactSummaryProduct {
        public String Name {get;set;}
        public String Id {get;set;}
        public Boolean Selected {get;set;}
    }

    global class ContactSummaryContact {
        public string Name {get;set;}
        public string Id {get;set;}
        public List<ContactSummaryProduct> Products {get;set;}
    }

    public class ContactDetails {
        public ViewMetadata ViewMetadata { get; set; }
        public FieldCategory Metadata { get; set; }
        public List<Contact> Data { get; set; }
        public List<TM_Service_Request_Contact__c> RelatedData {get;set;}
        public List<SelectedDetail> Selected {get;set;}
    }

    public class AccountDetails {
        public ViewMetadata ViewMetadata { get; set; }
        public FieldCategory Metadata { get; set; }
        public List<Eb_Account__c> Data { get; set; }
        public List<TM_Service_Request_Account__c> RelatedData {get;set;}
        public List<SelectedDetail> Selected {get;set;}
    }

    public class RequestDetails {
        public ViewMetadata ViewMetadata { get; set; }
        public FieldCategory Metadata { get; set; }
        public TM_Service_Request__c Data { get; set; }
    }

    public class EntityDetails {
        public String Id { get; set; }      
        public String Name {get;set;}
        public String RecordType {get;set;}
    }

    global class ContactAccountDetails {
        public ViewMetadata ViewMetadata { get; set; }
        public FieldCategory Metadata { get; set; }
        public List<TM_Service_Request_Contact_Account__c> Data { get; set; }
        public List<SelectedDetail> Selected {get;set;}
    }

    global class AccountContactDetails {
        public ViewMetadata ViewMetadata { get; set; }
        public FieldCategory Metadata { get; set; }
        public List<TM_Service_Request_Contact_Account__c> Data {get;set;}
        public List<SelectedDetail> Selected {get;set;}
    }

    public class CoreSm {
        public TM_Service_Request__c request { get; set; }
        public TM_Service_Request_Packet__c packet {get;set;}
        public List<Contact> contacts { get; set; }
        public List<EB_Account__c> accounts { get; set; }
    }

    public class RelatedSm {
        public List<TM_Service_Request_Contact__c> contactRelationships { get; set; }
        public List<TM_Service_Request_Account__c> accountRelationships { get; set; }
        public List<TM_Service_Request_Contact__c> deleteContactRelationships { get; set; }
        public List<TM_Service_Request_Account__c> deleteAccountRelationships { get; set; }
    }

    public class RelatedRelatedSm {
        public List<TM_Service_Request_Contact_Account__c> contactAccountRelationships { get; set; }
        public List<TM_Service_Request_Contact_Account__c> deleteContactAccountRelationships { get; set; }
    }

    global class SaveSms {
        public List<SaveSm> Objects {get;set;}
    }

    global class SaveSm {
        public String FieldName {get;set;}
        public Object FieldValue {get;set;}
        public String ObjectId {get;set;}
        public String ParentId {get;set;}
        public String RelatedId {get;set;}
        public boolean ValidateNow {get;set;}
        public boolean Correlated {get;set;}
    }

    public class RequestPm {
        public TM_Service_Request__c requestPm { get; set; }
        public TM_Service_Request_Packet__c packetPm { get; set; }
        public List<TM_Service_Request__c> packetRequestsPm {get;set;}
        public Account entityPm { get; set; }
        public List<Contact> contactPms { get; set; }
        public List<EB_Account__c> accountPms { get; set; }
        public List<TM_Service_Request_Contact__c> serviceContactPms { get; set; }
        public List<TM_Service_Request_Account__c> serviceAccountPms { get; set; }
        public List<TM_Service_Request_Contact_Account__c> serviceContactAccountPms { get; set; }
    }

    public class RequestConfigPm {
        public TM_Service_Configuration__c productPm { get; set; }
        public List<TM_Service_Configuration_Field__c> serviceOptionPms { get; set; }
        public List<TM_Service_Configuration_Field__c> contactOptionPms { get; set; }
        public List<TM_Service_Configuration_Field__c> accountOptionPms { get; set; }
        public List<TM_Service_Configuration_Field__c> contactAccountOptionPms { get; set; }
        public List<RequestScheduleConfigPm> schedulePms { get; set; }
        public Map<Id,TM_Service_Configuration_Section__c> sectionOptionPms {get;set;}
        public Map<Id, Tm_Service_Configuration_Section_Group__c> sectionGroupOptionPms {get;set;}
    }

    public class RequestScheduleConfigPm {
        public String ScheduleLabel { get; set; }
        public String ScheduleName { get; set; }
        public String ScheduleSection { get; set; }
        public String ScheduleType {get;set;}
        public List<TM_Service_Configuration_Field__c> serviceSchedulePms { get; set; }
        public List<TM_Service_Configuration_Field__c> accountServiceSchedulePms { get; set; }
    }

    public class ProductConfig {
        public String ProductId {get;set;}
        public String Product {get;set;}
        public String TemplateFolderName {get;set;}
        public String ContactSummaryReportTemplateName {get;set;}
        public String TemplateFileName {get;set;}
        public String TmScreenTemplateFileName {get;set;}
        public String UserBoardingTemplateName {get;set;}
        public String FooterTemplateId {get;set;}
        public String PrimarySignerCode{get;set;}
        public String SecondarySignerCode{get;set;}
        public String TmoSignerCode{get;set;}
        public Boolean RequiresInitialSignature{get;set;}
    }

    public class ContactVm implements Comparable {
        public boolean selected { get; set; }
        public string rowIndex { get; set; }
        public Contact contactPm { get; set; }
        public TM_Service_Request_Contact__c serviceContactPm { get; set; }
        public List<TM_Service_Request_Contact_Account__c> serviceContactAccountPms { get; set; }

        public Integer compareTo(Object compareTo) {
            ContactVm other = (ContactVm) compareTo;
            if (selected == other.Selected) return compareToLevel2(compareTo);
            if (selected == True) return - 1;
            return 1;
        }

        public Integer compareToLevel2(Object compareTo) {
            ContactVm other = (ContactVm) compareTo;
            if (contactPm.FirstName<other.contactPm.FirstName) return - 1;
            if (contactPm.FirstName == other.contactPm.FirstName) return 0;
            return 1;
        }
    }

    public class SelectedDetail {
        public boolean Selected {get;set;}
        public String Id {get;set;}
        public String RowIndex {get;set;}
    }


    public class AccountVm implements Comparable {
        public boolean selected { get; set; }
        public string rowIndex { get; set; }
        public EB_Account__c accountPm { get; set; }
        public TM_Service_Request_Account__c serviceAccountPm { get; set; }
        public List<TM_Service_Request_Contact_Account__c> serviceAccountContactPms { get; set; }

        public Integer compareTo(Object compareTo) {
            AccountVm other = (AccountVm) compareTo;
            if (selected == other.selected) return compareToLevel2(compareTo);
            if (selected == True) return - 1;
            return 1;
        }

        public Integer compareToLevel2(Object compareTo) {
            AccountVm other = (AccountVm) compareTo;
            if (accountPm.Name<other.accountPm.Name) return - 1;
            if (accountPm.Name == other.accountPm.Name) return 0;
            return 1;
        }
    }

    public class RelationshipRequest {
        public Id ParentId {get;set;}
        public String AlternateParentId {get;set;}
        public List<Id> RelatedIds {get;set;}
        public List<String> AlternateRelatedIds {get;set;}
        public boolean IsNewParentId {get;set;}
        public RequestPm requestPm {get;set;}
        public ServiceMetadata metadata {get;set;}
    }

    global class ReportDetails {
        public Blob reportData {get;set;}
        public List<TmBoarding.BoardingData> data{get;set;}
        public Blob MasterAgreement{get;set;}
    }

    public class UserBoardingDetails {
        public Blob reportData {get;set;}
        public List<TmBoarding.UserProductsVm> data{get;set;}
    }




    /* Latest Form 11/3/2017*/
    
    global class FormVm {
        public LayoutComponent Entity {get;set;}
        public LayoutComponent2 Packet {get;set;}
        public FormComponent Details {get;set;}
        public FormComponent Contacts {get;set;}
        public FormComponent Accounts {get;set;}
        public LayoutComponentStage StageDetails {get;set;}
        public LayoutComponentPermission PermissionDetails {get;set;}
        public List<LayoutPickList> AccountNumberTypes {get;set;}
        public List<string> Errors { get; set; }
        public ErrorRepository.ErrorDetails ErrorDetails { get; set; }
    }

    global class EntityFormVm {
        public LayoutComponent Entity {get;set;}
        public LayoutComponent2 Packet {get;set;}
        public LayoutComponentStage StageDetails {get;set;}
        public LayoutComponentPermission PermissionDetails {get;set;}
        public List<LayoutPickList> AccountNumberTypes {get;set;}
        public List<string> Errors { get; set; }
        public ErrorRepository.ErrorDetails ErrorDetails { get; set; }
    }

    global class FormModalVm {
        public FormComponent Parent {get;set;} // Parent Contact
        public FormComponent Children {get;set;} // Children Contact Accounts
    }

    global class FormComponent{
        public List<Map<String, Object>> Data {get;set;}
        public FormMetadata EditMetadata {get;set;}
        public FormMetadata ViewMetadata {get;set;}
    }

    public class FormMetadata {
        public List<FormSection> Sections {get;set;}
    }

    public class FormSection implements Comparable
    {
        public String Name {get;set;}
        public Integer Columns {get;set;}
        public Boolean Visible {get;set;}
        public String PrimaryKeyFieldName {get;set;}
        public List<Field> Fields {get;set;}
        public List<DependentFields> DependentFields {get;set;}
        public Decimal SortOrder {get;set;}

        public Integer compareTo(Object compareTo) {
            FormSection other = (FormSection) compareTo;
            if (SortOrder == other.SortOrder) return 0;
            if (SortOrder > other.SortOrder) return 1;
            return -1;
        }
    }

    public class DependentFields {
        public String Name {get;set;}
        public String Label {get;set;}
        public String KeyFieldName {get;set;}
        public String Type {get;set;}
        public List<Field> Fields {get;set;}
    }

    public class LayoutComponent {
        public String Name {get;set;}
        public String Type {get;set;}
        public String PacketId {get;set;}
        public DateTime TmMasterAgreementDate{get;set;}
        public LayoutComponentRelated Packet {get;set;}
    }

    public class LayoutPickList {
        public String Label {get;set;}
        public String Value {get;set;}
    }

    public class LayoutComponent2 {
        public LayoutComponentRelated PacketDetail {get;set;}
        public LayoutComponentRelated Entity {get;set;}
        public LayoutComponentRelated Request {get;set;}
        public String Type {get;set;}
        public Integer Signers {get;set;}
        public String RequestObjectId {get;set;}
        public List<LayoutComponentRelated> Requests {get;set;}
        public List<LayoutComponentRelated> AllProducts {get;set;}      
    }

    public class LayoutComponentRelated implements Comparable {
        public String Id {get;set;}
        public String Name {get;set;}
        public String Stage {get;set;}
        public NameValue RecordType{get;set;}
        public String PrimarySignerCode{get;set;}
        public String SecondarySignerCode{get;set;}
        public String TmoSignerCode{get;set;}
        public LayoutComponentStage StageDetails{get;set;}
        public Integer compareTo(Object compareTo) {
            LayoutComponentRelated other = (LayoutComponentRelated) compareTo;
            if (Name == other.Name) return 0;
            if (Name > other.Name) return 1;
            return -1;
        }
    }

    global class LayoutComponentStage {
        public String Id {get;set;}
        public String Name {get;set;}
        public String StageType {get;set;}
        public LayoutComponentPermission permission{get;set;}
        public List<LayoutComponentStage> RelatedStages{get;set;}
    }

    public class LayoutComponentPermission {
        public boolean View {get;set;}
        public boolean Edit {get;set;}
        public String ViewPage {get;set;}
        public String EditPage {get;set;}
    }

    global class StageLog {
        public NameValue stage{get;set;}
        public UserVm createdBy{get;set;}
        public Decimal timeInBusinessDays{get;set;}
        public String timeInBusinessDaysExpanded{get;set;}
        public DateTime createdDate{get;set;}
    }

    global class NameValue{
        public String id{get;set;}
        public String name{get;set;}
    }

    public class Field implements Comparable {
        public string Label { get; set; }
        public string InputType { get; set; }
        public string Name { get; set; }
        public string Multilist { get;set; }
        public String ObjectId {get;set;}
        public String HelpText {get;set;}
        public string ObjectName { get; set; }//delete
        //public string Section {get;set;}//delete
        //public Integer Columns {get;set;}//delete
        public string AlternateName{get;set;}
        public Boolean Correlated {get;set;}
        public Boolean Readonly {get;set;}
        public List<FieldOption> Options {get; set;}
        public FieldValidation Validation {get;set;}

        public Decimal SortOrder {get;set;}

        public Integer compareTo(Object compareTo) {
            Field other = (Field) compareTo;
            if (SortOrder == other.SortOrder) return 0;
            if (SortOrder > other.SortOrder) return 1;
            return -1;
        }
    }

    public class FieldOption
    {
        public string Label { get; set; }
        public string Value { get; set; }
        public integer SortOrder { get; set; }
    }

    public class FieldValidation {
        public string Id {get;set;}
        public string ParentId {get;set;}
        public string FieldName {get;set;}
        public string ErrorDescription {get;set;}
        public boolean Immediate {get;set;}
        public boolean Correlated {get;set;}
    }

    public enum Placement {Edit, View, Title, Report}

    public class BoardingData {
        public TmBoarding.LayoutComponent2 Packet {get;set;}
        public Integer Signers {get;set;}
        public DataComponent Details {get;set;}
        public DataComponent Contacts {get;set;}
        public DataComponent Accounts {get;set;}
        public DataComponent ContactAccounts {get;set;}
        public BoardingData(){
            Signers  = 2;
        }
    }

    public class ReportDataHolder{
        public Map<string, TmBoarding.BoardingData> allboardingData{get;set;}
        public Map<Id, TmBoarding.RequestPm> requestPms{get;set;}
        public Map<Id, TmConfiguration.ObjectDmFields> objectFieldsByRequestId{get;set;}
    }

    public class SignerInfo{
        public boolean isTmo{get;set;}
        public string SignerId{get;set;}
        public string SecurityCode{get;set;}
        public string SignerCode{get;set;}
        public Integer Priority{get;set;}
        public TmoSigner Tmo{get;set;} 
    }
    
    public class TmoSigner {
        public String FirstName{get;set;}
        public String LastName{get;set;}
        public String Email{get;set;}
        public String Phone{get;set;}
    }

    public class DataComponent {
        public List<Map<String, Object>> Data {get;set;}
    }

    global class AccountSearchResult {
        public String Id {get;set;}
        public String Name {get;set;}
        public String AccountNumber {get;set;}
        public String Address {get;set;}
        public String Entity {get;set;}
    }

    global class AccountGeneratorResult {
        public String AccountNumber {get;set;}
        public List<String> Errors {get;set;}
    }

    global class NewAccountDetails {
        public String ExistingAccountId {get;set;}
        public String AccountNumber {get;set;}
        public String AccountName {get;set;}
    }

    /////////////////////////////////////////////////




    /*Start of new Config*/
    public class ServiceMetadata
    {
        public string Name { get; set; }
        public List<Field> Fields { get; set; }
        public FieldCategory ContactFields { get; set; }
        public FieldCategory AccountFields { get; set; }
        public List<ServiceOption> ServiceOptions { get; set; }
        public List<string> Errors { get; set; }
    }

    public class ServiceOption
    {
        public string Name { get; set; }
        public string Label { get; set; }
        public string Type {get;set;}
        public string Section {get;set;}
        public List<Field> Fields { get; set; }
        public FieldCategory ContactFields { get; set; }
        public FieldCategory AccountFields { get; set; }
    }

    public class FieldCategory
    {
        public List<Field> KeyFields { get; set; }
        public List<Field> ViewFields { get; set; }
        public List<Field> EditFields { get; set; }
        public List<Field> ReportFields { get; set; }
        public FieldCategory RelatedFields { get; set; }
        public List<ServiceOption> ServiceOptions { get; set; }
    }

    
    /*End of new Config*/

    public class ViewMetadata {
        public Integer Columns { get; set; }
        public Map<String, Integer> Sections {get;set;}
    }

    global class ExistingDataValidationVm {
        public List<LayoutComponentStage> StageDetails{get;set;}
        public Map<string, List<TmValidator.ValidationResult>> ValidationsByStage {get;set;}
    }

    global class UserProductsVm {
        public UserVm UserInfo {get;set;}
        public List<UserServiceVm> Services{get;set;}
        public List<UserAccountVm> Accounts{get;set;}
    }

    public class UserVm {
        public String id{get;set;}
        public string Name{get;set;}
    }

    public class UserServiceVm {
        public string Product {get;set;}
    }

    public class UserAccountVm {
        public string Name {get;set;}
    }

   
    public class BootstrapException extends Exception { }
    public class SaveException extends Exception { }
    public class AccountNotFoundException extends Exception { }
    public class SignerException extends Exception { }
    public class SignerClientInfoException extends Exception { }
}