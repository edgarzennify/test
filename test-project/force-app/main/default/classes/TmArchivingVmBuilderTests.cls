@IsTest
private class TmArchivingVmBuilderTests {
    
    private static final TmArchivingVmBuilder sut;

    static {
        sut = new TmArchivingVmBuilder();
    }

    private static testMethod void it_should_build_archive_vm_when_dm_is_provided() {
        DateTime createdDateTime = DateTime.newInstance(2011,3,2,1,2,4);
        DmTmArchive dm = new DmTmArchive();
        dm.TreasuryService = new DmTreasuryService();
        dm.TreasuryService.id = 'test-tm-service-id';
        dm.TreasuryService.name = 'test-tm-service-name';
        dm.TreasuryService.product = 'tm-service-product';
        dm.TreasuryService.recordtype = new DmRecordtype();
        dm.TreasuryService.recordtype.id = '123';
        dm.TreasuryService.recordType.name = 'abc';
        dm.TmRequest = new DmTmRequest();
        dm.TmRequest.id = 'test-tm-request-id';
        dm.TmRequest.name = 'test-tm-request-name';
        dm.createdBy = new DmUser();
        dm.createdBy.id = 'test-user-id';
        dm.createdBy.name = 'test-user';
        dm.createdDate = createdDateTime;
        
        List<DmTmArchive> dms = new List<DmTmArchive>{dm};

        List<TmArchiving.ArchiveLayout> result =  sut.build(dms);

        System.assertEquals('test-tm-service-name' ,result[0].TMService.label);
        System.assertEquals('test-tm-service-id' ,result[0].TMService.value);
        System.assertEquals('test-tm-request-name' ,result[0].TMRequest.label);
        System.assertEquals('test-tm-request-id' ,result[0].TMRequest.value);
        System.assertEquals('test-user' ,result[0].CreatedBy.label);
        System.assertEquals('test-user-id' ,result[0].CreatedBy.value);
        System.assertEquals(createdDateTime ,result[0].CreatedDate);
        System.assertEquals( string.format('{0} ({1})', new List<string>{'abc', 'tm-service-product'}) ,result[0].Description);
    }

}