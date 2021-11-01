@IsTest
private class AgreementStatusManagerTests {

    private final static Mock.ofIUserInfoService mockUserInfoSvc = new Mock.ofIUserInfoService();
    private final static MockofIAgreementEntityManager mockEntityManager = new MockofIAgreementEntityManager();
    private final static MockofIAgreementStatusManagerDataProvider mockDataProvider = new MockofIAgreementStatusManagerDataProvider();
    private final static AgreementStatusManager sut = new AgreementStatusManager(mockUserInfoSvc, mockEntityManager, mockDataProvider);
    
    @IsTest
    static void codeCoverage_1(){
        TestUtilities.createLoanAppStages();        
        Agreement__c agmt = ObjectFactory.getAgreement('Pending', 'Bogus', 'hi there');
        Agreement__c agmt2 = ObjectFactory.getAgreement('Active', 'Bogus2', 'bye');
        agmt.Source_Agreement__c = agmt2.Id;
        update agmt;
        mockDataProvider.setup('getAgreementByID',ApexMoq.Arguments.HAVE_ANY_VALUE).returns(agmt);

        sut.MakeActive(agmt.Id);
    }
    
    @IsTest
    static void codeCoverage_2(){
        TestUtilities.createLoanAppStages();        
        Agreement__c agmt = ObjectFactory.getAgreement('Pending', 'Bogus', 'hi there');
        Agreement__c agmt2 = ObjectFactory.getAgreement('Active', 'Bogus2', 'bye');
        agmt.Source_Agreement__c = agmt2.Id;
        update agmt;
        mockDataProvider.setup('getAgreementByID',ApexMoq.Arguments.HAVE_ANY_VALUE).returns(agmt);
        
        sut.MakeArchive(agmt.Id);
    }
    
    @IsTest
    static void codeCoverage_3(){
        TestUtilities.createLoanAppStages();        
        Agreement__c agmt = ObjectFactory.getAgreement('Pending', 'Bogus', 'hi there');
        sut.MakeActiveAdminBackdoor(agmt.Id);
        sut.MakeArchiveAdminBackdoor(agmt.Id);
        sut.MakePendingAdminBackdoor(agmt.Id);
    }
    
    @IsTest
    static void it_should_set_the_backofficestart_fields_when_entering_the_back_office_modification_flow(){
        TestUtilities.createLoanAppStages();        
        User approver1 = ObjectFactory.getUser('Approver','One','app1@unit.test',true);
        Agreement__c testAgreement = new Agreement__c();
        testAgreement.Name = 'testAgreement';
        testAgreement.RecordTypeId = Utility.recordTypeObject('Agreement__c', 'Pending').Id;
        testAgreement.Stage__c = TestUtilities.getStageByName('Approved').Id;
        testAgreement.Approver_One__c = approver1.Id;
        insert testAgreement;
        
        String priorApprovalProcess = testAgreement.Actual_Approval_Process__c;
        Id priorApprover1 = testAgreement.Approver_One__c;
        Id priorApprover2 = testAgreement.Approver_Two__c;
        Id priorApprover3 = testAgreement.Approver_Three__c;

        sut.enterBackOfficeModification(testAgreement);

        System.assertEquals(testAgreement.Stage__c , testAgreement.Back_Office_Start_Stage__c);
        System.assertEquals(priorApprovalProcess, testAgreement.Back_Office_Start_Path__c);
        System.assertEquals(priorApprover1, testAgreement.Back_Office_Start_Approver_One__c);
        System.assertEquals(priorApprover2, testAgreement.Back_Office_Start_Approver_Two__c);
        System.assertEquals(priorApprover3, testAgreement.Back_Office_Start_Approver_Three__c);
    }
    
    @IsTest
    static void it_should_reset_the_approval_fields_when_entering_the_back_office_modification_flow(){
        TestUtilities.createLoanAppStages();        
        Agreement__c testAgreement = new Agreement__c();
        testAgreement.Name = 'testAgreement';
        testAgreement.RecordTypeId = Utility.recordTypeObject('Agreement__c', 'Pending').Id;
        testAgreement.Stage__c = TestUtilities.getStageByName('Approved').Id;
        insert testAgreement;

        sut.enterBackOfficeModification(testAgreement);

        System.assertEquals('', testAgreement.Actual_Approval_Process__c);
        System.assertEquals(null, testAgreement.Approver_One__c);
        System.assertEquals(null, testAgreement.Approver_Two__c);
        System.assertEquals(null, testAgreement.Approver_Three__c);
    }

