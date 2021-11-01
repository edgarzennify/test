@isTest
public class Mock {

    public class ofIApexPages extends ApexMoq implements IApexPages{
        public void addMessage(ApexPages.Severity sev, String msg){
            handleMethodInvocation('addMessage', new List<Object>{sev, msg});
        }
        public void addMessage(ApexPages.Message msg){
            handleMethodInvocation('addMessage', new List<Object>{msg});
        }
        public System.PageReference currentPage(){
            return (System.PageReference)handleMethodInvocation('currentPage');
        }
        public List<ApexPages.Message> getMessages(){
            return (List<ApexPages.Message>)handleMethodInvocation('getMessages');
        }
        public Boolean hasMessages(){
            return (Boolean)handleMethodInvocation('hasMessages');
        }
        public Boolean hasMessages(ApexPages.Severity sev){
            return (Boolean)handleMethodInvocation('hasMessages', new List<Object>{sev});
        }
        public String getParameter(String queryParameter){
            return (String)handleMethodInvocation('getParameter', new List<Object>{queryParameter});
        }
        public Map<String,String> getParameters(){
            return (Map<String,String>)handleMethodInvocation('getParameters');
        }
    }

    public class ofIAccountNumberServiceProxy extends ApexMoq implements AccountNumberServiceProxy.IAccountNumberService {
        public AccountNumberServiceProxy.AccountNumberSvcResponse getNewAccountNumber(String cardNumberUrl) {
            return (AccountNumberServiceProxy.AccountNumberSvcResponse)handleMethodInvocation('getNewAccountNumber', new List<Object>{cardNumberUrl});
        }
        public AccountNumberServiceProxy.AccountNumbersSvcResponse getNewAccountNumbers(String cardNumberUrl, Integer numberOfAccounts){
            return (AccountNumberServiceProxy.AccountNumbersSvcResponse)handleMethodInvocation('getNewAccountNumbers', new List<Object>{cardNumberUrl,numberOfAccounts});
        }
    }

    public class ofIAttachmentHandler extends ApexMoq implements AttachmentHandler.IAttachmentHandler{
        public Id generateAttachmentFromPageRef(PageReference pageRef, String attachmentName, Id parentId){
            return (Id)handleMethodInvocation('generateAttachmentFromPageRef', new List<Object>{pageRef, attachmentName, parentId});
        }
        public List<Attachment> getAllAttachmentsForParent(Id parentId){
            return (List<Attachment>)handleMethodInvocation('getAllAttachmentsForParent', new List<Object>{parentId});
        }
        public List<Attachment> getAttachmentsForParent(Id parentId, Integer maxAttachment) {
            return (List<Attachment>)handleMethodInvocation('getAttachmentsForParent', new List<Object>{parentId, maxAttachment});
        }
        public List<Attachment> getAllAttachmentsForParents(List<Id> parentIds) {
            return (List<Attachment>)handleMethodInvocation('getAllAttachmentsForParents', new List<object>{parentIds});
        }
        public Map<Id, List<Attachment>> getAttachmentsByParents(List<Id> parentIds) {
            return (Map<Id, List<Attachment>>)handleMethodInvocation('getAttachmentsByParents', new List<Object>{parentIds});
        }
    }

    public class ofICachedMap extends ApexMoq implements CachedMap.ICachedMap{
        public void put(String key, Object value){
            handleMethodInvocation('put', new List<Object>{key, value});
        }
        public Object get(String key){
            return (Object)handleMethodInvocation('get', new List<Object>{key});
        }
        public Boolean containsKey(String key){
            return (Boolean)handleMethodInvocation('containsKey', new List<Object>{key});
        }
        public Integer size(){
            return (Integer)handleMethodInvocation('size');
        }
        public void remove(String key){
            handleMethodInvocation('remove', new List<Object>{key});
        }
        public List<Object> values(){
            return (List<Object>)handleMethodInvocation('values');
        }
        public void clear(){
            handleMethodInvocation('clear');
        }
    }

    public class ofICardRepository extends ApexMoq implements CardRepository.ICardRepository {
        public List<DmCardInformation> getDepositCards() {
            return (List<DmCardInformation>)handleMethodInvocation('getDepositCards');
        }
        public List<DmCardInformation> getLoanCards() {
            return (List<DmCardInformation>)handleMethodInvocation('getLoanCards');
        }
        public List<DmCardInformation> getTmCards() {
            return (List<DmCardInformation>)handleMethodInvocation('getTmCards');
        }
    }

    public class ofIConfigurations extends ApexMoq implements Configurations.IConfigurations{
        public Integer getRelationshipReviewRequiredGracePeriod(){
            return (Integer)handleMethodInvocation('getRelationshipReviewRequiredGracePeriod');
        }
        public String getDefaultRelationshipOversightApprover(){
            return (String)handleMethodInvocation('getDefaultRelationshipOversightApprover');
        }
        public Boolean isSandbox(){
            return (Boolean)handleMethodInvocation('isSandbox'); 
        }
        public Integer creditRelationshipReportId(){
            return (Integer)handleMethodInvocation('creditRelationshipReportId'); 
        }
        public Integer creditRelationshipOreoReportId(){
            return (Integer)handleMethodInvocation('creditRelationshipOreoReportId'); 
        }
        public String creditRelationshipSnapshotUrl(){
            return (String)handleMethodInvocation('creditRelationshipSnapshotUrl'); 
        }
        public String creditRelationshipSnapshotOREOUrl(){
            return (String)handleMethodInvocation('creditRelationshipSnapshotOREOUrl'); 
        }
        public String baseReportUrl(){
            return (String)handleMethodInvocation('baseReportUrl'); 
        }
        public String certificateName(){
            return (String)handleMethodInvocation('certificateName'); 
        }
        public String creditRelationshipSaveReportBaseUrl(){
            return (String)handleMethodInvocation('creditRelationshipSaveReportBaseUrl'); 
        }
        public String creditRelationshipOreoSaveReportBaseUrl(){
            return (String)handleMethodInvocation('creditRelationshipOreoSaveReportBaseUrl'); 
        }
        public String restServiceBaseUrl(){
            return (String)handleMethodInvocation('restServiceBaseUrl'); 
        }
        public String get(String key) {
            return (String) handleMethodInvocation('get', new List<Object>{key});
        }
        public Object get(Schema.SObjectType soType, String key){
            return (Object)handleMethodInvocation('get', new List<Object>{soType, key});
        }
        public String barcodeGeneratorUploadDrawerName() {
            return (String)handleMethodInvocation('barcodeGeneratorUploadDrawerName');
        }
    }

    public class OfICrypto extends ApexMoq implements CryptoWrapper.ICrypto{
        public Blob generateDigest(string algo, Blob textAsBlob){
            return (Blob)handleMethodInvocation('generateDigest', new List<Object>{algo, textAsBlob});
        }
    }

