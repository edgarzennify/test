@IsTest
public class TmBoardingMock {

        public class ofIPresenter extends ApexMoq implements TmBoarding.IPresenter {
                public TmBoarding.FormVm getFormVm(TM_Service_Request__c record) {
                return (TmBoarding.FormVm)handleMethodInvocation('getFormVm', new List<Object>{record});
                }
                public TmBoarding.EntityFormVm getEntityFormVm(TM_Service_Request__c record){
                        return (TmBoarding.EntityFormVm)handleMethodInvocation('getEntityFormVm', new List<Object>{record});
                }
                public TmBoarding.FormModalVm buildAccountContacts(String contactId, List<String> relatedAccountIds, TM_Service_Request__c record) {
                        return (TmBoarding.FormModalVm)handleMethodInvocation('buildAccountContacts', new List<Object>{contactId, relatedAccountIds, record});
                }
                public TmBoarding.FormModalVm buildContactAccounts(String accountId, List<String> relatedContactIds, TM_Service_Request__c record) {
                        return (TmBoarding.FormModalVm)handleMethodInvocation('buildContactAccounts', new List<Object>{accountId, relatedContactIds, record});
                }
                public List<TmValidator.ValidationResult> getValidations(TmValidator.ValidationRequest req, TM_Service_Request__c pm) {
                        return (List<TmValidator.ValidationResult>)handleMethodInvocation('getValidations', new List<Object>{req, pm});
                }
                public TmBoarding.ExistingDataValidationVm validateTmRequest(TM_Service_Request__c record, List<string> stageIds) {
                        return (TmBoarding.ExistingDataValidationVm)handleMethodInvocation('validateTmRequest', new List<Object>{record, stageIds});
                }
                public List<TmValidator.ValidationResult> validateTmRequests(string packetId, List<string> tmRequests, List<string> stageIds) {
                        return (List<TmValidator.ValidationResult>)handleMethodInvocation('validateTmRequests', new List<Object>{packetId, tmRequests, stageIds});
                }
                public List<TmValidator.ValidationResult> validateTmRequestsByCurrentStage(string packetId, List<string> tmRequests){
                        return (List<TmValidator.ValidationResult>)handleMethodInvocation('validateTmRequestsByCurrentStage', new List<Object>{packetId, tmRequests});
                }
                public List<TmBoarding.LayoutComponentStage> getAllStages() {
                        return (List<TmBoarding.LayoutComponentStage>)handleMethodInvocation('getAllStages');
                }
                public List<TmBoarding.NameValue> getAllProducts() {
                        return (List<TmBoarding.NameValue>)handleMethodInvocation('getAllProducts');
                }
                public List<String> getTmos() {
                        return (List<String>)handleMethodInvocation('getTmos');
                }
                public string getStageNotes(Tm_Service_Request__c req) {
                        return (string)handleMethodInvocation('getStageNotes', new List<Object>{req});
                }
                public void saveStageNotes(Tm_Service_Request__c req, String notes){
                        handleMethodInvocation('saveStageNotes', new List<Object>{req, notes});
                }
                public void save(TmBoarding.FormVm vm) {
                        handleMethodInvocation('save', new List<Object>{vm});
                }
                public List<string> saveRequest(List<TmBoarding.SaveSm> sms, TM_Service_Request__c record) {
                        return (List<String>)handleMethodInvocation('saveRequest', new List<Object>{sms, record});
                }
                public List<string> saveContact(List<TmBoarding.SaveSm> sms, Boolean isNew, TM_Service_Request__c record) {
                        return (List<string>)handleMethodInvocation('saveContact', new List<Object>{sms, isNew, record});
                }
                public List<String> saveAccount(List<TmBoarding.SaveSm> sms, Boolean isNew, TM_Service_Request__c record, TmBoarding.NewAccountDetails newAccount) {
                        return (List<String>)handleMethodInvocation('saveAccount', new List<Object>{sms, isNew, record, newAccount});
                }
                public List<TmBoarding.AccountSearchResult> getAccountSearchResult(String param) {
                        return (List<TmBoarding.AccountSearchResult>)handleMethodInvocation('getAccountSearchResult', new List<Object>{param});
                }
                public TmBoarding.AccountGeneratorResult generateNewAccountNumber(String key) {
                        return (TmBoarding.AccountGeneratorResult)handleMethodInvocation('generateNewAccountNumber', new List<Object>{key});
                }
                public void updateStage(Tm_service_Request__c record, string stageId) {
                        handleMethodInvocation('updateStage', new List<Object>{record, stageId});
                }
                public void updateStage(List<string> tmRequests, string stageId) {
                        handleMethodInvocation('updateStage', new List<Object>{tmRequests, stageId});
                }
                public List<TmBoarding.StageLog> getStageLogs(TM_Service_Request__c record) {
                        return (List<TmBoarding.StageLog>)handleMethodInvocation('getStageLogs', new List<Object>{record});
                }
                public void updateOpsAssignee(String packetId, String assigneeName) {
                        handleMethodInvocation('updateOpsAssignee', new List<Object>{packetId, assigneeName});
                }
        }

        public class ofIVmBuilder extends ApexMoq implements TmBoarding.IVmBuilder {
                public TmBoarding.FormComponent buildDetails(List<DmSection> allDetailDms, List<DmSection> allDependentDms, TmBoarding.DataComponent dataComponent) {
                        return (TmBoarding.FormComponent)handleMethodInvocation('buildDetails', new List<Object>{allDetailDms, allDependentDms, dataComponent});
                }
                public TmBoarding.FormComponent buildContacts(List<DmSection> allContactDms, TmBoarding.DataComponent dataComponent) {
                        return (TmBoarding.FormComponent)handleMethodInvocation('buildContacts', new List<Object>{allContactDms, dataComponent});
                }
                public TmBoarding.FormComponent buildAccounts(List<DmSection> allAccountDms, TmBoarding.DataComponent dataComponent) {
                        return (TmBoarding.FormComponent)handleMethodInvocation('buildAccounts', new List<Object>{allAccountDms, dataComponent});
                }
                public TmBoarding.LayoutComponent2 getPacket(TmBoarding.RequestPm pm, List<DmRecordType> products, Map<string, TmConfiguration.ProductInfo> productInfos, List<DmTmRequestStage> stageDms){
                        return (TmBoarding.LayoutComponent2)handleMethodInvocation('getPacket', new List<Object>{pm, products, productInfos, stageDms});
                }
                public TmBoarding.LayoutComponent getEntity(TmBoarding.RequestPm pm) {
                        return (TmBoarding.LayoutComponent)handleMethodInvocation('getEntity', new List<Object>{pm});
                }
                public TmBoarding.LayoutComponentStage buildStages(TM_Service_Request__c record, DmTmRequestStage stageDm) {
                        return (TmBoarding.LayoutComponentStage)handleMethodInvocation('buildStages', new List<Object>{record, stageDm});
                }
                public List<TmBoarding.LayoutComponentStage> getAllStages(List<DmTmRequestStage> dms) {
                        return (List<TmBoarding.LayoutComponentStage>)handleMethodInvocation('getAllStages', new List<Object>{dms});
                }
                public TmBoarding.LayoutComponentPermission getPermission(DmTmRequestStage stage) {
                        return (TmBoarding.LayoutComponentPermission)handleMethodInvocation('getPermission', new List<Object>{stage});
                }
                public List<TmBoarding.LayoutPickList> getAccountTypes() {
                        return (List<TmBoarding.LayoutPickList>)handleMethodInvocation('getAccountTypes');
                }
                public TmBoarding.ExistingDataValidationVm build(List<DmTmRequestStage> stageDms, Map<String,List<TmValidator.ValidationResult>> vResults) {
                        return (TmBoarding.ExistingDataValidationVm)handleMethodInvocation('build', new List<Object>{stageDms, vResults});
                }

        }

