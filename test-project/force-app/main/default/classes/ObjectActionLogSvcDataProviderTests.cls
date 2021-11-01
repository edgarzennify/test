@IsTest
private class ObjectActionLogSvcDataProviderTests {
    private static ObjectActionLogSvcDataProvider sut;
    static {
        sut = new ObjectActionLogSvcDataProvider();
    }
    
    private static testMethod void it_should_get_logs_when_provided_recordId_actionType() {
        String recordId = String.valueOf(Utility.convertid15ToId18(ObjectFactory.getFakeId(Tm_Service_Request__c.SObjectType, '1')));
        String actionType = 'sdgfd';
        Object_Action_Log__c pm = new Object_Action_Log__c();
        pm.Object_Id__c = recordId;
        pm.Action_Type__c = actionType;
        pm.Action_Date_Time__c = System.now();
        insert pm;
        
        List<Object_Action_Log__c> result = sut.get(recordId, actionType);
        
        System.assertEquals(1, result.size());
        Object fieldObj = result[0].Object_API_Name__c;
        fieldObj = result[0].Object_Id__c;
        fieldObj = result[0].Action__c;
        fieldObj = result[0].Action_Date_Time__c;
        fieldObj = result[0].CreatedBy.Id;
        fieldObj = result[0].CreatedBy.Name;
        fieldObj = result[0].Cycle_Time_In_Business_Days__c;
		fieldObj = result[0].Cycle_Time_In_Business_Days_Hours__c;
		fieldObj = result[0].Cycle_Time_In_Calendar_Days__c;
		fieldObj = result[0].Cycle_Time_In_Calendar_Days_Hours__c;
    }

    private static testMethod void it_should_get_logs_by_list_of_record_ids(){
        String actionType = 'sdgfd';
        String recordId = String.valueOf(Utility.convertid15ToId18(ObjectFactory.getFakeId(Tm_Service_Request__c.SObjectType, '1')));
        Object_Action_Log__c pm = new Object_Action_Log__c();
        pm.Object_Id__c = recordId;
        pm.Action_Type__c = actionType;
        pm.Action_Date_Time__c = System.now();
        insert pm;
        List<string> recordIds = new List<string>{recordId};
        
        List<Object_Action_Log__c> result = sut.get(recordIds, actionType);
        
        System.assertEquals(1, result.size());
        Object fieldObj = result[0].Object_API_Name__c;
        fieldObj = result[0].Object_Id__c;
        fieldObj = result[0].Action__c;
        fieldObj = result[0].Action_Date_Time__c;
        fieldObj = result[0].CreatedBy.Id;
        fieldObj = result[0].CreatedBy.Name;
        fieldObj = result[0].Cycle_Time_In_Business_Days__c;
		fieldObj = result[0].Cycle_Time_In_Business_Days_Hours__c;
		fieldObj = result[0].Cycle_Time_In_Calendar_Days__c;
		fieldObj = result[0].Cycle_Time_In_Calendar_Days_Hours__c;
    }
}