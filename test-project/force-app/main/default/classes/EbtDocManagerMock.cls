@isTest
public class EbtDocManagerMock {

	public class ofIDataProvider extends ApexMoq implements EbtDocManager.IDataProvider {
        public List<LLC_BI__Document_Store_Index__c> getDocumentManagerLoanDocuments(Id loanId) {
            return (List<LLC_BI__Document_Store_Index__c>)handleMethodInvocation('getDocumentManagerLoanDocuments', new List<Object>{loanId});
        }
        public List<LLC_BI__Document_Store_Index__c> getDocumentManagerEntityDocuments(Id entityId) {
            return (List<LLC_BI__Document_Store_Index__c>)handleMethodInvocation('getDocumentManagerEntityDocuments', new List<Object>{entityId});
        }  
        public List<LLC_BI__Document_Store_Index__c> getDocumentManagerCollateralDocuments(Id collateralId) {
            return (List<LLC_BI__Document_Store_Index__c>)handleMethodInvocation('getDocumentManagerCollateralDocuments', new List<Object>{collateralId});
        }
        public List<LLC_BI__LLC_LoanDocument__c> getUnmatchedLoanDocuments(Id loanId){
            return (List<LLC_BI__LLC_LoanDocument__c>)handleMethodInvocation('getUnmatchedLoanDocuments', new List<Object>{loanId});
        }        
        public void save(List<SObject> items) {
            handleMethodInvocation('save', new List<Object>{items});
        }        
        public LLC_BI__Loan__c getLoan(Id loanId) {
            return (LLC_BI__Loan__c)handleMethodInvocation('getLoan', new List<Object>{loanId});
        }
        public Account getEntity(Id entityId) {
            return (Account)handleMethodInvocation('getEntity', new List<Object>{entityId});
        }
        public LLC_BI__Collateral__c getCollateral(Id collateralId) {
            return (LLC_BI__Collateral__c)handleMethodInvocation('getCollateral', new List<Object>{collateralId});
        }
        public List<LLC_BI__DocManager__c> getDocumentManagers(){
            return (List<LLC_BI__DocManager__c>)handleMethodInvocation('getDocumentManagers');
        }
        public List<LLC_BI__DocClass__c> getDocumentManagerClasses(){
            return (List<LLC_BI__DocClass__c>)handleMethodInvocation('getDocumentManagerClasses');
        }
    }    
    public class ofIInternalStore extends ApexMoq implements EbtDocManager.IInternalStore {
        public void cleanupUnmatchedItems(EbtDocManager.IPlugin plugin, Id objectId){
            handleMethodInvocation('cleanupUnmatchedItems', new List<Object>{plugin,objectId});
        }
        public Set<String> getExternalIdentifiers(EbtDocManager.IPlugin plugin, Id objectId){
            return (Set<String>)handleMethodInvocation('getExternalIdentifiers', new List<Object>{plugin,objectId});
        }	
        public void createDocumentsFromExternalDocuments(EbtDocManager.IPlugin plugin, List<ImagingServiceProxy.DocumentMetadata> externalDocs, Id objectId){
            handleMethodInvocation('createDocumentsFromExternalDocuments', new List<Object>{plugin,externalDocs,objectId});
        }
    }    
    public class ofIPlugin extends ApexMoq implements EbtDocManager.IPlugin {   
        public List<SObject> getUnmatchedItems(Id objectId){
            return (List<SObject>)handleMethodInvocation('getUnmatchedItems', new List<Object>{objectId});
        }
        public void fixUnmatchedItem(SObject document){
            handleMethodInvocation('fixUnmatchedItem', new List<Object>{document});
        }
        public SObjectType getSObjectTypeHandled(){
            return (SObjectType)handleMethodInvocation('getSObjectTypeHandled');
        }	
        public String getDocumentManagerName(){
            return (String)handleMethodInvocation('getDocumentManagerName');
        }	
        public EbtDocManager.ExternalDocumentLookup getExternalDocumentLookup(Id objectId){
            return (EbtDocManager.ExternalDocumentLookup)handleMethodInvocation('getExternalDocumentLookup', new List<Object>{objectId});
        }       
        public List<LLC_BI__Document_Store_Index__c> getDocumentManagerStoreIndexes(Id objectId){
            return (List<LLC_BI__Document_Store_Index__c>)handleMethodInvocation('getDocumentManagerStoreIndexes', new List<Object>{objectId});
        }        
        public SObject buildDocumentManagerDocument(EbtDocManager.InternalDocumentBuildRequest request){
            return (SObject)handleMethodInvocation('buildDocumentManagerDocument', new List<Object>{request});
        }
        public void updateDocumentManagerDocument(SObject document, LLC_BI__DocClass__c docClass){
            handleMethodInvocation('updateDocumentManagerDocument', new List<Object>{document, docClass});
        }      
        public void updateDocumentManagerDocument(SObject document, LLC_BI__Document_Store_Index__c storeIndex){
            handleMethodInvocation('updateDocumentManagerDocument', new List<Object>{document, storeIndex});
        }
    }    
    public class ofIPluginManager extends ApexMoq implements EbtDocManager.IPluginManager {
        public EbtDocManager.IPlugin getPluginByObjectId(Id objectId){
            return (EbtDocManager.IPlugin)handleMethodInvocation('getPluginByObjectId', new List<Object>{objectId});
        }
    }    
    public class ofIStoreBuilder extends ApexMoq implements EbtDocManager.IStoreBuilder {
        public List<LLC_BI__Document_Store__c> buildDocumentManagerStores(List<ImagingServiceProxy.DocumentMetadata> externalDocs) {
            return (List<LLC_BI__Document_Store__c>)handleMethodInvocation('buildDocumentManagerStores', new List<Object>{externalDocs});
        }
        public List<LLC_BI__Document_Store_Index__c> buildDocumentManagerStoreIndexes(List<LLC_BI__Document_Store__c> docStores) {
            return (List<LLC_BI__Document_Store_Index__c>)handleMethodInvocation('buildDocumentManagerStoreIndexes', new List<Object>{docStores});
        }
        public List<SObject> buildDocumentManagerDocuments(EbtDocManager.IPlugin plugin, List<ImagingServiceProxy.DocumentMetadata> externalDocs, Id objectId){
            return (List<SObject>)handleMethodInvocation('buildDocumentManagerDocuments', new List<Object>{plugin,externalDocs,objectId});
        }
    }
    public class ofIStoreBuilderHelper extends ApexMoq implements EbtDocManager.IStoreBuilderHelper {       
        public EbtDocManager.InternalDocumentBuildRequest createInternalDocumentBuildRequest(ImagingServiceProxy.DocumentMetadata externalDoc, String docManName, Id objectId) {
            return (EbtDocManager.InternalDocumentBuildRequest)handleMethodInvocation('createInternalDocumentBuildRequest', new List<Object>{externalDoc,docManName,objectId});
        }
        public LLC_BI__DocClass__c getDocumentManagerClass(String docManName, String docTypeName){
            return (LLC_BI__DocClass__c)handleMethodInvocation('getDocumentManagerClass', new List<Object>{docManName,docTypeName});
        }
    }

}