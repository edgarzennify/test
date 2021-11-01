public class DocumentCache implements Documents.IDocumentCache {

    private final String DOCUMENT_CACHE_FOLDER = 'DocumentCache';
    private final Documents.ISalesforceDocumentProvider m_provider;
    private final Documents.IDocumentDmBuilder m_builder;
    
    public DocumentCache(Documents.ISalesforceDocumentProvider provider,  Documents.IDocumentDmBuilder builder){
        m_provider = provider;
        m_builder = builder;
    }

    public DmDocument getDocument(String documentName){
        return m_builder.build(m_provider.getDocument(DOCUMENT_CACHE_FOLDER, documentName));
    }

    public DmDocument saveDocument(DmDocument dmDocument){
        Document documentPm = m_builder.build(dmDocument);
        return m_builder.build(m_provider.saveDocument(DOCUMENT_CACHE_FOLDER, documentPm));
    }
}