@isTest
public class LoanApplicationViewHelperControllerTests {
  public static testMethod void verifyLoanAppViewHelperPageReference(){
     	 String serverurl = Utility.getServerUrl();
     	 String url = serverurl + '/apex/LoanApplicationViewHelper?id=';
         Account entity = ObjectFactory.getValidEntity('TestEntity');
         EB_Account__c ebaccount = ObjectFactory.getEBAccount('loanaccount', '1234', entity);
         EB_Loan_Packet__c packet = ObjectFactory.getLoanPacket(entity);
         TestUtilities.CreateLoanAppStages();
         EB_Loan_Application__c app = ObjectFactory.getLoanApplication(packet, ebAccount, '1234');
         app.Account_Number_Assigned__c = '';
         app.Business_Purpose__c = 'Yes';
         update app;   
            
         PageReference pr = utility.testhelper(url + app.id);
         test.setCurrentPage(pr);
         ApexPages.StandardController sc = new Apexpages.Standardcontroller(app);
         LoanApplicationViewhelperController testcontroller = new LoanApplicationViewhelperController(sc);
         pagereference ptest =  testcontroller.GenerateNumber();
     }
 
}