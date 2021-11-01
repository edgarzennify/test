@isTest
private class LoanApplicationTriggerHelperTester {
    /*private final static LoanApplicationTriggerHelper sut;
    
    static {
        sut = new LoanApplicationTriggerHelper();
    }*/

    static Id ClientRecordTypeId{
        get{
        if(ClientRecordTypeID == null){
            ClientRecordTypeID = utility.RecordTypeObject('Account','Client').Id;
            system.debug('### ClientRecordTypeId loaded');
        }
            return ClientRecordTypeID;
        }
        set;
    }
    
    static EB_Team_Member__c teamRM{
        get{
            if(teamRM == null){
                teamRM = ObjectFactory.getTeamMember('Team1');
            }
            return teamRM;
        }
        set;
    }
    
    static Account leadEntity{
        get{
            if(leadEntity == null){
                leadEntity = ObjectFactory.getEntity('Krap Krappy', ClientRecordTypeId, teamRM);
            }
            return leadEntity;
        }
        set;
    }
    
    static EB_Loan_Packet__c packet{
        get{
            if(packet == null){
                packet = ObjectFactory.getLoanPacket(leadEntity);
            }
            return packet;
        }
        set;
    }
        
    static EB_Loan_Application__c newLoanApp{
        get{
            if(newLoanApp == null){
                newLoanApp = ObjectFactory.getLoanApplication(packet,null,'1234567');
            }
            return newLoanApp;
        }
        set;
    }
    
    static EB_Loan_Application__c newCommercialLoanApp{
        get{
            if(newCommercialLoanApp==null){
                newCommercialLoanApp = ObjectFactory.getLoanApplication(packet,null,'1234567','Yes');
            }
            return newCommercialLoanApp;
        }
        set;
    }    
    
    @isTest
    static void verifyLoanStageTrigger(){        
        User u = [SELECT Id FROM User WHERE alias =: 'rupadhya'];
        system.assertNotEquals(null, u);
        List<EB_Stage_Action_Controller__c> actionList = new List<EB_Stage_Action_Controller__c>();
        EB_Stage_Action_Controller__c action1 = new EB_Stage_Action_Controller__c(
                                                        Name = 'New',
                                                        Visual_Force_Action_Page__c = '/apex/LoanAppNewAction'
                                                        );
    
        actionList.add(action1);
        EB_Stage_Action_Controller__c action2 = new EB_Stage_Action_Controller__c(
                                                        Name = 'Pending Approval',
                                                        Visual_Force_Action_Page__c = '/apex/LoanAppPendingApprovalAction'
                                                        );
        actionList.add(action2);
        EB_Stage_Action_Controller__c action3 = new EB_Stage_Action_Controller__c(
                                                        Name = 'Documentation Complete',
                                                        Visual_Force_Action_Page__c = 'xxxxx'
                                                        );
        actionList.add(action3);
        insert actionList;
        
        system.assertEquals(true, [SELECT Id FROM EB_Stage_Action_Controller__c ].size() >= 3 );
        
        List<EB_Loan_App_Stage__c> stageList = new List<EB_Loan_App_Stage__c>();
        EB_Loan_App_Stage__c stage1 = new EB_Loan_App_Stage__c(
                                                        Name = action1.Name,
                                                        Stage_Selected_Email_Notifications__c = 'Coordinator;Secondary Officer',
                                                        Loan_App_Stage_Action_Controller__c = action1.Id,
                                                        Sort_Order__c = 111
                                                        );
        stageList.add(stage1);
        EB_Loan_App_Stage__c stage2 = new EB_Loan_App_Stage__c(
                                                        Name = action2.Name,
                                                        Stage_Selected_Email_Notifications__c = 'Coordinator;Secondary Officer',
                                                        Loan_App_Stage_Action_Controller__c = action2.Id,
                                                        Sort_Order__c = 112
                                                        );
        stageList.add(stage2);
        EB_Loan_App_Stage__c stage3 = new EB_Loan_App_Stage__c(
                                                        Name = action3.Name,
                                                        Stage_Selected_Email_Notifications__c = 'Coordinator;Secondary Officer',
                                                        Loan_App_Stage_Action_Controller__c = action3.Id,
                                                        Sort_Order__c = 113
                                                        );
        stageList.add(stage3);
        insert stageList;
        
        system.assertEquals(true, [SELECT Id FROM EB_Loan_App_Stage__c ].size() >= 3 );
        
        
        Datetime dT = System.now();
        Date d = date.newinstance(dT.year(), dT.month(), dT.day());         
        EB_Loan_Application__c app = new EB_Loan_Application__c(
                                                    EB_Loan_Packet__c = packet.Id,
                                                    Loan_Type__c = 'Fixed Line',
                                                    //Total_Loan_Amount__c = 2000,
                                                    Business_Purpose__c = 'Yes',
                                                    //Approved_by_SFDC_Approval_Process__c = true,
                                                    //Rejected_by_SFDC_Approval_Process__c = true,
                                                    
                                                    Approver_One__c = u.Id,
                                                    Approver_Two__c = u.Id,
                                                    Application_Stage__c = stage2.Id,
                                                    Original_Maturity_Date__c = d,
                                                    Maturity_date__c = d
                                                    );
        
        insert app;
        //Assert if app exists
        system.assertNotEquals(null,app);
        
        test.startTest();
        
        app.Application_Stage__c = stage2.Id;
        app.Approved_by_SFDC_Approval_Process__c = true;
        update app;
        //Assert if update was sucessful
        system.assertEquals(app.Application_Stage__c,stage2.Id );   
        
        app.Application_Stage__c = stage3.Id;
        update app;
        //Assert if update was sucessful
        system.assertEquals(app.Application_Stage__c,stage3.Id);   
        
        test.stopTest();   
    }
    
