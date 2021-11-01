global class CPDocsDocumentUploadController {

    @AuraEnabled
    public static Object[] fetchDocumentCollection(String filterCriteria) {
        return String.isBlank(filterCriteria) ? fetchAllDocs() : fetchDocsByFilter(filterCriteria);
    }

    @TestVisible
    private static Object[] fetchAllDocs() {
        CPDocs.IPresenter presenter = CPDocsBootstrapper.getIPresenterInstance();
        return presenter.getAllDocumentRequests();
    }

    @TestVisible
    private static Object[] fetchDocsByFilter(String objectDescription) {
        CPDocs.IPresenter presenter = CPDocsBootstrapper.getIPresenterInstance();
        return presenter.getDocumentRequestsByFilter(objectDescription);
    }

    @AuraEnabled
    public static Object[] postUpload(String docRequestId) {
        CPDocs.IPresenter presenter = CPDocsBootstrapper.getIPresenterInstance();
        return presenter.postUpload(docRequestId);
    }
}