    public virtual class ofIDataProvider extends ApexMoq implements DataProvider.IDataProvider {
        public void save(SObject obj) {
            handleMethodInvocation('save', new List<Object>{obj});
        }
        public void save(List<SObject> objs) {
            handleMethodInvocation('save', new List<Object>{objs});
        }
        public List<String> saveObjects(List<SObject> sobjs) {
            return (List<String>)handleMethodInvocation('saveObjects', new List<OBject>{sobjs});
        }
        public void remove(SObject obj) {
            handleMethodInvocation('remove', new List<Object>{obj});
        }
        public void remove(List<SObject> objs) {
            handleMethodInvocation('remove', new List<Object>{objs});
        }
        public List<String> removeObjects(List<SObject> objs) {
            return (List<string>)handleMethodInvocation('removeObjects', new List<Object>{objs});
        }
        public List<DataProvider.DynamicQueryResult> executeDynamicQuery(String query, List<String> fieldNames) {
            return (List<DataProvider.DynamicQueryResult>)handleMethodInvocation('executeDynamicQuery', new List<Object>{query, fieldNames});
        }
    }

    public class ofIDescribeFieldResult extends ApexMoq implements IDescribeFieldResult {
        public String getLabel() {
            return (String)handleMethodInvocation('getLabel');
        }
        public String getName() {
            return (String)handleMethodInvocation('getName');
        }
        public String getInlineHelpText() {
            return (String)handleMethodInvocation('getInlineHelpText');
        }
        public List<ISObjectType> getReferenceTo() {
            return (List<ISObjectType>)handleMethodInvocation('getReferenceTo');
        }
        public DescribeFieldResultWrapper.Type getType() {
            return (DescribeFieldResultWrapper.Type)handleMethodInvocation('getType');
        }
        public Boolean isUpdateable() {
            return (Boolean)handleMethodInvocation('isUpdateable');
        }
        public Boolean isCreateable() {
            return (Boolean)handleMethodInvocation('isCreateable');
        }
        public Boolean isCalculated() {
            return (Boolean)handleMethodInvocation('isCalculated');
        }
        public Boolean isAccessible() {
            return (Boolean)handleMethodInvocation('isAccessible');
        }
        public List<IPicklistEntry> getPicklistValues() {
            return (List<IPicklistEntry>)handleMethodInvocation('getPicklistValues');
        }
    }

    public class ofIDescribesObjectResult extends ApexMoq implements IDescribeSObjectResult {
        public IDescribeFieldResult getFieldResult(String fieldName){
            return (IDescribeFieldResult)handleMethodInvocation('getFieldResult', new List<Object>{fieldName});
        }
        public String getName(){
            return (String)handleMethodInvocation('getName');
        }
    }

    public class OfIDigitalSignatureFormGeneratorProxy extends ApexMoq implements DigitalSignatureFormGeneratorProxy.IProxy{
        public DigitalSignatureFormGeneratorProxy.SignatureResponse sendForSignature( DigitalSignatureFormGeneratorProxy.SignatureRequest req){
            return (DigitalSignatureFormGeneratorProxy.SignatureResponse)handleMethodInvocation('sendForSignature', new List<object>{req});
        }
        public DigitalSignatureFormGeneratorProxy.PdfResponse getPdfAsbase64(DigitalSignatureFormGeneratorProxy.SignatureRequest request){
            return (DigitalSignatureFormGeneratorProxy.PdfResponse)handleMethodInvocation('getPdfAsbase64', new List<Object>{request});
        }
        public DigitalSignatureFormGeneratorProxy.SignatureStatusDataResponse getData(string appId){
            return (DigitalSignatureFormGeneratorProxy.SignatureStatusDataResponse)handleMethodInvocation('getData', new List<Object>{appId});
        }
    }

    public class ofIDocumentDataService extends ApexMoq implements Documents.IDocumentDataService{
        public string BuildKey(String keyType, String pageKey, Boolean includeRelated){
            return (string)handleMethodInvocation('BuildKey', new List<Object>{keyType,pageKey,includeRelated});
        } 
        public List<Documents.ICacheable> LoadList(String listKey, String sortByProperty, String sortByDirection, Integer pageSize, Integer pageNumber, String conditions, Documents.ICacheable obj){
            return (List<Documents.ICacheable>)handleMethodInvocation('LoadList', new List<Object>{listKey, sortByProperty, sortByDirection, pageSize, pageNumber, conditions, obj});
        }
        public void ExpireCache(String objectId) {
            handleMethodInvocation('ExpireCache', new List<Object>{objectId});
        }
        public void ExpireCache(String keyType, String pageKey) {
            handleMethodInvocation('ExpireCache', new List<Object>{keyType, pageKey});
        }
        public void SaveList(List<Documents.ICacheable> objects, String listKey) {
            handleMethodInvocation('SaveList', new List<Object>{objects, listKey});
        }
    }

    public class ofIEbDocRepoProvider extends ApexMoq implements EbDocRepoProvider.IEbDocRepoProvider {
        public DmDocument GetFileByEbDocId(Id fileId) {
            return (DmDocument)handleMethodInvocation('GetFileByEbDocId', new List<Object>{fileId});
        }
        public Boolean FileExistsByEbDocId(Id fileId){
            return (Boolean)handleMethodInvocation('FileExistsByEbDocId', new List<Object>{fileId});
        }
        public DmDocument GetFileByEbDocName(string docName){
            return (DmDocument)handleMethodInvocation('GetFileByEbDocName',new List<Object>{docName});
        }
    }
    
    public class ofIEbObjectLookup extends ApexMoq implements EbObjectLookup.IEbObjectLookup {
        public Id getObjectId(String key) {
            return (Id)handleMethodInvocation('getObjectId', new List<Object>{key});
        }
        public Id getObjectId(String key, String keyType) {
            return (Id)handleMethodInvocation('getObjectId', new List<Object>{key, keyType});
        }
        public String getObjectKey(String objectId) {
            return (String)handleMethodInvocation('getObjectKey', new List<Object>{objectId});
        }
        public EbObjectLookup.KeyAndType getObjectKeyAndType(String item) {
            return (EbObjectLookup.KeyAndType)handleMethodInvocation('getObjectKeyAndType', new List<Object>{item});
        }
    }

    public class ofIEncodingUtil extends ApexMoq implements IEncodingUtil {
        public Blob fromBase64(String content) {
            return (Blob)handleMethodInvocation('fromBase64', new List<Object>{content});
        }

        public String toBase64(Blob content) {
            return (String)handleMethodInvocation('toBase64', new List<Object>{content});
        }
        public Blob toBytes(String content) {
            return (Blob)handleMethodInvocation('toBytes', new List<Object>{content});
        }
        public String convertToHex(Blob hash){
            return (String)handleMethodInvocation('convertToHex', new List<Object>{hash});
        }
    }

