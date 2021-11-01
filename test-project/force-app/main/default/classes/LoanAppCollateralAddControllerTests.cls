@isTest
public class LoanAppCollateralAddControllerTests {
    public static testMethod void verifyLoanAppCollteralAddPageReference(){
             //String url = 'https://cs3.salesforce.com/LoanAppCollateralAdd?aid=';
                 String url = Utility.getServerUrl() +'/apex/LoanAppCollateralAdd?aid=';
                 Account acctProspect = testObjectClass.getTestAccount();
                 EB_Loan_Application__c app = testObjectClass.getTestLoanApp(acctProspect);
                
                 PageReference pr = Utility.testhelper(url + app.Id);
                 test.setCurrentPage(pr);
                 ApexPages.StandardController sc = new Apexpages.Standardcontroller(app);
                 LoanAppCollateralAddController testcontroller = new LoanAppCollateralAddController(sc);
                 PageReference  psearch = testcontroller.SetSearch();
                 PageReference psave  = testcontroller.SaveCollateral();
                 PageReference psaveNew  = testcontroller.SaveNewCollateral();
                 PageReference pCancel = testcontroller.CancelCollateral();
                 pCancel =  Utility.testhelper('http://www.salesforce.com');
                // delete acctProspect;
                // delete app;
                 
    }
    
    public static testMethod void verifyLoanAppCollteralAddPageReferenceSecond(){
             //String url = 'https://cs3.salesforce.com/LoanAppCollateralAdd?aid=';
                 String url = Utility.getServerUrl()+ '/apex/LoanAppCollateralAdd?aid=';
                 Account acctProspect = testObjectClass.getTestAccount();
                 EB_Loan_Application__c app = testObjectClass.getTestLoanApp(acctProspect);
                
                 PageReference pr = Utility.testhelper(url);
                 test.setCurrentPage(pr);
                 ApexPages.StandardController sc = new Apexpages.Standardcontroller(app);
                 LoanAppCollateralAddController testcontroller = new LoanAppCollateralAddController(sc);
                 PageReference  psearch = testcontroller.SetSearch();
                 PageReference psave  = testcontroller.SaveCollateral();
                 PageReference psaveNew  = testcontroller.SaveNewCollateral();
                 PageReference pCancel = testcontroller.CancelCollateral();
                 pCancel =  Utility.testhelper('http://www.salesforce.com');
                // delete acctProspect;
                // delete app;
    }
    
    public static testMethod void verifyLoanAppCollteralAddMethod(){
         TestUtilities.createLoanAppStages();
         TestUtilities.createValidationRules();
         TestUtilities.createCollateralCodes();
         
         String url = Utility.getServerUrl()+ '/apex/LoanAppCollateralAdd?aid=';
         
         Account acctProspect = testObjectClass.getTestAccount();
         EB_Loan_Application__c app = testObjectClass.getTestLoanApp(acctProspect);
         PageReference pr = Utility.testhelper(url + app.Id);
         test.setCurrentPage(pr);
         ApexPages.StandardController sc = new Apexpages.Standardcontroller(app);
         LoanAppCollateralAddController testcontroller = new LoanAppCollateralAddController(sc);
         
         List<selectoption> names = testcontroller.getCollateralNames();
         String name =  testcontroller.getLoanApplicationName;
         String selected = testcontroller.getLoanAppSelected();
         EB_Collateral__c col = testObjectClass.getTestCollateralObj();
         //EB_Collateral__c col = [SELECT Id, Name FROM EB_Collateral__c WHERE Name != null limit 1];
         EB_Collateral_Client_Relationship__c rel = new EB_Collateral_Client_Relationship__c();
         rel.Client_ID__c = acctProspect.Id;
         rel.EB_Collateral_ID__c = col.Id;
         insert rel;
        // String ownerlist = testcontroller.getOwnerListForReadOnlyStatus(col.Id);
         testcontroller.selectedCollateralId = col.Id;
         testcontroller.getCollateralFound();
         testcontroller.getNoCollateralFound();
//       String ur =  LoanAppCollateralAddController.getServerUrl();
         List<SelectOption> unsorts = new List<SelectOption>();
           unsorts.add(new SelectOption('a' , 'a'));
           unsorts.add(new SelectOption('b' , 'b')); 
           unsorts.add(new SelectOption('c' , 'c'));            
         List<SelectOption> sortlist = LoanAppCollateralAddController.SortOptionList(unsorts);
        // delete acctProspect;
        // delete app;
    }
}