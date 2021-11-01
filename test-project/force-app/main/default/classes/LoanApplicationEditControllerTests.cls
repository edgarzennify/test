@isTest
public class LoanApplicationEditControllerTests {
   
    private static testMethod void it_should_retrieve_the_loan_fields_required_for_documentation() {
        
        Account acctClient =  ObjectFactory.getValidEntity('testAccountClient');
        EB_Account__c acct = ObjectFactory.getEBAccount('testAccount','1234',acctClient);
        TestUtilities.createLoanAppStages();
        EB_Loan_Application__c app = ObjectFactory.getLoanApplication('testAccountClient', 'testAccount', '1234', 'testLoanApp');
        app.Is_Loan_to_Financial_Institution__c = 'LTF';
        app.Is_Loan_to_Govt_Related_Entity__c = 'LTG';
        app.Is_repayment_reliant_on_agriculture__c = 'RELAG';
        app.Financial_institution_accept_deposits__c = 'ACD';
        app.Niche_Products__c = 'Niche';
        update app;
        ApexPages.StandardController sc = new Apexpages.Standardcontroller(app);
        String serverurl = Utility.getServerUrl();
        String url = serverurl + '/apex/LoanApplicationEdit?id=';
        PageReference pr = Utility.testhelper(url + app.Id);
        test.setCurrentPage(pr);
        LoanApplicationEditController sut = new LoanApplicationEditController(sc);

        System.assertEquals(app.Is_Loan_to_Financial_Institution__c, sut.loan.Is_Loan_to_Financial_Institution__c);
        System.assertEquals(app.Is_Loan_to_Govt_Related_Entity__c, sut.loan.Is_Loan_to_Govt_Related_Entity__c);
        System.assertEquals(app.Is_repayment_reliant_on_agriculture__c, sut.loan.Is_repayment_reliant_on_agriculture__c);
        System.assertEquals(app.Financial_institution_accept_deposits__c, sut.loan.Financial_institution_accept_deposits__c);
        System.assertEquals(app.Niche_Products__c, sut.loan.Niche_Products__c);
    }

    private static testMethod void it_should_return_true_when_gl_advance_amount_is_more_than_total_sub_loan_amount() {
        
        Account acctClient =  ObjectFactory.getValidEntity('testAccountClient');
        EB_Account__c acct = ObjectFactory.getEBAccount('testAccount','1234',acctClient);
        acct.RecordTypeId = Utility.RecordTypeObject('EB_Account__c', 'Guidance Line').Id;
        acct.Application__c = 35;
        acct.Available_Balance__c = 1000.00;
        update acct;
        
        TestUtilities.createLoanAppStages();
        EB_Loan_Application__c app = ObjectFactory.getLoanApplication('testAccountClient', 'testAccount', '1234', 'testLoanApp');
        app.Account_Number_Guidance_Line__c = acct.Id;
        app.RecordTypeId = Utility.RecordTypeObject('EB_Loan_Application__c', 'New - Guidance Line Advance').Id;
        app.Bank_Owned_Loan_Amount__c = 100.00;
        update app;

        EB_Loan_Application__c oldApp = ObjectFactory.getLoanApplication('testAccountClient', 'testAccount', '1234', 'testLoanAppOld');
        oldApp.Account_Number_Guidance_Line__c = acct.Id;
        oldApp.RecordTypeId = Utility.RecordTypeObject('EB_Loan_Application__c', 'New - Guidance Line Advance').Id;
        oldApp.Bank_Owned_Loan_Amount__c = 100.00;
        update oldApp;
     
        ApexPages.StandardController sc = new Apexpages.Standardcontroller(app);
        String serverurl = Utility.getServerUrl();
        String url = serverurl + '/apex/LoanApplicationEdit?id=';
        PageReference pr = Utility.testhelper(url + app.Id);
        test.setCurrentPage(pr);
        LoanApplicationEditController sut = new LoanApplicationEditController(sc);

        Boolean result = sut.IsGLAdvanceAmountValid;
        List<EB_Loan_Application__c> reQueryoldApp = [SELECT Id, Bank_Owned_Loan_Amount__c, Account_Number_Guidance_Line__r.RecordType.Name, Account_Number_Guidance_Line__r.Available_Balance__c FROM EB_Loan_Application__c WHERE Id =: oldApp.Id];
        List<EB_Loan_Application__c> reQueryapp = [SELECT Id, Bank_Owned_Loan_Amount__c, Account_Number_Guidance_Line__r.RecordType.Name, Account_Number_Guidance_Line__r.Available_Balance__c FROM EB_Loan_Application__c WHERE Id =: app.Id];
        System.assertEquals('Guidance Line', reQueryapp[0].Account_Number_Guidance_Line__r.RecordType.Name);
        System.assertEquals(1000.00, reQueryapp[0].Account_Number_Guidance_Line__r.Available_Balance__c);
        System.assertEquals(100.00, reQueryOldApp[0].Bank_Owned_Loan_Amount__c);
        System.assertEquals(100.00, reQueryapp[0].Bank_Owned_Loan_Amount__c);
        System.assertEquals(true, result);

    }