    public class ofIErrorRepository extends ApexMoq implements ErrorRepository.IErrorRepository {
        public void addWarning(String warning) {
            handleMethodInvocation('addWarning', new List<Object>{warning});
        }
        public void addError(String error) {
            handleMethodInvocation('addError', new List<OBject>{error});
        }
        public void addErrors(List<String> errors) {
            handleMethodInvocation('addErrors', new List<Object>{errors});
        }
        public void addInfo(String info) {
            handleMethodInvocation('addInfo', new List<Object>{info});
        }
        public void resetErrors() {
            handleMethodInvocation('resetErrors');
        }
        public void resetWarnings() {
            handleMethodInvocation('resetWarnings');
        }
        public ErrorRepository.ErrorDetails get() {
            return (ErrorRepository.ErrorDetails)handleMethodInvocation('get');
        }
        public List<String> getErrors() {
            return (List<String>)handleMethodInvocation('getErrors');
        }
        public List<String> getUniqueErrors() {
            return (List<String>)handleMethodInvocation('getUniqueErrors');
        }
        public List<String> getWarnings() {
            return (List<String>)handleMethodInvocation('getWarnings');
        }
    }

    public class ofIEventLogWriter extends ApexMoq implements EventLogWriter.IEventLogWriter{
        public EventLog__c createLog(String loglevel, String application, String message, String LocationDetails){
            return (EventLog__c)handleMethodInvocation('createlog', new List<Object>{logLevel, application, message, LocationDetails});
        }
    }

    public class ofIHtmlCoding extends ApexMoq implements HtmlCoding.IHtmlCoding{
        public String unEscape(string encodedText){
            return (String)handleMethodInvocation('unEscape', new List<Object>{encodedText});
        }
        public String httpRequestSanitizer(string text){
            return (String)handleMethodInvocation('httpRequestSanitizer', new List<OBject>{text});
        }
    }

    public class ofIHtmlReportingService extends ApexMoq implements HtmlReportingServiceProxy.IHtmlReportingService {
        public Blob getPdf(String staticResourceName, String fileName, String jsonData) {
            return (Blob)handleMethodInvocation('getPdf', new List<Object>{staticResourceName, fileName, jsonData});
        }
        public Blob getPdf(Blob template, String jsonData) {
            return (Blob)handleMethodInvocation('getPdf', new List<Object>{template, jsonData});
        }
        public Blob getMergedPdfs(List<HtmlReportingServiceProxy.MergeRequest> retuests) {
            return (Blob)handleMethodInvocation('getMergedPdfs', new List<Object>{retuests});
        }
        public Blob getHtml(Blob template, String data) {
            return (Blob)handleMethodInvocation('getHtml', new List<Object>{template, data});
        }
    }

    public class ofIImagingServiceProxy extends ApexMoq implements ImagingServiceProxy.IImagingServiceProxy{
        public ImagingServiceProxy.DocumentMetadata storeDocument(ImagingServiceProxy.StoreDocumentRequest request){
            return (ImagingServiceProxy.DocumentMetadata)handleMethodInvocation('storeDocument', new List<Object>{ request});
        }
        public List<String> retrieveDocument(String documentId){
            return (List<String>)handleMethodInvocation('retrieveDocument', new List<Object>{documentId} );
        }
        public List<DrawerPrivilege> getDrawerPrivilegesByEmailAddress(String emailAddress){
            return (List<DrawerPrivilege>)handleMethodInvocation('getDrawerPrivilegesByEmailAddress', new List<Object>{emailAddress});
        }
        public List<RelNavDocument> getRelNavDocuments(String keyType, List<String> keys, Boolean includeRelated){
            return (List<RelNavDocument>)handleMethodInvocation('getRelNavDocuments', new List<Object>{keyType, keys, includeRelated});
        }
        public List<ImagingServiceProxy.DocumentMetadata> getDocumentMetadata(List<String> keys){
            return (List<ImagingServiceProxy.DocumentMetadata>)handleMethodInvocation('getDocumentMetadata', new List<Object>{keys});
        }
        public void updateDocumentKeys(List<ImagingServiceProxy.UpdateDocumentKeysRequest> requests){
            handleMethodInvocation('updateDocumentKeys', new List<Object>{requests});
        }
        public void updateDocumentKeys_Async(List<ImagingServiceProxy.UpdateDocumentKeysRequest> requests){
            handleMethodInvocation('updateDocumentKeys_Async', new List<Object>{requests});
        }
        public String getChunkedMessageToken(ImagingServiceProxy.RequestMessageToken request){
            return (String)handleMethodInvocation('getChunkedMessageToken', new List<Object>{request});
        }
        public ImagingServiceProxy.DocumentMetadata storeDocumentChunked(ImagingServiceProxy.RequestChunk request){
            return (ImagingServiceProxy.DocumentMetadata)handleMethodInvocation('storeDocumentChunked', new List<Object>{request});
        }
        public String initializeChunkedDocument(ImagingServiceProxy.RequestMessageToken tokenRequest) {
            return (String)handleMethodInvocation('initializeChunkedDocument', new List<Object>{tokenRequest});
        }
        public void appendChunkedDocument(ImagingServiceProxy.RequestChunk chunk) {
            handleMethodInvocation('appendChunkedDocument', new List<Object>{chunk});
        }
        public ImagingServiceProxy.DocumentMetadata finalizeChunkedDocument(ImagingServiceProxy.RequestFinalization req) {
            return (ImagingServiceProxy.DocumentMetadata)handleMethodInvocation('finalizeChunkedDocument', new List<Object>{req});
        }
    }

    public class ofIJson extends ApexMoq implements IJson{
        public String serialize(Object objectToSerialize){
            return (String)handleMethodInvocation('serialize', new List<Object>{objectToSerialize});
        }
        public String serializePretty(Object objectToSerialize){
            return (String)handleMethodInvocation('serializePretty', new List<Object>{objectToSerialize});
        }
        public Object deserialize(String jsonString, System.Type apexType){
            return (Object)handleMethodInvocation('deserialize', new List<Object>{jsonString, apexType});
        }
    }

    public class ofIKeyValueDataProvider extends ApexMoq implements KeyValueDataProvider.IKeyValueDataProvider {
        public Object get(Schema.SObjectType soType, String key){
            return (Object)handleMethodInvocation('get', new List<Object>{soType, key});
        }
    }

    public class ofILoanAppComplianceCalculator extends ApexMoq implements LoanAppComplianceCalculator.ILoanAppComplianceCalculator{
        public void updateComplianceFieldsForLoanApps(Set<Id> loanAppIds){
            handleMethodInvocation('updateComplianceFieldsForLoanApps', new List<Object>{loanAppIds});
        }
    }