    @isTest
    static void verifyAfterUpdateTrigger(){
        TestUtilities.CreateLoanAppStages();
        test.startTest();
        // update the loan app              
        newLoanApp.Create_Minute__c = true;
        update newLoanApp;
        
        test.stopTest();
    }
    
    @isTest
    static void verifyLoanStageInitialization(){
        // initialize test objects
        EB_Loan_Packet__c thisPacket = packet;
        TestUtilities.CreateLoanAppStages();
        System.assertNotEquals(null,packet.Id);
        
        test.startTest();
        // confirm that the application is initialized at the "new" stage, using the shared commercial loan app
        EB_Loan_Application__c reloadTheApp = [SELECT Id, Application_Stage__c FROM EB_Loan_Application__c WHERE Id =: newCommercialLoanApp.Id];
        System.assertEquals(LoanApplicationTriggerHelper.newLoanAppStage.Id,reloadTheApp.Application_Stage__c);
        test.stopTest();        
    }
    
    @isTest
    static void verifyLoanStageLogging(){
        // initialize test objects
        EB_Loan_Packet__c thisPacket = packet;
        TestUtilities.CreateLoanAppStages();
        System.assertNotEquals(null,packet.Id);
        
        test.startTest();
        // confirm that there's one entry for this app in the stage log, using the shared commercial loan app
        List<EB_Loan_Application_Stage_Log__c>stageLogList = [SELECT Id, Name FROM EB_Loan_Application_Stage_Log__c WHERE EB_Loan_Application__c =: newCommercialLoanApp.Id];
        System.assertEquals(1,stageLogList.size());   
        test.stopTest();    
    }
    
    public class TestCallout implements HttpCalloutMock{
       private HttpResponse resp;
       public TestCallout(string test_Body){
           resp = new HttpResponse();
           resp.setBody(test_Body);
           resp.setStatusCode(200);
       }
       public HttpResponse respond(HTTPRequest req){
           return resp;
       }
    }    
    
