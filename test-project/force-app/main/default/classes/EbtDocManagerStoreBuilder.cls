public class EbtDocManagerStoreBuilder implements EbtDocManager.IStoreBuilder {
    
    private final String STORE_NAME_CONFIG_KEY = 'EbtDocManagerStoreName';

    private final Configurations.IConfigurations m_configs;
    private final EbtDocManager.IStoreBuilderHelper m_helper;
    
    public EbtDocManagerStoreBuilder(Configurations.IConfigurations configs, EbtDocManager.IStoreBuilderHelper helper){
        m_configs = configs;
        m_helper = helper;
    }

    public List<LLC_BI__Document_Store__c> buildDocumentManagerStores(List<ImagingServiceProxy.DocumentMetadata> externalDocs) {
         List<LLC_BI__Document_Store__c> docStores = new List<LLC_BI__Document_Store__c>();
         for(ImagingServiceProxy.DocumentMetadata doc: externalDocs){
              LLC_BI__Document_Store__c newDocStore = new LLC_BI__Document_Store__c();
              newDocStore.LLC_BI__External_Identifier__c = doc.documentId;
              newDocStore.LLC_BI__Type__c = m_configs.get(STORE_NAME_CONFIG_KEY);
              docStores.add(newDocStore);
         }         
         return docStores;
    }
    
    public List<LLC_BI__Document_Store_Index__c> buildDocumentManagerStoreIndexes(List<LLC_BI__Document_Store__c> docStores) {
        List<LLC_BI__Document_Store_Index__c> docStoreIndexes = new List<LLC_BI__Document_Store_Index__c>();
        for(LLC_BI__Document_Store__c docStore : docStores){
            LLC_BI__Document_Store_Index__c newDocStoreIndex = new LLC_BI__Document_Store_Index__c();
            newDocStoreIndex.LLC_BI__Document_Store__c = docStore.Id;
            docStoreIndexes.add(newDocStoreIndex);
        }        
        return docStoreIndexes;
    }
    
    public List<SObject> buildDocumentManagerDocuments(EbtDocManager.IPlugin plugin, List<ImagingServiceProxy.DocumentMetadata> externalDocs, Id objectId){
        List<SObject> documents = new List<SObject>();
        for(ImagingServiceProxy.DocumentMetadata xdoc : externalDocs){
            SObject document = buildDocumentManagerDocument(plugin, xdoc, objectId);
            documents.add(document);
        }
        return documents;
    }

    private SObject buildDocumentManagerDocument(EbtDocManager.IPlugin plugin, ImagingServiceProxy.DocumentMetadata externalDoc, Id objectId){
        String docManName = plugin.getDocumentManagerName();
        EbtDocManager.InternalDocumentBuildRequest buildRequest = m_helper.createInternalDocumentBuildRequest(externalDoc, docManName, objectId);
        
        SObject document = plugin.buildDocumentManagerDocument(buildRequest);
        
        LLC_BI__DocClass__c docClass = m_helper.getDocumentManagerClass(docManName, externalDoc.docTypeName);
        if(externalDoc.isStaged == false && docClass != null){
            plugin.updateDocumentManagerDocument(document, docClass);
        }
        
        return document;
    }

}