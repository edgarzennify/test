@IsTest
private class AgreementControllerTest {

    private final static AgreementController sut;
    private final static AgreementMock.ofIAgreementControllerDataProvider mockDataProvider;
    private final static AgreementMock.ofIAgreementApprovalInfo mockApprovalInfo;
    private final static AgreementMock.ofIAgreementStatusManager mockStatusManager;
    private final static AgreementMock.ofIAgreementValidator mockValidator;
    private final static Mock.ofIUserInfoService mockUserInfoSvc;
    private final static AgreementMock.ofILoanAppRepository mockLoanAppRepository;
    private final static Agreement__c agreement;
    private final static Mock.ofIConfigurations mockConfigs;
    private final static Mock.ofIReportUrlProvider mockReportUrlProvider;

    static {
        agreement = new Agreement__c(Id='a28f000000091AN');
        mockDataProvider = new AgreementMock.ofIAgreementControllerDataProvider();
        mockApprovalInfo = new AgreementMock.ofIAgreementApprovalInfo();
        mockStatusManager = new AgreementMock.ofIAgreementStatusManager();
        mockValidator = new AgreementMock.ofIAgreementValidator();
        mockUserInfoSvc = new Mock.ofIUserInfoService();
        mockLoanAppRepository = new AgreementMock.ofILoanAppRepository();
        mockReportUrlProvider = new Mock.ofIReportUrlProvider();
        mockConfigs = new Mock.ofIConfigurations();
        sut = new AgreementController(mockDataProvider,mockApprovalInfo,mockStatusManager,mockValidator,mockUserInfoSvc,agreement.Id,mockLoanAppRepository, mockConfigs, mockReportUrlProvider);
    }

    @IsTest 
    static void it_should_call_the_agreementStatusManager_when_calling_AdminMakeNew() {
        Id agreementId = ObjectFactory.getFakeId(Agreement__c.SObjectType, '1');
        Agreement__c testAgreement = new Agreement__c(Id = agreementId);

        sut.agmt = testAgreement;
        sut.AdminMakeNew();

        mockStatusManager.verify('MakeNewAdminBackdoor', new List<Object>{sut.agmt.Id}, Times.Once);
    }

    @IsTest
    static void it_should_return_false_when_agmt_record_type_is_null() {
        Id agreementId = ObjectFactory.getFakeId(Agreement__c.SObjectType, '1');
        Agreement__c testAgreement = new Agreement__c(Id = agreementId);

        sut.agmt = testAgreement;
        
        String result = sut.AgreementPendingStatus;

        System.assertEquals('false', result);    
    }

    @IsTest
    static void it_should_return_report_url() {
        Id agreementId = ObjectFactory.getFakeId(Agreement__c.SObjectType, '1');
        Agreement__c testAgreement = new Agreement__c(Id = agreementId);
        String agmtReportId = '123';        
        
        mockConfigs.setup('get',ApexMoq.Arguments.HAVE_ANY_VALUE).returns(agmtReportId);        
        
        sut.agmt = testAgreement;
        String result = sut.ReportUrl;

        mockReportUrlProvider.verify('getReportUrl', new List<Object>{agmtReportId, new List<String>{testAgreement.Id}}, Times.Once);
    }

    @IsTest
    static void it_should_toggle_the_boolean_EbAccountCollapse_when_ExpandCollapseEbAccount_is_called() {
        sut.EbAccountCollapse = true;

        sut.ExpandCollapseEbAccount();

        System.assertEquals(sut.EbAccountCollapse, false);
    }

    @IsTest
    static void it_should_toggle_the_boolean_PossibleBorrowersCollapse_when_ExpandCollapsePossibleBorrowersCollapse_is_called() {
        sut.PossibleBorrowersCollapse = true;

        sut.ExpandCollapsePossibleBorrowersCollapse();

        System.assertEquals(sut.PossibleBorrowersCollapse, false);
    }