        public class ofIVmBuilderHelper extends ApexMoq implements TmBoarding.IVmBuilderHelper {
                public TmBoarding.LayoutComponent2 getPacket(TmBoarding.RequestPm pm, List<DmRecordType> products, Map<string, TmConfiguration.ProductInfo> productInfos, List<DmTmRequestStage> stageDms){
                        return (TmBoarding.LayoutComponent2)handleMethodInvocation('getPacket', new List<Object>{pm, products, productInfos, stageDms});
                }
                public TmBoarding.LayoutComponentStage buildStages(TM_Service_Request__c pm, DmTmRequestStage stageDm) {
                        return (TmBoarding.LayoutComponentStage)handleMethodInvocation('buildStages', new List<Object>{pm, stageDm});
                }
                public TmBoarding.LayoutComponentPermission getPermission(DmTmRequestStage p) {
                        return (TmBoarding.LayoutComponentPermission)handleMethodInvocation('getPermission', new List<Object>{p});
                }
                public TmBoarding.LayoutComponent getEntity(TmBoarding.RequestPm pm) {
                        return (TmBoarding.LayoutComponent)handleMethodInvocation('getEntity', new List<Object>{pm});
                }
        }

        public class ofIDmBuilder extends ApexMoq implements TmBoarding.IDmBuilder {
                public TmBoarding.ServiceMetadata getConfigurationsByService(TmBoarding.RequestConfigPm configPm) {
                        return (TmBoarding.ServiceMetadata)handleMethodInvocation('getConfigurationsByService', new List<Object>{configPm});
                }
                public TmBoarding.FormComponent buildDetails(TmBoarding.RequestConfigPm config, TmBoarding.RequestPm pm) {
                        return (TmBoarding.FormComponent)handleMethodInvocation('buildDetails', new List<Object>{config, pm});
                }
                public TmBoarding.FormComponent buildContactOptions(TmBoarding.RequestConfigPm config, TmBoarding.RequestPm pm, TmBoarding.Field fld) {
                        return (TmBoarding.FormComponent)handleMethodInvocation('buildContactOptions', new List<Object>{config, pm, fld});
                }
                public TmBoarding.FormComponent buildAccountOptions(TmBoarding.RequestConfigPm config, TmBoarding.RequestPm pm, TmBoarding.Field fld) {
                        return (TmBoarding.FormComponent)handleMethodInvocation('buildAccountOptions', new List<Object>{config, pm, fld});
                }
                public TmBoarding.FormModalVm buildContactAccountsOptions(TmBoarding.RelationshipRequest req, TmBoarding.RequestConfigPm config, TmBoarding.RequestPm requestPm, TmBoarding.Field fld){
                        return (TmBoarding.FormModalVm)handleMethodInvocation('buildContactAccountsOptions', new List<Object>{req, config, requestPm, fld});
                }
                public TmBoarding.FormModalVm buildAccountContactsOptions(TmBoarding.RelationshipRequest req, TmBoarding.RequestConfigPm config, TmBoarding.RequestPm requestPm, TmBoarding.Field fld) {
                        return (TmBoarding.FormModalVm)handleMethodInvocation('buildAccountContactsOptions', new List<Object>{req, config, requestPm, fld});
                }
                public DmEbAccount getEbAccount(Eb_Account__c acct) {
                        return (DmEbAccount)handleMethodInvocation('getEbAccount', new List<Object>{acct});
                }
                public List<DmRecordType> getRequestRecordTypes() {
                        return (List<DmRecordType>)handleMethodInvocation('getRequestRecordTypes');
                }
                public DmTmRequestStage buildStage(TM_Service_Request_Stage__c parent, List<TM_Service_Request_Stage_Relationships__c> related) {
                        return (DmTmRequestStage)handleMethodInvocation('buildStage', new List<OBject>{parent, related});
                }
        }

        public class ofIDmBuilderHelper extends ApexMoq implements TmBoarding.IDmBuilderHelper {
                public List<Map<String, Object>> buildContactAccountData(TmBoarding.RequestPm requestPm, TmBoarding.RequestConfigPm config, TmBoarding.RelationshipRequest req) {
                        return (List<Map<String, Object>>)handleMethodInvocation('buildContactAccountData', new List<Object>{requestPm, config, req});
                }
                public List<Map<String, Object>> buildAccountContactData(TmBoarding.RequestPm requestPm, TmBoarding.RequestConfigPm config, TmBoarding.RelationshipRequest req) {
                        return (List<Map<String, Object>>)handleMethodInvocation('buildAccountContactData', new List<Object>{requestPm, config, req});
                }
                public List<Map<String, Object>> buildContactData(List<Contact> contactPms, List<TM_Service_Configuration_Field__c> contactOptionPms, List<TM_Service_Request_Contact__c> serviceContactPms) {
                        return (List<Map<String, Object>>)handleMethodInvocation('buildContactData', new List<Object>{contactPms, contactOptionPms, serviceContactPms});
                }
                public List<Map<String, Object>> buildAccountData(List<Eb_Account__c> accountPms, List<TM_Service_Configuration_Field__c> accountOptionPms, List<TM_Service_Request_Account__c> serviceAccountPms) {
                        return (List<Map<String, Object>>)handleMethodInvocation('buildAccountData', new List<Object>{accountPms, accountOptionPms, serviceAccountPms});
                }
                public void checkForAddNewAccount(TmBoarding.RelationshipRequest req ,TmBoarding.FormModalVm modalVm) {
                        handleMethodInvocation('checkForAddNewAccount', new List<Object>{req, modalVm});
                }
                public List<Map<String, Object>> buildDetailOptions( List<TM_Service_Configuration_Field__c> schedulePms, List<TM_Service_Configuration_Field__c> serviceOptionPms, TM_Service_Request__c requestPm) {
                        return (List<Map<String, Object>>)handleMethodInvocation('buildDetailOptions', new List<OBject>{schedulePms, serviceOptionPms, requestPm});
                }
        }

