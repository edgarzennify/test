@isTest
public class LoanAppRenewalControllerTests{
	static testMethod void it_should_handle_links_to_loan_in_agreement_for_empty_list(){
		Account entity = ObjectFactory.getValidEntity('test entity');
    	EB_Account__c  ebaccount = objectfactory.getEBAccount('Test Account Title', '12345-15', entity);
    	//EB_Loan_Packet__c ebLoanPacket = objectfactory.getLoanPacket(entity);
        //EB_Loan_Application__c loanApp = objectfactory.getLoanApplication(ebLoanPacket, ebAccount, '12345-15');
		PageReference pr = Page.LoanAppRenewal;
		test.setCurrentPage(pr);
        ApexPages.StandardController sc = new Apexpages.Standardcontroller(ebaccount);
		LoanAppRenewalController sut = new LoanAppRenewalController(sc);
		
		sut.linkLoanAppsToAgreementsForGivenEbaccount(ebaccount,null);	
	}
	
    static testMethod void verifyLoanAppRenewalPageReference(){
     
        String url = Utility.getServerUrl() + '/apex/LoanAppRenewal?id=';
        EB_Account__c acct = setupVerifyLoanAppRenewalMethods();
        PageReference pr = utility.testhelper(url + acct.Id + '&type=r');
        test.setCurrentPage(pr);
        ApexPages.StandardController sc = new Apexpages.Standardcontroller(acct);
        LoanAppRenewalController testcontroller = new LoanAppRenewalController(sc);
        PageReference psave  = testcontroller.RedirectToRenewalApp();
    }
      
     static testMethod void verifyLoanAppRenewalPageReference1(){
          
         
        
        String url = utility.getServerUrl() + '/apex/LoanAppRenewal?id=';
        EB_Account__c acct = setupVerifyLoanAppRenewalMethods();
                
        PageReference pr = utility.testhelper(url + acct.Id );
        test.setCurrentPage(pr);
        ApexPages.StandardController sc = new Apexpages.Standardcontroller(acct);
        LoanAppRenewalController testcontroller = new LoanAppRenewalController(sc);
        PageReference psave  = testcontroller.RedirectToRenewalApp();
    }
     
    static EB_Account__c setupVerifyLoanAppRenewalMethods(){
    	TestUtilities.createLoanAppStages();
	    EB_Unit__c branch = objectFactory.getUnit('testBranch', 4001);        
	                
	    EB_Team_Member__c team = objectFactory.getTeamMember('Team1');
	
	        Id ClientRecordTypeId = objectFactory.getRecordTypeIdByNameAndObject('Client', 'Account');
	            
	        Account LeadEntity = objectFactory.getEntity('Test Entity',ClientRecordTypeId, team);
	        List<EB_Account__c> accounts = new List<EB_Account__c>();
	            
	        EB_Account__c acct = new EB_Account__c(Name='123-15',Application__c=15);
	        acct.EB_Unit__c = branch.Id;
	        acct.Account_Status__c = 'A';
	        acct.Primary_Owner_Id__c = LeadEntity.ID;
	        insert acct;
	        EB_Loan_Packet__c  packet = Objectfactory.getLoanPacket(leadEntity);
	       
	        EB_Account_Participation__c testp = new EB_Account_Participation__c();
	        testp.EB_Account__c = acct.Id;
	        testp.RecordTypeId = Utility.recordTypeObject('EB_Account_Participation__c', 'Bought').Id;
	        insert testp;
	        
	        EB_Account_Relationship__c re = new EB_Account_Relationship__c();
	        re.Client_Id__c = LeadEntity.id;
	        re.EB_Account_Id__c = acct.Id;
	        re.Relationship__c = 'Primary Borrower';
	        insert re;
	        EB_Account_Participation__c p = new EB_Account_Participation__c();
	        p.IsPurchasedparticipation__c = testp.IsPurchasedparticipation__c;
	        p.Lead_bank__c = testp.Lead_Bank__c;
	        p.EB_Account__c = acct.id;
	            
	        p.Name_of_Signer__c = testp.Name_Of_Signer__c;
	        p.Participated_Amount__c = testp.Participated_Amount__c;
	        p.Participating_Institution__c = testp.Participating_Institution__c;
	        p.recordtypeid = testp.RecordTypeId;
	        p.Special_Participation_Instructions__c = testp.Special_Participation_Instructions__c;
	        p.Title_of_Signer__c = testp.Title_of_Signer__c;
	        p.Address__c = testp.Address__c;
	        insert p;
	            
	        EB_Account_Payment_Stream__c s = new EB_Account_Payment_Stream__c();
	        s.Amount__c =  100;
	        s.Duration__c = 60;
	        s.EB_Account__c = acct.Id;
	        s.RecordTypeId = Utility.recordTypeObject('EB_Account_Payment_Stream__c','Level Payment').Id;
	        s.Stream_Number__c = '1';
	        s.Frequency__c = 'Monthly';
	        insert s;
	            
	        return acct;
    }
    
