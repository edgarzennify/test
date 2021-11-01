@isTest
public class AgreementMock {
    public class ofIAgreementControllerDataProvider extends ApexMoq implements Agreements.IAgreementControllerDataProvider{
        public Agreement__c getAgreementByID(Id agreementId){
            return (Agreement__c)handleMethodInvocation('getAgreementByID', new List<Object>{agreementId});
        }
        public List<Agreement_Client_Relationships__c> getAgreementClientRelationshipsByAgreementId(Id agreementId){
            return (List<Agreement_Client_Relationships__c>)handleMethodInvocation('getAgreementClientRelationshipsByAgreementId', new List<Object>{agreementId});
        }
        public List<Agreement_Financial_Documents__c> getAgreementFinancialDocumentsByAgreementId(Id agreementId){
            return (List<Agreement_Financial_Documents__c>)handleMethodInvocation('getAgreementFinancialDocumentsByAgreementId', new List<Object>{agreementId});
        }
        public List<Account> getRelatedEntitiesWithClientRelationshipsByAgreementId(Id agreementId){
            return (List<Account>)handleMethodInvocation('getRelatedEntitiesWithClientRelationshipsByAgreementId', new List<Object>{agreementId});
        }
        public List<EB_Account_Relationship__c> getEbAccountRelationships(List<EB_Account__c> ebAccountsIncludedOnAgreement, Set<Id> entitiesIncludedOnAgreement){
            return (List<EB_Account_Relationship__c>)handleMethodInvocation('getEbAccountRelationships', new List<Object>{ebAccountsIncludedOnAgreement, entitiesIncludedOnAgreement});
        }
        public List<EB_Loan_App_Entity_Relationship__c> getLoanApplicationRelationships(List<EB_Loan_Application__c> loanAppsIncludedOnAgreement, Set<Id> entitiesIncludedOnAgreement){
            return (List<EB_Loan_App_Entity_Relationship__c>)handleMethodInvocation('getLoanApplicationRelationships', new List<Object>{loanAppsIncludedOnAgreement, entitiesIncludedOnAgreement});
        }
        public List<Agreement_EB_Account_Relationship__c> getIncludedEbAccountRelationshipsByAgreementId(Id agreementId){
            return (List<Agreement_EB_Account_Relationship__c>)handleMethodInvocation('getIncludedEbAccountRelationshipsByAgreementId', new List<Object>{agreementId});
        }
        public List<Agreement_LLC_BI_Loan_Relationship__c> getIncludedLlcBiLoanRelationshipsByAgreementId(Id agreementId){
            return (List<Agreement_LLC_BI_Loan_Relationship__c>)handleMethodInvocation('getIncludedLlcBiLoanCreditRequestRelationshipsByAgreementId', new List<Object>{agreementId});
        }
        public List<EB_Account__c> getExcludedEbAccounts(Set<Id> entitiesIncludedOnAgreement, List<EB_Account__c> ebAccountsIncludedOnAgreement){
            return (List<EB_Account__c>)handleMethodInvocation('getExcludedEbAccounts', new List<Object>{entitiesIncludedOnAgreement, ebAccountsIncludedOnAgreement});
        }
        public List<Agreement_Loan_Application_Relationship__c> getIncludedLoanAppRelationshipsByAgreementId(Id agreementId){
            return (List<Agreement_Loan_Application_Relationship__c>)handleMethodInvocation('getIncludedLoanAppRelationshipsByAgreementId', new List<Object>{agreementId});
        }
        public List<EB_Loan_Application__c> getExcludedLoanApps(Set<Id> entitiesIncludedOnAgreement, List<EB_Loan_Application__c> loanAppsIncludedOnAgreement){
            return (List<EB_Loan_Application__c>)handleMethodInvocation('getExcludedLoanApps', new List<Object>{entitiesIncludedOnAgreement, loanAppsIncludedOnAgreement});
        }
        public void save(SObject so){
            handleMethodInvocation('save', new List<Object>{so});
        }
        public Agreement_Loan_Application_Relationship__c findAgreementLoanApplicationRelationship(Id agreementId, Id loanAppId){
            return (Agreement_Loan_Application_Relationship__c)handleMethodInvocation('findAgreementLoanApplicationRelationship', new List<Object>{agreementId, loanAppId});
        }
        public Agreement_LLC_BI_Loan_Relationship__c findAgreementLlcBiLoanRelationship(Id agreementId, Id loanAppId){
            return (Agreement_LLC_BI_Loan_Relationship__c)handleMethodInvocation('findAgreementLlcBiLoanRelationship', new List<Object>{agreementId, loanAppId});
        }
        public void remove(SObject so){
            handleMethodInvocation('remove', new List<Object>{so});
        }
        public List<EB_Loan_App_Entity_Relationship__c> getEntityLoanAppRelationshipsByEntityIds(Set<Id> entityIds){
            return (List<EB_Loan_App_Entity_Relationship__c>)handleMethodInvocation('getEntityLoanAppRelationshipsByEntityIds', new List<Object>{entityIds});
        }
        public List<EB_Loan_App_Entity_Relationship__c> getEntityLoanAppRelationshipsByAppIds(Set<Id> appIds){
            return (List<EB_Loan_App_Entity_Relationship__c>)handleMethodInvocation('getEntityLoanAppRelationshipsByAppIds', new List<Object>{appIds});
        }
        public List<LLC_BI__Legal_Entities__c> getLlcBiEntityInvolvementsByEntityIds(Set<Id> entityIds){
            return (List<LLC_BI__Legal_Entities__c>)handleMethodInvocation('getLlcBiEntityInvolvementsByEntityIds', new List<Object>{entityIds});
        }
        public List<LLC_BI__Legal_Entities__c> getLlcBiEntityInvolvementsByAppIds(Set<Id> appIds){
            return (List<LLC_BI__Legal_Entities__c>)handleMethodInvocation('getLlcBiEntityInvolvementsByAppIds', new List<Object>{appIds});
        }
        public List<LLC_BI__LoanRenewal__c> getRenewalModParentLoanRelationships(Set<Id> loanIds){
            return (List<LLC_BI__LoanRenewal__c>)handleMethodInvocation('getRenewalModParentLoanRelationships', new List<Object>{loanIds});
        }
    }
    
