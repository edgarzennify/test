@IsTest
public class DocumentUploadControllerTest {
    
    @IsTest
    private static void fetchDocumentCollection_nullTest() {
        Boolean exceptionThrown = false;
        try {
            DocumentUploadController.fetchDocumentCollection('');
        } catch(ListException e) {
            System.debug(e.getMessage() + ', ' + e.getTypeName() + ', ' + e.getCause());
        } catch(Exception e) {
            System.debug(e.getMessage() + ', ' + e.getTypeName() + ', ' + e.getCause());
            exceptionThrown = true;
        }
        System.assertEquals(false, exceptionThrown);
    }

    @IsTest
    private static void fetchDocumentCollection_valueTest() {
        Boolean exceptionThrown = false;
        try {
            DocumentUploadController.fetchDocumentCollection('test');
        } catch(ListException e) {
            System.debug(e.getMessage() + ', ' + e.getTypeName() + ', ' + e.getCause());
        } catch(Exception e) {
            System.debug(e.getMessage() + ', ' + e.getTypeName() + ', ' + e.getCause());
            exceptionThrown = true;
        }
        System.assertEquals(false, exceptionThrown);
    }

    @IsTest
    private static void postUpload_test() {
        Boolean exceptionThrown = false;
        try {
            DocumentUploadController.postUpload('test');
        } catch(ListException e) {
            System.debug(e.getMessage() + ', ' + e.getTypeName() + ', ' + e.getCause());
        } catch(Exception e) {
            System.debug(e.getMessage() + ', ' + e.getTypeName() + ', ' + e.getCause());
            exceptionThrown = true;
        }
        System.assertEquals(false, exceptionThrown);
    }

    @IsTest
    private static void parseData_test() {
        CPDocs.DocumentRequest mockRequest = new CPDocs.DocumentRequest();
        mockRequest.documentRequestId = 'test';
        mockRequest.objectType = 'test';
        mockRequest.objectId  = 'test';
        mockRequest.objectDescription = 'test';
        mockRequest.documentDescription = 'test';
        mockRequest.documentName = 'test';
        mockRequest.documentDueDate = '2000-01-01';
        DocumentUploadController.MockDocumentRequest[] results = (DocumentUploadController.MockDocumentRequest[])DocumentUploadController.parseData(new List<CPDocs.DocumentRequest> {
            mockRequest
        });
        System.assertEquals(1, results.size());
        System.assertEquals('test', results[0].documentRequestId);
        System.assertEquals('test', results[0].objectType);
        System.assertEquals('test', results[0].objectId);
        System.assertEquals('test', results[0].objectDescription);
        System.assertEquals('test', results[0].documentDescription);
        System.assertEquals('test', results[0].documentName);
        System.assertEquals('2000-01-01 Overdue!', results[0].documentDueDate);
    }
}