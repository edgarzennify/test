@isTest
public class LoanArchiveMock {
    public class ofIDataProvider extends ApexMoq implements LoanArchive.IDataProvider { 
        public void save(List<SObject> objects){
            handleMethodInvocation('save', new List<Object>{objects});
        }
        public void remove(List<SObject> objects){
            handleMethodInvocation('remove', new List<Object>{objects});
        }
        public void merges(List<LoanArchive.MergeRequest> objects){
            handleMethodInvocation('merges', new List<Object>{objects});
        }
        public Savepoint setSavepoint(){
            return (Savepoint)handleMethodInvocation('setSavepoint');
        }
        public void rollback(Savepoint sp){
            handleMethodInvocation('rollback', new List<Object>{sp});
        }
        public LLC_BI__Loan__c getLoanForVm(Id loanId){
            return (LLC_BI__Loan__c)handleMethodInvocation('getLoanForVm', new List<Object>{loanId});
        }
        public List<LLC_BI__Collateral__c> getSObjectsForCollateralMerge(List<Id> collateralIds) {
            return (List<LLC_BI__Collateral__c>)handleMethodInvocation('getCollateralForMerge', new List<Object>{collateralIds});
        }
        public List<Account> getSObjectsForEntityMerge(List<Id> entityIds){
            return (List<Account>)handleMethodInvocation('getEntitiesForMerge', new List<Object>{entityIds});
        }
        public List<SObject> getSObjectsForEbCollateralMerge(List<Id> collateralIds){
            return (List<SObject>)handleMethodInvocation('getSObjectsForEbCollateralMerge', new List<Object>{collateralIds});
        }
        public List<LLC_BI__Document_Placeholder__c> getCollateralDocumentsForMerge(List<Id> collateralIds){
            return (List<LLC_BI__Document_Placeholder__c>)handleMethodInvocation('getCollateralDocumentsForMerge', new List<Object>{collateralIds});
        }
        public List<SObject> getSObjectsForLoanMerge(List<Id> loanIds){
            return (List<SObject>)handleMethodInvocation('getSObjectsForLoanMerge', new List<Object>{loanIds});
        }
        public EB_Account__c findEbAcctTwin(LLC_BI__Loan__c llcBiLoan){
            return (EB_Account__c)handleMethodInvocation('findEbAcctTwin', new List<Object>{llcBiLoan});
        }
        public List<EB_Account__c> findEbAcctTwins(List<String> llcBiLoanLookupKeys){
            return (List<EB_Account__c>)handleMethodInvocation('findEbAcctTwins', new List<Object>{llcBiLoanLookupKeys});
        }
    } 
    public class ofIHandler extends ApexMoq implements LoanArchive.IHandler {
        public SObjectType getSObjectTypeHandled(){
            return (SObjectType)handleMethodInvocation('getSObjectTypeHandled');
        }
        public List<SObject> getSObjectsForMerging(List<Id> objectIds) {
            return (List<SObject>)handleMethodInvocation('getSObjectsForMerging', new List<Object>{objectIds});
        }
        public LoanArchive.MergeResult mergeObjects(Id prospectId, Id coreId, Map<Id,SObject> mergeData) {
            return (LoanArchive.MergeResult)handleMethodInvocation('mergeObjects', new List<Object>{prospectId,coreId,mergeData});
        }
    }
    public class ofIHandlerEntityHelper extends ApexMoq implements LoanArchive.IHandlerEntityHelper {
        public List<SObject> reparentEntityInvolvements(List<LLC_BI__Legal_Entities__c> prospectInvolvements, List<LLC_BI__Legal_Entities__c> coreInvolvements) {
            return (List<SObject>)handleMethodInvocation('reparentEntityInvolvements', new List<Object>{prospectInvolvements, coreInvolvements});
        }
        public List<SObject> reparentEntityDocuments (Id prospectId,List<LLC_BI__AccountDocument__c> coreDocuments){
             return (List<SObject>)handleMethodInvocation('reparentEntityDocuments', new List<Object>{prospectId, coreDocuments});
        }        
        public List<SObject> reparentCollateralOwnerships(List<LLC_BI__Account_Collateral__c> prospectOwnerships, List<LLC_BI__Account_Collateral__c> coreOwnerships) {
            return (List<SObject>)handleMethodInvocation('reparentCollateralOwnerships', new List<Object>{prospectOwnerships, coreOwnerships});
        }
        public List<SObject> reparentLoans(Id prospectId, List<LLC_BI__Loan__c> coreLoans) {
            return (List<SObject>)handleMethodInvocation('reparentLoans', new List<Object>{prospectId, coreLoans});
        }
        public List<SObject> reparentEbAccountRelationships(Id prospectId, List<Eb_Account_Relationship__c> coreRels) {
            return (List<SObject>)handleMethodInvocation('reparentEbAccountRelationships', new List<Object>{prospectId, coreRels});
        }
        public List<SObject> reparentEbCollateralRelationships(Id prospectId, List<EB_Collateral_Client_Relationship__c> coreRels) {
            return (List<SObject>)handleMethodInvocation('reparentEbCollateralRelationships', new List<Object>{prospectId, coreRels});
        }
        public List<SObject> reparentEbAccountOwnerships(Id prospectId, List<Eb_Account__c> coreEbAccounts) {
            return (List<SObject>)handleMethodInvocation('reparentEbAccountOwnerships', new List<Object>{prospectId, coreEbAccounts});
        }
        public  List<SObject> reparentEbCollateralOwnerships(Id prospectId, List<Eb_Collateral__c> coreCollaterals) {
            return (List<SObject>)handleMethodInvocation('reparentEbCollateralOwnerships', new List<Object>{prospectId, coreCollaterals});
        }
        public List<SObject> createDeletesForEntityInvolvements(List<LLC_BI__Legal_Entities__c> prospectInvolvements, List<LLC_BI__Legal_Entities__c> coreInvolvements){
            return (List<SObject>)handleMethodInvocation('createDeletesForEntityInvolvements', new List<Object>{prospectInvolvements, coreInvolvements});
        }
        public List<SObject> createDeletesForCollateralOwnerships(List<LLC_BI__Account_Collateral__c> prospectOwnerships, List<LLC_BI__Account_Collateral__c> coreOwnerships){
            return (List<SObject>)handleMethodInvocation('createDeletesForCollateralOwnerships', new List<Object>{prospectOwnerships, coreOwnerships});
        }
    }
    public class ofIHandlerCollateralHelper extends ApexMoq implements LoanArchive.IHandlerCollateralHelper {
        public List<SObject> reparentCollateralPledges(List<LLC_BI__Loan_Collateral2__c> prospects, List<LLC_BI__Loan_Collateral2__c> cores) {
            return (List<SObject>)handleMethodInvocation('reparentCollateralPledges', new List<Object>{prospects, cores});
        }
        public List<SObject> reparentCollateralOwnerships(List<LLC_BI__Account_Collateral__c> prospects, List<LLC_BI__Account_Collateral__c> cores) {
            return (List<SObject>)handleMethodInvocation('reparentCollateralOwnerships', new List<Object>{prospects, cores});
        }
        public List<SObject> reparentCollateralDocuments (Id prospectId,List<LLC_BI__Document_PlaceHolder__c> coreDocuments){
            return (List<SObject>)handleMethodInvocation('reparentCollateralDocuments', new List<Object>{prospectId, coreDocuments});
        }
    }
    public class ofIHandlerLoanHelper extends ApexMoq implements LoanArchive.IHandlerLoanHelper {
        public Map<Id, Id> buildCachedMap(List<LLC_BI__Loan__c> llcBiLoans, List<EB_Account__c> ebAccounts) {
            return (Map<Id, Id>)handleMethodInvocation('buildCachedMap', new List<Object>{llcBiLoans, ebAccounts});
        }
    }
    public class ofIMergeProcessor extends ApexMoq implements LoanArchive.IMergeProcessor {
        public List<LoanArchive.MergeResult> process(List<LoanArchive.SObjectMergeRequest> requests){
            return (List<LoanArchive.MergeResult>)handleMethodInvocation('process', new List<Object>{requests});
        }
    }
    public class ofIMergeProcessorHelper extends ApexMoq implements LoanArchive.IMergeProcessorHelper {
        public Map<SObjectType, List<LoanArchive.SObjectMergeRequest>> buildRequestMap(List<LoanArchive.SObjectMergeRequest> requests){
            return(Map<SObjectType, List<LoanArchive.SObjectMergeRequest>>)handleMethodInvocation('buildRequestMap', new List<Object>{requests});
        }
        public List<Id> buildIdList(List<LoanArchive.SObjectMergeRequest> requests){
            return(List<Id>)handleMethodInvocation('buildIdList', new List<Object>{requests});
        }
        public Map<Id, SObject> buildSObjectMap(List<SObject> sobjects){
            return(Map<Id, SObject>)handleMethodInvocation('buildSObjectMap', new List<Object>{sobjects});
        }
        public List<LoanArchive.MergeResult> mergeObjects(LoanArchive.IHandler handler, List<LoanArchive.SObjectMergeRequest> requests, Map<Id, SObject> mergeData){
            return( List<LoanArchive.MergeResult>)handleMethodInvocation('mergeObjects', new List<Object>{handler,requests,mergeData});
        }
    }
    public class ofIPresenter extends ApexMoq implements LoanArchive.IPresenter {
        public LoanArchive.FormVm buildFormVm(Id loanId){
            return (LoanArchive.FormVm)handleMethodInvocation('buildFormVm', new List<Object>{loanId});
        }
        public void save(LoanArchive.FormVm formVm){
            handleMethodInvocation('save', new List<Object>{formVm});
        }
        public void saveCollateral(LoanArchive.FormVm vm){
            handleMethodInvocation('saveCollateral', new List<Object>{vm}); 
        }
        public List<String> getValidationErrors(LoanArchive.FormVm vm) {
            return (List<String>)handleMethodInvocation('getValidationErrors', new List<Object>{vm});
        }       
    }  
    public class ofIProcessor extends ApexMoq implements LoanArchive.IProcessor {
        public void process(Id loanId, List<LoanArchive.SObjectMergeRequest> requests){
            handleMethodInvocation('process', new List<Object>{loanId,requests});
        }   
    }
    public class ofIVmBuilder extends ApexMoq implements LoanArchive.IVmBuilder {
        public List<LoanArchive.MergeObjectVm> buildEntityMergeList(List<LLC_BI__Legal_Entities__c> involvements){
            return (List<LoanArchive.MergeObjectVm>)handleMethodInvocation('buildEntityMergeList', new List<Object>{involvements});
        }
        public List<LoanArchive.MergeObjectVm> buildCollateralMergeList(List<LLC_BI__Loan_Collateral2__c> pledged){
            return (List<LoanArchive.MergeObjectVm>)handleMethodInvocation('buildCollateralMergeList', new List<Object>{pledged});
        }
        public List<SelectOption> buildCoreEntityOptions(List<LLC_BI__Legal_Entities__c> involvements){
            return (List<SelectOption>)handleMethodInvocation('buildCoreEntityOptions', new List<Object>{involvements});
        }
        public List<SelectOption> buildCoreCollateralOptions(List<LLC_BI__Loan_Collateral2__c> pledged){
            return (List<SelectOption>)handleMethodInvocation('buildCoreCollateralOptions', new List<Object>{pledged});
        }
        public List<LoanArchive.MergeObjectVm> buildEntityCoreMergeList(List<SelectOption> entityOptions, List<LLC_BI__Legal_Entities__c> involvements){
            return (List<LoanArchive.MergeObjectVm>)handleMethodInvocation('buildEntityCoreMergeList', new List<Object>{entityOptions, involvements});
        }
        public List<LoanArchive.MergeObjectVm> buildCollateralCoreMergeList(List<SelectOption> collateralOptions, List<LLC_BI__Loan_Collateral2__c> pledged){
            return (List<LoanArchive.MergeObjectVm>)handleMethodInvocation('buildCollateralCoreMergeList', new List<Object>{collateralOptions, pledged});
        }
    } 
    public class ofIValidator extends ApexMoq implements LoanArchive.IValidator {
        public List<string> validateCoreAge(List<LoanArchive.MergeObjectVm> prospectVms, List<LoanArchive.MergeObjectVm> coreVms, String objType){
            return (List<String>)handleMethodInvocation('validateCoreAge', new List<Object>{prospectVms, coreVms ,objType});
        }
        public List<String> validateCoreMerge(List<LoanArchive.MergeObjectVm> vms, String objType) {
            return (List<String>)handleMethodInvocation('validateCoreMerge', new List<Object>{vms, objType});
        }
    }
}