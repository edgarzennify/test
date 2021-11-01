@IsTest
private class AgreementTestWorkflowControllerTests {

    private static final MockofITeamRoleMatrix mockTeamMatrix;
    private static final MockofIAgreementTestWorkflowDataProvider mockDataProvider;
    private static final Mock.ofIUtility mockUtility;
    private static final Mock.ofIUserInfoService mockUserInfo;
    private static final Mock.ofIApexPages mockApexPages;
    private static final Mock.ofIConfigurations mockConfigs;
    private static final Agreement_Test__c agmtTest;
    private static final AgreementTestWorkflowController sut;

    static {
        mockTeamMatrix = new MockofITeamRoleMatrix();
        mockDataProvider = new MockofIAgreementTestWorkflowDataProvider();
        mockUtility = new Mock.ofIUtility();
        mockUserInfo = new Mock.ofIUserInfoService();
        mockApexPages = new Mock.ofIApexPages();
        mockConfigs = new Mock.ofIConfigurations();
        agmtTest = new Agreement_Test__c(Id='a2O000000000000');       
        mockDataProvider.setup('getAgreementTestById', new List<Object>{agmtTest.Id}).returns(agmtTest);
        sut = new AgreementTestWorkflowController(mockConfigs, mockTeamMatrix, mockDataProvider, mockUtility, mockUserInfo, mockApexPages, agmtTest.Id);
    }
    
    @IsTest
    static void it_should_show_Approver_One_list_when_approval_path_is_selected() {
        sut.agreementTest.Approval_Process__c = 'test approval process';

        System.assertEquals(true, sut.showApproverOne);
    }

    @IsTest
    static void it_should_retrieve_the_approver_one_list_from_the_team_matrix_when_returning_approver_one_list() {
        Account borrower = new Account(Id='001000000000000');
        Agreement__c agmt = new Agreement__c(Id='a28000000000000');
        agmt.Borrower_Name__c = borrower.Id;
        
        agmtTest.Agreement__r = agmt;

        List<SelectOption> approverOneList = sut.approverOneList;

        mockTeamMatrix.verify('GetSigners', new List<Object>{borrower.Id});
    }

    @IsTest
    static void it_should_show_Approver_Two_list_when_rm_plus_one_approval_path_is_selected() {
        sut.agreementTest.Approval_Process__c = 'RM + 1';

        System.assertEquals(true, sut.showApproverOne);
        System.assertEquals(true, sut.showApproverTwo);
    }

    @IsTest
    static void it_should_show_Approver_Two_and_Approver_Three_lists_when_3_Signature_approval_path_is_selected() {
        sut.agreementTest.Approval_Process__c = '3 Signatures';

        System.assertEquals(true, sut.showApproverOne);
        System.assertEquals(true, sut.showApproverTwo);
        System.assertEquals(true, sut.showApproverThree);
    }

    @IsTest
    static void it_should_NOT_show_Approver_Two_list_unless_2_or_3_Signature_approval_path_is_selected() {
        sut.agreementTest.Approval_Process__c = 'Executive Loan Committee';

        System.assertEquals(false, sut.showApproverTwo);
    }

    @IsTest
    static void it_should_NOT_show_Approver_Two_or_Approver_Three_lists_unless_3_Signature_approval_path_is_selected() {
        sut.agreementTest.Approval_Process__c = 'Executive Loan Committee';

        System.assertEquals(false, sut.showApproverTwo);
        System.assertEquals(false, sut.showApproverThree);
    }

    @IsTest
    static void it_should_show_the_approval_path_list_when_submit_for_approval_is_selected() {
        sut.ddNextStatus = 'Submit For Approval';

        System.assertEquals(true, sut.showApprovalPath);
    }

    @IsTest
    static void it_should_NOT_show_the_approval_path_list_when_submit_for_approval_is_not_selected() {
        sut.ddNextStatus = 'Something Other Than Submit For Approval';

        System.assertEquals(false, sut.showApprovalPath);
    }