    public class ofIDmLoanAppBuilder extends ApexMoq implements Agreements.IDmLoanAppBuilder {
        public List<DmLoanApp> build(List<Agreement_Loan_Application_Relationship__c> rels){
            return (List<DmLoanApp>)handleMethodInvocation('build',new List<Object>{rels});
        }
        public List<DmLoanApp> build(List<EB_Loan_Application__c> loanApps){
            return (List<DmLoanApp>)handleMethodInvocation('build',new List<Object>{loanApps});
        }
        public List<DmLoanApp> build(List<Agreement_LLC_BI_Loan_Relationship__c> llcBiLoanRels){
            return (List<DmLoanApp>)handleMethodInvocation('build',new List<Object>{llcBiLoanRels});
        }
        public Agreements.LoanAppEntityRelationship build(DmLoanApp loanApp, Account entity){
            return (Agreements.LoanAppEntityRelationship)handleMethodInvocation('build',new List<Object>{loanApp,entity});
        }
        public List<DmLoanApp> build(List<LLC_BI__Loan__c> loanApps){
            return (List<DmLoanApp>)handleMethodInvocation('build',new List<Object>{loanApps});
        }
    }
    
    public class ofILoanAppRepository extends ApexMoq implements Agreements.ILoanAppRepository {
        public List<DmLoanApp> getIncludedLoanApps(Id agreementId){
            return (List<DmLoanApp>)handleMethodInvocation('getIncludedLoanApps', new List<Object>{agreementId});
        }        
        public List<DmLoanApp> getExcludedLoanApps(Set<Id> includedEntitiesSet, List<DmLoanApp> includedLoanApps, List<EB_Account__c> IncludedEbAccounts){
            return (List<DmLoanApp>)handleMethodInvocation('getExcludedLoanApps', new List<Object>{includedEntitiesSet,includedLoanApps, IncludedEbAccounts});
        }        
        public List<Agreements.LoanAppEntityRelationship> getExcludedLoanApplicationRelationships(List<DmLoanApp> allLoanApps, Set<Id> includedEntitiesSet){
            return (List<Agreements.LoanAppEntityRelationship>)handleMethodInvocation('getExcludedLoanApplicationRelationships', new List<Object>{allLoanApps,includedEntitiesSet});
        }
        public void includeLoanApp(Id agreementId, Id loanAppId){
            handleMethodInvocation('includeLoanApp', new List<Object>{agreementId,loanAppId});
        }
        public void excludeLoanApp(Id agreementId, Id loanAppId){
            handleMethodInvocation('excludeLoanApp', new List<Object>{agreementId,loanAppId});
        }
    }

