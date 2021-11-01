@isTest
public  class testObjectClass {
	    public static Id getRecordTypeIdForName(String RecordTypeName, String SobjectType){
		    
		      List<RecordType> recordTypeList = [SELECT  Name, Id FROM RecordType WHERE SobjectType =: SobjectType];
   
		    
		      for (RecordType r : recordTypeList){
		        if(r != null){
		          if(r.Name == RecordTypeName) return r.Id;
		        }
		      }
		  
		    return null;
 		 }
	public static Account getTestAccount(){
		/*Id record_typeProspectId  = testObjectClass.getRecordTypeIdForName('Prospect', 'Account');
	        
		List<User> users = [SELECT Id, Name, alias FROM User WHERE alias=: 'rupadhya' or alias=:'bholland' or  alias =: 'phoban' order by alias];
		List<EB_Team_Member__c> teammembers = [SELECT Id, Name FROM EB_Team_Member__c WHERE User__c =: users[0].Id or User__c =:users[1].Id or User__c =: users[2].Id order by Officer_Code__c];                
	        
	    
	    
        Date d = date.newinstance(2011, 1, 1);
        Account acctProspect = new Account(
        	Name='TestProspectPtoC', 
			BillingStreet='Test Street',
			BillingCity='Test city',
			BillingPostalCode='UTEST1 1UT',
			RecordTypeId=record_typeProspectId,
			Team_Relationship_Manager__c=teammembers[0].Id,
			Last_Financial_Statement__c=d
		);
			
        insert acctProspect;
        return acctProspect; */
        EB_Unit__c branch = objectFactory.getUnit('testBranch', 4001);
    		
	
    	
    		EB_Team_Member__c team = objectFactory.getTeamMember('Team1');
			Integer numEntities = 1;
         	//Integer numCollateral = 50;
         	
         	Id ClientRecordTypeId = objectFactory.getRecordTypeIdByNameAndObject('Client', 'Account');
         	Id ProspectRecordTypeId = objectFactory.getRecordTypeIdByNameAndObject('Prospect', 'Account');
         	//Id LoanAppCollateralRecordTypeId = objectFactory.getRecordTypeIdByNameAndObject('All', 'EB_Loan_App_Collateral_Relationship__c');
            Account LeadEntity = objectFactory.getEntity('Test Entity',ClientRecordTypeId, team);
            return LeadEntity;
	}

    public static EB_Loan_Application__c getTestLoanApp(){
		EB_Unit__c branch = objectFactory.getUnit('testBranch', 4001);
		EB_Team_Member__c team = objectFactory.getTeamMember('Team1');
		Integer numEntities = 1;
     	Id ClientRecordTypeId = objectFactory.getRecordTypeIdByNameAndObject('Client', 'Account');
     	Id ProspectRecordTypeId = objectFactory.getRecordTypeIdByNameAndObject('Prospect', 'Account');
        Account LeadEntity = objectFactory.getEntity('Test Entity',ClientRecordTypeId, team);
		EB_Loan_Packet__c loanpacket = objectfactory.getLoanPacket(leadEntity);
		EB_Account__c ebaccount = objectfactory.getEBAccount('Test', '1234', LeadEntity);
		EB_Loan_Application__c app = objectfactory.getLoanApplication(loanPacket, ebAccount, '1234');
		return app;
    }

    public static EB_Loan_Application__c getTestNewLoanApp(){
		EB_Unit__c branch = objectFactory.getUnit('testBranch', 4001);
		EB_Team_Member__c team = objectFactory.getTeamMember('Team1');
		Integer numEntities = 1;
     	Id ClientRecordTypeId = objectFactory.getRecordTypeIdByNameAndObject('Client', 'Account');
     	Id ProspectRecordTypeId = objectFactory.getRecordTypeIdByNameAndObject('Prospect', 'Account');
        Account LeadEntity = objectFactory.getEntity('Test Entity',ClientRecordTypeId, team);
		EB_Loan_Packet__c loanpacket = objectfactory.getLoanPacket(leadEntity);
		EB_Account__c ebaccount ;
		EB_Loan_Application__c app = objectfactory.getLoanApplication(loanPacket, ebaccount, '1234');
		return app;
    }