    @IsTest
    static void it_should_reset_the_backofficestart_fields_when_exiting_the_back_office_modification_flow(){
        TestUtilities.createLoanAppStages();        
        Agreement__c testAgreement = new Agreement__c();
        testAgreement.Name = 'testAgreement';
        testAgreement.RecordTypeId = Utility.recordTypeObject('Agreement__c', 'Pending').Id;
        testAgreement.Stage__c = TestUtilities.getStageByName('Approved').Id;
        testAgreement.Back_Office_Start_Stage__c = testAgreement.Stage__c ;
        insert testAgreement;

        sut.exitBackOfficeModification(testAgreement);

        System.assertEquals(null, testAgreement.Back_Office_Start_Stage__c);
        System.assertEquals('', testAgreement.Back_Office_Start_Path__c);
        System.assertEquals(null, testAgreement.Back_Office_Start_Approver_One__c);
        System.assertEquals(null, testAgreement.Back_Office_Start_Approver_Two__c);
        System.assertEquals(null, testAgreement.Back_Office_Start_Approver_Three__c);
    }
    
    @IsTest
    static void it_should_be_able_to_edit_agreement_when_stage_backOfficeModification(){
        EB_Loan_App_Stage__c backOfficeMod = new EB_Loan_App_Stage__c(Name='Back Office Modification');
        Account entity = ObjectFactory.getValidEntity('test entity');
        Agreement__c testAgreement = new Agreement__c(Name = 'test');
        testAgreement.Primary_Borrower__c = entity.Id;
        testAgreement.RecordTypeId = Utility.RecordTypeObject('Agreement__c', 'Pending').Id;
        testAgreement.Stage__r = backOfficeMod;
        User testUser = new User(Id='005000000000000');       
        mockUserInfoSvc.setup('hasPermissionSet',ApexMoq.Arguments.HAVE_ANY_VALUE).returns(false);
        mockUserInfoSvc.setup('hasPermissionSet',new List<Object>{testUser.Id,'Function - Lending Agreement System - Back Office Modification'}).returns(true);
        mockUserInfoSvc.setup('isSystemAdministrator',ApexMoq.Arguments.HAVE_ANY_VALUE).returns(false);
        
        boolean canEdit = sut.isAgreementEditable(testAgreement,testUser.Id);
        
        system.assertEquals(true, canEdit); 
    }

    @IsTest
    static void it_should_be_able_to_edit_agreement_when_stage_new_and_recordtype_pending(){
        EB_Loan_App_Stage__c newStage = new EB_Loan_App_Stage__c(Name='New');
        Account entity = ObjectFactory.getValidEntity('test entity');
        Agreement__c testAgreement = new Agreement__c(Name = 'test');
        testAgreement.Primary_Borrower__c = entity.Id;
        testAgreement.Stage__r = newStage;
        testAgreement.RecordTypeId = Utility.RecordTypeObject('Agreement__c', 'Pending').Id;        
        mockUserInfoSvc.setup('hasPermissionSet',ApexMoq.Arguments.HAVE_ANY_VALUE).returns(false);
         
        boolean canEdit = sut.isAgreementEditable(testAgreement,null);
        
        system.assertEquals(true, canEdit);   
    }

