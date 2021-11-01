@isTest
private class LoanAppStageAppActionControllerTests {

    static testMethod void testWithNormalOperation(){
        /////////////////// initialize test
        EB_Stage_Action_Controller__c newCtrl1 = new EB_Stage_Action_Controller__c();
        newCtrl1.Name = 'TestCtrl1';
        newCtrl1.Visual_Force_Action_Page__c = '/apex/LoanAppTestActionPage';
        insert newCtrl1;
        
        EB_Stage_Action_Controller__c newCtrl2 = new EB_Stage_Action_Controller__c();
        newCtrl2.Name = 'TestCtrl2';
        newCtrl2.Visual_Force_Action_Page__c = '/apex/LoanAppTestActionPage';
        insert newCtrl2;
        
        EB_Loan_App_Stage__c newStage1 = new EB_Loan_App_Stage__c();
        newStage1.Name = 'TestStage1';
        newStage1.Loan_App_Stage_Action_Controller__c = newCtrl1.Id;
        newStage1.Sort_Order__c = 1000;
        insert newStage1;
        
        EB_Loan_App_Stage__c newStage2 = new EB_Loan_App_Stage__c();
        newStage2.Name = 'TestStage2';
        newStage2.Loan_App_Stage_Action_Controller__c = newCtrl2.Id;
        newStage2.Sort_Order__c = 2000;
        insert newStage2;
        
        EB_Loan_App_Stage_Allowed_Action__c newAction1 = new EB_Loan_App_Stage_Allowed_Action__c();
        newAction1.Stage__c = newStage2.Id;
        newAction1.Controller__c = newCtrl1.Id;
        newAction1.RecordTypeId = testObjectClass.getRecordTypeIdForName('Next Action','EB_Loan_App_Stage_Allowed_Action__c');
        insert newAction1;
        system.debug('newAction1: ' + newAction1.Type__c);
        
        EB_Loan_App_Stage_Explanation__c newExplanation1 = new EB_Loan_App_Stage_Explanation__c();
        newExplanation1.Loan_App_Stage__c = newStage1.Id;
        newExplanation1.Name = 'Test Explanation';
        insert newExplanation1;
        
        EB_Loan_App_Stage_Validation_Rule__c newRule1 = new EB_Loan_App_Stage_Validation_Rule__c();
        newRule1.EB_Loan_App_Stage__c = newStage2.Id;
        newRule1.Object_Name__c = 'EB_Loan_Application__c';
        newRule1.Field_Name__c = 'Business_Purpose__c';
        newRule1.Operation__c = '<>';
        newRule1.Operand__c = 'test';       
        insert newRule1;
        
        EB_Loan_App_Stage_Validation_Rule__c newRule2 = new EB_Loan_App_Stage_Validation_Rule__c();
        newRule2.EB_Loan_App_Stage__c = newStage2.Id;
        newRule2.Object_Name__c = 'EB_Loan_Application__c';
        newRule2.Field_Name__c = 'Business_Purpose__c';
        newRule2.Operation__c = '=';
        newRule2.Operand__c = 'test';           
        
        EB_Loan_App_Action_Field_Update__c newUpdate1 = new EB_Loan_App_Action_Field_Update__c();
        newUpdate1.Allowed_Action__c = newAction1.Id;
        newUpdate1.Object_Name__c = 'EB_Loan_Application__c';
        newUpdate1.Field_Name__c = 'Business_Purpose__c';
        newUpdate1.New_Value__c = 'Yes';
        insert newUpdate1;
        
        //Account newEntity = [SELECT id,Name, Team_Relationship_Manager__c FROM Account WHERE Team_Relationship_Manager__c !=: null limit 1 ];//testObjectClass.getTestAccount();
        EB_Loan_Application__c newApp = testObjectClass.getTestLoanApp();
        newApp.Application_Stage__c = newStage1.Id;
        //update newApp;
        
        /////////////////// test                
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(newApp);
        LoanAppStageAppActionController c = new LoanAppStageAppActionController(sc);
        
        PageReference newPage = new PageReference(c.baseURL + '/apex/LoanAppStageAction?id=' + newApp.Id);
        newPage.setRedirect(true);
        
        // test valid
        c.Initialize(newApp.Id);
        c.ddNextStatusId = newStage2.Id;
        c.SaveClicked();
        
        // test invalid
        insert newRule2;
        c.Initialize(newApp.Id);
        c.ddNextStatusId = newStage2.Id;
        c.SaveClicked();
    }
        
