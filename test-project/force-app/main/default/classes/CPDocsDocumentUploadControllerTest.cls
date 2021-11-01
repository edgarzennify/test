@IsTest
public class CPDocsDocumentUploadControllerTest {
    
    @IsTest
    private static void fetchDocumentCollection_nullTest() {
        Boolean exceptionThrown = false;
        try {
            CPDocsDocumentUploadController.fetchDocumentCollection('');
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
            CPDocsDocumentUploadController.fetchDocumentCollection('test');
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
            CPDocsDocumentUploadController.postUpload('test');
        } catch(ListException e) {
            System.debug(e.getMessage() + ', ' + e.getTypeName() + ', ' + e.getCause());
        } catch(Exception e) {
            System.debug(e.getMessage() + ', ' + e.getTypeName() + ', ' + e.getCause());
            exceptionThrown = true;
        }
        System.assertEquals(false, exceptionThrown);
    }
}