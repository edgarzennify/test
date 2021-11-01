@IsTest
public class AgreementStageActionMgr_DataprovTests{
 
  static testmethod void it_should_get_the_stage_controller_by_agreement_Id(){
      Agreement__c testAgreement = new Agreement__c();
      EB_Stage_Action_Controller__c  testStageActionController = new EB_Stage_Action_Controller__c();
      EB_Loan_App_Stage__c testStage = new   EB_Loan_App_Stage__c();
     
      testStage.Loan_App_Stage_Action_Controller__c = testStageActionController.Id;
      testAgreement.Stage__c = testStage.Id;
     }
}