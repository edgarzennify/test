@IsTest
private class TmMaintenanceSvcRequestBuilderTests {
    private static final TmMaintenanceSvcRequestBuilder sut;
    static{
        sut = new TmMaintenanceSvcRequestBuilder();
    }

    private static testMethod void it_should_build_the_request_from_objs(){
        Id tmmId = ObjectFactory.getFakeId(TM_Maintenance__c.SObjectType, '1');
        String sync_Key = 'key';
        TM_Maintenance__c tmmOld = new TM_Maintenance__c();
        tmmOld.Id = tmmId;
        tmmOld.Status__c = 'x';
        tmmOld.Sync_Key__c = sync_Key;

        List<TM_Maintenance__c> tmmsOld = new List<TM_Maintenance__c>{tmmOld};
         TM_Maintenance__c tmmNew = new TM_Maintenance__c();
        tmmNew.Id = tmmId;
        tmmNew.Status__c = 'y';
        tmmNew.Sync_Key__c = sync_Key;
        Map<Id, TM_Maintenance__c> tmmMapNew = new Map<Id, TM_Maintenance__c>{tmmId => tmmNew};

        List<TmBoardingServiceProxy.TmMaintenanceStatusUpdateRequest> result = sut.buildStatusUpdateRequest(tmmsOld, tmmMapNew);

        System.assertEquals(1, result.size());
        System.assertEquals('y', result[0].Status);
    }
}