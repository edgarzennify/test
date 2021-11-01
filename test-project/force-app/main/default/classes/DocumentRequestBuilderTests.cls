@IsTest
private class DocumentRequestBuilderTests {
    
    private static final DocumentRequestBuilder sut;
    private static final MockOfExternalDocumentMetaDataProvider mockMetaDataProvider;
    private static final Mock.ofIUserInfoService mockUserInfoService;

    static {
        mockMetaDataProvider = new MockOfExternalDocumentMetaDataProvider();
        mockUserInfoService = new Mock.ofIUserInfoService();
        sut = new DocumentRequestBuilder(mockMetaDataProvider, mockUserInfoService);
    }
    
    @IsTest
    static void it_should_call_the_data_provider_to_get_external_document_meta_data() {
        String name = 'test123';
        EB_External_Document__c metaData = new EB_External_Document__c();        
        mockMetaDataProvider.setup('lookupExternal', new List<Object>{name}).returns(metaData);
        
        sut.buildDocumentGetRequest(name);
        
        mockMetaDataProvider.verify('lookupExternal', new List<Object>{name}, Times.Once);
    }
    
    @IsTest
    static void it_should_throw_an_exception_if_the_user_does_not_have_the_permission_set_required_for_the_document() {
        String name = 'test123';
        EB_External_Document__c metaData = new EB_External_Document__c();
		metaData.Required_Permission_Set_Name__c = 'xyz123';        
        mockMetaDataProvider.setup('lookupExternal', new List<Object>{name}).returns(metaData);
        mockUserInfoService.setup('hasPermissionSet', new List<Object>{metaData.Required_Permission_Set_Name__c}).returns(false);
        
        try {
        	sut.buildDocumentGetRequest(name);    
            System.assert(false, 'Exception was not thrown.');
        } catch (Exception ex) {
        	System.assert(true);
        }
    }
           
    private class MockOfExternalDocumentMetaDataProvider extends ApexMoq implements ExternalDocumentMetaDataProvider.IExternalDocumentMetaDataProvider {
        public EB_External_Document__c lookupExternal(String uniqueName){
            return (EB_External_Document__c)handleMethodInvocation('lookupExternal', new List<Object>{uniqueName});
        }
    }
}