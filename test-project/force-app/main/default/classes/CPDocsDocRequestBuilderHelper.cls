public class CPDocsDocRequestBuilderHelper implements CPDocs.INcinoDocRequestBuilderHelper{

    private String STATUS_OPEN = 'Open';
    private String STATUS_REJECTED = 'Rescinded';

    public CPDocsDocRequestBuilderHelper() {
    }

    public List<CPDocs.CPDocRequestSm> buildDocRequests( List<DmNcinoDocumentPlaceHolder> placeHolderDms,List<CPDocs.RelatedObject> relObjects, List<DmCPDocumentRequest> cpDocs, String objectType){
        List<CPDocs.CPDocRequestSm> reqs = new List<CPDocs.CPDocRequestSm>();
        String source = relObjects[0].source;
        List<string> entityIds = getIds(relObjects);
        
        Map<string,DmCPDocumentRequest> lookupCpDocs = getLookup(cpDocs);
        Map<string,DmNcinoDocumentPlaceHolder> lookupPlaceHolder = getLookup(placeHolderDms); 

        for(DmNcinoDocumentPlaceHolder dm : placeHolderDms){
            String key = dm.Id;
            if(lookupCpDocs.containskey(key)){
                DmCPDocumentRequest cpRecord = lookupCpDocs.get(key);
                if(!dm.IsPortalEnabled){
                    reqs.add(buildUpdateSm(cpRecord,STATUS_REJECTED));
                }else{
                    reqs.add(buildNoneSm(cpRecord));
                }     
            }
            else{
                if(dm.IsPortalEnabled) {
                    reqs.add(buildInsertSm(dm,source, objectType));
                }
            }       
        }

        for( DmCPDocumentRequest cp : cpDocs){
            if(String.isnotblank(cp.SourceId)){
                DmNcinoDocumentPlaceHolder ph = lookupPlaceHolder.get(cp.SourceId);
                if(ph == null || String.isBlank(ph.id)){
                    reqs.add(buildUpdateSm(cp,STATUS_REJECTED));
                }
            }
        }
        return reqs;
    }

    public List<string> getIds(List<CPDocs.RelatedObject> rels){
        List<string> ids = new List<string>();
        for(CPDocs.RelatedObject rel: rels){
            ids.add(rel.objectId);
        }
        return ids;
    }

    public Map<String,String> getIdNameLookup(List<CPDocs.RelatedObject> relObjects){
        Map<string,string> idNameLookup = new Map<string,string>();
        for(CPDocs.RelatedObject rel: relObjects){
            idNameLookup.put(rel.objectId, rel.objectName);
        }
        return idNameLookup;
    }

    private CPDocs.CPDocRequestSm buildUpdateSm(DmCPDocumentRequest dm, String status){
        CPDocs.CPDocRequestSm sm = new CPDocs.CPDocRequestSm();
        sm.saveType = CPDocs.SaveType.UpdateType;
        sm.requestPm = new PM_CP_Document_Request_c();
        sm.requestPm.id = dm.id;
        sm.requestPm.ObjectId_c = dm.ObjectId;
        sm.requestPm.ObjectDescription_c = dm.ObjectDescription;
        sm.requestPm.ObjectType_c = dm.ObjectType;
        sm.requestPm.documentName_c = dm.DocumentName;
        sm.requestPm.documentPortalName_c = dm.documentPortalName;
        sm.requestPm.documentDueDate_c = dm.DocumentDueDate;
        sm.requestPm.documentDescription_c = dm.DocumentDescription;
        sm.requestPm.SourceId_c = dm.SourceId;
        sm.requestPm.Source_c = dm.Source;
        sm.requestPm.Status_c = status;
        return sm;
    }

    private CPDocs.CPDocRequestSm buildNoneSm(DmCPDocumentRequest dm){
        CPDocs.CPDocRequestSm sm = new CPDocs.CPDocRequestSm();
        sm.saveType = CPDocs.SaveType.NoneType;
        sm.requestPm = new PM_CP_Document_Request_c();
        sm.requestPm.id = dm.id;
        sm.requestPm.ObjectId_c = dm.ObjectId;
        sm.requestPm.ObjectDescription_c = dm.ObjectDescription;
        sm.requestPm.ObjectType_c = dm.ObjectType;
        sm.requestPm.documentName_c = dm.DocumentName;
        sm.requestPm.documentPortalName_c = dm.documentPortalName;
        sm.requestPm.documentDueDate_c = dm.DocumentDueDate;
        sm.requestPm.documentDescription_c = dm.DocumentDescription;
        sm.requestPm.SourceId_c = dm.SourceId;
        sm.requestPm.Source_c = dm.Source;
        sm.requestPm.Status_c = dm.Status;
        return sm;
    }

    private CPDocs.CPDocRequestSm buildInsertSm(DmNcinoDocumentPlaceHolder dm,String sourceName, String objectType){
        CPDocs.CPDocRequestSm sm = new CPDocs.CPDocRequestSm();
        sm.saveType = CPDocs.SaveType.InsertType;
        sm.requestPm = new PM_CP_Document_Request_c();
        sm.requestPm.id = '';
        sm.requestPm.ObjectId_c = dm.objectId;
        sm.requestPm.ObjectDescription_c = dm.objectName;
        sm.requestPm.ObjectType_c = objectType;
        sm.requestPm.documentName_c = dm.Name;
        sm.requestPm.documentPortalName_c = dm.documentName ;
        sm.requestPm.documentDueDate_c = dm.documentDueDate <> null?Date.valueOf(dm.documentDueDate):null;
        sm.requestPm.documentDescription_c = dm.DocumentDescription;
        sm.requestPm.SourceId_c = dm.Id;
        sm.requestPm.Source_c = sourceName;
        sm.requestPm.Status_c = STATUS_OPEN;
        return sm;
    }

    private Map<string,DmCPDocumentRequest> getLookup(List<DmCPDocumentRequest> requestDms){
        Map<string,DmCPDocumentRequest> lookup = new Map<string,DmCPDocumentRequest>();
        for(DmCPDocumentRequest l : requestDms){
            String key = l.SourceId;
            if(!lookup.containsKey(key)){
                lookup.put(key,l);
            }
        }
        return lookup;
    }

    private Map<string,DmNcinoDocumentPlaceHolder> getLookup(List<DmNcinoDocumentPlaceHolder> placeHolderDms){
        Map<string,DmNcinoDocumentPlaceHolder> lookup = new Map<string,DmNcinoDocumentPlaceHolder>();
        for(DmNcinoDocumentPlaceHolder l : placeHolderDms){
            String key = l.id;
            if(!lookup.containsKey(key)){
                lookup.put(key,l);
            }
        }
        return lookup;
    }
    
}