    @IsTest
    static void it_should_be_able_to_edit_agreement_when_recordtype_is_pending_and_in_an_underwriting_stage_and_user_has_credit_analyst_role_permission(){
        EB_Stage_Action_Controller__c underwritingCtrl = new EB_Stage_Action_Controller__c(Name='Underwriting');
        EB_Loan_App_Stage__c underwritingStage = new EB_Loan_App_Stage__c(Name='Underwriting - On Hold');
        underwritingStage.Loan_App_Stage_Action_Controller__r = underwritingCtrl;
        Agreement__c testAgreement = new Agreement__c();
        testAgreement.RecordTypeId = Utility.RecordTypeObject('Agreement__c', 'Pending').Id;
        testAgreement.Stage__r = underwritingStage;
        User testUser = new User(Id='005000000000000');        
        mockUserInfoSvc.setup('hasPermissionSet',ApexMoq.Arguments.HAVE_ANY_VALUE).returns(false);
        mockUserInfoSvc.setup('hasPermissionSet',new List<Object>{testUser.Id,'Role - Credit Analyst'}).returns(true);
        mockUserInfoSvc.setup('isSystemAdministrator',ApexMoq.Arguments.HAVE_ANY_VALUE).returns(false);

        boolean canEdit = sut.isAgreementEditable(testAgreement,testUser.Id);
        
        system.assertEquals(true, canEdit);
    }

    @IsTest
    static void it_should_NOT_be_able_to_edit_agreement_when_recordtype_is_pending_and_in_an_underwriting_stage_and_user_doesnt_have_credit_analyst_role_permission(){
        EB_Stage_Action_Controller__c underwritingCtrl = new EB_Stage_Action_Controller__c(Name='Underwriting');
        EB_Loan_App_Stage__c underwritingStage = new EB_Loan_App_Stage__c(Name='Underwriting - On Hold');
        underwritingStage.Loan_App_Stage_Action_Controller__r = underwritingCtrl;
        Agreement__c testAgreement = new Agreement__c();
        testAgreement.RecordTypeId = Utility.RecordTypeObject('Agreement__c', 'Pending').Id;
        testAgreement.Stage__r = underwritingStage;
        User testUser = new User(Id='005000000000000');        
        mockUserInfoSvc.setup('hasPermissionSet',ApexMoq.Arguments.HAVE_ANY_VALUE).returns(false);
        mockUserInfoSvc.setup('hasPermissionSet',new List<Object>{testUser.Id,'Role - Credit Analyst'}).returns(false);
        mockUserInfoSvc.setup('isSystemAdministrator',ApexMoq.Arguments.HAVE_ANY_VALUE).returns(false);

        boolean canEdit = sut.isAgreementEditable(testAgreement,testUser.Id);
        
        system.assertEquals(false, canEdit);
    }

    @IsTest
    static void it_should_be_able_to_edit_agreement_when_recordtype_is_pending_and_in_an_underwriting_stage_and_user_has_administrator_permission(){
        EB_Stage_Action_Controller__c underwritingCtrl = new EB_Stage_Action_Controller__c(Name='Underwriting');
        EB_Loan_App_Stage__c underwritingStage = new EB_Loan_App_Stage__c(Name='Underwriting - On Hold');
        underwritingStage.Loan_App_Stage_Action_Controller__r = underwritingCtrl;
        Agreement__c testAgreement = new Agreement__c();
        testAgreement.RecordTypeId = Utility.RecordTypeObject('Agreement__c', 'Pending').Id;
        testAgreement.Stage__r = underwritingStage;
        User testUser = new User(Id='005000000000000');        
        mockUserInfoSvc.setup('hasPermissionSet',ApexMoq.Arguments.HAVE_ANY_VALUE).returns(false);
        mockUserInfoSvc.setup('isSystemAdministrator',ApexMoq.Arguments.HAVE_ANY_VALUE).returns(true);

        boolean canEdit = sut.isAgreementEditable(testAgreement,testUser.Id);
        
        system.assertEquals(true, canEdit);
    }

    @IsTest
    static void it_should_be_able_to_edit_agreement_when_pending_and_connected_to_loan_app_in_new_stage(){
        EB_Loan_App_Stage__c newStage = new EB_Loan_App_Stage__c(Name='New');
        Agreement__c testAgreement = new Agreement__c();
        testAgreement.RecordTypeId = Utility.RecordTypeObject('Agreement__c', 'Pending').Id;        
        EB_Loan_Application__c testApplication = new EB_Loan_Application__c();
        testApplication.Application_Stage__r = newStage;        
        Agreement_Loan_Application_Relationship__c agmtApp = new Agreement_Loan_Application_Relationship__c();
        agmtApp.Agreement__r = testAgreement;
        agmtApp.Loan_Application__r = testApplication;
        User testUser = new User(Id='005000000000000');
        mockUserInfoSvc.setup('hasPermissionSet',ApexMoq.Arguments.HAVE_ANY_VALUE).returns(false);
        mockUserInfoSvc.setup('isSystemAdministrator',ApexMoq.Arguments.HAVE_ANY_VALUE).returns(false);
        mockDataProvider.setup('getAgreementLoanAppRelationshipsByAgreementId',ApexMoq.Arguments.HAVE_ANY_VALUE).returns(new List<Agreement_Loan_Application_Relationship__c>{agmtApp});

        boolean canEdit = sut.isAgreementEditable(testAgreement,testUser.Id);
        
        system.assertEquals(true, canEdit);
    }

