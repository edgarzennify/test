public class EbtDocManagerPluginEntity implements EbtDocManager.IPlugin{
    
    private final String DOCUMENT_MANAGER_NAME = 'Account';  
    private final EbtDocManager.IDataProvider m_dataProvider;    
    
    public EbtDocManagerPluginEntity(EbtDocManager.IDataProvider dataProvider){
        m_dataProvider = dataProvider;
    }
    
    public SObjectType getSObjectTypeHandled(){
        return Account.SObjectType;
    }

    public String getDocumentManagerName() {
        return DOCUMENT_MANAGER_NAME;
    }
       
    public EbtDocManager.ExternalDocumentLookup getExternalDocumentLookup(Id objectId){
        EbtDocManager.ExternalDocumentLookup lookup = new EbtDocManager.ExternalDocumentLookup();
        Account entity = m_dataProvider.getEntity(objectId);
        if(entity.RecordType.Name == 'Prospect'){
            lookup.keys = new List<String> { entity.Id };
        }else{
            lookup.keys = new List<String> { entity.Id, entity.EB_Customer_Number__c };     
        }
        return lookup;
    }
    
    public List<LLC_BI__Document_Store_Index__c> getDocumentManagerStoreIndexes(Id objectId){    
        return m_dataProvider.getDocumentManagerEntityDocuments(objectId);
    }
    
    public SObject buildDocumentManagerDocument(EbtDocManager.InternalDocumentBuildRequest request) {
        LLC_BI__AccountDocument__c document = new LLC_BI__AccountDocument__c();
        document.LLC_BI__Account__c = request.objectId;
        document.LLC_BI__docManager__c = request.documentManagerId;
        document.LLC_BI__reviewStatus__c = 'In-File';
        document.Name = request.externalDoc.docTypeName;
        document.NDOC__fileName__c = request.externalDoc.docTypeName;
        document.LLC_BI__mimeType__c = request.externalDoc.extension;
        document.LLC_BI__date__c = Date.valueOf(request.externalDoc.documentDate);
        document.LLC_BI__comments__c = request.externalDoc.comments;        
        document.LLC_BI__fileSize__c = null;
        return document;
    }

    public void updateDocumentManagerDocument(SObject document, LLC_BI__DocClass__c docClass){
        LLC_BI__AccountDocument__c doc = (LLC_BI__AccountDocument__c) document;
        doc.LLC_BI__docType__c = docClass.LLC_BI__DocType__c;     
        doc.LLC_BI__docTab__c = docClass.LLC_BI__DocType__r.LLC_BI__docTab__c;
        doc.LLC_BI__reviewStatus__c = 'Approved';
    }
    
    public void updateDocumentManagerDocument(SObject document, LLC_BI__Document_Store_Index__c storeIndex) {
        LLC_BI__AccountDocument__c doc = (LLC_BI__AccountDocument__c) document;
        doc.LLC_BI__Document_Store_Index__c = storeIndex.Id;
    }

    public List<SObject> getUnmatchedItems(Id objectId){
        return null;
    }

    public void fixUnmatchedItem(SObject document){
        // do nothing here
    }
}