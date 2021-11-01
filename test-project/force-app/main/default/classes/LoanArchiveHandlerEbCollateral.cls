public class LoanArchiveHandlerEbCollateral implements LoanArchive.IHandler {
    private final LoanArchive.IDataProvider m_dataProvider;

    public LoanArchiveHandlerEbCollateral(LoanArchive.IDataProvider dataProvider) {
        m_dataProvider = dataProvider;
    }

    public SObjectType getSObjectTypeHandled(){
        return LLC_BI__Collateral__c.SObjectType;   
    }

    public List<SObject> getSObjectsForMerging(List<Id> objectIds){
        return m_dataProvider.getSObjectsForEbCollateralMerge(objectIds);
    }

    public LoanArchive.MergeResult mergeObjects(Id prospectId, Id coreId, Map<Id, SObject> mergeData){
        LLC_BI__Collateral__c prospectCollateral = (LLC_BI__Collateral__c) mergeData.get(prospectId);
        LLC_BI__Collateral__c coreCollateral = (LLC_BI__Collateral__c) mergeData.get(coreId);
        EB_Collateral__c prospectEbCollateral = getProspectEbCollateral(prospectCollateral, mergeData);
        EB_Collateral__c coreEbCollateral = getCoreEbCollateral(coreCollateral, mergeData);

        if(prospectEbCollateral != null && coreEbCollateral != null){
            prospectEbCollateral.Name = coreEbCollateral.Name;
            prospectEbCollateral.Key__c = coreEbCollateral.Key__c;
            return buildResult(prospectEbCollateral, coreEbCollateral);
        }

        return null;
    }

    private EB_Collateral__c getProspectEbCollateral(LLC_BI__Collateral__c prospect, Map<Id, SObject> data){
        for(SObject sobj : data.values()){
            if(sobj.getSObjectType() == EB_Collateral__c.SObjectType){
                EB_Collateral__c ebCollateral = (EB_Collateral__c)sobj;
                if(ebCollateral.Status__c == 'Prospective' && ebCollateral.Name == prospect.Name){
                    return ebCollateral;
                }
            }
        }
        return null;
    }
    
    private EB_Collateral__c getCoreEbCollateral(LLC_BI__Collateral__c core, Map<Id, SObject> data){
        for(SObject sobj : data.values()){
            if(sobj.getSObjectType() == EB_Collateral__c.SObjectType){
                EB_Collateral__c ebCollateral = (EB_Collateral__c)sobj;
                if(ebCollateral.Status__c == 'Existing' && ebCollateral.Key__c == core.Sync_Key__c){
                    return ebCollateral;
                }
            }
        }
        return null;
    }

    private LoanArchive.MergeResult buildResult(SObject saveObj, SObject deleteObj){
        LoanArchive.MergeResult result = new LoanArchive.MergeResult();
        result.saveRecords = new List<SObject> { saveObj };
        result.deleteRecords = new List<SObject> { deleteObj };
        result.mergeRecords = new List<LoanArchive.MergeRequest>();
        result.keyUpdates = new List<LoanArchive.DocumentKeyUpdate>();
        return result;
    }
}