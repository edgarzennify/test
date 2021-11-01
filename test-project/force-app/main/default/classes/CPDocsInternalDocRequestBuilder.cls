public class CPDocsInternalDocRequestBuilder implements CPDocs.IDocRequestBuilder {

    private string SOURCE_INTERNAL = 'Internal';
    private final CPDocs.ICPDocsRepository m_cpDocsRepo;
    

    public CPDocsInternalDocRequestBuilder(CPDocs.ICPDocsRepository cpDocsRepo){
        m_cpDocsRepo = cpDocsRepo;
    }

    public boolean handle(CPDocs.ObjectType type){
        return true;
    }

    public List<CPDocs.CPDocRequestSm> buildDocRequests(List<CPDocs.RelatedObject> relObjects, List<DmCPDocumentRequest> cpDocs){
        List<string> ids = getIds(relObjects);
        return getSms(m_cpDocsRepo.getDocumentRequestByObjectIdsDms(ids));
    }

    private List<CPDocs.CPDocRequestSm> getSms(List<DmCPDocumentRequest> dms){
        List<CPDocs.CPDocRequestSm> sms = new List<CPDocs.CPDocRequestSm>();
        for(DmCPDocumentRequest dm : dms){
            if(dm.Source == SOURCE_INTERNAL){
                sms.add(getOneSm(dm));
            }
        }
        return sms;
    }

    private CPDocs.CPDocRequestSm getOneSm(DmCPDocumentRequest dm){
        CPDocs.CPDocRequestSm sm = new CPDocs.CPDocRequestSm();
        sm.saveType = CPDocs.SaveType.NoneType;
        sm.requestPm = new PM_CP_Document_Request_c();
        sm.requestPm.id = dm.RecordId;    
        sm.requestPm.ObjectType_c = dm.ObjectType;
        sm.requestPm.ObjectId_c = dm.ObjectId;
        sm.requestPm.ObjectDescription_c = dm.ObjectDescription;
        sm.requestPm.documentName_c = dm.DocumentName;
        sm.requestPm.documentPortalName_c = dm.documentPortalName;
        sm.requestPm.documentDueDate_c = dm.DocumentDueDate;
        sm.requestPm.documentDescription_c = dm.DocumentDescription;
        sm.requestPm.Source_c = dm.Source;
        sm.requestPm.SourceId_c = dm.SourceId;
        sm.requestPm.Status_c = dm.Status;
        return sm;
    }

    private List<string> getIds(List<CPDocs.RelatedObject> rels){
        List<string> ids = new List<string>();
        for(CPDocs.RelatedObject rel: rels){
            ids.add(rel.objectId);
        }
        return ids;
    }


}