    static testMethod void testWithBruteForce(){
        TestUtilities.CreateLoanAppStages();
        
        EB_Loan_App_Stage__c tPendingApproval = TestUtilities.getStageByName('Pending Approval');
        EB_Loan_App_Stage__c tNew = TestUtilities.getStageByName('New');
        
        EB_Loan_Application__c testApp = testObjectClass.getTestLoanApp();
        
        ApexPages.StandardController testSC = new Apexpages.Standardcontroller(testApp);
        LoanAppStageAppActionController con = new LoanAppStageAppActionController(testSC);
        
        PageReference newPage = new PageReference(con.baseURL + '/apex/LoanAppStageAction?id=' + testApp.Id);
        newPage.setRedirect(true);
        con.currentStage = tNew;
        con.Initialize(testApp.Id);
        con.ddNextStatusId = tPendingApproval.Id;
        con.InitializeSignerOne();
        con.getApprovalPaths();         
        con.getShowPendingApprovalPanel();
        con.PendingApprovalSelected();
        con.getShowCommittee();
        con.getShowSignerOne();
        con.getShowSignerOneAndTwo();
        con.getShowSignerThree();
        con.getShowWithdrawnPanel();
        con.getStageExplanationOptions();    
        con.EmailNotificationList();
        con.EmailQueueNotificationList();
        List<String> roleList = new List<String>();
        List<SelectOption> slt = con.getApproverOneList();
        rolelist.add('Coordinator');
        roleList.add('Credit Analyst');
        roleList.add('Documentation Rep');
        roleList.add('Relationship Manager');
        roleList.add('WM Advisor');
        roleList.add('TM Rep');
        roleList.add('Secondary Officer');
        roleList.add('Bogus');
        con.EmailList(roleList);
        con.getQuotes();
        
        con.ddNextStatusId = tPendingApproval.Id;
        con.ddApprovalPath = con.threeSignaturePathText;    
        con.SaveClicked();
        con.ddApprovalPath = con.twoSignaturePathText;
        con.SaveClicked();
          
        //test prior actions
        con.currentStage = tPendingApproval;
        con.ddNextStatusId = tNew.Id;
        con.getStageExplanations();
        con.getExplanationNeeded();
        con.ExplanationNeeded();
              
        con.UpdateRecord(testApp.Id, 'EB_Loan_Application__c', 'Business_Purpose__c', 'yes');           
        con.CancelClicked();
        con.GotoNextPage();
        con.BackToMainAppPage();
        con.GotoPage('Booked');   
        con.SendEmail('','');        
        con.Bogus();            
        con.IsStageActionFieldValid(testApp.Id, 'EB_Loan_Application__c', 'Name', '=', 'bogus', 'bogusrule');           
        con.EvaluateExpression('1', '<>', '2');
        con.EvaluateExpression('1', '<=', '2');
        con.EvaluateExpression('1', '>=', '2');
        con.EvaluateExpression('a', 'regex', 'a');
        con.EvaluateExpression('a', 'in', 'a,b,c');
        con.EvaluateExpression('a', 'not in', 'a,b,c');
        con.EvaluateExpression('1', '=', '2');
        con.EvaluateExpression('1', '<', '2');
        con.EvaluateExpression('1', '>', '2');       
        
        List<EB_Stage_Action_Controller__c> dl = [SELECT Id FROM EB_Stage_Action_Controller__c];
        for(EB_Stage_Action_Controller__c d : dl) delete d;
        con.Initialize(testApp.Id);     
        
        con.SaveClicked();
    }

