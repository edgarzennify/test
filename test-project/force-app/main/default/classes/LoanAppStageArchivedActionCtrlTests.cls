@IsTest
public class LoanAppStageArchivedActionCtrlTests {

	 public static testMethod void testWithNormalOperation(){
                /////////////////// initialize test
            
            TestUtilities.CreateLoanAppStages();
            EB_Stage_Action_Controller__c newCtrl1 = new EB_Stage_Action_Controller__c();
            newCtrl1.Name = 'TestCtrl1';
            newCtrl1.Visual_Force_Action_Page__c = '/apex/LoanAppTestActionPage';
            insert newCtrl1;
            
            EB_Stage_Action_Controller__c newCtrl2 = new EB_Stage_Action_Controller__c();
            newCtrl2.Name = 'TestCtrl2';
            newCtrl2.Visual_Force_Action_Page__c = '/apex/LoanAppTestActionPage';
            insert newCtrl2;
            system.debug('TestCtrl1: '+ newCtrl1.Id );
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
            
            EB_Loan_App_Stage_Allowed_Action__c newActionInterim1 = new EB_Loan_App_Stage_Allowed_Action__c();
            newActionInterim1.Stage__c = newStage1.Id;
            newActionInterim1.Controller__c = newCtrl2.Id;
            newActionInterim1.RecordTypeId = testObjectClass.getRecordTypeIdForName('Next Action','EB_Loan_App_Stage_Allowed_Action__c');
            insert newActionInterim1;
            
            EB_Loan_App_Stage_Allowed_Action__c newAction1 = [SELECT Id, Type__c ,Stage__c, Name, Controller__c,RecordTypeId FROM EB_Loan_App_Stage_Allowed_Action__c WHERE id =: newActionInterim1.Id];
            
            EB_Loan_App_Stage_Allowed_Action__c newActionInterim2 = new EB_Loan_App_Stage_Allowed_Action__c();
            newActionInterim2.Stage__c = newStage2.Id;
            newActionInterim2.Controller__c = newCtrl1.Id;
            newActionInterim2.RecordTypeId = testObjectClass.getRecordTypeIdForName('Next Action','EB_Loan_App_Stage_Allowed_Action__c');
            
            insert newActionInterim2;
            EB_Loan_App_Stage_Allowed_Action__c newAction2 = [SELECT Id, Type__c ,Stage__c, Name, Controller__c,RecordTypeId FROM EB_Loan_App_Stage_Allowed_Action__c WHERE id =: newActionInterim2.Id];
                
            EB_Loan_App_Stage_Explanation__c newExplanation1 = new EB_Loan_App_Stage_Explanation__c();
            
            newExplanation1.Loan_App_Stage__c = newStage1.Id;
            newExplanation1.Name = 'Test Explanation';
            newExplanation1.type__c = 'Next Action';
            insert newExplanation1;
                
                
            EB_Loan_App_Stage_Explanation__c newExplanation3 = new EB_Loan_App_Stage_Explanation__c();
            newExplanation3.Loan_App_Stage__c = newStage2.Id;
            newExplanation3.Name = 'Test Explanation';
            newExplanation3.type__c = 'Next Action';
            insert newExplanation3;
                          
                
            EB_Loan_App_Action_Field_Update__c newUpdate1 = new EB_Loan_App_Action_Field_Update__c();
            newUpdate1.Allowed_Action__c = newAction1.Id;
            newUpdate1.Object_Name__c = 'EB_Booked_Loan_App__c';
            newUpdate1.Field_Name__c = 'Business_Purpose__c';
            newUpdate1.New_Value__c = 'Yes';
            insert newUpdate1;
                
            Account newEntity = ObjectFactory.getValidEntity('testEntity');//testObjectClass.getTestAccount();
            EB_Booked_Loan_App__c newApp = testObjectClass.getTestArchivedApp(newEntity);
            newApp.Application_Stage__c = newStage1.Id;
            newApp.Stage_Explanation__c = 'test;test1';
            newApp.Stage_Comment__c = 'test';
            update newApp;
                
            /////////////////// test                
            Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(newApp);
            LoanAppStageArchivedActionController c = new LoanAppStageArchivedActionController(sc);
                
            PageReference newPage = new PageReference(c.baseURL + '/apex/LoanArchivedStageAction?id=' + newApp.Id);
            newPage.setRedirect(true);
            
            // test valid
            c.Initialize(newApp.Id);
            c.ddNextStatusId = newStage2.Id;
            c.currentstage = [SELECT id, name,Loan_App_Stage_Action_Controller__c, Sort_Order__c FROM EB_Loan_App_Stage__c WHERE id =:newStage1.Id ];
            system.debug('stdController: ' + c.stageController.Id + 'controller1' + newCtrl1.Id + 'controller2' + newCtrl2.Id);
          
           
           for(EB_Loan_App_Stage_Allowed_Action__c testList : [SELECT Id, Name, Type__c, Stage__r.Id, Stage__r.Name,Controller__c, (SELECT Id, Object_Name__c, Field_Name__c, New_Value__c FROM EB_Loan_App_Action_Field_Updates__r) FROM EB_Loan_App_Stage_Allowed_Action__c WHERE Controller__c =: c.stageController.Id  AND Stage__r.Id !=: c.CurrentStage.Id ORDER BY Type__c, Stage__r.Sort_Order__c LIMIT 500]){
            	system.debug('testList%% ' + testList.Controller__c + ' : stage: ' + testList.Stage__r.Name);
            }
            c.SaveClicked();
            PageReference pcancel = c.CancelClicked();
            pcancel = c.bogus();
            c.currentstage = null;
            c.SaveClicked();
            
            
        } 