        public class ofISmExtractor extends ApexMoq implements TmBoarding.ISmExtractor {
                public Map<String, List<TmBoarding.SaveSm>> getObjectsById(String objectName, List<TmBoarding.SaveSm> sms) {
                        return (Map<String, List<TmBoarding.SaveSm>>)handleMethodInvocation('getObjectsById', new List<Object>{objectName, sms});
                }
                public Map<String, Object> getObjectFields(String objectName, List<TmBoarding.SaveSm> sms) {
                        return (Map<String, Object>)handleMethodInvocation('getObjectFields', new List<Object>{objectName, sms});
                }
                public Map<String, Object> getSelectedFields(String objectId ,List<TmBoarding.SaveSm> sms) {
                        return (Map<String, Object>)handleMethodInvocation('getSelectedFields', new List<Object>{objectId, sms});
                }
                public String getValidField(TmBoarding.SaveSm sm) {
                        return (String)handleMethodInvocation('getValidField', new List<Object>{sm});
                }
                public Map<String, List<TmBoarding.SaveSm>> getNewObjectsByParentId(String objectName, List<TmBoarding.SaveSm> sms) {
                        return (Map<String, List<TmBoarding.SaveSm>>)handleMethodInvocation('getNewObjectsByParentId', new List<Object>{objectName, sms});
                }
                public List<TmBoarding.SaveSm> getNewObjectWithoutId(String objectName, List<TmBoarding.SaveSm> sms) {
                        return (List<TmBoarding.SaveSm>)handleMethodInvocation('getNewObjectWithoutId', new List<Object>{objectName, sms});
                }
                public Map<String, List<TmBoarding.SaveSm>> getObjectsByParentAndRelated(String objectName, List<TmBoarding.SaveSm> sms) {
                        return (Map<String, List<TmBoarding.SaveSm>>)handleMethodInvocation('getObjectsByParentAndRelated', new List<Object>{objectName, sms});
                }
                public List<TmBoarding.SaveSm> getObjectsWithoutId(String objectName, List<TmBoarding.SaveSm> sms) {
                        return (List<TmBoarding.SaveSm>)handleMethodInvocation('getObjectsWithoutId', new List<Object>{objectName, sms});
                }
                public Map<String, List<TmBoarding.SaveSm>> getObjectsWithoutIdAndParentId(String objectName, List<TmBoarding.SaveSm> sms) {
                        return (Map<String, List<TmBoarding.SaveSm>>)handleMethodInvocation('getObjectsWithoutIdAndRelatedId', new List<Object>{objectName, sms});
                }
        }

        public class ofISmBuilderHelper extends ApexMoq implements TmBoarding.ISmBuilderHelper {
                public TmBoarding.RelatedSm buildServiceContacts(TmBoarding.RelatedSm relatedSm, TmBoarding.coreSm cSm, List<TmBoarding.SaveSm> sms, TmBoarding.RequestConfigPm metadata, TmBoarding.RequestPm pm) {
                        return (TmBoarding.RelatedSm)handleMethodInvocation('buildServiceContacts', new List<Object>{relatedSm, cSm, sms, metadata, pm});
                }
                public List<TM_Service_Request_Contact__c> buildNewServiceRequestContact(TmBoarding.relatedSm relatedSm, List<TmBoarding.SaveSm> sms, TmBoarding.RequestConfigPm metadata, TmBoarding.RequestPm pm) {
                        return (List<TM_Service_Request_Contact__c>)handleMethodInvocation('buildNewServiceRequestContact', new List<Object>{relatedSm, sms, metadata, pm});
                }
                public List<TM_Service_Request_Account__c> buildNewServiceRequestAccount(TmBoarding.relatedSm relatedSm, List<TmBoarding.SaveSm> sms, TmBoarding.RequestConfigPm metadata, TmBoarding.RequestPm pm) {
                        return (List<TM_Service_Request_Account__c>)handleMethodInvocation('buildNewServiceRequestAccount', new List<OBject>{relatedSm, sms, metadata, pm});
                }
                public TmBoarding.RelatedSm buildServiceAccounts(TmBoarding.RelatedSm relatedSm, TmBoarding.coreSm cSm, List<TmBoarding.SaveSm> sms, TmBoarding.RequestConfigPm metadata, TmBoarding.RequestPm pm) {
                        return (TmBoarding.RelatedSm)handleMethodInvocation('buildServiceAccounts', new List<Object>{relatedSm, cSm, sms, metadata, pm});
                }
                public List<TM_Service_Request_Contact_Account__c> buildNewContactAccount(TmBoarding.RelatedSm relatedSm, List<TmBoarding.SaveSm> sms, TmBoarding.RequestConfigPm metadata, TmBoarding.RequestPm pm) {
                        return (List<TM_Service_Request_Contact_Account__c>)handleMethodInvocation('buildNewContactAccount', new List<Object>{relatedSm, sms, metadata, pm});
                }
                public TM_Service_Request__c buildRequestData(List<TmBoarding.SaveSm> requestFields, TmBoarding.RequestPm pm) {
                        return (TM_Service_Request__c)handleMethodInvocation('buildRequestData', new List<Object>{requestFields, pm});
                }
                public List<Contact> buildContactsData(Map<String, List<TmBoarding.SaveSm>> fields, TmBoarding.RequestPm pm) {
                        return (List<Contact>)handleMethodInvocation('buildContactsData', new List<Object>{fields, pm});
                }
                public List<EB_Account__c> buildAccountsData(Map<String, List<TmBoarding.SaveSm>> fields, TmBoarding.RequestPm pm) {
                        return (List<EB_Account__c>)handleMethodInvocation('buildAccountsData', new List<Object>{fields, pm});
                }
                public Map<String, TM_Service_Request_Account__c> buildAccountRequests(Map<String, List<TmBoarding.SaveSm>> fields, List<TM_Service_Request_Account__c> serviceAccounts, Map<String, TM_Service_Request_Account__c> serviceAccountPms) {
                        return (Map<String, TM_Service_Request_Account__c>)handleMethodInvocation('buildAccountRequests', new List<Object>{fields, serviceAccounts, serviceAccountPms});
                }
                public Map<String , TM_Service_Request_Contact__c> buildContactRequests( Map<String, List<TmBoarding.SaveSm>> fields, List<TM_Service_Request_Contact__c> serviceContacts, Map<String, TM_Service_Request_Contact__c> serviceContactPms) {
                        return (Map<String , TM_Service_Request_Contact__c>)handleMethodInvocation('buildContactRequests', new List<Object>{fields, serviceContacts, serviceContactPms});
                }
        }