    static testMethod void testWithNullOperation(){
        /////////////////// initialize test
        EB_Stage_Action_Controller__c newCtrl1 = new EB_Stage_Action_Controller__c();
        newCtrl1.Name = 'TestCtrl1';
        newCtrl1.Visual_Force_Action_Page__c = '/apex/LoanAppTestActionPage';
        insert newCtrl1;
        
        EB_Stage_Action_Controller__c newCtrl2 = new EB_Stage_Action_Controller__c();
        newCtrl2.Name = 'TestCtrl2';
        newCtrl2.Visual_Force_Action_Page__c = '/apex/LoanAppTestActionPage';
        insert newCtrl2;
        
        EB_Loan_App_Stage__c newStage1 = new EB_Loan_App_Stage__c();
        newStage1.Name = 'TestStage1';
        newStage1.Loan_App_Stage_Action_Controller__c = newCtrl1.Id;
        newStage1.Sort_Order__c = 1000;
        insert newStage1;
        
        EB_Loan_App_Stage__c newStage2 = new EB_Loan_App_Stage__c();
        newStage2.Name = 'TestStage2';
        newStage2.Loan_App_Stage_Action_Controller__c = newCtrl2.Id;
        newStage2.Sort_Order__c = 2000;
        insert newStage2;
        
        EB_Loan_App_Stage_Allowed_Action__c newAction1 = new EB_Loan_App_Stage_Allowed_Action__c();
        newAction1.Stage__c = newStage2.Id;
        newAction1.Controller__c = newCtrl1.Id;
        newAction1.RecordTypeId = testObjectClass.getRecordTypeIdForName('Next Action','EB_Loan_App_Stage_Allowed_Action__c');
        insert newAction1;
        system.debug('newAction1: ' + newAction1.Type__c);
        
        EB_Loan_App_Stage_Explanation__c newExplanation1 = new EB_Loan_App_Stage_Explanation__c();
        newExplanation1.Loan_App_Stage__c = newStage1.Id;
        newExplanation1.Name = 'Test Explanation';
        insert newExplanation1;
        
        EB_Loan_App_Stage_Validation_Rule__c newRule1 = new EB_Loan_App_Stage_Validation_Rule__c();
        newRule1.EB_Loan_App_Stage__c = newStage2.Id;
        newRule1.Object_Name__c = 'EB_Loan_Application__c';
        newRule1.Field_Name__c = 'Business_Purpose__c';
        newRule1.Operation__c = '<>';
        newRule1.Operand__c = 'test';       
        insert newRule1;
        
        EB_Loan_App_Stage_Validation_Rule__c newRule2 = new EB_Loan_App_Stage_Validation_Rule__c();
        newRule2.EB_Loan_App_Stage__c = newStage2.Id;
        newRule2.Object_Name__c = 'EB_Loan_Application__c';
        newRule2.Field_Name__c = 'Business_Purpose__c';
        newRule2.Operation__c = '=';
        newRule2.Operand__c = 'test';           
        
        EB_Loan_App_Action_Field_Update__c newUpdate1 = new EB_Loan_App_Action_Field_Update__c();
        newUpdate1.Allowed_Action__c = newAction1.Id;
        newUpdate1.Object_Name__c = 'EB_Loan_Application__c';
        newUpdate1.Field_Name__c = 'Business_Purpose__c';
        newUpdate1.New_Value__c = 'Yes';
        insert newUpdate1;
        
        // Account newEntity = testObjectClass.getTestAccount();
        //Account newEntity = [SELECT id,Name, Team_Relationship_Manager__c FROM Account WHERE Team_Relationship_Manager__c !=: null limit 1 ];//testObjectClass.getTestAccount();
        EB_Loan_Application__c newApp = testObjectClass.getTestLoanApp();
        newApp.Application_Stage__c = newStage1.Id;
        //update newApp;
        
        /////////////////// test                
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(newApp);
        LoanAppStageAppActionController c = new LoanAppStageAppActionController(sc);
        
        PageReference newPage = new PageReference(c.baseURL + '/apex/LoanAppStageAction?id=' + newApp.Id);
        newPage.setRedirect(true);
        
        // test valid
        c.Initialize(null);
        c.currentStage = null;
        // c.ddNextStatusId = null;
        c.SaveClicked();
    }
   
    static testMethod void it_should_not_show_additional_appraisal_questions_when_use_evaluation_appraisal_in_file_is_false(){
        List<EB_Loan_App_Stage__c> stages = TestUtilities.CreateLoanAppStages();
        EB_Team_Member__c testRM = ObjectFactory.getTeamMember('TestRM');
        Id rtClientId = Utility.recordTypeObject('Account', 'Client').Id;
        Account entity = ObjectFactory.getEntity('Test Co', rtClientId, testRM);
        EB_Loan_Packet__c thisPacket = ObjectFactory.getLoanPacket(entity);
        EB_Account__c ebAccount = ObjectFactory.getEBAccount('Test Account2','98754',entity);
        EB_Loan_Application__c app = ObjectFactory.getLoanApplication(thisPacket, ebAccount, '12345678','Yes');
        Collateral_Code__c collCode = ObjectFactory.getCollateralCode('Real Estate', 're');
        collCode.Category__c = 'Not Real Estate';
        update collCode;
        EB_Collateral__c coll = ObjectFactory.getCollateral('home', false);
        coll.Valuation_Type__c = 'Use Appraisal in File';
        coll.Collateral_Code__c = collCode.Id;
        update coll;
        EB_Loan_App_Collateral_Relationship__c rel = new EB_Loan_App_Collateral_Relationship__c();
        rel.EB_Collateral_ID__c = coll.Id;
        rel.EB_Loan_Application_ID__c = app.Id;         
        rel.Purpose_of_Collateral__c = 'abcdefg';
        insert rel;         
        
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(app);
        ApexPages.currentPage().getParameters().put('id',String.valueOf(app.Id));
        LoanAppStageAppActionController sut = new LoanAppStageAppActionController(sc);
        sut.ddNextStatusId = stages[5].Id;
        
        String showAppraisalQuestions = sut.getShowAppraisalQuestions();
        
        System.assertEquals('false',showAppraisalQuestions);
    }
    