    @IsTest
    static void it_should_be_able_to_edit_agreement_when_pending_and_connected_to_loan_app_in_underwriting_and_user_has_credit_analyst_permission(){
        EB_Stage_Action_Controller__c underwritingCtrl = new EB_Stage_Action_Controller__c(Name='Underwriting');
        EB_Loan_App_Stage__c underwritingStage = new EB_Loan_App_Stage__c(Name='Underwriting - On Hold');
        underwritingStage.Loan_App_Stage_Action_Controller__r = underwritingCtrl;
        Agreement__c testAgreement = new Agreement__c();
        testAgreement.RecordTypeId = Utility.RecordTypeObject('Agreement__c', 'Pending').Id;        
        EB_Loan_Application__c testApplication = new EB_Loan_Application__c();
        testApplication.Application_Stage__r = underwritingStage;
        Agreement_Loan_Application_Relationship__c agmtApp = new Agreement_Loan_Application_Relationship__c();
        agmtApp.Agreement__r = testAgreement;
        agmtApp.Loan_Application__r = testApplication;
        User testUser = new User(Id='005000000000000');
        mockUserInfoSvc.setup('hasPermissionSet',ApexMoq.Arguments.HAVE_ANY_VALUE).returns(false);
        mockUserInfoSvc.setup('hasPermissionSet',new List<Object>{testUser.Id,'Role - Credit Analyst'}).returns(true);
        mockUserInfoSvc.setup('isSystemAdministrator',ApexMoq.Arguments.HAVE_ANY_VALUE).returns(false);
        mockDataProvider.setup('getAgreementLoanAppRelationshipsByAgreementId',ApexMoq.Arguments.HAVE_ANY_VALUE).returns(new List<Agreement_Loan_Application_Relationship__c>{agmtApp});

        boolean canEdit = sut.isAgreementEditable(testAgreement,testUser.Id);
        
        system.assertEquals(true, canEdit);
    }

    @IsTest
    static void it_should_NOT_be_able_to_edit_agreement_when_pending_and_connected_to_loan_app_beyond_underwriting(){
        EB_Stage_Action_Controller__c newController = new EB_Stage_Action_Controller__c(Name='New');
        EB_Stage_Action_Controller__c underwritingController = new EB_Stage_Action_Controller__c(Name='Underwriting');
        EB_Stage_Action_Controller__c approvedController = new EB_Stage_Action_Controller__c(Name='Approved');        
        EB_Loan_App_Stage__c newStage = new EB_Loan_App_Stage__c(Name='New');
        EB_Loan_App_Stage__c underwritingStage = new EB_Loan_App_Stage__c(Name='Underwriting - On Hold');
        EB_Loan_App_Stage__c approvedStage = new EB_Loan_App_Stage__c(Name='Approved');
        newStage.Loan_App_Stage_Action_Controller__r = newController;
        underwritingStage.Loan_App_Stage_Action_Controller__r = underwritingController;
        approvedStage.Loan_App_Stage_Action_Controller__r = approvedController;        
        Agreement__c testAgreement = new Agreement__c();
        testAgreement.RecordTypeId = Utility.RecordTypeObject('Agreement__c', 'Pending').Id;        
        EB_Loan_Application__c testApplication1 = new EB_Loan_Application__c();
        testApplication1.Application_Stage__r = newStage; 
        EB_Loan_Application__c testApplication2 = new EB_Loan_Application__c();
        testApplication2.Application_Stage__r = underwritingStage; 
        EB_Loan_Application__c testApplication3 = new EB_Loan_Application__c();
        testApplication3.Application_Stage__r = approvedStage; 
        Agreement_Loan_Application_Relationship__c agmtApp1 = new Agreement_Loan_Application_Relationship__c();
        agmtApp1.Agreement__r = testAgreement;
        agmtApp1.Loan_Application__r = testApplication1;
        Agreement_Loan_Application_Relationship__c agmtApp2 = new Agreement_Loan_Application_Relationship__c();
        agmtApp2.Agreement__r = testAgreement;
        agmtApp2.Loan_Application__r = testApplication2;
        Agreement_Loan_Application_Relationship__c agmtApp3 = new Agreement_Loan_Application_Relationship__c();
        agmtApp3.Agreement__r = testAgreement;
        agmtApp3.Loan_Application__r = testApplication3;
        User testUser = new User(Id='005000000000000');
        mockUserInfoSvc.setup('hasPermissionSet',ApexMoq.Arguments.HAVE_ANY_VALUE).returns(false);
        mockUserInfoSvc.setup('isSystemAdministrator',ApexMoq.Arguments.HAVE_ANY_VALUE).returns(false);
        mockDataProvider.setup('getAgreementLoanAppRelationshipsByAgreementId',ApexMoq.Arguments.HAVE_ANY_VALUE).returns(new List<Agreement_Loan_Application_Relationship__c>{agmtApp1, agmtApp2, agmtApp3});

        boolean canEdit = sut.isAgreementEditable(testAgreement,testUser.Id);
        
        system.assertEquals(false, canEdit);
    }

