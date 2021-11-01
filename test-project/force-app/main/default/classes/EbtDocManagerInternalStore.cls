public class EbtDocManagerInternalStore implements EbtDocManager.IInternalStore {
    
    private final EbtDocManager.IStoreBuilder m_storeBuilder;
    private final EbtDocManager.IDataProvider m_dataProvider;
    
    public EbtDocManagerInternalStore(EbtDocManager.IStoreBuilder storeBuilder, EbtDocManager.IDataProvider dataProvider){
        m_storeBuilder = storeBuilder;
        m_dataProvider = dataProvider;
    }

    public void cleanupUnmatchedItems(EbtDocManager.IPlugin plugin, Id objectId){
        List<SObject> unmatched = plugin.getUnmatchedItems(objectId);
        if(unmatched != null){
           for(SObject doc : unmatched){
                plugin.fixUnmatchedItem(doc);
            }
            m_dataProvider.save(unmatched); 
        }
    }
    
    public Set<String> getExternalIdentifiers(EbtDocManager.IPlugin plugin, Id objectId){
        Set<String> externalIds = new Set<String>();
        for(LLC_BI__Document_Store_Index__c storeIndex : plugin.getDocumentManagerStoreIndexes(objectId)){
            externalIds.add(storeIndex.LLC_BI__Document_Store__r.LLC_BI__External_Identifier__c);
        }        
        return externalIds;
    }
    
    public void createDocumentsFromExternalDocuments(EbtDocManager.IPlugin plugin, List<ImagingServiceProxy.DocumentMetadata> externalDocs, Id objectId){
        List<LLC_BI__Document_Store__c> docStores = m_storeBuilder.buildDocumentManagerStores(externalDocs);
        m_dataProvider.save(docStores);

        List<LLC_BI__Document_Store_Index__c> docStoreIndexes = m_storeBuilder.buildDocumentManagerStoreIndexes(docStores);
        m_dataProvider.save(docStoreIndexes);
        
        List<SObject> documents = m_storeBuilder.buildDocumentManagerDocuments(plugin, externalDocs, objectId);
        m_dataProvider.save(documents);
        
        for(Integer i=0; i<documents.size(); i++) {
            plugin.updateDocumentManagerDocument(documents[i], docStoreIndexes[i]);
        }        
        m_dataProvider.save(documents);
    }
}