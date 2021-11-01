public class SalesforceDocumentViewerPresenter implements SalesforceDocumentViewer.IPresenter{
	
    private final String DOCUMENT_OBJ_NAME = 'document';
    private final String CONTENT_DOCUMENT_OBJ_NAME = 'contentdocument';
    private final String ATTACHMENT_OBJ_NAME = 'attachment';
    
    private final SalesforceDocumentViewer.IDataProvider m_dataProvider;
    private final Utility.IUtility m_util;
    private final IEncodingUtil m_encodingUtil;
    
    public SalesforceDocumentViewerPresenter(SalesforceDocumentViewer.IDataProvider dataProvider, Utility.IUtility util, IEncodingUtil encodingUtil){
        m_dataProvider = dataProvider;
        m_util = util;
        m_encodingUtil = encodingUtil;
    }
    public SalesforceDocumentViewer.Report getReport(string documentId){
        String objName = m_util.getObjectNameFromId(documentId);
        if(objName == DOCUMENT_OBJ_NAME){
            Document doc = m_dataProvider.getDocument(documentId);
            if(doc != null) return getReport(doc.name, doc.Body);
        } else if(objName == CONTENT_DOCUMENT_OBJ_NAME) {
            ContentVersion cdoc = m_dataProvider.getContentDocument(documentId);
            if(cdoc != null) return getReport(cdoc.Title, cdoc.VersionData);
        } else if(objName == ATTACHMENT_OBJ_NAME){
            Attachment adoc = m_dataProvider.getAttachmentDocument(documentId);
            if(adoc != null) return getReport(adoc.name, adoc.Body);
        }
        return null;
    }
    
    private SalesforceDocumentViewer.Report getReport(string filename, Blob data){
        SalesforceDocumentViewer.Report r = new SalesforceDocumentViewer.Report();
        r.fileName = String.format('{0}.pdf', new List<string>{filename});
        r.dataAsBase64 = m_encodingUtil.toBase64(data);
        return r;
    }
}