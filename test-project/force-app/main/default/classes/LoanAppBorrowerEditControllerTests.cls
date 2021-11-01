@isTest
public class LoanAppBorrowerEditControllerTests {
	
	//Null Query parameter
  	public static testMethod void verifyLoanAppBorrowerEditControllerNullParameterBorrowerPage(){
        String url = Utility.getServerUrl() + '/apex/LoanAppBorrowerEdit';
        Account acctProspect = testObjectClass.getTestAccount();
        TestUtilities.CreateLoanAppStages();
        EB_Loan_Application__c app = testObjectClass.getTestLoanApp(acctProspect);
        EB_Loan_App_Entity_Relationship__c rel = testObjectClass.getLoanAppEntityRealationship(acctProspect, app);
        PageReference pr = utility.testhelper(url + '?id=&retURL=');
                    test.setCurrentPage(pr);
                    ApexPages.StandardController sc = new Apexpages.Standardcontroller(app);
                    LoanAppBorrowereditController testcontroller = new LoanAppBorrowereditController(sc);
                             
                    PageReference psave = testcontroller.SaveBorrower();
                    psave = testcontroller.SaveQuickBorrower();
    }

//test Edit  in relatedList
    public static testMethod void verifyLoanAppBorrowerEditControllerNewBorrowerPage(){
        String url = Utility.getServerUrl() + '/apex/LoanAppBorrowerEdit';
        Account acctProspect = testObjectClass.getTestAccount();
        TestUtilities.CreateLoanAppStages();
        EB_Loan_Application__c app = testObjectClass.getTestLoanApp(acctProspect);
        EB_Loan_App_Entity_Relationship__c rel = testObjectClass.getLoanAppEntityRealationship(acctProspect, app);
        PageReference pr = utility.testhelper(url + '?aid=' +  app.Id);
                    test.setCurrentPage(pr);
                    ApexPages.StandardController sc = new Apexpages.Standardcontroller(app);
                    LoanAppBorrowereditController testcontroller = new LoanAppBorrowereditController(sc);

                    PageReference psave = testcontroller.SaveBorrower();
                    psave = testcontroller.SaveQuickBorrower();
    }
 
    //test New Borrower  
    public static testMethod void verifyLoanAppBorrowerEditControllerEditPage(){
        String url = Utility.getServerUrl() + '/apex/LoanAppBorrowerEdit';
        Account acctProspect = testObjectClass.getTestAccount();
        TestUtilities.CreateLoanAppStages();
        EB_Loan_Application__c app = testObjectClass.getTestLoanApp(acctProspect);
           
        EB_Loan_App_Entity_Relationship__c rel = testObjectClass.getLoanAppEntityRealationship(acctProspect, app);
        PageReference pr = utility.testhelper(url + '?id=' + rel.Id + '&retURL=' + app.Id);
                    test.setCurrentPage(pr);
                    ApexPages.StandardController sc = new Apexpages.Standardcontroller(app);
                    LoanAppBorrowereditController testcontroller = new LoanAppBorrowereditController(sc);
                    
                    PageReference psave = testcontroller.SaveBorrower();
                    psave = testcontroller.SaveQuickBorrower();
       }

    //test Relationship 
    public static testMethod void verifyLoanAppBorrowerEditControllerInsertRelationshipPage(){
        String url = Utility.getServerUrl() + '/apex/LoanAppBorrowerEdit';
        Account acctProspect = testObjectClass.getTestAccount();
        TestUtilities.CreateLoanAppStages();
        EB_Loan_Application__c app = testObjectClass.getTestLoanApp(acctProspect);

        EB_Loan_App_Entity_Relationship__c rel = testObjectClass.getLoanAppEntityRealationship(acctProspect, app);
        PageReference pr = utility.testhelper(url + '?aid=' + app.Id + '&eid=' + rel.Id);
                    test.setCurrentPage(pr);
                    ApexPages.StandardController sc = new Apexpages.Standardcontroller(app);
                    LoanAppBorrowereditController testcontroller = new LoanAppBorrowereditController(sc);
                    PageReference psave = testcontroller.SaveBorrower();
                    psave = testcontroller.SaveQuickBorrower();
       }

    public static testMethod void verifyLoanAppBorrowerEditControllerMethods(){
        String url = Utility.getServerUrl() + '/apex/LoanAppBorrowerEdit';
		Account acctProspect = testObjectClass.getTestAccount();
        TestUtilities.CreateLoanAppStages();    
        EB_Loan_Application__c app = testObjectClass.getTestLoanApp(acctProspect);

        EB_Loan_App_Entity_Relationship__c rel = testObjectClass.getLoanAppEntityRealationship(acctProspect, app);
        PageReference pr =  utility.testhelper(url + '?aid=' + app.Id + '&eid=' + rel.Id);
                test.setCurrentPage(pr);
                ApexPages.StandardController sc = new Apexpages.Standardcontroller(app);
                LoanAppBorrowereditController testcontroller = new LoanAppBorrowereditController(sc);
                testcontroller.dropdownLimitedUnlimitedId = 'No';
                testcontroller.getQueryParameters();
                testcontroller.initialize();
                testcontroller.setPageFieldsForEntity();
                testcontroller.setMode();
                List<selectoption> options1 = testcontroller.getLimitedUnlimitedTypes();
                String visible = testcontroller.getLimitedUnlimitedVisibility();
                String reltype = testcontroller.getReadonlyRelationshipType();
                Id rec =  testcontroller.getRecordTypeIdForName('Prospect');
                List<selectoption> reltypes = testcontroller.getRelTypes();
                testcontroller.setEBUnitAndRM(acctProspect);
                testcontroller.dropdownRelationshipTypeId = 'Co-Borrower';
                
                Boolean exists = testcontroller.PrimaryOwnerExistsOnLoanApp();
                String quote = testcontroller.getQuotes();
                 List<selectoption> x1 = testcontroller.getAnnualFStmt();
                List<selectoption> x2 = testcontroller.getOfacVerified();
                List<selectoption> x3 = testcontroller.getRegOQ();
                List<selectoption> x4 = testcontroller.getstmQty();
                List<selectoption> x5 = testcontroller.getTaxReturns();
                List<selectoption> x6 = testcontroller.getInterimStm();
                List<selectoption> x7 = testcontroller.getGuaranteeExists();
                x7 = testcontroller.getSubType();
                x7 = testcontroller.getTaxReturnDays();
                x7 = testcontroller.getAnnualStatementYE();
                x7 = testcontroller.getInterimStatementEnd();
                x7 = testcontroller.getInterimStmPreparedBy();
                x7 = testcontroller.getAnnualStatementIncludeLoanAgreement();
                x7 = testcontroller.getInterimStatementIncludeLoanAgreement();
                x7 = testcontroller.getTaxIncludeInLoanAgreement();
                String valid = testcontroller.validateString('test' , 'NA');               
       }
       
  }