    public class ofILoanAppWrapper extends ApexMoq implements LoanAppWrapper.ILoanAppWrapper{
        public Boolean isAgriculturalPurpose(){
            return (Boolean)handleMethodInvocation('isAgriculturalPurpose');
        }
        public Boolean isAllResidentialRealEstateCollateralTakenAsAbundanceOfCaution(){
            return (Boolean)handleMethodInvocation('isAllResidentialRealEstateCollateralTakenAsAbundanceOfCaution');
        }
        public Boolean isBusinessPurpose(){
            return (Boolean)handleMethodInvocation('isBusinessPurpose');
        }
        public Boolean isConstructionLandDevelopment(){
            return (Boolean)handleMethodInvocation('isConstructionLandDevelopment');
        }
        public Boolean isHMDAEligibleLoanType(){
            return (Boolean)handleMethodInvocation('isHMDAEligibleLoanType');
        }
        public Boolean isHOEPAEligibleLoanType(){
            return (Boolean)handleMethodInvocation('isHOEPAEligibleLoanType');
        }
        public Boolean isHOEPAPurposeToFinanceInitialConstructionOfPrincipalDwelling(){
            return (Boolean)handleMethodInvocation('isHOEPAPurposeToFinanceInitialConstructionOfPrincipalDwelling');
        }
        public Boolean isHomeImprovement(){
            return (Boolean)handleMethodInvocation('isHomeImprovement');
        }
        public Boolean isLetterOfCredit(){
            return (Boolean)handleMethodInvocation('isLetterOfCredit');
        }
        public Boolean isLoanAmountOver500K(){
            return (Boolean)handleMethodInvocation('isLoanAmountOver500K');
        }
        public Boolean isLoanAmountOver1M(){
            return (Boolean)handleMethodInvocation('isLoanAmountOver1M');
        }
        public Boolean isModificationWithoutIncreasedLoanAmount(){
            return (Boolean)handleMethodInvocation('isModificationWithoutIncreasedLoanAmount');
        }
        public Boolean isOriginalLoanAmountOver500K(){
            return (Boolean)handleMethodInvocation('isOriginalLoanAmountOver500K');
        }
        public Boolean isOriginalLoanAmountOver1M(){
            return (Boolean)handleMethodInvocation('isOriginalLoanAmountOver1M');
        }
        public Boolean isPurchaseResidentialRealEstate(){
            return (Boolean)handleMethodInvocation('isPurchaseResidentialRealEstate');
        }
        public Boolean isPurposeOfLoanToBuySecurities(){
            return (Boolean)handleMethodInvocation('isPurposeOfLoanToBuySecurities');
        }
        public Boolean isCRAEligibleLoanType(){
            return (Boolean)handleMethodInvocation('isCRAEligibleLoanType');
        }
        public Boolean isCRAEligibleRecordType(){
            return (Boolean)handleMethodInvocation('isCRAEligibleRecordType');
        }
        public Boolean isRefinanceToPayoffExistingDebtBySameBorrower(){
            return (Boolean)handleMethodInvocation('isRefinanceToPayoffExistingDebtBySameBorrower');
        }
        public Boolean isRefinanceResidentialRealEstate(){
            return (Boolean)handleMethodInvocation('isRefinanceResidentialRealEstate');
        }
        public Boolean isResidentialRehab(){
            return (Boolean)handleMethodInvocation('isResidentialRehab');
        }
        public Boolean hasCRAEligibleCollateral(){
            return (Boolean)handleMethodInvocation('hasCRAEligibleCollateral');
        }
        public Boolean hasDwellingCollateral(){
            return (Boolean)handleMethodInvocation('hasDwellingCollateral');
        }
        public Boolean hasNonCommercialRealEstateCollateral(){
            return (Boolean)handleMethodInvocation('hasNonCommercialRealEstateCollateral');
        }
        public Boolean hasPurchasedParticipation(){
            return (Boolean)handleMethodInvocation('hasPurchasedParticipation');
        }
        public Boolean hasRealEstateCollateral(){
            return (Boolean)handleMethodInvocation('hasRealEstateCollateral');
        }
    }

    public class ofIObjectActionLogService extends ApexMoq implements ObjectActionLogService.IObjectActionLogService{
        public List<ObjectActionLogService.Data> get(ObjectActionLogService.ObjectAndTypeRequest request){
            return (List<ObjectActionLogService.Data>)handleMethodInvocation('get', new List<Object>{request});
        }
        public Map<string, List<ObjectActionLogService.Data>> get(List<ObjectActionLogService.ObjectRequest> requests, String actionType){
            return (Map<string, List<ObjectActionLogService.Data>>)handleMethodInvocation('get', new List<Object>{requests, actionType});
        }        
        public void log(String objectName, String objectRecordId, String actionType, String action){
            handleMethodInvocation('log', new List<Object>{objectName, objectRecordId, actionType, action});
        }
        public void recordCachedLogs(){
            handleMethodInvocation('recordCachedLogs');
        }
        public List<Object_Action_Log__c> getCachedLogs(){
            return (List<Object_Action_Log__c>)handleMethodInvocation('getCachedLogs');
        }
    }

    public class ofIParentRelationshipSvc extends ApexMoq implements ParentRelationshipSvc.IParentRelationshipSvc{
        public Account getTopLevelParent(Id entityId){
            return (Account)handleMethodInvocation('getTopLevelParent', new List<Object>{entityId});
        }
        public Map<Id, Account> getAllRelatedEntitiesForParent(Id topLevelEntityId){
            return (Map<Id, Account>)handleMethodInvocation('getAllRelatedEntitiesForParent', new List<Object>{topLevelEntityId});
        }
        public void setTopLevelParentForEntity(Account entity){
            handleMethodInvocation('setTopLevelParentForEntity', new List<Object>{entity});
        }
        public void flattenRelatedChildrenForEntity(Account entity){
            handleMethodInvocation('flattenRelatedChildrenForEntity', new List<Object>{entity});
        }
    }

    
    public class ofIParentRelTreeBuilderDataProv extends ApexMoq implements ParentRelTreeBuilderDataProv.IParentRelTreeBuilderDataProv{
        public Account getEntity(Id acctId){
            return (Account)handleMethodInvocation('getEntity', new List<Object>{acctId});
        }
        public Map<Id, Account> getChildrenForEntities(Set<Id> acctIds){
            return (Map<Id, Account>)handleMethodInvocation('getChildrenForEntities', new List<Object>{acctIds});
        }
        public Map<Id, Account> getTopLevelAccountsForOwners(Set<Id> ownerIds){
            return (Map<Id, Account>)handleMethodInvocation('getTopLevelAccountsForOwners', new List<Object>{ownerIds});
        }
        public void updateEntities(List<Account> entities){
            handleMethodInvocation('updateEntities', new List<Object>{entities});
        }
    }

    public class ofIParentRelTreeBuilder extends ApexMoq implements ParentRelationships.IParentRelTreeBuilder{
        public List<Map<Id, Account>> getRelationshipTreesForOwners(Set<Id> ownerIds){
            return (List<Map<Id, Account>>)handleMethodInvocation('getRelationshipTreesForOwners', new List<Object>{ownerIds});
        }
        public List<Map<Id, Account>> getRelationshipTreeForEntity(Id entityId, Boolean ignoreLookupForParent, Id excludeChildId){
            return (List<Map<Id, Account>>)handleMethodInvocation('getRelationshipTreeForEntity', new List<Object>{entityId, ignoreLookupForParent, excludeChildId});
        }
        public List<Map<Id, Account>> addChildToRelationshipTreeOfParent(Id parentIDofNewChild, Id childID, String relationshipToParent){
            return (List<Map<Id, Account>>)handleMethodInvocation('addChildToRelationshipTreeOfParent', new List<Object>{parentIDofNewChild, childId, relationshipToParent});
        }
        public List<ParentRelationships.RelatedEntity> getRelationshipTreeListForDisplay(List<Map<Id, Account>> relTree, Id currentId){
            return (List<ParentRelationships.RelatedEntity>)handleMethodInvocation('getRelationshipTreeListForDisplay', new List<Object>{relTree, currentId});
        }
    }

