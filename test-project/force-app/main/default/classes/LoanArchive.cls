public class LoanArchive {

    public interface IDataProvider {
        void save(List<SObject> objects);
        void remove(List<SObject> objects);
        void merges(List<MergeRequest> objects);
        Savepoint setSavepoint();
        void rollback(Savepoint sp);
        LLC_BI__Loan__c getLoanForVm(Id loanId);
        List<LLC_BI__Collateral__c> getSObjectsForCollateralMerge(List<Id> collateralIds);
        List<LLC_BI__Document_Placeholder__c> getCollateralDocumentsForMerge(List<Id> collateralIds);
        List<Account> getSObjectsForEntityMerge(List<Id> entityIds);
        List<SObject> getSObjectsForEbCollateralMerge(List<Id> collateralIds);
        List<SObject> getSObjectsForLoanMerge(List<Id> loanIds);
        EB_Account__c findEbAcctTwin(LLC_BI__Loan__c llcBiLoan);
        List<EB_Account__c> findEbAcctTwins(List<String> llcBiLoanLookupKeys);
    }

    public interface IHandler {
        SObjectType getSObjectTypeHandled();
        List<SObject> getSObjectsForMerging(List<Id> objectIds);
        MergeResult mergeObjects(Id prospectId, Id coreId, Map<Id, SObject> mergeData);
    }

    public interface IHandlerEntityHelper {
        List<SObject> reparentEntityInvolvements(List<LLC_BI__Legal_Entities__c> prospectInvolvements, List<LLC_BI__Legal_Entities__c> coreInvolvements);
        List<SObject> reparentEntityDocuments (Id prospectId,List<LLC_BI__AccountDocument__c> coreDocuments);
        List<SObject> reparentCollateralOwnerships(List<LLC_BI__Account_Collateral__c> prospectOwnerships, List<LLC_BI__Account_Collateral__c> coreOwnerships);
        List<SObject> reparentLoans(Id prospectId, List<LLC_BI__Loan__c> coreLoans);
        List<SObject> reparentEbAccountRelationships(Id prospectId, List<Eb_Account_Relationship__c> coreRels);
        List<SObject> reparentEbCollateralRelationships(Id prospectId, List<EB_Collateral_Client_Relationship__c> coreRels);
        List<SObject> reparentEbAccountOwnerships(Id prospectId, List<Eb_Account__c> coreEbAccounts);
        List<SObject> reparentEbCollateralOwnerships(Id prospectId, List<Eb_Collateral__c> coreCollaterals);
        List<SObject> createDeletesForEntityInvolvements(List<LLC_BI__Legal_Entities__c> prospectInvolvements, List<LLC_BI__Legal_Entities__c> coreInvolvements);
        List<SObject> createDeletesForCollateralOwnerships(List<LLC_BI__Account_Collateral__c> prospectOwnerships, List<LLC_BI__Account_Collateral__c> coreOwnerships);
    }
    
    public interface IHandlerCollateralHelper {
        List<SObject> reparentCollateralPledges(List<LLC_BI__Loan_Collateral2__c> prospects, List<LLC_BI__Loan_Collateral2__c> cores);
        List<SObject> reparentCollateralOwnerships(List<LLC_BI__Account_Collateral__c> prospects, List<LLC_BI__Account_Collateral__c> cores);
        List<SObject> reparentCollateralDocuments (Id prospectId,List<LLC_BI__Document_PlaceHolder__c> coreDocuments);
    }

    public interface IHandlerLoanHelper{
        Map<Id, Id> buildCachedMap(List<LLC_BI__Loan__c> llcBiLoans, List<EB_Account__c> ebAccounts);
    }

    public interface IMergeProcessor {
        List<MergeResult> process(List<SObjectMergeRequest> requests);
    }

    public interface IMergeProcessorHelper {
         Map<SObjectType, List<SObjectMergeRequest>> buildRequestMap(List<SObjectMergeRequest> requests);
         List<Id> buildIdList(List<SObjectMergeRequest> requests);
         Map<Id, SObject> buildSObjectMap(List<SObject> sobjects);
         List<MergeResult> mergeObjects(IHandler handler, List<SObjectMergeRequest> requests, Map<Id, SObject> mergeData);
    }

    public interface IProcessor {
        void process(Id loanId, List<SObjectMergeRequest> requests);
    }
    
    public interface IPresenter {
        FormVm buildFormVm(Id loanId);
        List<String> getValidationErrors(FormVm formVm);
        void save(FormVm formVm);
        void saveCollateral(FormVm formVm);
    }
    
    public interface IVmBuilder {
        List<MergeObjectVm> buildEntityMergeList(List<LLC_BI__Legal_Entities__c> involvements);
        List<MergeObjectVm> buildCollateralMergeList(List<LLC_BI__Loan_Collateral2__c> pledged);
        List<SelectOption> buildCoreEntityOptions(List<LLC_BI__Legal_Entities__c> involvements);
        List<SelectOption> buildCoreCollateralOptions(List<LLC_BI__Loan_Collateral2__c> pledged);
        List<MergeObjectVm> buildEntityCoreMergeList(List<SelectOption> entityOptions, List<LLC_BI__Legal_Entities__c> involvements);
        List<MergeObjectVm> buildCollateralCoreMergeList(List<SelectOption> collateralOptions, List<LLC_BI__Loan_Collateral2__c> pledged);
    }

    public interface IValidator {
        List<string> validateCoreAge(List<LoanArchive.MergeObjectVm> prospectVms, List<LoanArchive.MergeObjectVm> coreVms, String objType);
        List<String> validateCoreMerge(List<LoanArchive.MergeObjectVm> vms, String objType);
    }

    public class FormVm {
        public Id loanId;
        public List<MergeObjectVm> entityMergeList {get;set;}
        public List<MergeObjectVm> entityCoreMergeList {get;set;}
        public List<MergeObjectVm> collateralMergeList {get;set;}
        public List<MergeObjectVm> collateralCoreMergeList {get;set;}
        public List<SelectOption> coreEntityOptions {get;set;}
        public List<SelectOption> coreCollateralOptions {get;set;}
    }

    public class MergeObjectVm {
        public String description {get;set;}
        public Id objectId {get;set;}
        public String selectedOptionId {get;set;}
        public Datetime createdDate {get;set;}
    }
    
    public class MergeResult {
        public List<DocumentKeyUpdate> keyUpdates {get;set;}
        public List<SObject> saveRecords {get;set;}
        public List<SObject> deleteRecords {get;set;}
        public List<MergeRequest> mergeRecords {get;set;}
    }

    public class SObjectMergeRequest {
        public Id prospectObjectId {get;set;}
        public Id coreObjectId {get;set;}
    }

    public class MergeRequest {
        public SObject prospect {get;set;}
        public SObject core {get;set;}
    }

    public class DocumentKeyUpdate {
        public String oldExternalKey {get;set;}
        public String newExternalKey {get;set;}
    }

    public class SaveException extends Exception {}
    public class HandlerNotFoundException extends Exception {}
}