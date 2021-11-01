global class SalesforceDocumentViewer {

    public interface IDataProvider{
        Attachment getAttachmentDocument(string documentId);
        ContentVersion getContentDocument(string documentId);
        Document getDocument(string documentId);
    }

    public interface IPresenter{
        Report getReport(string documentId);
    }

    global class Report{
        public string dataAsBase64{get;set;}
        public string fileName{get;set;}
    }
}