    static testMethod void it_should_show_additional_appraisal_questions_when_use_evaluation_appraisal_in_file_is_true(){
        List<EB_Loan_App_Stage__c> stages = TestUtilities.CreateLoanAppStages();
        EB_Team_Member__c testRM = ObjectFactory.getTeamMember('TestRM');
        Id rtClientId = Utility.recordTypeObject('Account', 'Client').Id;
        Account entity = ObjectFactory.getEntity('Test Co', rtClientId, testRM);
        EB_Loan_Packet__c thisPacket = ObjectFactory.getLoanPacket(entity);
        EB_Account__c ebAccount = ObjectFactory.getEBAccount('Test Account2','98754',entity);
        EB_Loan_Application__c app = ObjectFactory.getLoanApplication(thisPacket, ebAccount, '12345678','Yes');
        Collateral_Code__c collCode = ObjectFactory.getCollateralCode('Real Estate', 're');
        collCode.Category__c = 'Real Estate';
        update collCode;
        EB_Collateral__c coll = ObjectFactory.getCollateral('home', false);
        coll.Valuation_Type__c = 'Use Appraisal in File';
        coll.Collateral_Code__c = collCode.Id;
        update coll;
        EB_Loan_App_Collateral_Relationship__c rel = new EB_Loan_App_Collateral_Relationship__c();
        rel.EB_Collateral_ID__c = coll.Id;
        rel.EB_Loan_Application_ID__c = app.Id;         
        rel.Purpose_of_Collateral__c = 'abcdefg';
        insert rel;         
        
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(app);
        ApexPages.currentPage().getParameters().put('id',String.valueOf(app.Id));
        LoanAppStageAppActionController sut = new LoanAppStageAppActionController(sc);
        sut.ddNextStatusId = TestUtilities.getStageByName('Pending Approval').Id;
        
        String showAppraisalQuestions = sut.getShowAppraisalQuestions();
        
        System.assertEquals('true',showAppraisalQuestions);
    }

    static testMethod void it_should_require_user_select_a_new_stage_when_same_status_when_dropdown_is_same_as_current(){
        TestUtilities.CreateLoanAppStages();
        EB_Loan_App_Stage__c newStage = TestUtilities.getStageByName('New');
        EB_Loan_App_Stage__c approvedStage = TestUtilities.getStageByName('Approved');
        EB_Loan_App_Stage__c pendingApprovalStage = TestUtilities.getStageByName('Pending Approval');
        EB_Loan_Application__c newApp = testObjectClass.getTestLoanApp();
        newApp.Application_Stage__c = newStage.Id;
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(newApp);
        LoanAppStageAppActionController sut = new LoanAppStageAppActionController(sc);
        PageReference newPage = new PageReference(sut.baseURL + '/apex/LoanAppStageAction?id=' + newApp.Id);
        newPage.setRedirect(true);
        sut.Initialize(newApp.Id);
        sut.ddNextStatusId = newStage.Id;
        sut.currentStage = newStage;
        System.assertEquals('Please select a new status', sut.ValidateForm());
    }

    static testMethod void it_should_require_user_select_an_approval_path_when_none_selected(){
        TestUtilities.CreateLoanAppStages();
        EB_Loan_App_Stage__c newStage = TestUtilities.getStageByName('New');
        EB_Loan_App_Stage__c approvedStage = TestUtilities.getStageByName('Approved');
        EB_Loan_App_Stage__c pendingApprovalStage = TestUtilities.getStageByName('Pending Approval');
        EB_Loan_Application__c newApp = testObjectClass.getTestLoanApp();
        newApp.Application_Stage__c = newStage.Id;
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(newApp);
        LoanAppStageAppActionController sut = new LoanAppStageAppActionController(sc);
        PageReference newPage = new PageReference(sut.baseURL + '/apex/LoanAppStageAction?id=' + newApp.Id);
        newPage.setRedirect(true);
        sut.Initialize(newApp.Id);
        sut.ddNextStatusId = pendingApprovalStage.Id;
        sut.ddApprovalPath = sut.ddApprovalPathDefault;
        sut.currentStage = newStage;
        System.assertEquals('Please select an approval path', sut.ValidateForm());
    }

    static testMethod void it_should_not_allow_same_signer_to_be_assigned_more_than_once(){
        TestUtilities.CreateLoanAppStages();
        EB_Loan_App_Stage__c newStage = TestUtilities.getStageByName('New');
        EB_Loan_App_Stage__c approvedStage = TestUtilities.getStageByName('Approved');
        EB_Loan_App_Stage__c pendingApprovalStage = TestUtilities.getStageByName('Pending Approval');
        EB_Loan_Application__c newApp = testObjectClass.getTestLoanApp();
        newApp.Application_Stage__c = newStage.Id;
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(newApp);
        LoanAppStageAppActionController sut = new LoanAppStageAppActionController(sc);
        PageReference newPage = new PageReference(sut.baseURL + '/apex/LoanAppStageAction?id=' + newApp.Id);
        newPage.setRedirect(true);
        sut.Initialize(newApp.Id);
        sut.ddNextStatusId = pendingApprovalStage.Id;
        sut.ddApprovalPath = '3 Signatures';
        sut.currentStage = newStage;
        Id userOneID = ObjectFactory.getUser('User', 'OneTest', 'userOneTest@enterprisebank.com.test', true).Id;
        Id userTwoID = ObjectFactory.getUser('User', 'TwoTest', 'userTwoTest@enterprisebank.com.test', true).Id;
        sut.dropdownApproverOneId = userOneID;
        sut.app.Approver_Two__c = userOneID;
        sut.app.Approver_Three__c = userTwoID;
        System.assertEquals('Cannot assign the same signer more than once.', sut.ValidateForm(), 'Did not return appropriate error message when signer one and signer two were the same.');

        sut.dropdownApproverOneId = userOneID;
        sut.app.Approver_Two__c = userTwoID;
        sut.app.Approver_Three__c = userOneID;
        System.assertEquals('Cannot assign the same signer more than once.', sut.ValidateForm(), 'Did not return appropriate error message when signer one and signer three were the same.');

        sut.dropdownApproverOneId = userOneID;
        sut.app.Approver_Two__c = userTwoID;
        sut.app.Approver_Three__c = userTwoID;
        System.assertEquals('Cannot assign the same signer more than once.', sut.ValidateForm(), 'Did not return appropriate error message when signer two and signer three were the same.');
    }

