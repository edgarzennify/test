public class ExternalDocumentViewerImgDocHandler implements ExternalDocumentViewer.IRequestHandler {

    private final string PARAM_NAME = 'name';

    private final Documents.IDocumentRequestBuilder m_requestBuilder;
    private final Documents.IDocumentProvider m_docs;

    public ExternalDocumentViewerImgDocHandler(Documents.IDocumentRequestBuilder requestBuilder, Documents.IDocumentProvider docs){
        m_requestBuilder = requestBuilder;
        m_docs = docs;
    }

    public string handle(){
        return PARAM_NAME;
    }
    
    public DmDocument buildDocument(Map<string, string> parameters){
        String docName = parameters.get(PARAM_NAME);
        Documents.DocumentGetRequest request = m_requestBuilder.buildDocumentGetRequest(docName);
        DmDocument doc = m_docs.getDocument(request);
        return doc;
    }
}