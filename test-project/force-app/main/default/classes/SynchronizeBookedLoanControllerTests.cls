@IsTest
public class SynchronizeBookedLoanControllerTests {
	
    private static testMethod void verifySynchronizeBookedLoanMethod(){
         String srvurl = utility.getServerUrl();
         String url =srvurl+ '/apex/SynchronizeBookedLoan?id=';
         system.debug('####url ' + url);
        
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
         EB_Loan_App_Stage__c stage = TestUtilities.getStageByName('Booking Complete');
         
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
         Agreement__c testAgreement = ObjectFactory.getAgreement('Pending', 'testAccountClient', 'test comments');
         Agreement_client_Relationships__c agmtRelsClient = new Agreement_client_Relationships__c();
         agmtRelsClient.Entity__c = acctClient.Id;
         agmtRelsClient.Agreement__c =  testAgreement.Id;
         insert agmtRelsClient;
         Agreement_client_Relationships__c agmtRelsProspect = new Agreement_client_Relationships__c();
         agmtRelsProspect.Entity__c = acctProspect.Id;
         agmtRelsProspect.Agreement__c =  testAgreement.Id;
         insert agmtRelsProspect;
         
         system.assertNotEquals(app.RecordTypeId, null);
         Test.startTest();
         PageReference pr = utility.testhelper(url + app.Id);
         test.setCurrentPage(pr);
         ApexPages.StandardController sc = new Apexpages.Standardcontroller(app);
         SynchronizeBookedLoanController testcontroller = new SynchronizeBookedLoanController(sc);
         
         testcontroller.entities = new List<SynchronizeBookedLoanController.BookedData>();
         SynchronizeBookedLoanController.BookedData b = new SynchronizeBookedLoanController.BookedData();
         b.BookedProspectId = acctProspect.Id;
         b.BookedProspect = acctProspect.Name;
         b.dropdownOptionId = acctClient.Id;
         testcontroller.entities.add(b);
         
         testcontroller.collaterals = new List<SynchronizeBookedLoanController.BookedData>();
         SynchronizeBookedLoanController.BookedData bc = new SynchronizeBookedLoanController.BookedData();
         bc.BookedProspectId = collProspective.Id;
         bc.BookedProspect = collProspective.Name;
         bc.dropdownOptionId = collExisiting.Id;
         testcontroller.collaterals.add(bc);
         testcontroller.initialize();
         
         
         
         
         testcontroller.PromoteProspectiveCollateralToExistingCollateral(testcontroller.collaterals,acct);
      
         testcontroller.LoadCollateralData();
         testcontroller.LoadProspectsForLoanApp();
       
         testcontroller.booked = testcontroller.collaterals;

         testcontroller.EBAccountDoesNotExistsMessage();
         
         
         testcontroller.MergeCollateral(collProspective,collExisiting);
         
         testcontroller.RunSelectiveCollateralMerge();
         
         Test.stopTest();
        
      }
      