    static testMethod void it_should_require_two_signers_when_two_signature_approval_path_is_selected(){
        TestUtilities.CreateLoanAppStages();
        EB_Loan_App_Stage__c newStage = TestUtilities.getStageByName('New');
        EB_Loan_App_Stage__c approvedStage = TestUtilities.getStageByName('Approved');
        EB_Loan_App_Stage__c pendingApprovalStage = TestUtilities.getStageByName('Pending Approval');
        EB_Loan_Application__c newApp = testObjectClass.getTestLoanApp();
        newApp.Application_Stage__c = newStage.Id;
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(newApp);
        LoanAppStageAppActionController sut = new LoanAppStageAppActionController(sc);
        PageReference newPage = new PageReference(sut.baseURL + '/apex/LoanAppStageAction?id=' + newApp.Id);
        newPage.setRedirect(true);
        sut.Initialize(newApp.Id);
        sut.ddNextStatusId = pendingApprovalStage.Id;
        sut.ddApprovalPath = '2 Signatures';
        sut.currentStage = newStage;
        Id userOneID = ObjectFactory.getUser('User', 'OneTest', 'userOneTest@enterprisebank.com.test', true).Id;
        Id userTwoID = ObjectFactory.getUser('User', 'TwoTest', 'userTwoTest@enterprisebank.com.test', true).Id;
        sut.dropdownApproverOneId = null;
        sut.app.Approver_Two__c = userTwoID;
        System.assertEquals('All Signers need to be filled', sut.ValidateForm(), 'Did not return appropriate error message when signer one was not chosen.');

        sut.dropdownApproverOneId = userOneID;
        sut.app.Approver_Two__c = null;
        System.assertEquals('All Signers need to be filled', sut.ValidateForm(), 'Did not return appropriate error message when signer two was not chosen.');
    }

    static testMethod void it_should_require_three_signers_when_three_signature_approval_path_is_selected(){
        TestUtilities.CreateLoanAppStages();
        EB_Loan_App_Stage__c newStage = TestUtilities.getStageByName('New');
        EB_Loan_App_Stage__c approvedStage = TestUtilities.getStageByName('Approved');
        EB_Loan_App_Stage__c pendingApprovalStage = TestUtilities.getStageByName('Pending Approval');
        EB_Loan_Application__c newApp = testObjectClass.getTestLoanApp();
        newApp.Application_Stage__c = newStage.Id;
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(newApp);
        LoanAppStageAppActionController sut = new LoanAppStageAppActionController(sc);
        PageReference newPage = new PageReference(sut.baseURL + '/apex/LoanAppStageAction?id=' + newApp.Id);
        newPage.setRedirect(true);
        sut.Initialize(newApp.Id);
        sut.ddNextStatusId = pendingApprovalStage.Id;
        sut.ddApprovalPath = '3 Signatures';
        sut.currentStage = newStage;
        Id userOneID = ObjectFactory.getUser('User', 'OneTest', 'userOneTest@enterprisebank.com.test', true).Id;
        Id userTwoID = ObjectFactory.getUser('User', 'TwoTest', 'userTwoTest@enterprisebank.com.test', true).Id;
        sut.dropdownApproverOneId = null;
        sut.app.Approver_Two__c = userOneID;
        sut.app.Approver_Three__c = userTwoID;
        System.assertEquals('All Signers need to be filled', sut.ValidateForm(), 'Did not return appropriate error message when signer one was not chosen.');

        sut.dropdownApproverOneId = userOneID;
        sut.app.Approver_Two__c = null;
        sut.app.Approver_Three__c = userTwoID;
        System.assertEquals('All Signers need to be filled', sut.ValidateForm(), 'Did not return appropriate error message when signer two was not chosen.');

        sut.dropdownApproverOneId = userOneID;
        sut.app.Approver_Two__c = userTwoID;
        sut.app.Approver_Three__c = null;
        System.assertEquals('All Signers need to be filled', sut.ValidateForm(), 'Did not return appropriate error message when signer three was not chosen.');
    }