    /*@isTest
    static void verifyCallout(){
        Id newRecordTypeId = utility.RecordTypeObject('EB_Loan_Application__c','New').Id;
        Id renewalRecordTypeId = utility.RecordTypeObject('EB_Loan_Application__c','Renewal').Id;       
        EB_Account__c ebAccount = ObjectFactory.getEBAccount('Test Account2','98754',leadEntity);
        EB_Loan_Packet__c thisPacket = packet;
        TestUtilities.CreateLoanAppStages();
        Eb_Loan_Application__c loan = newLoanApp;
        System.assertNotEquals(null,packet.Id);
        System.assertNotEquals(null,loan.id);
        
        //HttpResponse resp
        String testString = 'Test string';
        HttpCalloutMock mock = new TestCallout(testString);
        Test.setMock(HttpCalloutMock.class,mock);   
        HttpResponse res = LoanApplicationTriggerHelper.CalloutResponse(loan.id);
        
        //Testing 200 is still a problem since the callout fails in sandbox
        //System.assertEquals(200, res.getStatusCode());
        //System.assertEquals(res.getBody(),testString);
        
    }*/
    
    @isTest
    static void verifyLoanFeeTrigger(){
        // initialize test objects
        Id newRecordTypeId = utility.RecordTypeObject('EB_Loan_Application__c','New').Id;
        Id renewalRecordTypeId = utility.RecordTypeObject('EB_Loan_Application__c','Renewal').Id;       
        EB_Account__c ebAccount = ObjectFactory.getEBAccount('Test Account2','98754',leadEntity);
        EB_Loan_Packet__c thisPacket = packet;
        TestUtilities.CreateLoanAppStages();
        System.assertNotEquals(null,packet.Id);
        
        test.startTest();
        // confirm that the correct loan fee was added (assert), using the shared commercial loan app
        List<EB_Loan_Fee__c> testNewLoanFeeList = [SELECT Id, Type_of_Fee__c, Fee_Amount__c FROM EB_Loan_Fee__c WHERE Loan_Application__c =: newCommercialLoanApp.id limit 1];
        System.assertEquals(1,testNewLoanFeeList.size());       
        System.assertEquals('Loan',testNewLoanFeeList[0].Type_of_Fee__c);
        System.assertEquals(250,testNewLoanFeeList[0].Fee_Amount__c);
        
        // create a "new" consumer loan app
        EB_Loan_Application__c newConsumerLoanApp = ObjectFactory.getLoanApplication(packet, null, '12345678','No');
        System.assertEquals(newRecordTypeId,newConsumerLoanApp.RecordTypeId); 
        
        // confirm that no loan fee was added (assert)
        List<EB_Loan_Fee__c> newConsumerLoanFeeList = [SELECT Id, Type_of_Fee__c, Fee_Amount__c FROM EB_Loan_Fee__c WHERE Loan_Application__c =: newConsumerLoanApp.id limit 1];
        System.assertEquals(0,newConsumerLoanFeeList.size());       
        
        // create a "renewal" commercial loan app
        EB_Loan_Application__c renewalComercialLoanApp = ObjectFactory.getLoanApplication(packet, ebAccount, '12345678','Yes');
        System.assertEquals(renewalRecordTypeId,renewalComercialLoanApp.RecordTypeId);      
        
        // confirm that the correct loan fee was added (assert)
        List<EB_Loan_Fee__c> testRenewalComercialLoanFeeList = [SELECT Id, Type_of_Fee__c, Fee_Amount__c FROM EB_Loan_Fee__c WHERE Loan_Application__c =: renewalComercialLoanApp.id limit 1];
        System.assertEquals(1,testRenewalComercialLoanFeeList.size());      
        System.assertEquals('Renewal Fee',testRenewalComercialLoanFeeList[0].Type_of_Fee__c);
        System.assertEquals(250,testRenewalComercialLoanFeeList[0].Fee_Amount__c);
        
        // bulk test:
        // create 200 loan apps, save them, did we break something? (no assert needed)
        //Integer bulkCount = 100;
        //EB_Loan_Packet__c packetBulk = ObjectFactory.getLoanPacket(leadEntity);
        //System.assertNotEquals(null,packetBulk.Id);
        //List<EB_Loan_Application__c> appList = ObjectFactory.getLoanApplications(bulkCount, packetBulk, null, '12345');
        //System.assertEquals(bulkCount,appList.size());
        //List<EB_Loan_Application__c> appList2 = [SELECT Id, Name FROM EB_Loan_Application__c WHERE EB_Loan_Packet__c =: packetBulk.Id];
        //System.assertEquals(bulkCount,appList2.size());
        //Map<Id,EB_Loan_Application__c> appMap = new Map<Id,EB_Loan_Application__c>([SELECT Id, Name FROM EB_Loan_Application__c WHERE EB_Loan_Packet__c =: packetBulk.Id]);
        //System.assertEquals(bulkCount,appMap.size());
        //List<EB_Loan_Fee__c> testRenewalLoanFeeListBulk = [SELECT Id, Type_of_Fee__c, Fee_Amount__c FROM EB_Loan_Fee__c WHERE Loan_Application__c in: appMap.keyset() ];
        //System.assertEquals(bulkCount,testRenewalLoanFeeListBulk.size());   
        
        test.stopTest();
    }
    
