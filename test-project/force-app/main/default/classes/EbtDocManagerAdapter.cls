public class EbtDocManagerAdapter implements EbtDocManager.IAdapter {
    private final ImagingServiceProxy.IImagingServiceProxy m_imagingProxy;
    private final IJson m_json;
    private final EbtDocManager.IPluginManager m_pluginManager;
    private final EbtDocManager.IInternalStore m_internalStore;

    public EbtDocManagerAdapter(ImagingServiceProxy.IImagingServiceProxy imagingProxy, 
                                IJson json, 
                                EbtDocManager.IPluginManager pluginManager,
                                EbtDocManager.IInternalStore internalStore){
        m_json = json;
        m_imagingProxy = imagingProxy;
        m_pluginManager = pluginManager;
        m_internalStore = internalStore;
    }

    public void cleanupUnmatchedItems(String objectId){
        EbtDocManager.IPlugin plugin = m_pluginManager.getPluginByObjectId(objectId);
        m_internalStore.cleanupUnmatchedItems(plugin, objectId);
    }

    public void reconcileInternalStore(String objectId){
        EbtDocManager.IPlugin plugin = m_pluginManager.getPluginByObjectId(objectId);
        Set<String> externalIds = m_internalStore.getExternalIdentifiers(plugin, objectId);
        List<ImagingServiceProxy.DocumentMetadata> externalDocs = getExternalDocuments(plugin, objectId);
        List<ImagingServiceProxy.DocumentMetadata> missingDocs = getMissingDocuments(externalIds, externalDocs);
        m_internalStore.createDocumentsFromExternalDocuments(plugin, missingDocs, objectId);
    }

    public String getTokenForChunkedUpload(Integer chunkCount){
        ImagingServiceProxy.RequestMessageToken req = new ImagingServiceProxy.RequestMessageToken();
        req.shardCount = chunkCount;
        return m_imagingProxy.getChunkedMessageToken(req);
    }
    
    public String saveDocumentChunkToExternalStore(String messageToken, String chunkContent, Integer sequenceNumber){
        ImagingServiceProxy.RequestChunk req = new ImagingServiceProxy.RequestChunk();
        req.messageToken = messageToken;
        req.chunk = chunkContent;
        req.sequence = sequenceNumber;
        ImagingServiceProxy.DocumentMetadata doc = m_imagingProxy.storeDocumentChunked(req);   
        return doc == null ? '' : doc.documentId;
    }

    private List<ImagingServiceProxy.DocumentMetadata> getExternalDocuments(EbtDocManager.IPlugin plugin, Id objectId){
        EbtDocManager.ExternalDocumentLookup lookup = plugin.getExternalDocumentLookup(objectId);
        return m_imagingProxy.getDocumentMetadata(lookup.keys);
    }

    private List<ImagingServiceProxy.DocumentMetadata> getMissingDocuments(Set<String> externalIds, List<ImagingServiceProxy.DocumentMetadata> externalDocs){
        List<ImagingServiceProxy.DocumentMetadata> missingDocs = new List<ImagingServiceProxy.DocumentMetadata>();
        for(ImagingServiceProxy.DocumentMetadata externalDoc : externalDocs){
            if(!externalIds.contains(externalDoc.documentId)){
                missingDocs.add(externalDoc);
            }
        }
        return missingDocs;
    }

}