    @IsTest
    static void it_should_show_the_approver_one_error_when_no_team_members_with_lending_authority_are_assigned() {
        Account borrower = new Account(Id='001000000000000');
        Agreement__c agmt = new Agreement__c(Id='a28000000000000');
        agmt.Borrower_Name__c = borrower.Id;
        
        agmtTest.Agreement__r = agmt;
        mockTeamMatrix.setup('GetSigners', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(new List<SelectOption>{new SelectOption('', '--None--')});

        Boolean result = sut.isApproverOneAvailable;

        System.assertEquals(false, result);
    }

    @IsTest
    static void it_should_save_the_changes_to_the_Agreement_Test_when_submit_is_clicked() {
        User appr1 = new User(Id='005000000000000');
        User appr2 = new User(Id='005000000000001');
        User appr3 = new User(Id='005000000000002');

        sut.ddNextStatus = 'Submit For Approval';
        sut.agreementTest.Approval_Process__c = '3 Signatures';
        sut.agreementTest.Approver_One__c = appr1.Id;
        sut.agreementTest.Approver_Two__c = appr2.Id;
        sut.agreementTest.Approver_Three__c = appr3.Id;
        sut.submitClicked();

        System.assertEquals('3 Signatures',agmtTest.Approval_Process__c);
        System.assertEquals(appr1.Id,agmtTest.Approver_One__c);
        System.assertEquals(appr2.Id,agmtTest.Approver_Two__c);
        System.assertEquals(appr3.Id,agmtTest.Approver_Three__c);
        mockDataProvider.verify('saveAgreementTest', new List<Object>{agmtTest});
    }

    @IsTest
    static void it_should_submit_the_AgreementTest_for_approval_when_submit_is_clicked_and_Submit_For_Approval_is_selected() {
        User testUser = new User(Id='005000000000000');

        sut.ddNextStatus = 'Submit For Approval';
        sut.agreementTest.Approval_Process__c = 'Executive Loan Committee';
        sut.agreementTest.Approver_One__c = testUser.Id;
        sut.submitClicked();

        mockUtility.verify('submitForApproval', new List<Object>{agmtTest.Id});
    }

    @IsTest
    static void it_should_auto_approve_when_the_current_user_is_also_approver_one_when_submit_is_clicked() {
        User testUser = new User(Id='005000000000000');

        mockUserInfo.setup('getCurrentUserId').returns(testUser.Id);

        sut.agreementTest.Approver_One__c = testUser.Id;
        sut.ddNextStatus = 'Submit For Approval';
        sut.agreementTest.Approval_Process__c = 'Executive Loan Committee';
        sut.submitClicked();

        mockUtility.verify('approveNextStep', new List<Object>{agmtTest.Id});
    }

    @IsTest
    static void it_should_NOT_auto_approve_when_the_current_user_is_not_approver_one() {
        User someUser = new User(Id='005000000000001');
        User approverOne = new User(Id='005000000000000');

        mockUserInfo.setup('getCurrentUserId').returns(someUser.Id);

        sut.agreementTest.Approver_One__c = approverOne.Id;
        sut.ddNextStatus = 'Submit For Approval';
        sut.submitClicked();

        mockUtility.verify('approveNextStep', new List<Object>{agmtTest.Id}, Times.Never);
    }

    @IsTest
    static void it_should_return_a_Page_Reference_to_the_Agreement_Test_view_page_when_submit_is_clicked() {
        User someUser = new User(Id='005000000000001');
        User approverOne = new User(Id='005000000000000');
        mockUserInfo.setup('getCurrentUserId').returns(someUser.Id);

        sut.agreementTest.Approver_One__c = approverOne.Id;
        sut.ddNextStatus = 'Submit For Approval';
        sut.agreementTest.Approval_Process__c = 'Executive Loan Committee';
        PageReference nextPage = sut.submitClicked();

        PageReference expected = new PageReference('/' + agmtTest.Id);
        System.assertEquals(true,nextPage.getRedirect());
        System.assertEquals(expected.getUrl(),nextPage.getUrl());
    }

    @IsTest
    static void it_should_return_a_Page_Reference_to_the_Agreement_Test_view_page_when_cancel_is_clicked() {
        PageReference nextPage = sut.cancelClicked();

        PageReference expected = new PageReference('/' + agmtTest.Id);
        System.assertEquals(true,nextPage.getRedirect());
        System.assertEquals(expected.getUrl(),nextPage.getUrl());
    }

    @IsTest
    static void it_should_add_a_message_to_the_page_when_clicking_submit_and_the_approval_process_is_rm_plus_one_and_2_approvers_have_not_been_selected() {
        sut.ddNextStatus = 'Submit For Approval';
        sut.agreementTest.Approval_Process__c = 'RM + 1';
        PageReference nextPage = sut.submitClicked();

        System.assertEquals(null, nextPage);
        mockUtility.verify('submitForApproval', new List<Object>{agmtTest.Id}, Times.Never);
        mockApexPages.verify('addMessage', new List<Object>{ApexPages.Severity.ERROR, 'Please select Approver One and Approver Two'});
    }

    @IsTest
    static void it_should_add_a_message_to_the_page_when_clicking_submit_and_the_approval_process_is_3_signatues_and_3_approvers_have_not_been_selected() {
        sut.ddNextStatus = 'Submit For Approval';
        sut.agreementTest.Approval_Process__c = '3 Signatures';
        PageReference nextPage = sut.submitClicked();

        System.assertEquals(null, nextPage);
        mockUtility.verify('submitForApproval', new List<Object>{agmtTest.Id}, Times.Never);
        mockApexPages.verify('addMessage', new List<Object>{ApexPages.Severity.ERROR, 'Please select Approver One, Approver Two, and Approver Three'});
    }

    @IsTest
    static void it_should_add_a_message_to_the_page_when_clicking_submit_and_approver_1_and_approver_2_are_the_same() {
        User someUser = new User(Id='005000000000001');

        sut.ddNextStatus = 'Submit For Approval';
        sut.agreementTest.Approval_Process__c = 'RM + 1';
        sut.agreementTest.Approver_One__c = someUser.Id;
        sut.agreementTest.Approver_Two__c = someUser.Id;
        PageReference nextPage = sut.submitClicked();

        System.assertEquals(null, nextPage);
        mockUtility.verify('submitForApproval', new List<Object>{agmtTest.Id}, Times.Never);
        mockApexPages.verify('addMessage', new List<Object>{ApexPages.Severity.ERROR, 'Cannot assign the same approver to more than one approval level'});
    }

    @IsTest
    static void it_should_disable_the_page_when_an_existing_approval_process_is_already_in_progress() {
        Agreement_Test__c agmtTest = new Agreement_Test__c(Id='a2O000000000000');
        mockDataProvider.setup('getAgreementTestById', new List<Object>{agmtTest.Id}).returns(agmtTest);
        mockUtility.setup('pendingApprovalSteps', new List<Object>{agmtTest.Id}).returns(1);
        AgreementTestWorkflowController xsut = new AgreementTestWorkflowController(mockConfigs, mockTeamMatrix, mockDataProvider, mockUtility, mockUserInfo, mockApexPages, agmtTest.Id);

        String submitDisabled = xsut.isSubmitDisabled;

        System.assertEquals('true', submitDisabled);
        mockApexPages.verify('addMessage', new List<Object>{ApexPages.Severity.INFO, 'Pending approval already in progress'});
    }

    @IsTest
    static void it_should_disable_the_page_when_the_Agreement_Test_doesnt_need_approval() {
        Agreement_Test__c agmtTest = new Agreement_Test__c(Id='a2O000000000000');
        mockDataProvider.setup('getAgreementTestById', new List<Object>{agmtTest.Id}).returns(agmtTest);
        mockDataProvider.setup('isApprovalRequired', new List<Object>{agmtTest}).returns(false);
        AgreementTestWorkflowController xsut = new AgreementTestWorkflowController(mockConfigs, mockTeamMatrix, mockDataProvider, mockUtility, mockUserInfo, mockApexPages, agmtTest.Id);

        String submitDisabled = xsut.isSubmitDisabled;

        System.assertEquals('true', submitDisabled);
        mockApexPages.verify('addMessage', new List<Object>{ApexPages.Severity.INFO, 'This Agreement Test does not require approval'});
    }

    @IsTest
    static void it_should_call_configs_to_get_url_for_approval_paths_document() {
        String expectedURL = 'the url';

        mockConfigs.setup('get', new List<Object>{'AgreementApprovalPathsUrl'}).returns(expectedURL);

        String returnedUrl = sut.ApprovalPathsUrl;

        System.assertEquals('the url', returnedUrl);
    }

    private class MockofIAgreementTestWorkflowDataProvider extends ApexMoq implements AgreementTestWorkflowDataProvider.IAgreementTestWorkflowDataProvider {
        public Agreement_Test__c getAgreementTestById(Id agreementTestId) {
            return (Agreement_Test__c)handleMethodInvocation('getAgreementTestById', new List<Object>{agreementTestId});
        }
        public void saveAgreementTest(Agreement_Test__c agmtTest) {
            handleMethodInvocation('saveAgreementTest', new List<Object>{agmtTest});
        }
        public Boolean isApprovalRequired(Agreement_Test__c agmtTest) {
            return (Boolean)handleMethodInvocation('isApprovalRequired', new List<Object>{agmtTest});
        }
        public Boolean isActionReady(Agreement_Test__c agmtTest) {
            return (Boolean)handleMethodInvocation('isActionReady', new List<Object>{agmtTest});
        }
    }

    private class MockofITeamRoleMatrix extends ApexMoq implements TeamRoleMatrix.ITeamRoleMatrix {
        public List<SelectOption> GetSigners(Id EntityId) {
            return (List<SelectOption>)handleMethodInvocation('GetSigners', new List<Object>{EntityId});
        }
    }
}