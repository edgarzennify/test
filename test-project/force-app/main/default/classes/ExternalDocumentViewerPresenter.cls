public class ExternalDocumentViewerPresenter implements ExternalDocumentViewer.IPresenter{

    List<ExternalDocumentViewer.IRequestHandler> m_handlers;

    public ExternalDocumentViewerPresenter(List<ExternalDocumentViewer.IRequestHandler> handlers){
        m_handlers = handlers;
    }

    public DmDocument getDocument(Map<string, string> parameters){
        ExternalDocumentViewer.IRequestHandler handler = findHandler(parameters);
        if(handler == null) return null;

        return handler.buildDocument(parameters);
    }


    private ExternalDocumentViewer.IRequestHandler findHandler(Map<string, string> parameters){
        
        for(ExternalDocumentViewer.IRequestHandler h : m_handlers){
            for(string x : parameters.keySet()){
                if(h.Handle() == x){
                    return h;
                }
            }
        }
        
        return null;
    }
}