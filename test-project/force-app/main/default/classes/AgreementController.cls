public with sharing class AgreementController {
    private Id m_agmtId;
    public Agreement__c agmt {get;set;}
    public Agreement_Client_Relationships__c EntityRelationships {get;set;}
    public Agreement_Subordination__c Subordination {get;set;}
    public Agreement_Test__c AgreementTest {get; set;}
    public Agreement_Fee__c AgreementFee {get;set;}
    public Id selectedEntity {get;set;}
    public Id selectedEbAccount {get;set;}
    public Id selectedLoanApp {get;set;}
    public Id selectedSubordinationId {get;set;}
    public Id selectedAgreementFeeId {get;set;}
    public Boolean covenantStandardFieldsVisible {get;set;}
    public Boolean covenantCustomFieldsVisible {get;set;}
    public String styleClassPanel1 {get;set;}
    public String styleClassPanel2 {get;set;}
    public String layout {get;set;}
    public String url {get;set;}
    public Id selectedAgreementTestForDelete {get;set;}
    public Id selectedAgreementFeeForDelete {get;set;}
    public List<Account> clients {get;set;}
    public List<DocumentWrapper> finDocumentWrapper {get;set;}
    public List<DocumentWrapper> agmtDocumentWrapper {get;set;}
    public List<FinancialRequirement> financialRequirements {get;set;}
    public Boolean PossibleBorrowersCollapse {get;set;}
    public Boolean EbAccountCollapse {get;set;}
    
    private final String AGREEMENT_REPORT_ID = 'AgreementReportNoApp';
    private final String AGREEMENT_APPROVAL_PATHS_ID = 'AgreementApprovalPathsUrl';
    private final String AGREEMENT_REPORTING_REQUIREMENTS_ID = 'AgreementReportingRequirementsUrl';
    private final Agreements.IAgreementControllerDataProvider m_dataProvider;    
    private final Agreements.IAgreementApprovalInfo m_agreementApprovalInfo;
    private final Agreements.IAgreementStatusManager m_agreementStatusManager;
    private final Agreements.IAgreementValidator m_agreementValidator;
    private final IUserInfoService m_userInfoSvc;
    private final Agreements.ILoanAppRepository m_loanAppRepository;
    private final Configurations.IConfigurations m_configs;
    private final ReportUrlProvider.IReportUrlProvider m_UrlProvider;
    
    private Boolean m_approvalMinuteLoaded = false;

    enum CurrentPopup {
        Client,
        Subordination,
        IncludedEntities,
        None
    }

    CurrentPopup Mode;
    
    private EB_Loan_App_Minute__c m_approvalMinute {
        get {
            if (m_approvalMinuteLoaded == false) {
                if (m_agreementApprovalInfo != null && m_agreementApprovalInfo.GetApprovalMinute(agmt.Id) != null) {
                    m_approvalMinute =  m_agreementApprovalInfo.GetApprovalMinute(agmt.Id);
                }
                m_approvalMinuteLoaded = true;
            }
            return m_approvalMinute;
        }
        set;
    }
    
    private RecordType m_agreementRecordType {
        get {
            return m_agreementStatusManager.getRecordType(agmt);
        }
    }
   
    private Boolean m_isPending {
        get {
            return (m_agreementRecordType == Utility.recordTypeObject('Agreement__c','Pending'));
        }
    }
    
    private Boolean m_isActive {
        get {
            return (m_agreementRecordType == Utility.recordTypeObject('Agreement__c','Active'));
        }
    }
    
    private Boolean m_isArchive {
        get {
            return (m_agreementRecordType == Utility.recordTypeObject('Agreement__c','Archive'));
        }
    }
    
    private String m_url {
        get {
            return utility.getServerUrl() + '/apex/Agreement?id=' + agmt.Id; 
        }
    }
    
    private PageReference m_refreshPage {
        get {
            PageReference newPage = new PageReference(m_url);
            newPage.setRedirect(true);              
            return newPage;
        }
    }

    public boolean isBackOfficeModification {
        get {
            return (agmt.Stage__r.Name == 'Back Office Modification');
        }
    }

    public boolean isAgreementStageNew {
        get {
            return (agmt.Stage__r.Name == 'New');
        }
    }

    public boolean canEditAgreement {
        get {
            return m_agreementStatusManager.isAgreementEditable(agmt,UserInfo.getUserId());
        }   
    }

    public boolean isEditButtonVisible {
        get {
            return m_isPending || m_isActive;
        }
    }

    public boolean canViewAgreementTests {
        get {
            return !m_isPending;
        }   
    }

    public boolean canExcludeRelatedEBAccounts {
        get {
            return !m_isArchive;
        }   
    }

    public boolean canIncludeExcludedRelatedEBAccounts {
        get {
            return !m_isArchive;
        }   
    }

    public boolean canExcludeRelatedLoanApplications {
        get {
            return !m_isArchive;
        }   
    }

    public boolean canIncludeRelatedLoanApplications {
        get {
            return !m_isArchive;
        }   
    }
    
    public AgreementController(ApexPages.StandardController controller) {
        Configurations.IConfigurations cfgs = Configurations.bootstrap();
        m_dataProvider = new AgreementControllerDataProvider();
        m_userInfoSvc = new UserInfoService(cfgs, new UserInfoServiceDataProv());
        m_agreementApprovalInfo = new AgreementApprovalInfo();
        m_agreementStatusManager = new AgreementStatusManager(m_userInfoSvc, new AgreementEntityManager(new AgreementEntityManagerDataProvider()), new AgreementStatusManagerDataProvider());
        m_agreementValidator = AgreementValidator.getInstance();
        m_agmtId = ApexPages.currentPage().getParameters().get('id');
        m_loanAppRepository = new AgreementLoanAppRepository(m_dataProvider, new AgreementDmLoanAppBuilder(), new AgreementLoanAppRepositoryHelper());
        m_configs = cfgs;
        m_UrlProvider = new ReportUrlProvider(m_configs);
    }
    
    public AgreementController(Agreements.IAgreementControllerDataProvider dataProvider, 
        Agreements.IAgreementApprovalInfo approvalInfo, Agreements.IAgreementStatusManager statusManager, 
        Agreements.IAgreementValidator validator, IUserInfoService userInfoSvc, Id agreementId, Agreements.ILoanAppRepository loanAppRepository, Configurations.IConfigurations configs, ReportUrlProvider.IReportUrlProvider urlProvider){
        m_dataProvider = dataProvider;
        m_agreementApprovalInfo = approvalInfo;
        m_agreementStatusManager = statusManager;
        m_agreementValidator = validator;
        m_userInfoSvc = userInfoSvc;
        m_agmtId = agreementId;
        m_loanAppRepository = loanAppRepository;
        m_configs = configs;
        m_UrlProvider = urlProvider;
    }

    public void initialize() {
        agmt = m_dataProvider.getAgreementByID(m_agmtId);
        m_agreementValidator.Validate(agmt);
        InitializeRelatedLists();
        InitializeDocs();
        SetCollapseSections();
        layout = 'none';
        renderErrorsAndWarnings();
    }

    public void renderErrorsAndWarnings() {
        RenderErrorMessages();
        RenderWarningMessages(); 
    }
    
    public Boolean IsArchive {
        get {
            return m_isArchive;
        }
    }
    
    public Boolean IsActive {
        get {
            return m_isActive;
        }
    }
    
    public Boolean IsPending {
        get {
            return m_isPending;
        }
    }
    
    private Boolean showIndependentApprovalRelatedObjects {
        get {
            if (m_isPending) {
                if (m_agreementApprovalInfo.wasIndependentlyApproved(agmt.Id)) {
                    return true;
                }
                return !m_agreementStatusManager.hasLoanApps(agmt);
            }
            return m_agreementApprovalInfo.wasIndependentlyApproved(agmt.Id);
        }
    }
    
    public Boolean showMakeThisAgreementActive {
        get {
            if (m_isPending) {
                return showIndependentApprovalRelatedObjects && userHasMakeActivePermission;
            }
            return false;
        }
    }
    
    public Boolean showWorkflowNextStep {
        get {
            if (m_isPending) {
                return showIndependentApprovalRelatedObjects;
            }
            return false;
        }
    }
    
    public Boolean showWorkflowInformation {
        get {
            return showIndependentApprovalRelatedObjects;
        }
    }
    
    public Boolean showApprovalDetails {
        get {
            return showIndependentApprovalRelatedObjects;
        }
    }
    
    public Boolean showOwnApproval {
        get {
            if (m_agreementApprovalInfo.hasApprovalInformation(agmt.Id)) {
                return true;
            }
            if (m_isPending && !m_agreementStatusManager.hasLoanApps(agmt)) {
                return true;
            }
            return false;
        }
    }
    
    public Boolean showApprovalMinute {
        get {
            if (m_isPending) {
                return m_agreementStatusManager.hasLoanApps(agmt);    
            }
            return !m_agreementApprovalInfo.wasIndependentlyApproved(agmt.Id);
        }
    }
    
    public Boolean showAgreementFees {
        get {
            return showIndependentApprovalRelatedObjects;
        }
    }
    
    public Boolean showStageLog {
        get {
            return showIndependentApprovalRelatedObjects;
        }
    }
        
    public PageReference Modify() {
        PageReference newPage = new PageReference(utility.getServerUrl() + '/apex/ModifyAgreementView?id=' + string.valueOf(agmt.Id));
        newPage.setRedirect(true);              
        return newPage;
    }
    
    public PageReference WorkflowNextStep() {
        PageReference newPage = new PageReference(utility.getServerUrl() + '/apex/AgreementStageActionManager?id=' + string.valueOf(agmt.Id));
        newPage.setRedirect(true);              
        return newPage;
    }
    
    public String ReportUrl {
        get {
            String reportId = m_configs.get(AGREEMENT_REPORT_ID);
            List<string> parameters= new List<string>{string.valueOf(agmt.Id)};
            return m_UrlProvider.getReportUrl(reportId, parameters);
        }
    }

    public String ApprovalPathsUrl {
        get {
            return m_configs.get(AGREEMENT_APPROVAL_PATHS_ID);
        }
    }

    public String ReportingRequirementsURL {
        get {
            return m_configs.get(AGREEMENT_REPORTING_REQUIREMENTS_ID);
        }
    }

    @TestVisible  
    private void RenderErrorMessages() {
        if (agmt.ErrorMessages__c <> null && agmt.ErrorMessages__c <> '') {
            List<String>errors = utility.DelimitedStringToList(agmt.ErrorMessages__c,'\n');
            for (String e : errors) {
                ApexPages.Message newMsg = new ApexPages.Message(ApexPages.Severity.WARNING, e);
                ApexPages.addMessage(newMsg);
            }            
        }
    }

    @TestVisible
    private void RenderWarningMessages() {
        if (agmt.WarningMessages__c <> null && agmt.WarningMessages__c <> '') {
            List<String>errors = utility.DelimitedStringToList(agmt.WarningMessages__c,'\n');
            for (String e : errors) {
                ApexPages.Message newMsg = new ApexPages.Message(ApexPages.Severity.INFO, e);
                ApexPages.addMessage(newMsg);
            }            
        }
    }
    
    private void SetCollapseSections() {
        EbAccountCollapse= false;
        PossibleBorrowersCollapse = false;
    }

    private void InitializeRelatedLists() {
        EntityRelationships = new Agreement_Client_Relationships__c ();
        EntityRelationships.Agreement__c = agmt.Id;
        EntityRelationships.Entity__c = selectedEntity;
        EntityRelationships.Relationship__c = null;        
    }
   
    public EB_Loan_App_Minute__c approvalMinute {
        get {
            return (m_approvalMinute == null) ? new EB_Loan_App_Minute__c() : m_approvalMinute;
        }
    }
    
    public String approvalMinuteURL {
        get {
            return utility.GetUrlFor(approvalMinute.Id);
        }
    }
    
    public PageReference MakeActive() {
        m_agreementStatusManager.MakeActive(agmt.Id);
        return m_refreshPage;
    }
    
    public PageReference MakeArchive() {
        m_agreementStatusManager.MakeArchive(agmt.Id);
        return m_refreshPage;
    }
    
    public PageReference AdminMakeActive() {
        m_agreementStatusManager.MakeActiveAdminBackdoor(agmt.Id);
        return m_refreshPage;
    }
    
    public PageReference AdminMakePending() {
        m_agreementStatusManager.MakePendingAdminBackdoor(agmt.Id);
        return m_refreshPage;
    }
    
    public PageReference AdminMakeArchive() {
        m_agreementStatusManager.MakeArchiveAdminBackdoor(agmt.Id);
        return m_refreshPage;
    }
    
    public PageReference AdminMakeNew() {
        m_agreementStatusManager.MakeNewAdminBackdoor(agmt.Id);
        return m_refreshPage;
    }
   
    //// Financial Monitoring
    public List<Agreement_Financial_Documents__c> documents {get;set;}
    
    public Integer agmtDocumentWrapperCount {
        get {
            if (agmtDocumentWrapper == null) {
                return 0;
            }
            return agmtDocumentWrapper.size();
        }
    }
    
    public Integer finDocumentWrapperCount {
        get {
            if (finDocumentWrapper == null) {
                return 0;
            }
            return finDocumentWrapper.size();
        }
    }
    
    public class DocumentWrapper {
        public String financialDocType {get;set;}
        public Agreement_Financial_Documents__c financialDocument {get;set;}
        public Boolean overridden {get;set;}
        public documentWrapper(){}
    }
    
    public class FinancialRequirement {
        public String documentType {get;set;}
        public String name {get;set;}
        private String m_frequency {get;set;}
        private String m_period {get;set;}
        private String m_periodOther {get;set;}
        private String m_quality {get;set;}
        private String m_otherType {get;set;}
        private String m_entitiesToCombine {get;set;}
        public FinancialRequirement(String docType, String clientName, String frequency, String period, String periodOther, String quality, String otherType, String entitiesToCombine) {
            documentType = docType;
            name = clientName;
            m_frequency = frequency;
            m_period = period;
            m_periodOther = periodOther;
            m_quality = quality;
            m_otherType = otherType;
            m_entitiesToCombine = entitiesToCombine;
        }

        public String details {
            get {
                String period = m_period;
                if (period == '-1') {
                    period = 'Other (' + m_periodOther + ')';
                }                       
                    
                if (documentType == 'Personal Financial Statement') {
                    return 'Frequency: ' + m_frequency;
                } else if (documentType == 'Annual Financial Statement') {                    
                    String otherType = m_otherType != null ? m_otherType : '';
                    otherType += m_otherType == 'Combined' ? ' (' + m_entitiesToCombine + ')' : '';
                    return 'Days Due After Period End: ' + period + ' / Quality: ' + m_quality + ' / Other Type: ' + otherType;
                } else if (documentType == 'Interim Statement') {
                    return m_frequency + ' / Days Due After Period End: ' + period  + ' / Quality: ' + m_quality;
                } else if (documentType == 'Tax Return') {
                    return 'Tax Return Days Due After Filing: ' + period; 
                }
                return '';
            }
        }
    }

    public void initializeDocs() {
        initializeEntitySpecificDocs();
        initializeAgreementSpecificDocs();
    }

    public void initializeEntitySpecificDocs() {
        List<Agreement_Client_Relationships__c> agmtClientRels = m_dataProvider.getAgreementClientRelationshipsByAgreementId(agmt.Id);
        
        financialRequirements = new List<FinancialRequirement>();
        if (IsActive) {
            Map<Id,Account> entities = new Map<Id,Account>();
            for (Agreement_Client_Relationships__c rel : agmtClientRels) {
                entities.put(rel.Entity__c,rel.Entity__r);
            }
            for (Account entity : entities.values()) {
                if (entity.Personal_Financial_Statement__c == 'Yes') {
                    financialRequirements.add(new FinancialRequirement('Personal Financial Statement',entity.Entity_Name__c,entity.Personal_Financial_Statement_Frequency__c,'','','','',''));
                }
                if (entity.Annual_Financial_Statements__c == 'Yes') {
                    financialRequirements.add(new FinancialRequirement('Annual Financial Statement',entity.Entity_Name__c,'',String.valueOf(entity.Annual_Stmt_Days_Due_After_Fiscal_Y_E__c),String.valueOf(entity.Annual_Financial_Statement_Period_Other__c),entity.Annual_Statement_Quality__c,entity.Other_Type__c,entity.Entities_To_Combine__c));
                }
                if (entity.Interim_Statements__c != null && entity.Interim_Statements__c != 'Not Required') {
                    financialRequirements.add(new FinancialRequirement('Interim Statement',entity.Entity_Name__c,entity.Interim_Statements__c,String.valueOf(entity.Interim_Stmt_Days_Due_After_Period_End__c),String.valueOf(entity.Interim_Statement_Period_Other__c),entity.Interim_Stm_Prepared_By__c,'',''));
                }
                if (entity.Tax_Returns__c == 'Yes') {
                    financialRequirements.add(new FinancialRequirement('Tax Return',entity.Entity_Name__c,'',String.valueOf(entity.Tax_Return_Days_Due_After_Filing__c),String.valueOf(entity.Tax_Return_Period_Other__c),'','',''));
                }
            }
        } else if (IsPending) {
            Map<Id,Account> entities = new Map<Id,Account>();
            for (Agreement_Client_Relationships__c rel : agmtClientRels) {
                entities.put(rel.Entity__c,rel.Entity__r);
            }
            for (Account entity : entities.values()) {
                if (entity.Pending_PFS__c == 'Yes') {
                    financialRequirements.add(new FinancialRequirement('Personal Financial Statement',entity.Entity_Name__c,entity.Pending_PFS_Frequency__c,'','','','',''));
                }
                if (entity.Pending_AFS__c == 'Yes') {
                    financialRequirements.add(new FinancialRequirement('Annual Financial Statement',entity.Entity_Name__c,'',String.valueOf(entity.Pending_AFS_Days_Due_After_FYE__c),String.valueOf(entity.Pending_AFS_Period_Other__c),entity.Pending_AFS_Quality__c,entity.Pending_AFS_Other_Type__c,entity.Pending_AFS_Entities_To_Combine__c));
                }
                if (entity.Pending_IntStmts__c != null && entity.Pending_IntStmts__c != 'Not Required') {
                    financialRequirements.add(new FinancialRequirement('Interim Statement',entity.Entity_Name__c,entity.Pending_IntStmts__c,String.valueOf(entity.Pending_IntStmts_Days_Due_After_PE__c),String.valueOf(entity.Pending_IntStmts_Period_Other__c),entity.Pending_IntStmts_Quality__c,'',''));
                }
                if (entity.Pending_TaxReturns__c == 'Yes') {
                    financialRequirements.add(new FinancialRequirement('Tax Return',entity.Entity_Name__c,'',String.valueOf(entity.Pending_TaxReturns_Days_Due_After_Filing__c),String.valueOf(entity.Pending_TaxReturns_Period_Other__c),'','',''));
                }
            }
        } else {
            for (Agreement_Client_Relationships__c rel : agmtClientRels) {
                if (rel.Personal_Financial_Statement__c == 'Yes') {
                    financialRequirements.add(new FinancialRequirement('Personal Financial Statement',rel.Entity__r.Entity_Name__c,rel.Personal_Financial_Statement_Frequency__c,'','','','',''));
                }
                if (rel.Annual_Financial_Statements__c == 'Yes') {
                    financialRequirements.add(new FinancialRequirement('Annual Financial Statement',rel.Entity__r.Entity_Name__c,'',String.valueOf(rel.Annual_Stmt_Days_Due_After_Fiscal_Y_E__c),String.valueOf(rel.Annual_Financial_Statement_Period_Other__c),rel.Annual_Statement_Quality__c,rel.Other_Type__c,rel.Entities_To_Combine__c));
                }
                if (rel.Interim_Statements__c != null && rel.Interim_Statements__c != 'Not Required') {
                    financialRequirements.add(new FinancialRequirement('Interim Statement',rel.Entity__r.Entity_Name__c,rel.Interim_Statements__c,String.valueOf(rel.Interim_Stmt_Days_Due_After_Period_End__c),String.valueOf(rel.Interim_Statement_Period_Other__c),rel.Interim_Stm_Prepared_By__c,'',''));
                }
                if (rel.Tax_Returns__c == 'Yes') {
                    financialRequirements.add(new FinancialRequirement('Tax Return',rel.Entity__r.Entity_Name__c,'',String.valueOf(rel.Tax_Return_Days_Due_After_Filing__c),String.valueOf(rel.Tax_Return_Period_Other__c),'','',''));
                }
            }
        }             
    }

    public void initializeAgreementSpecificDocs() {
        documents = m_dataProvider.getAgreementFinancialDocumentsByAgreementId(agmt.Id);
        finDocumentWrapper = new List<DocumentWrapper>();
        agmtDocumentWrapper = new List<DocumentWrapper>();
        
        if (documents != null) {
            for (Agreement_Financial_Documents__c doc : documents) {
                if (doc.RecordTypeDescription__c != 'Personal Financial Statement'
                    && doc.RecordTypeDescription__c != 'Tax Return'
                    && doc.RecordTypeDescription__c != 'Interim Statement'
                    && doc.RecordTypeDescription__c != 'Annual Financial Statement') {
                        DocumentWrapper bWrap = new DocumentWrapper();
                        bWrap.financialDocType = doc.RecordTypeDescription__c;
                        bWrap.financialDocument = doc;
                        bWrap.overridden = (bWrap.financialDocument.Period_Due__c == 'Other');
                        agmtDocumentWrapper.add(bWrap);
                }
                if (doc.RecordTypeDescription__c == 'Personal Financial Statement'
                    || doc.RecordTypeDescription__c == 'Tax Return'
                    || doc.RecordTypeDescription__c == 'Interim Statement'
                    || doc.RecordTypeDescription__c == 'Annual Financial Statement') {
                        DocumentWrapper bWrap = new DocumentWrapper();
                        bWrap.financialDocType = doc.RecordTypeDescription__c;
                        bWrap.financialDocument = doc;
                        bWrap.overridden = (bWrap.financialDocument.Period_Due__c == 'Other');
                        finDocumentWrapper.add(bWrap);
                }
            }
        }
    }
    //// End: Financial Monitoring
    
    //// Entities
    public class Relationship {
        private Id m_Id {get;set;}
        public String Name {get;set;}
        public Relationship(Id i, String n) {
            m_Id = i;
            Name = n;
        }
    }

    public class RelatedEntity implements Comparable {
        private Account m_entity;
        public List<Relationship> Relationships {get;set;}
        public RelatedEntity(Account entity, Relationship firstRelationship) {
            m_entity = entity;
            Relationships = new List<Relationship>();
            Relationships.add(firstRelationship);
        }

        public Id Id {
            get {
                return m_entity.Id;
            }
        }

        public String Name {
            get {
                return m_entity.Entity_Name__c;
            }
        }

        public String Address {
            get {
                return m_entity.BillingStreet + ', ' + m_entity.BillingCity + ', ' + m_entity.BillingState + ', ' + m_entity.BillingPostalCode;
            }
        }

        public String EntityType {
            get {
                return m_entity.Record_Type_Description__c;
            }
        }

        public String RelatedBy {
            get {
                List<String>entries = new List<String>();
                for (Relationship r : Relationships) {
                    entries.add(r.Name);
                }
                return utility.ListToDelimitedString(entries, ', ');
            }
        }

        public String AbridgedRelatedBy {
            get {
                Integer MAX = 2;
                List<String>entries = new List<String>();
                for (Integer i=0; i<Relationships.size(); ++i) {
                    if (i < MAX) {
                        entries.add(Relationships[i].Name);
                    } else if (i == MAX) {
                        entries.add('+' + string.valueOf(Relationships.size() - MAX) + ' more');
                    }
                }
                return utility.ListToDelimitedString(entries, ', ');
            }
        }

        public Integer compareTo(Object compareTo) {
            RelatedEntity compareToEntity = (RelatedEntity)compareTo;
            if (Name == compareToEntity.Name) {return 0;}
            if (Name > compareToEntity.Name) {return 1;}
            return -1;    
        }
    }
    
    @TestVisible
    private Set<Id> IncludedEntitiesSet {
        get {
            if (IncludedEntitiesSet == null) {
                IncludedEntitiesSet = new Set<Id>();
                for (IncludedEntity ie : IncludedEntities) {
                    IncludedEntitiesSet.add(ie.Id);
                }
            }
            return IncludedEntitiesSet;
        }
        set;
    }
    
    public List<IncludedEntity> IncludedEntities {
        get {
            if (IncludedEntities == null) {
                IncludedEntities = new List<IncludedEntity>();
                List<Account> rels = m_dataProvider.getRelatedEntitiesWithClientRelationshipsByAgreementId(agmt.Id);
                for (Account rel : rels) {
                    IncludedEntity ie = new IncludedEntity(rel,agmt,rel.Agreement_To_Loan_Relations__r);
                    IncludedEntities.add(ie);
                }
                IncludedEntities.sort();
            }
            return IncludedEntities;
        }
        set;
    }

    @TestVisible
    private List<EB_Account_Relationship__c> EbAccountRelationships {
        get {
            return m_dataProvider.getEbAccountRelationships(AllEbAccounts, IncludedEntitiesSet);
        }
    }

    @TestVisible
    private List<Agreements.LoanAppEntityRelationship> LoanApplicationRelationships {
        get {
            return m_loanAppRepository.getExcludedLoanApplicationRelationships(AllLoanApps, IncludedEntitiesSet);
        }
    }
    
    public List<RelatedEntity> ExcludedEntities {
        get {
            if (ExcludedEntities == null) {
                Map<Id,RelatedEntity> relatedClientMap = new Map<Id,RelatedEntity>();
                   
                for (EB_Account_Relationship__c rel : EbAccountRelationships) {
                    RelatedEntity e;
                    Relationship r = new Relationship(rel.EB_Account_Id__r.Id, rel.EB_Account_Id__r.Name);
                    
                    if (relatedClientMap.containsKey(rel.Client_Id__c)) {
                        e = relatedClientMap.get(rel.Client_Id__c);
                        e.Relationships.add(r);
                    } else {
                        e = new RelatedEntity(rel.Client_Id__r, r);
                        relatedClientMap.put(rel.Client_Id__c, e);
                    }
                }
                
                for (Agreements.LoanAppEntityRelationship rel : LoanApplicationRelationships) {
                    RelatedEntity e;
                    Relationship r = new Relationship(rel.loanApp.id, rel.loanApp.name);
                    
                    if (relatedClientMap.containsKey(rel.entity.Id)) {
                        e = relatedClientMap.get(rel.entity.Id);
                        e.Relationships.add(r);
                    } else {
                        e = new RelatedEntity(rel.entity, r);
                        relatedClientMap.put(rel.entity.Id, e);
                    }
                }        
                
                ExcludedEntities = relatedClientMap.values();
                ExcludedEntities.sort();            
            }
            return ExcludedEntities;
        }
        set;
    }
       
    public Integer excludedEntitiesCount {
        get {
            if (ExcludedEntities == null) {
                return 0;
            }
            return ExcludedEntities.size();
        }
    }  
    
    public Integer includedEntitiesCount {
        get {
            if (IncludedEntities == null) {
                return 0;
            }
            return IncludedEntities.size();
        }
    }
    
    public void includeEntity() {
          EntityRelationships = new Agreement_Client_Relationships__c ();
          EntityRelationships.Agreement__c = agmt.id;
          EntityRelationships.Entity__c = selectedEntity;
          this.mode = CurrentPopup.Client;
          showDialog();          
    }
    
    public PageReference editEntity() {
       String url = Utility.getServerUrl() + '/apex/AgreementClientRelationshipEdit?id=' + string.valueOf(selectedEntity); 
       PageReference newPage = new PageReference(url);
       newPage.setRedirect(true);
       return newPage;
    }
    
    public PageReference excludeEntity() {
        Agreement_Client_Relationships__c relObjToRemove = new Agreement_Client_Relationships__c(Id = selectedEntity);
        m_dataProvider.remove(relObjToRemove);
        AgreementSummaryUpdater.updateSummaries(agmt.Id);
        return m_refreshPage;
    }    
    //// End: Entities
    
    //// EB Accounts  
    public List<EB_Account__c> AllEbAccounts {
        get {
            List<EB_Account__c> allEbAccounts = new List<EB_Account__c>();
            allEbAccounts.addAll(IncludedEbAccounts);
            allEbAccounts.addAll(ExcludedEbAccounts);
            return allEbAccounts;
        }
    }
    
    public List<Agreement_EB_Account_Relationship__c> IncludedEbAccountRelationships {
        get {
            if (IncludedEbAccountRelationships == null) {
                IncludedEbAccountRelationships = m_dataProvider.getIncludedEbAccountRelationshipsByAgreementId(agmt.Id);
            }
            return IncludedEbAccountRelationships;
        }
        private set;
    }
    
    private List<EB_Account__c> IncludedEbAccounts {
        get {
            List<EB_Account__c>included = new List<EB_Account__c>();
            for (Agreement_EB_Account_Relationship__c rel : IncludedEbAccountRelationships) {
                included.add(rel.Loan_Account__r);
            }
            return included;
        }
    }
    
    public List<EB_Account__c> ExcludedEbAccounts {
        get {
            if (ExcludedEbAccounts == null) {
               ExcludedEbAccounts = m_dataProvider.getExcludedEbAccounts(IncludedEntitiesSet, IncludedEbAccounts);
            }
            return ExcludedEbAccounts;
        }
        private set;
    }
    
    public Integer excludedEbAccountsCount {
        get {
            if (ExcludedEbAccounts == null) {
                return 0;
            }
            return ExcludedEbAccounts.size();
        }
    }
        
    public PageReference excludeEbAccount() {
        Agreement_EB_Account_Relationship__c relObjToRemove = new Agreement_EB_Account_Relationship__c(Id = selectedEbAccount);
        m_dataProvider.remove(relObjToRemove);
        AgreementSummaryUpdater.updateSummaries(agmt.Id);
        return m_refreshPage;
    }
    
    public PageReference includeEbAccount() {
        Agreement_EB_Account_Relationship__c insertObj = new Agreement_EB_Account_Relationship__c(Loan_Account__c = selectedEbAccount, Agreement__c = agmt.Id);
        m_dataProvider.save(insertObj);
        AgreementSummaryUpdater.updateSummaries(agmt.Id);
        return m_refreshPage;
    }    
    //// End: EB Accounts
    
    //// Loan Applications
    public List<DmLoanApp> AllLoanApps {
        get {            
            List<DmLoanApp> allLoanApps = new List<DmLoanApp>();
            allLoanApps.addAll(IncludedLoanApps);
            allLoanApps.addAll(ExcludedLoanApps);
            return allLoanApps;
        }
    }
    
    public List<DmLoanApp> IncludedLoanApps {
        get {
            if (IncludedLoanApps == null) {
                IncludedLoanApps = m_loanAppRepository.getIncludedLoanApps(agmt.Id);
            }      
            return IncludedLoanApps;
        }
        private set;
    }
    
    private Boolean m_agreementIsRelatedToNotNewLoanApplication {
        get {
            Boolean returnResult = false;
            if (IncludedLoanApps != null) {
                for (DmLoanApp rel: IncludedLoanApps) {
                    if (!rel.isNewStage) {returnResult = true;}
                }
            }
            return returnResult;
        }
    }
    
    public Boolean agreementIsRelatedToNotNewLoanApplication {
        get {
            return m_agreementIsRelatedToNotNewLoanApplication;
        }
    }
    
    public List<DmLoanApp> ExcludedLoanApps {
        get {
            if (ExcludedLoanApps == null) {
                ExcludedLoanApps = m_loanAppRepository.getExcludedLoanApps(IncludedEntitiesSet, IncludedLoanApps, IncludedEbAccounts);
            }
            return ExcludedLoanApps;
        }
        private set;
    }
    
    public Integer excludedLoanAppsCount {
        get {
            if (ExcludedLoanApps == null) {
                return 0;
            }
            return ExcludedLoanApps.size();
        }
    }    

    public PageReference excludeLoanApp() {
        m_loanAppRepository.excludeLoanApp(agmt.Id, selectedLoanApp);
        AgreementSummaryUpdater.updateSummaries(agmt.Id);
        return m_refreshPage;
    }
    
    public PageReference includeLoanApp() {
        m_loanAppRepository.includeLoanApp(agmt.Id, selectedLoanApp);
        AgreementSummaryUpdater.updateSummaries(agmt.Id);
        return m_refreshPage;
    }
    //// End: Loan Applications

    public Boolean displayDialog {get; set;}
    
    public void cancelDialog() {
        displayDialog = false;
    }

    public PageReference closeDialog() { 
        displayDialog = false;
        if (this.Mode ==  CurrentPopup.client) {
            if (EntityRelationships.Relationship__c != null && String.valueOf(selectedEntity) != '') {
                m_dataProvider.save(EntityRelationships);
            }
            AgreementSummaryUpdater.updateSummaries(agmt.Id);
        }
        ResetClickedParameters();
        return m_refreshPage;
    }

    public void showDialog() {        
        displayDialog = true;    
    }

    private void ResetClickedParameters() {
        selectedEntity = null;        
        this.mode = CurrentPopup.none;   
    }

    public PageReference ExpandCollapsePossibleBorrowersCollapse() {
        PossibleBorrowersCollapse = !PossibleBorrowersCollapse;
        return null;
    }

    public PageReference ExpandCollapseEbAccount() {
        EbAccountCollapse = !EbAccountCollapse;
        return null;
    }
    
    //////Vf Hide / Show methods//////
    public String AgreementPendingStatus {
        get {
            if (agmt.RecordTypeId == null) {
                return 'false';
            }
            if (Utility.RecordTypeObject('Agreement__c', agmt.RecordTypeId).Name == 'Pending') {
                return 'true';
            }
            return 'false';
        }
    }

    public class IncludedEntity implements Comparable {
        private Account m_entity;       
        private Agreement__c m_referenceAgreement;
        private List<Agreement_Client_Relationships__c> m_entityAgreements;
        private Agreement_Client_Relationships__c m_thisRelationship {
            get {
                if (m_thisRelationship == null) {
                    for (Agreement_Client_Relationships__c agmtRel : m_entityAgreements) {
                        if (agmtRel.Agreement__c == m_referenceAgreement.Id) {
                            m_thisRelationship = agmtRel;
                        }
                    }
                }
                return m_thisRelationship;
            }
            set;
        }
        
        public IncludedEntity(Account entity, Agreement__c refAgmt, List<Agreement_Client_Relationships__c> entityAgreements) {
            m_entity = entity;
            m_referenceAgreement = refAgmt;
            m_entityAgreements = entityAgreements;
        }

        public Id Id {
            get {
                return m_entity.Id;
            }
        }

        public String Name {
            get {
                return m_entity.Entity_Name__c;
            }
        }

        public String Relationship {
            get {
                if (m_thisRelationship != null) {
                    return m_thisRelationship.Relationship__c;
                }
                return '';
            }
        }

        public Decimal PrimarySortOrder {
            get {
                if (m_thisRelationship != null) {
                    return m_thisRelationship.Primary_Sort_Order__c;
                }
                return 99;
            }
        }

        public DateTime CreatedDate {
            get {
                if (m_thisRelationship != null) {
                    return m_thisRelationship.CreatedDate;
                }
                return DateTime.now();
            }
        }

        public Id AgreementRelationshipId {
            get {
                for (Agreement_Client_Relationships__c agmtRel : m_entityAgreements) {
                    if (agmtRel.Agreement__c == m_referenceAgreement.Id) {
                        return agmtRel.Id;
                    }
                }
                return null;
            }
        }

        public String OtherAgreements {
            get {
                Id refAgmtSourceId = m_referenceAgreement.Source_Agreement__c;
                List<String> agreements = new List<String>();
                for (Agreement_Client_Relationships__c agmtRel : m_entityAgreements) {
                    if (agmtRel.Agreement__r.RecordTypeDescription__c != 'Archive') {
                        if (agmtRel.Agreement__c != m_referenceAgreement.Id && agmtRel.Agreement__c != refAgmtSourceId) {
                            agreements.add(agmtRel.Agreement__r.Name + ' (' + agmtRel.Agreement__r.RecordTypeDescription__c + ')');
                        }
                    }
                }
                return utility.ListToDelimitedString(agreements, ', ');
            }
        }

        public Integer compareTo(Object compareTo) {
            IncludedEntity compareToEntity = (IncludedEntity)compareTo;
            if (PrimarySortOrder < compareToEntity.PrimarySortOrder) {return -1;}
            if (PrimarySortOrder > compareToEntity.PrimarySortOrder) {return 1;}
            return compareCreatedDate(compareTo);
        }

        private Integer compareCreatedDate(Object compareTo) {
            IncludedEntity compareToEntity = (IncludedEntity)compareTo;
            if(CreatedDate < compareToEntity.CreatedDate) {return -1;}
            if(CreatedDate > compareToEntity.CreatedDate) {return 1;}
            return 0;
        }
    }

    public Boolean isSystemAdministrator {
        get {
            return m_userInfoSvc.isSystemAdministrator(UserInfo.getUserId());
        }
    }

    public Boolean userHasMakeActivePermission {
        get {
            Map<String, PermissionSet> sets = m_userInfoSvc.getPermissionSets(UserInfo.getUserId());
            return (isSystemAdministrator || sets.containsKey('Function - Lending Agreement System - Activate Agreement')) ? true : false;
        }
    }

    public Boolean userHasMakeArchivePermission {
        get {
            Map<String, PermissionSet> sets = m_userInfoSvc.getPermissionSets(UserInfo.getUserId());          
            return (isSystemAdministrator || sets.containsKey('Function - Lending Agreement System - Archive Agreement')) ? true : false;
        }
    }
}