    @IsTest
    static void it_should_show_something_when_is_pending_has_back_office_modification_and_has_not_own_approval_no_apps_no_accounts_related() {
        mockDataProvider.setup('getAgreementByID', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(agreement);
        mockDataProvider.setup('getAgreementClientRelationshipsByAgreementId', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(new List<Agreement_Client_Relationships__c>());
        mockApprovalInfo.setup('wasIndependentlyApproved', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(false);
        mockApprovalInfo.setup('hasApprovalInformation', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(true);
        mockStatusManager.setup('hasLoanApps', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(false);
        mockStatusManager.setup('getRecordType', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(Utility.recordTypeObject('Agreement__c', 'Pending'));

        sut.Initialize();              
        Boolean showOwnApproval = sut.showOwnApproval;
        Boolean showApprovalMinute = sut.showApprovalMinute;
        Boolean showApprovalDetails = sut.showApprovalDetails;
        Boolean showWorkflowInformation = sut.showWorkflowInformation;
        Boolean showAgreementFees = sut.showAgreementFees;
        Boolean showStageLog = sut.showStageLog;
        Boolean showWorkflowNextStep = sut.showWorkflowNextStep;
              
        System.assertEquals(true, showOwnApproval);
        System.assertEquals(false, showApprovalMinute);
        System.assertEquals(true, showApprovalDetails);
        System.assertEquals(true, showWorkflowInformation);
        System.assertEquals(true, showAgreementFees);
        System.assertEquals(true, showStageLog);
        System.assertEquals(true, showWorkflowNextStep);
    }
    
    @IsTest
    static void it_should_show_something_when_is_pending_has_back_office_modification_and_has_not_own_approval_has_apps_and_no_accounts_related() {
        mockDataProvider.setup('getAgreementByID', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(agreement);
        mockDataProvider.setup('getAgreementClientRelationshipsByAgreementId', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(new List<Agreement_Client_Relationships__c>());
        mockApprovalInfo.setup('wasIndependentlyApproved', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(false);
        mockApprovalInfo.setup('hasApprovalInformation', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(true);
        mockStatusManager.setup('hasLoanApps', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(true);
        mockStatusManager.setup('getRecordType', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(Utility.recordTypeObject('Agreement__c', 'Pending'));
        
        sut.Initialize();      
        Boolean showOwnApproval = sut.showOwnApproval;
        Boolean showApprovalMinute = sut.showApprovalMinute;
        Boolean showApprovalDetails = sut.showApprovalDetails;
        Boolean showWorkflowInformation = sut.showWorkflowInformation;
        Boolean showAgreementFees = sut.showAgreementFees;
        Boolean showStageLog = sut.showStageLog;
        Boolean showWorkflowNextStep = sut.showWorkflowNextStep;
              
        System.assertEquals(true, showOwnApproval);
        System.assertEquals(true, showApprovalMinute);
        System.assertEquals(false, showApprovalDetails);
        System.assertEquals(false, showWorkflowInformation);
        System.assertEquals(false, showAgreementFees);
        System.assertEquals(false, showStageLog);
        System.assertEquals(false, showWorkflowNextStep);
    }
    
    @IsTest
    static void it_should_show_something_when_is_pending_has_not_back_office_modification_and_has_own_approval_has_apps_and_no_accounts_related() {
        mockDataProvider.setup('getAgreementByID', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(agreement);
        mockDataProvider.setup('getAgreementClientRelationshipsByAgreementId', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(new List<Agreement_Client_Relationships__c>());
        mockApprovalInfo.setup('wasIndependentlyApproved', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(true);
        mockApprovalInfo.setup('hasApprovalInformation', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(true);
        mockStatusManager.setup('hasLoanApps', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(true);
        mockStatusManager.setup('getRecordType', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(Utility.recordTypeObject('Agreement__c', 'Pending'));

        sut.Initialize();
        Boolean showOwnApproval = sut.showOwnApproval;
        Boolean showApprovalMinute = sut.showApprovalMinute;
        Boolean showApprovalDetails = sut.showApprovalDetails;
        Boolean showWorkflowInformation = sut.showWorkflowInformation;
        Boolean showAgreementFees = sut.showAgreementFees;
        Boolean showStageLog = sut.showStageLog;
        Boolean showWorkflowNextStep = sut.showWorkflowNextStep;
              
        System.assertEquals(true, showOwnApproval);
        System.assertEquals(true, showApprovalMinute);
        System.assertEquals(true, showApprovalDetails);
        System.assertEquals(true, showWorkflowInformation);
        System.assertEquals(true, showAgreementFees);
        System.assertEquals(true, showStageLog);
        System.assertEquals(true, showWorkflowNextStep);
    }
    
    @IsTest
    static void it_should_show_something_when_is_pending_has_not_back_office_modification_and_has_own_approval_has_no_apps_and_no_accounts_related() {
        mockDataProvider.setup('getAgreementByID', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(agreement);
        mockDataProvider.setup('getAgreementClientRelationshipsByAgreementId', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(new List<Agreement_Client_Relationships__c>());
        mockApprovalInfo.setup('wasIndependentlyApproved', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(true);
        mockApprovalInfo.setup('hasApprovalInformation', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(true);
        mockStatusManager.setup('hasLoanApps', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(false);
        mockStatusManager.setup('getRecordType', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(Utility.recordTypeObject('Agreement__c', 'Pending'));
       
        sut.Initialize();    
        Boolean showOwnApproval = sut.showOwnApproval;
        Boolean showApprovalMinute = sut.showApprovalMinute;
        Boolean showApprovalDetails = sut.showApprovalDetails;
        Boolean showWorkflowInformation = sut.showWorkflowInformation;
        Boolean showAgreementFees = sut.showAgreementFees;
        Boolean showStageLog = sut.showStageLog;
        Boolean showWorkflowNextStep = sut.showWorkflowNextStep;
              
        System.assertEquals(true, showOwnApproval);
        System.assertEquals(false, showApprovalMinute);
        System.assertEquals(true, showApprovalDetails);
        System.assertEquals(true, showWorkflowInformation);
        System.assertEquals(true, showAgreementFees);
        System.assertEquals(true, showStageLog);
        System.assertEquals(true, showWorkflowNextStep);
    }
    
    @IsTest
    static void it_should_show_something_when_is_pending_has_not_back_office_modification_and_has_not_own_approval_has_apps_and_no_accounts_related() {
        mockDataProvider.setup('getAgreementByID', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(agreement);
        mockDataProvider.setup('getAgreementClientRelationshipsByAgreementId', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(new List<Agreement_Client_Relationships__c>());
        mockApprovalInfo.setup('wasIndependentlyApproved', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(false);
        mockApprovalInfo.setup('hasApprovalInformation', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(false);
        mockStatusManager.setup('hasLoanApps', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(true);
        mockStatusManager.setup('getRecordType', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(Utility.recordTypeObject('Agreement__c', 'Pending'));
        
        sut.Initialize();      
        Boolean showOwnApproval = sut.showOwnApproval;
        Boolean showApprovalMinute = sut.showApprovalMinute;
        Boolean showApprovalDetails = sut.showApprovalDetails;
        Boolean showWorkflowInformation = sut.showWorkflowInformation;
        Boolean showAgreementFees = sut.showAgreementFees;
        Boolean showStageLog = sut.showStageLog;
        Boolean showWorkflowNextStep = sut.showWorkflowNextStep;
              
        System.assertEquals(false, showOwnApproval);
        System.assertEquals(true, showApprovalMinute);
        System.assertEquals(false, showApprovalDetails);
        System.assertEquals(false, showWorkflowInformation);
        System.assertEquals(false, showAgreementFees);
        System.assertEquals(false, showStageLog);
        System.assertEquals(false, showWorkflowNextStep);
    }
    
    @IsTest
    static void it_show_show_appropriate_section_when_is_pending_AND_no_back_office_modification_AND_not_own_approval_AND_has_no_apps_AND_has_no_accts() {
        mockDataProvider.setup('getAgreementByID', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(agreement);
        mockDataProvider.setup('getAgreementClientRelationshipsByAgreementId', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(new List<Agreement_Client_Relationships__c>());
        mockApprovalInfo.setup('wasIndependentlyApproved', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(false);
        mockApprovalInfo.setup('hasApprovalInformation', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(false);
        mockApprovalInfo.setup('getApprovalMinute', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(null);
        mockStatusManager.setup('hasLoanApps', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(false);
        mockStatusManager.setup('getRecordType', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(Utility.recordTypeObject('Agreement__c', 'Pending'));       
        
        //Act
        sut.Initialize();
        boolean showOwnApproval = sut.showOwnApproval;
        boolean showApprovalMinute = sut.showApprovalMinute;
        boolean showAgreementFees = sut.showAgreementFees;
        boolean showStageLog = sut.showStageLog;
        boolean showWorkflowInformation = sut.showWorkflowInformation;
        boolean showWorkflowNextStep = sut.showWorkflowNextStep;
        
        //Assert
        system.assertEquals(true, showOwnApproval);
        system.assertEquals(false, showApprovalMinute);
        system.assertEquals(true, showAgreementFees);
        system.assertEquals(true, showStageLog);
        system.assertEquals(true, showWorkflowInformation);
        system.assertEquals(true, showWorkflowNextStep);
    }
    
    @IsTest
    static void it_should_show_something_when_is_active_AND_not_back_office_modification_AND_not_own_approval_AND_no_apps_AND_has_accounts() {
        mockDataProvider.setup('getAgreementByID', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(agreement);
        mockDataProvider.setup('getAgreementClientRelationshipsByAgreementId', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(new List<Agreement_Client_Relationships__c>());
        mockApprovalInfo.setup('wasIndependentlyApproved', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(false);
        mockApprovalInfo.setup('hasApprovalInformation', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(false);
        mockApprovalInfo.setup('getApprovalMinute', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(new EB_Loan_App_Minute__c());
        mockStatusManager.setup('hasLoanApps', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(false);
        mockStatusManager.setup('getRecordType', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(Utility.recordTypeObject('Agreement__c', 'Active'));
        
        sut.Initialize();      
        Boolean showOwnApproval = sut.showOwnApproval;
        Boolean showApprovalMinute = sut.showApprovalMinute;
        Boolean showApprovalDetails = sut.showApprovalDetails;
        Boolean showWorkflowInformation = sut.showWorkflowInformation;
        Boolean showAgreementFees = sut.showAgreementFees;
        Boolean showStageLog = sut.showStageLog;
        Boolean showWorkflowNextStep = sut.showWorkflowNextStep;
              
        System.assertEquals(false, showOwnApproval);
        System.assertEquals(true, showApprovalMinute);
        System.assertEquals(false, showApprovalDetails);
        System.assertEquals(false, showWorkflowInformation);
        System.assertEquals(false, showAgreementFees);
        System.assertEquals(false, showStageLog);
        System.assertEquals(false, showWorkflowNextStep);
    }
    
    @IsTest
    static void it_should_show_something_when_is_active_AND_has_back_office_modification_AND_has_own_approval_AND_no_apps_AND_no_accounts() {
        mockDataProvider.setup('getAgreementByID', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(agreement);
        mockDataProvider.setup('getAgreementClientRelationshipsByAgreementId', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(new List<Agreement_Client_Relationships__c>());
        mockApprovalInfo.setup('wasIndependentlyApproved', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(true);
        mockApprovalInfo.setup('hasApprovalInformation', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(true);
        mockApprovalInfo.setup('getApprovalMinute', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(null);
        mockStatusManager.setup('hasLoanApps', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(false);
        mockStatusManager.setup('getRecordType', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(Utility.recordTypeObject('Agreement__c', 'Active'));
        
        sut.Initialize();
        Boolean showOwnApproval = sut.showOwnApproval;
        Boolean showApprovalMinute = sut.showApprovalMinute;
        Boolean showApprovalDetails = sut.showApprovalDetails;
        Boolean showWorkflowInformation = sut.showWorkflowInformation;
        Boolean showAgreementFees = sut.showAgreementFees;
        Boolean showStageLog = sut.showStageLog;
        Boolean showWorkflowNextStep = sut.showWorkflowNextStep;
              
        System.assertEquals(true, showOwnApproval);
        System.assertEquals(false, showApprovalMinute);
        System.assertEquals(true, showApprovalDetails);
        System.assertEquals(true, showWorkflowInformation);
        System.assertEquals(true, showAgreementFees);
        System.assertEquals(true, showStageLog);
        System.assertEquals(false, showWorkflowNextStep);
    }
    
    @IsTest
    static void it_should_show_something_when_is_active_AND_has_back_office_modification_AND_no_own_approval_AND_no_apps_AND_yes_accounts() {
        mockDataProvider.setup('getAgreementByID', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(agreement);
        mockDataProvider.setup('getAgreementClientRelationshipsByAgreementId', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(new List<Agreement_Client_Relationships__c>());
        mockApprovalInfo.setup('wasIndependentlyApproved', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(false);
        mockApprovalInfo.setup('hasApprovalInformation', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(true);
        mockApprovalInfo.setup('getApprovalMinute', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(new EB_Loan_App_Minute__c());
        mockStatusManager.setup('hasLoanApps', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(false);
        mockStatusManager.setup('getRecordType', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(Utility.recordTypeObject('Agreement__c', 'Active'));
        
        sut.Initialize();
        Boolean showOwnApproval = sut.showOwnApproval;
        Boolean showApprovalMinute = sut.showApprovalMinute;
        Boolean showApprovalDetails = sut.showApprovalDetails;
        Boolean showWorkflowInformation = sut.showWorkflowInformation;
        Boolean showAgreementFees = sut.showAgreementFees;
        Boolean showStageLog = sut.showStageLog;
        Boolean showWorkflowNextStep = sut.showWorkflowNextStep;
              
        System.assertEquals(true, showOwnApproval);
        System.assertEquals(true, showApprovalMinute);
        System.assertEquals(false, showApprovalDetails);
        System.assertEquals(false, showWorkflowInformation);
        System.assertEquals(false, showAgreementFees);
        System.assertEquals(false, showStageLog);
        System.assertEquals(false, showWorkflowNextStep);
    }
    
    @IsTest
    static void it_should_show_something_when_is_active_AND_no_back_office_modification_AND_has_own_approval_AND_no_apps_AND_no_accounts() {
        mockDataProvider.setup('getAgreementByID', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(agreement);
        mockDataProvider.setup('getAgreementClientRelationshipsByAgreementId', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(new List<Agreement_Client_Relationships__c>());
        mockApprovalInfo.setup('wasIndependentlyApproved', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(true);
        mockApprovalInfo.setup('hasApprovalInformation', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(true);
        mockApprovalInfo.setup('getApprovalMinute', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(null);
        mockStatusManager.setup('hasLoanApps', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(false);
        mockStatusManager.setup('getRecordType', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(Utility.recordTypeObject('Agreement__c', 'Active'));
        
        sut.Initialize();
        Boolean showOwnApproval = sut.showOwnApproval;
        Boolean showApprovalMinute = sut.showApprovalMinute;
        Boolean showApprovalDetails = sut.showApprovalDetails;
        Boolean showWorkflowInformation = sut.showWorkflowInformation;
        Boolean showAgreementFees = sut.showAgreementFees;
        Boolean showStageLog = sut.showStageLog;
        Boolean showWorkflowNextStep = sut.showWorkflowNextStep;
              
        System.assertEquals(true, showOwnApproval);
        System.assertEquals(false, showApprovalMinute);
        System.assertEquals(true, showApprovalDetails);
        System.assertEquals(true, showWorkflowInformation);
        System.assertEquals(true, showAgreementFees);
        System.assertEquals(true, showStageLog);
        System.assertEquals(false, showWorkflowNextStep);
    }
    
    @IsTest
    static void it_should_show_the_edit_button_when_the_agreement_is_pending() {
        mockDataProvider.setup('getAgreementByID', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(agreement);
        mockDataProvider.setup('getAgreementClientRelationshipsByAgreementId', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(new List<Agreement_Client_Relationships__c>());
        mockStatusManager.setup('getRecordType', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(Utility.recordTypeObject('Agreement__c', 'Pending'));
        
        sut.Initialize();
        Boolean isVisible = sut.isEditButtonVisible;
        
        System.assertEquals(true, isVisible);
    }
    
    @IsTest
    static void it_should_show_the_edit_button_when_the_agreement_is_active() {
        mockDataProvider.setup('getAgreementByID', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(agreement);
        mockDataProvider.setup('getAgreementClientRelationshipsByAgreementId', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(new List<Agreement_Client_Relationships__c>());
        mockStatusManager.setup('getRecordType', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(Utility.recordTypeObject('Agreement__c', 'Active'));
        
        sut.Initialize();
        Boolean isVisible = sut.isEditButtonVisible;
        
        System.assertEquals(true, isVisible);
    }

    @IsTest
    static void it_should_return_the_ACTIVE_finreq_fields_for_an_ACTIVE_agreement() {
        Account testEntity = new Account();
        testEntity.Name = 'TEST ENTITY';
        testEntity.Personal_Financial_Statement__c = 'Yes';
        testEntity.Personal_Financial_Statement_Frequency__c = 'Annually';
        testEntity.Annual_Financial_Statements__c = 'Yes';
        testEntity.Annual_Statement_Quality__c = 'Self Prepared';
        testEntity.Fiscal_Year_End_Date__c = '01/02';
        testEntity.Annual_Stmt_Days_Due_After_Fiscal_Y_E__c = -1;
        testEntity.Annual_Financial_Statement_Period_Other__c = 121;
        testEntity.Other_Type__c = 'Consolidated & Consolidating';
        testEntity.Entities_To_Combine__c = 'me and you';
        testEntity.Interim_Statements__c = 'Semi-Annually';
        testEntity.Interim_Stm_Prepared_By__c = 'Audited by CPA';
        testEntity.Interim_Stmt_Days_Due_After_Period_End__c = -1;
        testEntity.Interim_Statement_Period_Other__c = 60;
        testEntity.Tax_Returns__c = 'Yes';
        testEntity.Tax_Return_Days_Due_After_Filing__c = -1;
        testEntity.Tax_Return_Period_Other__c = 90;

        Agreement__c testAgmt = new Agreement__c(Id='a28f00000008zGI');
        testAgmt.RecordType = Utility.recordTypeObject('Agreement__c','Active');

        Agreement_Client_Relationships__c agmtClientRel = new Agreement_Client_Relationships__c();
        agmtClientRel.Entity__r = testEntity;
        agmtClientRel.Agreement__c = testAgmt.Id;

        mockDataProvider.setup('getAgreementByID', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(testAgmt);
        mockStatusManager.setup('getRecordType', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(testAgmt.RecordType);
        mockDataProvider.setup('getAgreementClientRelationshipsByAgreementId', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(new List<Agreement_Client_Relationships__c> {agmtClientRel});
        
        sut.Initialize();

        List<AgreementController.FinancialRequirement> finRptReqs = sut.financialRequirements;
        AgreementController.FinancialRequirement finRptReqsPersFinancialStmt;
        AgreementController.FinancialRequirement finRptReqsAnnualFinancialStmt;
        AgreementController.FinancialRequirement finRptReqsInterimStmt;
        AgreementController.FinancialRequirement finRptReqsTaxReturn;
        for (AgreementController.FinancialRequirement finRpt : finRptReqs) {
            if (finRpt.documentType == 'Personal Financial Statement') {
                finRptReqsPersFinancialStmt = finRpt;
            } else if (finRpt.documentType == 'Annual Financial Statement') {
                finRptReqsAnnualFinancialStmt = finRpt;
            } else if (finRpt.documentType == 'Interim Statement') {
                finRptReqsInterimStmt = finRpt;
            } else if (finRpt.documentType == 'Tax Return') {
                finRptReqsTaxReturn = finRpt;
            }
        }

        System.assertNotEquals(null, finRptReqs);
        System.assertEquals(4, finRptReqs.size());
        System.assertEquals('Personal Financial Statement', finRptReqsPersFinancialStmt.documentType);
        System.assertEquals('Frequency: Annually', finRptReqsPersFinancialStmt.details);
        System.assertEquals('Annual Financial Statement', finRptReqsAnnualFinancialStmt.documentType);
        System.assertEquals('Days Due After Period End: Other (121) / Quality: Self Prepared / Other Type: Consolidated & Consolidating', finRptReqsAnnualFinancialStmt.details);
        System.assertEquals('Interim Statement', finRptReqsInterimStmt.documentType);
        System.assertEquals('Semi-Annually / Days Due After Period End: Other (60) / Quality: Audited by CPA', finRptReqsInterimStmt.details);
        System.assertEquals('Tax Return', finRptReqsTaxReturn.documentType);
        System.assertEquals('Tax Return Days Due After Filing: Other (90)', finRptReqsTaxReturn.details);
    }

    @IsTest
    static void it_should_return_the_PENDING_finreq_fields_for_a_PENDING_agreement() {
        Account testEntity = new Account();
        testEntity.Name = 'TEST ENTITY';
        testEntity.Pending_PFS__c = 'Yes';
        testEntity.Pending_PFS_Frequency__c = 'Annually';
        testEntity.Pending_AFS__c = 'Yes';
        testEntity.Pending_AFS_Quality__c = 'Self Prepared';
        testEntity.Pending_AFS_FYE__c = '01/02';
        testEntity.Pending_AFS_Days_Due_After_FYE__c = -1;
        testEntity.Pending_AFS_Period_Other__c = 121;
        testEntity.Pending_AFS_Other_Type__c = 'Consolidated & Consolidating';
        testEntity.Pending_AFS_Entities_To_Combine__c = 'me and you';
        testEntity.Pending_IntStmts__c = 'Semi-Annually';
        testEntity.Pending_IntStmts_Quality__c = 'Audited by CPA';
        testEntity.Pending_IntStmts_Days_Due_After_PE__c = -1;
        testEntity.Pending_IntStmts_Period_Other__c = 60;
        testEntity.Pending_TaxReturns__c = 'Yes';
        testEntity.Pending_TaxReturns_Days_Due_After_Filing__c = -1;
        testEntity.Pending_TaxReturns_Period_Other__c = 90;

        Agreement__c testAgmt = new Agreement__c(Id='a28f00000008zGI');
        testAgmt.RecordType = Utility.recordTypeObject('Agreement__c','Pending');

        Agreement_Client_Relationships__c agmtClientRel = new Agreement_Client_Relationships__c();
        agmtClientRel.Entity__r = testEntity;
        agmtClientRel.Agreement__c = testAgmt.Id;

        mockDataProvider.setup('getAgreementByID', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(testAgmt);
        mockStatusManager.setup('getRecordType', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(testAgmt.RecordType);
        mockDataProvider.setup('getAgreementClientRelationshipsByAgreementId', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(new List<Agreement_Client_Relationships__c> {agmtClientRel});
        
        sut.Initialize();

        List<AgreementController.FinancialRequirement> finRptReqs = sut.financialRequirements;
        AgreementController.FinancialRequirement finRptReqsPersFinancialStmt;
        AgreementController.FinancialRequirement finRptReqsAnnualFinancialStmt;
        AgreementController.FinancialRequirement finRptReqsInterimStmt;
        AgreementController.FinancialRequirement finRptReqsTaxReturn;
        for (AgreementController.FinancialRequirement finRpt : finRptReqs) {
            if (finRpt.documentType == 'Personal Financial Statement') {
                finRptReqsPersFinancialStmt = finRpt;
            } else if (finRpt.documentType == 'Annual Financial Statement') {
                finRptReqsAnnualFinancialStmt = finRpt;
            } else if (finRpt.documentType == 'Interim Statement') {
                finRptReqsInterimStmt = finRpt;
            } else if (finRpt.documentType == 'Tax Return') {
                finRptReqsTaxReturn = finRpt;
            }
        }

        System.assertNotEquals(null, finRptReqs);
        System.assertEquals(4, finRptReqs.size());
        System.assertEquals('Personal Financial Statement', finRptReqsPersFinancialStmt.documentType);
        System.assertEquals('Frequency: Annually', finRptReqsPersFinancialStmt.details);
        System.assertEquals('Annual Financial Statement', finRptReqsAnnualFinancialStmt.documentType);
        System.assertEquals('Days Due After Period End: Other (121) / Quality: Self Prepared / Other Type: Consolidated & Consolidating', finRptReqsAnnualFinancialStmt.details);
        System.assertEquals('Interim Statement', finRptReqsInterimStmt.documentType);
        System.assertEquals('Semi-Annually / Days Due After Period End: Other (60) / Quality: Audited by CPA', finRptReqsInterimStmt.details);
        System.assertEquals('Tax Return', finRptReqsTaxReturn.documentType);
        System.assertEquals('Tax Return Days Due After Filing: Other (90)', finRptReqsTaxReturn.details);
    }

    @IsTest
    static void it_should_return_the_ARCHIVE_finreq_fields_for_an_ARCHIVE_agreement() {
        Account testEntity = new Account();
        testEntity.Name = 'TEST ENTITY';

        Agreement__c testAgmt = new Agreement__c(Id='a28f00000008zGI');
        testAgmt.RecordType = Utility.recordTypeObject('Agreement__c','Archive');

        Agreement_Client_Relationships__c agmtClientRel = new Agreement_Client_Relationships__c();
        agmtClientRel.Entity__r = testEntity;
        agmtClientRel.Agreement__c = testAgmt.Id;
        agmtClientRel.Personal_Financial_Statement__c = 'Yes';
        agmtClientRel.Personal_Financial_Statement_Frequency__c = 'Annually';
        agmtClientRel.Annual_Financial_Statements__c = 'Yes';
        agmtClientRel.Annual_Statement_Quality__c = 'Self Prepared';
        agmtClientRel.Fiscal_Year_End_Date__c = '01/02';
        agmtClientRel.Annual_Stmt_Days_Due_After_Fiscal_Y_E__c = -1;
        agmtClientRel.Annual_Financial_Statement_Period_Other__c = 121;
        agmtClientRel.Other_Type__c = 'Consolidated & Consolidating';
        agmtClientRel.Entities_To_Combine__c = 'me and you';
        agmtClientRel.Interim_Statements__c = 'Semi-Annually';
        agmtClientRel.Interim_Stm_Prepared_By__c = 'Audited by CPA';
        agmtClientRel.Interim_Stmt_Days_Due_After_Period_End__c = -1;
        agmtClientRel.Interim_Statement_Period_Other__c = 60;
        agmtClientRel.Tax_Returns__c = 'Yes';
        agmtClientRel.Tax_Return_Days_Due_After_Filing__c = -1;
        agmtClientRel.Tax_Return_Period_Other__c = 90;

        mockDataProvider.setup('getAgreementByID', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(testAgmt);
        mockStatusManager.setup('getRecordType', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(testAgmt.RecordType);
        mockDataProvider.setup('getAgreementClientRelationshipsByAgreementId', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(new List<Agreement_Client_Relationships__c> {agmtClientRel});
        
        sut.Initialize();

        List<AgreementController.FinancialRequirement> finRptReqs = sut.financialRequirements;
        AgreementController.FinancialRequirement finRptReqsPersFinancialStmt;
        AgreementController.FinancialRequirement finRptReqsAnnualFinancialStmt;
        AgreementController.FinancialRequirement finRptReqsInterimStmt;
        AgreementController.FinancialRequirement finRptReqsTaxReturn;
        for (AgreementController.FinancialRequirement finRpt : finRptReqs) {
            if (finRpt.documentType == 'Personal Financial Statement') {
                finRptReqsPersFinancialStmt = finRpt;
            } else if (finRpt.documentType == 'Annual Financial Statement') {
                finRptReqsAnnualFinancialStmt = finRpt;
            } else if (finRpt.documentType == 'Interim Statement') {
                finRptReqsInterimStmt = finRpt;
            } else if (finRpt.documentType == 'Tax Return') {
                finRptReqsTaxReturn = finRpt;
            }
        }

        System.assertNotEquals(null, finRptReqs);
        System.assertEquals(4, finRptReqs.size());
        System.assertEquals('Personal Financial Statement', finRptReqsPersFinancialStmt.documentType);
        System.assertEquals('Frequency: Annually', finRptReqsPersFinancialStmt.details);
        System.assertEquals('Annual Financial Statement', finRptReqsAnnualFinancialStmt.documentType);
        System.assertEquals('Days Due After Period End: Other (121) / Quality: Self Prepared / Other Type: Consolidated & Consolidating', finRptReqsAnnualFinancialStmt.details);
        System.assertEquals('Interim Statement', finRptReqsInterimStmt.documentType);
        System.assertEquals('Semi-Annually / Days Due After Period End: Other (60) / Quality: Audited by CPA', finRptReqsInterimStmt.details);
        System.assertEquals('Tax Return', finRptReqsTaxReturn.documentType);
        System.assertEquals('Tax Return Days Due After Filing: Other (90)', finRptReqsTaxReturn.details);
    }

    @IsTest
    static void it_should_call_the_loan_app_repository_when_getting_included_loan_app_relationships() {
        Agreement_Client_Relationships__c agmtClient = new Agreement_Client_Relationships__c(Id='a24000000000000');
        mockDataProvider.setup('getAgreementClientRelationshipsByAgreementId', new List<Object>{agreement.Id}).returns(new List<Agreement_Client_Relationships__c>{agmtClient});
        mockDataProvider.setup('getAgreementByID', new List<Object>{agreement.Id}).Returns(agreement);

        sut.initialize();
        List<DmLoanApp> loanAppRels = sut.IncludedLoanApps;

        mockLoanAppRepository.verify('getIncludedLoanApps', new List<Object>{agreement.Id}, Times.Once);
    }

    @IsTest
    static void it_should_exclude_the_selected_loan_app() {
        Id selectedLoanAppId = ObjectFactory.getFakeId(EB_Loan_Application__c.SObjectType, '1');
        Agreement_Client_Relationships__c agmtClient = new Agreement_Client_Relationships__c(Id='a24000000000000');
        mockDataProvider.setup('getAgreementClientRelationshipsByAgreementId', new List<Object>{agreement.Id}).returns(new List<Agreement_Client_Relationships__c>{agmtClient});
        mockDataProvider.setup('getAgreementByID', new List<Object>{agreement.Id}).Returns(agreement);

        sut.initialize();
        sut.selectedLoanApp = selectedLoanAppId;
        sut.excludeLoanApp();

        mockLoanAppRepository.verify('excludeLoanApp', new List<Object>{agreement.Id, selectedLoanAppId}, Times.Once);
    }

    @IsTest
    static void it_should_include_the_selected_loan_app() {
        Id selectedLoanAppId = ObjectFactory.getFakeId(EB_Loan_Application__c.SObjectType, '1');
        Agreement_Client_Relationships__c agmtClient = new Agreement_Client_Relationships__c(Id='a24000000000000');
        mockDataProvider.setup('getAgreementClientRelationshipsByAgreementId', new List<Object>{agreement.Id}).returns(new List<Agreement_Client_Relationships__c>{agmtClient});
        mockDataProvider.setup('getAgreementByID', new List<Object>{agreement.Id}).Returns(agreement);

        sut.initialize();
        sut.selectedLoanApp = selectedLoanAppId;
        sut.includeLoanApp();

        mockLoanAppRepository.verify('includeLoanApp', new List<Object>{agreement.Id, selectedLoanAppId}, Times.Once);
    }

    // legacy tests
    @IsTest
    static void it_should_call_the_default_controller_constructor() {
        TestUtilities.createLoanAppStages();
        Account entity = ObjectFactory.getValidEntity('test entity');
        EB_Account__c  ebAccount = ObjectFactory.getEBAccount('Test Account Title', '12345-15', entity);
        EB_Loan_Packet__c ebLoanPacket = ObjectFactory.getLoanPacket(entity);
        EB_Loan_Application__c loanApp = ObjectFactory.getLoanApplication(ebLoanPacket, ebAccount, '12345-15');
        Agreement__c testAgreement = new Agreement__c(name='test');
        insert testAgreement;
        Agreement_Client_Relationships__c relClient = new Agreement_Client_Relationships__c();
        relClient.Agreement__c = testAgreement.Id;
        relClient.Entity__c = entity.Id;
        insert relClient;
        Agreement_Financial_Documents__c doc = new Agreement_Financial_Documents__c();
        doc.Agreement_Client_Relationship__c = relClient.Id;
        doc.Agreement__c = testAgreement.Id;
        doc.RecordTypeId = utility.RecordTypeObject('Agreement_Financial_Documents__c','Personal Financial Statement').Id;
        insert doc;
        Agreement_Subordination__c sub = new Agreement_Subordination__c();
        sub.Agreement__c = testAgreement.Id;
        sub.Creditor__c = entity.Id;
        insert sub;
        Agreement_Test__c testAgmt = new Agreement_Test__c();
        testAgmt.Agreement__c = testAgreement.Id;
        insert testAgmt;
        Agreement_Fee__c fee = new Agreement_Fee__c();
        fee.Agreement__c = testAgreement.Id;
        insert fee;
        Agreement_Loan_Application_Relationship__c loanrel = new Agreement_Loan_Application_Relationship__c();
        loanrel.Agreement__c = testAgreement.Id;
        loanrel.Loan_Application__c = loanApp.Id;
        insert loanrel;
        Agreement_EB_Account_Relationship__c ebrel = new Agreement_EB_Account_Relationship__c();
        ebrel.Agreement__c = testAgreement.Id;
        ebrel.Loan_Account__c = ebAccount.Id;
        insert ebrel;
        
        PageReference pr = Page.Agreement;
        test.setCurrentPage(pr);
        
        ApexPages.currentPage().getParameters().put('Id', testAgreement.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(testAgreement);
        AgreementController xsut  = new AgreementController(sc);    
        xsut.initialize();         
        xsut.selectedEntity = entity.Id;
        xsut.selectedEbAccount = ebAccount.Id;
        xsut.selectedLoanApp = loanApp.Id;
        xsut.selectedSubordinationId = sub.Id;
        xsut.selectedAgreementFeeId = fee.Id;
        xsut.clients = new List<Account>{entity};
        AgreementController.DocumentWrapper dw = new AgreementController.DocumentWrapper();
        dw.financialDocType = 'Personal Financial Statement';
        dw.financialDocument  = doc;
        dw.overridden = false;
        xsut.finDocumentWrapper = new List<AgreementController.DocumentWrapper>{dw};
        AgreementController.FinancialRequirement afinancial = new AgreementController.FinancialRequirement('Personal Financial Statement', 'test client', '30', 'Monthly', '', '2', 'test', '');        
        AgreementController.Relationship rel = new AgreementController.Relationship(relClient.Id, 'test client');
        AgreementController.RelatedEntity relComparable = new AgreementController.RelatedEntity(entity,rel);
        
        PageReference pg = xsut.includeLoanApp();
        xsut.selectedLoanApp = loanrel.Id;
        pg = xsut.excludeLoanApp();
        
        pg = xsut.closeDialog();
        pg = xsut.modify();
        pg = xsut.WorkflowNextStep();
        pg = xsut.MakeActive();
        pg = xsut.MakeArchive();
        pg = xsut.AdminMakeActive();
        pg = xsut.AdminMakePending();
        pg = xsut.AdminMakeArchive();
        xsut.selectedLoanApp = loanApp.Id;
        xsut.selectedLoanApp = loanrel.Id;
        pg = xsut.includeEbAccount();
        pg = xsut.editEntity();
    }
    
    @IsTest
    static void it_should_call_all_the_methods_in_the_controller() {
        TestUtilities.createLoanAppStages();
        Account entity = ObjectFactory.getValidEntity('test entity');
        EB_Account__c  ebAccount = ObjectFactory.getEBAccount('Test Account Title', '12345-15', entity);
        EB_Loan_Packet__c ebLoanPacket = ObjectFactory.getLoanPacket(entity);
        EB_Loan_Application__c loanApp = ObjectFactory.getLoanApplication(ebLoanPacket, ebAccount, '12345-15');
        Agreement__c testAgreement = new Agreement__c();
        testAgreement.name = 'test';
        testAgreement.ErrorMessages__c = 'test';
        testAgreement.WarningMessages__c = 'test1';
        testAgreement.RecordTypeId = Utility.RecordTypeObject('Agreement__c', 'Pending').Id;
        insert testAgreement;
        Agreement_Client_Relationships__c relClient = new Agreement_Client_Relationships__c();
        relClient.Agreement__c = testAgreement.Id;
        relClient.Entity__c = entity.Id;
        insert relClient;
        Agreement_Financial_Documents__c doc = new Agreement_Financial_Documents__c();
        doc.Agreement_Client_Relationship__c = relClient.Id;
        doc.Agreement__c = testAgreement.Id;
        insert doc;
        Agreement_Subordination__c sub = new Agreement_Subordination__c();
        sub.Agreement__c = testAgreement.Id;
        sub.Creditor__c = entity.Id;
        insert sub;
        Agreement_Test__c testAgmt = new Agreement_Test__c();
        testAgmt.Agreement__c = testAgreement.Id;
        insert testAgmt;
        Agreement_Fee__c fee = new Agreement_Fee__c();
        fee.Agreement__c = testAgreement.Id;
        insert fee;
        Agreement_Loan_Application_Relationship__c loanrel = new Agreement_Loan_Application_Relationship__c();
        loanrel.Agreement__c = testAgreement.Id;
        loanrel.Loan_Application__c = loanApp.Id;
        insert loanrel;
        Agreement_EB_Account_Relationship__c ebrel = new Agreement_EB_Account_Relationship__c();
        ebrel.Agreement__c = testAgreement.Id;
        ebrel.Loan_Account__c = ebAccount.Id;
        insert ebrel;
        
        PageReference pr = Page.Agreement;
        test.setCurrentPage(pr);
        
        ApexPages.currentPage().getParameters().put('Id', testAgreement.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(testAgreement);
        AgreementController xsut  = new AgreementController(sc);   
        xsut.initialize();          
        xsut.selectedEntity = entity.Id;
        xsut.selectedEbAccount = ebAccount.Id;
        xsut.selectedLoanApp = loanApp.Id;
        xsut.selectedSubordinationId = sub.Id;
        xsut.selectedAgreementFeeId = fee.Id;
        xsut.clients = new List<Account>{entity};
        AgreementController.DocumentWrapper dw = new AgreementController.DocumentWrapper();
        dw.financialDocType = 'Personal Financial Statement';
        dw.financialDocument  = doc;
        dw.overridden = false;

        xsut.finDocumentWrapper = new List<AgreementController.DocumentWrapper>{dw};
        AgreementController.FinancialRequirement afinancial = new AgreementController.FinancialRequirement('Personal Financial Statement', 'test client', '30', 'Monthly', '', '2', 'test', '');        
        afinancial.documentType = 'Personal Financial Statement';
        String details = afinancial.details;
        afinancial.documentType = 'Annual Financial Statement';
        details = afinancial.details;
        afinancial.documentType = 'Interim Statement';
        details = afinancial.details;
        afinancial.documentType = 'Tax Return';
        details = afinancial.details;
        AgreementController.Relationship rel = new AgreementController.Relationship(relClient.Id, 'test client');
        AgreementController.RelatedEntity relComparable = new AgreementController.RelatedEntity(entity,rel);
        String testString = relComparable.Name;
        testString =  relComparable.Address;
        testString = relComparable.entityType;
        testString = relComparable.RelatedBy;
        testString = relComparable.AbridgedRelatedBy;
        integer compare = relComparable.compareTo(relComparable);
        
        
        PageReference pg = xsut.includeLoanApp();
        xsut.selectedLoanApp = loanrel.Id;
        
        
        String url = xsut.ReportUrl;
        
        EB_Loan_App_Minute__c min = xsut.approvalMinute;
        String approveTest = xsut.approvalminuteurl;
        
        boolean check = xsut.IsArchive;
        check = xsut.IsActive;
        check = xsut.IsPending;
        
        xsut.initializeEntitySpecificDocs();        
       
        AgreementController.IncludedEntity IncludedEntity = new  AgreementController.IncludedEntity(entity, testAgreement, new List<Agreement_Client_Relationships__c> {relClient});
        xsut.IncludedEntities = null;
        List<AgreementController.IncludedEntity> objIncludedEntities = xsut.IncludedEntities;
        xsut.IncludedEntitiesSet = null;
        set<Id> ids = xsut.IncludedEntitiesSet;
        
        xsut.ExcludedEntities = null; 
        List<AgreementController.RelatedEntity> relEntities = xsut.ExcludedEntities;
        
        Integer counter = xsut.excludedEntitiesCount;
        counter = xsut.includedEntitiesCount;
        counter = xsut.agmtDocumentWrapperCount;
        counter = xsut.finDocumentWrapperCount;
        
        List<EB_Account_Relationship__c> EbAccountRelationships = xsut.EbAccountRelationships;
        List<Agreements.LoanAppEntityRelationship> LoanApplicationRelationships = xsut.LoanApplicationRelationships;
        
        xsut.IncludeEntity();
        testAgreement.RecordTypeId = Utility.RecordTypeObject('Agreement__c', 'Pending').Id;
        
        update testAgreement;
        testAgreement.ErrorMessages__c = 'test';
        testAgreement.WarningMessages__c = 'test1';
        xsut.RenderErrorMessages();
        xsut.RenderWarningMessages();
        xsut.initializeEntitySpecificDocs();
    }
    
    @IsTest
    static void it_should_be_able_to_edit_agreement_when_stage_backOfficeModification() {
        TestUtilities.createLoanAppStages();
        Profile p = [SELECT Id, Name FROM Profile WHERE Name=:'System Administrator']; 
        User user = ObjectFactory.getUser('test99', 'user99', 'tuser99@enterprisebank.sfdc.test', false); 
        user.ProfileId = p.Id;
        //user.Two_Signature_Authority__c=true;
        insert user;  
        Account entity = ObjectFactory.getValidEntity('test entity');
        Agreement__c testAgreement = new Agreement__c();
        testAgreement.name = 'test';
        testAgreement.Primary_Borrower__c = entity.Id;
        testAgreement.RecordTypeId = Utility.RecordTypeObject('Agreement__c', 'Pending').Id;
        insert testAgreement;
        testAgreement.Stage__c = TestUtilities.getStageByName('Back Office Modification').Id;
        update testAgreement;
        PageReference pr = Page.Agreement;
        test.setCurrentPage(pr);
        System.runAs(user){      
            ApexPages.currentPage().getParameters().put('Id', testAgreement.Id);
            ApexPages.StandardController sc = new ApexPages.StandardController(testAgreement);
            AgreementController xsut  = new AgreementController(sc);  
            xsut.initialize();
        
            boolean canEdit = xsut.canEditAgreement;
            system.assertEquals(true, canEdit); 
        }
    }
    
    @IsTest
    static void it_should_be_able_to_edit_agreement_when_stage_new_and_recordtype_pending() {
        TestUtilities.createLoanAppStages();
        Account entity = ObjectFactory.getValidEntity('test entity');
        Agreement__c testAgreement = new Agreement__c();
        testAgreement.name = 'test';
        testAgreement.Primary_Borrower__c = entity.Id;
        testAgreement.Stage__c = TestUtilities.getStageByName('New').Id;
        testAgreement.RecordTypeId = Utility.RecordTypeObject('Agreement__c', 'Pending').Id;
        insert testAgreement;
        PageReference pr = Page.Agreement;
        test.setCurrentPage(pr);
        
        ApexPages.currentPage().getParameters().put('Id', testAgreement.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(testAgreement);
        AgreementController xsut  = new AgreementController(sc); 
        xsut.initialize();
        
        boolean canEdit = xsut.canEditAgreement;
        system.assertEquals(true, canEdit);   
    }

    @IsTest
    static void it_should_not_be_able_to_edit_agreement() {
        TestUtilities.createLoanAppStages();
        Account entity = ObjectFactory.getValidEntity('test entity');
        Agreement__c testAgreement = new Agreement__c();
        testAgreement.name = 'test';
        testAgreement.Primary_Borrower__c = entity.Id;
        testAgreement.RecordTypeId = Utility.RecordTypeObject('Agreement__c', 'Pending').Id;
        insert testAgreement;
        testAgreement.Stage__c = TestUtilities.getStageByName('Underwriting').Id;
        testAgreement.RecordTypeId = Utility.RecordTypeObject('Agreement__c', 'Active').Id;
        update testAgreement;
        PageReference pr = Page.Agreement;
        test.setCurrentPage(pr);
        
        ApexPages.currentPage().getParameters().put('Id', testAgreement.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(testAgreement);
        AgreementController xsut  = new AgreementController(sc);  
        xsut.initialize();
        
        boolean canEdit = xsut.canEditAgreement;
        system.assertEquals(false, canEdit);   
    }
    
    @IsTest
    static void it_should_be_able_to_view_agreement_tests() {
        TestUtilities.createLoanAppStages();
        Account entity = ObjectFactory.getValidEntity('test entity');
        Agreement__c testAgreement = new Agreement__c();
        testAgreement.name = 'test';
        testAgreement.Primary_Borrower__c = entity.Id;
        testAgreement.Stage__c = TestUtilities.getStageByName('New').Id;
        testAgreement.RecordTypeId = Utility.RecordTypeObject('Agreement__c', 'Pending').Id;
        insert testAgreement;
        PageReference pr = Page.Agreement;
        test.setCurrentPage(pr);
        
        ApexPages.currentPage().getParameters().put('Id', testAgreement.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(testAgreement);
        AgreementController xsut  = new AgreementController(sc);
        xsut.initialize();  
        
        boolean canEdit = xsut.canViewAgreementTests;
        system.assertEquals(false, canEdit);   
    }

    @IsTest
    static void it_should_be_able_to_exclude_related_eb_accounts() {
        TestUtilities.createLoanAppStages();
        Account entity = ObjectFactory.getValidEntity('test entity');
        Agreement__c testAgreement = new Agreement__c();
        testAgreement.name = 'test';
        testAgreement.Primary_Borrower__c = entity.Id;
        testAgreement.Stage__c = TestUtilities.getStageByName('New').Id;
        testAgreement.RecordTypeId = Utility.RecordTypeObject('Agreement__c', 'Pending').Id;
        insert testAgreement;
        PageReference pr = Page.Agreement;
        test.setCurrentPage(pr);
        
        ApexPages.currentPage().getParameters().put('Id', testAgreement.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(testAgreement);
        AgreementController xsut  = new AgreementController(sc);
        xsut.initialize();  
        
        boolean canEdit = xsut.canExcludeRelatedEBAccounts;
        system.assertEquals(true, canEdit);
    }

    @IsTest
    static void it_should_be_able_to_include_excluded_related_eb_accounts() {
        TestUtilities.createLoanAppStages();
        Account entity = ObjectFactory.getValidEntity('test entity');
        Agreement__c testAgreement = new Agreement__c();
        testAgreement.name = 'test';
        testAgreement.Primary_Borrower__c = entity.Id;
        testAgreement.Stage__c = TestUtilities.getStageByName('New').Id;
        testAgreement.RecordTypeId = Utility.RecordTypeObject('Agreement__c', 'Pending').Id;
        insert testAgreement;
        PageReference pr = Page.Agreement;
        test.setCurrentPage(pr);
        
        ApexPages.currentPage().getParameters().put('Id', testAgreement.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(testAgreement);
        AgreementController xsut  = new AgreementController(sc); 
        xsut.initialize(); 
        
        boolean canEdit = xsut.canIncludeExcludedRelatedEBAccounts;
        system.assertEquals(true, canEdit);
    }

    @IsTest
    static void it_should_be_able_to_exclude_related_loan_applications() {
        TestUtilities.createLoanAppStages();
        Account entity = ObjectFactory.getValidEntity('test entity');
        Agreement__c testAgreement = new Agreement__c();
        testAgreement.name = 'test';
        testAgreement.Primary_Borrower__c = entity.Id;
        testAgreement.Stage__c = TestUtilities.getStageByName('New').Id;
        testAgreement.RecordTypeId = Utility.RecordTypeObject('Agreement__c', 'Pending').Id;
        insert testAgreement;
        PageReference pr = Page.Agreement;
        test.setCurrentPage(pr);
        
        ApexPages.currentPage().getParameters().put('Id', testAgreement.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(testAgreement);
        AgreementController xsut  = new AgreementController(sc);  
        xsut.initialize();

        boolean canEdit = xsut.canExcludeRelatedLoanApplications;
        system.assertEquals(true, canEdit);
    }

    @IsTest
    static void it_should_be_able_to_include_related_loan_applications() {
        TestUtilities.createLoanAppStages();
        Account entity = ObjectFactory.getValidEntity('test entity');
        Agreement__c testAgreement = new Agreement__c();
        testAgreement.name = 'test';
        testAgreement.Primary_Borrower__c = entity.Id;
        testAgreement.Stage__c = TestUtilities.getStageByName('New').Id;
        testAgreement.RecordTypeId = Utility.RecordTypeObject('Agreement__c', 'Pending').Id;
        insert testAgreement;
        PageReference pr = Page.Agreement;
        test.setCurrentPage(pr);
        
        ApexPages.currentPage().getParameters().put('Id', testAgreement.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(testAgreement);
        AgreementController xsut  = new AgreementController(sc);
        xsut.initialize(); 
        
        boolean canEdit = xsut.canIncludeRelatedLoanApplications;
        system.assertEquals(true, canEdit);
    }
}