    public class ofILoanAppRepositoryHelper extends ApexMoq implements Agreements.ILoanAppRepositoryHelper {
        public List<EB_Loan_Application__c> getExcludedLoanApps(List<EB_Loan_App_Entity_Relationship__c> entityAppRels, Set<Id> includedLoanAppIds) {
            return (List<EB_Loan_Application__c>)handleMethodInvocation('getExcludedLoanApps', new List<Object>{entityAppRels, includedLoanAppIds});
        }
        public List<LLC_BI__Loan__c> getExcludedLlcBiLoans(List<LLC_BI__Legal_Entities__c> entityInvolvements, Set<Id> includedLoanAppIds){
            return (List<LLC_BI__Loan__c>)handleMethodInvocation('getExcludedLlcBiLoans', new List<Object>{entityInvolvements, includedLoanAppIds});
        }
        public List<LLC_BI__Loan__c> filterExcludedLlcBiLoans(List<LLC_BI__Loan__c> unfilteredExcludedLoans, List<EB_Account__c> IncludedEbAccounts){
            return (List<LLC_BI__Loan__c>)handleMethodInvocation('filterExcludedLlcBiLoans', new List<Object>{unfilteredExcludedLoans, IncludedEbAccounts});
        }
    }

    public class ofIAgreementApprovalInfo extends ApexMoq implements Agreements.IAgreementApprovalInfo{
        public Boolean wasIndependentlyApproved(Id agmtId){
            return (Boolean)handleMethodInvocation('wasIndependentlyApproved', new List<Object>{agmtId});
        }
        public Boolean hasApprovalInformation(Id agmtId){
            return (Boolean)handleMethodInvocation('hasApprovalInformation', new List<Object>{agmtId});
        }
        public EB_Loan_App_Minute__c getApprovalMinute(Id agmtId){
            return (EB_Loan_App_Minute__c)handleMethodInvocation('getApprovalMinute', new List<Object>{agmtId});
        }
    }   

    public class ofIAgreementLoanAppLink extends ApexMoq implements Agreements.IAgreementLoanAppLink{
        public void ConnectLoanAppToAgreement(Id loanAppId, Id agmtId){
            handleMethodInvocation('ConnectLoanAppToAgreement', new List<Object>{loanAppId, agmtId});
        }
        public void RemoveLoanAppFromAgreement(Id loanAppId, Id agmtId){
            handleMethodInvocation('RemoveLoanAppFromAgreement', new List<Object>{loanAppId, agmtId});
        }
        public void RemoveEbAccountFromAgreement(Id ebAccountId, Id agmtId){
            handleMethodInvocation('RemoveEbAccountFromAgreement', new List<Object>{ebAccountId, agmtId});
        }
        public List<Agreement__c> GetActiveAgreementsForEbAccount(Id ebAccountId){
            return (List<Agreement__c>)handleMethodInvocation('GetActiveAgreementsForEbAccount', new List<Object>{ebAccountId});
        }
    }

    public class ofIAgreementLoanAppLinkDataProvider extends ApexMoq implements Agreements.IAgreementLoanAppLinkDataProvider{
        public void SaveLoanAppToAgreementRelatedList(Id loanAppId, Id agmtId){
            handleMethodInvocation('SaveLoanAppToAgreementRelatedList', new List<Object>{loanAppId, agmtId});
        }
        public void DeleteLoanAppFromAgreementRelatedList(Id loanAppId, Id agmtId){
            handleMethodInvocation('DeleteLoanAppFromAgreementRelatedList', new List<Object>{loanAppId,agmtId});
        }
        public void DeleteEbAccountFromAgreementRelatedList(Id ebaccountId, Id agmtId){
            handleMethodInvocation('DeleteEbAccountFromAgreementRelatedList', new List<Object>{ebaccountId, agmtId});
        }
        public List<Agreement__c> GetListOfAgreementForEBAccount(Id ebAccountId){
            return (List<Agreement__c>)handleMethodInvocation('GetListOfAgreementForEBAccount', new List<Object>{ebAccountId});
        }
    }