    @IsTest
    static void it_should_return_the_agreements_record_type(){
        Agreement__c agmt = new Agreement__c();
        agmt.RecordTypeId = Utility.recordTypeObject('Agreement__c','Active').Id;
        
        RecordType rType = sut.getRecordType(agmt);
        
        System.assertEquals('Active',rType.Name);
    }

    @IsTest
    static void it_should_set_the_agreement_to_the_new_stage(){
        TestUtilities.createLoanAppStages();
        Agreement__c agmt = new Agreement__c();
        agmt.RecordTypeId = Utility.recordTypeObject('Agreement__c','Active').Id;
        insert agmt;
        agmt.Stage__c = TestUtilities.getStageByName('Approved').Id;
        update agmt;        
        mockDataProvider.setup('getAgreementByID',ApexMoq.Arguments.HAVE_ANY_VALUE).returns(agmt);
        mockDataProvider.setup('getLoanAppStageByName',ApexMoq.Arguments.HAVE_ANY_VALUE).returns(new EB_Loan_App_Stage__c(Id='a0if0000000Jzw4'));

        sut.MakeNewAdminBackdoor(agmt.Id);
        
        mockDataProvider.verify('getLoanAppStageByName',new List<Object>{'New'}, Times.Once);
        mockDataProvider.verify('saveAgreement', new List<Object>{agmt}, Times.Once);
    }

    @IsTest
    static void it_should_call_the_entity_manager_to_move_financial_reporting_requirements_to_the_active_state_on_active(){
        Agreement__c testAgmt = new Agreement__c(Id='a28f000000091AS');
        testAgmt.RecordTypeId = Utility.recordTypeObject('Agreement__c','Pending').Id;
        mockDataProvider.setup('getAgreementByID',ApexMoq.Arguments.HAVE_ANY_VALUE).returns(testAgmt);

        sut.MakeActive(testAgmt.Id);

        mockEntityManager.verify('copyPendingFinancialReportingRequirementsToActive',new List<Object>{testAgmt.Id}, Times.Once);
    }

    @IsTest
    static void it_should_call_the_entity_manager_to_move_financial_reporting_requirements_to_the_archive_state_on_archive(){
        Agreement__c testAgmt = new Agreement__c(Id='a28f000000091AS');
        testAgmt.RecordTypeId = Utility.recordTypeObject('Agreement__c','Active').Id;
        mockDataProvider.setup('getAgreementByID',ApexMoq.Arguments.HAVE_ANY_VALUE).returns(testAgmt);
        mockDataProvider.setup('getAgreementClientRelationshipsByAgreementId',ApexMoq.Arguments.HAVE_ANY_VALUE).returns(new List<Agreement_Client_Relationships__c>());

        sut.MakeArchive(testAgmt.Id);

        mockEntityManager.verify('copyActiveFinancialReportingRequirementsToArchive',new List<Object>{testAgmt.Id}, Times.Once);
    }

