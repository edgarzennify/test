@IsTest
public  class LoanAppFeeAddControllerTests {
	 public static testMethod void verifyLoanAppFeePageReference(){
             String url = utility.getServerUrl() + '/' +'apex/LoanAppFeeAdd?aid=';
             
             Account entity = ObjectFactory.getValidEntity('testEntity');
             EB_Account__c ebAccount = ObjectFactory.getEBAccount('testAccount', '1234-15', entity);
             Eb_Loan_Packet__c packet = ObjectFactory.getLoanPacket(entity);
             TestUtilities.createLoanAppStages();
             Eb_Loan_Application__c app = ObjectFactory.getLoanApplication(packet, ebAccount, '123-15');
             Collateral_Code__c ccode = ObjectFactory.getCollateralCode('testcollcateralCode', '989');
             EB_Collateral__c collateral = ObjectFactory.getCollateral('testCollateral', ccode, false);   
             EB_Loan_Fee__c fee = new EB_Loan_Fee__c();
             fee.Related_Collateral__c = collateral.Id;
             fee.Loan_Application__c = app.Id;
             fee.Fee_Amount__c = 30.00;
             fee.Payable_To__c = 'testuser';
             insert fee;
             //EB_Loan_Fee__c fee = [SELECT Id ,Related_Collateral__c, Loan_Application__c FROM EB_Loan_Fee__c WHERE Related_Collateral__c != null and Loan_Application__c != null limit 1];  
             PageReference pr = utility.testhelper(url +  fee.Loan_Application__c  );
             test.setCurrentPage(pr);
             ApexPages.StandardController sc = new Apexpages.Standardcontroller(fee);
             LoanAppFeeAddController testcontroller = new LoanAppFeeAddController(sc);
             PageReference pCancel = testcontroller.CancelLoanFee();
             PageReference psave  = testcontroller.SaveLoanFee();
             
           
             pCancel = testcontroller.SaveAndNewLoanFee();
                                 
    }
    public static testMethod void verifyLoanAppFeePageReferenceforNull(){
             String url = utility.getServerUrl() + '/' +'apex/LoanAppFeeAdd?aid=';
               
                
             Account entity = ObjectFactory.getValidEntity('testEntity');
             EB_Account__c ebAccount = ObjectFactory.getEBAccount('testAccount', '1234-15', entity);
             Eb_Loan_Packet__c packet = ObjectFactory.getLoanPacket(entity);
             TestUtilities.createLoanAppStages();
             Eb_Loan_Application__c app = ObjectFactory.getLoanApplication(packet, ebAccount, '123-15');
             Collateral_Code__c ccode = ObjectFactory.getCollateralCode('testcollcateralCode', '989');
             EB_Collateral__c collateral = ObjectFactory.getCollateral('testCollateral', ccode, false);   
             EB_Loan_Fee__c fee = new EB_Loan_Fee__c();
             fee.Related_Collateral__c = collateral.Id;
             fee.Loan_Application__c = app.Id;
             fee.Fee_Amount__c = 30.00;
             fee.Payable_To__c = 'testuser';
             insert fee;
             
             PageReference pr = utility.testhelper(url   );
             test.setCurrentPage(pr);
             ApexPages.StandardController sc = new Apexpages.Standardcontroller(fee);
             LoanAppFeeAddController testcontroller = new LoanAppFeeAddController(sc);
             PageReference pCancel = testcontroller.CancelLoanFee();
             PageReference psave  = testcontroller.SaveLoanFee();
             
           
             pCancel = testcontroller.SaveAndNewLoanFee();
                                 
    }
    public static testMethod void verifyLoanAppFeeMethods(){
             String url = utility.getServerUrl() + '/' +'apex/LoanAppFeeAdd?aid=';
               
                
             Account entity = ObjectFactory.getValidEntity('testEntity');
             EB_Account__c ebAccount = ObjectFactory.getEBAccount('testAccount', '1234-15', entity);
             Eb_Loan_Packet__c packet = ObjectFactory.getLoanPacket(entity);
             TestUtilities.createLoanAppStages();
             Eb_Loan_Application__c app = ObjectFactory.getLoanApplication(packet, ebAccount, '123-15');
             Collateral_Code__c ccode = ObjectFactory.getCollateralCode('testcollcateralCode', '989');
             EB_Collateral__c collateral = ObjectFactory.getCollateral('testCollateral', ccode, false);   
             EB_Loan_Fee__c fee = new EB_Loan_Fee__c();
             fee.Related_Collateral__c = collateral.Id;
             fee.Loan_Application__c = app.Id;
             fee.Fee_Amount__c = 30.00;
             fee.Payable_To__c = 'testuser';
             insert fee;
             PageReference pr = utility.testhelper(url + fee.Loan_Application__c );
             test.setCurrentPage(pr);
             ApexPages.StandardController sc = new Apexpages.Standardcontroller(fee);
             LoanAppFeeAddController testcontroller = new LoanAppFeeAddController(sc);
             testcontroller.getQueryParameters();
             testcontroller.Initialize();
             testcontroller.setMode();
             List<selectoption> s1 = testcontroller.getCollateralDescs();
             List<SelectOption> s2 = testcontroller.getFeeHandling();
             List<SelectOption> s3 = testcontroller.getTypeOfFees();
             testcontroller.getQuotes();              
                                 
    }
}