public class EbtDocManagerStoreBuilderHelper implements EbtDocManager.IStoreBuilderHelper {

	private Map<String, LLC_BI__DocClass__c> m_documentClasses;
	private Map<String, Id> m_documentManagerIds;
	private final EbtDocManager.IDataProvider m_dataProvider;

	public EbtDocManagerStoreBuilderHelper(EbtDocManager.IDataProvider dataProvider){
        m_dataProvider = dataProvider;
    }

    public EbtDocManager.InternalDocumentBuildRequest createInternalDocumentBuildRequest(ImagingServiceProxy.DocumentMetadata externalDoc, String docManName, Id objectId){
      	EbtDocManager.InternalDocumentBuildRequest request = new EbtDocManager.InternalDocumentBuildRequest();
    	request.externalDoc = externalDoc;
    	request.objectId = objectId;
    	request.documentManagerId = documentManagerIds.get(docManName);
    	return request;
    }

    public LLC_BI__DocClass__c getDocumentManagerClass(String docManName, String docTypeName){
    	Id docManId = documentManagerIds.get(docManName);
    	String docClassKey = buildKey(docTypeName, docManId);
    	if(documentClasses.containsKey(docClassKey)){
    		return documentClasses.get(docClassKey);
    	}
    	return null;
    }

    private Map<String, LLC_BI__DocClass__c> documentClasses {
    	get{
	    	if(m_documentClasses == null) {
	    		m_documentClasses = new Map<String, LLC_BI__DocClass__c>();
	    		for(LLC_BI__DocClass__c docClass:  m_dataProvider.getDocumentManagerClasses()){
    				String key = buildKey(docClass.Name, docClass.LLC_BI__docManager__c);
	    			m_documentClasses.put(key, docClass);
	    		}
	    	}
	    	return m_documentClasses;
       }
    }

    private Map<String, Id> documentManagerIds {
    	get{
	    	if(m_documentManagerIds == null) {
	    		m_documentManagerIds = new Map<String, Id>();
	    		for(LLC_BI__DocManager__c docMgr :  m_dataProvider.getDocumentManagers()){	    		
	    			m_documentManagerIds.put(docMgr.Name, docMgr.Id);
	    		}
	    	}
	    	return m_documentManagerIds;
       }
    }

    private String buildKey(String docTypeName, Id docManId){
    	return String.format('{0}|{1}', new List<String>{docTypeName, docManId});
    }
}