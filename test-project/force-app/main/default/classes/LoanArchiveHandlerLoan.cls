public class LoanArchiveHandlerLoan implements LoanArchive.IHandler{

    private LoanArchive.IDataProvider m_dataProvider;
    private LoanArchive.IHandlerLoanHelper m_helper;

    public LoanArchiveHandlerLoan(LoanArchive.IDataprovider dataProvider, LoanArchive.IHandlerLoanHelper helper) {
        m_dataProvider = dataProvider;
        m_helper = helper;
    }

    public SObjectType getSObjectTypeHandled() {
        return LLC_BI__Loan__c.SObjectType;
    }

    public List<SObject> getSObjectsForMerging(List<Id> objectIds) {
        return m_dataProvider.getSObjectsForLoanMerge(objectIds);
    }

    public LoanArchive.MergeResult mergeObjects(Id prospectId, Id coreId, Map<Id, SObject> mergeData) {
        if(LoanArchiveHandlerLoanHelper.cachedMap == null){
            List<String> llcBiLoanLookupKeys = getLookupKeys(mergeData.values());
            List<EB_Account__c> ebAccts = m_dataProvider.findEbAcctTwins(llcBiLoanLookupKeys);
            LoanArchiveHandlerLoanHelper.cachedMap = m_helper.buildCachedMap(mergeData.values(), ebAccts);
        }
    
        LLC_BI__Loan__c loan = (LLC_BI__Loan__c) mergeData.get(coreId);
        loan.Archive__c = true;
        loan.Ready_for_Checkback__c = true;

        return buildResult(loan, LoanArchiveHandlerLoanHelper.cachedMap);
    }

    private List<String> getLookupKeys(List<LLC_BI__Loan__c> llcBiLoans){
        List<String> lookupKeys = new List<String>();
        for(LLC_BI__Loan__c loan : llcBiLoans){
            if(loan.LLC_BI__lookupKey__c != null && loan.LLC_BI__lookupKey__c != ''){
                lookupKeys.add(loan.LLC_BI__lookupKey__c);
            }
        }
        return lookupKeys;
    }

    private LoanArchive.MergeResult buildResult(LLC_BI__Loan__c loan, Map<Id, Id> cachedMap){
        LoanArchive.MergeResult result = new LoanArchive.MergeResult();
        result.saveRecords = new List<SObject>{ loan };
        result.deleteRecords = new List<SObject>();
        LoanArchive.DocumentKeyUpdate keyUpdate = new LoanArchive.DocumentKeyUpdate();
        keyUpdate.oldExternalKey = loan.Id;
        keyUpdate.newExternalKey = loan.LLC_BI__lookupKey__c;
        result.keyUpdates = new List<LoanArchive.DocumentKeyUpdate> { keyUpdate };
        LoanArchive.MergeResult relResult = buildRelationshipsResult(loan, cachedMap);
        result.saveRecords.addAll(relResult.saveRecords);
        result.deleteRecords.addAll(relResult.deleteRecords);
        result.mergeRecords = new List<LoanArchive.MergeRequest>();
        return result;
    }

    private LoanArchive.MergeResult buildRelationshipsResult(LLC_BI__Loan__c loan, Map<Id, Id> cachedMap){
        LoanArchive.MergeResult relResult = new LoanArchive.MergeResult();
        relResult.saveRecords = new List<SObject>();
        relResult.deleteRecords = new List<SObject>();
        relResult.mergeRecords = new List<LoanArchive.MergeRequest>();

        for(Agreement_LLC_BI_Loan_Relationship__c llcBiRel : loan.Agreement_LLC_BI_Loan_Relationships__r){
            relResult.deleteRecords.add(llcBiRel);
            Agreement_EB_Account_Relationship__c newAgmtEbAcctRel = new Agreement_EB_Account_Relationship__c(Agreement__c = llcBiRel.Agreement__c, Loan_Account__c = cachedMap.get(loan.Id));
            relResult.saveRecords.add(newAgmtEbAcctRel);
        }

        //for(LLC_BI__Legal_Entities__c inv: loan.LLC_BI__Legal_Entities__r){
        //    if(inv.LLC_BI__Account__r.RecordType.Name == 'Prospect'){
        //        relResult.deleteRecords.add(inv);
        //    }
        //}

        return relResult;
    }   

}