    public class ofIPicklistEntry extends ApexMoq implements IPicklistEntry {
        public String getLabel() {
            return (String)handleMethodInvocation('getLabel');
        }
        public String getValue() {
            return (String)handleMethodInvocation('getValue');
        }
        public Boolean isActive() {
            return (Boolean)handleMethodInvocation('isActive');
        }
        public Boolean isDefaultValue() {
            return (Boolean)handleMethodInvocation('isDefaultValue');
        }
    }

    public class ofIPricingWkstDataProv extends ApexMoq implements PricingWkst.IPricingWkstDataProv{
        public List<EB_Account__c> getEBAccountsForEntities(Set<Id> entityIDs, Set<Integer> applicationCodes){
            return (List<EB_Account__c>)handleMethodInvocation('getEBAccountsForEntities', new List<Object>{entityIDs, applicationCodes});
        }
        public void addPricingWorksheet(Pricing_Worksheet__c worksheet){
            handleMethodInvocation('addPricingWorksheet', new List<Object>{worksheet});
        }
        public Pricing_Worksheet__c getPricingWorksheet(Id worksheetId){
            return (Pricing_Worksheet__c)handleMethodInvocation('getPricingWorksheet', new List<Object>{worksheetId});
        }
        public void updatePricingWorksheet(Pricing_Worksheet__c worksheet){
            handleMethodInvocation('updatePricingWorksheet', new List<Object>{worksheet});
        }
        public List<EB_Loan_Packet__c> getLoanPacketsForEntities(Set<Id> entityIDs){
            return (List<EB_Loan_Packet__c>)handleMethodInvocation('getLoanPacketsForEntities', new List<Object>{entityIDs});
        }
        public Map<Id, Pricing_Proposed_Loan__c> getPricingProposedLoansForWorksheet(Id worksheetId){
            return (Map<Id, Pricing_Proposed_Loan__c>)handleMethodInvocation('getPricingProposedLoansForWorksheet', new List<Object>{worksheetId});
        }
        public Map<Id, Pricing_Proposed_Deposit__c> getPricingProposedDepositsForWorksheet(Id worksheetId){
            return (Map<Id, Pricing_Proposed_Deposit__c>)handleMethodInvocation('getPricingProposedDepositsForWorksheet', new List<Object>{worksheetId});
        }
        public Map<Id, Pricing_Proposed_Non_Interest_Income__c> getPricingProposedNonIntIncomeForWorksheet(Id worksheetId){
            return (Map<Id, Pricing_Proposed_Non_Interest_Income__c>)handleMethodInvocation('getPricingProposedNonIntIncomeForWorksheet', new List<Object>{worksheetId});
        }
        public Map<Id, Pricing_Proposed_Account_Removal__c> getPricingProposedAcctRemovalsForWorksheet(Id worksheetId){
            return (Map<Id, Pricing_Proposed_Account_Removal__c>)handleMethodInvocation('getPricingProposedAcctRemovalsForWorksheet', new List<Object>{worksheetId});
        }
        public void addPricingProposedLoans(List<Pricing_Proposed_Loan__c> propLoans){
            handleMethodInvocation('addPricingProposedLoans', new List<Object>{propLoans});
        }
        public void addPricingProposedDeposits(List<Pricing_Proposed_Deposit__c> propDeposits){
            handleMethodInvocation('addPricingProposedDeposits', new List<Object>{propDeposits});
        }
        public void addPricingProposedNonIntIncomes(List<Pricing_Proposed_Non_Interest_Income__c> propNonIntIncomes){
            handleMethodInvocation('addPricingProposedNonIntIncomes', new List<Object>{propNonIntIncomes});
        }
        public void addPricingProposedAcctRemovals(List<Pricing_Proposed_Account_Removal__c> propAcctRemovals){
            handleMethodInvocation('addPricingProposedAcctRemovals', new List<Object>{propAcctRemovals});
        }
        public Pricing_Proposed_Loan__c getPricingProposedLoan(Id propLoanId){
            return (Pricing_Proposed_Loan__c)handleMethodInvocation('getPricingProposedLoan', new List<Object>{propLoanId});
        }
        public Pricing_Proposed_Deposit__c getPricingProposedDeposit(Id propDepositId){
            return (Pricing_Proposed_Deposit__c)handleMethodInvocation('getPricingProposedDeposit', new List<Object>{propDepositId});
        }
        public Pricing_Proposed_Non_Interest_Income__c getPricingProposedNonIntIncome(Id propNonIntIncomeId){
            return (Pricing_Proposed_Non_Interest_Income__c)handleMethodInvocation('getPricingProposedNonIntIncome', new List<Object>{propNonIntIncomeId});
        }
        public Pricing_Proposed_Account_Removal__c getPricingProposedAcctRemoval(Id propAcctRemovalId){
            return (Pricing_Proposed_Account_Removal__c)handleMethodInvocation('getPricingProposedAcctRemoval', new List<Object>{propAcctRemovalId});
        }
        public String getWorksheetIdForEntity(Id entityId){
            return (String)handleMethodInvocation('getWorksheetIdForEntity', new List<Object>{entityId});
        }
        public void updatePricingProposedLoans(List<Pricing_Proposed_Loan__c> propLoans){
            handleMethodInvocation('updatePricingProposedLoans', new List<Object>{propLoans});
        }
        public void updatePricingProposedDeposits(List<Pricing_Proposed_Deposit__c> propDeposits){
            handleMethodInvocation('updatePricingProposedDeposits', new List<Object>{propDeposits});
        }
        public void updatePricingProposedNonIntIncomes(List<Pricing_Proposed_Non_Interest_Income__c> propNonIntIncomes){
            handleMethodInvocation('updatePricingProposedNonIntIncomes', new List<Object>{propNonIntIncomes});
        }
        public void updatePricingProposedAcctRemovals(List<Pricing_Proposed_Account_Removal__c> propAcctRemovals){
            handleMethodInvocation('updatePricingProposedAcctRemovals', new List<Object>{propAcctRemovals});
        }
        public void deletePricingProposedLoans(List<Pricing_Proposed_Loan__c> propLoans){
            handleMethodInvocation('deletePricingProposedLoans', new List<Object>{propLoans});
        }
        public void deletePricingProposedDeposits(List<Pricing_Proposed_Deposit__c> propDeposits){
            handleMethodInvocation('deletePricingProposedDeposits', new List<Object>{propDeposits});
        }
        public void deletePricingProposedNonIntIncomes(List<Pricing_Proposed_Non_Interest_Income__c> propNonIntIncomes){
            handleMethodInvocation('deletePricingProposedNonIntIncomes', new List<Object>{propNonIntIncomes});
        }
        public void deletePricingProposedAcctRemovals(List<Pricing_Proposed_Account_Removal__c> propAcctRemovals){
            handleMethodInvocation('deletePricingProposedAcctRemovals', new List<Object>{propAcctRemovals});
        }
    }

