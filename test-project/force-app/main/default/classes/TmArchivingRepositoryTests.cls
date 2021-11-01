@IsTest
private class TmArchivingRepositoryTests {
    
    private static final TmArchivingMock.ofIDataProvider mockDataProvider;
    private static TmArchivingRepository sut;

    static {
        mockDataProvider = new TmArchivingMock.ofIDataProvider();
        sut = new TmArchivingRepository(mockDataProvider);
    }

    @IsTest
    static void it_should_build_adm_industry_code_when_industry_code_is_provided() {
        String industryCode = 'test-id';
        String name = 'test-code';
        String code = '123'; 
        String gp = '2';
        EB_Industry_Code__c pm = new EB_Industry_Code__c();
        pm.name = name;
        pm.industry_code__c = code;
        pm.industry_group__c = gp;

        mockDataProvider.setup('getIndustryIdFromCode', new List<Object>{industryCode}).returns(pm);

        DmIndustryCode result = sut.getIndustryIdFromCode(industryCode);

        System.assertEquals(null, result.id);
        System.assertEquals(name, result.name);
        System.assertEquals(code, result.code);
        System.assertEquals(gp, result.industryGroup);
    }

    @IsTest
    static void it_should_get_call_the_dataprovider_to_get_archive_pms() {     
        String tmRequestId = 'test-id';
        Id archiveId = ObjectFactory.getFakeId(Tm_Service_Request_Archive__c.SOBjectType, '1');
        Tm_Service_Request_Archive__c pm = new Tm_Service_Request_Archive__c(Id=archiveId );
        List<Tm_Service_Request_Archive__c> pms = new List<Tm_Service_Request_Archive__c>{pm};
        mockDataProvider.setup('getArchives', new List<Object>{tmRequestId}).returns(pms);

        List<DmTmArchive> result = sut.getArchives(tmRequestId);

        mockDataProvider.verify('getArchives', new List<Object>{tmRequestId}, Times.Once);
        System.assertEquals(1, result.size());
        System.assertEquals(null, result[0].createddate);
    }
}