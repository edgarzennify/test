public class SalesforceDocumentProvider implements Documents.ISalesforceDocumentProvider{
    public Document getDocument(String folderName, String documentName){
        Folder folder = getFolderByName(folderName);
        if(folder == null){
            return null;
        }
        List<Document> document = [
            SELECT 
                Id
                ,Name
                ,AuthorId 
                ,IsInternalUseOnly
                ,Body
                ,ContentType
                ,Description
                ,Keywords
                ,Type
                ,LastModifiedDate
            FROM 
                Document 
            WHERE 
                Name =: documentName
            LIMIT 1
        ];
        return document.size() > 0 ? document[0] : null;
    }

    public List<Document> getDocuments(List<String> documentIds) {

        return 
            [
            SELECT 
                Id
                ,Name
                ,AuthorId 
                ,IsInternalUseOnly
                ,Body
                ,ContentType
                ,Description
                ,Keywords
                ,Type
                ,LastModifiedDate
            FROM 
                Document 
            WHERE 
                Id in: documentIds
        ];
    }

    public Document saveDocument(String folderName, Document document){
        Folder folder = getFolderByName(folderName);
        if(folder == null){
            throw new FolderDoesNotExistException ('Folder does not exist - ' + folderName);
        }
        
        document.FolderId = folder.Id;
        upsert document;

        return document;
    }

    private Folder getFolderByName(String name){
        List<Folder> folder = [SELECT Id, Name FROM Folder WHERE Folder.Name =:name LIMIT 1]; 
        return folder.size() > 0 ? folder[0] : null;
    }
    
    public class FolderDoesNotExistException extends Exception{}
}