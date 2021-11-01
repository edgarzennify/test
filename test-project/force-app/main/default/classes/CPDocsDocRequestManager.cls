public class CPDocsDocRequestManager implements CPDocs.IDocRequestManager{
   
    private String STATUS_DOCUMENT_UPLOADED = 'Document Uploaded';

    private CPDocs.ICPDocsRepository m_cpDocsRepo;
    private List<CPDocs.IDocRequestBuilder> m_docRequestBuilders;
    private CPDocs.IRelatedObjectsProvider m_relatedObjsProvider;

    public CPDocsDocRequestManager(CPDocs.ICPDocsRepository cpDocsRepo,
     List<CPDocs.IDocRequestBuilder> docRequestBuilders, CPDocs.IRelatedObjectsProvider relatedObjsProvider){
        m_cpDocsRepo = cpDocsRepo;
        m_docRequestBuilders = docRequestBuilders;
        m_relatedObjsProvider = relatedObjsProvider;
    }

    public List<DmCPDocumentRequest> getRequests(DmUser userDm){
        Map<CPDocs.ObjectType, List<CPDocs.RelatedObject>> relatedObjects = m_relatedObjsProvider.getRelatedObjects(userDm);
        return m_cpDocsRepo.getDocumentRequestByObjectIdsDms(getIds(relatedObjects));
    }

    public List<DmCPDocumentRequest> calculateRequests(DmUser userDm){
        Map<CPDocs.ObjectType, List<CPDocs.RelatedObject>> relatedObjects = m_relatedObjsProvider.getRelatedObjects(userDm);
        return  buildRequests(relatedObjects);
    }

    public List<DmCPDocumentRequest> getRequestByObjectDescription(DmUser userDm, string objectDescription){
        Map<CPDocs.ObjectType, List<CPDocs.RelatedObject>> relatedObjects = m_relatedObjsProvider.getRelatedObjects(userDm);       
        return  m_cpDocsRepo.getDocumentRequestByObjectIdsAndDescriptionDms(getIds(relatedObjects), objectDescription);
    }

    public List<DmCPDocumentRequest> getRequestByIds(List<string> documentRequestIds){
        return m_cpDocsRepo.getDocumentRequestByIdsDms(documentRequestIds);
    }

    public boolean updateRequestStatus(List<string> documentRequestIds){
        List<CPDocs.CPDocRequestSm> sms = new List<CPDocs.CPDocRequestSm>();
        for(String docId: documentRequestIds){
            CPDocs.CPDocRequestSm sm = new CPDocs.CPDocRequestSm();
            sm.saveType = CPDocs.SaveType.UpdateType;
            sm.requestPm = new PM_CP_Document_Request_c();
            sm.requestPm.Id = docId;
            sm.requestPm.Status_c = STATUS_DOCUMENT_UPLOADED;
            sms.add(sm);
        }
        m_cpDocsRepo.updateDocumentRequestStatus(sms);
        return true;
    }

    private List<DmCPDocumentRequest> buildRequests(Map<CPDocs.ObjectType, List<CPDocs.RelatedObject>> relatedObjects){
        List<DmCPDocumentRequest> docRequests = m_cpDocsRepo.getDocumentRequestByObjectIdsDms(getIds(relatedObjects));
        List<CPDocs.CPDocRequestSm> requestPms = new List<CPDocs.CPDocRequestSm>();
        for(CPDocs.ObjectType o : relatedObjects.keySet()){
            addRequests(requestPms, relatedObjects,  docRequests, o);
        }        
        return  m_cpDocsRepo.saveDocumentRequestPms(requestPms);
    }

    private void addRequests(List<CPDocs.CPDocRequestSm> requestPms, Map<CPDocs.ObjectType, 
                List<CPDocs.RelatedObject>> relatedObjects, List<DmCPDocumentRequest> docRequests, CPDocs.ObjectType o){
        List<CPDocs.RelatedObject> relObjs = relatedObjects.get(o);
        for(CPDocs.IDocRequestBuilder bld  : m_docRequestBuilders){
            if(bld.handle(o)){
                requestPms.addAll(bld.buildDocRequests(relObjs,docRequests));
            }
        } 
    }

    private List<string> getIds(Map<CPDocs.ObjectType, List<CPDocs.RelatedObject>> relatedObjects){
        List<string> ids = new List<string>();
        for(List<CPDocs.RelatedObject> objs : relatedObjects.values()){
            for(CPDocs.RelatedObject obj: objs){
                ids.add(obj.objectId);
            }
        }
        return ids;
    }
}