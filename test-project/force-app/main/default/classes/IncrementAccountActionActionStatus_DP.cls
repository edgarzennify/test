public class IncrementAccountActionActionStatus_DP extends DataProvider implements IncrementAccountActionActionStatusUpdate.IupdateActionStatusDataProvider{
    Public EB_Loan_Action__c getAccountAction (String curId){
    	return [Select id, Action_Status_Update__c, On_Hold__c, Complete_No_Further_Action_Counter__c, Next_Step_Counter__c from EB_Loan_Action__c Where id =:curId]; 
    }
}