    private static testMethod void it_should_return_true_when_gl_advance_amount_is_equal_to_total_sub_loan_amount() {
        
        Account acctClient =  ObjectFactory.getValidEntity('testAccountClient');
        EB_Account__c acct = ObjectFactory.getEBAccount('testAccount','1234',acctClient);
        acct.RecordTypeId = Utility.RecordTypeObject('EB_Account__c', 'Guidance Line').Id;
        acct.Application__c = 35;
        acct.Available_Balance__c = 1000.00;
        update acct;
        
        TestUtilities.createLoanAppStages();
        EB_Loan_Application__c app = ObjectFactory.getLoanApplication('testAccountClient', 'testAccount', '1234', 'testLoanApp');
        app.Account_Number_Guidance_Line__c = acct.Id;
        app.RecordTypeId = Utility.RecordTypeObject('EB_Loan_Application__c', 'New - Guidance Line Advance').Id;
        app.Bank_Owned_Loan_Amount__c = 900.00;
        update app;

        EB_Loan_Application__c oldApp = ObjectFactory.getLoanApplication('testAccountClient', 'testAccount', '1234', 'testLoanAppOld');
        oldApp.Account_Number_Guidance_Line__c = acct.Id;
        oldApp.RecordTypeId = Utility.RecordTypeObject('EB_Loan_Application__c', 'New - Guidance Line Advance').Id;
        oldApp.Bank_Owned_Loan_Amount__c = 100.00;
        update oldApp;
     
        ApexPages.StandardController sc = new Apexpages.Standardcontroller(app);
        String serverurl = Utility.getServerUrl();
        String url = serverurl + '/apex/LoanApplicationEdit?id=';
        PageReference pr = Utility.testhelper(url + app.Id);
        test.setCurrentPage(pr);
        LoanApplicationEditController sut = new LoanApplicationEditController(sc);

        Boolean result = sut.IsGLAdvanceAmountValid;

        List<EB_Loan_Application__c> reQueryapp = [SELECT Id, Bank_Owned_Loan_Amount__c, Account_Number_Guidance_Line__r.RecordType.Name, Account_Number_Guidance_Line__r.Available_Balance__c FROM EB_Loan_Application__c WHERE Id =: app.Id];
        List<EB_Loan_Application__c> reQueryoldApp = [SELECT Id, Bank_Owned_Loan_Amount__c, Account_Number_Guidance_Line__r.RecordType.Name, Account_Number_Guidance_Line__r.Available_Balance__c FROM EB_Loan_Application__c WHERE Id =: oldApp.Id];

        System.assertEquals('Guidance Line', reQueryapp[0].Account_Number_Guidance_Line__r.RecordType.Name);
        System.assertEquals(1000.00, reQueryapp[0].Account_Number_Guidance_Line__r.Available_Balance__c);
        System.assertEquals(900.00 ,reQueryApp[0].Bank_Owned_Loan_Amount__c);
        System.assertEquals(100.00 ,reQueryOldApp[0].Bank_Owned_Loan_Amount__c);
        System.assertEquals(true, result);
    }

    private static testMethod void it_should_return_false_when_gl_advance_amount_is_less_than_total_sub_loan_amount() {
        
        Account acctClient =  ObjectFactory.getValidEntity('testAccountClient');
        EB_Account__c acct = ObjectFactory.getEBAccount('testAccount','1234',acctClient);
        acct.RecordTypeId = Utility.RecordTypeObject('EB_Account__c', 'Guidance Line').Id;
        acct.Application__c = 35;
        acct.Available_Balance__c = 1000.00;
        update acct;
        
        TestUtilities.createLoanAppStages();
        EB_Loan_Application__c app = ObjectFactory.getLoanApplication('testAccountClient', 'testAccount', '1234', 'testLoanApp');
        app.Account_Number_Guidance_Line__c = acct.Id;
        app.RecordTypeId = Utility.RecordTypeObject('EB_Loan_Application__c', 'New - Guidance Line Advance').Id;
        app.Bank_Owned_Loan_Amount__c = 900.00;
        update app;

        EB_Loan_Application__c oldApp = ObjectFactory.getLoanApplication('testAccountClient', 'testAccount', '1234', 'testLoanAppOld');
        oldApp.Account_Number_Guidance_Line__c = acct.Id;
        oldApp.RecordTypeId = Utility.RecordTypeObject('EB_Loan_Application__c', 'New - Guidance Line Advance').Id;
        oldApp.Bank_Owned_Loan_Amount__c = 101.00;
        update oldApp;
     
        ApexPages.StandardController sc = new Apexpages.Standardcontroller(app);
        String serverurl = Utility.getServerUrl();
        String url = serverurl + '/apex/LoanApplicationEdit?id=';
        PageReference pr = Utility.testhelper(url + app.Id);
        test.setCurrentPage(pr);
        LoanApplicationEditController sut = new LoanApplicationEditController(sc);

        Boolean result = sut.IsGLAdvanceAmountValid;

        List<EB_Loan_Application__c> reQueryOldapp = [SELECT Id, Bank_Owned_Loan_Amount__c, Account_Number_Guidance_Line__r.RecordType.Name, Account_Number_Guidance_Line__r.Available_Balance__c FROM EB_Loan_Application__c WHERE Id =: oldApp.Id];
        List<EB_Loan_Application__c> reQueryApp = [SELECT Id, Bank_Owned_Loan_Amount__c, Account_Number_Guidance_Line__r.RecordType.Name, Account_Number_Guidance_Line__r.Available_Balance__c FROM EB_Loan_Application__c WHERE Id =: app.Id];
        System.assertEquals('Guidance Line', reQueryOldapp[0].Account_Number_Guidance_Line__r.RecordType.Name);
        System.assertEquals(1000.00, reQueryOldapp[0].Account_Number_Guidance_Line__r.Available_Balance__c);
        System.assertEquals(900.00 ,reQueryApp[0].Bank_Owned_Loan_Amount__c);
        System.assertEquals(101.00 ,reQueryOldapp[0].Bank_Owned_Loan_Amount__c);
        System.assertEquals(false, result);
    }