    public class ofIAgreementPicker extends ApexMoq implements Agreements.IAgreementPicker{
        public List<EB_Loan_Application__c> GetLoanObjectForLoanAppId(Id LoanAppId){
            return (List<EB_Loan_Application__c>)handleMethodInvocation('GetLoanObjectForLoanAppId', new List<Object>{LoanAppId});
        }
        public void SaveAgreementLoanRel(Id AgreementId, Id LoanAppId){
            handleMethodInvocation('SaveAgreementLoanRel', new List<Object>{AgreementId, LoanAppId});
        }
        public void SaveAgreementLlcBiLoanRel(Id AgreementId, Id LlcBiLoanId){
            handleMethodInvocation('SaveAgreementLlcBiLoanRel', new List<Object>{AgreementId, LlcBiLoanId});
        }
        public List<Agreement__c> GetAgreementsForLoanApp(Id LoanAppId){
            return (List<Agreement__c>)handleMethodInvocation('GetAgreementsForLoanApp', new List<Object>{LoanAppId});
        }
    }

    public class ofIAgreementPickerDataProvider extends ApexMoq implements Agreements.IAgreementPickerDataProvider{
        public Agreement__c GetAgreementFromId(Id AgreementId){
            return (Agreement__c)handleMethodInvocation('GetAgreementFromId', new List<Object>{AgreementId});
        }
        public List<Eb_Loan_Application__c> GetLoanApplicationObjectForLoanAppId(Id LoanAppId){
            return (List<Eb_Loan_Application__c>)handleMethodInvocation('GetLoanApplicationObjectForLoanAppId', new List<Object>{LoanAppId});
        }
        public void SaveAgreementLoanAppRel(Id AgreementId, Id LoanAppId){
            handleMethodInvocation('SaveAgreementLoanRel', new List<Object>{AgreementId, LoanAppId});
        }
        public void SaveAgreementLlcBiLoanRel(Id AgreementId, Id LlcBiLoanId){
            handleMethodInvocation('SaveAgreementLlcBiLoanRel', new List<Object>{AgreementId, LlcBiLoanId});
        }
        public List<Agreement__c> GetAgreementsForLoanApp(Id LoanAppId){
            return (List<Agreement__c>)handleMethodInvocation('GetAgreementsForLoanApp', new List<Object>{LoanAppId});
        }
    }
    
    public class ofIAgreementStatusManager extends ApexMoq implements Agreements.IAgreementStatusManager{
        public void MakeActiveAdminBackdoor(Id agmtId){
            handleMethodInvocation('MakeActiveAdminBackdoor', new List<Object>{agmtId});
        }
        public void MakePendingAdminBackdoor(Id agmtId){
            handleMethodInvocation('MakePendingAdminBackdoor', new List<Object>{agmtId});
        }
        public void MakeArchiveAdminBackdoor(Id agmtId){
            handleMethodInvocation('MakeArchiveAdminBackdoor', new List<Object>{agmtid});
        }
        public void MakeNewAdminBackdoor(Id agmtId){
            handleMethodInvocation('MakeNewAdminBackdoor', new List<Object>{agmtId});
        }
        public void MakeActive(Id agmtId){
            handleMethodInvocation('MakeActive', new List<Object>{agmtId});
        }
        public void MakeArchive(Id agmtId){
            handleMethodInvocation('MakeArchive', new List<Object>{agmtId});
        }
        public void attachLoanAppAgreementsToAccount(Id appId, Id acctId){
            handleMethodInvocation('attachLoanAppAgreementsToAccount', new List<Object>{appId, acctId});
        }
        public void enterBackOfficeModification(Agreement__c agmt){
            handleMethodInvocation('enterBackOfficeModification', new List<Object>{agmt});
        }
        public void exitBackOfficeModification(Agreement__c agmt){
            handleMethodInvocation('exitBackOfficeModification', new List<Object>{agmt});
        }
        public Boolean isAgreementEditable(Agreement__c agmt, Id userId){
            return (Boolean)handleMethodInvocation('isAgreementEditable', new List<Object>{agmt, userId});
        }
        public Boolean hasLoanApps(Agreement__c agmt){
            return (Boolean)handleMethodInvocation('hasLoanApps', new List<Object>{agmt});
        }
        public RecordType getRecordType(Agreement__c agmt){
            return (RecordType)handleMethodInvocation('getRecordType', new List<Object>{agmt});
        }
    }