        public class ofISmBuilder extends ApexMoq implements TmBoarding.ISmBuilder {
                public TmBoarding.coreSm buildCoreSm(TmBoarding.FormVm vm) {
                        return (TmBoarding.coreSm)handleMethodInvocation('buildCoreSm', new List<Object>{vm});
                }
                public TmBoarding.relatedSm buildRelatedSm(TmBoarding.FormVm vm) {
                        return (TmBoarding.relatedSm)handleMethodInvocation('buildRelatedSm', new List<Object>{vm});
                }
                public TmBoarding.relatedRelatedSm buildRelatedContactAccountSm(TmBoarding.FormVm vm) {
                        return (TmBoarding.relatedRelatedSm)handleMethodInvocation('buildRelatedContactAccountSm', new List<object>{vm});
                }
                public TmBoarding.coreSm coreSmBuilder(List<TmBoarding.SaveSm> sms, TmBoarding.RequestPm pm) {
                        return (TmBoarding.CoreSm)handleMethodInvocation('coreSmBuilder', new List<Object>{sms, pm});
                }
                public TmBoarding.relatedSm relatedSmBuilder(TmBoarding.CoreSm coreSm, List<TmBoarding.SaveSm> sms, TmBoarding.RequestPm pm) {
                        return (TmBoarding.RelatedSm)handleMethodInvocation('relatedSmBuilder', new List<Object>{coreSm, sms, pm});
                }
                public TmBoarding.RelatedSm buildEditServiceContact(TmBoarding.RelatedSm relatedSm, List<TmBoarding.SaveSm> sms, TmBoarding.RequestPm pm) {
                        return (TmBoarding.RelatedSm)handleMethodInvocation('buildEditServiceContact', new List<Object>{relatedSm, sms, pm});
                }
                public TmBoarding.relatedSm buildEditServiceAccount(TmBoarding.RelatedSm relatedSm, List<TmBoarding.SaveSm> sms, TmBoarding.RequestPm pm) {
                        return (TmBoarding.RelatedSm)handleMethodInvocation('buildEditServiceAccount', new List<Object>{relatedSm, sms, pm});
                }
                public TmBoarding.RelatedRelatedSm buildServiceContactAccount(TmBoarding.RelatedSm relatedSm,List<TmBoarding.SaveSm> sms, TmBoarding.RequestPm pm) {
                        return (TmBoarding.RelatedRelatedSm)handleMethodInvocation('buildServiceContactAccount', new List<Object>{relatedSm, sms, pm});
                }
                public TM_Service_Request_Contact__c buildNewRequestContactForNewContact(Contact newContact, List<TmBoarding.SaveSm> sms, TmBoarding.RequestPm pm) {
                        return (TM_Service_Request_Contact__c)handleMethodInvocation('buildNewRequestContactForNewContact', new List<Object>{newContact, sms, pm});
                }
                public TM_Service_Request_Account__c buildNewRequestAccountForProspectiveAccount(DmEbAccount newAccount, TmBoarding.RequestPm pm) {
                        return (TM_Service_Request_Account__c)handleMethodInvocation('buildNewRequestAccountForNewAccount', new List<Object>{newAccount, pm});
                }
                public List<TM_Service_Request_Contact_Account__c> buildNewRequestAccountContact(TM_Service_Request_Account__c reqAccount, List<TmBoarding.SaveSm> sms, TmBoarding.RequestPm pm) {
                        return (List<TM_Service_Request_Contact_Account__c>)handleMethodInvocation('buildNewRequestAccountContact', new List<Object>{reqAccount, sms, pm});
                }
                public List<TM_Service_Request_Contact_Account__c> buildNewRequestContactAccount(TM_Service_Request_Contact__c reqContact, List<TmBoarding.SaveSm> sms, TmBoarding.RequestPm pm) {
                        return (List<TM_Service_Request_Contact_Account__c>)handleMethodInvocation('buildNewRequestContactAccount', new List<Object>{reqContact, sms, pm});
                }
                public TM_Service_Request__c buildNewCoreRequest(List<TmBoarding.SaveSm> sms, TmBoarding.RequestPm pm) {
                        return (TM_Service_Request__c)handleMethodInvocation('buildNewCoreRequest', new List<Object>{sms,  pm});
                }
                public Contact buildNewCoreContact(List<TmBoarding.SaveSm> sms, TmBoarding.RequestPm pm) {
                        return (Contact)handleMethodInvocation('buildNewCoreContact', new List<Object>{sms, pm});
                }
                public Eb_Account__c buildNewCoreAccount(List<TmBoarding.SaveSm> sms, TmBoarding.RequestPm pm) {
                        return (Eb_Account__c)handleMethodInvocation('buildNewCoreAccount', new List<Object>{sms, pm});
                }
                public Set<String> getExcludedFieldsFromRequest(TmBoarding.RequestConfigPm config, Tm_service_Request__c request) {
                        return (Set<String>)handleMethodInvocation('getExcludedFieldsFromRequest', new List<Object>{config, request});
                }
                public Tm_service_Request__c removeValuesFromRequest(Set<String> fields, Tm_service_Request__c request) {
                        return (Tm_service_Request__c)handleMethodInvocation('removeValuesFromRequest', new List<Object>{fields, request});
                }
                public TmBoarding.CoreSm addCoreAccount(DmEbAccount dm, TmBoarding.CoreSm coreSm) {
                        return (TmBoarding.CoreSm)handleMethodInvocation('addCoreAccount', new List<Object>{dm, coreSm});
                }
                public void updateCoreAccountId(DmEbAccount ebAccount, TmBoarding.CoreSm coreSm) {
                        handleMethodInvocation('updateCoreAccountId', new List<Object>{ebAccount, coreSm});
                }
                public SObject buildRelatedEbAccount(TmBoarding.RequestPm pm, DmEbAccount ebAccount) {
                        return (SObject)handleMethodInvocation('buildRelatedEbAccount', new List<Object>{pm, ebAccount});
                }
                public List<SObject> updateProductAssignee(List<TmBoarding.RequestPm> products, String assigneeName) {
                        return (List<SObject>)handleMethodInvocation('updateProductAssignee', new List<Object>{products, assigneeName});
                }
        }

        public class ofISmVerifier extends ApexMoq implements TmBoarding.ISmVerifier {
                public TmBoarding.RelatedSm verifyRelatedSm(TmBoarding.RelatedSm sm, TmBoarding.RequestPm requestPm){
                        return (TmBoarding.RelatedSm)handleMethodInvocation('verifyRelatedSm', new List<Object>{sm, requestPm});
                }
        }

