public class AccountActionIncrementFieldDataProvider extends DataProvider implements AccountActionIncrementFieldController.IAccountActionIncrementFieldDataProvider {
    public EB_Loan_Action__c getAccountAction (String curId){
    	return [
            SELECT 
            	Id
            	,Action_Status_Update__c
            	,On_Hold__c
            	,Complete_No_Further_Action_Counter__c
            	,Next_Step_Counter__c 
            FROM 
            	EB_Loan_Action__c 
            WHERE 
            	Id =:curId
        ]; 
    }
}