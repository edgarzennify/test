@isTest
public class LoanArchivedStageTriggerHelperTests {
	
    public static testMethod void verifyLoanStageTrigger(){
        
        User u = [SELECT Id FROM User WHERE alias =: 'rupadhya'];
        Account acctProspect = testObjectClass.getTestAccount();
        EB_Loan_Packet__c packet = objectfactory.getLoanPacket(acctProspect) ;    
        
        packet.Actual_Approval_Path__c = '2 Signatures';
        update packet;
                              
        List<EB_Stage_Action_Controller__c> actions = [SELECT Id, Name, Visual_Force_Action_Page__c FROM EB_Stage_Action_Controller__c Order By Name];
        EB_Stage_Action_Controller__c action1 = new EB_Stage_Action_Controller__c(
                                                Name = 'Archived',
                                                Visual_Force_Action_Page__c = '/apex/LoanAppNewAction'
                                                );
        insert action1;
        EB_Stage_Action_Controller__c action2 = new EB_Stage_Action_Controller__c(
                                                Name = 'Checkback',
                                                Visual_Force_Action_Page__c = '/apex/LoanAppPendingApprovalAction'
                                                );
        insert action2;
        EB_Stage_Action_Controller__c action3 = new EB_Stage_Action_Controller__c(
                                                Name = 'Checkback',
                                                Visual_Force_Action_Page__c = 'xxxxx'
                                                );
        insert action3;
        EB_Loan_App_Stage__c stage1 = new EB_Loan_App_Stage__c(
                                        Name = action1.Name,
                                        Stage_Selected_Email_Notifications__c = 'Coordinator;Secondary Officer',
                                        Loan_App_Stage_Action_Controller__c = action1.Id,
                                        Sort_Order__c = 111
                                      );
        insert stage1;
        EB_Loan_App_Stage__c stage2 = new EB_Loan_App_Stage__c(
                                        Name = action2.Name,
                                        Stage_Selected_Email_Notifications__c = 'Coordinator;Secondary Officer',
                                        Loan_App_Stage_Action_Controller__c = action2.Id,
                                        Sort_Order__c = 112
                                        );
        insert stage2;
          EB_Loan_App_Stage__c stage3 = new EB_Loan_App_Stage__c(
                                        Name = action3.Name,
                                        Stage_Selected_Email_Notifications__c = 'Coordinator;Secondary Officer',
                                        Loan_App_Stage_Action_Controller__c = action3.Id,
                                        Sort_Order__c = 113
                                        );
        insert stage3;
        
        Eb_Account__c acct = objectfactory.getEBAccount('test', '123', acctProspect);
        
        test.startTest();
        Datetime dT = System.now();
        Date d = date.newinstance(dT.year(), dT.month(), dT.day()); 
        EB_Booked_Loan_App__c archivedapp =  new  EB_Booked_Loan_App__c(    
            Loan_Packet__c = packet.id,
    	    Loan_Type__c = 'Fixed Line',
        	Business_Purpose__c = 'Yes',
            Stage_Explanation__c = 'qwqw;qwqwq',
            Approver_One__c = u.Id,
            Approver_Two__c = u.Id,
            Application_Stage__c = stage1.Id,
            Original_Maturity_Date__c = d,
            Maturity_date__c = d
        );
                                            
                                      
        insert archivedapp;
        archivedapp.Application_Stage__c = stage1.id;
        update archivedapp;
     
    }
}