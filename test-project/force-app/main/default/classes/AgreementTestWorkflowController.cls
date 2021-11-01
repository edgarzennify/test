public with sharing class AgreementTestWorkflowController {

    private final String NONE = '--None--';
    private final String SUBMIT_FOR_APPROVAL = 'Submit For Approval';
    private final String TWO_SIGNATURES = '2 Signatures';
    private final String RM_PLUS_ONE = 'RM + 1';
    private final String THREE_SIGNATURES = '3 Signatures';
    private final String EXECUTIVE_LOAN_COMMITTEE = 'Executive Loan Committee';
    private final String REGIONAL_LOAN_COMMITTEE = 'Regional Loan Committee';
    private final String AGREEMENT_APPROVAL_PATHS_ID = 'AgreementApprovalPathsUrl';

    private ApexPages.StandardController m_controller;
    private TeamRoleMatrix.ITeamRoleMatrix m_teamRoleMatrix;
    private AgreementTestWorkflowDataProvider.IAgreementTestWorkflowDataProvider m_dataProvider;
    private Utility.IUtility m_utility;
    private IUserInfoService m_userInfoSvc;
    private IApexPages m_apexPages;
    private Configurations.IConfigurations m_configs;
    
    private Id m_agreementTestId;

    public String ddNextStatus {get;set;}

    public AgreementTestWorkflowController(ApexPages.StandardController controller){
        m_configs = Configurations.bootstrap();
        m_controller = controller;
        m_agreementTestId = m_controller.getId();
        m_teamRoleMatrix = new TeamRoleMatrix.TeamRoleMatrixImplementation();
        m_dataProvider = new AgreementTestWorkflowDataProvider();
        m_utility = new Utility();
        m_userInfoSvc = new UserInfoService(m_configs, new UserInfoServiceDataProv());
        m_apexPages = new ApexPagesWrapper();
        initialize();
    }

    public AgreementTestWorkflowController(Configurations.IConfigurations configs, TeamRoleMatrix.ITeamRoleMatrix teamRoleMatrix, AgreementTestWorkflowDataProvider.IAgreementTestWorkflowDataProvider dataProvider, Utility.IUtility utility, IUserInfoService userInfoSvc, IApexPages apexPages, Id agreementTestId){
        m_configs = configs;
        m_agreementTestId = agreementTestId;
        m_teamRoleMatrix = teamRoleMatrix;
        m_dataProvider = dataProvider;
        m_utility = utility;
        m_userInfoSvc = userInfoSvc;
        m_apexPages = apexPages;
        initialize();
    }

    public String agreementName{
        get{
            return String.valueOf(agreementTest.Agreement__r.Name);
        }
    }

    public List<SelectOption> allowedActions{
        get{
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption(NONE,NONE));
            options.add(new SelectOption(SUBMIT_FOR_APPROVAL,SUBMIT_FOR_APPROVAL));
            return options;
        }   
    }

    public List<SelectOption> approvalPaths{
        get{
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption(NONE,NONE));
            options.add(new SelectOption(RM_PLUS_ONE, RM_PLUS_ONE));
            return options;
        }
    }

    public String ApprovalPathsUrl {
        get{
            return m_configs.get(AGREEMENT_APPROVAL_PATHS_ID);
        }
    }

    public List<SelectOption> approverOneList{
        get{
            if(approverOneList == null){
                approverOneList = m_teamRoleMatrix.GetSigners(agreementTest.Agreement__r.Borrower_Name__c);
            }
            return approverOneList;
        }
        private set;
    }

    public Boolean isApproverOneAvailable{
        get{
            return (approverOneList.size() > 1);
        }
    }

    public Boolean showApprovalPath{
        get{
            return m_isPendingApprovalSelected;
        }
    }

    public Boolean showCommittee{
        get{
            return (agreementTest.Approval_Process__c == EXECUTIVE_LOAN_COMMITTEE || agreementTest.Approval_Process__c == REGIONAL_LOAN_COMMITTEE);
        }
    }

    public Boolean showApproverOne{
        get{
            return (agreementTest.Approval_Process__c != NONE && !String.isEmpty(agreementTest.Approval_Process__c));
        }
    }

    public Boolean showApproverTwo{
        get{
            return (agreementTest.Approval_Process__c == RM_PLUS_ONE || agreementTest.Approval_Process__c == THREE_SIGNATURES);
        }
    }

    public Boolean showApproverThree{
        get{
            return (agreementTest.Approval_Process__c == THREE_SIGNATURES);
        }
    }

    public String isSubmitDisabled{
        get{
            if(m_hasPendingApprovalInProgress == true || m_isApprovalRequired == false || m_isActionReady == false){
                return 'true';
            }
            return (ddNextStatus != '') ? 'false' : 'true';
        }
    }

    public PageReference submitClicked(){
        List<ApexPages.Message> validationErrors = getValidationErrors();
        if(validationErrors.size() == 0 && m_isPendingApprovalSelected){
            m_dataProvider.saveAgreementTest(agreementTest);
            submitAgreementTestForApproval();
            return m_agreementTestViewPage;
        }
        displayMessages(validationErrors);     
        return null;            
    }

    public PageReference cancelClicked(){
        return m_agreementTestViewPage;
    }

    public Agreement_Test__c agreementTest{
        get{
            if(agreementTest == null){
                agreementTest = m_dataProvider.getAgreementTestById(m_agreementTestId);
            }
            return agreementTest;
        }
        private set;
    }

    private void initialize(){
        ddNextStatus = SUBMIT_FOR_APPROVAL;
        displayMessages(getInitializationErrors());
    }

    private void displayMessages(List<ApexPages.Message> messages){
        for(ApexPages.Message msg : messages){
            m_apexPages.addMessage(msg.getSeverity(),msg.getSummary());
        }
    }

    private List<ApexPages.Message> getInitializationErrors(){
        List<ApexPages.Message> errors = new List<ApexPages.Message>();
        if(m_hasPendingApprovalInProgress){
            errors.add(new ApexPages.Message(ApexPages.Severity.INFO, 'Pending approval already in progress'));
        }else if(m_isApprovalRequired == false){
            errors.add(new ApexPages.Message(ApexPages.Severity.INFO, 'This Agreement Test does not require approval'));
        }else if(m_isActionReady == false){
            errors.add(new ApexPages.Message(ApexPages.Severity.INFO, 'Please select an "Action" for this Agreement Test before submitting for approval'));
        }
        return errors;
    }

    private List<ApexPages.Message> getValidationErrors(){
        List<ApexPages.Message> errors = new List<ApexPages.Message>();
        if(agreementTest.Approval_Process__c == RM_PLUS_ONE){
            if(agreementTest.Approver_One__c == null || agreementTest.Approver_Two__c == null){
                errors.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select Approver One and Approver Two'));
            }else if(agreementTest.Approver_One__c == agreementTest.Approver_Two__c){
                errors.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'Cannot assign the same approver to more than one approval level'));
            }
        }else if(agreementTest.Approval_Process__c == THREE_SIGNATURES){
            if(agreementTest.Approver_One__c == null || agreementTest.Approver_Two__c == null || agreementTest.Approver_Three__c == null){
                errors.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select Approver One, Approver Two, and Approver Three'));
            }else if(agreementTest.Approver_One__c == agreementTest.Approver_Two__c || agreementTest.Approver_One__c == agreementTest.Approver_Three__c || agreementTest.Approver_Two__c == agreementTest.Approver_Three__c){
                errors.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'Cannot assign the same approver to more than one approval level'));
            }
        }else if(agreementTest.Approval_Process__c == EXECUTIVE_LOAN_COMMITTEE || agreementTest.Approval_Process__c == REGIONAL_LOAN_COMMITTEE){
            if(agreementTest.Approver_One__c == null){
                errors.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select Approver One'));
            } 
        }else{
            errors.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select an Approval Process'));
        }
        return errors;
    }

    private void submitAgreementTestForApproval(){
        m_utility.submitForApproval(agreementTest.Id);                    
        if(m_isUserSameAsApproverOne) m_utility.approveNextStep(agreementTest.Id);                    
    }

    private Boolean m_hasPendingApprovalInProgress{
        get{
            if(m_hasPendingApprovalInProgress == null){
                m_hasPendingApprovalInProgress = (m_utility.pendingApprovalSteps(agreementTest.Id) > 0);
            }
            return m_hasPendingApprovalInProgress;
        }
        set;
    }

    private Boolean m_isApprovalRequired{
        get{
            return m_dataProvider.isApprovalRequired(agreementTest);
        }
    }

    private Boolean m_isActionReady{
        get{
            return m_dataProvider.isActionReady(agreementTest);
        }
    }

    private Boolean m_isPendingApprovalSelected{
        get{
            return (ddNextStatus == SUBMIT_FOR_APPROVAL);
        }
    }

    private Boolean m_isUserSameAsApproverOne{   
        get{
           return (agreementTest.Approver_One__c == m_userInfoSvc.getCurrentUserId());
        }
    }

    private PageReference m_agreementTestViewPage{
        get{
            PageReference pg = new PageReference('/' + agreementTest.Id);
            pg.setRedirect(true);
            return pg;
        }
    }
}