public class ExternalDocumentViewerDvRptHandler implements ExternalDocumentViewer.IRequestHandler {
    
    private final string PARAM_DOC_ID = 'docid';
    
    public string handle(){
        return PARAM_DOC_ID;
    }
    
    public DmDocument buildDocument(Map<string, string> parameters){       
        String documentId = parameters.get(PARAM_DOC_ID);
        DmDocument d = new DmDocument();
        d.id = documentId;
        return d;
    }
}