    public static EB_Loan_Application__c getTestLoanApp(Account acctProspect){
    	return getTestLoanApp();
		/*List<User> users = [SELECT Id, Name, alias FROM User WHERE alias=: 'rupadhya' or alias=:'bholland' or  alias =: 'phoban' order by alias];
		List<EB_Team_Member__c> teammembers = [SELECT Id, Name FROM EB_Team_Member__c WHERE User__c =: users[0].Id or User__c =:users[1].Id or User__c =: users[2].Id order by Officer_Code__c];                
		Datetime dT = System.now();
	    Date d = date.newinstance(dT.year(), dT.month(), dT.day()); 
	    
		EB_Loan_Packet__c packet = new EB_Loan_Packet__c(
			Name='Test Packet',
			Lead_Entity__c=acctProspect.Id,
			
			Loan_Coordinator__c=teammembers[0].Id,
			Actual_Approval_Path__c='2 Signatures',
			Law_Firm__c = 'TestFirm'
			
		);
		insert packet;
        Id RectTypeId = testObjectClass.getRecordTypeIdForName('New', 'EB_Loan_Application__c');
		EB_Loan_Application__c app = new EB_Loan_Application__c(
			EB_Loan_Packet__c = packet.Id,
			Loan_Type__c = 'Fixed Line',
			Business_Purpose__c = 'Yes',
			Approver_One__c = users[1].Id,
			Approver_Two__c = users[2].Id,
			Approver_Three__c = users[0].Id,
			Approved_by_SFDC_Approval_Process__c = false,
			Rejected_by_SFDC_Approval_Process__c = false,
			Original_Maturity_Date__c = d,
			Maturity_date__c = d
			//RecordTypeId = RectTypeId
		);
		insert app;
		
		
		return app;*/
    }
    public static EB_Booked_Loan_App__c getTestArchivedApp(Account acctProspect){
		//List<User> users = [SELECT Id, Name, alias FROM User WHERE alias=: 'rupadhya' or alias=:'bholland' or  alias =: 'mlawson' order by alias];
		//List<EB_Team_Member__c> teammembers = [SELECT Id, Name FROM EB_Team_Member__c WHERE User__c =: users[0].Id or User__c =:users[1].Id or User__c =: users[2].Id order by Officer_Code__c];                
		
		Datetime dT = System.now();
	    Date d = date.newinstance(dT.year(), dT.month(), dT.day()); 
		EB_Loan_Packet__c packet = new EB_Loan_Packet__c(
			Name='Test Packet',
			Lead_Entity__c=acctProspect.Id,
			Loan_Coordinator__c=objectFactory.getTeamMember('TeamMember1').Id,
			Actual_Approval_Path__c='2 Signatures',
			Law_Firm__c = 'TestFirm'
			
		);
		insert packet;
        Id RectTypeId = testObjectClass.getRecordTypeIdForName('New', 'EB_Loan_Application__c');
		EB_Booked_Loan_App__c app = new EB_Booked_Loan_App__c(
			Loan_Packet__c = packet.Id,
			Loan_Type__c = 'Fixed Line',
			Business_Purpose__c = 'Yes',
			Approver_One__c = objectFactory.getUser('Test1','User1','Test1User1@enterprisebank.com.test',true).Id,
			Approver_Two__c = objectFactory.getUser('Test2','User2','Test2User2@enterprisebank.com.test',true).Id,
			Approver_Three__c = objectFactory.getUser('Test3','User3','Test3User3@enterprisebank.com.test',true).Id,
			Approved_by_SFDC_Approval_Process__c = false,
			Rejected_by_SFDC_Approval_Process__c = false,
			Original_Maturity_Date__c = d,
			Maturity_date__c = d
			//RecordTypeId = RectTypeId
		);
		insert app;
		
		
		return app;
    }
    public static EB_Loan_App_Entity_Relationship__c getLoanAppEntityRealationship(Account acctProspect , EB_Loan_Application__c app){
    	EB_Loan_App_Entity_Relationship__c rel = new EB_Loan_App_Entity_Relationship__c();
    	rel.Entity_Name__c = acctProspect.Id;
    	rel.Loan_Application_ID__c = app.Id;
    	rel.Limited_or_Unlimited__c = 'No';
    	rel.Relationship_Type__c = 'Co-Borrower';
    	rel.Limitation__c = 2000;
    	rel.Loan_App_Net_Worth__c = 3000;
    	insert rel;
    	return rel;
    }
    public static EB_Loan_App_Collateral_Relationship__c getTestLoanAppCollateralRelationshipObj(EB_Collateral__c collateral, EB_Loan_Application__c app){
    	EB_Loan_App_Collateral_Relationship__c rel = new EB_Loan_App_Collateral_Relationship__c();
    	rel.Abundance_of_Caution__c = 'No';
    	rel.EB_Collateral_ID__c = collateral.Id;
    	rel.EB_Loan_Application_ID__c = app.Id;
    	rel.RecordTypeId = getRecordTypeIdForName('All', 'EB_Loan_App_Collateral_Relationship__c');
    	rel.Purpose_of_Collateral__c = 'Additional';
    	insert rel;
    	return rel;
    }
    public static EB_Collateral__c getTestCollateralObj(String colateralCode){
    	
    	Collateral_Code__c code = objectfactory.getCollateralCode('Testccode', colateralCode);
    	system.debug('###' + code.Id);
    	EB_Collateral__c col = objectfactory.getCollateral('TestCollateral', code, true);											

    	return col;
    }
       public static EB_Collateral__c getTestCollateralObj(){
      Collateral_Code__c code = [SELECT Id FROM Collateral_Code__c WHERE Collateral_Code_ID__c <> null limit 1];
      EB_Collateral__c col = new EB_Collateral__c(Name = 'Prospective-Test',
                            City__c = 'Saint Louis',
                            Collateral_Application__c = '00',
                            Collateral_Code__c = code.Id,
                            Collateral_Description__c = 'Test Collateral',
                            Collateral_Number__c = '00000'
                          
                            
                            );
      insert col;
      return col;
    }
    public static EB_Collateral_Client_Relationship__c getTestCollateralClientObject(Account acctProspect, EB_Collateral__c collateral){
    	EB_Collateral_Client_Relationship__c rel = new EB_Collateral_Client_Relationship__c();
    	rel.Client_ID__c = acctProspect.Id;
    	rel.EB_Collateral_ID__c = collateral.Id;
    	insert rel;
    	return rel;
    }
     /*public static testMethod void verifytestObjectClass(){
     	Account acct = testObjectClass.getTestAccount();
     	EB_Loan_Application__c app = testObjectClass.getTestLoanApp(acct);
     	EB_Collateral__c col = testObjectClass.getTestCollateralObj('??');
     	EB_Collateral_Client_Relationship__c relOwner = getTestCollateralClientObject(acct,col);
     	EB_Loan_App_Collateral_Relationship__c rel = testObjectClass.getTestLoanAppCollateralRelationshipObj(col,app);
     	Id rec = testObjectClass.getRecordTypeIdForName('Prospect', 'Account');
     	
     }
     */
}