        public class ofIRepository extends ApexMoq implements TmBoarding.IRepository {
                public TmBoarding.RequestConfigPm getMetaData(TM_Service_Request__c record) {
                        return (TmBoarding.RequestConfigPm)handleMethodInvocation('getMetaData', new List<Object>{record});
                }
                public TmBoarding.ServiceMetadata getConfigurations(TM_Service_Request__c record) {
                    return (TmBoarding.ServiceMetadata)handleMethodInvocation('getConfigurations', new List<Object>{record});
                }
                public Tmboarding.RequestPm getData(TM_Service_Request__c record) {
                        return (Tmboarding.RequestPm)handleMethodInvocation('getData', new List<Object>{record});
                }
                public Tmboarding.FormComponent getDetailsFormComponent(Tmboarding.RequestConfigPm configPm, Tmboarding.RequestPm pm) {
                        return (Tmboarding.FormComponent)handleMethodInvocation('getDetailsFormComponent', new List<Object>{configPm ,pm});
                }
                public Tmboarding.FormComponent getContactsFormComponent(Tmboarding.RequestConfigPm configPm, Tmboarding.RequestPm pm) {
                        return (Tmboarding.FormComponent)handleMethodInvocation('getContactsFormComponent', new List<Object>{configPm ,pm});
                }
                public Tmboarding.FormComponent getAccountsFormComponent(Tmboarding.RequestConfigPm configPm, Tmboarding.RequestPm pm) {
                        return (Tmboarding.FormComponent)handleMethodInvocation('getAccountsFormComponent', new List<Object>{configPm ,pm});
                }
                public Tmboarding.FormModalVm getContactAccountsFormComponent(TmBoarding.RelationshipRequest req, TmBoarding.RequestConfigPm config, TmBoarding.RequestPm requestPm) {
                        return (TmBoarding.FormModalVm)handleMethodInvocation('getContactAccountsFormComponent', new List<Object>{req, config, requestPm});
                }
                public TmBoarding.FormModalVm getAccountContactsFormComponent(TmBoarding.RelationshipRequest req, TmBoarding.RequestConfigPm config, TmBoarding.RequestPm requestPm) {
                        return (TmBoarding.FormModalVm)handleMethodInvocation('getAccountContactsFormComponent', new List<Object>{req, config, requestPm});
                }
                public DmEbAccount getExistingAccountByNumber(Integer app, String accountNumber) {
                        return (DmEbAccount)handleMethodInvocation('getExistingAccountByNumber', new List<Object>{app, accountNumber});
                }
                public TmBoarding.RequestPm getRequestById(String requestId, List<string> fields){
                        return (TmBoarding.RequestPm)handleMethodInvocation('getRequestById', new List<Object>{requestId, fields});
                }
                public void save(TmBoarding.CoreSm sm) {
                    handleMethodInvocation('save', new List<Object>{sm});
                }
                public void save(TmBoarding.RelatedSm sm, Id requestId) {
                    handleMethodInvocation('save', new List<Object>{sm,requestId});
                }
                public void save(TmBoarding.RelatedRelatedSm sm) {
                        handleMethodInvocation('save', new List<Object>{sm});
                }
                public void remove(TmBoarding.RelatedSm sm) {
                    handleMethodInvocation('save', new List<Object>{sm});
                }
                public void remove(TmBoarding.RelatedRelatedSm sm) {
                        handleMethodInvocation('remove', new List<Object>{sm});
                }
                public List<DmRecordType> getRecordTypesForTmRequest() {
                        return (List<DmRecordType>)handleMethodInvocation('getRecordTypesForTmRequest');
                }
                public DmTmRequestStage getStageDetail(String requestId) {
                        return (DmTmRequestStage)handleMethodInvocation('getStageDetail', new List<String>{requestId});
                }
                public DmEbAccount getExistingAccountById(String ebaccountId) {
                        return (DmEbAccount)handleMethodInvocation('getExistingAccountById', new List<Object>{ebaccountId});
                }
                public DmTmRequestStage getDefaultStage() {
                        return (DmTmRequestStage)handleMethodInvocation('getDefaultStage');
                }
                public List<DmTmRequestStage> getAllStages() {
                        return (List<DmTmRequestStage>)handleMethodInvocation('getAllStages');
                }
                public List<TmBoarding.RequestPm> getRequestPmsForPacket(string packetId) {
                        return (List<TmBoarding.RequestPm>)handleMethodInvocation('getRequestPmsForPacket', new List<object>{packetId});
                }
                public void save(SObject sobj) {
                        handleMethodInvocation('save', new List<OBject>{sobj});
                }
                public void save(List<SObject> objs) {
                        handleMethodInvocation('save', new List<Object>{objs});
                }
        }
        public class ofIFieldMetadataBuilder extends ApexMoq implements TmBoarding.IFieldMetadataBuilder {
                public TmBoarding.Field getFieldMetadata(TM_Service_Configuration_Field__c cfgField,  TmBoarding.Placement plc, Map<Id, TM_Service_Configuration_Section_Group__c> sectionGroups) {
                        return (TmBoarding.Field)handleMethodInvocation('getFieldMetadata', new List<Object>{cfgField, plc, sectionGroups});
                }
                public TmBoarding.FieldCategory getCategoryMetadata(List<TM_Service_Configuration_Field__c> fields, Map<Id, TM_Service_Configuration_Section_Group__c> sectionGroups) {
                        return (TmBoarding.FieldCategory)handleMethodInvocation('getCategoryMetadata', new List<Object>{fields, sectionGroups});
                }
                public TmBoarding.FieldCategory getCategoryMetadata(List<TM_Service_Configuration_Field__c> parent, List<TM_Service_Configuration_Field__c> related, Map<Id, TM_Service_Configuration_Section_Group__c> sectionGroups) {
                        return (TmBoarding.FieldCategory)handleMethodInvocation('getCategoryMetadata', new List<Object>{parent, related, sectionGroups });
                }
                public TmBoarding.FormComponent getFormComponent(List<TM_Service_Configuration_Field__c> fields, Map<Id, TM_Service_Configuration_Section__c> sections, Map<Id, TM_Service_Configuration_Section_Group__c> sectionGroups) {
                        return (TmBoarding.FormComponent)handleMethodInvocation('getFormComponent', new List<Object>{fields, sections, sectionGroups});
                }
                public TmBoarding.FormComponent getDetailsFormComponent(List<TM_Service_Configuration_Field__c> fields, Map<Id, TM_Service_Configuration_Section__c> sections, Map<Id, TM_Service_Configuration_Section_Group__c> sectionGroups, List<TmBoarding.RequestScheduleConfigPm> schedulePms) {
                        return (TmBoarding.FormComponent)handleMethodInvocation('getDetailsFormComponent', new List<Object>{fields, sections, sectionGroups, schedulePms});
                }
        }
        public class ofIFieldMapManager extends ApexMoq implements TmBoarding.IFieldMapManager {
                public Schema.SObjectField getField(string objectName, string fieldName){
                        return (Schema.SObjectField)handleMethodInvocation('getField', new List<Object>{objectName, fieldName});
                }
                public boolean IsFieldValid(string objectName, string fieldName) {
                        return (boolean)handleMethodInvocation('IsFieldValid', new List<Object>{objectName,fieldName});
                }
                public boolean IsFieldUpdatable(Schema.SObjectField field) {
                        return (boolean)handleMethodInvocation('IsFieldUpdatable', new List<Object>{field});
                }
                public object Convert(Schema.SObjectField field, Object fieldValue) {
                        return (object)handleMethodInvocation('Convert', new List<Object> {field, fieldValue});
                }
                public  object fillEmpty(Schema.SObjectField field) {
                        return (object)handleMethodInvocation('fillEmpty', new List<Object>{field});
                }
                public String getFieldHelpText(Schema.SObjectField fld) {
                        return (String)handleMethodInvocation('getFieldHelpText', new List<Object>{fld});
                }
                public String getFieldName(Schema.SObjectField fld) {
                        return (String)handleMethodInvocation('getFieldName', new List<Object>{fld});
                }
                public Schema.DisplayType getType(Schema.SObjectField fld) {
                        return (Schema.DisplayType)handleMethodInvocation('getType', new List<Object>{fld});
                }
                public List<Schema.PicklistEntry> getPicklist(Schema.SObjectField fld) {
                        return (List<Schema.PicklistEntry>)handleMethodInvocation('getPicklist', new List<Object>{fld});
                }
                public Boolean IsFieldAccessible(Schema.SObjectField fld) {
                        return (Boolean)handleMethodInvocation('IsFieldAccessible', new List<OBject>{fld});
                }

        }
        public class ofIAccountProvider extends ApexMoq implements TmBoarding.IAccountProvider {
                public String generateNewAccountNumber() {
                        return (String)handleMethodInvocation('generateNewAccountNumber');
                }
                public TmBoarding.AccountGeneratorResult generateNewTmAccountNumber() {
                        return (TmBoarding.AccountGeneratorResult)handleMethodInvocation('generateNewTmAccountNumber');
                }
                public List<TmBoarding.AccountSearchResult> searchAccount(String searchParam) {
                        return (List<TmBoarding.AccountSearchResult>)handleMethodInvocation('searchAccount' , new List<Object>{searchParam});
                }
                public TmBoarding.AccountGeneratorResult generateNewAccountNumber(String key) {
                        return (TmBoarding.AccountGeneratorResult)handleMethodInvocation('generateNewAccountNumber', new List<Object>{key});
                }
        }
        public class ofIDataMapBuilder extends ApexMoq implements Tmboarding.IDataMapBuilder {
                public TmBoarding.LayoutComponent2 buildPacket(TmBoarding.RequestPm pm) {
                        return (TmBoarding.LayoutComponent2)handleMethodInvocation('buildPacket', new List<Object>{pm});
                }
                public TmBoarding.DataComponent buildDetails(TmBoarding.RequestPm pm, List<DmField> requestfields, List<DmField> scheduleFields) {
                        return (TmBoarding.DataComponent)handleMethodInvocation('buildDetails', new List<Object>{pm, requestfields, scheduleFields});
                }
                public Map<String,Object> buildContact(Contact c, List<DmField> dms, Map<Id,TM_Service_Request_Contact__c> rels) {
                        return (Map<String,Object>)handleMethodInvocation('buildContact', new List<Object>{c, dms, rels});
                }
                public TmBoarding.DataComponent buildContacts(TmBoarding.RequestPm pm, List<DmField> contactOptions) {
                        return (TmBoarding.DataComponent)handleMethodInvocation('buildContacts', new List<Object>{pm, contactOptions});
                }
                public Map<String,Object> buildAccount(EB_Account__c a, List<DmField> dms, Map<String,TM_Service_Request_Account__c> rels) {
                        return (Map<String,Object>)handleMethodInvocation('buildAccount', new List<Object>{a, dms, rels});
                }
                public TmBoarding.DataComponent buildAccounts(TmBoarding.RequestPm pm, List<DmField> accountOptions) {
                        return (TmBoarding.DataComponent)handleMethodInvocation('buildAccounts', new List<Object>{pm, accountOptions});
                }
                public TmBoarding.DataComponent buildContactAccounts(TmBoarding.RequestPm pm, List<DmField> contactAccountOptions) {
                        return (TmBoarding.DataComponent)handleMethodInvocation('buildContactAccounts', new List<Object>{pm, contactAccountOptions});
                }
        }
        public class ofIDataProvider extends Mock.ofIDataProvider implements TmBoarding.IDataProvider {
                public TmBoarding.RequestPm getRequest(Id requestId, List<string> requestFields, List<string> contactFields, List<string> accountFields, List<string> contactAccountFields) {
                        return (TmBoarding.RequestPm)handleMethodInvocation('getRequest', new List<Object>{requestId, requestFields, accountFields, contactAccountFields});
                }
                public TmBoarding.requestPm getRequestWithRelatedEbAccounts(Id requestId, List<String> entityIds, List<string> requestFields, List<string> contactFields, List<string> accountFields, List<string> contactAccountFields, List<String> contactCoreFields, List<String> accountCoreFields) {
                        return (TmBoarding.requestPm)handleMethodInvocation('getRequestWithRelatedEbAccounts', new List<Object>{requestId, entityIds, requestFields, accountFields, contactAccountFields});
                }
                public TmBoarding.requestPm getRequestFromPacket(TM_Service_Request__c request) {
                        return (TmBoarding.requestPm)handleMethodInvocation('getRequestFromPacket', new List<Object>{request});
                }
                public List<Tm_Service_Request__c> getRequestsForPacket(Id packetId) {
                        return (List<Tm_Service_Request__c>)handleMethodInvocation('getRequestsForPacket', new List<Object>{packetId});
                }
                public TmBoarding.RequestConfigPm getPageFieldConfigurationsByServiceType(string recordTypeName) {
                        return (TmBoarding.RequestConfigPm)handleMethodInvocation('getPageFieldConfigurationsByServiceType', new List<Object>{recordTypeName});
                }
                public List<Eb_Account__c> getEbAccount(Decimal app, String accountNumber) {
                        return (List<Eb_Account__c>)handleMethodInvocation('getEbAccount', new List<Object>{app, accountNumber});
                }
                public TmBoarding.RequestPm getRequest(Id recordId, List<String> requestFields, List<String> contactFields, List<String> accountFields, List<String> contactAccountFields, List<String> coreContacts, List<String> coreAccounts) {
                        return (TmBoarding.RequestPm )handleMethodInvocation('getRequest', new List<Object>{recordId,requestFields, contactFields,  accountFields, contactAccountFields, coreContacts, coreAccounts});
                }
                public Opportunity getOpportunity(String opportunityId) {
                        return (Opportunity)handleMethodInvocation('getOpportunity', new List<Object>{opportunityId});
                }
                public List<TM_Service_Request_Packet__c> getPacketsFromEntity(String entityId) {
                        return (List<TM_Service_Request_Packet__c>)handleMethodInvocation('getPacketsFromEntity', new List<Object>{entityId});
                }
                public TM_Service_Request_Stage__c getStageForRequest(String requestId) {
                        return (TM_Service_Request_Stage__c)handleMethodInvocation('getStageForRequest', new List<Object>{requestId});
                }
                public List<TM_Service_Request_Stage_Relationships__c> getValidStages(TM_Service_Request_Stage__c parent) {
                        return (List<TM_Service_Request_Stage_Relationships__c>)handleMethodInvocation('getValidStages', new List<Object>{parent});
                }
                public EB_Account__c getEbAccount(String ebaccountId) {
                        return (Eb_Account__c)handleMethodInvocation('getEbAccount', new List<Object>{ebaccountId});
                }
                public TM_Service_Request_Stage__c getStageByName(String requestId) {
                        return (TM_Service_Request_Stage__c)handleMethodInvocation('getStageByName', new List<Object>{requestId});
                }
                public List<EB_Account__c> getEbAccountSearchResults(String param) {
                        return (List<EB_Account__c>)handleMethodInvocation('getEbAccountSearchResults', new List<Object>{param});
                }
                public TM_Service_Request_Packet__c getPacket(TM_Service_Request__c record) {
                        return (TM_Service_Request_Packet__c)handleMethodInvocation('getPacket', new List<Object>{record});
                }
                public TM_Service_Request__c getPacketFromRequest(TM_Service_Request__c request) {
                        return (TM_Service_Request__c)handleMethodInvocation('getPacketFromRequest', new List<Object>{request});
                }
                public TM_Service_Request_Stage__c getDefaultStage() {
                        return (TM_Service_Request_Stage__c)handleMethodInvocation('getDefaultStage');
                }
                public Map<Id,TM_Service_Configuration_Section__c> getConfigSections() {
                        return (Map<Id,TM_Service_Configuration_Section__c>)handleMethodInvocation('getConfigSections');
                }
                public Map<Id,TM_Service_Configuration_Section_Group__c> getConfigSectionGroups() {
                        return (Map<Id,TM_Service_Configuration_Section_Group__c>)handleMethodInvocation('getConfigSectionGroups');
                }
                public List<TM_Service_Configuration__c> getAllConfigurations() {
                        return (List<TM_Service_Configuration__c>)handleMethodInvocation('getAllConfigurations');
                }
                public Map<string, TmBoarding.RequestConfigPm> getAllPageFieldConfigurationsByServiceType() {
                        return (Map<string, TmBoarding.RequestConfigPm>)handleMethodInvocation('getAllPageFieldConfigurationsByServiceType');
                }
                public Map<Id,TmBoarding.RequestPm> getAllRequests(List<Id> requestIds, List<string> requestFields, List<string> contactFields, List<string> accountFields, List<string> contactAccountFields, List<String> contactCoreFields, List<String> accountCoreFields) {
                        return (Map<Id,TmBoarding.RequestPm>)handleMethodInvocation('getAllRequests', new List<Object>{requestIds, requestFields, contactFields, accountFields, contactAccountFields, contactCoreFields, accountCoreFields});
                }
                public List<Tm_Service_Request_Stage__c> getAllStages() {
                        return (List<Tm_Service_Request_Stage__c>)handleMethodInvocation('getAllStages');
                }
                public List<TmBoarding.RequestPm> getUserCentricAccountsForPacket(Id packetId) {
                        return (List<TmBoarding.RequestPm>)handleMethodInvocation('getUserCentricAccountsForPacket', new List<Object>{packetId});
                }
        }
        public class ofIEbAccountRelBuilder extends ApexMoq implements TmBoarding.IEbAccountRelBuilder{
                public Map<String, DmEntity> getRelatedEntitiesIncludingParent(Account parent) {
                        return (Map<String, DmEntity>)handleMethodInvocation('getRelatedEntitiesIncludingParent', new List<Object>{parent});
                }
        }
        public class ofIPermission extends ApexMoq implements TmBoarding.IPermission {
                public TmBoarding.LayoutComponentPermission getPermissionByRequestStage(DmTmRequestStage stage) {
                        return (TmBoarding.LayoutComponentPermission)handleMethodInvocation('getPermissionByRequestStage', new List<Object>{stage});
                }
        }
        public class ofIValidationEngine extends ApexMoq implements TmBoarding.IValidationEngine {
                public TmBoarding.FormMetadata addValidation(string objectName, TmBoarding.FormMetadata meta, Map<string, TmValidator.ValidationResults> validationLookup) {
                        return (TmBoarding.FormMetadata)handleMethodInvocation('addValidation', new List<Object>{objectName, meta, validationLookup});
                }
        }
        public class ofIVmFieldBuilder extends ApexMoq implements TmBoarding.IVmFieldBuilder {
                public TmBoarding.Field build(DmField fld) {
                        return (TmBoarding.Field)handleMethodInvocation('build', new List<Object>{fld});
                }
                public TmBoarding.Field build(DmField fld, Decimal sortPosition) {
                        return (TmBoarding.Field)handleMethodInvocation('build', new List<Object>{fld, sortPosition});
                }
        }
        public class ofIInputTypeVmBuilder extends ApexMoq implements TmBoarding.IInputTypeVmBuilder {
                public String build(DescribeFieldResultWrapper.Type t, String tStr) {
                        return (String)handleMethodInvocation('build', new List<Object>{t, tStr});
                }
        }
        public class ofIVmMetadataTypeBuilder extends ApexMoq implements TmBoarding.IVmMetadataTypeBuilder {
                public TmConfiguration.Placement getType() {
                        return (TmConfiguration.Placement)handleMethodInvocation('getType');
                }
                public List<TmBoarding.Field> build(List<DmField> dms, TmBoarding.IVmFieldBuilder bld) {
                        return (List<TmBoarding.Field>)handleMethodInvocation('build', new List<Object>{dms, bld});
                }
        }

