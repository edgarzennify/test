public class LoanArchiveHandlerCollateral implements LoanArchive.IHandler {
    
    private List<LLC_BI__Document_PlaceHolder__c> m_docs;

    private final LoanArchive.IDataProvider m_dataProvider;
    private final LoanArchive.IHandlerCollateralHelper m_helper;

    public LoanArchiveHandlerCollateral(LoanArchive.IDataProvider dataProvider, LoanArchive.IHandlerCollateralHelper helper) {
        m_dataProvider = dataProvider;
        m_helper = helper;
    }

    public SObjectType getSObjectTypeHandled(){
        return LLC_BI__Collateral__c.SObjectType;   
    }

    public List<SObject> getSObjectsForMerging(List<Id> objectIds){
        return m_dataProvider.getSObjectsForCollateralMerge(objectIds);
    }

    public LoanArchive.MergeResult mergeObjects(Id prospectId, Id coreId, Map<Id, SObject> mergeData){
        List<SObject> saves = new List<SObject>();
        List<SObject> deletes = new List<SObject>();
        List<LoanArchive.MergeRequest> merges = new List<LoanArchive.MergeRequest>();

        List<LLC_BI__Document_PlaceHolder__c> prospectDocs = new List<LLC_BI__Document_PlaceHolder__c>();
        List<LLC_BI__Document_PlaceHolder__c> coreDocs = new List<LLC_BI__Document_PlaceHolder__c>();
        Set<Id> collateralIdSet = mergeData.keyset();
        
          
        cacheDocuments(mergeData);
  
        LLC_BI__Collateral__c prospect = (LLC_BI__Collateral__c) mergeData.get(prospectId);
        LLC_BI__Collateral__c core = (LLC_BI__Collateral__c) mergeData.get(coreId);
        
        prospect.Sync_Key__c = core.Sync_Key__c;
        prospect.LLC_BI__Collateral_Name__c = core.LLC_BI__Collateral_Name__c;
        
        if(m_docs != null){
            for(LLC_BI__Document_PlaceHolder__c d : m_docs){
                if(d.LLC_BI__External_Id__c == coreId){
                    coreDocs.add(d);
                }
            }
        }

        saves.addAll(reparentCollateralPledges(prospect, core));
        saves.addAll(reparentCollateralOwnerships(prospect, core));
        saves.addAll(reparentCollateralDocuments(prospect, coreDocs));
        
        saves.add(prospect);
        deletes.add(core);

        LoanArchive.DocumentKeyUpdate keyUpdate = new LoanArchive.DocumentKeyUpdate();
        keyUpdate.oldExternalKey = prospect.Id;
        keyUpdate.newExternalKey = prospect.Sync_Key__c;

        return buildResult(saves, deletes, merges, keyUpdate);
    }

    private List<SObject> reparentCollateralPledges(LLC_BI__Collateral__c prospect, LLC_BI__Collateral__c core){
        return m_helper.reparentCollateralPledges(prospect.LLC_BI__Loan_Collateral2__r, core.LLC_BI__Loan_Collateral2__r);
    }

    private List<SObject> reparentCollateralDocuments(LLC_BI__Collateral__c prospect,List<LLC_BI__Document_PlaceHolder__c> coreDocuments){
        return m_helper.reparentCollateralDocuments(prospect.Id, coreDocuments);
    }

    private List<SObject> reparentCollateralOwnerships(LLC_BI__Collateral__c prospect, LLC_BI__Collateral__c core){
        return m_helper.reparentCollateralOwnerships(prospect.LLC_BI__Account_Collateral__r, core.LLC_BI__Account_Collateral__r);
    }

    private LoanArchive.MergeResult buildResult(List<SObject> saves, List<SObject> deletes, List<LoanArchive.MergeRequest> mergeObjs , LoanArchive.DocumentKeyUpdate keyUpdate) {
        LoanArchive.MergeResult result = new LoanArchive.MergeResult();
        result.saveRecords = saves;
        result.deleteRecords = deletes;
        result.mergeRecords = mergeObjs;
        result.keyUpdates = new List<LoanArchive.DocumentKeyUpdate> { keyUpdate };
        
        return result;
    }

    private void cacheDocuments(Map<Id, SObject> mergeData){

        if(m_docs == null){
            List<Id> collateralIds = getCoreObjectIds(mergeData);
            m_docs = new List<LLC_BI__Document_PlaceHolder__c>();
            List<LLC_BI__Document_PlaceHolder__c> docs = m_dataProvider.getCollateralDocumentsForMerge(collateralIds);
            if(docs == null) return;
            for(LLC_BI__Document_PlaceHolder__c d : docs){               
                m_docs.add(d);
            }
        }
    }

    private List<Id> getCoreObjectIds(Map<Id, SObject> mergeData){
        List<Id> coreIds = new List<Id>();
        if(mergeData == null) return coreIds;
        for(SObject o : mergeData.values()){
            LLC_BI__Collateral__c cobj = (LLC_BI__Collateral__c)o;
            if(!String.isBlank(cobj.Sync_Key__c)){
                coreIds.add(cobj.Id);
            }
        }
        return coreIds;
    }
}