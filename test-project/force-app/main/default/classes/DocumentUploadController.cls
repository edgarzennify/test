global class DocumentUploadController {

    @AuraEnabled
    public static Object[] fetchDocumentCollection(String filterCriteria) {
        return String.isBlank(filterCriteria) ? fetchAllDocs() : fetchDocsByFilter(filterCriteria);
    }

    @TestVisible
    private static Object[] fetchAllDocs() {
        CPDocs.IPresenter presenter = CPDocsBootstrapper.getIPresenterInstance();
        List<CPDocs.DocumentRequest> response = presenter.getAllDocumentRequests();
        System.debug(JSON.serialize(response));
        return parseData(response);
    }

    @TestVisible
    private static Object[] fetchDocsByFilter(String objectDescription) {
        CPDocs.IPresenter presenter = CPDocsBootstrapper.getIPresenterInstance();
        List<CPDocs.DocumentRequest> response = presenter.getDocumentRequestsByFilter(objectDescription);
        System.debug(JSON.serialize(response));
        return parseData(response);
    }

    @AuraEnabled
    public static Object[] postUpload(String docRequestId) {
        CPDocs.IPresenter presenter = CPDocsBootstrapper.getIPresenterInstance();
        List<CPDocs.DocumentRequest> response = presenter.postUpload(docRequestId);
        return parseData(response);
    }

    @TestVisible
    private static Object[] parseData(List<CPDocs.DocumentRequest> documents) {
        List<MockDocumentRequest> returnData = new List<MockDocumentRequest> ();
        for (CPDocs.DocumentRequest document : documents) {
            MockDocumentRequest mockResponse = new MockDocumentRequest(document);
            returnData.add(mockResponse);
        }
        return returnData;
    }

    public class MockDocumentRequest {
        @AuraEnabled public String documentRequestId { get; set; }
        @AuraEnabled public String objectType { get; set; }
        @AuraEnabled public String objectId { get; set; }
        @AuraEnabled public String objectDescription { get; set; }
        @AuraEnabled public String documentDescription { get; set; }
        @AuraEnabled public String documentName { get; set; }
        @AuraEnabled public String documentDueDate { get; set; }
        @AuraEnabled public Boolean readyStatus { get; set; }
        @AuraEnabled public Boolean pastDue { get; set; }

        public MockDocumentRequest(CPDocs.DocumentRequest document) {
            this.documentRequestId = document.documentRequestId;
            this.objectType = document.objectType;
            this.objectId = document.objectId;
            this.objectDescription = document.objectDescription;
            this.documentDescription = document.documentDescription;
            this.documentName = document.documentName;
            if (String.isNotBlank(document.documentDueDate)) {
                this.pastDue = Date.today() > Date.valueOf(document.documentDueDate);
                this.documentDueDate = this.pastDue ? document.documentDueDate + ' Overdue!' : document.documentDueDate;
            }
            this.readyStatus = document.status == 'Open' ? false : true;
        }
    }
}