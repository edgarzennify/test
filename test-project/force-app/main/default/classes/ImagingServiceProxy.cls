public class ImagingServiceProxy implements IImagingServiceProxy {
    public interface IImagingServiceProxy {
        DocumentMetadata storeDocument(StoreDocumentRequest request);
        List<String> retrieveDocument(String documentId);
        List<DrawerPrivilege> getDrawerPrivilegesByEmailAddress(String emailAddress);
        List<RelNavDocument> getRelNavDocuments(String keyType, List<String> keys, Boolean includeRelated);
        List<DocumentMetadata> getDocumentMetadata(List<String> keys);
        void updateDocumentKeys(List<UpdateDocumentKeysRequest> requests);
        void updateDocumentKeys_Async(List<UpdateDocumentKeysRequest> requests);

        String getChunkedMessageToken(RequestMessageToken request);
        DocumentMetadata storeDocumentChunked(RequestChunk request);
        
        String initializeChunkedDocument(RequestMessageToken request);
        void appendChunkedDocument(RequestChunk request);
        DocumentMetadata finalizeChunkedDocument(RequestFinalization request);
    }

    private static String SERVICE_API_NAME = 'DocumentsUrl';
    private static String STORE_DOC_URI = '/documents';
    private static String RETRIEVE_DOC_URI_TEMPLATE = '/documents/{!documentId}';
    private static String GET_DRAWERS_URI_TEMPLATE = '/drawers?user={!emailAddress}';
    private static String GET_REL_NAV_DOCS_URI_TEMPLATE = '/documents/rel_nav?key_type={!keyType}&keys={!keys}&include_related={!includeRelated}';
    private static String GET_DOC_METADATA_URI_TEMPLATE = '/documents?keys={!keys}';
    private static String UPDATE_DOC_KEYS_URI = '/documents/keys';

    private static String STORE_DOC_CHUNK_URI = '/documents/chunks';
    
    private static String INIT_CHUNK_TOKEN_URI = '/documents/chunks/initialize';
	private static String APPEND_DOC_CHUNK_URI = '/documents/chunks/append';    
    private static String FINALIZE_CHUNK_URI = '/documents/chunks/finalize';

    private final Webservices.IRESTService m_restService;
    private final IJson m_jsonSerializer;
    private final Utility.IUtility m_utility;

    public ImagingServiceProxy(Webservices.IRESTService restService, IJson jsonSerializer, Utility.IUtility utility){
        m_restService = restService;
        m_jsonSerializer = jsonSerializer;
        m_utility = utility;
    }

    public DocumentMetadata storeDocument(StoreDocumentRequest request){
        String requestAsJson = m_jsonSerializer.serialize(request);
        RESTUtility.result res = m_restService.POST(SERVICE_API_NAME, STORE_DOC_URI, requestAsJson);

        if(res.status.contains('OK')){
            return (DocumentMetadata) m_jsonSerializer.deserialize(res.response, DocumentMetadata.class);
        }
        return null;
    }

    public List<String> retrieveDocument(String documentId){
        String uri = RETRIEVE_DOC_URI_TEMPLATE.replace('{!documentId}', documentId);
        RESTUtility.result res = m_restService.GET(SERVICE_API_NAME, uri);
            
        if(res.status.contains('OK')){
            Document doc = (Document) m_jsonSerializer.deserialize(res.response, Document.class);
            return doc.base64Pages;
        }
        return new List<String>();
    }

    public List<DrawerPrivilege> getDrawerPrivilegesByEmailAddress(String emailAddress){
        String uri = GET_DRAWERS_URI_TEMPLATE.replace('{!emailAddress}', emailAddress);
        RESTUtility.result res = m_restService.GET(SERVICE_API_NAME, uri);

        if(res.status.contains('OK')){
            return (List<DrawerPrivilege>) m_jsonSerializer.deserialize(res.response, List<DrawerPrivilege>.class);
        }
        return new List<DrawerPrivilege>();
    }

    public List<RelNavDocument> getRelNavDocuments(String keyType, List<String> keys, Boolean includeRelated){
        String delimitedKeys = m_utility.listToDelimitedString(keys, ',');
        String uri = GET_REL_NAV_DOCS_URI_TEMPLATE.replace('{!keyType}', keyType)
                                                  .replace('{!keys}', delimitedKeys)
                                                  .replace('{!includeRelated}', String.valueOf(includeRelated));
        RESTUtility.result res = m_restService.GET(SERVICE_API_NAME, uri);

        if(res.status.contains('OK')){
            return (List<RelNavDocument>) m_jsonSerializer.deserialize(res.response, List<RelNavDocument>.class);
        }
        return new List<RelNavDocument>();
    }

    public List<DocumentMetadata> getDocumentMetadata(List<String> keys){
        String delimitedKeys = m_utility.listToDelimitedString(keys, ',');
        String uri = GET_DOC_METADATA_URI_TEMPLATE.replace('{!keys}', delimitedKeys);
        RESTUtility.result res = m_restService.GET(SERVICE_API_NAME, uri);

        if(res.status.contains('OK')){
            return (List<DocumentMetadata>) m_jsonSerializer.deserialize(res.response, List<DocumentMetadata>.class);
        }
        return new List<DocumentMetadata>();
    }

    public void updateDocumentKeys(List<UpdateDocumentKeysRequest> requests){
        String requestsAsJson = m_jsonSerializer.serialize(requests);
        m_restService.POST(SERVICE_API_NAME, UPDATE_DOC_KEYS_URI, requestsAsJson);
    }

    public void updateDocumentKeys_Async(List<UpdateDocumentKeysRequest> requests){
        String requestsAsJson = m_jsonSerializer.serialize(requests);
        m_restService.POST_Async(SERVICE_API_NAME, UPDATE_DOC_KEYS_URI, requestsAsJson);
    }

    public String getChunkedMessageToken(RequestMessageToken request){
        return initializeChunkedDocument(request);        
    }

    public DocumentMetadata storeDocumentChunked(RequestChunk request){
        String requestAsJson = m_jsonSerializer.serialize(request);
        RESTUtility.result res = m_restService.POST(SERVICE_API_NAME, STORE_DOC_CHUNK_URI, requestAsJson);

        if(res.status.contains('OK')){
            return (DocumentMetadata) m_jsonSerializer.deserialize(res.response, DocumentMetadata.class);
        }
        return null;
    }
    
    public String initializeChunkedDocument(RequestMessageToken request){
        String requestAsJson = m_jsonSerializer.serialize(request);
        RESTUtility.result res = m_restService.POST(SERVICE_API_NAME, INIT_CHUNK_TOKEN_URI, requestAsJson);

        if(res.status.contains('OK')){
            MessageTokenResponse response = (MessageTokenResponse) m_jsonSerializer.deserialize(res.response, MessageTokenResponse.class);
            return response.messageToken;
        }
        return null;
    }
    
    public void appendChunkedDocument(RequestChunk request){
        String requestAsJson = m_jsonSerializer.serialize(request);
        RESTUtility.result res = m_restService.POST(SERVICE_API_NAME, APPEND_DOC_CHUNK_URI, requestAsJson);        
    }
    
    public DocumentMetadata finalizeChunkedDocument(RequestFinalization request){
        String requestAsJson = m_jsonSerializer.serialize(request);  
        
        RESTUtility.result res = m_restService.POST(SERVICE_API_NAME, FINALIZE_CHUNK_URI, requestAsJson);        
        
        if(res.status.contains('OK')){
            return (DocumentMetadata) m_jsonSerializer.deserialize(res.response, DocumentMetadata.class);
        }
        return null;            
    }

    public class StoreDocumentRequest {
        public String fileName {get;set;}
        public String documentType {get;set;}
        public String drawerName {get;set;}
        public String externalObjectKey {get;set;}
        public String externalDocumentKey {get;set;}        
        public String documentAsBase64 {get;set;}
        public String fileExtension {get;set;}
        public String userEmail {get;set;}
    }

    public class DocumentMetadata {
        public String documentId {get;set;}
        public String extension {get;set;}
        public String docTypeName {get;set;}
        public String documentDate {get;set;}
        public String drawerName {get;set;}
        public String comments {get;set;}
        public Boolean isStaged {get;set;}
    }

    public class Document {
        public List<String> base64Pages {get;set;}
    }

    public class UpdateDocumentKeysRequest {
        public String keyType {get;set;}
        public String oldExternalKey {get;set;}
        public String newExternalKey {get;set;}
    }

    public class RequestMessageToken{
        public Integer shardCount {get;set;}
    }

    public class RequestChunk{        
        public String messageToken {get;set;}
        public String chunk {get;set;}
        public Integer sequence {get;set;}
    }

    public class MessageTokenResponse{
        public String messageToken {get;set;}
    }
    
    public class RequestFinalization{
        public String messageToken {get;set;}
        public String drawerName {get;set;}
        public String documentType {get;set;}
        public String externalObjectSource {get;set;}
        public List<String> externalObjectKeys {get;set;}
        public String externalDocumentKey {get;set;}
        public Date documentDate {get;set;}
        public String comments {get;set;}
        public String userEmail {get;set;}
        public String fileName {get;set;}
        public String fileExtension {get;set;}
    }
    
}