         public static testMethod void testNullOperation(){
                /////////////////// initialize test
            TestUtilities.CreateLoanAppStages();
            EB_Stage_Action_Controller__c newCtrl1 = new EB_Stage_Action_Controller__c();
            newCtrl1.Name = 'TestCtrl1';
            newCtrl1.Visual_Force_Action_Page__c = '/apex/LoanAppTestActionPage';
            insert newCtrl1;
            
            EB_Stage_Action_Controller__c newCtrl2 = new EB_Stage_Action_Controller__c();
            newCtrl2.Name = 'TestCtrl2';
            newCtrl2.Visual_Force_Action_Page__c = '/apex/LoanAppTestActionPage';
            insert newCtrl2;
            system.debug('TestCtrl1: '+ newCtrl1.Id );
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
            
            EB_Loan_App_Stage_Allowed_Action__c newActionInterim1 = new EB_Loan_App_Stage_Allowed_Action__c();
            newActionInterim1.Stage__c = newStage1.Id;
            newActionInterim1.Controller__c = newCtrl2.Id;
            newActionInterim1.RecordTypeId = testObjectClass.getRecordTypeIdForName('Next Action','EB_Loan_App_Stage_Allowed_Action__c');
            insert newActionInterim1;
            
            EB_Loan_App_Stage_Allowed_Action__c newAction1 = [SELECT Id, Type__c ,Stage__c, Name, Controller__c,RecordTypeId FROM EB_Loan_App_Stage_Allowed_Action__c WHERE id =: newActionInterim1.Id];
            
            EB_Loan_App_Stage_Allowed_Action__c newActionInterim2 = new EB_Loan_App_Stage_Allowed_Action__c();
            newActionInterim2.Stage__c = newStage2.Id;
            newActionInterim2.Controller__c = newCtrl1.Id;
            newActionInterim2.RecordTypeId = testObjectClass.getRecordTypeIdForName('Next Action','EB_Loan_App_Stage_Allowed_Action__c');
            
            insert newActionInterim2;
            EB_Loan_App_Stage_Allowed_Action__c newAction2 = [SELECT Id, Type__c ,Stage__c, Name, Controller__c,RecordTypeId FROM EB_Loan_App_Stage_Allowed_Action__c WHERE id =: newActionInterim2.Id];
                
            EB_Loan_App_Stage_Explanation__c newExplanation1 = new EB_Loan_App_Stage_Explanation__c();
            
            newExplanation1.Loan_App_Stage__c = newStage1.Id;
            newExplanation1.Name = 'Test Explanation';
            newExplanation1.type__c = 'Next Action';
            insert newExplanation1;
                
                
            EB_Loan_App_Stage_Explanation__c newExplanation3 = new EB_Loan_App_Stage_Explanation__c();
            newExplanation3.Loan_App_Stage__c = newStage2.Id;
            newExplanation3.Name = 'Test Explanation';
            newExplanation3.type__c = 'Next Action';
            insert newExplanation3;
                        
                
            EB_Loan_App_Action_Field_Update__c newUpdate1 = new EB_Loan_App_Action_Field_Update__c();
            newUpdate1.Allowed_Action__c = newAction1.Id;
            newUpdate1.Object_Name__c = 'EB_Booked_Loan_App__c';
            newUpdate1.Field_Name__c = 'Business_Purpose__c';
            newUpdate1.New_Value__c = 'Yes';
            insert newUpdate1;
                
            Account newEntity = ObjectFactory.getValidEntity('testEntity');//testObjectClass.getTestAccount();
            //EB_Booked_Loan_App__c newApp = testObjectClass.getTestArchivedApp(newEntity);
            EB_Booked_Loan_App__c newApp = new EB_Booked_Loan_App__c();
            insert newApp;
            newApp.Application_Stage__c = newStage1.Id;
            newApp.Stage_Explanation__c = 'test;test1';
            newApp.Stage_Comment__c = 'test';
            update newApp;
                
            /////////////////// test                
            Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(newApp);
            LoanAppStageArchivedActionController c = new LoanAppStageArchivedActionController(sc);
                
            PageReference newPage = new PageReference(c.baseURL + '/apex/LoanArchivedStageAction?id=' + null);
            newPage.setRedirect(true);
            
            // test valid
            c.Initialize(null);

            c.SaveClicked();
            PageReference pcancel = c.CancelClicked();
            pcancel = c.bogus();
            
         
            
        } 

