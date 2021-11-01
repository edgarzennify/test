global with sharing class EbtDocManagerController {

    private final static String STORE_NAME_CONFIG_KEY = 'EbtDocManagerStoreName';
    private final static String DOC_URL_TEMPLATE_CONFIG_KEY = 'EbtDocManagerDocUrlTemplate';
    private final static String DEFAULT_DRAWER_CONFIG_KEY = 'EbtDocManagerDefaultDrawerName';
    private final static String DEFAULT_DOC_TYPE_CONFIG_KEY = 'EbtDocManagerDefaultDocType';

    private final Configurations.IConfigurations m_configs;

    public EbtDocManagerController(){
        m_configs = Configurations.bootstrap();
    }

    public EbtDocManagerController(Configurations.IConfigurations configs){
        m_configs = configs;
    }

    public String storeName { get { return m_configs.get(STORE_NAME_CONFIG_KEY); } }
    public String documentUrlTemplate { get { return m_configs.get(DOC_URL_TEMPLATE_CONFIG_KEY); } }
    public String defaultDrawerName { get { return m_configs.get(DEFAULT_DRAWER_CONFIG_KEY); } }
    public String defaultDocType { get { return m_configs.get(DEFAULT_DOC_TYPE_CONFIG_KEY); } }

    @RemoteAction
    global static void init(String objectId) {
        try{
            EbtDocManager.IAdapter adapter = EbtDocManagerBootstrapper.getInstanceOfIEbtDocManagerAdapter();
            adapter.cleanupUnmatchedItems(objectId);
            adapter.reconcileInternalStore(objectId);
        }catch(exception ex){
            throw new DocManagerInitializationException(ex.getMessage());
        }        
    }
    
    @RemoteAction
    global static String getTokenForChunkedUpload(Integer chunkCount){
        try{
            EbtDocManager.IAdapter adapter = EbtDocManagerBootstrapper.getInstanceOfIEbtDocManagerAdapter();
            return adapter.getTokenForChunkedUpload(chunkCount);
        }catch(exception ex){
            throw new UploadDocumentException(ex.getMessage());
        }
    }

    @RemoteAction
    global static String uploadDocumentChunk(String messageToken, String chunkContent, Integer sequenceNumber) {
        try{
            EbtDocManager.IAdapter adapter = EbtDocManagerBootstrapper.getInstanceOfIEbtDocManagerAdapter();
            return adapter.saveDocumentChunkToExternalStore(messageToken, chunkContent, sequenceNumber);
        }catch(exception ex){
            throw new UploadDocumentException(ex.getMessage());
        }
    }
    
    public class UploadDocumentException extends Exception {}
    public class DocManagerInitializationException extends Exception {}
}