    public class ofIQueue extends ApexMoq implements IQueue {
        public void enqueue(Object item) {
            handleMethodInvocation('enqueue', new List<Object>{item});
        }
        public Object dequeue() {
            return (Object)handleMethodInvocation('dequeue');
        }
        public Boolean isEmpty() {
            return (Boolean)handleMethodInvocation('isEmpty');
        }
        public Object peek() {
            return (Object)handleMethodInvocation('peek');
        }
        public Integer size() {
            return (Integer)handleMethodInvocation('size');
        }
    }

    public class ofIQueueFactory extends ApexMoq implements QueueFactory.IQueueFactory {
        public IQueue getNewInstance() {
            return (IQueue)handleMethodInvocation('getNewInstance');
        }
    }

    public class ofIReportUrlProvider extends ApexMoq implements ReportUrlProvider.IReportUrlProvider{
        public string getReportUrl(string reportId){
            return (string)handleMethodInvocation('getReportUrl', new List<Object>{reportId});
        }
        public string getReportUrl(string reportId, List<string> parameters){
            return (string)handleMethodInvocation('getReportUrl', new List<Object>{reportId, parameters});
        }
    }

    public class ofIRESTService extends ApexMoq implements WebServices.IRESTService{
        public void Wakeup(){
            handleMethodInvocation('Wakeup');
        }
        public RESTUtility.result GET(String uri){
            return (RESTUtility.result)handleMethodInvocation('GET', new List<Object>{uri});
        }
        public RESTUtility.result GET(String uri, Map<string,string> headers){
            return (RESTUtility.result)handleMethodInvocation('GET', new List<Object>{uri,headers});
        }
        public RESTUtility.result GET(String apiName, String uri){
            return (RESTUtility.result)handleMethodInvocation('GET', new List<Object>{apiName, uri});
        }
        public RESTUtility.result GET(String apiName, String uri, Map<string,string> headers){
            return (RESTUtility.result)handleMethodInvocation('GET', new List<Object>{apiName, uri, headers});
        }
        public RESTUtility.result POST(String uri, String body){
            return (RESTUtility.result)handleMethodInvocation('POST', new List<Object>{uri, body});
        }
        public RESTUtility.result POST(String uri, String body, Map<string,string> headers){
            return (RESTUtility.result)handleMethodInvocation('POST', new List<Object>{uri, body, headers});
        }
        public RESTUtility.result POST(String apiName, String uri, String body){
            return (RESTUtility.result)handleMethodInvocation('POST', new List<Object>{apiName, uri, body});
        }
        public RESTUtility.result POST(String apiName, String uri, String body, Map<string, string> headers){
            return (RESTUtility.result)handleMethodInvocation('POST', new List<Object>{apiName, uri, body, headers});
        }
        public void POST_Async(String apiName, String uri, String body){
            handleMethodInvocation('POST_Async', new List<Object>{apiName, uri, body});
        }
        public void GET_Async(String apiName, String uri) {
            handleMethodInvocation('GET_Async', new List<Object>{apiName, uri});
        }
        public string GetApiResource(string apiName){
            return (string)handleMethodInvocation('GetApiResource', new List<Object>{apiName});
        }
    }

    public class ofIRuleEvaluator extends ApexMoq implements RuleEvaluator.IRuleEvaluator{
        public Boolean evaluate(DescribeFieldResultWrapper.Type type, Object subjectOperand, String ruleOperation, String ruleOperand){
            return (Boolean)handleMethodInvocation('evaluate', new List<Object>{type, subjectOperand, ruleOperation, ruleOperand});
        }
        public Boolean evaluate(String referenceObject, String referenceFieldName, Object subjectOperand, String ruleOperation, String ruleOperand){
            return (Boolean)handleMethodInvocation('evaluate', new List<Object>{referenceObject, referenceFieldName, subjectOperand, ruleOperation, ruleOperand});
        }
    }

    public class ofISchema extends ApexMoq implements ISchema {
        public ISObjectField getField(string objectName, string fieldName) {
            return (ISObjectField)handleMethodInvocation('getField', new List<Object>{objectName, fieldName});
        }
        public List<ISObjectField> getFields(string objectName) {
            return (List<ISObjectField>)handleMethodInvocation('getFields', new List<Object>{objectName});
        }
        public Map<string, ISObjectField> getFieldMap(string objectName) {
            return ( Map<string, ISObjectField>)handleMethodInvocation('getFieldMap', new List<Object>{objectName});
        }
        public ISObjectType getSObjectType(String objectName){
            return (ISObjectType)handleMethodInvocation('getSObjectType', new List<Object>{objectName});
        }
    }

    public class ofIShuntingYard extends ApexMoq implements ShuntingYard.IShuntingYard {
        public Boolean run(String formula, Map<String, Boolean> data) {
            return (Boolean)handleMethodInvocation('run', new List<Object>{formula, data});
        }
        public Boolean evaluate(String formula) {
            return (Boolean)handleMethodInvocation('evaluate', new List<Object>{formula});
        }
        public String formulaConverter(String formula, Map<String, Boolean> data) {
            return (String)handleMethodInvocation('formulaConverter', new List<Object>{formula, data});
        }
        public List<String> toPostfix(String formula) {
            return (List<String>)handleMethodInvocation('toPostfix', new List<object>{formula});
        }
    }

    public class ofISobject extends ApexMoq implements ISobject {
        public void addError(SObject sobj, String errorMessage) {
            handleMethodInvocation('addError', new List<Object>{sobj, errorMessage});
        }
    }

    public class ofISObjectField extends ApexMoq implements ISobjectField {
        public Boolean isUpdateable() {
            return (Boolean)handleMethodInvocation('isUpdateable');
        }
        public String getName() {
            return (String)handleMethodInvocation('getName');
        }
        public String getLabel() {
            return (String)handleMethodInvocation('getLabel');
        }
        public String getInlineHelpText() {
            return (String)handleMethodInvocation('getInlineHelpText');
        }
        public  Boolean isCreatable() {
            return (Boolean)handleMethodInvocation('isCreatable');
        }
        public Boolean isCalculated() {
            return (Boolean)handleMethodInvocation('isCalculated');
        }
        public Boolean isAccessible() {
            return (Boolean)handleMethodInvocation('isAccessible');
        }
        public DescribeFieldResultWrapper.Type getType() {
            return (DescribeFieldResultWrapper.Type)handleMethodInvocation('getType');
        }
        public List<IPicklistEntry> getPicklistValues() {
            return (List<IPicklistEntry>)handleMethodInvocation('getPicklistValues');
        }
        public IDescribeFieldResult getDescribe() {
            return (IDescribeFieldResult)handleMethodInvocation('getDescribe');
        }
    }
    
    public class ofISObjectFieldFactory extends ApexMoq implements SObjectFieldFactory.ISObjectFieldFactory {
        public ISObjectField getInstance(Schema.SObjectField fld) {
            return (ISObjectField)handleMethodInvocation('getInstance', new List<Object>{fld});
        }
    }

