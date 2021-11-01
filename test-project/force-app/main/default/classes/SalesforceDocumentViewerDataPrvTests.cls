@IsTest
private class SalesforceDocumentViewerDataPrvTests {
    private static final SalesforceDocumentViewerDataProvider sut;
    
    static{
        sut = new SalesforceDocumentViewerDataProvider();
    }
    
    @IsTest
    private static void it_should_get_attachment(){
        Contact c = new Contact();
        c.firstName = 'first';
        c.LastName = 'last';
        insert c;
        Attachment a = new Attachment();
        a.Body = Blob.valueOf('test');
        a.Name = 'name';
        a.ParentId = c.Id;
        insert a;
        
        Attachment result = sut.getAttachmentDocument(a.Id);
        
        Object fieldObject = result.Id;
        fieldObject = result.ContentType;
        fieldObject = result.OwnerId;
        fieldObject = result.Parent.Type;
        fieldObject = result.Parent.Name;
        fieldObject = result.Owner.Name;
        fieldObject = result.Name;
        fieldObject = result.Body;
        fieldObject = result.LastModifiedDate;
    }
    
    @IsTest
    private static void it_should_get_content_version(){
        
        ContentVersion cv = new ContentVersion();
        cv.VersionData = Blob.valueOf('test');
        cv.Title = 'title';
        cv.PathOnClient = '/apex/test';
        insert cv;

        cv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id LIMIT 1];
        
        ContentVersion result = sut.getContentDocument(cv.ContentDocumentId);
        
        Object fieldObject = result.Id;
        fieldObject = result.Title;
        fieldObject = result.Description;
        fieldObject = result.FileType;
        fieldObject = result.VersionData;
        fieldObject = result.FileExtension;
        fieldObject = result.LastModifiedDate;
    }

}