@IsTest
public class SalesforceDocumentViewerMock {
    public class ofIDataProvider extends ApexMoq implements SalesforceDocumentViewer.IDataProvider {
        public Attachment getAttachmentDocument(string documentId){
            return (Attachment)handleMethodInvocation('getAttachmentDocument', new List<Object>{documentId});
        }
        public ContentVersion getContentDocument(string documentId){
            return (ContentVersion)handleMethodInvocation('getContentDocument', new List<Object>{documentId});
        }
        public Document getDocument(string documentId){
            return (Document)handleMethodInvocation('getDocument', new List<Object>{documentId});
        }
    }
}