    static testMethod void verifyLoanAppRenewalMethod(){
    	
	    	String url = utility.getServerUrl() + '/apex/LoanAppRenewal?id=';
	        EB_Account__c acct = setupVerifyLoanAppRenewalMethods();   
	            
	        test.startTest();
	         
	        PageReference pr = utility.testhelper(url + acct.Id + '&t=r' );
			test.setCurrentPage(pr);
			ApexPages.StandardController sc = new Apexpages.Standardcontroller(acct);
			LoanAppRenewalController testcontroller = new LoanAppRenewalController(sc);
			testcontroller.initialize();
			testcontroller.EBAccount = acct;
			EB_Loan_Packet__c pt = testcontroller.CreateLoanPacket();
			 
			testcontroller.CreateLoanApplication(pt);          
			String surl = utility.getServerUrl() + '/'; 
			List<EB_Collateral__c> cols =  testcontroller.getCollaterals();
			List<EB_Account_Relationship__c> rels = testcontroller.getAccountRelationships();
			List<Account> accts = testcontroller.getPledgors(rels);

			testcontroller.CreateRateStream();
			Map<id,RecordType> idmap = testcontroller.RenewalsAndModMapByIdKey;
			idmap =  testcontroller.RenewalsAndModMapByIdKeyWithoutAdminRenewal;
			Map<String,RecordType> nameMap =  testcontroller.RenewalsAndModMapByNameKey;
	        
	        test.stopTest();
    }
    
    static testMethod void verifyLoanAppRenewalMethod_CreateRenewalProcess(){
	        String url = utility.getServerUrl() + '/apex/LoanAppRenewal?id=';
	        EB_Account__c acct = setupVerifyLoanAppRenewalMethods();   
	            
	        test.startTest();
	        
	        PageReference pr = utility.testhelper(url + acct.Id + '&t=r' );
	        test.setCurrentPage(pr);
	        ApexPages.StandardController sc = new Apexpages.Standardcontroller(acct);
	        LoanAppRenewalController testcontroller = new LoanAppRenewalController(sc);
	        testcontroller.initialize();
	        testcontroller.EBAccount = acct;
	                 
	        testcontroller.CreateRenewalProcess();              
	        
	        test.stopTest();
    }
    
    static testMethod void verifyLoanAppRenewalMethod_CreateLoanEntityRelationships(){
	        String url = utility.getServerUrl() + '/apex/LoanAppRenewal?id=';
	        EB_Account__c acct = setupVerifyLoanAppRenewalMethods();   
	            
	        test.startTest();
	        
	        PageReference pr = utility.testhelper(url + acct.Id + '&t=r' );
	        test.setCurrentPage(pr);
	        ApexPages.StandardController sc = new Apexpages.Standardcontroller(acct);
	        LoanAppRenewalController testcontroller = new LoanAppRenewalController(sc);
	        testcontroller.initialize();
	        testcontroller.EBAccount = acct;
	        EB_Loan_Packet__c pt = testcontroller.CreateLoanPacket();
	         
	        testcontroller.CreateLoanApplication(pt);                
	        testcontroller.CreateLoanEntityRelationships();              
	        
	        test.stopTest();
    }
    
    static testMethod void verifyLoanAppRenewalMethod_CreateLoanCollateralRelationship(){
	        String url = utility.getServerUrl() + '/apex/LoanAppRenewal?id=';
	        EB_Account__c acct = setupVerifyLoanAppRenewalMethods();   
	            
	        test.startTest();
	        
	        PageReference pr = utility.testhelper(url + acct.Id + '&t=r' );
	        test.setCurrentPage(pr);
	        ApexPages.StandardController sc = new Apexpages.Standardcontroller(acct);
	        LoanAppRenewalController testcontroller = new LoanAppRenewalController(sc);
	        testcontroller.initialize();
	        testcontroller.EBAccount = acct;
	        EB_Loan_Packet__c pt = testcontroller.CreateLoanPacket();
	        
	        testcontroller.CreateLoanApplication(pt);                 
	        testcontroller.CreateLoanCollateralRelationship();              
	         
	        test.stopTest();
    }
    
