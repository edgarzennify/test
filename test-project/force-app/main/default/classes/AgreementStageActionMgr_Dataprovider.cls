public class AgreementStageActionMgr_Dataprovider implements AgreementStageActionManagerCntr.IDataProvider{
     
    public EB_Stage_Action_Controller__c getStageControllerByAgreementId(Id agreementId){
        Agreement__c agmt = [SELECT Id, Stage__c, Stage__r.Loan_App_Stage_Action_Controller__r.Visual_Force_Action_Page__c  FROM Agreement__c WHERE Id =: agreementId limit 1];
        return agmt.stage__r.Loan_App_Stage_Action_Controller__r;
    }
 }