        public class ofIReportHelper extends ApexMoq implements TmBoarding.IReportHelper {
                public TmBoarding.ReportDataHolder buildBulkRequestPmData(Map<string, TmConfiguration.ProductInfo> allProductInfos, List<string> tmRequestIds){
                        return (TmBoarding.ReportDataHolder)handleMethodInvocation('buildBulkRequestPmData', new List<OBject>{allProductInfos, tmRequestIds});
                }
                public TmBoarding.ReportDataHolder buildJsonDataBulk(Map<String,TM_Service_Request__c> requests) {
                        return (TmBoarding.ReportDataHolder)handleMethodInvocation('buildJsonDataBulk', new List<Object>{requests});
                }
                public TmBoarding.BoardingData buildJsonData(TM_Service_Request__c r, String prod) {
                        return (TmBoarding.BoardingData)handleMethodInvocation('buildJsonData', new List<Object>{r, prod});
                }
                public TmBoarding.BoardingData buildData(TmBoarding.RequestPm pm, List<DmField> requestFields, List<DmField> scheduleFields, List<DmField> contactFields, List<DmField> accountFields, List<DmField> contactAccountFields) {
                        return (TmBoarding.BoardingData)handleMethodInvocation('buildData', new List<Object>{pm, requestFields, scheduleFields, contactFields, accountFields,  contactAccountFields});
                }
                public Blob getMasterServiceAgreement(string packetId){
                        return (Blob)handleMethodInvocation('getMasterServiceAgreement', new List<Object>{packetId});
                }
                public TmConfiguration.ProductInfo getProductWithMasterServiceAgreement(String packetId){
                        return (TmConfiguration.ProductInfo)handleMethodInvocation('getProductWithMasterServiceAgreement',new List<Object>{packetId});
                }
        }

