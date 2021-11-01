//use this class as a "namespace" for all interfaces and wrapper classes in the Agreements ecosystem
public class Agreements{

    public interface IAgreementApprovalInfo{
        Boolean wasIndependentlyApproved(Id agmtId);
        Boolean hasApprovalInformation(Id agmtId);
        EB_Loan_App_Minute__c getApprovalMinute(Id agmtId);
    }
        
    public interface IAgreementLoanAppLink{
        void ConnectLoanAppToAgreement(Id loanAppId,Id agmtId );
        void RemoveLoanAppFromAgreement(Id loanAppId,Id agmtId);
        void RemoveEbAccountFromAgreement(Id ebAccountId,Id agmtId);
        List<Agreement__c> GetActiveAgreementsForEbAccount(Id ebAccountId);
    }
    
    public interface IAgreementLoanAppLinkDataProvider{
        void SaveLoanAppToAgreementRelatedList(Id loanAppId, Id agmtId);
        void DeleteLoanAppFromAgreementRelatedList(Id loanAppId, Id agmtId);
        void DeleteEbAccountFromAgreementRelatedList(Id ebaccountId, Id agmtId);
        List<Agreement__c> GetListOfAgreementForEBAccount(Id ebAccountId);
    }
    
    public interface IAgreementPicker{
        List<EB_Loan_Application__c> GetLoanObjectForLoanAppId(Id LoanAppId);
        void SaveAgreementLoanRel(Id AgreementId, Id LoanAppId);
        void SaveAgreementLlcBiLoanRel(Id AgreementId, Id LlcBiLoanId);
        List<Agreement__c> GetAgreementsForLoanApp(Id LoanAppId);
    }

    public interface IAgreementPickerDataProvider{
        Agreement__c GetAgreementFromId(Id AgreementId);
        List<Eb_Loan_Application__c> GetLoanApplicationObjectForLoanAppId(Id LoanAppId);
        void SaveAgreementLoanAppRel(Id AgreementId, Id LoanAppId);
        void SaveAgreementLlcBiLoanRel(Id AgreementId, Id LlcBiLoanId);
        List<Agreement__c> GetAgreementsForLoanApp(Id LoanAppId);
    }
    
    public interface IAgreementStatusManager{
        void MakeActiveAdminBackdoor(Id agmtId);
        void MakePendingAdminBackdoor(Id agmtId);
        void MakeArchiveAdminBackdoor(Id agmtId);
        void MakeNewAdminBackdoor(Id agmtId);
        void MakeActive(Id agmtId);
        void MakeArchive(Id agmtId);
        void attachLoanAppAgreementsToAccount(Id appId, Id acctId);
        void enterBackOfficeModification(Agreement__c agreement);
        void exitBackOfficeModification(Agreement__c agreement);
        Boolean isAgreementEditable(Agreement__c agreement, Id userId);
        Boolean hasLoanApps(Agreement__c agreement);
        RecordType getRecordType(Agreement__c agreement);
    }

    public interface IAgreementStatusManagerDataProvider{
        Agreement__c getAgreementByID(Id agreementId);
        List<Agreement_Loan_Application_Relationship__c> getAgreementLoanAppRelationshipsByAgreementId(Id agreementId);
        List<Agreement_Loan_Application_Relationship__c> getAgreementLoanApplicationRelationshipsByAppId(Id applicationId);
        EB_Loan_App_Stage__c getLoanAppStageByName(String stageName);
        List<Agreement_EB_Account_Relationship__c> getAgreementAccountRelationshipsByAccountId(Id ebAccountId);
        void saveAgreement(Agreement__c agreement);
        void saveAccountRelationships(List<Agreement_EB_Account_Relationship__c> agreementAccountRelationships);
    }
    
    public interface IAgreementEntityManager{
        void copyPendingFinancialReportingRequirementsToActive(Id agreementId);
        void copyActiveFinancialReportingRequirementsToArchive(Id agreementId);
    }

    public interface IAgreementEntityManagerDataProvider{
        List<Account> getRelatedEntitiesByAgreementId(Id agreementId);
        List<Agreement_Client_Relationships__c> getAgreementClientRelationshipsByAgreementId(Id agreementId);
        void updateEntities(List<Account> entities);
        void updateAgreementClientRelationships(List<Agreement_Client_Relationships__c> agreementClients);
    }
    
    public interface IAgreementValidator{
        void Validate(Agreement__c agreement);
        void ValidateAndSave(Agreement__c agreement);
        void ValidateAndSaveFromTrigger(Agreement__c agreement);
        void DisableValidateFromTrigger(Boolean disable);
    }
    
