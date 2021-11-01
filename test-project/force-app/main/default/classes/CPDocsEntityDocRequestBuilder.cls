public class CPDocsEntityDocRequestBuilder implements CPDocs.IDocRequestBuilder{

    private String OBJECT_TYPE = 'Entity';

    private final CPDocs.INCinoRepository m_ncinoRepo;
    private final CPDocs.INcinoDocRequestBuilderHelper m_helper;

    public CPDocsEntityDocRequestBuilder(CPDocs.INCinoRepository ncinoRepo,
    CPDocs.INcinoDocRequestBuilderHelper helper){
        m_ncinoRepo = ncinoRepo;
        m_helper = helper;
    }

    public boolean handle(CPDocs.ObjectType type){
        return type == CPDocs.ObjectType.Entity;
    }

    public List<CPDocs.CPDocRequestSm> buildDocRequests(List<CPDocs.RelatedObject> relObjects, List<DmCPDocumentRequest> cpDocs){
        List<string> ids = m_helper.getIds(relObjects);
        List<DmNcinoDocumentPlaceHolder>  placeHolderDms = m_ncinoRepo.getAccountDocuments(ids);
        return m_helper.buildDocRequests( placeHolderDms, relObjects, cpDocs, OBJECT_TYPE);
    }
}