        public class ofIReportManager extends ApexMoq implements TmBoarding.IReportManager {
                public TmBoarding.ReportDetails getReport(TM_Service_Request__c r) {
                        return (TmBoarding.ReportDetails)handleMethodInvocation('getReport', new List<Object>{r});
                }
                public TmBoarding.ContactSummaryDetails getContactSummaryDetails(Id itemId) {
                        return (TmBoarding.ContactSummaryDetails)handleMethodInvocation('getContactSummaryDetails', new List<Object>{itemId});
                }
                public TmBoarding.ReportDetails getPacketReport(String item , Boolean isMasterSvcRequired) {
                        return (TmBoarding.ReportDetails)handleMethodInvocation('getPacketReport', new List<Object>{item, isMasterSvcRequired});
                }
                public TmBoarding.ReportDetails getTmOperationsReport(TM_Service_Request__c r) {
                        return (TmBoarding.ReportDetails)handleMethodInvocation('getTmOperationsReport', new List<OBject>{r});
                }
                public TmBoarding.ProductConfig getTemplatesForProduct(String product) {
                        return (TmBoarding.ProductConfig)handleMethodInvocation('getTemplatesForProduct', new List<Object>{product});
                }
                public TmBoarding.UserBoardingDetails getBoardingUserInfo(string packetId) {
                        return (TmBoarding.UserBoardingDetails)handleMethodInvocation('getBoardingUserInfo', new List<Object>{packetId});
                }
                public Blob getMasterServiceAgreement(string packetId) {
                        return (Blob)handleMethodInvocation('getMasterServiceAgreement', new List<Object>{packetId});
                }
                public TmBoarding.ReportDetails getEmptyReports(List<string> products) {
                        return (TmBoarding.ReportDetails)handleMethodInvocation('getEmptyReports', new List<Object>{products});
                }
        }