    public interface IAgreementValidatorDataProvider{
        void SaveAgreement(Agreement__c agreement);
        Agreement__c loadAgreementById(Id agreementId);
        List<Account> GetEntitiesTiedToARBorrowingBaseComponent(Id agreementId);
        List<Agreement_Client_Relationships__c> GetReportingRequirementsForEntityList(List<Account> entities, Id agreementId);
        List<Agreement_Client_Relationships__c> GetAgreementEntityRels(Id agreementId);
        List<Account> GetEntitiesTiedToBorrowingBaseComponent(Id agreementId);
        List<Agreement_Client_Relationships__c> GetOtherAgreementEntitiesRels(List<Account> entities, Id agreementId, Id sourceAgmtId);
        List<EB_Loan_Application__c> getEbLoanApplicationsNotRelatedToCurrentAgreement(Id agreementId, Id sourceAgmtId);
        List<EBAccountWrapper> getEbAccountsNotRelatedToCurrentAgreement(Id agreementId, Id sourceAgmtId);
        List<Agreement_Loan_Application_Relationship__c> getLoanApplicationRelationshipsByAgreementId(Id agreementId);
    } 
    
    public interface IClone_Agreement{
        Agreement__c Clone(Id origId);
        Integer GetPendingAgreementCount(Agreement__c orig);
        Agreement__c GetAgreementById(Id agmtId);
        Agreement__c CloneAndRemoveLoanApps(Id origId);
    }
    
    public interface IClone_AgreementDataProvider{
        Agreement__c GetAgreementById(Id agreementId);
        List<Agreement_Borrowing_Base_Relationship__c> GetAgreementBorrowingBaseRelationships(Id agreementId);
        List<Agreement_Financial_Covenant__c> GetAgreementFinancialCovenants(Id agreementId);
        List<Agreement_Client_Relationships__c> GetAgreementClientRelationships(Id agreementId);
        List<Agreement_EB_Account_Relationship__c> GetAgreementEBAccountRelationships(Id agreementId);
        List<Agreement_Loan_Application_Relationship__c> GetAgreementLoanApplicationRelationships(Id agreementId);
        List<Agreement_Subordination__c> getAgreementSubordinationRelationships(Id agreementId);
        Integer GetPendingAgreementCountByName(String revisionName);
        void RemoveAgreementLoanApps(List<Agreement_Loan_Application_Relationship__c> relatedAgmtLoanApps, Agreement__c original);
    }
    
    public interface IClone_AgreementRelationships{
        Map<SObject,List<SObject>> Clone(List<Agreement_Borrowing_Base_Relationship__c> origList, Id newAgreementId);
        Map<SObject,List<SObject>> Clone(List<Agreement_Financial_Covenant__c> origList, Id newAgreementId);
        Map<SObject,List<SObject>> Clone(List<Agreement_Client_Relationships__c> origList, Id newAgreementId);
        List<Agreement_EB_Account_Relationship__c> Clone(List<Agreement_EB_Account_Relationship__c> origList, Id newAgreementId);
        List<Agreement_Loan_Application_Relationship__c> Clone(List<Agreement_Loan_Application_Relationship__c> origList, Id newAgreementId);
        Map<SObject,List<SObject>> Clone(List<Agreement_Subordination__c> origList, Id newAgreementId);
    }
    
    public interface IAgreementBBaseComponentControllerDataProvider{
        void SaveComponent(Agreement_Borrowing_Base_Relationship__c component);
        void DeleteComponent(Agreement_Borrowing_Base_Relationship__c component);
        void InsertComponentEntities(List<Agreement_Borrowing_Base_Entity_Rel__c> bbEntities);
        void DeleteComponentEntities(List<Agreement_Borrowing_Base_Entity_Rel__c> bbEntities);
        List<Agreement_Borrowing_Base_Relationship__c> GetBorrowingBaseComponents(Id agreementId);
        Agreement_Borrowing_Base_Relationship__c GetBorrowingBaseComponent(Id componentId);
        Map<Id,Agreement_Client_Relationships__c> GetAgreementClientRelationships(Id agreementId);
        List<Agreement_Borrowing_Base_Entity_Rel__c> CurrentComponentEntityRelationshipList(Id componentId);
    }

    public interface IAgreementClientRelationshipEditDataProvider{
        Agreement_Client_Relationships__c getAgreementClientRelationshipById(Id agreementClientRelationshipId);
        Agreement__c getAgreementById(Id agreementId);
        List<Agreement_Financial_Documents__c> getAgreementFinancialDocumentsFilteredByRecordType(id agreementclientrelationshipid, set<id> recordtypeidset);
        List<Agreement_Financial_Documents__c> getAgreementFinancialDocuments(id agreementclientrelationshipid);
        Account updateAccount(Account account);
        Agreement_Client_Relationships__c updateAgreementClientRelationships(Agreement_Client_Relationships__c agmtClientRel);
        List<Agreement_Financial_Documents__c> saveAgreementFinancialDocuments(List<Agreement_Financial_Documents__c> agmtFinancialDocs);
        void deleteAgreementFinancialDocuments(List<Agreement_Financial_Documents__c> agmtFinancialDocs);
    }

