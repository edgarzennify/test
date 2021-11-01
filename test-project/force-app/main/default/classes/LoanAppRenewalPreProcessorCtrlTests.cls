@IsTest
public  class LoanAppRenewalPreProcessorCtrlTests {
     
	 public static  testMethod void verifyLoanAppRenewalPreProcessorPageReference(){
          	 String url = Utility.getServerUrl() + '/apex/LoanAppRenewalPreProcessor?id=';
                
             Account prospect = ObjectFactory.getValidEntity('testEntity');
             EB_Account__c ebAccount = ObjectFactory.getEBAccount('TestTitle', '1234-15',prospect);
             ebAccount.Primary_Owner_Id__c =  prospect.Id;        
    		 EB_Account_Relationship__c ebAccountRel = new EB_Account_Relationship__c();
    		 ebAccountRel.Client_Id__c = prospect.Id;
    		 ebAccountRel.EB_Account_Id__c = ebAccount.Id;
    		 insert ebAccountRel;
        	 User user1 = ObjectFactory.getUser('test1', 'user98', 'tuser98@enterprisebank.sfdc.test', true);       	 
        	 EB_Team_Member__c  teamMember = ObjectFactory.getTeamMember('testTeamMemeber');
        	 teamMember.User__c = user1.Id;
        	 teamMember.Officer_Code__c = 'tuser1';
        	 update teamMember;                   
             EB_Loan_Packet__c packet = new EB_Loan_Packet__c(
                                                                Name = 'Test Packet',
                                                                Lead_Entity__c = prospect.Id,
                                                                Loan_Coordinator__c = teammember.Id,
                                                                Actual_Approval_Path__c = '2 Signatures'
                                                              );
             insert packet; 
 			 PageReference pr = utility.testhelper(url + ebAccount.Id + '&t=r');
             test.setCurrentPage(pr);
             ApexPages.StandardController sc = new Apexpages.Standardcontroller(ebAccount);
             
             LoanAppRenewalPreProcessorController sut = new LoanAppRenewalPreProcessorController(sc);
             sut.selectedEditId = packet.id;
             PageReference p = sut.NewPacket();
             p = sut.AutoForward();
             p = sut.SelectPacket();
             
             system.assertEquals(ebAccount.Id, sut.EbAccountId);
  	}

   	public static void verifyLoanAppRenewalPreProcessorModPageReference(){
             String url = Utility.getServerUrl() + '/apex/LoanAppRenewalPreProcessor?id=';
                
             Account prospect = ObjectFactory.getValidEntity('testEntity');
             EB_Account__c ebAccount = ObjectFactory.getEBAccount('TestTitle', '1234-15',prospect);
             ebAccount.Primary_Owner_Id__c =  prospect.Id;        
    		 EB_Account_Relationship__c ebAccountRel = new EB_Account_Relationship__c();
    		 ebAccountRel.Client_Id__c = prospect.Id;
    		 ebAccountRel.EB_Account_Id__c = ebAccount.Id;
    		 insert ebAccountRel;
        	 User user1 = ObjectFactory.getUser('test1', 'user97', 'tuser97@enterprisebank.sfdc.test', true);       	 
        	 EB_Team_Member__c  teamMember = ObjectFactory.getTeamMember('testTeamMemeber');
        	 teamMember.User__c = user1.Id;
        	 teamMember.Officer_Code__c = 'tuser1';
        	 update teamMember;   
             EB_Loan_Packet__c packet = new EB_Loan_Packet__c(
                                                                    Name = 'Test Packet',
                                                                    Lead_Entity__c = prospect.Id,
                                                                    Loan_Coordinator__c = teammember.Id,
                                                                    Actual_Approval_Path__c = '2 Signatures'
                                                              );
             insert packet;
 			 PageReference pr = utility.testhelper(url + ebAccount.Id + '&t=m');
             test.setCurrentPage(pr);
             ApexPages.StandardController sc = new Apexpages.Standardcontroller(ebAccount);
             LoanAppRenewalPreProcessorController sut = new LoanAppRenewalPreProcessorController(sc);
             sut.selectedEditId = packet.id;
             PageReference p = sut.NewPacket();
             p = sut.SelectPacket();
             sut.searchParam = 'packet';
             p = sut.NewPacket();
             p = sut.SelectPacket();
             
             system.assertEquals(ebAccount.Id, sut.EbAccountId);
       }

       public static testMethod void verifyLoanAppRenewalPreProcessorMethod(){
             String url = Utility.getServerUrl() + '/apex/LoanAppRenewalPreProcessor?id=';
             
             Account prospect = ObjectFactory.getValidEntity('testEntity');
             EB_Account__c ebAccount = ObjectFactory.getEBAccount('TestTitle', '1234-15',prospect);
             ebAccount.Primary_Owner_Id__c =  prospect.Id;        
             EB_Account_Relationship__c ebAccountRel = new EB_Account_Relationship__c();
    		 ebAccountRel.Client_Id__c = prospect.Id;
    		 ebAccountRel.EB_Account_Id__c = ebAccount.Id;
    		 insert ebAccountRel;
        	 User user1 = ObjectFactory.getUser('test1', 'user96', 'tuser96@enterprisebank.sfdc.test', true);       	 
        	 EB_Team_Member__c  teamMember = ObjectFactory.getTeamMember('testTeamMemeber');
        	 teamMember.User__c = user1.Id;
        	 teamMember.Officer_Code__c = 'tuser1';
        	 update teamMember;
        	    
             EB_Loan_Packet__c packet = new EB_Loan_Packet__c();
             packet.Name = 'Test Packet';
             packet.Lead_Entity__c = prospect.Id;                                          		
             packet.Loan_Coordinator__c =   teammember.Id;                                                 
             packet.Actual_Approval_Path__c = '2 Signatures';                                                   
             insert packet;
             
             PageReference pr = utility.testhelper(url + ebAccount.Id + '&t=r');
             test.setCurrentPage(pr);
             ApexPages.StandardController sc = new Apexpages.Standardcontroller(ebAccount);
             LoanAppRenewalPreProcessorController sut = new LoanAppRenewalPreProcessorController(sc);
             sut.selectedEditId = packet.id;
             sut.initialize(); 
             List<EB_Loan_Packet__c> ps= sut.activePackets;
             List<SelectOption> option = sut.getPackets();
             RecordType rec = sut.getRecordTypeNameorId(null, 'New', true);
             rec = sut.getRecordTypeNameorId(null, 'New', false); 
             String s = utility.getServerUrl();
             sut.CreatePacketListWithoutSearch(); 
               
             sut.CreatePacketListWithSearch('renewal');
             id ids = sut.GetArchivedPacketId();
             List<EB_Loan_Packet__c> getActivePackets = sut.getActivePackets();
             sut.minModMap = null;
             Map<id,RecordType> mod = sut.minModMap;
             sut.ArchivedPackedId = null;
             ids = sut.GetArchivedPacketId();
             List<SelectOption> getModRecordTypes = sut.getModRecordTypes();
             PageReference pp = utility.testhelper('http://www.google.com');
             
             system.assertEquals(ebAccount.Id, sut.EbAccountId);
                                  
          }
}