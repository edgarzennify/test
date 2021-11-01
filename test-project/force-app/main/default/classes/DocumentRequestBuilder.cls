public class DocumentRequestBuilder implements Documents.IDocumentRequestBuilder {

    private final ExternalDocumentMetaDataProvider.IExternalDocumentMetaDataProvider m_metaDataProvider;
    private final IUserInfoService m_userInfoService;
    
    public DocumentRequestBuilder(ExternalDocumentMEtaDataProvider.IExternalDocumentMEtaDataProvider metaDataProvider, IUserInfoService userInfoService){
        m_metaDataProvider = metaDataProvider;
        m_userInfoService = userInfoService;
    }
    
    public Documents.DocumentGetRequest buildDocumentGetRequest(String uniqueName){
        EB_External_Document__c pm = m_metaDataProvider.lookupExternal(uniqueName);
		CheckPermission(pm.Required_Permission_Set_Name__c);        
        
        Documents.DocumentGetRequest request = new Documents.DocumentGetRequest();
        request.uniqueName = pm.Name;
        request.externalDocumentId = pm.External_Document_Id__c;
        request.description = pm.Label__c;        
        request.docMimeType = pm.MIME_Type__c;
        request.docType = pm.File_Type__c;
        request.maxAgeMinutes = Integer.valueOf(pm.Max_Age_Minutes__c);
        return request;
    }
    
    private void CheckPermission(String permissionSetName){
        if(!String.isEmpty(permissionSetName) && !m_userInfoService.hasPermissionSet(permissionSetName)) throw new applicationException('User missing required permission set: "' + permissionSetName + '".');
    }

}