        public static testMethod void testWithBruteForce(){
            TestUtilities.CreateLoanAppStages();
            EB_Stage_Action_Controller__c newCtrl1 = new EB_Stage_Action_Controller__c();
            newCtrl1.Name = 'TestCtrl1';
            newCtrl1.Visual_Force_Action_Page__c = '/apex/LoanAppTestActionPage';
            insert newCtrl1;
            
            EB_Stage_Action_Controller__c newCtrl2 = new EB_Stage_Action_Controller__c();
            newCtrl2.Name = 'TestCtrl2';
            newCtrl2.Visual_Force_Action_Page__c = '/apex/LoanAppTestActionPage';
            insert newCtrl2;
            system.debug('TestCtrl1: '+ newCtrl1.Id );
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
            
            EB_Loan_App_Stage_Allowed_Action__c newActionInterim1 = new EB_Loan_App_Stage_Allowed_Action__c();
            newActionInterim1.Stage__c = newStage1.Id;
            newActionInterim1.Controller__c = newCtrl2.Id;
            newActionInterim1.RecordTypeId = testObjectClass.getRecordTypeIdForName('Next Action','EB_Loan_App_Stage_Allowed_Action__c');
            insert newActionInterim1;
            
            EB_Loan_App_Stage_Allowed_Action__c newAction1 = [SELECT Id, Type__c ,Stage__c, Name, Controller__c,RecordTypeId FROM EB_Loan_App_Stage_Allowed_Action__c WHERE id =: newActionInterim1.Id];
            
            EB_Loan_App_Stage_Allowed_Action__c newActionInterim2 = new EB_Loan_App_Stage_Allowed_Action__c();
            newActionInterim2.Stage__c = newStage2.Id;
            newActionInterim2.Controller__c = newCtrl1.Id;
            newActionInterim2.RecordTypeId = testObjectClass.getRecordTypeIdForName('Next Action','EB_Loan_App_Stage_Allowed_Action__c');
            
            insert newActionInterim2;
            EB_Loan_App_Stage_Allowed_Action__c newAction2 = [SELECT Id, Type__c ,Stage__c, Name, Controller__c,RecordTypeId FROM EB_Loan_App_Stage_Allowed_Action__c WHERE id =: newActionInterim2.Id];
                
            EB_Loan_App_Stage_Explanation__c newExplanation1 = new EB_Loan_App_Stage_Explanation__c();
            
            newExplanation1.Loan_App_Stage__c = newStage1.Id;
            newExplanation1.Name = 'Test Explanation';
            newExplanation1.type__c = 'Next Action';
            insert newExplanation1;
                

                
            EB_Loan_App_Stage_Explanation__c newExplanation3 = new EB_Loan_App_Stage_Explanation__c();
            newExplanation3.Loan_App_Stage__c = newStage2.Id;
            newExplanation3.Name = 'Test Explanation';
            newExplanation3.type__c = 'Next Action';
            insert newExplanation3;
                
          
                
            EB_Loan_App_Action_Field_Update__c newUpdate1 = new EB_Loan_App_Action_Field_Update__c();
            newUpdate1.Allowed_Action__c = newAction1.Id;
            newUpdate1.Object_Name__c = 'EB_Booked_Loan_App__c';
            newUpdate1.Field_Name__c = 'Business_Purpose__c';
            newUpdate1.New_Value__c = 'Yes';
            insert newUpdate1;
                
            Account newEntity = ObjectFactory.getValidEntity('testEntity');//testObjectClass.getTestAccount();
            EB_Booked_Loan_App__c newApp = testObjectClass.getTestArchivedApp(newEntity);
            newApp.Application_Stage__c = newStage1.Id;
            newApp.Stage_Explanation__c = 'test;test1';
            newApp.Stage_Comment__c = 'test';
            update newApp;
                
            /////////////////// test                
            Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(newApp);
            LoanAppStageArchivedActionController con = new LoanAppStageArchivedActionController(sc);
                
            PageReference newPage = new PageReference(con.baseURL + '/apex/LoanArchivedStageAction?id=' + newApp.Id);
            newPage.setRedirect(true);
            
            // test valid
            con.Initialize(newApp.Id);
            con.ddNextStatusId = newStage2.Id;
            con.currentstage = [SELECT id, name,Loan_App_Stage_Action_Controller__c, Sort_Order__c FROM EB_Loan_App_Stage__c WHERE id =:newStage1.Id ];
            con.getAllowedActions();         
            con.getShowPendingApprovalPanel();
            con.PendingApprovalSelected();
   
            con.getStageExplanationOptions();    
            con.EmailNotificationList();
            con.EmailQueueNotificationList();

            List<String> roleList = new List<String>();

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
      
            con.getStageExplanations();
                con.getExplanationNeeded();
                con.ExplanationNeeded();
                                
            con.UpdateRecord(newApp.Id, 'EB_Booked_Loan_App__c', 'Business_Purpose__c', 'yes');           
            
            con.SendEmail('','');        
            
            con.IsStageActionFieldValid(newApp.Id, 'EB_Booked_Loan_App__c', 'Name', '=', 'bogus', 'bogusrule');           
            con.EvaluateExpression('1', '<>', '2');
            con.EvaluateExpression('1', '<=', '2');
            con.EvaluateExpression('1', '>=', '2');
            con.EvaluateExpression('a', 'regex', 'a');
            con.EvaluateExpression('a', 'in', 'a,b,c');
            con.EvaluateExpression('a', 'not in', 'a,b,c');
            con.EvaluateExpression('1', '=', '2');
            con.EvaluateExpression('1', '<', '2');
            con.EvaluateExpression('1', '>', '2');       
            String msg = con.SendEmailHelper();
            EB_Loan_App_Stage_Explanation__c testexplain = [SELECT Id, Name FROM EB_Loan_App_Stage_Explanation__c  WHERE Loan_App_Stage__c =: con.ddNextStatusId  AND Type__c =: 'Next Action' ORDER BY Name LIMIT 1];
         	system.debug('testexplain:' + testexplain.Id);
   
        }
}