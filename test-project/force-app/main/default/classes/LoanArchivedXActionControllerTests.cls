@isTest
private class LoanArchivedXActionControllerTests {
	
    private static testMethod void verifyLoanArchivedXActionPageReference(){
        String Url = Utility.getServerUrl() + '/apex/LoanArchivedCheckbackAction?id=';

        TestUtilities.CreateLoanAppStages();

        EB_Loan_App_Stage__c newStage1 = TestUtilities.getStageByName('New');
        EB_Loan_App_Stage__c newStage2 = TestUtilities.getStageByName('Pending Approval');
        
        EB_Loan_App_Stage_Allowed_Action__c newActionInterim1 = new EB_Loan_App_Stage_Allowed_Action__c();
        newActionInterim1.Stage__c = newStage1.Id;
        newActionInterim1.Controller__c = newStage1.Loan_App_Stage_Action_Controller__c;
        newActionInterim1.RecordTypeId = testObjectClass.getRecordTypeIdForName('Next Action','EB_Loan_App_Stage_Allowed_Action__c');
        insert newActionInterim1;
        
        EB_Loan_App_Stage_Allowed_Action__c newAction1 = [SELECT Id, Type__c ,Stage__c, Name, Controller__c,RecordTypeId FROM EB_Loan_App_Stage_Allowed_Action__c WHERE id =: newActionInterim1.Id];
        
        EB_Loan_App_Stage_Allowed_Action__c newActionInterim2 = new EB_Loan_App_Stage_Allowed_Action__c();
        newActionInterim2.Stage__c = newStage2.Id;
        newActionInterim2.Controller__c = newStage2.Loan_App_Stage_Action_Controller__c;
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

        Account newEntity = testObjectClass.getTestAccount();
        EB_Booked_Loan_App__c newApp = testObjectClass.getTestArchivedApp(newEntity);
        newApp.Application_Stage__c = newStage1.Id;
        newApp.Stage_Explanation__c = 'test;test1';
        newApp.Stage_Comment__c = 'test';
        update newApp;
    
        PageReference pr = urlhelper(url +  newApp.Id);
        test.setCurrentPage(pr);
        ApexPages.StandardController sc = new Apexpages.Standardcontroller(newApp);
        LoanArchivedXActionController testcontroller = new LoanArchivedXActionController (sc);
        PageReference predirect = testcontroller.RedirectURL();
	}

	private static PageReference urlhelper(String url){
        PageReference newPage = new PageReference(url);
        newPage.setRedirect(true);
        return newPage;
    }

}