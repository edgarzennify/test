@IsTest
private class LoanArchiveHandlerEbCollateralTests {
    
    private final static LoanArchiveHandlerEbCollateral sut;
    private final static LoanArchiveMock.ofIDataProvider mockDataProvider;
    
    static {
        mockDataProvider = new LoanArchiveMock.ofIDataProvider();
        sut = new LoanArchiveHandlerEbCollateral(mockDataProvider);        
    }

    @IsTest
    static void it_should_get_the_eb_collateral_sobject_type() {
        SobjectType result = sut.getSObjectTypeHandled();

        System.assertEquals(LLC_BI__Collateral__c.SObjectType ,result);
    }

    @IsTest
    static void it_should_call_the_data_provider_to_get_collaterals_for_merge() {
        Id ebCollateralId = ObjectFactory.getFakeId(Eb_Collateral__C.SObjectType, '1');
        List<Id> objectIds = new List<Id> {ebCollateralId};

        sut.getSObjectsForMerging(objectIds);

        mockDataProvider.verify('getSObjectsForEbCollateralMerge', new List<Object>{ objectIds }, Times.Once);
    }

    @IsTest
    static void  it_should_build_a_merge_result_from_prospect_and_core_collateral_data() {
        LLC_BI__Collateral_Type__c colType = new LLC_BI__Collateral_Type__c();
        insert colType;
        Collateral_Code__c colCode = new Collateral_Code__c(Collateral_Code_ID__c = '9998');
        insert colCode;
        LLC_BI__Collateral__c prospectObj = new LLC_BI__Collateral__c(LLC_BI__Collateral_Type__c = colType.Id);
        insert prospectObj;
        prospectObj = [SELECT Id, Name, Sync_Key__c FROM LLC_BI__Collateral__c WHERE Id =:prospectObj.Id];
        LLC_BI__Collateral__c coreObj = new LLC_BI__Collateral__c(LLC_BI__Collateral_Type__c = colType.Id, Sync_Key__c = '1234');
        insert coreObj;
        coreObj = [SELECT Id, Name, Sync_Key__c FROM LLC_BI__Collateral__c WHERE Id =:coreObj.Id];
        EB_Collateral__c ebColProspectObj = new EB_Collateral__c( Name = prospectObj.Name,  Collateral_Code__c = colCode.Id);
        insert ebColProspectObj;
        ebColProspectObj = [SELECT Id, Name, Key__c, Status__c FROM EB_Collateral__c WHERE id =:ebColProspectObj.Id];
        EB_Collateral__c ebColCoreObj = new EB_Collateral__c( Name = '1234', key__c = '1234', Collateral_Code__c = colCode.Id);
        insert ebColCoreObj;
        ebColCoreObj = [SELECT Id, Name, Key__c, Status__c FROM EB_Collateral__c WHERE id =:ebColCoreObj.Id];
        Map<Id, SObject> objectsForMerge = new Map<Id, SObject>{
                                                                    coreObj.Id => coreObj
                                                                    ,prospectObj.Id => prospectObj
                                                                    ,ebColCoreObj.Id => ebColCoreObj
                                                                    ,ebColProspectObj.Id => ebColProspectObj 
                                                               };

        LoanArchive.MergeResult result = sut.mergeObjects(prospectObj.Id, coreObj.Id, objectsForMerge);

        EB_Collateral__c saveRecord = (EB_Collateral__c)result.saveRecords[0];
        EB_Collateral__c deleteRecord = (EB_Collateral__c)result.deleteRecords[0];
        System.assertEquals(1, result.saveRecords.size());
        System.assertEquals(1, result.deleteRecords.size());
        System.assertEquals(ebColProspectObj.Id , saveRecord.Id);
        System.assertEquals('1234' , saveRecord.Key__c);
        System.assertEquals(ebColCoreObj.Id , deleteRecord.Id);
    }

    @IsTest
    static void  it_should_build_a_merge_result_from_prospect_and_return_null_when_there_is_no_matching_merge_obj () {
        Id prospectId = ObjectFactory.getFakeId(LLC_BI__Collateral__c.SObjectType, '1');
        Id coreId = ObjectFactory.getFakeId(LLC_BI__Collateral__c.SObjectType, '2');

        LoanArchive.MergeResult result = sut.mergeObjects(prospectId, coreId, new Map<Id, SObject>());

        System.assertEquals(null, result);
    }
}