    public class ofISObjectType extends ApexMoq implements ISobjectType {
        public IDescribeSObjectResult getDescribe(){
            return (IDescribeSObjectResult)handleMethodInvocation('getDescribe');
        }
        public SObject newSObject(){
            return (SObject)handleMethodInvocation('newSObject');
        }
    }
	

    public class ofIStack extends ApexMoq implements IStack {
        public void push(Object item) {
            handleMethodInvocation('push', new List<Object>{item});
        }
        public Object pop() {
            return (Object)handleMethodInvocation('pop');
        }
        public Boolean isEmpty() {
            return (Boolean)handleMethodInvocation('isEmpty');
        }
        public Object peek() {
            return (Object)handleMethodInvocation('peek');
        }
        public Integer size() {
            return (Integer)handleMethodInvocation('size');
        }
    }

    public class ofIStackFactory extends ApexMoq implements StackFactory.IStackFactory {
        public IStack getNewInstance() {
            return (IStack)handleMethodInvocation('getNewInstance');
        }
    }

    public class ofISalesforceDocumentProvider extends ApexMoq implements Documents.ISalesforceDocumentProvider{
        public Document getDocument(String folderName, String documentName){
            return (Document) handleMethodInvocation('getDocument', new List<Object>{folderName, documentName});
        }

        public List<Document> getDocuments(List<String> documentIds) {
            return (List<Document>) handleMethodInvocation('getDocuments', new List<Object>{documentIds});
        }

        public Document saveDocument(String folderName, Document document){
            return (Document) handleMethodInvocation('saveDocument', new List<Object> {folderName, document});
        }
    }

    public class ofIStandardController extends ApexMoq implements IStandardController{
        public SObject getRecord(){
            return (SObject)handleMethodInvocation('getRecord');
        }
        public String getId(){
            return (String)handleMethodInvocation('getId');
        }
    }

    public class ofIStaticResource extends ApexMoq implements StaticResourceDataProvider.IStaticResource {
        public Blob getData(String staticResourceName) {
            return (Blob)handleMethodInvocation('getData', new List<Object>{staticResourceName});
        }
        public Blob getData(String staticResourceName, String fileNameInZippedFolder) {
            return (Blob)handleMethodInvocation('getData', new List<Object>{staticResourceName, fileNameInZippedFolder});
        }
    }

    public class ofISystem extends ApexMoq implements ISystem{
        public DateTime now(){
            return (DateTime)handleMethodInvocation('now');
        }
        public Date today(){
            return (Date)handleMethodInvocation('today');
        }
    }

    public class ofIUserInfoService extends ApexMoq implements IUserInfoService{
        public Id getCurrentUserId(){
            return (Id)handleMethodInvocation('getCurrentUserId');
        }
        public Boolean isSystemAdministrator(){
            return (Boolean)handleMethodInvocation('isSystemAdministrator');
        }
        public Boolean isSystemAdministrator(Id userId){
            return (Boolean)handleMethodInvocation('isSystemAdministrator', new List<Object>{userId});
        }
        public Boolean hasPermissionSet(String permissionSetLabel){
            return (Boolean)handleMethodInvocation('hasPermissionSet', new List<Object>{permissionSetLabel});
        }
        public Boolean hasPermissionSet(Id userId, String permissionSetLabel){
            return (Boolean)handleMethodInvocation('hasPermissionSet', new List<Object>{userId, permissionSetLabel});
        }
        public Profile getProfile(){
            return (Profile)handleMethodInvocation('getProfile');
        }
        public Profile getProfile(Id userId){
            return (Profile)handleMethodInvocation('getProfile', new List<Object>{userId});
        }
        public Map<String,PermissionSet> getPermissionSets(){
            return (Map<String,PermissionSet>)handleMethodInvocation('getPermissionSets');
        }
        public Map<String,PermissionSet> getPermissionSets(Id userId){
            return (Map<String,PermissionSet>)handleMethodInvocation('getPermissionSets', new List<Object>{userId});
        }
        public List<User> getUsersWithPermissionSet(String permissionSetLabel){
            return (List<User>)handleMethodInvocation('getUsersWithPermissionSet', new List<Object>{permissionSetLabel});
        }
        public Boolean isCurrentUserLicensed(String namespace){
            return (Boolean)handleMethodInvocation('isCurrentUserLicensed', new List<Object>{namespace});
        }
        public Map<User, UserRole> getUserRoleRelationship(){
            return (Map<User, UserRole>)handleMethodInvocation('getUserRoleRelationship');
        }
    }

