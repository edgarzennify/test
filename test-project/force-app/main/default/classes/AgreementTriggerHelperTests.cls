@isTest
private class AgreementTriggerHelperTests {
	private static Map<String,EB_Loan_App_Stage__c> stageMap{
        get{
            if(stageMap == null){
                stageMap = new Map<String,EB_Loan_App_Stage__c>();
                for(EB_Loan_App_Stage__c stgs : [SELECT Id, Name, Stage_Selected_Email_Notifications__c FROM EB_Loan_App_Stage__c  ORDER BY name]){
                    stageMap.put(stgs.Name , stgs);
                }
            }
            return stageMap;
        }
        set;
    }
    
    public static testMethod void testAgreementTriggerHelper(){
    	TestUtilities.createLoanAppStages();
        //create an Agreement
        Agreement__c agmt = objectfactory.getAgreement('Prospective', 'Borrower Name_1', 'TEST TEST');   
        //create an Entity
        EB_Unit__c branch = objectFactory.getUnit('testBranch', 4001);
        EB_Team_Member__c team = objectFactory.getTeamMember('Team1');
        Id ClientRecordTypeId = objectFactory.getRecordTypeIdByNameAndObject('Client', 'Account');
        Account entity = objectFactory.getEntity('Borrower Name_1',ClientRecordTypeId, team);
        
        agmt.Stage__c = stageMap.values()[0].Id;
        agmt.Approved_by_SFDC_Approval_Process__c = true;
        update agmt;
        agmt.Stage__c = stageMap.values()[1].Id;
        agmt.Stage_Explanation__c = 'abc';
        agmt.Rejected_by_SFDC_Approval_Process__c = true;
        update agmt;
        agmt.Set_App_to_New__c = true;
        update agmt;
        agmt.Stage__c = stageMap.get('Documentation Complete').Id;
        update agmt;
        delete agmt;
    }
    
    private static testMethod void it_should_set_the_stage_to_backofficeStartStage_on_backofficeModification_approval(){
        TestUtilities.createLoanAppStages();
        Agreement__c testAgreement = new Agreement__c();
        insert testAgreement;
        
        testAgreement.Back_Office_Start_Stage__c = stageMap.get('Approved').Id;
        testAgreement.Back_Office_Start_Path__c = '2 Signature';
        update testAgreement;
        
        //mimic approval process
        testAgreement.Stage__c = TestUtilities.getStageByName('Back Office Modification - Pending Approval').Id;
        testAgreement.Approved_by_SFDC_Approval_Process__c = true;
        update testAgreement;

        Agreement__c requeryTestAgreement = [SELECT Stage__c, Actual_Approval_Process__c, Back_Office_Start_Stage__c, Back_Office_Start_Path__c FROM Agreement__c WHERE Id =: testAgreement.Id];
        system.assertEquals(null, requeryTestAgreement.Back_Office_Start_Stage__c);
        system.assertEquals(null, requeryTestAgreement.Back_Office_Start_Path__c);
        system.assertEquals(stageMap.get('Approved').Id, requeryTestAgreement.Stage__c);
        system.assertEquals('2 Signature', requeryTestAgreement.Actual_Approval_Process__c);
    }
}