    public class ofIAgreementStatusManagerDataProvider extends ApexMoq implements Agreements.IAgreementStatusManagerDataProvider{
        public Agreement__c getAgreementByID(Id agreementId){
            return (Agreement__c)handleMethodInvocation('getAgreementByID', new List<Object>{agreementId});
        }
        public List<Agreement_Loan_Application_Relationship__c> getAgreementLoanAppRelationshipsByAgreementId(Id agreementId){
            return (List<Agreement_Loan_Application_Relationship__c>)handleMethodInvocation('getAgreementLoanAppRelationshipsByAgreementId', new List<Object>{agreementId});
        }
        public List<Agreement_Loan_Application_Relationship__c> getAgreementLoanApplicationRelationshipsByAppId(Id applicationId){
            return (List<Agreement_Loan_Application_Relationship__c>)handleMethodInvocation('getAgreementLoanApplicationRelationshipsByAppId', new List<Object>{applicationId});
        }
        public EB_Loan_App_Stage__c getLoanAppStageByName(String stageName){
            return (EB_Loan_App_Stage__c)handleMethodInvocation('getLoanAppStageByName', new List<Object>{stageName});
        }
        public List<Agreement_EB_Account_Relationship__c> getAgreementAccountRelationshipsByAccountId(Id ebAccountId){
            return (List<Agreement_EB_Account_Relationship__c>)handleMethodInvocation('getAgreementAccountRelationshipsByAccountId', new List<Object>{ebAccountId});
        }
        public void saveAgreement(Agreement__c agreement){
            handleMethodInvocation('saveAgreement', new List<Object>{agreement});
        }
        public void saveAccountRelationships(List<Agreement_EB_Account_Relationship__c> agreementAccountRelationships){
            handleMethodInvocation('saveAccountRelationships', new List<Object>{agreementAccountRelationships});
        }
    }
    
    public class IAgreementEntityManager extends ApexMoq implements Agreements.IAgreementEntityManager{
        public void copyPendingFinancialReportingRequirementsToActive(Id agreementId){
            handleMethodInvocation('copyPendingFinancialReportingRequirementsToActive', new List<Object>{agreementId});
        }
        public void copyActiveFinancialReportingRequirementsToArchive(Id agreementId){
            handleMethodInvocation('copyActiveFinancialReportingRequirementsToArchive', new List<Object>{agreementId});
        }
    }

    public class ofIAgreementEntityManagerDataProvider extends ApexMoq implements Agreements.IAgreementEntityManagerDataProvider{
        public List<Account> getRelatedEntitiesByAgreementId(Id agreementId){
            return (List<Account>)handleMethodInvocation('getRelatedEntitiesByAgreementId', new List<Object>{agreementId});
        }
        public List<Agreement_Client_Relationships__c> getAgreementClientRelationshipsByAgreementId(Id agreementId){
            return (List<Agreement_Client_Relationships__c>)handleMethodInvocation('getAgreementClientRelationshipsByAgreementId', new List<Object>{agreementId});
        }
        public void updateEntities(List<Account> entities){
            handleMethodInvocation('updateEntities', new List<Object>{entities});
        }
        public void updateAgreementClientRelationships(List<Agreement_Client_Relationships__c> agreementClients){
            handleMethodInvocation('updateAgreementClientRelationships', new List<Object>{agreementClients});
        }
    }
    
