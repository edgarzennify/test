@IsTest
private class AgreementApprovalInfoTests {
    
    @IsTest
    static void it_should_determine_when_agreement_has_its_own_approval() {
        TestObjects t = new TestObjects();
        Agreement__c agmt = new Agreement__c();
        agmt.RecordTypeId = utility.RecordTypeObject('Agreement__c', 'Pending').Id;
        agmt.Actual_Approval_Process__c = 'RM + 1';
        User app1 = ObjectFactory.getUser();
        User app2 = ObjectFactory.getUser('GenericB');
        agmt.Approver_One__c = app1.Id;
        agmt.Approver_Two__c = app2.Id;
        agmt.Loan_Coordinator__c = ObjectFactory.getTeamMember('testTeamMemeber').Id;
        insert agmt;
        Utility.SubmitForApproval(agmt.Id);
        Utility.ApproveWorkflow(agmt.Id);
        
        Boolean bOwnApproval = t.sut.hasApprovalInformation(agmt.Id);
        
        System.assertEquals(true, bOwnApproval);
    }
    
    @IsTest
    static void it_should_determine_when_agreement_does_not_have_its_own_approval() {
        TestObjects t = new TestObjects();
        Agreement__c agmt = new Agreement__c();
        agmt.RecordTypeId = utility.RecordTypeObject('Agreement__c', 'Active').Id;
        insert agmt;
        
        Boolean bOwnApproval = t.sut.hasApprovalInformation(agmt.Id);
        
        System.assertEquals(false, bOwnApproval);
    }
    
    @IsTest
    static void it_should_provide_the_apps_approval_when_the_record_type_is_pending() {
        TestUtilities.createLoanAppStages();
        TestObjects t = new TestObjects();
        Agreement__c agmt = new Agreement__c();
        agmt.RecordTypeId = Utility.recordTypeObject('Agreement__c','Pending').Id;
        insert agmt;
        Account newEntity = ObjectFactory.getValidEntity('test entity');
        Eb_Account__c newEBAccount = ObjectFactory.getEBAccount('test Account','1234', newEntity);      
        EB_Loan_Packet__c newPacket = ObjectFactory.getLoanPacket(newEntity);
        EB_Loan_Application__c loanapp = ObjectFactory.getLoanApplication(newPacket, newEBAccount, '123445');
        Agreement_Loan_Application_Relationship__c app2agmt = new Agreement_Loan_Application_Relationship__c();
        app2agmt.Agreement__c = agmt.Id;
        app2agmt.Loan_Application__c = loanapp.Id;
        insert app2agmt;

        EB_Loan_App_Minute__c approvalMinuteForApp = new EB_Loan_App_Minute__c();
        approvalMinuteForApp.EB_Loan_Application__c = loanapp.id;
        approvalMinuteForApp.Decision_Date__c = Date.newInstance(2013,8,30);
        approvalMinuteForApp.Type_of_Snapshot__c = 'Approval Minute';
        insert approvalMinuteForApp;
        
        EB_Loan_App_Minute__c returnedMinute = t.sut.GetApprovalMinute(agmt.Id);
        
        System.assertEquals(approvalMinuteForApp.Id, returnedMinute.Id);
    }
    
    @IsTest
    static void it_should_provide_the_accts_approval_when_the_record_type_is_not_pending() {
        TestObjects t = new TestObjects();
        Agreement__c agmt = new Agreement__c();
        agmt.RecordTypeId = Utility.recordTypeObject('Agreement__c','Active').Id;
        insert agmt;
        Account newEntity = ObjectFactory.getValidEntity('test entity');
        Eb_Account__c newEBAccount = ObjectFactory.getEBAccount('test Account','1234', newEntity);      
        EB_Loan_Packet__c newPacket = ObjectFactory.getLoanPacket(newEntity);
        EB_Booked_Loan_App__c bookedApp = new EB_Booked_Loan_App__c();
        bookedApp.Loan_Packet__c = newPacket.Id;
        bookedApp.Account__c = newEBAccount.Id;
        insert bookedApp;
        Agreement_EB_Account_Relationship__c acct2agmt = new Agreement_EB_Account_Relationship__c();
        acct2agmt.Agreement__c = agmt.Id;
        acct2agmt.Loan_Account__c = newEBAccount.Id;
        insert acct2agmt;

        EB_Loan_App_Minute__c approvalMinuteForBookedApp = new EB_Loan_App_Minute__c();
        approvalMinuteForBookedApp.Booked_Loan_Application__c = bookedApp.id;
        approvalMinuteForBookedApp.Decision_Date__c = Date.newInstance(2013,8,30);
        approvalMinuteForBookedApp.Type_of_Snapshot__c = 'Approval Minute';
        insert approvalMinuteForBookedApp;
        
        EB_Loan_App_Minute__c returnedMinute = t.sut.GetApprovalMinute(agmt.Id);
        
        System.assertEquals(approvalMinuteForBookedApp.Id, returnedMinute.Id);
    }
    
    @IsTest
    static void it_should_indicate_when_the_agreement_was_independently_approved() {
    	TestObjects t = new TestObjects();
        Agreement__c agmt = new Agreement__c(Independently_Approved_Approval_Process__c = true);
        insert agmt;
        
        Boolean independentlyApproved = t.sut.wasIndependentlyApproved(agmt.Id);
        
        System.assertEquals(true,independentlyApproved);
    }
    
    private class TestObjects {
        public AgreementApprovalInfo sut {get;private set;}
        public TestObjects() {
            sut = new AgreementApprovalInfo();
        }
    }
}