        public class ofISignerManager extends ApexMoq implements TmBoarding.ISignerManager {
                public boolean sendForSignature(string packetId, List<TmBoarding.SignerInfo> signers, List<string> tmRequests, boolean includeMaster, integer applicationId){
                        return (boolean)handleMethodInvocation('sendForSignature', new List<Object>{packetId, signers, tmRequests, includeMaster, applicationId});
                }
                public boolean sendForSignature(string clientName, string entityId, List<TmBoarding.SignerInfo> signers, List<string> relatedIds, integer applicationId){
                        return (boolean)handleMethodInvocation('sendForSignature', new List<Object>{clientName, entityId, signers, relatedIds, applicationId});
                }
        }

        public class ofIServiceRequestBuilder extends ApexMoq implements TmBoarding.IServiceRequestBuilder {
                public List<TmBoardingServiceProxy.HtmlToSignatureRequest> build(string packetId, List<TmBoarding.SignerInfo> signers, List<string> products, boolean includeMaster, integer applicationId) {
                        return (List<TmBoardingServiceProxy.HtmlToSignatureRequest>)handleMethodInvocation('build', new List<object>{packetId, signers, products, includeMaster, applicationId});
                }
                public List<TmBoardingServiceProxy.HtmlToSignatureRequest> buildTMSADataForEntity(string clientName, string entityId, List<TmBoarding.SignerInfo> signers, List<string> items , integer applicationId){
                        return (List<TmBoardingServiceProxy.HtmlToSignatureRequest>)handleMethodInvocation('buildTMSADataForEntity', new List<object>{clientName, entityId, signers, items, applicationId});
                }
        }

        public class ofIServiceClientInfoProvider extends ApexMoq implements TmBoarding.IServiceClientInfoProvider {
                public List<TmBoardingServiceProxy.ClientInfo> getClientInfo(Map<String, Contact> contacts, List<TmBoarding.SignerInfo> signers, String roleIdentifier) {
                        return (List<TmBoardingServiceProxy.ClientInfo>)handleMethodInvocation('getClientInfo', new List<Object>{contacts, signers, roleIdentifier});
                }
        }

        public class ofITmBoardingServiceProxy extends ApexMoq implements TmBoardingServiceProxy.ITmBoardingServiceProxy {
                public  TmBoardingServiceProxy.SvcResponse sendForSignature(List<TmBoardingServiceProxy.HtmlToSignatureRequest> request) {
                        return (TmBoardingServiceProxy.SvcResponse)handleMethodInvocation('sendForSignature', new List<Object>{request});
                }
                public void sendMaintenanceStatus(string request){
                        handleMethodInvocation('sendMaintenanceStatus', new List<OBject>{request});
                }
        }

        public class ofIApproval extends ApexMoq implements TmBoarding.IApproval {
                public ApprovalProcess.ApprovalProcessInformation getApprovalInfo(Tm_Service_Request__c record){
                        return ( ApprovalProcess.ApprovalProcessInformation)handleMethodInvocation('getApprovalInfo', new List<Object>{record});
                }
                public ApprovalProcess.ApprovalSubmitResponse submitApprovalOrRecall(Tm_Service_request__c record, String action){
                        return (ApprovalProcess.ApprovalSubmitResponse)handleMethodInvocation('submitApprovalOrRecall', new List<Object>{record, action});
                }
        }
}