    public class ofIAgreementValidator extends ApexMoq implements Agreements.IAgreementValidator{
        public void Validate(Agreement__c agreement){
            handleMethodInvocation('Validate', new List<Object>{agreement});
        }
        public void ValidateAndSave(Agreement__c agreement){
            handleMethodInvocation('ValidateAndSave', new List<Object>{agreement});
        }
        public void ValidateAndSaveFromTrigger(Agreement__c agreement){
            handleMethodInvocation('ValidateAndSaveFromTrigger', new List<Object>{agreement});
        }
        public void DisableValidateFromTrigger(Boolean disable){
            handleMethodInvocation('DisableValidateFromTrigger', new List<Object>{disable});
        }
    }
    
    public class ofIAgreementValidatorDataProvider extends ApexMoq implements Agreements.IAgreementValidatorDataProvider{
        public void SaveAgreement(Agreement__c agreement){
            handleMethodInvocation('SaveAgreement', new List<Object>{agreement});
        }
        public Agreement__c loadAgreementById(Id agreementId){
            return (Agreement__c)handleMethodInvocation('loadAgreementById', new List<Object>{agreementId});
        }
        public List<Account> GetEntitiesTiedToARBorrowingBaseComponent(Id agreementId){
            return (List<Account>)handleMethodInvocation('GetEntitiesTiedToARBorrowingBaseComponent', new List<Object>{agreementId});
        }
        public List<Agreement_Client_Relationships__c> GetReportingRequirementsForEntityList(List<Account> entities, Id agreementId){
            return (List<Agreement_Client_Relationships__c>)handleMethodInvocation('GetReportingRequirementsForEntityList', new List<Object>{entities, agreementId});
        }
        public List<Agreement_Client_Relationships__c> GetAgreementEntityRels(Id agreementId){
            return (List<Agreement_Client_Relationships__c>)handleMethodInvocation('GetAgreementEntityRels', new List<Object>{agreementId});
        }
        public List<Account> GetEntitiesTiedToBorrowingBaseComponent(Id agreementId){
            return (List<Account>)handleMethodInvocation('GetEntitiesTiedToBorrowingBaseComponent', new List<Object>{agreementId});
        }
        public List<Agreement_Client_Relationships__c> GetOtherAgreementEntitiesRels(List<Account> entities, Id agreementId, Id sourceAgmtId){
            return (List<Agreement_Client_Relationships__c>)handleMethodInvocation('GetOtherAgreementEntitiesRels', new List<Object>{entities, agreementId, sourceAgmtId});
        }
        public List<EB_Loan_Application__c> getEbLoanApplicationsNotRelatedToCurrentAgreement(Id agreementId, Id sourceAgmtId){
            return (List<EB_Loan_Application__c>)handleMethodInvocation('getEbLoanApplicationsNotRelatedToCurrentAgreement', new List<Object>{agreementId, sourceAgmtId});
        }
        public List<Agreements.EBAccountWrapper> getEbAccountsNotRelatedToCurrentAgreement(Id agreementId, Id sourceAgmtId){
            return (List<Agreements.EBAccountWrapper>)handleMethodInvocation('getEbAccountsNotRelatedToCurrentAgreement', new List<Object>{agreementId, sourceAgmtId});
        }
        public List<Agreement_Loan_Application_Relationship__c> getLoanApplicationRelationshipsByAgreementId(Id agreementId){
            return (List<Agreement_Loan_Application_Relationship__c>)handleMethodInvocation('getLoanApplicationRelationshipsByAgreementId', new List<Object>{agreementId});
        }
    } 
    
    public class ofIClone_Agreement extends ApexMoq implements Agreements.IClone_Agreement{
        public Agreement__c Clone(Id origId){
            return (Agreement__c)handleMethodInvocation('Clone', new List<Object>{origId});
        }
        public Integer GetPendingAgreementCount(Agreement__c orig){
            return (Integer)handleMethodInvocation('GetPendingAgreementCount', new List<Object>{orig});
        }
        public Agreement__c GetAgreementById(Id agmtId){
            return (Agreement__c)handleMethodInvocation('GetAgreementById', new List<Object>{agmtId});
        }
        public Agreement__c CloneAndRemoveLoanApps(Id origId){
            return (Agreement__c)handleMethodInvocation('CloneAndRemoveLoanApps', new List<Object>{origId});
        }
    }
    
