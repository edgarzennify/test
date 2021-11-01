public class Documents{ 
       
    public interface IDocumentProvider {
        DmDocument getDocument(DocumentGetRequest request);
    }
    
    public interface IDocumentCache {
        DmDocument getDocument(String documentName);
        DmDocument saveDocument(DmDocument document);
    }
    
    public interface IDocumentDmBuilder{
        DmDocument build(Document documentPm);
        Document build(DmDocument documentDm);
    }
    
    public interface ISalesforceDocumentProvider {
        Document getDocument(String folderName, String documentName);
        List<Document> getDocuments(List<String> documentIds);
        Document saveDocument(String folderName, Document document);
    }

    public interface IDocumentRequestBuilder {
        DocumentGetRequest buildDocumentGetRequest(String uniqueName);
    }
    
    public interface ICacheable{
        Type classType();
        Documents.ICacheable FromCacheItem(wsCacheItem__c item);
        wsCacheItem__c ToCacheItem();
        String ToCacheFieldName(String fieldName);
    }
    
    public interface IDocumentDataService{
        void ExpireCache(String objectId);
        void ExpireCache(String keyType, String pageKey);
        string BuildKey(String keyType, String pageKey, Boolean includeRelated);
        List<Documents.ICacheable> LoadList(String listKey, String sortByProperty, String sortByDirection, Integer pageSize, Integer pageNumber, String conditions, Documents.ICacheable obj);
        void SaveList(List<Documents.ICacheable> objects, String listKey);
    }

    public interface IRelNavDocument {
        void SaveList(List<RelNavDocument> oList, String listKey);
        List<RelNavDocument> LoadList(String listKey, String sortByProperty, String sortByDirection);
        List<RelNavDocument> LoadList(String listKey, String sortByProperty, String sortByDirection, Integer pageSize, Integer pageNumber, String conditions);
        List<RelNavDocument> LoadList(String listKey, String sortByProperty, String sortByDirection, Integer pageSize, Integer pageNumber, RelNavDocument.RelNavDocumentFilter filter);
    }
    
    public class DocumentGetRequest {
        public String uniqueName {get;set;}
        public String externalDocumentId {get;set;}
        public Integer maxAgeMinutes {get;set;}
        public String docType {get;set;}
        public String docMimeType {get;set;}
        public String description {get;set;}
    }

}