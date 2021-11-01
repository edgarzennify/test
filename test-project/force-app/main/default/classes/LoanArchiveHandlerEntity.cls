public class LoanArchiveHandlerEntity implements LoanArchive.IHandler{
    private final LoanArchive.IDataProvider m_dataProvider;
    private final LoanArchive.IHandlerEntityHelper m_entityHandlerHelper;

    public LoanArchiveHandlerEntity (LoanArchive.IDataprovider dataProvider, LoanArchive.IHandlerEntityHelper entityHandlerHelper) {
        m_dataProvider = dataProvider;
        m_entityHandlerHelper = entityHandlerHelper;
    }
    
    public SObjectType getSObjectTypeHandled() {
        return Account.SObjectType;
    }

    public List<SObject> getSObjectsForMerging(List<Id> objectIds) {
        return m_dataProvider.getSObjectsForEntityMerge(objectIds);
    }

    public LoanArchive.MergeResult mergeObjects(Id prospectId, Id coreId, Map<Id, SObject> mergeData) {
        
        List<SObject> saves = new List<SObject>();
        List<SObject> deletes = new List<SObject>();
        List<LoanArchive.MergeRequest> merges = new List<LoanArchive.MergeRequest>();        

        Account prospect = (Account) mergeData.get(prospectId);
        Account core =  (Account) mergeData.get(coreId);

        prospect.RecordTypeId = core.RecordTypeId;
        prospect.EB_Client_Name__c = core.EB_Client_Name__c;
        prospect.EB_Customer_Number__c = core.EB_Customer_Number__c;
        prospect.WM_Key__c = core.WM_Key__c;
        prospect.BillingStreet = core.BillingStreet;
        prospect.BillingCity = core.BillingCity;
        prospect.BillingState = core.BillingState;
        prospect.BillingPostalCode = core.BillingPostalCode;
        prospect.Phone = core.Phone;
        prospect.SSNTIN_Encrypted__c = core.SSNTIN_Encrypted__c;
        prospect.SSN_TIN_Has_Value__c = core.SSN_TIN_Has_Value__c;
        

        saves.addAll(reparentEntityInvolvements(prospect, core));       
        saves.addAll(reparentCollateralOwnerships(prospect, core));
        saves.addAll(reparentLoans(prospect, core));
        saves.addAll(reparentEbAccountRelationships(prospect, core));      
        saves.addAll(reparentEbCollateralRelationships(prospect, core));
        saves.addAll(reparentEbAccountOwnerships(prospect, core));
        saves.addAll(reparentEbCollateralOwnerships(prospect, core));      
        saves.add(prospect);


        deletes.addAll(buildDeletes(prospect.LLC_BI__Legal_Entities__r, core.LLC_BI__Legal_Entities__r));
        deletes.addAll(buildDeletes(prospect.LLC_BI__Account_Collateral__r, core.LLC_BI__Account_Collateral__r));

        Account prospectForMerge = buildEntityForMerge(prospect);
        Account coreForMerge = buildEntityForMerge(core);
        LoanArchive.MergeRequest request = new LoanArchive.MergeRequest();
        request.prospect = prospectForMerge;
        request.core = coreForMerge;
        merges.add(request);


        LoanArchive.DocumentKeyUpdate keyUpdate = new LoanArchive.DocumentKeyUpdate();
        keyUpdate.oldExternalKey = prospect.Id;
        keyUpdate.newExternalKey = prospect.EB_Customer_Number__c;

        return buildResult(saves, deletes, merges, keyUpdate);
    }

    private List<SObject> reparentLoans(Account prospect, Account core){
        return m_entityHandlerHelper.reparentLoans(prospect.Id, core.LLC_BI__Loans__r);
    }

    private List<SObject> reparentEbAccountRelationships(Account prospect, Account core){
        return m_entityHandlerHelper.reparentEbAccountRelationships(prospect.Id, core.EB_Account_Relationships__r);
    }

    private List<SObject> reparentEbCollateralRelationships(Account prospect, Account core){
        return m_entityHandlerHelper.reparentEbCollateralRelationships(prospect.Id, core.EB_Collateral_Client_Relationships__r);
    }

    private List<SObject> reparentEbAccountOwnerships(Account prospect, Account core){
        return m_entityHandlerHelper.reparentEbAccountOwnerships(prospect.Id, core.EB_Accounts__r);
    }

    private List<SObject> reparentEbCollateralOwnerships(Account prospect, Account core){
        return m_entityHandlerHelper.reparentEbCollateralOwnerships(prospect.Id, core.Collateral__r);
    }

    private List<SObject> reparentEntityInvolvements(Account prospect, Account core){
        return m_entityHandlerHelper.reparentEntityInvolvements(prospect.LLC_BI__Legal_Entities__r, core.LLC_BI__Legal_Entities__r);
    }

    private List<SObject> reparentCollateralOwnerships(Account prospect, Account core){
        return m_entityHandlerHelper.reparentCollateralOwnerships(prospect.LLC_BI__Account_Collateral__r, core.LLC_BI__Account_Collateral__r);       
    }

    private List<SObject> buildDeletes(List<LLC_BI__Legal_Entities__c> prospects, List<LLC_BI__Legal_Entities__c> cores){
        return m_entityHandlerHelper.createDeletesForEntityInvolvements(prospects,cores);
    }

    private List<SObject> buildDeletes(List<LLC_BI__Account_Collateral__c> prospects, List<LLC_BI__Account_Collateral__c> cores){
        return m_entityHandlerHelper.createDeletesForCollateralOwnerships(prospects,cores);
    }
    
    private LoanArchive.MergeResult buildResult(List<SObject> saves, List<SObject> deletes, List<LoanArchive.MergeRequest> merges, LoanArchive.DocumentKeyUpdate keyUpdate) {
        LoanArchive.MergeResult result = new LoanArchive.MergeResult();
        result.saveRecords = saves;
        result.deleteRecords = deletes;
        result.mergeRecords = merges;
        result.keyUpdates = new List<LoanArchive.DocumentKeyUpdate> { keyUpdate };
        
        return result;
    }

    private Account buildEntityForMerge(Account item){
        Account a = new Account(Id=item.Id);
        a.RecordTypeId = item.RecordTypeId;
        a.EB_Client_Name__c = item.EB_Client_Name__c;
        a.EB_Customer_Number__c = item.EB_Customer_Number__c;
        a.WM_Key__c = item.WM_Key__c;
        a.BillingStreet = item.BillingStreet;
        a.BillingCity = item.BillingCity;
        a.BillingState = item.BillingState;
        a.BillingPostalCode = item.BillingPostalCode;
        a.Phone = item.Phone;
        a.SSNTIN_Encrypted__c = item.SSNTIN_Encrypted__c;
        a.SSN_TIN_Has_Value__c = item.SSN_TIN_Has_Value__c;
        return a;
    }
}