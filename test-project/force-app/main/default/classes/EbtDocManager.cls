public class EbtDocManager {
    public interface IAdapter{
        void cleanupUnmatchedItems(String objectId);
        void reconcileInternalStore(String objectId);
        String getTokenForChunkedUpload(Integer chunkCount);
        String saveDocumentChunkToExternalStore(String messageToken, String chunkContent, Integer sequenceNumber);
    }

    public interface IPluginManager {
        IPlugin getPluginByObjectId(Id objectId);
    }

    public interface IPlugin {
        List<SObject> getUnmatchedItems(Id objectId);
        void fixUnmatchedItem(SObject document);
        SObjectType getSObjectTypeHandled();
        String getDocumentManagerName();
        ExternalDocumentLookup getExternalDocumentLookup(Id objectId);
        List<LLC_BI__Document_Store_Index__c> getDocumentManagerStoreIndexes(Id objectId);
        SObject buildDocumentManagerDocument(InternalDocumentBuildRequest request);
        void updateDocumentManagerDocument(SObject document, LLC_BI__DocClass__c docClass);
        void updateDocumentManagerDocument(SObject document, LLC_BI__Document_Store_Index__c storeIndex);
    }
    
    public interface IInternalStore {
        void cleanupUnmatchedItems(IPlugin plugin, Id objectId);
        Set<String> getExternalIdentifiers(IPlugin plugin, Id objectId);
        void createDocumentsFromExternalDocuments(IPlugin plugin, List<ImagingServiceProxy.DocumentMetadata> externalDocs, Id objectId);
    }
    
    public interface IStoreBuilder {
        List<LLC_BI__Document_Store__c> buildDocumentManagerStores(List<ImagingServiceProxy.DocumentMetadata> externalDocs);
        List<LLC_BI__Document_Store_Index__c> buildDocumentManagerStoreIndexes(List<LLC_BI__Document_Store__c> docStores);
        List<SObject> buildDocumentManagerDocuments(IPlugin plugin, List<ImagingServiceProxy.DocumentMetadata> externalDocs, Id objectId);
    }

    public interface IStoreBuilderHelper {
        InternalDocumentBuildRequest createInternalDocumentBuildRequest(ImagingServiceProxy.DocumentMetadata externalDoc, String docManName, Id objectId);
        LLC_BI__DocClass__c getDocumentManagerClass(String docManName, String docTypeName);
    }

    public interface IDataProvider {
        List<LLC_BI__Document_Store_Index__c> getDocumentManagerLoanDocuments(Id loanId);
        List<LLC_BI__Document_Store_Index__c> getDocumentManagerEntityDocuments(Id entityId);
        List<LLC_BI__Document_Store_Index__c> getDocumentManagerCollateralDocuments(Id collateralId);
        void save(List<SObject> items);
        LLC_BI__Loan__c getLoan(Id loanId);
        Account getEntity(Id entityId);
        LLC_BI__Collateral__c getCollateral(Id collateralId);
        List<LLC_BI__DocManager__c> getDocumentManagers();
        List<LLC_BI__DocClass__c> getDocumentManagerClasses();
        List<LLC_BI__LLC_LoanDocument__c> getUnmatchedLoanDocuments(Id loanId);
    }
    
    public class ExternalDocumentLookup {
        public List<String> keys {get;set;}
    }

    public class InternalDocumentBuildRequest {
        public ImagingServiceProxy.DocumentMetadata externalDoc {get;set;}
        public Id objectId {get;set;}
        public Id documentManagerId {get;set;}
    }

}