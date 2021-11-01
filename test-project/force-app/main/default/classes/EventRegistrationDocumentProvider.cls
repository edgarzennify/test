public class EventRegistrationDocumentProvider implements EventRegistration.IDocumentProvider {

	private final Documents.ISalesforceDocumentProvider m_provider;
    private final Documents.IDocumentDmBuilder m_builder;
    
    public EventRegistrationDocumentProvider(Documents.ISalesforceDocumentProvider provider,  Documents.IDocumentDmBuilder builder){
        m_provider = provider;
        m_builder = builder;
    }

	public Map<String,DmDocument> getDocuments(List<String> documentIds) {
		Map<String, DmDocument> mapped = new Map<String, DmDocument>();
		for(Document d : m_provider.getDocuments(documentIds)){
			mapped.put(d.Id, m_builder.build(d));
		}

		return mapped;
	}
}