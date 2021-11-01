@IsTest
Private class SynchronizationResultsControllerTests{

    private static final SynchronizationResultsController sut;

    static{
        sut = new SynchronizationResultsController();
    }

    private static testMethod void it_should_pass_entity_id_to_the_page_to_get_entity_object()
    {
        Id ClientRecordTypeId = objectFactory.getRecordTypeIdByNameAndObject('Client', 'Account');
        Account testEntity = new Account(Name='Test Entity',RecordTypeId = ClientRecordTypeId);
        testEntity.Synchronization_Batch_Id__c = '333';
        testEntity.SynchronizationDate__c = DateTime.newInstance(2014,1,1);
        insert testEntity;

        PageReference pr = Page.SynchronizationResults;
        test.setCurrentPage(pr);        
        ApexPages.currentPage().getParameters().put('Id', testEntity.Id);

        String result = EncodingUtil.urlDecode(sut.entityJson, 'UTF-8');
        System.assertEquals(true,result.Contains('333'));
        System.assertEquals(true,result.Contains('2014-01-01'));
    }

    private static testMethod void it_should_get_results_by_batch()
    {
        Id ClientRecordTypeId = objectFactory.getRecordTypeIdByNameAndObject('Client', 'Account');
        Account testEntity = new Account(Name='Test Entity',RecordTypeId = ClientRecordTypeId);
        testEntity.Synchronization_Batch_Id__c = '333';
        testEntity.SynchronizationDate__c = DateTime.newInstance(2014,1,1);
        insert testEntity;

        PageReference pr = Page.SynchronizationResults;
        test.setCurrentPage(pr);        
        ApexPages.currentPage().getParameters().put('Id', testEntity.Id);
        String entityString = sut.entityJson;

        String result = SynchronizationResultsController.ResultsByBatch(entityString);
        
        System.assertEquals('',result);
    }

    //private static testMethod void it_should_call_the_get_callout_when_results_by_batch_is_requested()
    //{
    //  String testEntityString = 'test';  //may need json of entity
    //  String result = SynchronizationResultsController.ResultsByBatch(testEntityString);
    //}
}