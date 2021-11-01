public class CPDocsCollateralDocRequestBuilder implements CPDocs.IDocRequestBuilder{

    private String OBJECT_TYPE = 'Collateral';

    private final CPDocs.INCinoRepository m_ncinoRepo;
    private final CPDocs.INcinoDocRequestBuilderHelper m_helper;

    public CPDocsCollateralDocRequestBuilder(CPDocs.INCinoRepository ncinoRepo,
    CPDocs.INcinoDocRequestBuilderHelper helper) {
        m_ncinoRepo = ncinoRepo;
        m_helper = helper;
    }

    public boolean handle(CPDocs.ObjectType type){
        return type == CPDocs.ObjectType.Collateral;
    }

    public List<CPDocs.CPDocRequestSm> buildDocRequests(List<CPDocs.RelatedObject> relObjects, List<DmCPDocumentRequest> cpDocs){       
        Map<string,string> idNameLookup = m_helper.getIdNameLookup(relObjects);
        List<string> ids = new List<string>(idNameLookup.keySet());
        List<DmNcinoDocumentPlaceHolder>  placeHolderDms = m_ncinoRepo.getCollateralDocuments(ids, idNameLookup);
        return m_helper.buildDocRequests( placeHolderDms, relObjects, cpDocs, OBJECT_TYPE);
    }

    
}