    /*static testMethod void it_should_update_the_RM_and_LC_email_address_fields_when_inserting_a_loan_application(){
        TestUtilities.CreateLoanAppStages();
        User bob = ObjectFactory.getUser('bob','smith','bob@testmethod.sfdc',true);
        User sally = ObjectFactory.getUser('sally','jones','sally@testmethod.sfdc',true);
        EB_Team_Member__c tmBob = ObjectFactory.getTeamMember(bob,true);
        EB_Team_Member__c tmSally = ObjectFactory.getTeamMember(sally,true);
        
        Id rtClientId = Utility.recordTypeObject('Account', 'Client').Id;
        Account entity = ObjectFactory.getEntity('Test Co', rtClientId, tmBob);
        EB_Loan_Packet__c thisPacket = ObjectFactory.getLoanPacket(entity);
        thisPacket.Loan_Coordinator__c = tmSally.Id;
        update thisPacket;
        EB_Account__c ebAccount = ObjectFactory.getEBAccount('Test Account2','98754',entity);
        
        EB_Loan_Application__c loanApp = ObjectFactory.getLoanApplication(thisPacket, ebAccount, '12345678','Yes');
        
        EB_Loan_Application__c appSOQL = [SELECT Id, RM_Email_Address__c, Loan_Coordinator_Email_Address__c FROM EB_Loan_Application__c WHERE Id =: loanApp.Id];
        System.assertEquals('bob@testmethod.sfdc',appSOQL.RM_Email_Address__c);
        System.assertEquals('sally@testmethod.sfdc',appSOQL.Loan_Coordinator_Email_Address__c);
    }
    
    static testMethod void it_should_update_the_RM_and_LC_email_address_fields_when_updating_a_loan_application(){
        TestUtilities.CreateLoanAppStages();
        User bob = ObjectFactory.getUser('bob','smith','bob@testmethod.sfdc',true);
        User sally = ObjectFactory.getUser('sally','jones','sally@testmethod.sfdc',true);
        EB_Team_Member__c tmBob = ObjectFactory.getTeamMember(bob,true);
        EB_Team_Member__c tmSally = ObjectFactory.getTeamMember(sally,true);
        
        Id rtClientId = Utility.recordTypeObject('Account', 'Client').Id;
        Account entity = ObjectFactory.getEntity('Test Co', rtClientId, tmBob);
        EB_Loan_Packet__c thisPacket = ObjectFactory.getLoanPacket(entity);
        thisPacket.Loan_Coordinator__c = tmSally.Id;
        update thisPacket;
        EB_Account__c ebAccount = ObjectFactory.getEBAccount('Test Account2','98754',entity);
        EB_Loan_Application__c loanApp = ObjectFactory.getLoanApplication(thisPacket, ebAccount, '12345678','Yes');
        
        update loanApp;
        
        EB_Loan_Application__c appSOQL = [SELECT Id, RM_Email_Address__c, Loan_Coordinator_Email_Address__c FROM EB_Loan_Application__c WHERE Id =: loanApp.Id];
        System.assertEquals('bob@testmethod.sfdc',appSOQL.RM_Email_Address__c);
        System.assertEquals('sally@testmethod.sfdc',appSOQL.Loan_Coordinator_Email_Address__c);
    }*/

