@IsTest
public class LoanAppraisalOrderValidationTests{
	public static testMethod void verifyAppraisalPageReference(){
             String url = utility.getserverurl() +'/apex/AppraisalOrderValidation';
               TestUtilities.createLoanAppStages();
                EB_Loan_Application__c app = ObjectFactory.getLoanApplication('testEntity', 'ebname', '1234-15', 'testApp');
                
                EB_Collateral__c col = ObjectFactory.getCollateral('testCollateral', false);
                EB_Loan_App_Collateral_Relationship__c rel = new EB_Loan_App_Collateral_Relationship__c();
        		rel.EB_Collateral_ID__c = col.id;
                rel.EB_Loan_Application_ID__c = app.Id;
                rel.Purpose_of_Collateral__c = 'test';
        		insert rel;
                
                 EB_Appraisal_Order__c appraisal = new EB_Appraisal_Order__c();
                 //EB_Collateral__c  testCollateral = ObjectFactory.getCollateral('testcollateral2', false);
        
                 appraisal.Related_Collateral__r = col;
                 appraisal.Related_Collateral__c = col.Id;
        	
                 INSERT appraisal;
                  PageReference pr = utility.testhelper(url +  '?aid=' + col.id + '&uid=' + rel.Id );
                  test.setCurrentPage(pr);
                  ApexPages.StandardController sc = new Apexpages.Standardcontroller(appraisal);
                  LoanAppraisalOrderValidationController testcontroller = new LoanAppraisalOrderValidationController(sc);
                 PageReference ref = testcontroller.ValidateAppraisalOrderEntry();
                 ref = testcontroller.BackToCollateralRelationship();

  }
   public static testMethod void verifyAppraisalMethods(){
             String url = utility.getserverurl() + '/apex/AppraisalOrderValidation';
               
                TestUtilities.createLoanAppStages();
                EB_Loan_Application__c app = ObjectFactory.getLoanApplication('testEntity', 'ebname', '1234-15', 'testApp');
                
                EB_Collateral__c col = ObjectFactory.getCollateral('testCollateral', false);
                EB_Loan_App_Collateral_Relationship__c rel = new EB_Loan_App_Collateral_Relationship__c();
        		rel.EB_Collateral_ID__c = col.id;
                rel.EB_Loan_Application_ID__c = app.Id;
                rel.Purpose_of_Collateral__c = 'test';
        		insert rel;
                
                 EB_Appraisal_Order__c appraisal = new EB_Appraisal_Order__c();
                 //EB_Collateral__c  testCollateral = ObjectFactory.getCollateral('testcollateral', false);
                 appraisal.Related_Collateral__r = col;
                 appraisal.Related_Collateral__c = col.Id;
                 INSERT appraisal;
               PageReference pr = utility.testhelper(url +  '?aid=' + col.id + '&uid=' + rel.Id );
               test.setCurrentPage(pr);
               ApexPages.StandardController sc = new Apexpages.Standardcontroller(appraisal);
               LoanAppraisalOrderValidationController testcontroller = new LoanAppraisalOrderValidationController(sc);
               testcontroller.getQueryParameters();
               testcontroller.initialize();
               testcontroller.setMode();
   }
}