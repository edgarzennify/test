@IsTest
private class TmBoardingVmBuilderHelperTests {
	
    private static TmBoardingVmBuilderHelper sut;
    private static final TmBoardingMock.ofIPermission mockPermission;
    private static final Mock.ofIUtility mockUtil;
    
    static {
        mockPermission = new TmBoardingMock.ofIPermission();
        mockUtil = new Mock.ofIUtility();
        sut = new TmBoardingVmBuilderHelper(mockPermission, mockUtil);
    }
    
    @IsTest
    static void it_should_build_a_entity_layout_component() {
        String entityName = 'test-entity';
        TmBoarding.RequestPm pm = new TmBoarding.RequestPm();
        pm.entityPm = new Account(Name = entityName);
        
        TmBoarding.LayoutComponent result = sut.getEntity(pm);
        
        System.assertEquals(entityName, result.name);
    }
    
    @IsTest
    static void it_should_build_stages() {
        Id requestId = ObjectFactory.getFakeId(TM_Service_Request__c.SObjectType, '1');
        TM_Service_Request__c record = new TM_Service_Request__c(Id = requestId);
        DmTmRequestStage stageDm = new DmTmRequestStage();
        stageDm.name = 'New';
        stageDm.relatedStages = new List<DmTmRequestStage>{new DmTmRequestStage()};
        
        TmBoarding.LayoutComponentStage result = sut.buildStages(record, stageDm);
        
        System.assertEquals('New' , result.Name);
    }

    @IsTest
    static void it_should_get_permissions() {
        String stageName = 'New';
        DmTmRequestStage stageDm = new DmTmRequestStage();
        stageDm.name = stageName;

        TmBoarding.LayoutComponentPermission result = sut.getPermission(stageDm);

        mockPermission.verify('getPermissionByRequestStage', new List<Object>{stageDm});
    }

    @IsTest
    static void it_should_get_packet() {
        String requestId = ObjectFactory.getFakeId(TM_Service_Request__c.SObjectType, '1');
        String stageId = ObjectFactory.getFakeId(TM_Service_Request_Stage__c.SObjectType, '1');       
        TM_Service_Request__c request = new TM_Service_Request__c(Id = requestId, Stage__c=stageId);
        TmBoarding.RequestPm pm = new TmBoarding.RequestPm();
        pm.packetRequestsPm = new List<TM_Service_Request__c>{request};
        List<DmRecordType> products = new List<DmRecordType>{new DmRecordType()};
        DmTmRequestStage stageDm = new DmTmRequestStage();
        stageDm.id = stageId;
        List<DmTmRequestStage> stageDms = new List<DmTmRequestStage>();
        Map<String, TmConfiguration.ProductInfo> productInfos = new Map<String, TmConfiguration.ProductInfo>();

        TmBoarding.LayoutComponent2 result =  sut.getPacket(pm, products, productInfos, stageDms);

        mockUtil.verify('convertid15ToId18', new List<Object>{stageId}, Times.Once);
    }
}