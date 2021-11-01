@IsTest
private class SalesforceDocumentViewerControllerTests {  

    @IsTest
    private static void it_should_get_report_for_content_document(){
        ContentVersion cv = new ContentVersion();
        cv.VersionData = Blob.valueOf('test');
        cv.Title = 'title';
        cv.PathOnClient = '/apex/test';
        insert cv;
        cv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id LIMIT 1];

        SalesforceDocumentViewer.Report result =  SalesforceDocumentViewerController.getPdfData(cv.ContentDocumentId);
        
        system.assertEquals('title.pdf', result.fileName);
    }
    
}