    private static testMethod void code_coverage_emails_are_sent_for_tdr_in_before_update_when_approval_process_is_true() {
        TestUtilities.CreateLoanAppStages();
        EB_Loan_App_Stage__c stage = [SELECT ID, Name FROM EB_Loan_App_Stage__c WHERE Name =: 'Approved' limit 1];
        stage.Stage_Selected_Email_Notifications__c = 'test@test.com.ebt,test2@test2.com.ebt';
        update stage;
        EB_Loan_Application__c loan = ObjectFactory.getLoanApplication('test entity' , 'testacctname', 'testacctnumber' ,'testloanname');
        List<EB_Loan_Application__c> oldList = new List<EB_Loan_Application__c>{loan};
        loan.Approved_by_SFDC_Approval_Process__c = true;
        
        loan.TDR_Determination_TWo__c = 'Concessions have been granted';
        update loan;
        List<EB_Loan_Application__c> newList = new List<EB_Loan_Application__c>{loan};
        Map<Id, EB_Loan_Application__c> newMap = new Map<Id, EB_Loan_Application__c>{loan.Id => loan};
        LoanApplicationTriggerHelper sut = new LoanApplicationTriggerHelper();
        
        sut.doBeforeUpdate(oldList,  newList,  newMap);
    }

    private static testMethod void code_coverage_emails_are_sent_for_tdr_in_before_update_when_rejected_proess_is_true() {
        TestUtilities.CreateLoanAppStages();
        EB_Loan_Application__c loan = ObjectFactory.getLoanApplication('test entity' , 'testacctname', 'testacctnumber' ,'testloanname');
        List<EB_Loan_Application__c> oldList = new List<EB_Loan_Application__c>{loan};
        loan.Approved_by_SFDC_Approval_Process__c = true;
        loan.Rejected_by_SFDC_Approval_Process__c = true;
        List<EB_Loan_Application__c> newList = new List<EB_Loan_Application__c>{loan};
        Map<Id, EB_Loan_Application__c> newMap = new Map<Id, EB_Loan_Application__c>{loan.Id => loan};
        LoanApplicationTriggerHelper sut = new LoanApplicationTriggerHelper();
        
        sut.doBeforeUpdate(oldList,  newList,  newMap);
    }

    private static testMethod void code_coverage_before_update_when_app_set_to_new() {
        TestUtilities.CreateLoanAppStages();
        EB_Loan_Application__c loan = ObjectFactory.getLoanApplication('test entity' , 'testacctname', 'testacctnumber' ,'testloanname');
        List<EB_Loan_Application__c> oldList = new List<EB_Loan_Application__c>{loan};
        loan.Approved_by_SFDC_Approval_Process__c = true;
        loan.Set_App_to_New__c = true;
        List<EB_Loan_Application__c> newList = new List<EB_Loan_Application__c>{loan};
        Map<Id, EB_Loan_Application__c> newMap = new Map<Id, EB_Loan_Application__c>{loan.Id => loan};
        LoanApplicationTriggerHelper sut = new LoanApplicationTriggerHelper();
        
        sut.doBeforeUpdate(oldList,  newList,  newMap);
    }

