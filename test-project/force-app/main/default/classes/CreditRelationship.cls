public class CreditRelationship {

    public interface ICreditRelationshipService
    {
        CreditRelationship.CreditRelationshipVm getCreditRelationshipViewModel(String creditRelationshipId);
        void addArchivedReport(String creditRelationshipId);
        void addRelatedEntity(CreditRelationship.RelatedEntitySm sm);
        void addExcludedAccount(CreditRelationship.ExcludedAccountSm sm);
        void addNote(CreditRelationship.NoteSm sm);
        void deleteRelatedEntity(String recordId);
        void deleteExcludedEbAccount(String recordId);
        void deleteNote(String recordId);
        String getReportUrl(String creditRelationshipId);
        Boolean hasPermissionAdmin();
        Boolean hasPermissionToEdit();
        Boolean hasPermissionToView();
    }
    
    public interface ICreditRelationshipReportManager
    {
        void generateReportOutput(String archivedReportId, Boolean isOreo);
        Integer getReportIdForUrl(Boolean isOreo);
        String getArchiveReportName(Boolean isOreo);
        CreditRelationship.ArchivedReportSm buildArchivedReportSm(DmArchivedReport dm);
    }
    
    public interface ICreditRelationshipVmBuilder
    {
        List<CreditRelationship.ArchivedReportVm> buildArchivedReportVms(List<DmArchivedReport> dms);
        List<CreditRelationship.RelatedEntityVm> buildRelatedEntityVms(List<DmCreditRelationshipRelatedEntity> dms);
        List<CreditRelationship.RelatedAccountVm> buildRelatedAccountVms(List<DmEbAccount> dms);
        List<CreditRelationship.ExcludedAccountVm> buildExcludedAccountVms(List<DmCreditRelationshipExcludedAccount> dms);
        List<CreditRelationship.NoteVm> buildNoteVms(List<DmCreditRelationshipNote> dms);
        List<CreditRelationship.PossibleRelatedEntityVm> buildPossibleRelatedEntityVms(List<DmEntity> dms);
    }
    
    public interface IDataModelBuilder
    {
        DmCreditRelationship buildDmCreditRelationship(Credit_Relationship__c pm);
        List<DmEbAccount> buildDmEbAccounts(List<EB_Account__c> pms);
        List<DmCreditRelationshipExcludedAccount> buildDmCreditRelationshipExcludedAccounts(List<Credit_Relationship_Excluded_Account__c> pms);
        List<DmArchivedReport> buildDmArchivedReports(List<Archived_Report__c> pms);
        List<DmCreditRelationshipRelatedEntity> buildDmCreditRelationshipRelatedEntities(List<Credit_Relationship_Related_Client__c> pms);
        List<DmCreditRelationshipNote> buildDmCreditRelationshipNotes(List<Credit_Relationship_Note__c> pms);
        List<DmEntity> buildDmEntities(List<Account> pms);
    }

    public interface ICreditRelationshipData
    {
        DmCreditRelationship getCreditRelationshipById(String creditRelationshipId);
        List<DmEbAccount> getRelatedAccounts(List<DmCreditRelationshipRelatedEntity> relatedEntities);
        List<DmEntity> getPossibleRelatedEntities(List<DmEbAccount> relatedAccounts, List<DmCreditRelationshipRelatedEntity> relatedEntities);

        String addArchivedReport(CreditRelationship.ArchivedReportSm sm);
        void addRelatedEntity(CreditRelationship.RelatedEntitySm sm);
        void addExcludedAccount(CreditRelationship.ExcludedAccountSm sm);
        void addNote(CreditRelationship.NoteSm sm);
        void lockNotesById(List<String> ids); 

        void deleteRelatedEntity(String recordId);
        void deleteExcludedEbAccount(String recordId);
        void deleteNote(String recordId);
    }

    public class CreditRelationshipVm
    {
        public List<ArchivedReportVm> archivedReports {get;set;}
        public List<RelatedEntityVm> relatedEntities {get;set;}
        public List<PossibleRelatedEntityVm> possibleRelatedEntities {get;set;}
        public List<RelatedAccountVm> relatedAccounts {get;set;}
        public List<ExcludedAccountVm> excludedAccounts {get;set;}
        public List<NoteVm> minutes {get;set;}
        public List<NoteVm> situationAnalysis {get;set;}
    }

    public class ArchivedReportVm
    {
        public String id {get;set;}
        public String url {get;set;}
        public String name {get;set;}
        public Datetime createdDate {get;set;}
        public String createdBy {get;set;}
    }

    public class RelatedEntityVm
    {
        public String id {get;set;}
        public String entityId {get;set;}
        public String name {get;set;}
        public String street {get;set;}
        public String city {get;set;}
        public String state {get;set;}
        public String zip {get;set;}
    }

    public class RelatedAccountVm
    {
        public String id {get;set;}
        public String accountNumber {get;set;}
        public String accountTitle {get;set;}
        public String riskRating {get;set;}
        public Decimal contributionMargin {get;set;}
        public String primaryOwner {get;set;}
        public Decimal application {get;set;}
        public Decimal currentCommitment {get;set;}
        public Decimal unadvancedLoanAmount {get;set;}
        public Decimal currentBalance {get;set;}
        public String status {get;set;}
    }

    public class ExcludedAccountVm
    {
        public String id {get;set;}
        public String accountId {get;set;}
        public String accountNumber {get;set;}
        public String accountTitle {get;set;}
        public String riskRating {get;set;}
        public Decimal contributionMargin {get;set;}
        public String primaryOwner {get;set;}
    }

    public class NoteVm
    {
        public String id {get;set;}
        public String name {get;set;}
        public String createdBy {get;set;}
        public String diary {get;set;}
        public Boolean locked {get;set;}
    }

    public class PossibleRelatedEntityVm
    {
        public String id {get;set;}
        public String name {get;set;}
        public String street {get;set;}
        public String city {get;set;}
        public String state {get;set;}
        public String zip {get;set;}
    }
    
    public class ArchivedReportSm
    {
        public String name {get;set;}
        public String creditRelationshipId {get;set;}
    }
    
    public class RelatedEntitySm
    {
        public String entityId {get;set;}
        public String creditRelationshipId {get;set;}
    }
    
    public class ExcludedAccountSm
    {
        public String creditRelationshipId {get;set;}
        public String accountId {get;set;}
    }

    public enum NoteType
    {
        minute,
        situationAnalysis
    }

    public class NoteSm
    {
        public NoteType type {get;set;}
        public String creditRelationshipId {get;set;}
        public String diary {get;set;}
    }
}