public with sharing class ExternalDocumentViewerController {
    
    private final IApexPages m_apexPages;
    private final ExternalDocumentViewer.IPresenter m_presenter;

    public String message {get;set;}
    
    public ExternalDocumentViewerController(){
        m_apexPages = new ApexPagesWrapper();
        m_presenter = ExternalDocumentViewerBootstrap.getPresenterInstance();
    }
    
    public ExternalDocumentViewerController(IApexPages apexPages, ExternalDocumentViewer.IPresenter presenter){
        m_apexPages = apexPages;
        m_presenter = presenter;
    }

    public PageReference initialize() {
        try{
            DmDocument d =m_presenter.getDocument(m_apexPages.getParameters());
            return new PageReference('/servlet/servlet.FileDownload?file=' + d.Id);
        }catch(Exception ex){
            message = 'Unable to load external document - ' + ex.getMessage();
        }   
        return null;     
    }

}