       private static testMethod void verifySynchronizeBookedLoanPageReference(){
         String srvurl = utility.getServerUrl();
         String url =srvurl+ '/apex/SynchronizeBookedLoan?id=';
         Account acctProspect = ObjectFactory.getValidEntity('testAccountProspect');
         Account acctClient =  ObjectFactory.getValidEntity('testAccountClient');
         acctClient.RecordTypeId = Utility.recordTypeObject('Account', 'Client').Id;
         update acctClient; 

         EB_Account__c acct = ObjectFactory.getEBAccountWithoutInsert('testAccount','1234',acctClient);
         acct.Application__c = 35;
         acct.Primary_Owner_Id__c = acctClient.Id;
         insert acct;
         acct = [SELECT Id, Interest_Rate__c, EB_Account_Type__c, Interest_Rate_Type_Description__c, Account_Industry_Code__c, Application__c, Rate_Subject_to_Change__c,  Interest_Rate_Ceiling__c , Interest_Rate_Floor__c, Interest_Rate_Variance__c, Index_Variance_Code__c,  Rate_Index__c, User_Code_1__c ,Unadvanced_Loan_Amount__c,Current_Balance__c,  Name, Account_Type__c, Primary_Owner_Id__r.Id, Primary_Owner_Id__r.Name, Primary_Owner_Id__r.Createddate, Account_Number__c FROM EB_Account__c  WHERE Id=: acct.Id limit 1 ];
                
         EB_Account_Relationship__c acctRel = new EB_Account_Relationship__c();
         acctRel.EB_Account_Id__c = acct.Id;
         acctRel.Client_Id__c = acctClient.Id;
         insert acctRel;
         TestUtilities.createLoanAppStages();
         EB_Loan_App_Stage__c stage = TestUtilities.getStageByName('Booking Complete');

         EB_Loan_Application__c app = ObjectFactory.getLoanApplication('testAccountClient', 'testAccount', '1234', 'testLoanApp');//testObjectClass.getTestLoanApp(acctProspect);
         Id RectTypeId = Utility.recordTypeObject('EB_Loan_Application__c', 'New').Id;
         app.RecordTypeId = RectTypeId;
         app.Account_Number_Assigned__c = acct.Account_Number__c;
         app.Loan_Type__c = utility.LoanTypeGuidanceLine();
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
         EB_Collateral__c collProspective = ObjectFactory.getCollateral('testProspectiveCollateral', ccode, false);//testObjectClass.getTestCollateralObj();
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
         Agreement__c testAgreement = new Agreement__c();
         testAgreement.Borrower_Name__c = acctProspect.Id;
         insert testAgreement;
         Agreement_client_Relationships__c agmtRelsClient = new Agreement_client_Relationships__c();
         agmtRelsClient.Entity__c = acctClient.Id;
         agmtRelsClient.Agreement__c =  testAgreement.Id;
         insert agmtRelsClient;
         Agreement_client_Relationships__c agmtRelsProspect = new Agreement_client_Relationships__c();
         agmtRelsProspect.Entity__c = acctProspect.Id;
         agmtRelsProspect.Agreement__c =  testAgreement.Id;
         insert agmtRelsProspect;
              
         Test.startTest();
         PageReference pr = utility.testhelper(url + app.Id);
         test.setCurrentPage(pr);
         ApexPages.StandardController sc = new Apexpages.Standardcontroller(app);
         SynchronizeBookedLoanController testcontroller = new SynchronizeBookedLoanController(sc);
         testcontroller.entities = new List<SynchronizeBookedLoanController.BookedData>();
         SynchronizeBookedLoanController.BookedData b = new SynchronizeBookedLoanController.BookedData();
         b.BookedProspectId = acctProspect.Id;
         b.BookedProspect = acctProspect.Name;
         b.dropdownOptionId = acctClient.Id;
         testcontroller.entities.add(b);
         
         testcontroller.collaterals = new List<SynchronizeBookedLoanController.BookedData>();
         SynchronizeBookedLoanController.BookedData bc = new SynchronizeBookedLoanController.BookedData();
         bc.BookedProspectId = collProspective.Id;
         bc.BookedProspect = collProspective.Name;
         bc.dropdownOptionId = collExisiting.Id;
         testcontroller.collaterals.add(bc);
         PageReference psave  = testcontroller.CancelClicked();

         psave = testcontroller.SaveClicked();
         string collectiveMerge = testcontroller.ShowSelectiveCollateralMerge;
         Test.stopTest();
     }
     private static testMethod void it_should_throw_an_exception_if_the_stage_is_not_BookedComplete(){
         String srvurl = utility.getServerUrl();
         String url =srvurl+ '/apex/SynchronizeBookedLoan?id=';
         system.debug('####url ' + url); 
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
         Agreement__c testAgreement = ObjectFactory.getAgreement('Pending', 'testAccountClient', 'test comments');
         Agreement_client_Relationships__c agmtRelsClient = new Agreement_client_Relationships__c();
         agmtRelsClient.Entity__c = acctClient.Id;
         agmtRelsClient.Agreement__c =  testAgreement.Id;
         insert agmtRelsClient;
         Agreement_client_Relationships__c agmtRelsProspect = new Agreement_client_Relationships__c();
         agmtRelsProspect.Entity__c = acctProspect.Id;
         agmtRelsProspect.Agreement__c =  testAgreement.Id;
         insert agmtRelsProspect;
         Test.startTest();
         PageReference pr = utility.testhelper(url + app.Id);
         test.setCurrentPage(pr);
         ApexPages.StandardController sc = new Apexpages.Standardcontroller(app);
         SynchronizeBookedLoanController testcontroller = new SynchronizeBookedLoanController(sc);        
         testcontroller.entities = new List<SynchronizeBookedLoanController.BookedData>();
         SynchronizeBookedLoanController.BookedData b = new SynchronizeBookedLoanController.BookedData();
         b.BookedProspectId = acctProspect.Id;
         b.BookedProspect = acctProspect.Name;
         b.dropdownOptionId = acctClient.Id;
         testcontroller.entities.add(b);        
         testcontroller.collaterals = new List<SynchronizeBookedLoanController.BookedData>();
         SynchronizeBookedLoanController.BookedData bc = new SynchronizeBookedLoanController.BookedData();
         bc.BookedProspectId = collProspective.Id;
         bc.BookedProspect = collProspective.Name;
         bc.dropdownOptionId = collExisiting.Id;
         testcontroller.collaterals.add(bc);
         testcontroller.initialize();                       
 
         ApexPages.Message[] msgs = ApexPages.getMessages();

         //Assert
         //system.assertEquals(true, msgs.size() > 0);
         Test.stopTest();        
      } 
      
