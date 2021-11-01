@istest
public class LoanAppStageActionControllerTests {
	 public static testMethod void testWithNormalOperation(){
        TestUtilities.CreateLoanAppStages();

        EB_Loan_App_Stage__c newStage1 = TestUtilities.getStageByName('New');
        EB_Loan_App_Stage__c newStage2 = TestUtilities.getStageByName('Approved');
            
        EB_Loan_App_Stage_Allowed_Action__c newAction1 = new EB_Loan_App_Stage_Allowed_Action__c();
        newAction1.Stage__c = newStage2.Id;
        newAction1.Controller__c = newStage2.Loan_App_Stage_Action_Controller__c;
        newAction1.RecordTypeId = testObjectClass.getRecordTypeIdForName('Next Action','EB_Loan_App_Stage_Allowed_Action__c');
        insert newAction1;
                
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
        
        Account newEntity = testObjectClass.getTestAccount();
        EB_Loan_Application__c newApp = testObjectClass.getTestLoanApp(newEntity);
        newApp.Application_Stage__c = newStage1.Id;
        update newApp;
            
        /////////////////// test                
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(newApp);
        LoanAppStageActionController c = new LoanAppStageActionController(sc);
            
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
        
    public static testMethod void testWithBruteForce(){
    	TestUtilities.CreateLoanAppStages();
        EB_Loan_App_Stage__c tPendingApproval;
        EB_Loan_App_Stage__c tNew;
            
        Account testEntity = testObjectClass.getTestAccount();
        EB_Loan_Application__c testApp = testObjectClass.getTestLoanApp(testEntity);
        List<EB_Loan_App_Stage__c> testStages = [SELECT Id, Name, Loan_App_Stage_Action_Controller__c FROM EB_Loan_App_Stage__c limit 100];
            
        ApexPages.StandardController testSC = new Apexpages.Standardcontroller(testApp);
        LoanAppStageActionController con = new LoanAppStageActionController(testSC);
                
        PageReference newPage = new PageReference(con.baseURL + '/apex/LoanAppStageAction?id=' + testApp.Id);
        newPage.setRedirect(true);
        
        con.debug_RecordLog('Test');
        con.Initialize(testApp.Id);
        con.ddNextStatusId = testStages[0].Id;
        con.InitializeSignerOne();
        con.getAllowedActions();
        con.getApprovalPaths();         
        con.getShowPendingApprovalPanel();
        con.PendingApprovalSelected();
        con.getShowCommittee();
        con.getShowSignerOne();
        con.getShowSignerOneAndTwo();
        con.getShowSignerThree();
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
        for(EB_Loan_App_Stage__c s : testStages){   
            if(s.Name == 'Pending Approval') tPendingApproval = s;                          
            if(s.Name == 'New') tNew = s;                           
        }
            
        con.currentStage = tNew;
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
        con.SendEmail();        
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
        
        con.LoanAppId = null;
        con.SaveClicked();
    }
}