    @IsTest
    static void it_should_attach_agreement_from_given_loan_application_to_given_loan_account(){
        EB_Loan_Application__c app = new EB_Loan_Application__c(Id='a0m000000000000');
        Agreement__c agmt = new Agreement__c(Id='a28000000000000');
        EB_Account__c acct = new EB_Account__c(Id='a02000000000000');
        List<Agreement_Loan_Application_Relationship__c> appAgmts = new List<Agreement_Loan_Application_Relationship__c>{new Agreement_Loan_Application_Relationship__c(Loan_Application__c=app.Id, Agreement__c=agmt.Id)};
        List<Agreement_EB_Account_Relationship__c> acctAgmts = new List<Agreement_EB_Account_Relationship__c>();
        mockDataProvider.setup('getAgreementLoanApplicationRelationshipsByAppId', new List<Object>{app.Id}).returns(appAgmts);
        mockDataProvider.setup('getAgreementAccountRelationshipsByAccountId', new List<Object>{acct.Id}).returns(acctAgmts);

        sut.attachLoanAppAgreementsToAccount(app.Id,acct.Id);

        List<Agreement_EB_Account_Relationship__c> expected = new List<Agreement_EB_Account_Relationship__c>{new Agreement_EB_Account_Relationship__c(Agreement__c=agmt.Id, Loan_Account__c=acct.Id)};
        mockDataProvider.verify('saveAccountRelationships', new List<Object>{expected}, Times.Once);
    }

    @IsTest
    static void it_should_NOT_attach_already_attached_agreement_from_given_loan_application_to_given_loan_account(){
        EB_Loan_Application__c app = new EB_Loan_Application__c(Id='a0m000000000000');
        Agreement__c agmt = new Agreement__c(Id='a28000000000000');
        EB_Account__c acct = new EB_Account__c(Id='a02000000000000');
        List<Agreement_Loan_Application_Relationship__c> appAgmts = new List<Agreement_Loan_Application_Relationship__c>{new Agreement_Loan_Application_Relationship__c(Loan_Application__c=app.Id, Agreement__c=agmt.Id)};
        List<Agreement_EB_Account_Relationship__c> acctAgmts = new List<Agreement_EB_Account_Relationship__c>{new Agreement_EB_Account_Relationship__c(Agreement__c=agmt.Id, Loan_Account__c=acct.Id)};
        mockDataProvider.setup('getAgreementLoanApplicationRelationshipsByAppId', new List<Object>{app.Id}).returns(appAgmts);
        mockDataProvider.setup('getAgreementAccountRelationshipsByAccountId', new List<Object>{acct.Id}).returns(acctAgmts);

        sut.attachLoanAppAgreementsToAccount(app.Id,acct.Id);

        List<Agreement_EB_Account_Relationship__c> expected = new List<Agreement_EB_Account_Relationship__c>{new Agreement_EB_Account_Relationship__c(Agreement__c=agmt.Id, Loan_Account__c=acct.Id)};
        mockDataProvider.verify('saveAccountRelationships', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Never);
    }

