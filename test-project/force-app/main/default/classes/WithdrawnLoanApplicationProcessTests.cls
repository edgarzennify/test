@IsTest
public class WithdrawnLoanApplicationProcessTests {

     public static testMethod void verifyWithdrawLoanApplicationProcessClass(){
     	
     	Account entityClient =  ObjectFactory.getValidEntity('testAccountClient');
     	entityClient.RecordTypeId = Utility.recordTypeObject('Account', 'Client').Id;
     	update entityClient; 
         
        EB_Account__c ebAccount = ObjectFactory.getEBAccountWithoutInsert('testAccount','1234',entityClient);
     	//acct.Application__c = 35;
        ebAccount.Primary_Owner_Id__c = entityClient.Id;
        insert ebAccount;
        TestUtilities.createLoanAppStages();
	    EB_Loan_App_Stage__c stage = TestUtilities.getStageByName('Booking Complete');
     	Id newRecordTypeId = utility.RecordTypeObject('EB_Loan_Application__c','New').Id;
    	Id renewalRecordTypeId = utility.RecordTypeObject('EB_Loan_Application__c','Renewal').Id;
    	EB_Loan_Packet__c thisPacket = packet;
    	 
    	
    	test.startTest();
    	// confirm that the correct loan fee was added (assert), using the shared commercial loan app
    	List<EB_Loan_Fee__c> testNewLoanFeeList = [SELECT Id, Type_of_Fee__c, Fee_Amount__c FROM EB_Loan_Fee__c WHERE Loan_Application__c =: newCommercialLoanApp.id limit 1];
    	System.assertEquals(1,testNewLoanFeeList.size());    	
    	System.assertEquals('Loan',testNewLoanFeeList[0].Type_of_Fee__c);
    	System.assertEquals(250,testNewLoanFeeList[0].Fee_Amount__c);
	    			
	    // create a "new" consumer loan app
	    EB_Loan_Application__c new_LoanApp = ObjectFactory.getLoanApplication(packet, null, '12345678','No');
    	System.assertEquals(newRecordTypeId,new_LoanApp.RecordTypeId);
    	
    	WithdrawLoanApplicationProcess withdrawApp = new WithdrawLoanApplicationProcess();
    	withdrawApp.withdraw(new_LoanApp.Id);
    	WithdrawLoanApplicationProcess.updateApp(new_LoanApp);
    	boolean b = WithdrawLoanApplicationProcess.IsAppWithdrawn(new_LoanApp);
    	WithdrawLoanApplicationProcess withdrawApp2 = new WithdrawLoanApplicationProcess();
    	withdrawApp2.withdraw(null);
    	 
     	
     }
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
    			leadEntity = ObjectFactory.getEntity('Jon Doe', ClientRecordTypeId, teamRM);
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
    static EB_Loan_Application__c newCommercialLoanApp{
    	get{
    		if(newCommercialLoanApp==null){
    			newCommercialLoanApp = ObjectFactory.getLoanApplication(packet,null,'1234567','Yes');
    		}
    		return newCommercialLoanApp;
    	}
    	set;
    }       
}