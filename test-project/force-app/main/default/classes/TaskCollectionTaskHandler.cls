public class TaskCollectionTaskHandler implements TaskTriggerHandler.ITaskCollectionTaskHandler{
    
    public TaskCollectionTaskHandler(){
        m_dataProv = new TaskDataProvider();
    }
    public TaskCollectionTaskHandler(TaskTriggerHandler.ITaskDataProvider dataProv){
        m_dataProv = dataProv;
    }
    
    public void handleCollectionTasks(List<SObject> sos, Map<Id, SObject> newSos){
        updateCollectionTaskFields(sos, newSos);
        handleFollowUpTaskCreation(sos, newSos);
    }
    
    private final String COLLECTION_RECORD_TYPE_NAME = 'Collection Task';
    private Map<String, String> objectIds;
    private Map<String, Schema.SObjectType> globalDescribe;
    Id collectionTaskRecordTypeId;
    private static TaskTriggerHandler.ITaskDataProvider m_dataProv;
    
    private void updateCollectionTaskFields(List<SObject>sos, Map<Id, SObject> newSos){
        collectionTaskRecordTypeId = getcollectionTaskRecordTypeId();        
        for(Task t : (List<Task>)sos){
            if(newSos != null && newSos.keySet().size() > 0){
                t = (Task)newSos.get(t.Id);
            }
            if(collectionTaskBeforeInsert(t) && t.Follow_Up__c != 'RMG Follow Up'){
                
                if(relatedToIsLoan(t)){
                    t.Loan__c = t.WhatId;
                }
                if(activityDateNeedsUpdate(t)){
                    t.ActivityDate = t.Task_Date__c;
                }  
            }
            
        }
    }
    private Boolean relatedToIsLoan(Task t){
        if(globalDescribe == null){
            globalDescribe = Schema.getGlobalDescribe();
        }
        if(objectIds == null){
            objectIds = new Map<String, String>();
            for(String s : globalDescribe.keySet()){
                objectIds.put(s, globalDescribe.get(s).getDescribe().getKeyPrefix());
            }
        }
        if(t.WhatId != null && String.valueOf(t.WhatId).left(3) == objectIds.get('llc_bi__loan__c')){
            return true;
        }
        return false;
    }
    private Boolean activityDateNeedsUpdate(Task t){
        return t.Task_Date__c != null && t.Task_Date__c != t.ActivityDate; 
    }
    private void handleFollowUpTaskCreation(List<SObject>sos, Map<Id, SObject> newSos){
        List<SObject> objectsToInsert = new List<SObject>();
        Task oldTask;
        collectionTaskRecordTypeId = getCollectionTaskRecordTypeId();
        for(Task t : (List<Task>)sos){
            if(newSos != null && newSos.keySet().size() > 0){
                oldTask = t;
                t = (Task)newSos.get(t.Id);
            }
            if(followUpTaskRequired(oldTask, t)){
                objectsToInsert.add(buildFollowUpTask(t));
            }
        }
        if(objectsToInsert != null && objectsToInsert.size() > 0){
            m_dataProv.save(objectsToInsert);
        }
    }
    private Boolean followUpTaskRequired(Task oldTask, Task t){
        if(oldTask == null && t.Follow_Up_Date__c != null && t.RecordTypeId == collectionTaskRecordTypeId && t.Id != null){
            return true;
        }else if(oldTask != null 
                 && oldTask.Follow_Up_Date__c == null 
                 && t.Follow_Up_Date__c != null 
                 && t.RecordTypeId == collectionTaskRecordTypeId){
            return true;
        }
        return false;
    }
    private SObject buildFollowUpTask(Task t){
        Task returnTask = new Task();
        returnTask.OwnerId = t.OwnerId;
        returnTask.Task_Date__c = t.Follow_Up_Date__c;
        returnTask.ActivityDate = t.Follow_Up_Date__c;
        returnTask.WhatId = t.WhatId;
        returnTask.Loan__c = t.Loan__c;
        returnTask.Type = t.Type;
        returnTask.Subject = 'Follow up for ' + t.Entity_Name__c;
        returnTask.Description = t.Description;
        returnTask.Status = 'Not Started';
        returnTask.Follow_Up__c = 'RMG Follow Up';
        
        return returnTask;
    }
    private ID getCollectionTaskRecordTypeId(){
        if(collectionTaskRecordTypeId == null){
            collectionTaskRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get(COLLECTION_RECORD_TYPE_NAME).getRecordTypeId();
        }
        return collectionTaskRecordTypeId;
    }
    private Boolean collectionTaskBeforeInsert(Task t){
       return t.RecordTypeId == collectionTaskRecordTypeId && t.Id == null;
    }


}