    public class ofIUtility extends ApexMoq implements Utility.IUtility {
        public String getServerUrl(){
            return (String)handleMethodInvocation('getServerUrl');
        }
        public String getUrlFor(Id objId){
            return (String)handleMethodInvocation('getUrlFor', new List<Object>{objId});
        }
        public List<SelectOption> ListValuesFromObject(String SObjectType, String PicklistName){
            return (List<SelectOption>)handleMethodInvocation('ListValuesFromObject', new List<Object>{SObjectType, PicklistName});
        }
        public String DefaultPicklistValue(String SObjectType, String PicklistName){
            return (String)handleMethodInvocation('DefaultPicklistValue', new List<Object>{SObjectType, PicklistName});
        }
        public RecordType recordTypeObject(String SObjectType, Id recordTypeId){
            return (RecordType)handleMethodInvocation('recordTypeObject', new List<Object>{SObjectType, recordTypeId});
        }
        public RecordType recordTypeObject(String SObjectType, String recordTypeName){
            return (RecordType)handleMethodInvocation('recordTypeObject', new List<Object>{SObjectType, recordTypeName});
        }
        public List<RecordType> recordTypeObjects(String SObjectType){
            return (List<RecordType>)handleMethodInvocation('recordTypeObjects', new List<Object>{SObjectType});
        }
        public List<RecordType> recordTypeObjectList(String SObjectType, Id recordTypeId){
            return (List<RecordType>)handleMethodInvocation('recordTypeObjectList', new List<Object>{SObjectType, recordTypeId});
        }
        public List<RecordType> recordTypeObjectList(String SObjectType, String recordTypeName){
            return (List<RecordType>)handleMethodInvocation('recordTypeObjectList', new List<Object>{SObjectType, recordTypeName});
        }
        public boolean IsMiniModification (Id LoanAppRecordTypeId){
            return (boolean)handleMethodInvocation('', new List<Object>{LoanAppRecordTypeId});
        }
        public PageReference testhelper(String url){
            return (PageReference)handleMethodInvocation('testhelper', new List<Object>{url});
        }
        public List<SelectOption> sortOptionList(List<SelectOption> ListToSort){
            return (List<SelectOption>)handleMethodInvocation('sortOptionList', new List<Object>{ListToSort});
        }
        public Boolean isFieldEmpty(Schema.DisplayType typeOfField, Object fieldValue){
            return (Boolean)handleMethodInvocation('isFieldEmpty', new List<Object>{typeOfField, fieldValue});
        }
        public Object getValidFieldValue(Schema.DisplayType typeOfField){
            return (Object)handleMethodInvocation('getValidFieldValue', new List<Object>{typeOfField});
        }
        public Map<String,String> IsStageActionFieldValid(string parentobject, Map<string , Utility.QueryParam> QueryParamMap){
            return (Map<String,String>)handleMethodInvocation('IsStageActionFieldValid', new List<Object>{parentobject, QueryParamMap});
        }
        public boolean EvaluateExpression(String operand1, String operation, String operand2){
            return (boolean)handleMethodInvocation('EvaluateExpression', new List<Object>{operand1, operation, operand2});
        }
        public String NewGuidanceLineAdvance(){
            return (String)handleMethodInvocation('NewGuidanceLineAdvance');
        }
        public String LoanTypeGuidanceLine(){
            return (String)handleMethodInvocation('LoanTypeGuidanceLine');
        }
        public String LoanTypeGuidanceLineFixed(){
            return (String)handleMethodInvocation('LoanTypeGuidanceLineFixed');
        }
        public String LoanTypeGuidanceLineRevolving(){
            return (String)handleMethodInvocation('LoanTypeGuidanceLineRevolving');
        }
        public String convertid15ToId18(String id15){
            return (String)handleMethodInvocation('convertid15ToId18', new List<Object>{id15});
        }
        public String RemoveLastTextFromString(String text,string CharToBeRemoved){
            return (string)handleMethodInvocation('RemoveLastTextFromString', new List<Object>{text, CharToBeRemoved});
        }
        public String ListToDelimitedString(List<String> strings, String delimiter){
            return (String)handleMethodInvocation('ListToDelimitedString', new List<Object>{strings, delimiter});
        }
        public List<String> DelimitedStringToList(String delimited, String delimiter){
            return (List<String>)handleMethodInvocation('DelimitedStringToList', new List<Object>{delimited, delimiter});
        }
        public String escape( string value ){
            return (String)handleMethodInvocation('escape', new List<Object>{value});
        }
        public String unescape( string value ){
            return (String)handleMethodInvocation('unescape', new List<Object>{value});
        }
        public String getObjectNameFromId(String recordId){
            return (String)handleMethodInvocation('getObjectNameFromId', new List<Object>{recordId});
        }
        public void submitForApproval(Id objId){
            handleMethodInvocation('submitForApproval', new List<Object>{objId});
        }
        public void approveNextStep(Id objId){
            handleMethodInvocation('approveNextStep', new List<Object>{objId});
        }
        public void approveNextStep(Id objId, Id userId){
            handleMethodInvocation('approveNextStep', new List<Object>{objId, userId});
        }
        public void approveWorkflow(Id objId){
            handleMethodInvocation('approveWorkflow', new List<Object>{objId});
        }
        public Integer pendingApprovalSteps(Id objId){
            return (Integer)handleMethodInvocation('pendingApprovalSteps', new List<Object>{objId});
        }
        public void recallApprovalRequest(Id objId){
            handleMethodInvocation('recallApprovalRequest', new List<Object>{objId});
        }
        public Date ApproveDate(Id objId){
            return (Date)handleMethodInvocation('ApproveDate', new List<Object>{objId});
        }
        public void DeleteCache(){
            handleMethodInvocation('DeleteCache');
        }
        public void DeleteExpiredCache(){
            handleMethodInvocation('DeleteExpiredCache');
        }
        public void DeleteCache(Id wscacheId){
            handleMethodInvocation('DeleteCache', new List<Object>{wscacheId});
        }
        public Decimal subtractTwoAmounts(decimal amount1 , decimal amount2){
            return (Decimal)handleMethodInvocation('subtractTwoAmounts', new List<Object>{amount1, amount2});
        }
        public Decimal addTwoAmounts(decimal amount1, decimal amount2){
            return (Decimal)handleMethodInvocation('addTwoAmounts', new List<Object>{amount1, amount2});
        }
        public Decimal multiplyTwoAmounts(decimal amount1 , decimal amount2){
            return (Decimal)handleMethodInvocation('multiplyTwoAmounts', new List<Object>{amount1, amount2});
        }
        public void debug_RecordLog(String application, String event, String sourceCodeLocationDetails){
            handleMethodInvocation('debug_RecordLog', new List<Object>{application, event, sourceCodeLocationDetails});
        }
        public void debug_DisplayInfo(Object output){
            handleMethodInvocation('debug_DisplayInfo', new List<Object>{output});
        }
        public void debug_Log(Object output){
            handleMethodInvocation('debug_Log', new List<Object>{output});
        }
        public void debug_Log(String debugHeader, Object output){
            handleMethodInvocation('debug_Log', new List<Object>{debugHeader, output});
        }
        public Blob getBase64(String content){
            return (Blob)handleMethodInvocation('getBase64', new List<Object>{content});
        }
        public EventLog__c createEventLog(String application, Object obj, String sourceCodeLocationDetails){
            return (EventLog__c)handleMethodInvocation('createEventLog', new List<Object>{application, obj, sourceCodeLocationDetails});
        }
        public Set<Id> convertToIdSet(List<SObject> sObjectList, String field){
            return (Set<Id>)handleMethodInvocation('convertToIdSet', new List<Object>{sObjectList, field});
        }
        public List<Id> convertToIdList(List<SObject> sObjectList, String field){
            return (List<Id>)handleMethodInvocation('convertToIdList', new List<Object>{sObjectList, field});
        }
        public Set<Id> convertToIdSet(List<SObject> sObjectList){
            return (Set<Id>)handleMethodInvocation('convertToIdSet', new List<Object>{sObjectList});
        }
        public Map<Id, SObject> convertToMap(List<SObject> sObjectList){
            return (Map<Id, SObject>)handleMethodInvocation('convertToMap', new List<Object>{sObjectList});
        }
    }

    public class ofIWebServiceCache extends ApexMoq implements WebServiceCache.IWebServiceCache {
        public wsCache__c FindByKey(String key){
            return (wsCache__c)handleMethodInvocation('FindByKey', new List<Object>{key});
        }
        public wsCache__c SaveItems(List<wsCacheItem__c> items, String cacheKey){
            return (wsCache__c)handleMethodInvocation('SaveItems', new List<Object>{items, cacheKey});
        }
        public wsCache__c SaveItems(List<wsCacheItem__c> items, String cacheKey, Integer lifeSpanMinutes){
            return (wsCache__c)handleMethodInvocation('SaveItems', new List<Object>{items, cacheKey, lifeSpanMinutes});
        }
        public List<wsCacheItem__c> LoadItems(wsCache__c Cache, String sortByProperty, String sortByDirection, Integer pageSize, Integer pageNumber, String conditions){
            return (List<wsCacheItem__c>)handleMethodInvocation('LoadItems', new List<Object>{cache, sortByProperty, sortByDirection, pageSize, pageNumber, conditions});
        }
        public void DeleteItems(ID wscacheId){
            handleMethodInvocation('DeleteItems', new List<Object>{wscacheId});
        }
        public void DeleteItems(String key){
            handleMethodInvocation('DeleteItems', new List<Object>{key});
        }
    }

    public class ofHttpCalloutMock extends ApexMoq implements HttpCalloutMock{
        public HTTPResponse respond(HTTPRequest req){           
            return (HTTPResponse)handleMethodInvocation('respond', new List<Object>{req});
        }
    }

}