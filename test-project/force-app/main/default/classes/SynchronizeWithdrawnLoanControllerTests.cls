@IsTest
public with sharing class SynchronizeWithdrawnLoanControllerTests {
	private static testMethod void verifySynchronizeWithdrawnLoanPageReference(){
	 	 String url = utility.getServerUrl()+ '/apex/SynchronizeWithdrawnLoan?id=';
	 	 Account acctProspect = ObjectFactory.getValidEntity('testAccountProspect');
         Account acctClient =  ObjectFactory.getValidEntity('testAccountClient');
         acctClient.RecordTypeId = Utility.recordTypeObject('Account', 'Client').Id;
	 	 update acctClient;
	 	 
	 	 EB_Account__c acct = ObjectFactory.getEBAccountWithoutInsert('testAccount','1234',acctClient);
         acct.Primary_Owner_Id__c = acctClient.Id;
         insert acct;
         acct = [SELECT Id, Interest_Rate__c, EB_Account_Type__c, Interest_Rate_Type_Description__c, Account_Industry_Code__c, Application__c, Rate_Subject_to_Change__c,  Interest_Rate_Ceiling__c , Interest_Rate_Floor__c, Interest_Rate_Variance__c, Index_Variance_Code__c,  Rate_Index__c, User_Code_1__c ,Unadvanced_Loan_Amount__c,Current_Balance__c,  Name, Account_Type__c, Primary_Owner_Id__r.Id, Primary_Owner_Id__r.Name, Primary_Owner_Id__r.Createddate, Account_Number__c FROM EB_Account__c  WHERE Id=: acct.Id limit 1 ];
   
	 	 EB_Account_Relationship__c acctRel = new EB_Account_Relationship__c();
	 	 acctRel.EB_Account_Id__c = acct.Id;
	 	 acctRel.Client_Id__c = acctClient.Id;
	 	 insert acctRel;
	 	 TestUtilities.createLoanAppStages();
         EB_Loan_App_Stage__c stage = TestUtilities.getStageByName('Withdrawn');
         
         EB_Loan_Application__c app = ObjectFactory.getLoanApplication('testAccountClient', 'testAccount', '1234', 'testLoanApp');
         Id RectTypeId = Utility.recordTypeObject('EB_Loan_Application__c', 'New').Id;
         app.RecordTypeId = RectTypeId;

         app.Account_Number_Assigned__c = acct.Account_Number__c;
         app.Application_Stage__c = stage.Id;
         update app;
         EB_Loan_App_Minute__c snap = new EB_Loan_App_Minute__c();
         snap.EB_Loan_Application__c = app.Id;
         Datetime dT = System.now();
	     Date d = date.newinstance(dT.year(), dT.month(), dT.day()); 
         snap.Decision_Date__c = d;
         insert snap;
         
         EB_Loan_Application_Stage_Log__c log = new EB_Loan_Application_Stage_Log__c();
         log.EB_Loan_Application__c = app.id;
         insert log;
         
         Collateral_Code__c ccode = ObjectFactory.getCollateralCode('testccode', '10001');
         EB_Collateral__c collExisiting = ObjectFactory.getCollateral('testExistingCollateral', ccode, false);
         EB_Collateral__c collProspective = ObjectFactory.getCollateral('testProspectiveCollateral', ccode, false);
         collProspective.key__c = '';
         update collProspective;
         
         EB_Collateral_Account_Relationship__c colAcctRel = new EB_Collateral_Account_Relationship__c();
         colAcctRel.EB_Account_ID__c = acct.Id;
         colAcctRel.EB_Collateral_ID__c = collExisiting.Id;
        
         insert colAcctRel;
         system.assertNotEquals(colAcctRel.Id, null);
         EB_Loan_App_Collateral_Relationship__c colRel = new EB_Loan_App_Collateral_Relationship__c();
         colRel.EB_Collateral_ID__c = collExisiting.Id;
         colRel.EB_Loan_Application_ID__c = app.Id;
          colRel.Purpose_of_Collateral__c = 'Business';
         insert colRel;
         System.assertNotEquals(colRel.Id, null);
         EB_Loan_App_Entity_Relationship__c entRel = new EB_Loan_App_Entity_Relationship__c();
         entRel.Loan_Application_ID__c = app.Id;
         entRel.Entity_Name__c = acctProspect.Id;
         entRel.Relationship_Type__c ='Guarantor';
         insert entRel;
         system.assertNotEquals(entRel, null);
         
         
         Test.startTest();
         PageReference pr = utility.testhelper(url + app.Id);
	     test.setCurrentPage(pr);
	     ApexPages.StandardController sc = new Apexpages.Standardcontroller(app);
	     SynchronizeWithdrawnLoanController testcontroller = new SynchronizeWithdrawnLoanController(sc);
	     testcontroller.initialize();
	     PageReference psave = testcontroller.ArchiveWithdrawnApp();
	     Test.stopTest();
	 }
	
	  private static testMethod void verifySynchronizeWithdrawnLoanMethod(){
   	 	String url = utility.getServerUrl()+ '/apex/SynchronizeWithdrawnLoan?id=';
   	 	Account acctProspect = ObjectFactory.getValidEntity('testAccountProspect');
         Account acctClient =  ObjectFactory.getValidEntity('testAccountClient');
         acctClient.RecordTypeId = Utility.recordTypeObject('Account', 'Client').Id;
   	 	update acctClient;
   	 	 
   	 	EB_Account__c acct = ObjectFactory.getEBAccountWithoutInsert('testAccount','1234',acctClient);
         acct.Primary_Owner_Id__c = acctClient.Id;
         insert acct;
         acct = [SELECT Id, Interest_Rate__c, EB_Account_Type__c, Interest_Rate_Type_Description__c, Account_Industry_Code__c, Application__c, Rate_Subject_to_Change__c,  Interest_Rate_Ceiling__c , Interest_Rate_Floor__c, Interest_Rate_Variance__c, Index_Variance_Code__c,  Rate_Index__c, User_Code_1__c ,Unadvanced_Loan_Amount__c,Current_Balance__c,  Name, Account_Type__c, Primary_Owner_Id__r.Id, Primary_Owner_Id__r.Name, Primary_Owner_Id__r.Createddate, Account_Number__c FROM EB_Account__c  WHERE Id=: acct.Id limit 1 ];
   
	 	   EB_Account_Relationship__c acctRel = new EB_Account_Relationship__c();
	 	   acctRel.EB_Account_Id__c = acct.Id;
	 	   acctRel.Client_Id__c = acctClient.Id;
	 	   insert acctRel;
	 	   TestUtilities.createLoanAppStages();
         EB_Loan_App_Stage__c stage = TestUtilities.getStageByName('Withdrawn');
         
         EB_Loan_Application__c app = ObjectFactory.getLoanApplication('testAccountClient', 'testAccount', '1234', 'testLoanApp');
         Id RectTypeId = Utility.recordTypeObject('EB_Loan_Application__c', 'New').Id;
         app.RecordTypeId = RectTypeId;

         app.Account_Number_Assigned__c = acct.Account_Number__c;
         app.Application_Stage__c = stage.Id;
         update app;
         EB_Loan_App_Minute__c snap = new EB_Loan_App_Minute__c();
         snap.EB_Loan_Application__c = app.Id;
         Datetime dT = System.now();
	      Date d = date.newinstance(dT.year(), dT.month(), dT.day()); 
         snap.Decision_Date__c = d;
         insert snap;
         
         EB_Loan_Application_Stage_Log__c log = new EB_Loan_Application_Stage_Log__c();
         log.EB_Loan_Application__c = app.id;
         insert log;
         
         Collateral_Code__c ccode = ObjectFactory.getCollateralCode('testccode', '10001');
         EB_Collateral__c collExisiting = ObjectFactory.getCollateral('testExistingCollateral', ccode, false);
         EB_Collateral__c collProspective = ObjectFactory.getCollateral('testProspectiveCollateral', ccode, false);
         collProspective.key__c = '';
         update collProspective;
         
         EB_Collateral_Account_Relationship__c colAcctRel = new EB_Collateral_Account_Relationship__c();
         colAcctRel.EB_Account_ID__c = acct.Id;
         colAcctRel.EB_Collateral_ID__c = collExisiting.Id;
        
         insert colAcctRel;
         system.assertNotEquals(colAcctRel.Id, null);
         EB_Loan_App_Collateral_Relationship__c colRel = new EB_Loan_App_Collateral_Relationship__c();
         colRel.EB_Collateral_ID__c = collExisiting.Id;
         colRel.EB_Loan_Application_ID__c = app.Id;
         colRel.Purpose_of_Collateral__c = 'Business';
         insert colRel;
         System.assertNotEquals(colRel.Id, null);
         EB_Loan_App_Entity_Relationship__c entRel = new EB_Loan_App_Entity_Relationship__c();
         entRel.Loan_Application_ID__c = app.Id;
         entRel.Entity_Name__c = acctProspect.Id;
         entRel.Relationship_Type__c ='Guarantor';
         insert entRel;
         system.assertNotEquals(entRel, null);
         
         system.assertNotEquals(app.RecordTypeId, null);
         Test.startTest();
         PageReference pr = utility.testhelper(url + app.Id);
	     test.setCurrentPage(pr);
	     ApexPages.StandardController sc = new Apexpages.Standardcontroller(app);
	     SynchronizeWithdrawnLoanController testcontroller = new SynchronizeWithdrawnLoanController(sc);

	     testcontroller.initialize();
		 Test.stopTest();
        
	  }
	  private static testMethod void it_should_throw_an_exception_if_the_stage_is_not_Withdrawn(){
	 	 String url = utility.getServerUrl()+ '/apex/SynchronizeWithdrawnLoan?id=';
	 	 Account acctProspect = ObjectFactory.getValidEntity('testAccountProspect');
         Account acctClient =  ObjectFactory.getValidEntity('testAccountClient');
         acctClient.RecordTypeId = Utility.recordTypeObject('Account', 'Client').Id;
	 	 update acctClient;	 	 
	 	 EB_Account__c acct = ObjectFactory.getEBAccountWithoutInsert('testAccount','1234',acctClient);
         acct.Primary_Owner_Id__c = acctClient.Id;
         insert acct;
         acct = [SELECT Id, Interest_Rate__c, EB_Account_Type__c, Interest_Rate_Type_Description__c, Account_Industry_Code__c, Application__c, Rate_Subject_to_Change__c,  Interest_Rate_Ceiling__c , Interest_Rate_Floor__c, Interest_Rate_Variance__c, Index_Variance_Code__c,  Rate_Index__c, User_Code_1__c ,Unadvanced_Loan_Amount__c,Current_Balance__c,  Name, Account_Type__c, Primary_Owner_Id__r.Id, Primary_Owner_Id__r.Name, Primary_Owner_Id__r.Createddate, Account_Number__c FROM EB_Account__c  WHERE Id=: acct.Id limit 1 ]; 
	 	 EB_Account_Relationship__c acctRel = new EB_Account_Relationship__c();
	 	 acctRel.EB_Account_Id__c = acct.Id;
	 	 acctRel.Client_Id__c = acctClient.Id;
	 	 insert acctRel;
	 	 TestUtilities.createLoanAppStages();
         EB_Loan_App_Stage__c stage = TestUtilities.getStageByName('New');        
         EB_Loan_Application__c app = ObjectFactory.getLoanApplication('testAccountClient', 'testAccount', '1234', 'testLoanApp');
         Id RectTypeId = Utility.recordTypeObject('EB_Loan_Application__c', 'New').Id;
         app.RecordTypeId = RectTypeId;
         app.Account_Number_Assigned__c = acct.Account_Number__c;
         app.Application_Stage__c = stage.Id;
         update app;
         EB_Loan_App_Minute__c snap = new EB_Loan_App_Minute__c();
         snap.EB_Loan_Application__c = app.Id;
         Datetime dT = System.now();
	     Date d = date.newinstance(dT.year(), dT.month(), dT.day()); 
         snap.Decision_Date__c = d;
         insert snap;        
         EB_Loan_Application_Stage_Log__c log = new EB_Loan_Application_Stage_Log__c();
         log.EB_Loan_Application__c = app.id;
         insert log;        
         Collateral_Code__c ccode = ObjectFactory.getCollateralCode('testccode', '10001');
         EB_Collateral__c collExisiting = ObjectFactory.getCollateral('testExistingCollateral', ccode, false);
         EB_Collateral__c collProspective = ObjectFactory.getCollateral('testProspectiveCollateral', ccode, false);
         collProspective.key__c = '';
         update collProspective;    
         EB_Collateral_Account_Relationship__c colAcctRel = new EB_Collateral_Account_Relationship__c();
         colAcctRel.EB_Account_ID__c = acct.Id;
         colAcctRel.EB_Collateral_ID__c = collExisiting.Id;    
         insert colAcctRel;
         system.assertNotEquals(colAcctRel.Id, null);
         EB_Loan_App_Collateral_Relationship__c colRel = new EB_Loan_App_Collateral_Relationship__c();
         colRel.EB_Collateral_ID__c = collExisiting.Id;
         colRel.EB_Loan_Application_ID__c = app.Id;
         colRel.Purpose_of_Collateral__c = 'Business';
         insert colRel;
         System.assertNotEquals(colRel.Id, null);
         EB_Loan_App_Entity_Relationship__c entRel = new EB_Loan_App_Entity_Relationship__c();
         entRel.Loan_Application_ID__c = app.Id;
         entRel.Entity_Name__c = acctProspect.Id;
         entRel.Relationship_Type__c ='Guarantor';
         insert entRel;     
         Test.startTest();
         PageReference pr = utility.testhelper(url + app.Id);
	     test.setCurrentPage(pr);
	     ApexPages.StandardController sc = new Apexpages.Standardcontroller(app);
	     SynchronizeWithdrawnLoanController testcontroller = new SynchronizeWithdrawnLoanController(sc);
	     testcontroller.initialize();


		 ApexPages.Message[] msgs = ApexPages.getMessages();

		 //Assert
		 system.assertEquals(true, msgs.size() > 0);
		 Test.stopTest();
        
	  }
}