    static testMethod void it_should_not_require_TDR_determination_to_be_filled_out_when_new_application(){
        TestUtilities.CreateLoanAppStages();
        EB_Loan_App_Stage__c newStage = TestUtilities.getStageByName('New');
        EB_Loan_App_Stage__c pendingApprovalStage = TestUtilities.getStageByName('Pending Approval');
        EB_Loan_Application__c newApp = testObjectClass.getTestNewLoanApp();
        newApp.Application_Stage__c = newStage.Id;
        update newApp;
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(newApp);
        LoanAppStageAppActionController sut = new LoanAppStageAppActionController(sc);
        sut.Initialize(newApp.Id);
        sut.ddNextStatusId = pendingApprovalStage.Id;
        sut.ddApprovalPath = '2 Signatures';

        Id userOneID = ObjectFactory.getUser('User', 'OneTest', 'userOneTest@enterprisebank.com.test', true).Id;
        Id userTwoID = ObjectFactory.getUser('User', 'TwoTest', 'userTwoTest@enterprisebank.com.test', true).Id;
        sut.dropdownApproverOneId = userOneID;
        sut.app.Approver_Two__c = userTwoID;
       
        sut.app.TDR_Determination_One__c = null;
        System.assertEquals('', sut.ValidateForm());

        sut.app.TDR_Determination_One__c = '';
        System.assertEquals('', sut.ValidateForm());
    }

    static testMethod void it_should_require_TDR_determination_to_be_filled_out_when_application_is_not_new(){
        TestUtilities.CreateLoanAppStages();
        EB_Loan_App_Stage__c newStage = TestUtilities.getStageByName('New');
        EB_Loan_App_Stage__c pendingApprovalStage = TestUtilities.getStageByName('Pending Approval');
        EB_Loan_Application__c renewalApp = testObjectClass.getTestLoanApp();
        renewalApp.Application_Stage__c = newStage.Id;
        update renewalApp;
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(renewalApp);
        LoanAppStageAppActionController sut = new LoanAppStageAppActionController(sc);
        sut.Initialize(renewalApp.Id);
        sut.ddNextStatusId = pendingApprovalStage.Id;
        sut.ddApprovalPath = '2 Signatures';

        Id userOneID = ObjectFactory.getUser('User', 'OneTest', 'userOneTest@enterprisebank.com.test', true).Id;
        Id userTwoID = ObjectFactory.getUser('User', 'TwoTest', 'userTwoTest@enterprisebank.com.test', true).Id;
        sut.dropdownApproverOneId = userOneID;
        sut.app.Approver_Two__c = userTwoID;
       
        sut.app.TDR_Determination_One__c = null;
        System.assertEquals('TDR Determination 1 needs to be filled out', sut.ValidateForm());

        sut.app.TDR_Determination_One__c = '';
        System.assertEquals('TDR Determination 1 needs to be filled out', sut.ValidateForm());
    }

    static testMethod void it_should_show_TDR_determination_fields_when_application_is_not_new(){
        TestUtilities.CreateLoanAppStages();
        EB_Loan_App_Stage__c newStage = TestUtilities.getStageByName('New');
        EB_Loan_App_Stage__c pendingApprovalStage = TestUtilities.getStageByName('Pending Approval');
        EB_Loan_Application__c renewalApp = testObjectClass.getTestLoanApp();
        renewalApp.Application_Stage__c = newStage.Id;
        update renewalApp;
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(renewalApp);
        LoanAppStageAppActionController sut = new LoanAppStageAppActionController(sc);
        sut.Initialize(renewalApp.Id);
        sut.ddNextStatusId = pendingApprovalStage.Id;
        sut.ddApprovalPath = '2 Signatures';

        Id userOneID = ObjectFactory.getUser('User', 'OneTest', 'userOneTest@enterprisebank.com.test', true).Id;
        Id userTwoID = ObjectFactory.getUser('User', 'TwoTest', 'userTwoTest@enterprisebank.com.test', true).Id;
        sut.dropdownApproverOneId = userOneID;
        sut.app.Approver_Two__c = userTwoID;
       
        String result = sut.getShowTDRquestions();

        System.assertEquals('true', result);
    }

    private static testMethod void it_should_show_TDR_determination_fields_when_1_Signature_approval_path_is_chosen_and_application_is_not_new(){
        TestUtilities.CreateLoanAppStages();
        EB_Loan_App_Stage__c newStage = TestUtilities.getStageByName('New');
        EB_Loan_App_Stage__c pendingApprovalStage = TestUtilities.getStageByName('Pending Approval');
        EB_Loan_Application__c renewalApp = testObjectClass.getTestLoanApp();
        renewalApp.Application_Stage__c = newStage.Id;
        update renewalApp;
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(renewalApp);
        LoanAppStageAppActionController sut = new LoanAppStageAppActionController(sc);
        sut.Initialize(renewalApp.Id);
        sut.ddNextStatusId = pendingApprovalStage.Id;
        sut.ddApprovalPath = '1 Signature';

        String result = sut.getShowTDRquestions();

        System.assertEquals('true', result);
    }

