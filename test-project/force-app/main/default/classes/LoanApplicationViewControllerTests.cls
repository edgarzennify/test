@isTest
public class LoanApplicationViewControllerTests {
	 
     private static testMethod void verifyLoanAppViewPageReference(){
     	     TestUtilities.createLoanAppStages();
             String serverurl = Utility.getServerUrl();
             String url = serverurl + '/apex/LoanApplicationView?id=';
            
             Account entity = ObjectFactory.getValidEntity('TestEntity');
             EB_Account__c ebaccount = ObjectFactory.getEBAccount('loanaccount', '1234', entity);
             EB_Loan_Packet__c packet = ObjectFactory.getLoanPacket(entity);
             
             EB_Loan_Application__c app = ObjectFactory.getLoanApplication(packet, ebAccount, '1234');
             app.Account_Number_Assigned__c = '';
             app.Business_Purpose__c = 'Yes';
             update app;   
                
             PageReference pr = Utility.testhelper(url + app.id);
             test.setCurrentPage(pr);
             ApexPages.StandardController sc = new Apexpages.Standardcontroller(app);
             LoanApplicationViewController testcontroller = new LoanApplicationViewController(sc);                            
      }

      private static testMethod  void verifyLoanAppViewMethod(){
        	 TestUtilities.createLoanAppStages();
           	 String serverurl = Utility.getServerUrl();
             String url = serverurl +'/apex/LoanApplicationView?id=';
             Account entity = ObjectFactory.getValidEntity('TestEntity');
             EB_Account__c ebaccount = ObjectFactory.getEBAccount('loanaccount', '1234', entity);
             EB_Loan_Packet__c packet = ObjectFactory.getLoanPacket(entity);
             
             EB_Loan_Application__c app = ObjectFactory.getLoanApplication(packet, ebAccount, '1234');
             app.Account_Number_Assigned__c = '';
             app.Business_Purpose__c = 'Yes';
             update app; 
                            
             PageReference pr = Utility.testhelper(url + app.id);
             test.setCurrentPage(pr);
             ApexPages.StandardController sc = new Apexpages.Standardcontroller(app);
             LoanApplicationViewController testcontroller = new LoanApplicationViewController(sc);
             testcontroller.tester = 'test';
             String perm = testcontroller.HasGenerateNumberPermission;
             boolean check = LoanApplicationViewController.ValidateRequest('BusinessLoanNumber',app);
             String loannumber = LoanApplicationViewController.GetNumber('BusinessLoanNumber');
             LoanApplicationViewController.GenerateNumberHelper(app);
             loannumber = LoanApplicationViewController.GetNewLoanNumber(app);
             String minimods = testcontroller.RenderRelatedEntity;
             minimods = testcontroller.RenderCollateral;
             minimods = testcontroller.RenderRateStream;
             minimods = testcontroller.RenderPaymentStream;
             minimods = testcontroller.RenderParticipation;
             minimods = testcontroller.RenderLoanFee;
             minimods = testcontroller.RenderLoanAgreement;
             Map<id,RecordType> AppMap = testcontroller.RecordTypeLoanAppMap;               
        }
	

}