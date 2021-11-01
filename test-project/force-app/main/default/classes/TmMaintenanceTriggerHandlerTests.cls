@IsTest
private class TmMaintenanceTriggerHandlerTests {

    private static final TmMaintenanceTriggerHandler sut;
    private static final MockOfITmMaintenanceSvcRequestBuilder  mockBuilder;
    private static final Mock.OfIJson mockJson;
    private static Mock.ofHttpCalloutMock m_mockCallout;

    static {
        HttpResponse response;
        response = new HttpResponse();
        response.setBody('testcallback-test');
        response.setStatusCode(200);
        response.setStatus('OK');
        m_mockCallout = new Mock.ofHttpCalloutMock();
        m_mockCallout.Setup('respond',  ApexMoq.Arguments.HAVE_ANY_VALUE).returns(response);
        mockBuilder = new MockOfITmMaintenanceSvcRequestBuilder();
        mockJson = new Mock.OfIJson();
        sut = new TmMaintenanceTriggerHandler(mockBuilder, mockJson);
    }

    @IsTest
    static void it_should_call_the_tm_boarding_service_to_post_maintenance_updates() {
        Id tmmId = ObjectFactory.getFakeId(TM_Maintenance__c.SObjectType, '1');
        String sync_Key = 'key';
        TM_Maintenance__c tmmOld = new TM_Maintenance__c();
        tmmOld.Id = tmmId;
        tmmOld.Status__c = 'x';
        tmmOld.Sync_Key__c = sync_Key; 

        List<TM_Maintenance__c> oldSos = new List<TM_Maintenance__c>{tmmOld};
        TM_Maintenance__c tmmNew = new TM_Maintenance__c();
        tmmNew.Id = tmmId;
        tmmNew.Status__c = 'y';
        tmmNew.Sync_Key__c = sync_Key;
        
        Map<Id, TM_Maintenance__c> newSosMap = new Map<Id, TM_Maintenance__c>{tmmId => tmmNew};
        TmBoardingServiceProxy.TmMaintenanceStatusUpdateRequest req = new TmBoardingServiceProxy.TmMaintenanceStatusUpdateRequest();
        req.Status = 'y';
        req.SalesforceId = 'z';
        req.SyncKey = 'key';
        List<TmBoardingServiceProxy.TmMaintenanceStatusUpdateRequest> request = new List<TmBoardingServiceProxy.TmMaintenanceStatusUpdateRequest>{req};
        IJson j = new JsonWrapper();
        String json = j.serialize(request);
        mockBuilder.setup('buildStatusUpdateRequest', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(request);
        mockJson.setup('serialize', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(json);

        Test.setMock(HttpCalloutMock.class, m_mockCallout);        
        Test.startTest();
        sut.bulkAfterUpdate(oldSos, newSosMap);
        Test.stopTest();

        m_mockCallout.verify('respond',  ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
        List<Object> arguments = (List<Object>)m_mockCallout.getArgumentsFromCall('respond');
        HttpRequest calledRequest = (HttpRequest)arguments[0];
        System.assertEquals('POST', calledRequest.getMethod()); 
    }

    @IsTest
    static void it_should_run_the_trigger_for_intigration_test() {
        TM_Maintenance__c m = new TM_Maintenance__c();
        insert m;
        m.Status__c = 'InProcess';
        update m;
    }

    private class MockOfITmMaintenanceSvcRequestBuilder extends ApexMoq implements TmMaintenanceSvcRequestBuilder.ITmMaintenanceSvcRequestBuilder {
        public List<TmBoardingServiceProxy.TmMaintenanceStatusUpdateRequest> buildStatusUpdateRequest(List<TM_Maintenance__c> oldSObjs, Map<Id, TM_Maintenance__c> newSObjs ){
           return (List<TmBoardingServiceProxy.TmMaintenanceStatusUpdateRequest>)handleMethodInvocation('buildStatusUpdateRequest', new List<OBject>{oldSObjs, newSObjs});
        }
    }
}