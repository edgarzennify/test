public class CPDocsRepository implements CPDocs.ICPDocsRepository{

    private final CPDocs.IDataProvider m_cDocsDataProvider;
    private final CPDocs.IDmBuilder m_cDocsDmBuilder;


    public CPDocsRepository(CPDocs.IDataProvider cDocsDataProvider, 
        CPDocs.IDmBuilder cDocsDmBuilder){
        m_cDocsDataProvider = cDocsDataProvider; 
        m_cDocsDmBuilder = cDocsDmBuilder;
    }

    public DmUser getUser(string userId){
        return m_cDocsDmBuilder.build(m_cDocsDataProvider.getUserDetail(userId));
    }

    public List<DmCPDocumentRequest> getAllDocumentRequestDms(){
        List<PM_CP_Document_Request_c> pms = m_cDocsDataProvider.getAllDocumentRequests();
        return m_cDocsDmBuilder.build(pms);
    }

    public List<DmCPDocumentRequest> getDocumentRequestByObjectIdsDms(List<string> objectIds){
        List<PM_CP_Document_Request_c> pms = m_cDocsDataProvider.getDocumentRequestByObjectIds(objectIds);
        return m_cDocsDmBuilder.build(pms);
    }
    
    public List<DmCPDocumentRequest> getDocumentRequestByObjectIdsAndDescriptionDms(List<string> ids, string objectDescription){
        List<PM_CP_Document_Request_c> pms = m_cDocsDataProvider.getDocumentRequestByObjectIdsAndDescription(ids, objectDescription);
        return m_cDocsDmBuilder.build(pms);
    }

    public List<DmCPDocumentRequest> getDocumentRequestByIdsDms(List<string> ids){
        List<PM_CP_Document_Request_c> pms = m_cDocsDataProvider.getDocumentRequestByIds(ids);
        return m_cDocsDmBuilder.build(pms);
    } 

    public List<DmCPDocumentRequest> saveDocumentRequestPms(List<CPDocs.CPDocRequestSm> sms){
        List<PM_CP_Document_Request_c> itemsForSave = new List<PM_CP_Document_Request_c>();
        List<PM_CP_Document_Request_c> itemsNone = new List<PM_CP_Document_Request_c>();
        for(CPDocs.CPDocRequestSm sm : sms){
            if(sm.saveType == CPDocs.SaveType.NoneType){
                itemsNone.add(sm.requestPm);              
            }else{
                itemsForSave.add(sm.requestPm);
            }
        }
        List<PM_CP_Document_Request_c> saved = m_cDocsDataProvider.saveCpDocuments(itemsForSave);
        List<PM_CP_Document_Request_c> allItems = new List<PM_CP_Document_Request_c>();
        allItems.addall(saved);
        allItems.addAll(itemsNone);
        return m_cDocsDmBuilder.build(reQuery(allItems));
    }

    public void updateDocumentRequestStatus(List<CPDocs.CPDocRequestSm> sms){
        List<SObject> sobjs = new List<SObject>();
        for(CPDocs.CPDocRequestSm sm: sms){          
            if(sm.saveType == CPDocs.SaveType.InsertType || sm.saveType == CPDocs.SaveType.UpdateType)
            {
                CP_Document_Request__c saveObj = new CP_Document_Request__c();
                if(sm.saveType == CPDocs.SaveType.UpdateType){
                    saveObj.id = sm.requestPm.Id;
                }
                saveObj.Status__c = sm.requestPm.Status_c;
                sobjs.add(saveObj);
            }
        }
        if(sobjs.size() > 0 ) m_cDocsDataProvider.save(sobjs);
    }

    public string getDocIndexIdAfterAddingComponentDocumentLinks(String docRequestId, String destinationObjectId){
        if(String.isBlank(docRequestId) || String.isBlank(destinationObjectId)) return '';
        List<ContentDocumentLink> linkPms = m_cDocsDataProvider.getComponentDocumentLinks(docRequestId);
        List<SObject> inserts = new List<SObject>();
        if(linkPms != null || linkPms.size()> 0){
            LLC_BI__Document_Store__c docStore = new LLC_BI__Document_Store__c();
            m_cDocsDataProvider.save(docStore);
            LLC_BI__Document_Store_Index__c docIndex = new LLC_BI__Document_Store_Index__c();
            docIndex.LLC_BI__Document_Store__c = docStore.Id;
            m_cDocsDataProvider.save(docIndex);
            for(ContentDocumentLink clk : linkPms){
                ContentDocumentLink newClk = clk;
                newClk.Id = null;
                newClk.LinkedEntityId = docStore.Id;
                inserts.add(newClk);
            }
            if(inserts.size() > 0){
                m_cDocsDataProvider.save(inserts);
                return docIndex.Id;
            }          
        }
        return '';
    }

    public void save(List<Sobject> sobjs){
        m_cDocsDataProvider.save(sobjs);
    }

    private List<PM_CP_Document_Request_c> reQuery(List<PM_CP_Document_Request_c> allItems){
        List<String> ids = new List<string>();
        for(PM_CP_Document_Request_c pm : allItems){
            ids.add(pm.id);
        }
        return m_cDocsDataProvider.getDocumentRequestByIds(ids);
    }
}