    @IsTest
    static void it_should_attach_all_agreements_from_given_loan_application_to_given_loan_account(){
        EB_Loan_Application__c app = new EB_Loan_Application__c(Id='a0m000000000000');
        Agreement__c agmt0 = new Agreement__c(Id='a28000000000000');
        Agreement__c agmt1 = new Agreement__c(Id='a28000000000001');
        EB_Account__c acct = new EB_Account__c(Id='a02000000000000');
        Agreement_Loan_Application_Relationship__c appAgmt0 = new Agreement_Loan_Application_Relationship__c(Loan_Application__c=app.Id, Agreement__c=agmt0.Id);
        Agreement_Loan_Application_Relationship__c appAgmt1 = new Agreement_Loan_Application_Relationship__c(Loan_Application__c=app.Id, Agreement__c=agmt1.Id);
        List<Agreement_Loan_Application_Relationship__c> appAgmts = new List<Agreement_Loan_Application_Relationship__c>{appAgmt0, appAgmt1};
        List<Agreement_EB_Account_Relationship__c> acctAgmts = new List<Agreement_EB_Account_Relationship__c>();
        mockDataProvider.setup('getAgreementLoanApplicationRelationshipsByAppId', new List<Object>{app.Id}).returns(appAgmts);
        mockDataProvider.setup('getAgreementAccountRelationshipsByAccountId', new List<Object>{acct.Id}).returns(acctAgmts);

        sut.attachLoanAppAgreementsToAccount(app.Id,acct.Id);

        Agreement_EB_Account_Relationship__c expectedAcctAgmt0 = new Agreement_EB_Account_Relationship__c(Agreement__c=agmt0.Id, Loan_Account__c=acct.Id);
        Agreement_EB_Account_Relationship__c expectedAcctAgmt1 = new Agreement_EB_Account_Relationship__c(Agreement__c=agmt1.Id, Loan_Account__c=acct.Id);
        List<Agreement_EB_Account_Relationship__c> expected = new List<Agreement_EB_Account_Relationship__c>{expectedAcctAgmt0,expectedAcctAgmt1};
        mockDataProvider.verify('saveAccountRelationships', new List<Object>{expected}, Times.Once);
    }

    public class MockofIAgreementEntityManager extends ApexMoq implements Agreements.IAgreementEntityManager{
        public void copyPendingFinancialReportingRequirementsToActive(Id agreementId){
            handleMethodInvocation('copyPendingFinancialReportingRequirementsToActive',new List<Object>{agreementId});
        }
        public void copyActiveFinancialReportingRequirementsToArchive(Id agreementId){
            handleMethodInvocation('copyActiveFinancialReportingRequirementsToArchive',new List<Object>{agreementId});
        }
    }

    private class MockofIAgreementStatusManagerDataProvider extends ApexMoq implements Agreements.IAgreementStatusManagerDataProvider{
        public Agreement__c getAgreementByID(Id agreementId){
            return (Agreement__c)handleMethodInvocation('getAgreementByID',new List<Object>{agreementId});
        }
        public List<Agreement_Loan_Application_Relationship__c> getAgreementLoanAppRelationshipsByAgreementId(Id agreementId){
            return (List<Agreement_Loan_Application_Relationship__c>)handleMethodInvocation('getAgreementLoanAppRelationshipsByAgreementId',new List<Object>{agreementId});
        }
        public List<Agreement_Loan_Application_Relationship__c> getAgreementLoanApplicationRelationshipsByAppId(Id applicationId){
            return (List<Agreement_Loan_Application_Relationship__c>)handleMethodInvocation('getAgreementLoanApplicationRelationshipsByAppId',new List<Object>{applicationId});
        }
        public EB_Loan_App_Stage__c getLoanAppStageByName(String stageName){
            return (EB_Loan_App_Stage__c)handleMethodInvocation('getLoanAppStageByName',new List<Object>{stageName});
        }
        public List<Agreement_EB_Account_Relationship__c> getAgreementAccountRelationshipsByAccountId(Id ebAccountId){
            return (List<Agreement_EB_Account_Relationship__c>)handleMethodInvocation('getAgreementAccountRelationshipsByAccountId',new List<Object>{ebAccountId});
        }
        public List<Agreement_Client_Relationships__c> getAgreementClientRelationshipsByAgreementId(Id agreementId){
            return (List<Agreement_Client_Relationships__c>)handleMethodInvocation('getAgreementClientRelationshipsByAgreementId',new List<Object>{agreementId});
        }
        public void saveAgreement(Agreement__c agreement){
            handleMethodInvocation('saveAgreement',new List<Object>{agreement});
        }
        public void updateClientRelationships(List<Agreement_Client_Relationships__c> agreementClientRelationships){
            handleMethodInvocation('updateClientRelationships',new List<Object>{agreementClientRelationships});
        }
        public void saveAccountRelationships(List<Agreement_EB_Account_Relationship__c> agreementAccountRelationships){
            handleMethodInvocation('saveAccountRelationships',new List<Object>{agreementAccountRelationships});
        }
    }
}