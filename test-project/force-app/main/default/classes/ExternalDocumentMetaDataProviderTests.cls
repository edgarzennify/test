@IsTest
private class ExternalDocumentMetaDataProviderTests{
    private static testMethod void it_should_return_a_external_document_meta_data_when_unique_name_is_provided(){
        EB_External_Document__c metadata = new EB_External_Document__c(External_Document_Id__c = 'xxx123');
        insert metadata;
        metadata = [SELECT Id, Name, External_Document_Id__c FROM EB_External_Document__c WHERE Id =: metadata.Id LIMIT 1];

        ExternalDocumentMetaDataProvider sut = new ExternalDocumentMetaDataProvider();
        EB_External_Document__c result = sut.lookupExternal(metadata.Name);
        
        System.assertEquals(metadata.Id, result.Id);
        Object wasFieldInSOQL;
        wasFieldInSOQL = result.Name;
        wasFieldInSOQL = result.External_Document_Id__c;
        wasFieldInSOQL = result.Label__c;
        wasFieldInSOQL = result.MIME_Type__c;
        wasFieldInSOQL = result.File_Type__c;
        wasFieldInSOQL = result.Max_Age_Minutes__c;
    }
}