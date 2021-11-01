public class SalesforceDocumentViewerDataProvider implements SalesforceDocumentViewer.IDataProvider{
    
    public Attachment getAttachmentDocument(string documentId){
        return [
                SELECT Id,
                        ContentType,
                        OwnerId,
                        Parent.Type,
                        Parent.Name,
                        Owner.Name,
                        Name,
                        Body,
                        LastModifiedDate
                FROM Attachment 
                WHERE Id =: documentId
                LIMIT 1
            ];
    }
    
    public ContentVersion getContentDocument(string documentId){
        return [
            SELECT 
                Id
                ,Title
                ,Description
                ,FileType
                ,VersionData
                ,FileExtension
                ,LastModifiedDate
            FROM 
                ContentVersion 
            WHERE 
                ContentDocumentId =: documentId
            ORDER BY
                LastModifiedDate DESC
            Limit 1
       ];
    }
    
    public Document getDocument(string documentId){
        return [
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
                    Id =: documentId
                LIMIT 1
            ];
    }
}