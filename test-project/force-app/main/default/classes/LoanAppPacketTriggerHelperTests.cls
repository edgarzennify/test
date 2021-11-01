@isTest
public class LoanAppPacketTriggerHelperTests{
	public static testMethod void verifyLoanAppPacketTriggerHelper(){
        EB_Unit__c branch = objectFactory.getUnit('testBranch', 4001);                
        EB_Team_Member__c team = objectFactory.getTeamMember('Team1');

        Id ClientRecordTypeId = objectFactory.getRecordTypeIdByNameAndObject('Client', 'Account');
            
        Account LeadEntity = objectFactory.getEntity('Test Entity',ClientRecordTypeId, team);
        List<EB_Account__c> accounts = new List<EB_Account__c>();
        
        EB_Account__c ebaccount = ObjectFactory.getEBAccount('Account Title', '10120300-15', leadEntity);
        ebaccount.EB_Unit__c = branch.Id;
        ebaccount.Account_Status__c = 'A';
        update ebaccount;
        
        EB_Loan_Packet__c  packet = Objectfactory.getLoanPacket(leadEntity);
        EB_Loan_Application__c app = ObjectFactory.getLoanApplication(packet,ebaccount,'1234');
      
        packet.Name = 'Updated Name';        
    }
    
    public static testMethod void it_should_not_insert_the_record_when_setting_an_override_lender_that_is_not_eligible(){
    	EB_Team_Member__c primaryRM = ObjectFactory.getTeamMember('Primary RM');
    	EB_Team_Member__c lender = ObjectFactory.getTeamMember('Test Lender');
    	RecordType client = Utility.RecordTypeObject('Account', 'Client');
    	Account LeadEntity = ObjectFactory.getEntity('Test Entity', client.Id, primaryRM);
   		EB_Loan_Packet__c packet = Objectfactory.getLoanPacket(leadEntity, false);
   		packet.Override_Lender__c = lender.Id;
   		try{
   			insert packet; 
   		}catch(Exception e){
   			System.Assert(true,'insert failed as expected');
   			return;
   		}
        System.Assert(false,'insert should have failed!'); 		  		
    }
    
    private static testMethod void it_should_insert_the_record_when_setting_an_override_lender_that_is_eligible(){
    	TestUtilities.createAccountTeamRoles();
    	EB_Team_Member__c primaryRM = ObjectFactory.getTeamMember('Primary RM');
        EB_Team_Member__c lender = ObjectFactory.getTeamMember('Test Lender');
        RecordType client = Utility.RecordTypeObject('Account', 'Client');
        Account leadEntity = ObjectFactory.getEntity('Test Entity', client.Id, primaryRM);
        AccountTeamMember teamMember = new AccountTeamMember();
        teamMember.AccountId = leadEntity.Id;
        teamMember.TeamMemberRole = 'Commercial Relationship Manager';
        teamMember.UserId = lender.User__c;
        insert teamMember;
        EB_Loan_Packet__c packet = Objectfactory.getLoanPacket(leadEntity, false);
        packet.Override_Lender__c = lender.Id;
        insert packet;         
        System.Assert(true,'insert successfull');              
    }
}