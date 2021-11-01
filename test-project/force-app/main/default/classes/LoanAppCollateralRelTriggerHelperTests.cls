@isTest
public with sharing class LoanAppCollateralRelTriggerHelperTests {
	public static void verifyLoanStageTrigger(){
		EB_Unit__c branch = objectFactory.getUnit('testBranch', 4001);	
		EB_Team_Member__c team = objectFactory.getTeamMember('Team1');
		Integer numEntities = 1;
	    Integer numCollateral = 50;
	    Id ClientRecordTypeId = objectFactory.getRecordTypeIdByNameAndObject('Client', 'Account');
     	Account LeadEntity = objectFactory.getEntity('Test Entity',ClientRecordTypeId, team);
        EB_Account__c ebaccount = ObjectFactory.getEBAccount('Account Title', '11120300-15', leadEntity);
	        ebaccount.EB_Unit__c =branch.Id; 
	        ebaccount.Account_Status__c = 'A';
	        ebaccount.Application__c = 15;
	        ebaccount.current_balance__c = 9000;
	        ebaccount.Unadvanced_Loan_Amount__c = 10000;
        update ebaccount;

        EB_Loan_Packet__c packet = ObjectFactory.getLoanPacket(LeadEntity);
        TestUtilities.CreateLoanAppStages();
        EB_Loan_Application__c app = ObjectFactory.getLoanApplication(packet, ebAccount, '1234');
		system.assertNotEquals(null, app.id);
		    app.Account_Number_Assigned__c = '';
		    app.Business_Purpose__c = 'Yes';
	     update app; 

	     Collateral_Code__c code = objectfactory.getCollateralCode('Testccode', '999');
         EB_Collateral__c collateral = objectfactory.getCollateral('TestCollateral', code, true);
    	 Id rectypeidForLoanAppCollateral = objectfactory.getRecordTypeIdByNameAndObject('All', 'EB_Loan_App_Collateral_Relationship__c');
    	 system.debug('###' + rectypeidForLoanAppCollateral);
    	 EB_Loan_App_Collateral_Relationship__c rel = objectfactory.relateCollateralToLoanAppreturnObj(collateral, app, rectypeidForLoanAppCollateral);
	     system.assertNotEquals(rel , null);
	     rel.Purpose_of_Collateral__c = 'Primary';
	     update rel;
		
		
	}
}