    private static testMethod void it_should_show_the_signer_1_field_when_the_1_Signature_approval_path_is_chosen(){
        TestUtilities.CreateLoanAppStages();
        EB_Loan_App_Stage__c newStage = TestUtilities.getStageByName('New');
        EB_Loan_App_Stage__c pendingApprovalStage = TestUtilities.getStageByName('Pending Approval');
        EB_Loan_Application__c renewalApp = testObjectClass.getTestLoanApp();
        renewalApp.Application_Stage__c = newStage.Id;
        update renewalApp;
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(renewalApp);
        LoanAppStageAppActionController sut = new LoanAppStageAppActionController(sc);
        sut.Initialize(renewalApp.Id);
        sut.ddNextStatusId = pendingApprovalStage.Id;
        sut.ddApprovalPath = '1 Signature';

        String result = sut.getShowSignerOne();

        System.assertEquals('true', result);
    }

    static testMethod void it_should_not_show_TDR_determination_fields_when_application_is_new(){
        TestUtilities.CreateLoanAppStages();
        EB_Loan_App_Stage__c newStage = TestUtilities.getStageByName('New');
        EB_Loan_App_Stage__c pendingApprovalStage = TestUtilities.getStageByName('Pending Approval');
        EB_Loan_Application__c newApp = testObjectClass.getTestNewLoanApp();
        newApp.Application_Stage__c = newStage.Id;
        update newApp;
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(newApp);
        LoanAppStageAppActionController sut = new LoanAppStageAppActionController(sc);
        sut.Initialize(newApp.Id);
        sut.ddNextStatusId = pendingApprovalStage.Id;
        sut.ddApprovalPath = '2 Signatures';

        Id userOneID = ObjectFactory.getUser('User', 'OneTest', 'userOneTest@enterprisebank.com.test', true).Id;
        Id userTwoID = ObjectFactory.getUser('User', 'TwoTest', 'userTwoTest@enterprisebank.com.test', true).Id;
        sut.dropdownApproverOneId = userOneID;
        sut.app.Approver_Two__c = userTwoID;
       
        String result = sut.getShowTDRquestions();

        System.assertEquals('false', result);
    }

    private static testMethod void it_should_display_a_validation_exception_if_a_required_field_business_purpose_is_missing(){
        //Assemble
        TestUtilities.CreateLoanAppStages();
        TestUtilities.createValidationRules();
        EB_Loan_App_Stage__c newStage = TestUtilities.getStageByName('New');
        EB_Loan_App_Stage__c approvedStage = TestUtilities.getStageByName('Approved');
        EB_Loan_App_Stage__c pendingApprovalStage = TestUtilities.getStageByName('Pending Approval');

        EB_Team_Member__c testRM = ObjectFactory.getTeamMember('TestRM');
        Id rtClientId = Utility.recordTypeObject('Account', 'Client').Id;
        Account entity = ObjectFactory.getEntity('Test Co', rtClientId, testRM);
        EB_Loan_Packet__c thisPacket = ObjectFactory.getLoanPacket(entity);
        EB_Account__c ebAccount = ObjectFactory.getEBAccount('Test Account2','98754',entity);
        EB_Loan_Application__c newApp = ObjectFactory.getLoanApplication(thisPacket, ebAccount, '12345678','Yes');

        newApp.Application_Stage__c = newStage.Id;
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(newApp);
        LoanAppStageAppActionController sut = new LoanAppStageAppActionController(sc);
        PageReference newPage = new PageReference(sut.baseURL + '/apex/LoanAppStageAction?id=' + newApp.Id);
        newPage.setRedirect(true);
        sut.Initialize(newApp.Id);
        sut.ddNextStatusId = pendingApprovalStage.Id;
        sut.ddApprovalPath = '2 Signatures';
        sut.currentStage = newStage;
        Id userOneID = ObjectFactory.getUser('User', 'OneTest', 'userOneTest@enterprisebank.com.test', true).Id;
        Id userTwoID = ObjectFactory.getUser('User', 'TwoTest', 'userTwoTest@enterprisebank.com.test', true).Id;
        sut.dropdownApproverOneId = userOneID;
        sut.app.Approver_Two__c = userTwoID;
        sut.app.TDR_Determination_One__c = 'Borrower is not experiencing financial difficulty';
        sut.app.TDR_Detail_Justification__c = 'bogus';
        sut.IsValidationRequired = true;

        //Act
        Test.Starttest();
        String returnedValidation = sut.ValidateForm();
        Test.StopTest();

        //Assert
        System.assertEquals(true, returnedValidation.contains('Loan Purpose is required'));
    }

