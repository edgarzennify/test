global class SalesforceDocumentViewerController {

    @RemoteAction
    global static SalesforceDocumentViewer.Report getPdfData(string documentId){
        SalesforceDocumentViewer.IPresenter p = getPresenterInstance();
        return p.getReport(documentId);
    }
    

    private static SalesforceDocumentViewer.IPresenter getPresenterInstance(){
        SalesforceDocumentViewer.IDataProvider dataProvider = new SalesforceDocumentViewerDataProvider();
        Utility.IUtility util = new Utility();
        IEncodingUtil encode = new EncodingUtilProvider();
        return new SalesforceDocumentViewerPresenter(dataProvider, util, encode);
    }
}