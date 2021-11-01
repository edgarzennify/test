//
// Do not modify code below, trigger should be standard call to trigger factory where processing is managed
// and appropriate handler called based on object type.
//
// ** TO DO List (Remove each line as step is completed.)
//   1) Create appropriate classes to handle processing trigger events for this object type
//         Modification_Request__cTriggerHandler                (based on TriggerHandlerTemplate)
//         Modification_Request__cTriggerHandlerTests           (based on TriggerHandlerTestsTemplate)
//         Modification_Request__cs                             (based on ObjectTemplate, if not already created)
//         Modification_Request__cTests                         (based on ObjectTestsTemplate, if not already created)
//         Modification_Request__cDataProvider                  (based on DataProviderTemplate, if not already created)
//         Modification_Request__cDataProviderTests             (based on DataProviderTestsTemplate, if not already created)
//   2) Add Entry to TriggerFactory to handle this object
//
trigger ModificationRequestTrigger on Modification_Request__c (after delete, after insert, after update, before delete, before insert, before update) {
    TriggerFactory.createHandler(Modification_Request__c.sObjectType);
}