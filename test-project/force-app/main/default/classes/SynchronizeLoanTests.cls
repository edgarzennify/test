@isTest
public with sharing class SynchronizeLoanTests {
	    
      private static  testMethod void verifySynchronizeBookedLoanPageReference(){
            Account acctProspect = ObjectFactory.getValidEntity('testAccountProspect');
         	Account acctClient =  ObjectFactory.getValidEntity('testAccountClient');
         	acctClient.RecordTypeId = Utility.recordTypeObject('Account', 'Client').Id;
         	update acctClient; 
             
            EB_Account__c acct = ObjectFactory.getEBAccountWithoutInsert('testAccount','1234',acctClient);
         	//acct.Application__c = 35;
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
             SynchronizeLoan syncloan = new SynchronizeLoan();
             syncloan.LoanAppId = app.id;
             syncloan.initializeHelper(); 
             RecordType archiverectype = [SELECT Id, Name FROM RecordType WHERE SobjectType =:'EB_Booked_Loan_App__c' and Name=: 'Booked'] ;
             syncloan.CreateLoanAppBooked(app, acct, 'Booked',archiverectype.Id );
             syncloan.RewireLoanStageLogs(syncloan.bookedLoanapp, syncloan.stagelogs);
           
             syncloan.RewireLoanSnapshots(syncloan.bookedLoanapp, syncloan.snapshots);
             syncloan.CreateNewSnapshot(acct, app, syncloan.bookedLoanapp, 'Booked Snapshot', 'Booked');
          
             syncloan.RewireNotesAndAttachments( app, syncloan.bookedLoanapp);
             syncloan.RewireTasks(app, syncloan.bookedLoanapp);
             Test.stopTest();
               
      }
        	 
      private static  testMethod void verifyAgreementObjectPageReferences(){
      	     Account acctProspect = ObjectFactory.getValidEntity('testAccountProspect');
         	 Account acctClient =  ObjectFactory.getValidEntity('testAccountClient');
         	 acctClient.RecordTypeId = Utility.recordTypeObject('Account', 'Client').Id;
         	 update acctClient; 
             
             EB_Account__c ebAccount = ObjectFactory.getEBAccountWithoutInsert('testAccount','1234',acctClient);
         	//acct.Application__c = 35;
	         ebAccount.Primary_Owner_Id__c = acctClient.Id;
	         insert ebAccount;
	         ebAccount = [SELECT Id, Interest_Rate__c, EB_Account_Type__c, Interest_Rate_Type_Description__c, Account_Industry_Code__c, Application__c, Rate_Subject_to_Change__c,  Interest_Rate_Ceiling__c , Interest_Rate_Floor__c, Interest_Rate_Variance__c, Index_Variance_Code__c,  Rate_Index__c, User_Code_1__c ,Unadvanced_Loan_Amount__c,Current_Balance__c,  Name, Account_Type__c, Primary_Owner_Id__r.Id, Primary_Owner_Id__r.Name, Primary_Owner_Id__r.Createddate, Account_Number__c FROM EB_Account__c  WHERE Id=: ebAccount.Id limit 1 ];           
        	 Agreement__c agmt = new Agreement__c();
	         agmt.Borrower_Name__c = acctProspect.Id;
        	 insert agmt;
        	 TestUtilities.createLoanAppStages();
        	 EB_Loan_Packet__c ebLoanPacket = objectfactory.getLoanPacket(acctProspect);
        	 EB_Loan_Application__c ebLoanApp = objectfactory.getLoanApplication(ebLoanPacket, ebAccount, '12345-15');
        	 Agreement_Loan_Application_Relationship__c agmtLoanAppRel = new Agreement_Loan_Application_Relationship__c(Loan_Application__c=ebLoanApp.Id,Agreement__c=agmt.Id);
             insert agmtLoanAppRel;
             
             Test.startTest();
             SynchronizeLoan syncloan = new SynchronizeLoan();
             syncloan.LoanAppId = ebLoanApp.id;
             syncloan.initializeHelper();
             
             syncloan.updateAgreementClientRelationships(acctProspect, acctClient);
             syncloan.RewireAgreements(ebLoanApp, ebAccount);
             Test.stopTest();
      	
      }

      private static testMethod void it_should_sync_fields_req_for_documentation() {
         	Account acctClient =  ObjectFactory.getValidEntity('testAccountClient');
            EB_Account__c acct = ObjectFactory.getEBAccount('testAccount','1234',acctClient);
	        TestUtilities.createLoanAppStages();
	        EB_Loan_Application__c app = ObjectFactory.getLoanApplication('testAccountClient', 'testAccount', '1234', 'testLoanApp');//testObjectClass.getTestLoanApp(acctProspect);
	        app.Is_Loan_to_Financial_Institution__c = 'LTF';
	        app.Is_Loan_to_Govt_Related_Entity__c = 'LTG';
	        app.Is_repayment_reliant_on_agriculture__c = 'RELAG';
	        app.Financial_institution_accept_deposits__c = 'ACD';
	        app.Niche_Products__c = 'Niche';
	        app.TDR_Determination_One__c = 'Yes';
	        app.TDR_Detail_Justification__c = 'DetailJust';
	        app.TDR_Determination_Two__c = 'No';
	        app.TDR_Concession_Justification__c = 'ConcessJust';
            RecordType archiverectype = [SELECT Id, Name FROM RecordType WHERE SobjectType =:'EB_Booked_Loan_App__c' and Name=: 'Booked'] ;
            SynchronizeLoan sut = new SynchronizeLoan();
            sut.CreateLoanAppBooked(app, acct, 'Booked',archiverectype.Id );
            EB_Booked_Loan_App__c bkdLoan = [SELECT Is_Loan_to_Financial_Institution__c, Is_Loan_to_Govt_Related_Entity__c, Is_repayment_reliant_on_agriculture__c
            										,Financial_institution_accept_deposits__c, Niche_Products__c
            										, TDR_Determination_One__c, TDR_Detail_Justification__c, TDR_Determination_Two__c, TDR_Concession_Justification__c
            								FROM EB_Booked_Loan_App__c LIMIT 1];
            System.assertEquals(app.Is_Loan_to_Financial_Institution__c, bkdLoan.Is_Loan_to_Financial_Institution__c);
            System.assertEquals(app.Is_Loan_to_Govt_Related_Entity__c, bkdLoan.Is_Loan_to_Govt_Related_Entity__c);
            System.assertEquals(app.Is_repayment_reliant_on_agriculture__c, bkdLoan.Is_repayment_reliant_on_agriculture__c);
            System.assertEquals(app.Financial_institution_accept_deposits__c, bkdLoan.Financial_institution_accept_deposits__c);
            System.assertEquals(app.Niche_Products__c, bkdLoan.Niche_Products__c);
            System.assertEquals(app.TDR_Determination_One__c, bkdLoan.TDR_Determination_One__c);
            System.assertEquals(app.TDR_Detail_Justification__c, bkdLoan.TDR_Detail_Justification__c);
            System.assertEquals(app.TDR_Determination_Two__c, bkdLoan.TDR_Determination_Two__c);
            System.assertEquals(app.TDR_Concession_Justification__c, bkdLoan.TDR_Concession_Justification__c);
     }
}