    public interface IAgreementControllerDataProvider{
        Agreement__c getAgreementByID(Id agreementId);
        List<Agreement_Client_Relationships__c> getAgreementClientRelationshipsByAgreementId(Id agreementId);
        List<Agreement_Financial_Documents__c> getAgreementFinancialDocumentsByAgreementId(Id agreementId);
        List<Account> getRelatedEntitiesWithClientRelationshipsByAgreementId(Id agreementId);
        List<EB_Account_Relationship__c> getEbAccountRelationships(List<EB_Account__c> ebAccountsIncludedOnAgreement, Set<Id> entitiesIncludedOnAgreement);
        List<EB_Loan_App_Entity_Relationship__c> getLoanApplicationRelationships(List<EB_Loan_Application__c> loanAppsIncludedOnAgreement, Set<Id> entitiesIncludedOnAgreement);
        List<Agreement_EB_Account_Relationship__c> getIncludedEbAccountRelationshipsByAgreementId(Id agreementId);
        List<Agreement_LLC_BI_Loan_Relationship__c> getIncludedLlcBiLoanRelationshipsByAgreementId(Id agreementId);
        List<EB_Account__c> getExcludedEbAccounts(Set<Id> entitiesIncludedOnAgreement, List<EB_Account__c> ebAccountsIncludedOnAgreement);
        List<Agreement_Loan_Application_Relationship__c> getIncludedLoanAppRelationshipsByAgreementId(Id agreementId);
        List<EB_Loan_Application__c> getExcludedLoanApps(Set<Id> entitiesIncludedOnAgreement, List<EB_Loan_Application__c> loanAppsIncludedOnAgreement);
        void save(SObject so);
        Agreement_Loan_Application_Relationship__c findAgreementLoanApplicationRelationship(Id agreementId, Id loanAppId);
        Agreement_LLC_BI_Loan_Relationship__c findAgreementLlcBiLoanRelationship(Id agreementId, Id loanAppId);
        void remove(SObject so);
        List<EB_Loan_App_Entity_Relationship__c> getEntityLoanAppRelationshipsByEntityIds(Set<Id> entityIds);
        List<EB_Loan_App_Entity_Relationship__c> getEntityLoanAppRelationshipsByAppIds(Set<Id> appIds);
        List<LLC_BI__Legal_Entities__c> getLlcBiEntityInvolvementsByEntityIds(Set<Id> entityIds);
        List<LLC_BI__Legal_Entities__c> getLlcBiEntityInvolvementsByAppIds(Set<Id> appIds);
        List<LLC_BI__LoanRenewal__c> getRenewalModParentLoanRelationships(Set<Id> loanIds);
    }

    public interface ILoanAppRepository {
        List<DmLoanApp> getIncludedLoanApps(Id agreementId);
        List<DmLoanApp> getExcludedLoanApps(Set<Id> includedEntitiesSet, List<DmLoanApp> includedLoanApps, List<EB_Account__c> IncludedEbAccounts);
        List<LoanAppEntityRelationship> getExcludedLoanApplicationRelationships(List<DmLoanApp> allLoanApps, Set<Id> includedEntitiesSet);
        void includeLoanApp(Id agreementId, Id loanAppId);
        void excludeLoanApp(Id agreementId, Id loanAppId);
    }

    public interface ILoanAppRepositoryHelper {
        List<EB_Loan_Application__c> getExcludedLoanApps(List<EB_Loan_App_Entity_Relationship__c> entityAppRels, Set<Id> includedLoanAppIds);
        List<LLC_BI__Loan__c> getExcludedLlcBiLoans(List<LLC_BI__Legal_Entities__c> entityInvolvements, Set<Id> includedLoanAppIds);
        List<LLC_BI__Loan__c> filterExcludedLlcBiLoans(List<LLC_BI__Loan__c> unfilteredExcludedLoans, List<EB_Account__c> IncludedEbAccounts);
    }

    public interface IDmLoanAppBuilder {
        List<DmLoanApp> build(List<Agreement_Loan_Application_Relationship__c> rels);
        List<DmLoanApp> build(List<EB_Loan_Application__c> loanApps);
        List<DmLoanApp> build(List<Agreement_LLC_BI_Loan_Relationship__c> loanApps);
        LoanAppEntityRelationship build(DmLoanApp loanApp, Account entity);
        List<DmLoanApp> build(List<LLC_BI__Loan__c> loanApps);
    }

    public class EBAccountWrapper{
        public EB_Account__c account {get;private set;}
        public List<Agreement__c> relatedAgreements {get;private set;}
        public EBAccountWrapper(EB_Account__c acct){
            account = acct;
            relatedAgreements = new List<Agreement__c>();
        }
        public String Name{
            get{
               return account.Name;
            }
        }
    }
 
    public class LoanAppEntityRelationship {
        public DmLoanApp loanApp {get;set;}
        public Account entity {get;set;}
    }
}