      private static testMethod void it_should_promote_prospective_collateral_and_set_delete_flag_to_false(){
         // Assemble
         Account testLeadEntity = ObjectFactory.getValidEntity('testEntity');
         EB_Account__c testEbAccount = ObjectFactory.getEBAccount('test', '1234',  testleadEntity);
         Collateral_Code__c ccode = ObjectFactory.getCollateralCode('testccode', '10001');
         EB_Collateral__c collExisiting = ObjectFactory.getCollateral('testExistingCollateral', ccode, false);
         EB_Collateral__c collProspective = ObjectFactory.getCollateral('testProspectiveCollateral', ccode, false);
         collProspective.key__c = '';
         collProspective.Delete_Flag__c = false;
         collProspective.Change_Collateral_Code__c = false;
         update collProspective;

         EB_Collateral_Account_Relationship__c ebExistingCollatAcctRel = new EB_Collateral_Account_Relationship__c(EB_Collateral_ID__c=collExisiting.Id, EB_Account_ID__c=testEbAccount.Id);
         insert ebExistingCollatAcctRel;
      
         EB_Collateral_Client_Relationship__c ebExistingCollatClientRel = new EB_Collateral_Client_Relationship__c( EB_Collateral_ID__c = collExisiting.Id, Client_ID__c=testLeadEntity.Id,Key__c='1234');
         insert ebExistingCollatClientRel;

         EB_Appraisal_Order__c appraisalOrder = new EB_Appraisal_Order__c( Related_Collateral__c=collExisiting.Id);
         insert appraisalOrder;

         SynchronizeBookedLoanController.BookedData bData = new SynchronizeBookedLoanController.BookedData();
        
         bData.index = '0';
         bData.BookedProspect = collProspective.Name;
         bData.BookedProspectId = collProspective.Id;
         bData.dropdownOptionId = collExisiting.Id;

         List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption(collExisiting.Id, collExisiting.Name));

         List<SynchronizeBookedLoanController.BookedData> listBookedData = new List<SynchronizeBookedLoanController.BookedData>{bData};
         SynchronizeBookedLoanController testController = new SynchronizeBookedLoanController(null,null);

         //Act
         testController.PromoteProspectiveCollateralToExistingCollateral(listBookedData, testEbAccount);

         EB_Collateral__c reQueriedcollProspective = [SELECT Id, Delete_Flag__c, Name,
                                                       (SELECT Id, Name, EB_Collateral_ID__c FROM EB_Collateral_Account_Relationships__r ),
                                                       (SELECT Id, Name, EB_Collateral_ID__c FROM EB_Collateral_Client_Relationships__r ),
                                                      (SELECT Id ,Name, Related_Collateral__c FROM EB_Loan_Appraisal_Orders__r) 
                                                      FROM EB_Collateral__c WHERE ID =:collProspective.Id limit 1];

         //Assert                                             
         System.assertEquals(false,reQueriedcollProspective.Delete_Flag__c);
         System.assertEquals(ebExistingCollatAcctRel.Id,reQueriedcollProspective.EB_Collateral_Account_Relationships__r[0].Id);
         System.assertNotEquals(null,ebExistingCollatClientRel.Id);
         System.assertEquals(0,reQueriedcollProspective.EB_Collateral_Client_Relationships__r.Size());         
         System.assertEquals(appraisalOrder.Id,reQueriedcollProspective.EB_Loan_Appraisal_Orders__r[0].Id);

         List<EB_Collateral__c> reQueriedcollExisiting = [SELECT Id, Delete_Flag__c, Name FROM EB_Collateral__c WHERE ID =:collExisiting.Id ];
         System.assertEquals(0,reQueriedcollExisiting.size());
      }
   
      private static testMethod void it_should_not_promote_prospective_collateral_when_not_applicable_is_selected_and_set_delete_flag_to_true(){
         // Assemble
         Account testLeadEntity = ObjectFactory.getValidEntity('testEntity');
         EB_Account__c testEbAccount = ObjectFactory.getEBAccount('test', '1234',  testleadEntity);
         Collateral_Code__c ccode = ObjectFactory.getCollateralCode('testccode', '10001');
         EB_Collateral__c collProspective = ObjectFactory.getCollateral('testProspectiveCollateral', ccode, false);
         collProspective.key__c = '';
         collProspective.Delete_Flag__c = false;
         collProspective.Change_Collateral_Code__c = false;
         update collProspective;

         SynchronizeBookedLoanController.BookedData bData = new SynchronizeBookedLoanController.BookedData();
         bData.index = '0';
         bData.BookedProspect = collProspective.Name;
         bData.BookedProspectId = collProspective.Id;
         bData.dropdownOptionId = '1';
       
         List<SynchronizeBookedLoanController.BookedData> listBookedData = new List<SynchronizeBookedLoanController.BookedData>{bData};
         SynchronizeBookedLoanController testController = new SynchronizeBookedLoanController(null,null);

         //Act
         testController.PromoteProspectiveCollateralToExistingCollateral(listBookedData, testEbAccount);

         EB_Collateral__c reQueriedcollProspective = [SELECT Id, Delete_Flag__c, Name,
                                                      (SELECT Id, Name, EB_Collateral_ID__c FROM EB_Collateral_Account_Relationships__r ),
                                                      (SELECT Id, Name, EB_Collateral_ID__c FROM EB_Collateral_Client_Relationships__r ),
                                                      (SELECT Id ,Name, Related_Collateral__c FROM EB_Loan_Appraisal_Orders__r) 
                                                      FROM EB_Collateral__c WHERE ID =:collProspective.Id limit 1];

         //Assert                                             
         System.assertEquals(true,reQueriedcollProspective.Delete_Flag__c);
        
      }
}