     public static testMethod void code_coverage_1(){
        TestUtilities.createLoanAppStages(); 
        String serverurl = Utility.getServerUrl(); 
        String url = serverurl + '/apex/LoanApplicationEdit?id=';
        EB_Team_Member__c member =  ObjectFactory.getTeamMember('rupadhya');
        Id recEntityId = ObjectFactory.getRecordTypeIdByNameAndObject('Prospect', 'Account');
        Account acctProspect = ObjectFactory.getEntity('test', recEntityId, member);
        EB_Loan_Application__c app = testObjectClass.getTestLoanApp(acctProspect);
        Id RecId = objectfactory.getRecordTypeIdByNameAndObject('Renewal', 'EB_Loan_Application__c');
        update app;

        system.assertNotEquals(app.id, null);
        PageReference pr = Utility.testhelper(url + app.Id);
        test.setCurrentPage(pr);
        ApexPages.StandardController sc = new Apexpages.Standardcontroller(app);
        LoanApplicationEditController testcontroller = new LoanApplicationEditController(sc);
        Map<String,RecordType> recMap1 = testcontroller.RenewalMap;
        Map<Id,RecordType> recMap2 = testcontroller.RenewalMapWithIdAsKey;

        PageReference psave  = testcontroller.SaveClicked();
        PageReference psaveNew  = testcontroller.QuickSaveClicked();
        PageReference pCancel = testcontroller.CheckLocked();
        EB_Loan_Application__c newApp = new EB_Loan_Application__c();
        testcontroller.loan = newApp;
        pCancel = testcontroller.CancelClicked();
        psaveNew  = testcontroller.QuickSaveClicked();
        psavenew = testcontroller.CheckLocked();                                 
    }

    public static testMethod void code_coverage_2(){
        TestUtilities.createLoanAppStages();
        String serverurl = Utility.getServerUrl();
        String url = serverurl + '/apex/LoanApplicationEdit?id=';
        Account acctProspect = testObjectClass.getTestAccount();
        EB_Loan_Application__c app = testObjectClass.getTestLoanApp(acctProspect);
                         
        PageReference pr = Utility.testhelper(url + app.Id);
        test.setCurrentPage(pr);
        ApexPages.StandardController sc = new Apexpages.Standardcontroller(app);
        LoanApplicationEditController testcontroller = new LoanApplicationEditController(sc);
        Map<String,RecordType> recMap1 = testcontroller.RenewalMap;
        Map<Id,RecordType> recMap2 = testcontroller.RenewalMapWithIdAsKey;
        app.recordtypeId = recMap1.get('Renewal').id;
        update app;
        List<SelectOption> lst = testcontroller.getRecordTypes();
        lst = testcontroller.sortSelectOptions(lst);   
        RecordType rec = testcontroller.getRecordTypeId('Renewal'); 
        String check = testcontroller.getIsRenewal();
        check = testcontroller.getRecordtypeStatus();
        LoanApplicationEditController.RenewalLoanCount rencount = testcontroller.renewalCount();
        String perm = testcontroller.HasPermissionToEditLoanNumber;
        String s = LoanApplicationEditController.getServerUrl();
        s = testcontroller.Locked;
        Map<Id,RecordType> maps = testcontroller.RenewalMapWithIdAsKey;
        Boolean checkPermission = testcontroller.HasPermissionToEditLockedApplication;
        checkPermission = testcontroller.IsGLAdvanceAmountValid;
    }
	
}