    public class ofIClone_AgreementDataProvider extends ApexMoq implements Agreements.IClone_AgreementDataProvider{
        public Agreement__c GetAgreementById(Id agreementId){
            return (Agreement__c)handleMethodInvocation('GetAgreementById', new List<Object>{agreementId});
        }
        public List<Agreement_Borrowing_Base_Relationship__c> GetAgreementBorrowingBaseRelationships(Id agreementId){
            return (List<Agreement_Borrowing_Base_Relationship__c>)handleMethodInvocation('GetAgreementBorrowingBaseRelationships', new List<Object>{agreementId});
        }
        public List<Agreement_Financial_Covenant__c> GetAgreementFinancialCovenants(Id agreementId){
            return (List<Agreement_Financial_Covenant__c>)handleMethodInvocation('GetAgreementFinancialCovenants', new List<Object>{agreementId});
        }
        public List<Agreement_Client_Relationships__c> GetAgreementClientRelationships(Id agreementId){
            return (List<Agreement_Client_Relationships__c>)handleMethodInvocation('GetAgreementClientRelationships', new List<Object>{agreementId});
        }
        public List<Agreement_EB_Account_Relationship__c> GetAgreementEBAccountRelationships(Id agreementId){
            return (List<Agreement_EB_Account_Relationship__c>)handleMethodInvocation('GetAgreementEBAccountRelationships', new List<Object>{agreementId});
        }
        public List<Agreement_Loan_Application_Relationship__c> GetAgreementLoanApplicationRelationships(Id agreementId){
            return (List<Agreement_Loan_Application_Relationship__c>)handleMethodInvocation('GetAgreementLoanApplicationRelationships', new List<Object>{agreementId});
        }
        public List<Agreement_Subordination__c> getAgreementSubordinationRelationships(Id agreementId){
            return (List<Agreement_Subordination__c>)handleMethodInvocation('getAgreementSubordinationRelationships', new List<Object>{agreementId});
        }
        public Integer GetPendingAgreementCountByName(String revisionName){
            return (Integer)handleMethodInvocation('GetPendingAgreementCountByName', new List<Object>{revisionName});
        }
        public void RemoveAgreementLoanApps(List<Agreement_Loan_Application_Relationship__c> relatedAgmtLoanApps, Agreement__c original){
            handleMethodInvocation('RemoveAgreementLoanApps', new List<Object>{relatedAgmtLoanApps, original});
        }
    }
    
    public class ofIClone_AgreementRelationships extends ApexMoq implements Agreements.IClone_AgreementRelationships{
        public Map<SObject,List<SObject>> Clone(List<Agreement_Borrowing_Base_Relationship__c> origList, Id newAgreementId){
            return (Map<SObject,List<SObject>>)handleMethodInvocation('Clone', new List<Object>{origList, newAgreementId});
        }
        public Map<SObject,List<SObject>> Clone(List<Agreement_Financial_Covenant__c> origList, Id newAgreementId){
            return (Map<SObject,List<SObject>>)handleMethodInvocation('Clone', new List<Object>{origList, newAgreementId});
        }
        public Map<SObject,List<SObject>> Clone(List<Agreement_Client_Relationships__c> origList, Id newAgreementId){
            return (Map<SObject,List<SObject>>)handleMethodInvocation('Clone', new List<Object>{origList, newAgreementId});
        }
        public List<Agreement_EB_Account_Relationship__c> Clone(List<Agreement_EB_Account_Relationship__c> origList, Id newAgreementId){
            return (List<Agreement_EB_Account_Relationship__c>)handleMethodInvocation('Clone', new List<Object>{origList, newAgreementId});
        }
        public List<Agreement_Loan_Application_Relationship__c> Clone(List<Agreement_Loan_Application_Relationship__c> origList, Id newAgreementId){
            return (List<Agreement_Loan_Application_Relationship__c>)handleMethodInvocation('Clone', new List<Object>{origList, newAgreementId});
        }
        public Map<SObject,List<SObject>> Clone(List<Agreement_Subordination__c> origList, Id newAgreementId){
            return (Map<SObject,List<SObject>>)handleMethodInvocation('Clone', new List<Object>{origList, newAgreementId});
        }
    }
    
