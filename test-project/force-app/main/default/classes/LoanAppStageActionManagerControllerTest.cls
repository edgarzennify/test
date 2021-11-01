@isTest
public class LoanAppStageActionManagerControllerTest{
   private static  testmethod void verifyLoanAppStageActionPageReference(){
        String Url =Utility.getServerUrl()+ '/apex/LoanAppStageActionManager?id=';
        RecordType record_typeProspect = Utility.recordTypeObject('Account', 'Prospect'); 
        Profile p = [SELECT Id, Name FROM Profile WHERE Name=:'EB Base User']; 
        User user1 = ObjectFactory.getUser('test95', 'user95', 'tuser95@enterprisebank.sfdc.test', false); 
        user1.ProfileId = p.Id;
        user1.Two_Signature_Authority__c=true;
        insert user1;  
       
        User user2 = ObjectFactory.getUser('test94', 'user94', 'tuser94@enterprisebank.sfdc.test', false);        
        user2.Two_Signature_Authority__c=true;
        user2.ProfileId = p.Id;
        insert user2;
       
        EB_Team_Member__c  teamMember = ObjectFactory.getTeamMember('testTeamMemeber');
        teamMember.User__c = user1.Id;
        teamMember.Officer_Code__c = 'tuser1';
        update teamMember; 
       
        Account acctProspect = new Account(Name='TestProspectPtoC', 
                        BillingStreet='Test Street',
                        BillingCity='Test city',
                        BillingPostalCode='UTEST1 1UT',
                        RecordTypeId = record_typeProspect.Id,
                        Team_Relationship_Manager__c = teamMember.Id
                                 );
        insert acctProspect;
                                
        EB_Loan_Packet__c packet = new EB_Loan_Packet__c(
                        Name = 'Test Packet',
                        Lead_Entity__c = acctProspect.Id,
                        Loan_Coordinator__c = teamMember.Id,
                        Actual_Approval_Path__c = '3 Signatures'
                                           );
        insert packet;
        TestUtilities.createLoanAppStages();
        EB_Loan_Application__c app = new EB_Loan_Application__c();
                        app.EB_Loan_Packet__c = packet.Id;
                        app.Loan_Type__c = 'Fixed Line';
                        app.Business_Purpose__c = 'Yes';
                        app.Approved_by_SFDC_Approval_Process__c = true;
                        app.Application_Stage__c = testUtilities.getStageByName('Approved').Id;
                        app.Approver_Two__c = user2.Id; 
        insert app;

        PageReference pr = utility.testhelper(url +  app.Id);
        test.setCurrentPage(pr);
        ApexPages.StandardController sc = new Apexpages.Standardcontroller(app);
        LoanAppStageActionManagerController sut = new LoanAppStageActionManagerController(sc);
        PageReference predirect = sut.RedirectAction();
    }

    private static testmethod void verifyLoanAppStageActionMethods(){
        String Url = Utility.getServerUrl() + '/apex/LoanAppStageActionManager?id=';
        RecordType record_typeProspect = Utility.recordTypeObject('Account', 'Prospect');  
        Profile p = [SELECT Id, Name FROM Profile WHERE Name=:'EB Base User']; 
        User user1 = ObjectFactory.getUser('test93', 'user93', 'tuser93@enterprisebank.sfdc.test', false);
        user1.ProfileId = p.Id;
        user1.Two_Signature_Authority__c=true;
        insert user1;      
        User user2 = ObjectFactory.getUser('test92', 'user92', 'tuser92@enterprisebank.sfdc.test', false); 
        user2.Two_Signature_Authority__c=true;
        user2.ProfileId = p.Id;
        insert user2;
        EB_Team_Member__c  teamMember = ObjectFactory.getTeamMember('testTeamMemeber');
        teamMember.User__c = user1.Id;
        teamMember.Officer_Code__c = 'tuser93';
        update teamMember;  
        
        Account acctProspect = new Account(Name='TestProspectPtoC', 
                        BillingStreet='Test Street',
                        BillingCity='Test city',
                        BillingPostalCode='UTEST1 1UT',
                        RecordTypeId = record_typeProspect.Id,
                        Team_Relationship_Manager__c = teamMember.Id
                                 );
        insert acctProspect;
        
        EB_Loan_Packet__c packet = new EB_Loan_Packet__c(
                        Name = 'Test Packet',
                        Lead_Entity__c = acctProspect.Id,
                        Loan_Coordinator__c = teamMember.Id,
                        Actual_Approval_Path__c = '3 Signatures'
                                           );
        insert packet;
         
        EB_Loan_Application__c app = new EB_Loan_Application__c(
                        EB_Loan_Packet__c = packet.Id,
                        Loan_Type__c = 'Fixed Line',
                        Business_Purpose__c = 'Yes',
                        Approver_Two__c = user2.Id,
                        Approved_by_SFDC_Approval_Process__c = true,
                        Rejected_by_SFDC_Approval_Process__c = true
                                    );
        testUtilities.createLoanAppStages();
        insert app;

        PageReference pr = utility.testhelper(url);
        test.setCurrentPage(pr);
        ApexPages.StandardController sc = new Apexpages.Standardcontroller(app);
        LoanAppStageActionManagerController sut = new LoanAppStageActionManagerController(sc);
        sut.getQueryParameters();
        sut.getUrl();
        sut.initialize();
    }

}