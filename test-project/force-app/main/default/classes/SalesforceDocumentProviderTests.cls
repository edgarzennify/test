@IsTest
private class SalesforceDocumentProviderTests{

    private static String TEST_FOLDER_NAME = 'DocumentCache';
    private static String BOGUS_FOLDER_NAME = 'BogusFolderForNegativeTesting';
    private static SalesforceDocumentProvider sut;

    static {
        sut = new SalesforceDocumentProvider();
    }

    private static testMethod void it_should_get_a_document_by_foldername_and_documentname(){
        String folderName = TEST_FOLDER_NAME;
        String documentName = 'test document 123';
        Document testDoc = new Document();
        testDoc.Name = documentName;
        testDoc.FolderId = getFolderByName(folderName).Id;
        insert testDoc;

        Document result = sut.getDocument(folderName, documentName);

        System.assertEquals(testDoc.Id, result.Id);
        System.assertEquals(documentName , result.Name);
        Object fieldObject;
        fieldObject = result.Id;
        fieldObject = result.Name;
        fieldObject = result.AuthorId; 
        fieldObject = result.IsInternalUseOnly;
        fieldObject = result.Body;
        fieldObject = result.ContentType;
        fieldObject = result.Description;
        fieldObject = result.Keywords;
        fieldObject = result.Type;
        fieldObject = result.LastModifiedDate;
    }

    private static testMethod void it_should_return_null_when_getting_a_document_and_folder_doesnt_exist(){
        String folderName = BOGUS_FOLDER_NAME;
        String documentName = 'test document 123';

        Document result = sut.getDocument(folderName, documentName);

        System.assertEquals(null, result);
    }

    private static testMethod void it_should_return_null_when_no_documents_are_found() {
        Id docId = ObjectFactory.getFakeId(Document.SObjectType, '1');

        List<Document> result = sut.getDocuments(new List<Id>{docId});

        System.assert(result.size() == 0);
    }

    private static testMethod void it_should_save_a_document(){
        String folderName = TEST_FOLDER_NAME;
        String documentName = 'test document 123';
        Document testDoc = new Document();
        testDoc.Name = documentName;

        Document result = sut.saveDocument(folderName, testDoc);

        System.assertNotEquals(null, result.Id);
    }

    private static testMethod void it_should_throw_a_FolderDoesNotExistException_when_saving_and_folder_doesnt_exist(){
        String folderName = BOGUS_FOLDER_NAME;
        String documentName = 'test document 123';
        Document testDoc = new Document();
        testDoc.Name = documentName;

        try{
            Document result = sut.saveDocument(folderName, testDoc);
            System.assert(false);
        }catch(SalesforceDocumentProvider.FolderDoesNotExistException ex){
            System.assert(true);
        }
    }
    
    private static Folder getFolderByName(String name){
        List<Folder> folder = [SELECT Id, Name FROM Folder WHERE Folder.Name =:name LIMIT 1]; 
        return folder.size() > 0 ? folder[0] : null;
    }
}