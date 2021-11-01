public class EbtDocManagerPluginCollateral implements EbtDocManager.IPlugin{
    
    private final String DOCUMENT_MANAGER_NAME = 'Collateral';  
    private final EbtDocManager.IDataProvider m_dataProvider;    
    
    public EbtDocManagerPluginCollateral(EbtDocManager.IDataProvider dataProvider){
        m_dataProvider = dataProvider;
    }
    
    public SObjectType getSObjectTypeHandled(){
        return LLC_BI__Collateral__c.SObjectType;
    }

    public String getDocumentManagerName() {
        return DOCUMENT_MANAGER_NAME;
    }
       
    public EbtDocManager.ExternalDocumentLookup getExternalDocumentLookup(Id objectId){
        EbtDocManager.ExternalDocumentLookup lookup = new EbtDocManager.ExternalDocumentLookup();
        LLC_BI__Collateral__c collateral = m_dataProvider.getCollateral(objectId);
        if(String.isEmpty(collateral.Sync_Key__c)){
            lookup.keys = new List<String> { collateral.Id };
        }else{
            lookup.keys = new List<String> { collateral.Id, collateral.Sync_Key__c };     
        }
        return lookup;
    }
    
    public List<LLC_BI__Document_Store_Index__c> getDocumentManagerStoreIndexes(Id objectId){    
        return m_dataProvider.getDocumentManagerCollateralDocuments(objectId);
    }
    
    public SObject buildDocumentManagerDocument(EbtDocManager.InternalDocumentBuildRequest request) {
        LLC_BI__Document_Placeholder__c document = new LLC_BI__Document_Placeholder__c();
        document.LLC_BI__External_Id__c = request.objectId;
        document.LLC_BI__docManager__c = request.documentManagerId;
        document.LLC_BI__Review_Status__c = 'In-File';
        document.Name = request.externalDoc.docTypeName;
        document.NDOC__File_Name__c = request.externalDoc.docTypeName;
        document.NDOC__Mime_Type__c = request.externalDoc.extension;
        document.LLC_BI__Date__c = Date.valueOf(request.externalDoc.documentDate);
        document.NDOC__Comments__c = request.externalDoc.comments; 
        document.NDOC__File_Size__c = null;
        return document;
    }

    public void updateDocumentManagerDocument(SObject document, LLC_BI__DocClass__c docClass){
        LLC_BI__Document_Placeholder__c doc = (LLC_BI__Document_Placeholder__c) document;
        doc.LLC_BI__docClass__c = docClass.Id;   
        doc.LLC_BI__docType__c = docClass.LLC_BI__DocType__c;     
        doc.LLC_BI__docTab__c = docClass.LLC_BI__DocType__r.LLC_BI__docTab__c;
        doc.LLC_BI__Review_Status__c = 'Approved';
    }
    
    public void updateDocumentManagerDocument(SObject document, LLC_BI__Document_Store_Index__c storeIndex) {
        LLC_BI__Document_Placeholder__c doc = (LLC_BI__Document_Placeholder__c) document;
        doc.LLC_BI__Document_Store_Index__c = storeIndex.Id;
    }

    public List<SObject> getUnmatchedItems(Id objectId){
        return null;
    }

    public void fixUnmatchedItem(SObject document){
        // do nothing here
    }
}