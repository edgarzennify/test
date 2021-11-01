public class ObjectActionLogSvcDataProvider extends DataProvider implements IDataProvider {
    public interface IDataProvider extends DataProvider.IDataProvider{
        List<Object_Action_Log__c> get(String recordId, String actionType);
		List<Object_Action_Log__c> get(List<String> recordIds, String actionType);
    }
    
    public List<Object_Action_Log__c> get(String recordId, String actionType){
        return [
        	SELECT
        		Id
        		,Name
        		,Object_API_Name__c
        		,Object_Id__c
        		,Action__c
        		,Cycle_Time_In_Business_Days__c
        		,Cycle_Time_In_Business_Days_Hours__c
        		,Cycle_Time_In_Calendar_Days__c
        		,Cycle_Time_In_Calendar_Days_Hours__c
        		,Action_Date_Time__c
        		,CreatedBy.Id
        		,CreatedBy.Name
                ,CreatedDate
        	FROM
        		Object_Action_Log__c
        	WHERE
				Object_Id__c =: recordId
				AND Action_Type__c =: actionType
            ORDER BY
                Action_Date_Time__c DESC
                ,CreatedDate DESC
        ];
    }

	public List<Object_Action_Log__c> get(List<String> recordIds, String actionType){
        return [
        	SELECT
        		Id
        		,Name
        		,Object_API_Name__c
        		,Object_Id__c
        		,Action__c
        		,Cycle_Time_In_Business_Days__c
        		,Cycle_Time_In_Business_Days_Hours__c
        		,Cycle_Time_In_Calendar_Days__c
        		,Cycle_Time_In_Calendar_Days_Hours__c
        		,Action_Date_Time__c
        		,CreatedBy.Id
        		,CreatedBy.Name
                ,CreatedDate
        	FROM
        		Object_Action_Log__c
        	WHERE
        		Object_Id__c =: recordIds
				AND Action_Type__c =: actionType
            ORDER BY
                Action_Date_Time__c DESC
                ,CreatedDate DESC
        ];
    }
}