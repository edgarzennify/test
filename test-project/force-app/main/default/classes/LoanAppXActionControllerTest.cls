@isTest
public class LoanAppXActionControllerTest{
 private static testMethod void verifyLoanAppXActionController(){
        test.startTest();
        String Url = Utility.getServerUrl()+ '/apex/LoanAppStageAction?id=';
        RecordType record_typeProspect = Utility.recordTypeObject('Account', 'Prospect'); 
        Profile p = [SELECT Id, Name FROM Profile WHERE Name=:'EB Base User']; 
        User user1 = ObjectFactory.getUser('test91', 'user91', 'tuser91@enterprisebank.sfdc.test', false); 
        user1.ProfileId = p.Id;
        user1.Two_Signature_Authority__c=true;
        insert user1;  
       
        User user2 = ObjectFactory.getUser('test90', 'user90', 'tuser90@enterprisebank.sfdc.test', false);        
        user2.Two_Signature_Authority__c=true;
        user2.ProfileId = p.Id;
        insert user2;
     
        User user3 = ObjectFactory.getUser('test89', 'user89', 'tuser89@enterprisebank.sfdc.test', false); 
        user3.ProfileId = p.Id;
        user3.Two_Signature_Authority__c=true;
        user3.Three_Signature_Authority__c=true;
        insert user3;  
       
        EB_Team_Member__c  teamMember = ObjectFactory.getTeamMember('testTeamMemeber');
        teamMember.User__c = user1.Id;
        teamMember.Officer_Code__c = 'tuser1';
        update teamMember; 
        EB_Team_Member__c  teamMember1 = ObjectFactory.getTeamMember('testTeamMemeber');
        teamMember1.User__c = user2.Id;
        teamMember1.Officer_Code__c = 'tuser2';
        update teamMember1; 
               
        Account acctProspect = new Account(Name='TestProspectPtoC', 
                                           BillingStreet='Test Street',
                                           BillingCity='Test city',
                                           BillingPostalCode='UTEST1 1UT',
                                           RecordTypeId = record_typeProspect.Id,
                                           Team_Relationship_Manager__c = teamMember.Id
                                           );
        insert acctProspect;                                
        EB_Loan_Packet__c packet = new EB_Loan_Packet__c(Name = 'Test Packet',
                                                         Lead_Entity__c = acctProspect.Id,
                                                         Loan_Coordinator__c = teammember1.Id,
                                                         Actual_Approval_Path__c = '3 Signatures'
                                                         );
        insert packet;
        TestUtilities.createLoanAppStages();
        EB_Loan_Application__c app = new EB_Loan_Application__c(EB_Loan_Packet__c = packet.Id,
                                                                Loan_Type__c = 'Fixed Line',
                                                                Business_Purpose__c = 'Yes',
                                                                Approver_Two__c = user2.Id,
                                                                Approver_Three__c=user3.Id,
                                                                Approved_by_SFDC_Approval_Process__c = true
                                                                );
        insert app;
    
        PageReference pr = utility.testhelper(url +  app.Id);
        test.setCurrentPage(pr);
        ApexPages.StandardController sc = new Apexpages.Standardcontroller(app);
        LoanAppXActionController sut = new LoanAppXActionController(sc);
        PageReference predirect = sut.RedirectAction();
        Boolean bTest = sut.IsStageAccessible('/apex/LoanAppApprovedAction');
        bTest = sut.IsStageAccessible('/apex/LoanAppArchivedAction');
        bTest = sut.IsStageAccessible('/apex/LoanAppBookedAction');
        bTest = sut.IsStageAccessible('/apex/LoanAppDocumentationAction');      
        bTest = sut.IsStageAccessible('/apex/LoanAppNewAction');
        bTest = sut.IsStageAccessible('/apex/LoanAppPendingApprovalAction');
        bTest = sut.IsStageAccessible('/apex/LoanAppUnderwritingAction');
        bTest = sut.IsStageAccessible('TestForElseCase');
        test.stopTest();
    }
}