    public class ofIAgreementBBaseComponentControllerDataProvider extends ApexMoq implements Agreements.IAgreementBBaseComponentControllerDataProvider{
        public void SaveComponent(Agreement_Borrowing_Base_Relationship__c component){
            handleMethodInvocation('SaveComponent', new List<Object>{component});
        }
        public void DeleteComponent(Agreement_Borrowing_Base_Relationship__c component){
            handleMethodInvocation('DeleteComponent', new List<Object>{component});
        }
        public void InsertComponentEntities(List<Agreement_Borrowing_Base_Entity_Rel__c> bbEntities){
            handleMethodInvocation('InsertComponentEntities', new List<Object>{bbEntities});
        }
        public void DeleteComponentEntities(List<Agreement_Borrowing_Base_Entity_Rel__c> bbEntities){
            handleMethodInvocation('DeleteComponentEntities', new List<Object>{bbEntities});
        }
        public List<Agreement_Borrowing_Base_Relationship__c> GetBorrowingBaseComponents(Id agreementId){
            return (List<Agreement_Borrowing_Base_Relationship__c>)handleMethodInvocation('GetBorrowingBaseComponents', new List<Object>{agreementId});
        }
        public Agreement_Borrowing_Base_Relationship__c GetBorrowingBaseComponent(Id componentId){
            return (Agreement_Borrowing_Base_Relationship__c)handleMethodInvocation('GetBorrowingBaseComponent', new List<Object>{componentId});
        }
        public Map<Id,Agreement_Client_Relationships__c> GetAgreementClientRelationships(Id agreementId){
            return (Map<Id,Agreement_Client_Relationships__c>)handleMethodInvocation('GetAgreementClientRelationships', new List<Object>{agreementId});
        }
        public List<Agreement_Borrowing_Base_Entity_Rel__c> CurrentComponentEntityRelationshipList(Id componentId){
            return (List<Agreement_Borrowing_Base_Entity_Rel__c>)handleMethodInvocation('CurrentComponentEntityRelationshipList', new List<Object>{componentId});
        }
    }

    public class ofIAgreementClientRelationshipEditDataProvider extends ApexMoq implements Agreements.IAgreementClientRelationshipEditDataProvider{
        public Agreement_Client_Relationships__c getAgreementClientRelationshipById(Id agreementClientRelationshipId){
            return (Agreement_Client_Relationships__c)handleMethodInvocation('getAgreementClientRelationshipById', new List<Object>{agreementClientRelationshipId});
        }
        public Agreement__c getAgreementById(Id agreementId){
            return (Agreement__c)handleMethodInvocation('getAgreementById', new List<Object>{agreementId});
        }
        public List<Agreement_Financial_Documents__c> getAgreementFinancialDocumentsFilteredByRecordType(id agreementclientrelationshipid, set<id> recordtypeidset){
            return (List<Agreement_Financial_Documents__c>)handleMethodInvocation('getAgreementFinancialDocumentsFilteredByRecordType', new List<Object>{agreementclientrelationshipid, recordtypeidset});
        }
        public List<Agreement_Financial_Documents__c> getAgreementFinancialDocuments(id agreementclientrelationshipid){
            return (List<Agreement_Financial_Documents__c>)handleMethodInvocation('getAgreementFinancialDocuments', new List<Object>{agreementclientrelationshipid});
        }
        public Account updateAccount(Account account){
            return (Account)handleMethodInvocation('updateAccount', new List<Object>{account});
        }
        public Agreement_Client_Relationships__c updateAgreementClientRelationships(Agreement_Client_Relationships__c agmtClientRel){
            return (Agreement_Client_Relationships__c)handleMethodInvocation('updateAgreementClientRelationships', new List<Object>{agmtClientRel});
        }
        public List<Agreement_Financial_Documents__c> saveAgreementFinancialDocuments(List<Agreement_Financial_Documents__c> agmtFinancialDocs){
            return (List<Agreement_Financial_Documents__c>)handleMethodInvocation('saveAgreementFinancialDocuments', new List<Object>{agmtFinancialDocs});
        }
        public void deleteAgreementFinancialDocuments(List<Agreement_Financial_Documents__c> agmtFinancialDocs){
            handleMethodInvocation('deleteAgreementFinancialDocuments', new List<Object>{agmtFinancialDocs});
        }
    }
}