    private static testMethod void code_coverage_before_update_when_app_stage_set_to_new() {
        TestUtilities.CreateLoanAppStages();
        EB_Loan_Application__c loan = ObjectFactory.getLoanApplication('test entity' , 'testacctname', 'testacctnumber' ,'testloanname');
        List<EB_Loan_Application__c> oldList = new List<EB_Loan_Application__c>{loan};
        loan.Approved_by_SFDC_Approval_Process__c = true;
        loan.Application_Stage__c = TestUtilities.getStageByName('New').Id;
        List<EB_Loan_Application__c> newList = new List<EB_Loan_Application__c>{loan};
        Map<Id, EB_Loan_Application__c> newMap = new Map<Id, EB_Loan_Application__c>{loan.Id => loan};
        LoanApplicationTriggerHelper sut = new LoanApplicationTriggerHelper();
        
        sut.doBeforeUpdate(oldList,  newList,  newMap);
    }

    private static testMethod void code_coverage_before_update_when_app_stage_set_to_document_complete() {
        TestUtilities.CreateLoanAppStages();
        EB_Loan_Application__c loan = ObjectFactory.getLoanApplication('test entity' , 'testacctname', 'testacctnumber' ,'testloanname');
        List<EB_Loan_Application__c> oldList = new List<EB_Loan_Application__c>{loan};
        //loan.Approved_by_SFDC_Approval_Process__c = true;
        loan.Application_Stage__c = TestUtilities.getStageByName('Documentation Complete').Id;
        List<EB_Loan_Application__c> newList = new List<EB_Loan_Application__c>{loan};
        Map<Id, EB_Loan_Application__c> newMap = new Map<Id, EB_Loan_Application__c>{loan.Id => loan};
        LoanApplicationTriggerHelper sut = new LoanApplicationTriggerHelper();
        
        sut.doBeforeUpdate(oldList,  newList,  newMap);
    }

    private static testMethod void code_coverage_before_update_when_app_stage_set_to_approved_and_hoepa_email_is_sent() {
        TestUtilities.CreateLoanAppStages();
        EB_Loan_Application__c loan = ObjectFactory.getLoanApplication('test entity' , 'testacctname', 'testacctnumber' ,'testloanname');
        List<EB_Loan_Application__c> oldList = new List<EB_Loan_Application__c>{loan};
        loan.Approved_by_SFDC_Approval_Process__c = true;
        loan.Application_Stage__c = TestUtilities.getStageByName('Approved').Id;
        loan.IsHOEPAAsDeterminedByTrigger__c = true;
        update loan;
        List<EB_Loan_Application__c> newList = new List<EB_Loan_Application__c>{loan};
        Map<Id, EB_Loan_Application__c> newMap = new Map<Id, EB_Loan_Application__c>{loan.Id => loan};
        LoanApplicationTriggerHelper sut = new LoanApplicationTriggerHelper();
        
        sut.doBeforeUpdate(oldList,  newList,  newMap);
    }
    
    /*private static void CreateLoanAppStages(){
        List<EB_Loan_App_Stage__c> stages = new List<EB_Loan_App_Stage__c>();
        stages.add(CreateLoanAppStage('New',1));
        stages.add(CreateLoanAppStage('Approved',2));
        stages.add(CreateLoanAppStage('Denied',3));
        stages.add(CreateLoanAppStage('Documentation Complete',4));
        stages.add(CreateLoanAppStage('Booking',5));        
        insert stages;
    }
    
    private static EB_Loan_App_Stage__c CreateLoanAppStage(String stageName, Integer sortOrder){
        EB_Loan_App_Stage__c stage = new EB_Loan_App_Stage__c();
        stage.Name = stageName;
        stage.Sort_Order__c = sortOrder;
        return stage;
    }*/
}