    private static testMethod void it_should_not_diplay_a_validation_exception_if_required_relatedEntity_relatedCollateral_packet_and_loan_app_and_payment_stream_arefilled_out(){
        //Assemble
        TestUtilities.CreateLoanAppStages();
        TestUtilities.createValidationRules();
        Date d = Date.newInstance(2013,2,3);
        EB_Industry_Code__c newIndustryCode = new EB_Industry_Code__c();
        newIndustryCode.Industry_Code__c = '34';
        newIndustryCode.Industry_Description__c = 'test';
        insert newIndustryCode;
        EB_Loan_App_Stage__c newStage = TestUtilities.getStageByName('New');
        EB_Loan_App_Stage__c approvedStage = TestUtilities.getStageByName('Approved');
        EB_Loan_App_Stage__c pendingApprovalStage = TestUtilities.getStageByName('Pending Approval');

        EB_Team_Member__c testRM = ObjectFactory.getTeamMember('TestRM');
        Id rtClientId = Utility.recordTypeObject('Account', 'Client').Id;
        Account entity = ObjectFactory.getEntity('Test Co', rtClientId, testRM);
        entity.SSNTIN_Encrypted__c = '23223232';
        entity.Last_Financial_Statement__c = d;
        entity.State_Of_Incorporation__c = 'MO';
        update entity;
        EB_Loan_Packet__c thisPacket = ObjectFactory.getLoanPacket(entity);
        thisPacket.Documentation_Path__c = 'Internal Documentation';
        thisPacket.AppPathQ1__c = 2000000;
        thisPacket.AppPathQ2__c = 'NO';
        thisPAcket.AppPathQ3__c = 'NO';
        update thisPacket;
        EB_Account__c ebAccount = ObjectFactory.getEBAccount('Test Account2','98754',entity);
        EB_Loan_Application__c newApp = ObjectFactory.getLoanApplication(thisPacket, ebAccount, '12345678',false);
        newApp.Business_Purpose__c = 'Yes';
        newApp.Purpose_of_Loan__c = 'Awesome deal';
        newApp.Credit_Rating__c = 'RR9 - Doubtful Credit';
        newApp.Bank_Owned_Loan_Amount__c = 1000;
        newApp.Revenue_Code__c = '$0 - 1 Million - this includes start up businesse';
        newApp.Loan_Type__c = 'Fixed Line';
        newApp.Annual_Income__c = 12.25;
        newApp.Application_Stage__c = newStage.Id;
        newApp.Maturity_Term_In_Months__c = 60;
        newApp.EB_Account_Industry_Code__c = newIndustryCode.Id;
        newApp.NAICS_Code__c = 'test';
        insert newApp;

        Collateral_Code__c collCode = ObjectFactory.getCollateralCode('Real Estate', 're');
        collCode.Category__c = 'Real Estate';
        update collCode;
        EB_Collateral__c coll = ObjectFactory.getCollateral('home', false);
        coll.Valuation_Type__c = 'Use Appraisal in File';
        coll.Collateral_Code__c = collCode.Id;
        update coll;
        EB_Loan_App_Collateral_Relationship__c colRel = new EB_Loan_App_Collateral_Relationship__c();
        colRel.EB_Collateral_ID__c = coll.Id;
        colRel.EB_Loan_Application_ID__c = newApp.Id;         
        colRel.Purpose_of_Collateral__c = 'abcdefg';
        insert colRel;

        EB_Loan_App_Entity_Relationship__c entityRel = ObjectFactory.getLoanAppEntityRelationship(entity, newApp);

        EB_Loan_Application_Payment_Stream__c testPaymentStream = new EB_Loan_Application_Payment_Stream__c();
        testPaymentStream.Number_of_Payments_for_Roll_up__c =60;
        testPaymentStream.EB_Loan_Application__c = newApp.Id;
        testPaymentStream.Duration_in_Months__c = 60;
        insert testPaymentStream;

        
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(newApp);
        LoanAppStageAppActionController sut = new LoanAppStageAppActionController(sc);
        PageReference newPage = new PageReference(sut.baseURL + '/apex/LoanAppStageAction?id=' + newApp.Id);
        newPage.setRedirect(true);
        sut.Initialize(newApp.Id);
        sut.ddNextStatusId = pendingApprovalStage.Id;
        sut.ddApprovalPath = '2 Signatures';
        sut.currentStage = newStage;
        Id userOneID = ObjectFactory.getUser('User', 'OneTest', 'userOneTest@enterprisebank.com.testOne', true).Id;
        Id userTwoID = ObjectFactory.getUser('User', 'TwoTest', 'userTwoTest@enterprisebank.com.testTwo', true).Id;
        sut.dropdownApproverOneId = userOneID;
        sut.app.Approver_Two__c = userTwoID;
        sut.app.TDR_Determination_One__c = 'Borrower is not experiencing financial difficulty';
        sut.app.TDR_Detail_Justification__c = 'bogus';
        sut.IsValidationRequired = true;

        //Act
        Test.Starttest();
        String returnedValidation = sut.ValidateForm();
        Test.StopTest();

        //Assert
        System.assertEquals('', returnedValidation);
    }

}