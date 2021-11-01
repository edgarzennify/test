public class ProductPackageTriggerHandlerDataProvider extends DataProvider implements ProductPackageTriggerHandler.IDataProvider{
	
    public List<LLC_BI__Loan__c> getLoans(Set<Id> packageIds){
        return [
            SELECT
            	Id
                ,LLC_BI__Structure_Hierarchy__c 
            	,LLC_BI__Stage__c
            	,LLC_BI__Product_Package__c
            	,First_Approver__c
            	,Second_Approver__c 
            	,Third_Approver__c 
            	,Originating_Officer__c
            	,Actual_Approval_Path_fx__c
            	,Channel__c
            	,LLC_BI__Status__c
            FROM
            	LLC_BI__Loan__c
            WHERE
            	LLC_BI__Product_Package__c IN: packageIds
        ];
    }
    public List<Approval.ProcessResult> submitRequests(List<Approval.ProcessRequest> objectsToSubmit){
        List<Approval.ProcessResult> results = new List<Approval.ProcessResult>();
        if(objectsToSubmit.size() > 0){
             results = Approval.process(objectsToSubmit);
        }
        return results;
    }
}