    static testMethod void verifyLoanAppRenewalMethod_CheckExistingRenewalCount(){
	        String url = utility.getServerUrl() + '/apex/LoanAppRenewal?id=';
	        EB_Account__c acct = setupVerifyLoanAppRenewalMethods();   
	            
	        test.startTest();
	        
	        PageReference pr = utility.testhelper(url + acct.Id + '&t=r' );
	        test.setCurrentPage(pr);
	        ApexPages.StandardController sc = new Apexpages.Standardcontroller(acct);
	        LoanAppRenewalController testcontroller = new LoanAppRenewalController(sc);
	        testcontroller.initialize();
	        testcontroller.EBAccount = acct;
	                 
	        testcontroller.CheckExistingRenewalCount();              
	        
	        test.stopTest();
    }
    
    static testMethod void verifyLoanAppRenewalMethod2(){
    	TestUtilities.createLoanAppStages();
        String url = utility.getServerUrl() + '/apex/LoanAppRenewal?id=';

        EB_Unit__c branch = objectFactory.getUnit('testBranch', 4001);     
                
        EB_Team_Member__c team = objectFactory.getTeamMember('Team1');
    
        Id ClientRecordTypeId = objectFactory.getRecordTypeIdByNameAndObject('Client', 'Account');
                
        Account LeadEntity = objectFactory.getEntity('Test Entity',ClientRecordTypeId, team);
        List<EB_Account__c> accounts = new List<EB_Account__c>();
                
        EB_Account__c acct = new EB_Account__c(Name='123-15',Application__c=15);
        acct.EB_Unit__c = branch.Id;
        acct.Account_Status__c = 'A';
        acct.Primary_Owner_Id__c = LeadEntity.ID;
        insert acct;
            
        EB_Loan_Packet__c  packet = Objectfactory.getLoanPacket(leadEntity);
                    
        EB_Account_Participation__c testp = new EB_Account_Participation__c();
        testp.EB_Account__c = acct.Id;
        testp.RecordTypeId = Utility.recordTypeObject('EB_Account_Participation__c', 'Bought').Id;
        insert testp;
            
        EB_Account_Relationship__c re = new EB_Account_Relationship__c();
        re.Client_Id__c = LeadEntity.Id;
        re.EB_Account_Id__c = acct.Id;
        re.Relationship__c = 'Primary Borrower';
        insert re;
        EB_Account_Participation__c p = new EB_Account_Participation__c();
        p.IsPurchasedparticipation__c = testp.IsPurchasedparticipation__c;
        p.Lead_bank__c = testp.Lead_Bank__c;
        p.EB_Account__c = acct.id;
        p.Name_of_Signer__c = testp.Name_Of_Signer__c;
        p.Participated_Amount__c = testp.Participated_Amount__c;
        p.Participating_Institution__c = testp.Participating_Institution__c;
        p.recordtypeid = testp.RecordTypeId;
        p.Special_Participation_Instructions__c = testp.Special_Participation_Instructions__c;
        p.Title_of_Signer__c = testp.Title_of_Signer__c;
        p.Address__c = testp.Address__c;
        insert p;
            
        EB_Account_Payment_Stream__c s = new EB_Account_Payment_Stream__c();
        s.Amount__c =  100;
        s.Duration__c = 60;
        s.EB_Account__c = acct.Id;
        s.RecordTypeId = Utility.recordTypeObject('EB_Account_Payment_Stream__c','Level Payment').Id;
        s.Stream_Number__c = '1';
        s.Frequency__c = 'Monthly';
        insert s;
            
        PageReference pr = utility.testhelper(url  );
        test.setCurrentPage(pr);
        ApexPages.StandardController sc = new Apexpages.Standardcontroller(acct);
        LoanAppRenewalController testcontroller = new LoanAppRenewalController(sc);
        testcontroller.initialize();
        testcontroller.EBAccount = acct;
        EB_Loan_Packet__c pt = testcontroller.CreateLoanPacket();
              
        testcontroller.CreateLoanApplication(pt);
        testcontroller.CreateRenewalProcess();
        String surl = utility.getServerUrl() + '/' ;
        List<EB_Collateral__c> cols =  testcontroller.getCollaterals();
        List<EB_Account_Relationship__c> rels = testcontroller.getAccountRelationships();
        List<Account> accts = testcontroller.getPledgors(rels);
                       
        testcontroller.CreateLoanEntityRelationships();
        testcontroller.CreateLoanCollateralRelationship();
        testcontroller.CreateRateStream();     
     }
}