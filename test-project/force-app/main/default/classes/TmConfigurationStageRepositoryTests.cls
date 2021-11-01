@IsTest
private class TmConfigurationStageRepositoryTests {

    private static TmConfigurationStageRepository sut;
    private static final TmBoardingMock.ofIDataProvider mockDataProvider;
    
    static {
        mockDataProvider  = new TmBoardingMock.ofIDataProvider();
        sut = new TmConfigurationStageRepository(mockDataProvider);
    }
    
    @IsTest
    static void it_should_get_stage_details_when_requestId_is_provided() {
        String stageID = 'stage-id';
        String requestId = 'request-id';
        Tm_Service_Request_Stage__c stage = new Tm_Service_Request_Stage__c(Name = 'New');
        List<Tm_Service_Request_Stage_Relationships__c> related = new List<Tm_Service_Request_Stage_Relationships__c>();
        mockDataProvider.setup('getStageForRequest', new List<OBject>{requestId}).returns(stage);
        mockDataProvider.setup('getValidStages', new List<Object>{stage}).returns(related);
        
        DmTmRequestStage result =  sut.getStageDetail(requestId);
        
        System.assertEquals(stage.name , result.Name);
        System.assertEquals(stage.id , result.id);
    }
    
    @IsTest
    static void it_should_use_the_default_stage_as_parent() {
        String autoForwardStage = 'auto-forward-stage';
        Id autoStageId = Objectfactory.getFakeId(Tm_Service_Request_Stage__c.SObjectType, '1');
        Tm_Service_Request_Stage__c stagePm = new Tm_Service_REquest_Stage__c();

        stagePm.Name = 'New';
        stagePm.Permission__c = 'test-permission';
        stagePm.Type__c = 'type-test';

        stagePm.Auto_Forward_Stage__r = new Tm_Service_Request_Stage__c(Id = autoStageId, Name='auto-forward-stage');
        mockDataProvider.setup('getDefaultStage').returns(stagePm);
        
        DmTmRequestStage result = sut.getDefaultStage();
        
        System.assertEquals(result.name , stagePm.Name);
        System.assertEquals(result.permission , stagePm.Permission__c);
        System.assertEquals(result.type , stagePm.Type__c);
        System.assertEquals(autoStageId , stagePm.Auto_Forward_Stage__r.Id);
        System.assertEquals(autoForwardStage , stagePm.Auto_Forward_Stage__r.Name);
    }

    @IsTest
    static void it_should_get_all_stages() {
        String stageName = 'test-name';
        Tm_Service_Request_Stage__c stg1 = new Tm_Service_Request_Stage__c();
        stg1.name = stageName;

        mockDataProvider.setup('getAllStages').returns(new List<Tm_Service_Request_Stage__c>{stg1});

        List<DmTmRequestStage> result = sut.getAllStages();

        mockDataProvider.verify('getAllStages', Times.Once);
        System.assertEquals(1 , result.size());
        System.assertEquals(stageName , result[0].name);
    }
}