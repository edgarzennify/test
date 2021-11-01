@isTest
public class TaskCollectionTaskHandlerTests {
    private static TaskTriggerHandler.ITaskCollectionTaskHandler sut;
    private static MockOfTaskDataProvider mockDataProv;
    static{
        mockDataProv = new MockOfTaskDataProvider();
        sut = new TaskCollectionTaskHandler(mockDataProv);
    }
    
    private static testMethod void it_should_code_cover_the_constructor(){
        TaskTriggerHandler.ITaskCollectionTaskHandler tcth = new TaskCollectionTaskHandler();
    }
    private static testMethod void it_should_update_the_collection_task_fields_if_collection_task(){
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        loan.Id = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        Task t = new Task();
        t.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Collection Task').getRecordTypeId();
        t.WhatId = loan.Id;
        t.Task_Date__c = Date.today();
        List<SObject> sos = new List<SObject>{t};
        Map<Id, SObject> newSos = new Map<Id, SObject>();
        newSos.put(t.Id, t);
        sut.handleCollectionTasks(sos, newSos);
        system.assertEquals(t.Loan__c, t.WhatId);
        system.assertEquals(t.ActivityDate, t.Task_Date__c);
    }
    private static testMethod void it_should_not_update_the_loan_field_if_not_related_to_loan(){
        Account acct = new Account();
        acct.Id = ObjectFactory.getFakeId(Account.SObjectType, '1');
        Task t = new Task();
        t.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Collection Task').getRecordTypeId();
        t.WhatId = acct.Id;
        t.Task_Date__c = Date.today();
        List<SObject> sos = new List<SObject>{t};
        Map<Id, SObject> newSos = new Map<Id, SObject>();
        newSos.put(t.Id, t);
        sut.handleCollectionTasks(sos, newSos);
        system.assertEquals(t.Loan__c, null);
    }
    private static testMethod void it_should_not_update_the_collection_task_fields_if_not_collection_task(){
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        loan.Id = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        Task t = new Task();
        t.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Task').getRecordTypeId();
        t.WhatId = loan.Id;
        t.Task_Date__c = Date.today();
        List<SObject> sos = new List<SObject>{t};
        Map<Id, SObject> newSos = new Map<Id, SObject>();
        newSos.put(t.Id, t);
        sut.handleCollectionTasks(sos, newSos);
        system.assertNotEquals(t.Loan__c, t.WhatId);
        system.assertNotEquals(t.ActivityDate, t.Task_Date__c);
    }
    private static testMethod void it_should_create_a_follow_up_task_for_collection_task_if_follow_up_date_is_not_null_when_task_is_inserted(){
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        loan.Id = ObjectFactory.getFakeId(LLC_BI__Loan__C.SObjectType, '1');
        User u = ObjectFactory.getUser();
        Task t = new Task();
        t.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Collection Task').getRecordTypeId();
        t.Follow_Up_Date__c = Date.today() + 7;
        t.OwnerId = u.Id;
        t.WhatId = loan.Id;
        t.Loan__c = loan.Id;
        t.Type = 'Phone Call';
        t.Description = 'This is a test';
        t.Id = ObjectFactory.getFakeId(Task.SObjectType, '1');
        List<SObject> sos = new List<SObject>{t};
        Task followUpTask = new Task();
        followUpTask.OwnerId = u.Id;
        followUpTask.Task_Date__c = t.Follow_Up_Date__c;
        followUpTask.ActivityDate = t.Follow_Up_Date__c;
        followUpTask.WhatId = loan.Id;
        followUpTask.Loan__c = loan.Id;
        followUpTask.Type = 'Phone Call';
        followUpTask.Subject = 'Follow up for ' + t.Entity_Name__c;
        followUpTask.Description = 'This is a test';
        followUpTask.Status = 'Not Started';
        followUpTask.Follow_Up__c = 'RMG Follow Up';
        List<Task> followUpTasks = new List<Task>{followUpTask};
        sut.handleCollectionTasks(sos, new Map<Id, SObject>());
        mockDataProv.verify('save', new List<Object>{followUpTasks}, Times.Once);
    }
    private static testMethod void it_should_create_a_follow_up_task_for_collection_task_when_task_with_blank_follow_up_is_modified_to_have_value(){
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        loan.Id = ObjectFactory.getFakeId(LLC_BI__Loan__C.SObjectType, '1');
        User u = ObjectFactory.getUser();
        Id collectionTaskRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Collection Task').getRecordTypeId();
        Task oldTask = new Task();
        oldTask.RecordTypeId = collectionTaskRecordTypeId;
        oldTask.OwnerId = u.Id;
        oldTask.WhatId = loan.Id;
        oldTask.Loan__c = loan.Id;
        oldTask.Type = 'Phone Call';
        oldTask.Description = 'This is a test';
        Task newTask = new Task();
        newTask.RecordTypeId = collectionTaskRecordTypeId;
        newTask.Follow_Up_Date__c = Date.today() + 7;
        newTask.OwnerId = u.Id;
        newTask.WhatId = loan.Id;
        newTask.Loan__c = loan.Id;
        newTask.Type = 'Phone Call';
        newTask.Description = 'This is a test';
        List<SObject> sos = new List<SObject>{oldTask};
        Task followUpTask = new Task();
        followUpTask.OwnerId = u.Id;
        followUpTask.Task_Date__c = newTask.Follow_Up_Date__c;
        followUpTask.ActivityDate = newTask.Follow_Up_Date__c;
        followUpTask.WhatId = loan.Id;
        followUpTask.Loan__c = loan.Id;
        followUpTask.Type = 'Phone Call';
        followUpTask.Subject = 'Follow up for ' + newTask.Entity_Name__c;
        followUpTask.Description = 'This is a test';
        followUpTask.Status = 'Not Started';
        followUpTask.Follow_Up__c = 'RMG Follow Up';
        List<Task> followUpTasks = new List<Task>{followUpTask};
        Map<Id, SObject> newSos = new Map<Id, SObject>();
        newSos.put(newTask.Id, newTask);
        sut.handleCollectionTasks(sos, newSos);
        mockDataProv.verify('save', new List<Object>{followUpTasks}, Times.Once);
    }
    
    
    public class MockOfTaskDataProvider extends ApexMoq implements TaskTriggerHandler.ITaskDataProvider{
        public void save(List<SObject> objs){
            handleMethodInvocation('save', new List<Object>{objs});
        }
    }

}